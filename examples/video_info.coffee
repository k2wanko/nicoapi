
NicoAPI = require '../src'

nico = new NicoAPI

{ID} = process.env

nico.video(id: ID)
.then (info)->
  console.log "info", info
.catch (err)->
  throw err




