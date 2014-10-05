//
//  Canvas2ImagePlugin.js
//  Canvas2ImagePlugin PhoneGap/Cordova plugin
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
        	console.log("Canvas2ImagePlugin Error: successCallback is not a function");
        }
        else if (typeof failureCallback != "function") {
            console.log("Canvas2ImagePlugin Error: failureCallback is not a function");
        }
        else {
            return cordova.exec(successCallback, failureCallback, "Canvas2ImagePlugin","saveImageDataToLibrary",[imageData]);
        }
    }
};
  
