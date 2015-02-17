
NicoAPI = require '../src'

nico = new NicoAPI

{ID} = process.env

nico.video.get id: ID
.then (info)->
  console.log "info", info
.catch (err)->
  throw err




