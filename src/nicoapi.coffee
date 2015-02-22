
class NicoAPI

  users: require './users_request'
  video: require './video_request'
  live:  require './live_request'

  constructor: (options)->
    return new NicoAPI(options) unless @ instanceof NicoAPI

module.exports = exports = NicoAPI
