//
//  LCTViewController.m
//  MotionDot
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface LCTViewController () {
	CMMotionManager *_motionManager;
	UIView *_blueDot;
}

@end

@implementation LCTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	_blueDot = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
	[_blueDot setBackgroundColor:[UIColor blueColor]];
	
	[[self view] addSubview:_blueDot];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	CGRect bounds = [[self view] bounds];
	CGFloat width = CGRectGetWidth(bounds);
	CGFloat height = CGRectGetHeight(bounds);
	
	CGRect blueDotFrame = [_blueDot frame];
	CGFloat dotWidth = CGRectGetWidth(blueDotFrame);
	CGFloat dotHeight = CGRectGetHeight(blueDotFrame);
	
	_motionManager = [[CMMotionManager alloc] init];
	
	if ([_motionManager isAccelerometerAvailable] == NO) {
		return;
	}
	
	[_motionManager setAccelerometerUpdateInterval:1.0 / 60.0];
	
	CMAccelerometerHandler accelerometerHandler =
	^(CMAccelerometerData *accelerometerData, NSError *error) {
		CMAcceleration acceleration = [accelerometerData acceleration];
		
		CGFloat x = floorf(((width - dotWidth) / 2.0f) + (100 * acceleration.x));
		CGFloat y = floorf(((height - dotHeight) / 2.0f) + (100 * acceleration.y));
		CGFloat width = floorf(dotWidth * (20 * acceleration.z));
		CGFloat height = floorf(dotHeight * (20 * acceleration.z));
		
		[_blueDot setFrame:CGRectMake(x, y, width, height)];
	};
	
	[_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
										 withHandler:accelerometerHandler];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if ([_motionManager isAccelerometerActive]) {
		[_motionManager stopAccelerometerUpdates];
	}
	
	_motionManager = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	_blueDot = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
