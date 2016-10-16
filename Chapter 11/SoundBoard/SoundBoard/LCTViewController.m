//
//  LCTViewController.m
//  SoundBoard
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface LCTViewController () {
	AVAudioPlayer *_audioPlayer;
	SystemSoundID _soundID;
}

@end

@implementation LCTViewController

@synthesize systemSoundButton;
@synthesize alertSoundButton;
@synthesize audioPlayerButton;

- (void)dealloc
{
	AudioServicesDisposeSystemSoundID(_soundID);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"Trumpet"
											  withExtension:@"m4a"];
	
	// Create a sound ID used to play the system sound.
	OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
													   &_soundID);
	
	if (status != kAudioServicesNoError) {
		// An error occurred, so let's disable the buttons.
		[[self systemSoundButton] setEnabled:NO];
		[[self alertSoundButton] setEnabled:NO];
	}
	
	// Initialize the AVAudioPlayer
	NSError *error = nil;
	_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL
														  error:&error];
	
	if (_audioPlayer == nil) {
		// An error occured, so let's disable the button and log the error.
		NSLog(@"%@", error);
		[[self audioPlayerButton] setEnabled:NO];
	}
	else {
		[_audioPlayer prepareToPlay];
	}
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

- (IBAction)systemSoundButtonPressed:(id)sender
{
	AudioServicesPlaySystemSound(_soundID);
}

- (IBAction)alertSoundButtonPressed:(id)sender
{
	AudioServicesPlayAlertSound(_soundID);
}

- (IBAction)audioPlayerButtonPressed:(id)sender
{
	[_audioPlayer play];
}

@end
