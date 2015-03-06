
debug           = require('debug')('nicoapi:message_socket')
_               = require 'underscore'
{EventEmitter2} = require 'eventemitter2'
{Socket}        = require 'net'
{parseXml}      = require './util'
{Promise}       = require 'es6-promise'

class MessageSocket extends EventEmitter2

  connect: (ms)->
    @socket.connect ms.port, ms.addr, =>
      debug 'connect'
      @write '<thread thread="' + ms.thread + '" version="20061206" res_from="-50"/>'
    return @
  
  write: (data)->
    debug 'write', data
    @socket.write data + '\0'
  
  constructor: (options)->
    new MessageSocket(options) unless @ instanceof MessageSocket
    super
    
    @socket = new Socket
    @socket.setEncoding 'utf-8'

    for e in ['lookup', 'connect', 'end', 'timeout', 'drain', 'error', 'close']
      @socket.on e, (args...)=>
        args.shift e
        @emit.apply null, args

    buf = ""
    xmlReg = /<(".*?"|'.*?'|[^'"])*?(\/>|>(.+?)<\/(".*?"|'.*?'|[^'"])*?>)/g    
    @socket.on 'data', (data)=>
      buf += data
      return unless data.slice(-1) is '\0'
      
      xml = buf.match(xmlReg)
      debug 'on data: matchs xml', xml
      return unless xml
      
      Promise.all xml.map((xml)-> parseXml(xml))
      .then (res)=>
        @emit 'data', res.map (data)->
          return data.thread.$ if data.thread
          
          if chat = data.chat
            res = chat.$
            res.body = chat._
            return res
      .catch (e)=>
        @emit 'error', e
      buf = ""

module.exports = exports = MessageSocket
