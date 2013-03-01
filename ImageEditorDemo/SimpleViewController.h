//
//  SimpleViewController.h
//  ImageEditor
//
//  Created by David di Marcantonio on 19/02/13.
//  Copyright (c) 2013 Heitor Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HFImageEditorFrameView.h"
#import "DemoImageEditor.h"

@interface SimpleViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIButton *LaunchImagePicker;
@property (strong, nonatomic) IBOutlet HFImageEditorFrameView *frameView;
@property (nonatomic, strong) DemoImageEditor *imageEditor;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (strong, nonatomic) IBOutlet UIWindow *window;


- (IBAction)LaunchImagePickerPressed:(id)sender;

@end
