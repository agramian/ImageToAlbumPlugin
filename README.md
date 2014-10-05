Canvas2ImagePlugin
============

This plugin allows you to save the contents of an HTML canvas tag to the iOS Photo Library, Android Gallery or WindowsPhone 8 Photo Album from your app.

Installation
------------

### For Cordova 3.x.x:

1. To add this plugin just type: 'cordova plugin add https://github.com/agramian/Canvas2ImagePlugin.git'
2. To remove this plugin type: 'cordova plugin remove org.agramian.Canvas2ImagePlugin'

Usage:
------

Call the 'window.canvas2ImagePlugin.saveImageDataToLibrary()' method using success and error callbacks
### Example
```html
<canvas id="myCanvas" width="165px" height="145px"></canvas>
```

```javascript
function onDeviceReady()
{
	imageData = document.getElementById('myCanvas').toDataURL("image/png").split(',')[1];
	directoryPath = "My Album/Pics"
	filename = "myphoto.png"
	window.canvas2ImagePlugin.saveImageDataToLibrary(
        function(msg){
            console.log(msg);
        },
        function(err){
            console.log(err);
        },
        imageData,
        directoryPath,
        filename
    );
}
```

## License

The MIT License

Copyright (c) 2014 Abtin Gramian (http://github.com/agramian)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
