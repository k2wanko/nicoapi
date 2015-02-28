
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

module.exports = exports = new LiveRequest
