assert = require 'power-assert'

NicoAPI = require '../'

describe "live", ->

  it "getalertinfo  - No auth get alert status", (done)->
    nico = new NicoAPI
    nico.live.alert.info.get()
    .then (res)->
      assert(res.user_id is 'Anonymous')
      done()
    .catch done
