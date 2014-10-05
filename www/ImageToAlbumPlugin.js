//
//  ImageToAlbumPlugin.js
//  ImageToAlbumPlugin PhoneGap/Cordova plugin
//
//  Created by Abtin Gramian on 10/05/14.
//  Copyright (c) 2014 Abtin Gramian. All rights reserved.
//  MIT Licensed
//

module.exports = { 
	echo: function(str, callback) {
		console.log("calling plugin echo");
	    return cordova.exec(callback, function(err) {
	        callback('Nothing to echo.');
	    }, "Echo", "echo", [str]);
	},	
	saveImageDataToLibrary:function(successCallback,
									failureCallback,
									imageData,
									directoryPath,
									filename) {
		console.log('save iamge to library');
        if (typeof successCallback != "function") {
        	console.log("ImageToAlbumPlugin Error: successCallback is not a function");
        }
        else if (typeof failureCallback != "function") {
            console.log("ImageToAlbumPlugin Error: failureCallback is not a function");
        }
        else {
            //return cordova.exec(successCallback, failureCallback, "ImageToAlbumPlugin","saveImageDataToLibrary",[imageData]);
            return cordova.exec(successCallback, failureCallback, "ImageToAlbumPlugin","saveImageDataToLibrary",[imageData]);
        }
    }
};