'use strict'
/* global self */

require('../index.html')

const $dragoverPopup = document.querySelector('.dragover-popup')
const $body = document.querySelector('body')

var Elm = require('../elm/App.elm')
var mountNode = document.getElementById('main')
var app = Elm.Main.embed(mountNode)


const jsqr = require('jsqr')
const streamBuffers = require('stream-buffers')
// const Room = require('ipfs-pubsub-room')
const Ipfs = require('ipfs')
const Orbit = require('orbit-db')

let node
let peerId
let room

let devices
devices = {peerId: ["pins"]}
// let db
let ev

const repo_seed =  0.6732527245947163

let last_change = 0

let first_start
first_start = true


// multisig for adding devices:
//   -every device is a key
//   -user has a password(1key)
//   -maybe other keys (third party, backup, etc)
//
// adding -> 2 keys:
//   -> temporary add device window
//
//   qr-code gives hash of device key
//   + enter password on (to be added) device
//   device is added (db-entry via other device)

//or like in private ipfs: qr code transmits swarm key

// -- feature : text clipboard

// var account =
//   {'time': 0,
//    'devices': {}
//   }
//
//
// //!!! send all via pubkey cryptography
//
// //use ipns for pinlist
// function add_dev (peerId, dev_name) {
//   if( dev_name in account['devices'] )
//     { console.log('device already exists')
//       return -1}
//
//   account['time'] = Date.now()
//   account['devices'][dev_name] = peerId
//   // account['devices']['device_name'] = dev_name
//
//   //send encrypted account file to peerId
//   //prompt password on peer -> decrypt account file
//   //return new account file(encrypted)
//
// }
// function update_acc (update, sender) {
//   if (update['time'] > account['time'])
//     account = update
//
// }

// function add_dev (password, devicename, peerid) {
//   if (account['devices'].indexOf(devicename) != -1)
//     { console.log('device:' + devicename + 'already exists')
//       return }
//   account['devices'][account['devices'].length + 1] = {devicename: peerid}
//
//   //send encrypted account file to peerId
//   //prompt password on peer -> decrypt account file
//   //return new account file(encrypted)
// }

// room = Room(node, "ipfs-cloud-room" + repo_seed)

function start () {
  if (!node) {
    console.log('node starts');
    updateView('starting', node)

    node = new Ipfs({repo: 'ipfs-cloud' + repo_seed, //Math.random(),
                    init: true,
                    EXPERIMENTAL: {
                      pubsub: true
                    }
                    // config: {
                    //   Addresses: {
                    //     Swarm: [
                    //       'ip4/127.0.0.1/tcp/1337'
                    //     ],
                    //     Bootstrap: {
                    //       'ip4/192.178.168.29/tcp...'
                    //     }
                    //
                    //    }
                    //  }
                  })

    node.on('start', () => {
      node.id().then((id) => {
        const orbitdb = new Orbit(node)
        // db = orbitdb.kvstore('pinlist')
        ev = orbitdb.eventlog('pinlist')
        peerId = id
        app.ports.ipfs_answer.send({answertype: "device_infos", value: JSON.stringify(peerId), hash: ""})
        updateView('ready', node)

        // setInterval(refreshPeerList, 1000)
      })
    })
  }
}



function createFileBlob (data, multihash, wanttype) {
  const file = new window.Blob(data, {type: 'application/octet-binary'})
  const fileUrl = window.URL.createObjectURL(file)
  console.log(fileUrl);
  console.log(wanttype);
  app.ports.ipfs_answer.send({answertype: wanttype, value: fileUrl, hash: multihash})
  var mime = "";
  const getMimetype = (signature) => {
        switch (signature) {
            case '89504E47':
                return 'image/png'
            case '47494638':
                return 'image/gif'
            case '25504446':
                return 'application/pdf'
            case 'FFD8FFDB':
            case 'FFD8FFE0':
                return 'image/jpeg'
            case '504B0304':
                return 'application/zip'
            case '00020':
                return 'video/mp4'
            case '4F676753':
                return 'audio/ogg'
            case '20202020':
                return 'inode/directory'
            default:
                return 'Unknown filetype'
        }
      }

  var blob = file.slice(0,4)

  var fileReader = new window.FileReader();
  fileReader.onloadend = function(e) {
    var header = "";
    var arr = (new Uint8Array(e.target.result)).subarray(0, 4);
    for(var i = 0; i < arr.length; i++) {
       header += arr[i].toString(16);
    }
    header = header.toUpperCase()

    console.log(header);
    console.log("port-send: " + getMimetype(header));

    mime = getMimetype(header)

    var answer = {"maddr": multihash, "mime": mime, "ispinned": true} //listItem
    console.log(answer);
    // app.ports.ipfs_asset.send(answer)
    // app.ports.ipfs_asset.send({answertype: "audio answer", value: fileUrl})

}
fileReader.readAsArrayBuffer(blob);

}

