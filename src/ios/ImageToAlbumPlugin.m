//
//  ImageToAlbumPlugin.m
//  ImageToAlbumPlugin PhoneGap/Cordova plugin
//
//  Created by Abtin Gramian on 10/05/14.
//  Copyright (c) 2012 Abtin Gramian. All rights reserved.
//	MIT Licensed
//

#import "ImageToAlbumPlugin.h"

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

@implementation ImageToAlbumPlugin

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
    // get reference to library
    self.library = [[ALAssetsLibrary alloc] init];
    // get album name from paramter
    NSString* albumName = [command.arguments objectAtIndex:1];
    // create the album if it doesn't exist
    [self.library addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
        NSLog(@"Album '%@' %s", albumName, group.editable ? "successfully created." : "already exists");
        NSLog(@"groupToAddTo1: %@", group);
        if (group.editable) {
            [self _writeImageFromCommand:command
                      toGroup:group];
        } else {
            // get reference to the album if wasn't just created
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                            if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                                 NSLog(@"Album %@ found in library.", albumName);
                                                 [self _writeImageFromCommand:command
                                                                      toGroup:group];
                                             }
                                         }
                                       failureBlock:^(NSError* error) {
                                           NSString* errorMessage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
                                           NSLog(@"%@", errorMessage);
                                           CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                             messageAsString:errorMessage];
                                           [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                       }];
        }
    } failureBlock:^(NSError *error) {
        NSString* errorMessage = [NSString stringWithFormat:@"Error: new album %@ was not created", albumName];
        NSLog(@"%@", errorMessage);
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:errorMessage];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)_writeImageFromCommand:(CDVInvokedUrlCommand*)command
                       toGroup:(ALAssetsGroup*) groupToAddTo
{
    // decode base64 image
    NSLog(@"groupToAddTo4: %@", groupToAddTo);
    NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
    // save image to album
    [self.library writeImageDataToSavedPhotosAlbum:imageData
                                          metadata:nil
                                   completionBlock:^(NSURL* assetURL, NSError* error) {
                                       if (error.code == 0) {
                                            NSLog(@"Image successfully saved at url: %@", assetURL);
                                            // try to get the asset
                                            [self.library assetForURL:assetURL
                                                          resultBlock:^(ALAsset *asset) {
                                                               NSLog(@"groupToAddTo5: %@", groupToAddTo);
                                                               // assign the photo to the album
                                                               [groupToAddTo addAsset:asset];
                                                               NSLog(@"Added image '%@' to album '%@'",
                                                                     [[asset defaultRepresentation] filename], groupToAddTo);
                                                               CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                                                               [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                           }
                                                          failureBlock:^(NSError* error) {
                                                              NSString* errorMessage = [NSString stringWithFormat:@"Error: %@ ",
                                                                                        [error localizedDescription]];
                                                              NSLog(@"%@", errorMessage);
                                                              CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
                                                              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                          }];
                                        } else {
                                            NSString* errorMessage = [NSString stringWithFormat:@"Error saving image.  Code:%ld\n%@",
                                                                      error.code, [error localizedDescription]];
                                            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                              messageAsString:errorMessage];
                                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                        }}];
}

@end
