
NicoAPI = require '../src'

nico = new NicoAPI

{MAIL, PASSWORD} = process.env

nico.users.login.post
  mail_tel: MAIL # mail_tel or mail
  password: PASSWORD
  site:     'nicolive_antenna'
.then (res)->
  nico.live.alert.status.post res
.then (res)->
  console.log 'live', res
.catch (err)->
  throw err
