colors = require 'colors'

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
    data.map (data)->
      return unless body = data.body
      id = data.user_id
      
      console.log (id + ([0...(27-id.length)].map(-> " ").join("")))[if data.premium is "3" then 'red' else 'blue'],
      (if data.premium is "1" then 'P'.yellow else " "),
      body

  socket.on 'error', (e)->
    console.log 'error', e
.catch (e)->
  throw e
