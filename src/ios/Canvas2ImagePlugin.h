//
//  Canvas2ImagePlugin.h
//  Canvas2ImagePlugin PhoneGap/Cordova plugin
//
//  Created by Abtin Gramian on 10/05/16.
//  Copyright (c) 2014 Abtin Gramian. All rights reserved.
//	MIT Licensed
//


#import <Cordova/CDVPlugin.h>

@interface Canvas2ImagePlugin : CDVPlugin
{
	NSString* callbackId;
}

@property (nonatomic, copy) NSString* callbackId;

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command;

@end
