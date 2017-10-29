'use strict'
/* global self */

const $dragoverPopup = document.querySelector('.dragover-popup')
const $body = document.querySelector('body')


// var cryptojs = require('crypto-js')

require('../index.html')

var Elm = require('../elm/App.elm')
var mountNode = document.getElementById('main')
var app = Elm.Main.embed(mountNode)

const streamBuffers = require('stream-buffers')
const Ipfs = require('ipfs')
const Room = require('ipfs-pubsub-room')

let node
let peerInfo


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


function start () {
  if (!node) {
    console.log('node starts');
    updateView('starting', node)

    node = new Ipfs({repo: 'ipfs-' + 0.6732527245947162, //Math.random(),
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
        peerInfo = id
        updateView('ready', node)
        // const room = Room(node, "ipfs-cloud")
        // setInterval(refreshPeerList, 1000)
      })
    })
  }
}

function createFileBlob (data, multihash) {
  const file = new window.Blob(data, {type: 'application/octet-binary'})
  const fileUrl = window.URL.createObjectURL(file)
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
            case '4F676753':
                return 'audio/ogg'
            default:
                return 'Unknown filetype'
        }
      }

  var blob = file.slice(0,4)

  var fileReader = new window.FileReader();
  console.log("test");
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

    var answer = [{"maddr": multihash, "mime": mime}] //listItem
    console.log(answer);
    app.ports.ipfs_answer.send(answer)

}
fileReader.readAsArrayBuffer(blob);

}

function getFile (multihash) {
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
          createFileBlob(buf, multihash)
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

  filesArray.map((file) => {
    readFileContents(file)
      .then((buffer) => {
        let fileSize = buffer.byteLength

        if (fileSize < 50000000) {
          console.log('upload from buffer');
          return node.files.add([{
            path: file.name,
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
              path: file.name,
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
            }, 5000)


          })

        }

      })
      .then((files) => {
        if (files && files.length) {
          var a = files[0].hash
          console.log('added ' + a)

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
    const addressesHtml = peerInfo.addresses.map((address) => {
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

app.ports.ipfs_get.subscribe(
  function myfunction( bla) {
    var multihashstr = bla
    console.log("port: " + multihashstr)
    getFile(multihashstr)
  }
)

// app.ports.ipfs_add.subscribe(
//   function ofd (bla){
//   $('input[type="file"]').click();
//   }
// )
