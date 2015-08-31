
Request = require './request'
{GET, POST} = Request.Method

_ = require 'underscore'
{parseXml} = require './util'

liveParse = (res)->
  parseXml res
  .then (res)->
    res = res.getalertstatus or res.getplayerstatus
    if error = res.error?[0]
      throw new Error error.description
    data = {}
    format = (res)->
      for key, val of res
        if key is 'communities'
          @[key] = val[0].community_id
          continue
        if _.isObject val[0]
          @[key] = {}
          format.call @[key], val[0]
          continue
        @[key] = val[0]
    format.call data, res
    delete data['$']
    data

class LiveRequest extends Request

  uri: "http://api.ce.nicovideo.jp/liveapi/v1/video.onairlist?__format=json"
  method: GET
  parmas:
    from: 0
    limit: 50
    order: 'a' # d,a
    pt: '' # official, channel, community
    sort: 'start_time' # start_time, view_counter, comment_num
  parse: (res)->
    JSON.parse(res).nicolive_video_response
  
  info: new class extends Request
    uri: "http://live.nicovideo.jp/api/getplayerstatus?v=:id"
    method: GET
    cookies:
      user_session: null
    parse: liveParse
  
  alert: new class extends Request
    status: new class extends Request
      uri: "http://live.nicovideo.jp/api/getalertstatus"
      method: POST
      parse: liveParse

    info: new class extends Request
      uri: "http://live.nicovideo.jp/api/getalertinfo"
      method: GET
      parse: liveParse

  postkey: new class Request
    uri: "http://live.nicovideo.jp/api/getpostkey?thread=:thread&block_no=:block"
    params:
      thread: 0
      block: 0
    parse: (res)->
      console.log res
      res

module.exports = exports = new LiveRequest
