
NicoAPI = require '../src'

nico = new NicoAPI

{MAIL, PASSWORD} = process.env

nico.users.login.post
  mail_tel: MAIL # mail_tel or mail
  password: PASSWORD
  site:     'nicolive_antenna'
.then (res)->
  console.log 'res', res
.catch (err)->
  throw err