function getFile (multihash, wanttype) {
  //const multihash = ""

  if (!multihash) {
    return console.log('no multihash was inserted')
  }
  else {
    console.log('getting ' + multihash);
  }

  // files.get documentation
  // https://github.com/ipfs/interface-ipfs-core/tree/master/API/files#get
  node.files.get(multihash, (err, filesStream) => {
    if (err) {
      return onError(err)
    }

    filesStream.on('data', (file) => {
      if (file.content) {
        const buf = []
        // buffer up all the data in the file
        file.content.on('data', (data) => buf.push(data))
        file.content.once('end', () => {
          createFileBlob(buf, multihash, wanttype)
          // console.log(item);
        })
        file.content.resume()
      }
    })
    filesStream.resume()
    filesStream.on('end', () => console.log('Every file was fetched for', multihash))


  })

  // console.log(item);
}


/*
 * Drag and drop
 */
function onDrop (event) {
  onDragExit()
  event.preventDefault()
  console.log('ondrop')

  const dt = event.dataTransfer
  const files = dt.files

  upload(files)
}

function onUpbtn() {
  console.log("onupbtn")
  var files = this.files
  upload(files)
}

function upload (files){
  if (!node) {
    onError('IPFS must be started before files can be added')
    return
  }


  function readFileContents (file) {
    return new Promise((resolve) => {
      const reader = new window.FileReader()
      reader.onload = (event) => resolve(event.target.result)
      reader.readAsArrayBuffer(file)
    })
  }

  let filesArray = []
  for (let i = 0; i < files.length; i++) {
    filesArray.push(files[i])
  }
  var filecount = filesArray.length
  filesArray.map((file) => {
    readFileContents(file)
      .then((buffer) => {
        let fileSize = buffer.byteLength

        if (fileSize < 50000000) {
          console.log('upload from buffer');
          return node.files.add([{
            path: "/media/" + file.name,
            content: new node.types.Buffer(buffer)
          }])
        } else {

          console.log('use addstream');
          // use createAddStream and chunk the file.
          let progress = 0

          let myReadableStreamBuffer = new streamBuffers.ReadableStreamBuffer({
            // frequency: 10,   // in milliseconds.
            chunkSize: 32048  // in bytes.
          })

          node.files.createAddStream((err, stream) => {
            if (err) throw err

            stream.on('data', (file) => {

              if (progressbar) {
                clearInterval(progressbar)
                progress = 0
              }
            })

            myReadableStreamBuffer.on('data', (chunk) => {
              progress += chunk.byteLength
            })

            if (!myReadableStreamBuffer.destroy) {
              myReadableStreamBuffer.destroy = () => {}
            }

            stream.write({
              path: ('/media/' + file.name),
              content: myReadableStreamBuffer
            })

            myReadableStreamBuffer.put(Buffer.from(buffer))
            myReadableStreamBuffer.stop()

            myReadableStreamBuffer.on('end', () => {
              stream.end()
            })

            myReadableStreamBuffer.resume()

            // progress.
            let progressbar = setInterval(() => {
              console.log('progress: ', progress, '/', fileSize, ' = ', Math.floor((progress / fileSize) * 100), '%')
              app.ports.ipfs_answer.send({answertype: "upload progress", value: ( (progress/fileSize) * 100 ) })

            }, 5000)


          })

        }

      })
      .then((files) => {
        if (files && files.length) {
          var a = files[0].hash
          console.log('added ' + a)
          ev.add({pinned: true, peer: peerId, multihash:a})

          // node.pubsub.publish("ipfs-cloud", new Buffer('added' + a), (err) => {
          //   if (err){
          //     throw err
          //     }
          //   })

        }
      })
      .catch(onError)
  })

}

function add_dev (peer_id) {
  //event.target.disabled = true
  node.swarm.connect(peer_id, (err) => {
    if (err) {
      return onError(err)
    }

    // setTimeout(() => {
    //   event.target.disabled = false
    // }, 500)
  })
  // node.pubsub.subscribe("ipfs-cloud", (msg) => console.log(msg.from, msg.toString()))
}

// function refreshPeerList () {
//   node.swarm.peers((err, peers) => {
//     if (err) {
//       return onError(err)
//     }
//     const peersAsHtml = peers
//       .map((peer) => {
//         if (peer.addr) {
//           const addr = peer.addr.toString()
//           if (addr.indexOf('ipfs') >= 0) {
//             return addr
//           } else {
//             return addr + peer.peer.id.toB58String()
//           }
//         }
//       })
//       .map((addr) => {
//         return '<li>' + addr + '</li>'
//       }).join('')
//
//
//   })
// }

function onError (err) {
  let msg = 'An error occured, check the dev console'

  if (err.stack !== undefined) {
    msg = err.stack
  } else if (typeof err === 'string') {
    msg = err
  }

}

window.onerror = onError

function onDragEnter () {
  $dragoverPopup.style.display = 'block'
}

function onDragExit () {
  $dragoverPopup.style.display = 'none'
}

