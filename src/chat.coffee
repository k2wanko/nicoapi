
_ = require 'underscore'

class Chat
  constructor: (chat)->
    return new Chat(chat) unless @ instanceof Chat
    _.extend @, chat.$
    @body = chat._
    

module.exports = exports = Chat
