
_ = require 'underscore'
{parseUri} = require './util'
request       = require 'request-promise'
{Promise}     = require 'es6-promise'

class Request

  @Method:
    GET:  'get'
    POST: 'post'

  {GET, POST} = @Method

  constructor: ->
    self = @
    req = {}
    req.__proto__ = @__proto__
    for key, val of @
      if val instanceof Request
        req[key] = val
    
    return req unless @uri
    
    @method = GET unless @method
    
    req[@method] = buildRequest(@)
    
    return req

  buildRequest = (options)->

    return {} unless options.uri
    options.method = GET unless options.method

    options = do ->
      opt = {}
      for k, v of options
        continue if k is 'constructor'
        opt[k] = v
      opt
    
    (params)->
      @params = _.clone(params = _.defaults(params, options.params or {}))
      @method = options.method

      options.uri = parseUri options.uri, params
      if options.cookies?
        options.jar = request.jar()
        cookies = {}
        for k, v of options.cookies
          if params[k]
            cookies[k] = params[k]
            delete params[k]
        delete options['cookies']
        for cookie in _.pairs(cookies).map(((c)-> "#{c[0]}=#{c[1]}"))
          cookie = request.cookie cookie
          cookie.domain   = "nicovideo.jp"
          cookie.hostOnly = false
          options.jar.setCookie cookie, "http://nicovideo.jp/"
      
      parse = if options.parse then options.parse else (res)-> res
      delete options['parse']

      options.form = _.defaults(params, (options.form or {})) if _.keys(params).length

      request[@method] options
      .then parse.bind @

    
module.exports = exports = Request
