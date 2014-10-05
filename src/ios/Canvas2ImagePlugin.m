//
//  Canvas2ImagePlugin.m
//  Canvas2ImagePlugin PhoneGap/Cordova plugin
//
//  Created by Abtin Gramian on 10/05/14.
//  Copyright (c) 2012 Abtin Gramian. All rights reserved.
//	MIT Licensed
//

#import "Canvas2ImagePlugin.h"
#import <Cordova/CDV.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Canvas2ImagePlugin
@synthesize callbackId;

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
	NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
	NSString *albumName = @"PicFlik";
	UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
    
    ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
    [libraryFolder addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group)
    {
        NSLog(@"Adding Folder:'%s', success: %s", albumName, group.editable ? "Success" : "Already created: Not Success");
    } failureBlock:^(NSError *error)
    {
        NSLog(@"Error: Adding on Folder");
    }];
    [self.webView stringByEvaluatingJavaScriptFromString:[result toSuccessCallbackString: self.callbackId]];
    /*
    [self.library addAssetsGroupAlbumWithName:albumName
                                  resultBlock:^(ALAssetsGroup *group) {
                                      NSLog(@"added album:%@", albumName);
                                  }
                                 failureBlock:^(NSError *error) {
                                     NSLog(@"error adding album");
                                 }];
    __block ALAssetsGroup* groupToAddTo;
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                                        NSLog(@"found album %@", albumName);
                                        groupToAddTo = group;
                                    }
                                }
                              failureBlock:^(NSError* error) {
                                  NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
                              }];
    CGImageRef img = [image CGImage];
    [self.library writeImageToSavedPhotosAlbum:image
                                      metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                               completionBlock:^(NSURL* assetURL, NSError* error) {
                                   if (error.code == 0) {
                                       NSLog(@"saved image completed:\nurl: %@", assetURL);
                                       
                                       // try to get the asset
                                       [self.library assetForURL:assetURL
                                                     resultBlock:^(ALAsset *asset) {
                                                         // assign the photo to the album
                                                         [groupToAddTo addAsset:asset];
                                                         NSLog(@"Added %@ to %@", [[asset defaultRepresentation] filename], albumName);
                                                     }
                                                    failureBlock:^(NSError* error) {
                                                        NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
                                                    }];
                                   }
                                   else {
                                       image:didFinishSavingWithError:contextInfo
                                       //NSLog(@"saved image failed.\nerror code %i\n%@", error.code, [error //localizedDescription]);
                                   }
                               }];*/
	//UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	
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
