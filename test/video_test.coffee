assert = require 'power-assert'

NicoAPI = require '../'

VIDEO_ID = "1397552685"

describe "video", ->

  it "getthumbinfo - Get video information.", (done)->
    nico = new NicoAPI()
    nico.video.get id: VIDEO_ID
    .then (info)->
      assert info.video_id
      done()
    .catch done
