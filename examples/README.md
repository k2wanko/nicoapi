# Nico API examples

## get info

```
$ ID="1397552685" coffee ./video_info.coffee
```

## get flv

```
$ ID="1397552685" MAIL="..." PASSWORD="..." coffee ./video_flv.coffee
```

## get live list

```
$ coffee ./live_list.coffee
```

## get live info

```
$ ID="..." MAIL="..." PASSWORD="..." coffee ./live_info.coffee
```

## Live comment

```
$ DEBUG="*" ID="..." MAIL="..." PASSWORD="..." coffee ./live_comment.coffee
```

## auth nicolive alert

```
$ MAIL="..." PASSWORD="..." coffee ./live_auth.coffee
```

## no auth nicolive alert info

```
$ coffee ./live_alert_info.coffee
```
