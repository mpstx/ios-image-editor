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

@interface SimpleViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UIButton *LaunchImagePicker;
@property (retain, nonatomic) IBOutlet HFImageEditorFrameView *frameView;
@property (nonatomic, retain) DemoImageEditor *imageEditor;
@property (nonatomic, retain) ALAssetsLibrary *library;
@property (retain, nonatomic) IBOutlet UIWindow *window;


- (IBAction)LaunchImagePickerPressed:(id)sender;

@end
