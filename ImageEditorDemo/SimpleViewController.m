//
//  SimpleViewController.m
//  ImageEditor
//
//  Created by David di Marcantonio on 19/02/13.
//  Copyright (c) 2013 Heitor Ferreira. All rights reserved.
//

#import "SimpleViewController.h"
#import "DemoImageEditor.h"

@interface SimpleViewController ()

@end

@implementation SimpleViewController

@synthesize LaunchImagePicker = _LaunchImagePicker,
            frameView = _frameView,
            imageEditor = _imageEditor,
            window = _window,
            library = _library;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"%s", __FUNCTION__ );
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"%s", __FUNCTION__ );
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%s", __FUNCTION__ );
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__ );
    [_LaunchImagePicker release];
    [_frameView release];
    [_imageEditor release];
    [_library release];
    [_window release];
    [super dealloc];
}
- (void)viewDidUnload
{
    NSLog(@"%s", __FUNCTION__ );
    [self setLaunchImagePicker:nil];
    [self setFrameView:nil];
    [self setWindow:nil];
    [super viewDidUnload];
}

#pragma mark ImagePickerManagement
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
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


#pragma mark IBACTIONs

- (IBAction)LaunchImagePickerPressed:(id)sender
{
    NSLog(@"%s", __FUNCTION__ );
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //self.window.rootViewController = picker;
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

}
@end
