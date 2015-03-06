NicoAPI = require '../src'

nico = new NicoAPI

{Socket} = require 'net'

{ID, MAIL, PASSWORD} = process.env

nico.users.login.post
  mail_tel: MAIL # mail_tel or mail
  password: PASSWORD
.then (res)->
  res.id = ID
  nico.live.info.get res
.then (res)->
  socket = new NicoAPI.MessageSocket
  socket.connect res.ms
  socket.on 'data', (data)->
    console.log 'data', data
  socket.on 'error', (e)->
    console.log 'error', e
.catch (e)->
  throw e
