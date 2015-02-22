
Request = require './request'
{GET, POST} = Request.Method

_ = require 'underscore'
{parseXml} = require './util'

alertParse = (res)->
  parseXml res
  .then (res)->
    res = res.getalertstatus
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
  alert: new class extends Request
    status: new class extends Request
      uri: "http://live.nicovideo.jp/api/getalertstatus"
      method: POST
      parse: alertParse

    info: new class extends Request
      uri: "http://live.nicovideo.jp/api/getalertinfo"
      method: GET
      parse: alertParse

module.exports = exports = new LiveRequest
