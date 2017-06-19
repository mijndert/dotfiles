# LiveReload for Atom

[![Build Status](https://travis-ci.org/taggon/livereload.svg)](https://travis-ci.org/taggon/livereload)

An [Atom](https://atom.io/) package enables you to control built-in [LiveReload](http://livereload.com/) server.
> LiveReload monitors changes in the file system. As soon as you save a file, it is preprocessed as needed, and the browser is refreshed.
>
> Even cooler, when you change a CSS file or an image, the browser is updated instantly without reloading the page.
>
> *from LiveReload official site*

## Usage
1. Select main menu `Packages > LiveReload > Toggle Server` to turn the server on. Or press `Ctrl+Shift+R`.
2. When the server started successfully, `LiveReload: PORT_NUMBER` text appears in the status bar(see the bottom right panel in the following screenshot).
   ![LiveReload status text](https://cloud.githubusercontent.com/assets/212034/3565696/c50f01ce-0aca-11e4-991e-4cb8475364c4.png)
3. Click it to get the url of `livereload.js` JavaScript file.
4. Put the script into the bottom of documents you want to give power of live reloading.

## Features
* Reloads web pages when any file is created, removed or modified.
* Applies changes without reloading when any CSS or image changed.
* Works well with [Chrome LiveReload extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei?hl=en).

## Notes
* The chrome extension works only with default port 35729.
* Watching too many files can make this horribly slow. To avoid this please exclude directories which have many files such as `node_modules`.

## Todo
* Setting per project.
* Support preprocessors.

## License
MIT
