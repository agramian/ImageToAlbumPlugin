//
//  ImageToAlbumPlugin.js
//  ImageToAlbumPlugin PhoneGap/Cordova plugin
//
//  Created by Abtin Gramian on 10/05/14.
//  Copyright (c) 2014 Abtin Gramian. All rights reserved.
//  MIT Licensed
//
module.exports = { 
	saveImageDataToLibrary:function(successCallback,
									failureCallback,
									imageData,
									directoryPath,
									filename) {
        if (typeof successCallback != "function") {
        	console.log("ImageToAlbumPlugin Error: successCallback is not a function");
        }
        else if (typeof failureCallback != "function") {
            console.log("ImageToAlbumPlugin Error: failureCallback is not a function");
        }
        else {
            return cordova.exec(successCallback, failureCallback, "ImageToAlbumPlugin","saveImageDataToLibrary",[imageData]);
        }
    }
};
  
