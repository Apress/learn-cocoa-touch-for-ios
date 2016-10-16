//
//  LCTAppDelegate.m
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTAppDelegate.h"

#import "LCTTwitterController.h"
#import "LCTTimelineViewController.h"
#import "LCTTweetMapViewController.h"

@implementation LCTAppDelegate {
	UIViewController *viewController;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
//	LCTTimelineViewController *viewController =
//	[[LCTTimelineViewController alloc] initWithStyle:UITableViewStylePlain];
//	
//	UINavigationController *navigationController =
//	[[UINavigationController alloc] initWithRootViewController:viewController];
//	
//	UIColor *darkBlueSlateColor = [UIColor colorWithRed:(74/255.0f)
//												  green:(82/255.0f)
//												   blue:(90/255.0f)
//												  alpha:1.0f];
//	
//	[[navigationController navigationBar] setTintColor:darkBlueSlateColor];
//	
//	[[self window] setRootViewController:navigationController];

	viewController =
	[[LCTTweetMapViewController alloc] initWithNibName:nil
												bundle:nil];
	
	[[self window] setRootViewController:viewController];

    return YES;
}

@end
