'use strict'
/* global self */

const $dragoverPopup = document.querySelector('.dragover-popup')

const $body = document.querySelector('body')

//const connectPeer = ""

var cryptojs = require('crypto-js')

//var webcomponents = require('src/web-components/')
require('../index.html')


var Elm = require('../elm/main.elm')
var mountNode = document.getElementById('main')
var app = Elm.Main.embed(mountNode)



const streamBuffers = require('stream-buffers')
const Ipfs = require('ipfs')
const Room = require('ipfs-pubsub-room')

let node
let peerInfo

// var account = {"devices": [
//   {"device1name": { "key": "key",
//                     "peerId": "peerId",
//                     "repohash": "repohash",
//                     "repokey": "repokey"},
//
//   {"device1name": { "key": "key",
//                     "peerId": "peerId",
//                     "repohash": "repohash",
//                     "repokey": "repokey"},
//   "last_edit": "edit time"
// }


//!!! send all via pubkey cryptography
function newacc () {
  //prompt elm devicname, password, ->make key from password
  // generate repo and save peer id
  //save repo-files
}

function add_dev (peerId) {
  //send encrypted account file to peerId
  //prompt password on peer -> decrypt account file
  //return new account file(encrypted)

}
function update_acc () {
  //sends update to all devices
}


/*
 * Start and stop the IPFS node
 */

function start () {
  if (!node) {
    console.log('node starts');
    updateView('starting', node)



    node = new Ipfs({repo: 'ipfs-' + Math.random(),
                    EXPERIMENTAL: {
                      pubsub: true
                    }})

    node.on('start', () => {
      node.id().then((id) => {
        peerInfo = id
        updateView('ready', node)
        setInterval(refreshPeerList, 1000)
      })
    })
  }
}

function stop () {
  console.log('node stops');
  window.location.href = window.location.href // refresh page

}

/*
 * Fetch files and display them to the user
 */

function createFileBlob (data, multihash) {
  const file = new window.Blob(data, {type: 'application/octet-binary'})
  const fileUrl = window.URL.createObjectURL(file)

  const listItem = document.createElement('div')
  const link = document.createElement('a')
  link.setAttribute('href', fileUrl)
  link.setAttribute('download', multihash)
  const date = (new Date()).toLocaleTimeString()

  listItem.appendChild(link)
  return listItem
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
          const listItem = createFileBlob(buf, multihash)

        })

        file.content.resume()
      }
    })
    filesStream.resume()

    filesStream.on('end', () => console.log('Every file was fetched for', multihash))
  })
}

/*
 * Drag and drop
 */
function onDrop (event) {
  onDragExit()
  event.preventDefault()
  console.log('ondrop')
  if (!node) {
    onError('IPFS must be started before files can be added')
    return
  }
  const dt = event.dataTransfer
  const files = dt.files

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
        }
      })
      .catch(onError)
  })

}

/*
 * Network related functions
 */

//Get peers from IPFS and display them

function connectToPeer (targetPeer) {
  //event.target.disabled = true
  node.swarm.connect(targetPeer, (err) => {
    if (err) {
      return onError(err)
    }

    // setTimeout(() => {
    //   event.target.disabled = false
    // }, 500)
  })
}

function refreshPeerList () {
  node.swarm.peers((err, peers) => {
    if (err) {
      return onError(err)
    }
    const peersAsHtml = peers
      .map((peer) => {
        if (peer.addr) {
          const addr = peer.addr.toString()
          if (addr.indexOf('ipfs') >= 0) {
            return addr
          } else {
            return addr + peer.peer.id.toB58String()
          }
        }
      })
      .map((addr) => {
        return '<li>' + addr + '</li>'
      }).join('')


  })
}

/*
 * UI functions
 */

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
  //$dragoverPopup.style.display = 'block'
}

function onDragExit () {
  //$dragoverPopup.style.display = 'none'
}

/*
 * App states
 */
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

  // TODO should work to hide the dragover-popup but doesn't...
  $body.addEventListener('dragleave', onDragExit)

  start()

}

//startApplication()

var acpsw = " 1"

app.ports.acc_submit.subscribe(
  function myfunction(acc_psw) {
    var acpsw = " 1"
    acpsw = acc_psw
    console.log(acpsw)
  }
)
