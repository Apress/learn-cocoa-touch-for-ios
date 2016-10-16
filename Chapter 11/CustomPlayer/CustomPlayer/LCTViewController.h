//
//  LCTViewController.h
//  CustomPlayer
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *movieHostingView;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *fullscreenButton;

- (IBAction)playPauseButtonPressed:(id)sender;
- (IBAction)fullscreenButtonPressed:(id)sender;

@end
