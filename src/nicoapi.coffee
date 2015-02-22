
_             = require 'underscore'
request       = require 'request-promise'
{Promise}     = require 'es6-promise'
{parseString} = require 'xml2js'
pathRegexp    = require 'path-to-regexp'

parseXml = (xml)->
  new Promise (resolve, reject)->
    parseString xml, (err, json)->
      return reject(err) if err
      resolve(json)

parseUriParams = (params)->
  data = {}
  params = params.split '&'
  for item in params
    item = item.split '='
    key = item[0]
    val = item[1]
    data[key] = decodeURIComponent val
    
  data

class NicoAPI

  VERSION = "20090904"
  
  GET  = 'get'
  POST = 'post'
  
  Resource =
    users:
      resource:
        login:
          uri: "https://secure.nicovideo.jp/secure/login?site=:site"
          params:
            site: "niconico"
          method: POST
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
    video:
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
          
      resource:
        flv:
          uri: "http://flapi.nicovideo.jp/api/getflv/:id"
          method: GET
          parse: (res)->
            data = parseUriParams res
            if error = data['error']
              throw new Error(error)
            data.ms_id =  data.ms.match(/// [0-9]+ ///)[0]
            data            

        # alpha
        messages:
          uri: "http://msg.nicovideo.jp/:ms_id/api.json/thread?version=#{VERSION}&thread=:thread_id&res_from=:res_from"
          method: GET
          params:
            res_from: -100
          parse: (res)->
            data = {}
            for item in JSON.parse res
              for item in _.pairs item
                key = item[0]
                val = item[1]
                
                unless data[key]
                  data[key] = val
                  continue
                
                unless _.isArray data[key]
                  vals = [data[key]]
                  data[key] = vals
                  
                data[key].push val

            data

    live:
      resource:
        alert:
          resource:
            status:
              uri: "http://live.nicovideo.jp/api/getalertstatus"
              method: POST
              parse: (res)->
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

            info:
              uri: "http://live.nicovideo.jp/api/getalertinfo"
              method: GET
              parse: (res)->
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

  getResource: -> Resource

  itself = null
  constructor: (options)->
    return new NicoAPI(options) unless @ instanceof NicoAPI

    @jar = request.jar()

    itself = @

    build = (resource)->
      for key, val of resource
        child = resource[key]['resource'] or null
        delete resource[key]['resource'] if child
        method = val.method
        @[key] = {}
        if method
          @[key][method] = buildRequest.call(@, val)
        build.call(@[key], child) if child
        
    build.call(@, Resource)

  parseUri = (uri, params)->

    re = pathRegexp uri, params
    uri = uri
    re.keys.map (key)->
      val = params[key.name]
      delete params[key]
      uri = uri.replace /// :#{key.name} ///, val
      
    uri

  buildRequest = (options)->

    return {} unless options.uri
    options.method = GET unless options.method
    
    (params)->
      @params = _.clone(params = _.defaults(params, options.params or {}))
      @method = options.method

      options.uri = parseUri options.uri, params
      
      parse = if options.parse then options.parse else (res)-> res
      delete options['parse']

      options.form = _.defaults (options.form or {}), params if _.keys(params).length

      options.jar = itself.jar
      
      request[@method] options
      .then parse.bind @

module.exports = exports = NicoAPI
