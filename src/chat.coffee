
_ = require 'underscore'

class Chat

  UserStatus =
    Premium: "1"
    Alert:   "2"
    Owner:   "3"
    Admin:   "6"
  
  constructor: (chat)->
    return new Chat(chat) unless @ instanceof Chat
    _.extend @, chat.$
    @body = chat._

  isOwner: ->
    @premium is UserStatus.Owner

  isPremium: ->
    @premium is UserStatus.Premium

  isAlert: ->
    @premium is UserStatus.Alert

module.exports = exports = Chat
