//
//  SimpleViewController.m
//  ImageEditor
//
//  Created by David di Marcantonio on 19/02/13.
//  Last update 22/02/13
//
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
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    NSLog(@"%s", __FUNCTION__ );
    switch (buttonIndex)
    {
        case 0:
            // Camera Button
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            // Library Button
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 2:
            // Cancel Button
            break;
        default:
            break;
    }
}

-(void) displayImagePickerWithSource:(UIImagePickerControllerSourceType)src
{
    NSLog(@"%s", __FUNCTION__ );
    if([UIImagePickerController isSourceTypeAvailable:src])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.allowsEditing = NO;
        picker.sourceType = src;
        picker.delegate = self;
        
        [self presentModalViewController:picker animated:YES];        
        
        self.library = [[ALAssetsLibrary alloc] init];
        
        if (!self.imageEditor)
        {
            self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil];
        }
        
        __block SimpleViewController *weakSelf = self;
        
        self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
            if(!canceled)
            {
                [weakSelf.library writeImageToSavedPhotosAlbum:[editedImage CGImage]
                                                   orientation:(ALAssetOrientation)(editedImage.imageOrientation)
                                               completionBlock:^(NSURL *assetURL, NSError *error){
                                                   if (error) {
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving"
                                                                                                       message:[error localizedDescription]
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"Ok"
                                                                                             otherButtonTitles: nil];
                                                       [alert show];
                                                   }
                                               }];
            }
            /* *********** here the image processing  *** */
            
            /* ****************************************** */
            
            [picker dismissModalViewControllerAnimated:NO];
        };
    }
}



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
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark IBACTIONs
- (IBAction) LaunchImagePickerPressed: (id) sender
{
    NSLog(@"%s", __FUNCTION__ );

    
    // present an alert sheet if a camera is visible and allow the user to select the camera or photo library.
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // this device has a camera, display the alert sheet:
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Select Image Source"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Camera",@"Photo Library", nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        // the tab bar was interferring in the current view
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    } else {
        // without a camera, there is no choice to make. just display the modal image picker
        [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}



@end
