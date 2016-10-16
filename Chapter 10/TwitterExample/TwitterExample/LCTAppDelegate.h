//
//  LCTAppDelegate.h
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

@interface LCTAppDelegate : UIResponder <MPMediaPickerControllerDelegate, UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
