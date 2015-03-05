
# Nico API

Nico API is Nicovideo API Client

[![Build Status](https://travis-ci.org/k2wanko/nicoapi.svg)](https://travis-ci.org/k2wanko/nicoapi)

## Install

```
$ npm install --save nicoapi
```

## Usage

```js
var NicoAPI = require('nicoapi');

var nico = new NicoAPI();

nico.video.get({id: 'sm...'})
.then(function(info){
  console.dir(info);
})
['catch'](function(err){ throw err;});

```

## APIs

### Users

#### login - Login the Niconico.

`nico.users.login.post(options)`

|Parameters                     |||
|:-----------|:---------|:--------|
| string     | mail_tel | user email or phone number|
| string     | password | user password|
| string     | site     | login site \['niconico', 'nicolive\_antenna'\] (default: niconico)|

### Video

#### getthumbinfo - Get video information.

`nico.video.get(options)`

|Parameters               |||
|:-----------|:---|:--------|
| string     | id | video id|

#### getflv - Get video path. (e.g. mp4)

`nico.video.flv.get(options)`

request `user_session`

|Parameters                                   |||
|:-----------|:-----------------------|:--------|
| string     | id                     | video id|
| string     | user\_session (optional)| if have login is optional. (Unimplemented) |

#### messages - Get video comment. (geting user video only)

`nico.video.messages.get(options)`

|Parameters                      |||
|:-----------|:----------|:--------|
| string     | ms\_id     | Meesage Server id|
| string     | thread\_id | Thread id|
| number     | res\_from  | back number (default: -100) |

### Live/Alert

`nico.live.get`

|Parameters                      |||
|:-----------|:----------|:--------|
| number     | from      | start page|
| number     | limit     | get item count|
| string     | order     | d or a (default: a)|
| string     | pt        | pt is provider. official, channel, community (default: all) |
| string     | sort      | sort type. start\_time, view\_counter, comment\_num|

#### getplayerstatus - Get Live info

`nico.live.info.get`

request `user_session`

|Parameters                      |||
|:-----------|:----------|:--------|
| string     | id            | live id|
| string     | user\_session | session id|

#### getalertstatus - Get alert status

`nico.live.alert.status.post(options)`

|Parameters                      |||
|:-----------|:----------|:--------|
| string     | ticket    | ticket obtained in antenna login|

#### getalertinfo - No auth get alert status

`nico.live.alert.info.get()`

|Parameters                      |||
|:-----------|:----------|:--------|
| no                             |||

# License

[MIT](http://k2wanko.mit-license.org/)
