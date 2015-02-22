

NicoAPI = require '../src'

nico = new NicoAPI()

{MAIL, PASSWORD, ID} = process.env

nico.users.login.post
  mail_tel: MAIL # mail_tel or mail
  password: PASSWORD
.then (res)->
  console.log res
  res.id = ID
  nico.video.flv.get res
.then (res)->
  console.log 'flv', res
.catch (err)->
  throw err
