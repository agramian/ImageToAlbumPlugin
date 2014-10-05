//
//  ImageToAlbumPlugin.m
//  ImageToAlbumPlugin PhoneGap/Cordova plugin
//
//  Created by Abtin Gramian on 10/05/14.
//  Copyright (c) 2012 Abtin Gramian. All rights reserved.
//	MIT Licensed
//

#import "ImageToAlbumPlugin.h"
#import <Cordova/CDV.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ImageToAlbumPlugin

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
    ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
    NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
    NSString* albumName = [command.arguments objectAtIndex:1];
    [libraryFolder addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group)
    {
        NSLog(@"Adding Folder:'%@', success: %s", albumName, group.editable ? "Success" : "Already created: Not Success");
    } failureBlock:^(NSError *error)
    {
        NSLog(@"Error: Adding on Folder");
    }];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
    /*
    self.callbackId = command.callbackId;
    NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
    
    UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);*/
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"ERROR: %@",error);
        CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:error.description];
        [self.webView stringByEvaluatingJavaScriptFromString:[result toErrorCallbackString: self.callbackId]];
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog(@"IMAGE SAVED!");
        CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"Image saved"];
        [self.webView stringByEvaluatingJavaScriptFromString:[result toSuccessCallbackString: self.callbackId]];
    }
}

- (void)dealloc
{
    [callbackId release];
    [super dealloc];
}


@end
