//
//  LCTViewController.h
//  SoundBoard
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCTViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *systemSoundButton;
@property (strong, nonatomic) IBOutlet UIButton *alertSoundButton;
@property (strong, nonatomic) IBOutlet UIButton *audioPlayerButton;

- (IBAction)systemSoundButtonPressed:(id)sender;
- (IBAction)alertSoundButtonPressed:(id)sender;
- (IBAction)audioPlayerButtonPressed:(id)sender;

@end
