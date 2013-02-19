
//  DemoAppDelegate.m
//  ImageEditor
//
//  Modified by David di Marcantonio on 19/02/13.
//  Copyright (c) 2013 Heitor Ferreira. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DemoAppDelegate.h"
#import "DemoImageEditor.h"
#import "SimpleViewController.h"

@interface DemoAppDelegate()
@property(nonatomic,retain) DemoImageEditor *imageEditor;
@property(nonatomic,retain) ALAssetsLibrary *library;
@end

@implementation DemoAppDelegate

@synthesize library = _library;
@synthesize imageEditor = _imageEditor;
@synthesize simpleViewController = _simpleViewController;

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__ );
    [_library release];
    [_imageEditor release];
    [_window release];
    [_simpleViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s", __FUNCTION__ );
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    /* *** OFF by David di Marcantonio ***
    //if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    self.window.rootViewController = picker;
    [picker release];
    
    self.library = [[[ALAssetsLibrary alloc] init] autorelease];
    self.imageEditor = [[[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil] autorelease];
    
    self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
        if(!canceled) {
          
            [self.library writeImageToSavedPhotosAlbum:[editedImage CGImage]
                                      orientation:editedImage.imageOrientation
                                  completionBlock:^(NSURL *assetURL, NSError *error){
                                      if (error) {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving"
                                                                                          message:[error localizedDescription]
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"Ok"
                                                                                otherButtonTitles: nil];
                                          [alert show];
                                          [alert release];
                                      }
                                  }];
        }
        [picker popToRootViewControllerAnimated:YES];
        [picker setNavigationBarHidden:NO animated:YES];
    };
     */
    
    /* replaced by */
    self.simpleViewController = [[[SimpleViewController alloc] initWithNibName:@"SimpleViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.simpleViewController;


    [self.window makeKeyAndVisible];
    return YES;
}

/* *** OFF by David di Marcantonio 
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s", __FUNCTION__ );
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];

    [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];

        self.imageEditor.sourceImage = image;
        self.imageEditor.previewImage = preview;
        [self.imageEditor reset:NO];
        
        [picker pushViewController:self.imageEditor animated:YES];
        [picker setNavigationBarHidden:YES animated:NO];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to get asset from library");
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%s", __FUNCTION__ );
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel"
                                                    message:@"Nowhere to go my friend. This is a demo."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

 */

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"%s", __FUNCTION__ );
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%s", __FUNCTION__ );
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%s", __FUNCTION__ );
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%s", __FUNCTION__ );
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%s", __FUNCTION__ );
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
