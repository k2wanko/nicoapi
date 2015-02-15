
# Nico API

Nico API is Nicovideo API Client


## Install

```
$ npm install --save nicoapi
```

## Usage

```js
var NicoAPI = require('nicoapi');

var nico = new NicoAPI();

nico.video({id: 'sm...'})
.then(function(info){
  console.dir(info);
})
['catch'](function(err){ throw err;});

```

## APIs

### Users

#### login - Login the Niconico.

`nico.users.login(options)`

|Parameters                     |||
|:-----------|:---------|:--------|
| string     | mail_tel | user email or phone number|
| string     | password | user password|

### Video

#### getthumbinfo - Get video information.

`nico.video(options)`

|Parameters               |||
|:-----------|:---|:--------|
| string     | id | video id|

#### getflv - Get video path. (e.g. mp4)

`nico.video.flv(options)`

request `user_session`

|Parameters                                   |||
|:-----------|:-----------------------|:--------|
| string     | id                     | video id|
| string     | user\_session (optional)| if have login is optional. (Unimplemented) |

#### messages - Get video comment. (geting user video only)

`nico.video.messages(options)`

|Parameters                      |||
|:-----------|:----------|:--------|
| string     | ms\_id     | Meesage Server id|
| string     | thread\_id | Thread id|
| number     | res\_from  | back number (default: -100) |


# License

[MIT](http://k2wanko.mit-license.org/)
