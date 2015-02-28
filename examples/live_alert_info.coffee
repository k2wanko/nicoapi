
NicoAPI = require '../src'

nico = new NicoAPI

nico.live.alert.info.get()
.then (res)->
  console.log 'live', res
.catch (err)->
  throw err
