
{Promise}     = require 'es6-promise'
{parseString} = require 'xml2js'
pathRegexp    = require 'path-to-regexp'

parseXml = exports.parseXml = (xml)->
  new Promise (resolve, reject)->
    parseString xml, (err, json)->
      return reject(err) if err
      resolve(json)

parseUriParams = exports.parseUriParams = (params)->
  data = {}
  params = params.split '&'
  for item in params
    item = item.split '='
    key = item[0]
    val = item[1]
    data[key] = decodeURIComponent val
    
  data

parseUri = exports.parseUri = (uri, params)->
  re = pathRegexp uri, params
  re.keys.map (key)->
    val = params[key.name]
    delete params[key.name]
    uri = uri.replace /// :#{key.name} ///, val
  uri


module.exports = exports
