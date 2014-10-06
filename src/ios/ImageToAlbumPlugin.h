//
//  ImageToAlbumPlugin.h
//  ImageToAlbumPlugin PhoneGap/Cordova plugin
//
//  Created by Abtin Gramian on 10/05/16.
//  Copyright (c) 2014 Abtin Gramian. All rights reserved.
//	MIT Licensed
//


#import <Cordova/CDVPlugin.h>

@interface ImageToAlbumPlugin : CDVPlugin

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command;

@end
