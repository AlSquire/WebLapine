# WebLapine

[![Build Status](https://secure.travis-ci.org/AlSquire/WebLapine.png)](http://travis-ci.org/AlSquire/WebLapine)

A toy rails app, acting as a web front/backend for my personal IRC bot (the bot code is not included yet).

Its main purpose is to save all the links and images that have been posted on an IRC channel.

## Features

### Links
Record and list URIs it receives, by network and channel.

* When an image URI is recognized, request a copy of the image through another REST call (so it can be hosted elsewhere)
* Parse images URIs from 9gag or imgur
* Recognize Youtube URIs and embed the video
* Recognize NWS NMS tags, so you can't see boobs inadvertently, or worse
* Search & pagination
* RSS feed

#### Usage
* POST /:network/:channel/links create a record, params are `link[line]` and `link[sender]`
* GET  /:network/:channel/links HTML frontend.

#### Image copying
After recognizing an image URI, the app do a POST request to `MIRROR_SERVICE_URI` env variable with a `uri` param (the image to copy). The awaited answer is the URI for the hosted copy.

Example of php code for this matter, copying and renaming the file by date/time :

```php
    <?php
    $uri  = $_REQUEST['uri'];
    $file = date("His") . '-' . array_pop(explode('/', $uri));
    $dir  = date("y/m/d");
    $dest = "$dir/$file";

    if ((is_dir($dir) || mkdir($dir, 0777, true)) && copy($uri, $dest)) {
        echo "http://" . $_SERVER['HTTP_HOST'] . "/$dest";
    } else {
        header('HTTP/1.1 400 Bad Request');
    }
    ?>
```

It should behave like this (here `MIRROR_SERVICE_URI` should be http://www.mycheaphosting.com/copy.php):

    POST http://www.mycheaphosting.com/copy.php?uri=http://example.com/image.gif
    returns => http://www.mycheaphosting.com/13/02/01/213500-image.gif

### Logs
By network and channel, record any line of text, especially compromising ones. Then, months later, ask for a random line and have a good laugh.

* POST /:network/:channel/logs record the line, params are `log[line]` and `log[sender]`
* GET  /:network/:channel/logs HTML frontend, with search and pagination
* GET  /:network/:channel/random return a random line
* GET  /:network/:channel/search param `term`, return a random line containing `term`
* GET  /:network/:channel/previous return the last (or older with `offset` param) line returned with details on sender and creation date

### Admin
Uses [ActiveAdmin](https://github.com/gregbell/active_admin) as a back office.

## TODO
* Release an example IRC bot code (preferably Hubot) and maybe deployment instruction on Heroku.
* Need auth, at least a minimal one for POSTs.
* The CSS right now is just plain wrong.