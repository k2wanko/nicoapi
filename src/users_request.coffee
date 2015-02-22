
Request = require './request'
{GET, POST} = Request.Method

{parseXml} = require './util'

class UsersRequest extends Request
  login: new class extends Request
    uri: "https://secure.nicovideo.jp/secure/login?site=:site"
    method: POST
    params:
      site: "niconico"
    resolveWithFullResponse: true
    simple: false
    parse: (res)->
      if @params.site is 'nicolive_antenna'
        return parseXml(res.body)
        .then (data)->
          data = data.nicovideo_user_response
          if error = res.error?[0]
            throw new Error error.description[0]
          {ticket: data.ticket[0]}
            
      session = null
      for cookies in res.headers['set-cookie']
        for cookie in cookies.split '; '
          c = cookie.split '='
          key = c[0]
          val = c[1]
          continue if key isnt 'user_session'
          if val.match /^user_session_/
            session = val
            break

      throw new Error("Login failure") unless session      
      {user_session: session}


module.exports = exports = new UsersRequest
