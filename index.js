window.remote = require('remote-calling-example')

window.failedMiserably = true
window.logs = []

function log (message) {
  window.logs.push(message)
  console.log(message)
}

window.addEventListener('example:fetched', function () {
  if (window.remote.error) {
    log('[EXAMPLE] Remote fetch failed')
    window.failedMiserably = true
  } else {
    log('[EXAMPLE] Remote fetch successful')
    log(`[EXAMPLE] BTC to ETH: ${window.remote.data.BTC_ETH.last}`)
  }
})

window.remote.fetch()