const states = {
  ready: () => {
    const addressesHtml = peerId.addresses.map((address) => {
      console.log(address);
      return '<li><span class="address">' + address + '</span></li>'
    }).join('')


  },
  starting: () => {
  }
}

function updateView (state, ipfs) {
  if (states[state] !== undefined) {
    states[state]()
  } else {
    throw new Error('Could not find state "' + state + '"')
  }
}

/*
 * Boot this application!
 */
const startApplication = () => {
  // Setup event listeners
  $body.addEventListener('dragenter', onDragEnter)
  $body.addEventListener('drop', onDrop)

  // var upbtn = document.getElementById('upbtn')
  // if (upbtn)
  //  {  console.log("shit finallly");
  //    $upbtn.addEventListener('change', onUpbtn, false) }


  // document.addEventListener()
  // TODO should work to hide the dragover-popup but doesn't...
  $body.addEventListener('dragleave', onDragExit)


  start()

}



startApplication()

var $upbtn = document.getElementById('upbtn')
$upbtn.addEventListener('change', onUpbtn)

// app.ports.ipfs_answer.send(answer)

//pin ls =>
// room.broadcast("pins")
//pin (msg)

app.ports.ipfs_cmd.subscribe(
  function handle_action(msg) {
    switch (msg['action']) {
      case "cat":
        console.log("port cat " + msg);
        getFile(msg['maddr'], msg['wanttype'])
        break;
      case "get":
        console.log("port get " + msg);
        break;
      case "add":
        console.log("port add" + msg);
        $upbtn.click();
        break;
      case "pin":
        console.log("port pin" + msg);
        // var newval = db.get(msg['maddr'])
        ev.add({pinned: true, peer: msg['wanttype'], multihash:msg['maddr']})

        // if (newval!=undefined){
        //   newval.push(msg['wanttype']) //or msg["pinner"]
        //   db.set(msg['maddr'], newval)
        //
        // }
        // else {
        //   db.put(msg['maddr'], [newval])
        // }
        // console.log(db.get(msg['maddr']));
        break;
      case "unpin":
        console.log("port unpin" + msg);
        ev.add({pinned: false, peer: msg['wanttype'], multihash:msg['maddr']})

        // var newval = db.get(msg['maddr'])
        // if (newval != undefined){
        //   newval.splice(
        //     newval.indexOf(msg['wanttype']),
        //     1
        //   )
        //   db.set(msg['maddr'], newval)
        //
        // }
        // console.log(db.get(msg['maddr']));
        break;
      case "pin_ls":
        console.log("port pin_ls" + msg);
        // ev.events.on('ready', () => {
        //   var items = ev.iterator().collect()
        //   items.forEach((e) => console.log(e.name))
        // })
        const evts = ev.iterator({ limit: 100 })
          .collect()
          .reverse()
          .map((e) => console.log(e.payload.value)) //e.payload.value)

        break;
      case "dag_get":
        console.log("port dag_get " + msg['maddr']);
        node.dag.get(msg['maddr'], function (err, val) {
          if(err != undefined)
          {throw new Error("dag get err")}
          else if (typeof err == 'string')
          {throw new Error('dag get err')}
          console.log(val);
          console.log((val['value']['data']));
          // getFile(msg['maddr'])

          // const cid = multibase.decode(version)
          // version = parseInt(cid.slice(0, 1).toString('hex'), 16)
          // codec = multicodec.getCodec(cid.slice(1))
          // multihash = multicodec.rmPrefix(cid.slice(1))

          // var codec = (val['value']['multihash']).slice(1))
          // var cid = new CID(val['value']['multihash'])
          // console.log(cid.codec);
          var answer = JSON.stringify(val['value'])
        app.ports.ipfs_answer.send({answertype: "dag answer url", value: answer, hash: msg['maddr']})
        })
        break;
      case "device_infos":
        console.log("port device_infos ");
        app.ports.ipfs_answer.send({answertype: "device_infos", value: devices, hash: "" })
        break;
      // default:

    }

    // var multihashstr = action
    // console.log("port get: " + multihashstr)
    // getFile(multihashstr)
  }
)



// app.ports.ipfs_pin_ls.subscribe(
//   function myfunction( bla) {
//     var multihashstr = bla
//     console.log("port pin ls: " + multihashstr)
//     getFile(multihashstr)
//   }
// )

// app.ports.ipfs_add.subscribe(
//   function ofd (bla){
//   $('input[type="file"]').click();
//   }
// )




//<12 20 e3 b0 c4 42 98 fc 1c 14 9a fb f4 c8 99 6f b9 24 27 ae 41 e4 64 9b 93 4c a4 95 99 1b 78 52 b8 55>
// node.object.get('QmS4ustL54uo8FzR9455qaxZwuMiUhyvMcX9Ba8nUH4uVv', function(err,val){
//   console.log(val['data'])
// })

//QmUDhFjiVkHaQUvsViPm6ueM4WuV9ZeRm9JVnGD13ec9zS
// dagpb.util.deserialize(val['value']['data'], function(err,v2){
//   console.log(v2);
// })

//
