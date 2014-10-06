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

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

@implementation ImageToAlbumPlugin

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
    // get reference to library
    ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
    // get album name from paramter
    NSString* albumName = [command.arguments objectAtIndex:1];
    // create the album if it doesn't exist
    __block ALAssetsGroup* groupToAddTo = nil;
    [libraryFolder addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
        NSLog(@"Album '%@' %s", albumName, group.editable ? "successfully created." : "already exists");
        groupToAddTo = group;
    } failureBlock:^(NSError *error) {
        NSString* errorMessage = [NSString stringWithFormat:@"Error: new album %@ was not created", albumName];
        NSLog(@"%s", errorMessage);
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:errorMessage];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    // get reference to the album if wasn't just created
    if (groupToAddTo == nil) {
        [libraryFolder enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                     usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                         if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                             NSLog(@"Album %@ found in library.", albumName);
                                             groupToAddTo = group;
                                         }
                                     }
                                   failureBlock:^(NSError* error) {
                                       NSString* errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
                                       NSLog(@"%s", errorMessage);
                                       CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                         messageAsString:errorMessage];
                                       [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                   }];
    }
    // decode base64 image
    NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
    // save image to album
    [libraryFolder writeImageDataToSavedPhotosAlbum:imageData
                                           metadata:nil
                                    completionBlock:^(NSURL* assetURL, NSError* error) {
                                        if (error.code == 0) {
                                            NSLog(@"Image successfully saved at url: %@", assetURL);
                                            // try to get the asset
                                            [libraryFolder assetForURL:assetURL
                                                           resultBlock:^(ALAsset *asset) {
                                                               // assign the photo to the album
                                                               [groupToAddTo addAsset:asset];
                                                               NSLog(@"Added image '%@' to album '%@'",
                                                                     [[asset defaultRepresentation] filename], albumName);
                                                           }
                                                          failureBlock:^(NSError* error) {
                                                              NSString* errorMessage = [NSString stringWithFormat:@"Error: %@ ",
                                                                                        [error localizedDescription]];
                                                              NSLog(@"%s", errorMessage);
                                                              CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
                                                              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                          }];
                                        } else {
                                            NSString* errorMessage = [NSString stringWithFormat:@"Error saving image.  Code:%l\n%@",
                                                                      error.code, [error localizedDescription]];
                                            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                              messageAsString:errorMessage];
                                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                        }}];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
