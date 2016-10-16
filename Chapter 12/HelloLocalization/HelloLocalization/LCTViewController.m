//
//  LCTViewController.m
//  HelloLocalization
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTViewController.h"

@interface LCTViewController ()

@end

@implementation LCTViewController

@synthesize helloLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[[self helloLabel] setText:NSLocalizedString(@"helloWorld", NULL)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
