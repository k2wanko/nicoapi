

NicoAPI = require '../src'

nico = new NicoAPI()

{MAIL, PASSWORD, ID} = process.env

nico.users.login
  mail_tel: MAIL # mail_tel or mail
  password: PASSWORD
.then -> nico.video.flv(id: ID)
.then (res)->
  console.log 'flv', res
.catch (err)->
  throw err
