//
//  LCTAppDelegate.h
//  RedditSlideshow
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTViewController;

@interface LCTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LCTViewController *viewController;

@end
