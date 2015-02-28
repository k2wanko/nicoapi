
NicoAPI = require '../src'

nico = new NicoAPI

{ID, MAIL, PASSWORD} = process.env

nico.users.login.post
  mail_tel: MAIL # mail_tel or mail
  password: PASSWORD
.then (res)->
  res.id = ID
  nico.live.info.get res
.then (res)->
  console.log 'info', res
.catch (e)->
  throw e
