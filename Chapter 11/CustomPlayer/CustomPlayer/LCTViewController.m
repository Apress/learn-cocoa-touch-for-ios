//
//  LCTViewController.m
//  CustomPlayer
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface LCTViewController () {
	MPMoviePlayerController *_moviePlayerController;
}

- (void)selectVideoButtonPressed:(id)sender;
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation LCTViewController

@synthesize movieHostingView;
@synthesize playPauseButton;
@synthesize fullscreenButton;

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		[self setTitle:@"CustomPlayer"];
		
		SEL selectVideoSelector = @selector(selectVideoButtonPressed:);
		UIBarButtonItem *selectVideoButton =
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
													  target:self
													  action:selectVideoSelector];
		
		[[self navigationItem] setRightBarButtonItem:selectVideoButton];
		
		[[NSNotificationCenter defaultCenter]
		 addObserverForName:MPMoviePlayerPlaybackStateDidChangeNotification
		 object:nil
		 queue:[NSOperationQueue mainQueue]
		 usingBlock:^(NSNotification *note) {
			 MPMoviePlayerController *moviePlayerController = [note object];
			 
			 if ([moviePlayerController playbackState] == MPMoviePlaybackStatePlaying) {
				 [[self playPauseButton] setTitle:@"Pause"
										 forState:UIControlStateNormal];
			 }
			 else {
				 [[self playPauseButton] setTitle:@"Play"
										 forState:UIControlStateNormal];
			 }
		 }];
		
		[[NSNotificationCenter defaultCenter]
		 addObserverForName:MPMoviePlayerDidExitFullscreenNotification
		 object:nil
		 queue:[NSOperationQueue mainQueue]
		 usingBlock:^(NSNotification *note) {
			 MPMoviePlayerController *moviePlayerController = [note object];
			 
			 [moviePlayerController setControlStyle:MPMovieControlStyleNone];
		 }];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

#pragma mark - UIActionSheetDelegate Protocol Methods

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		// The user selected "Take a Video."
		[self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else if (buttonIndex == 1) {
		// The user selected "Use Photo Library."
		[self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
}

#pragma mark - UIImagePickerControllerDelegate Protocol Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];

	NSURL *movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
	
	if (movieURL != nil) {
		_moviePlayerController =
		[[MPMoviePlayerController alloc] initWithContentURL:movieURL];
		
		[_moviePlayerController setControlStyle:MPMovieControlStyleNone];
		
		[[_moviePlayerController view]
		 setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
							  UIViewAutoresizingFlexibleHeight)];
		
		[[_moviePlayerController view] setClipsToBounds:YES];
		[[_moviePlayerController view] setFrame:[[self movieHostingView] bounds]];
		[[self movieHostingView] addSubview:[_moviePlayerController view]];
	}
}

#pragma mark -

- (void)selectVideoButtonPressed:(id)sender
{
	// If there is already a movie player controller, clean it up.
	if (_moviePlayerController != nil) {
		[[_moviePlayerController view] removeFromSuperview];
		_moviePlayerController = nil;
	}
	
	// Determine the ways in which we can get a video from an image picker controller.
	BOOL canUseCamera = NO;
	
	if ([UIImagePickerController
		 isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
		[[UIImagePickerController
		  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]
		 containsObject:(NSString *)kUTTypeMovie]) {
		canUseCamera = YES;
	}
	
	BOOL canUsePhotoLibrary = NO;
	
	if ([UIImagePickerController
		 isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] &&
		[[UIImagePickerController
		  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]
		 containsObject:(NSString *)kUTTypeMovie]) {
		canUsePhotoLibrary = YES;
	}
	
	// If we can use both source types, show the user an action sheet to allow them to
	// decide which to use.
	if (canUseCamera == YES && canUsePhotoLibrary == YES) {
		UIActionSheet *actionSheet =
		[[UIActionSheet alloc] initWithTitle:nil
									delegate:self
						   cancelButtonTitle:@"Cancel"
					  destructiveButtonTitle:nil
						   otherButtonTitles:@"Take a Video", @"Use Photo Library", nil];
		
		[actionSheet showInView:[self view]];
	}
	else if (canUseCamera == YES && canUsePhotoLibrary == NO) {
		[self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else if (canUseCamera == NO && canUsePhotoLibrary == YES) {
		[self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
	else {
		// Neither the camera or the photo library are available.
		UIAlertView *alertView =
		[[UIAlertView alloc] initWithTitle:@"Error Loading Video"
								   message:@"No source type is available."
								  delegate:nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		[alertView show];
	}
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
	UIImagePickerController *imagePicker =
	[[UIImagePickerController alloc] init];

	[imagePicker setDelegate:self];
	[imagePicker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
	[imagePicker setSourceType:sourceType];
	
	[self presentModalViewController:imagePicker animated:YES];
}

- (void)playPauseButtonPressed:(id)sender
{
	if (_moviePlayerController == nil) {
		return;
	}
	
	if ([_moviePlayerController playbackState] == MPMoviePlaybackStatePlaying) {
		// The video is playing.
		[_moviePlayerController pause];
	}
	else {
		// The video is not playing.
		[_moviePlayerController play];
	}
}

- (void)fullscreenButtonPressed:(id)sender
{
	if (_moviePlayerController == nil) {
		return;
	}
	
	[_moviePlayerController setControlStyle:MPMovieControlStyleDefault];
	[_moviePlayerController setFullscreen:YES animated:YES];
}

@end
