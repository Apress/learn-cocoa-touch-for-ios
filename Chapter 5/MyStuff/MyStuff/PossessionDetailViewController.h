//
//  PossessionDetailViewController.h
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "PossessionDetailViewControllerDelegate.h"


@class Possession;

@interface PossessionDetailViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak) IBOutlet UIImageView *imageView;
@property (weak) IBOutlet UITextField *nameField;
@property (weak) IBOutlet UITextField *valueField;
@property (strong) Possession *possession;
@property (getter = isModal) BOOL modal;
@property (weak) id <PossessionDetailViewControllerDelegate> delegate;

@end
