NicoAPI = require '../src'

nico = new NicoAPI

nico.live.get()
.then (res)->
  console.log 'list', res
.catch (e)->
  throw e
