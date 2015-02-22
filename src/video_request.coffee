
Request = require './request'
{GET, POST} = Request.Method

{parseXml, parseUriParams} = require './util'

class VideoRequest extends Request
  uri: "http://ext.nicovideo.jp/api/getthumbinfo/:id"
  method: GET
  parse: (res)->
    parseXml(res)
    .then (res)->
      res = res.nicovideo_thumb_response
      if error = res.error?[0]
        throw new Error error.description[0]
      data = {}
      for key, val of res.thumb[0]
        if key is 'tags'
          data[key] = for tag in val[0].tag
            body: tag._
            category: tag.$?.category?
            lock: tag.$?.lock?
          continue
        data[key] = val[0]

      data

  flv: new class extends Request
    uri: "http://flapi.nicovideo.jp/api/getflv/:id"
    method: GET
    cookies:
      user_session: null
    parse: (res)->
      data = parseUriParams res
      if error = data['error']
        throw new Error(error)
      try
        data.ms_id =  data.ms.match(/// [0-9]+ ///)[0]
      catch e
        throw new Error "Session error"
      data            

  messages:
    uri: "http://msg.nicovideo.jp/:ms_id/api.json/thread"
    method: GET
    parmas:
      version: "20090904"

module.exports = exports = new VideoRequest
