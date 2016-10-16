//
//  PossessionDetailViewController.m
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//


#import "PossessionDetailViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>

#import "Possession.h"


@interface PossessionDetailViewController()

- (void)doneButtonPressed:(id)sender;
- (void)imageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType;

@end


@implementation PossessionDetailViewController

@synthesize imageView = _imageView;
@synthesize nameField = _nameField;
@synthesize valueField = _valueField;
@synthesize possession = _possession;
@synthesize modal = _modal;
@synthesize delegate = _delegate;

#pragma mark - Object Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        [self setTitle:@"Item Details"];

        UIBarButtonItem *doneButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:self
                                                      action:@selector(doneButtonPressed:)];
        
        [[self navigationItem] setRightBarButtonItem:doneButtonItem];
	}
    
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UITapGestureRecognizer *tapGestureRecognizer =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(imageViewTapped:)];
	
	[[self imageView] addGestureRecognizer:tapGestureRecognizer];
	[[self imageView] setUserInteractionEnabled:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[[self imageView] setImage:[[self possession] image]];
    [[self nameField] setText:[[self possession] name]];
    [[self valueField] setText:[[[self possession] value] stringValue]];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

#pragma mark - UIActionSheetDelegate Protocol Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [actionSheet cancelButtonIndex]) {
		return;
	}
	else {
		UIImagePickerControllerSourceType sourceType;
		
		if (buttonIndex == 0) {
			sourceType = UIImagePickerControllerSourceTypeCamera;
		}
		else {
			sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		
		[self showImagePickerControllerWithSourceType:sourceType];
	}
}

#pragma mark - UIImagePickerControllerDelegate Protocol Methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([self possession] == nil) {
        [self setPossession:[[Possession alloc] init]];
		[[self possession] setName:[[self nameField] text]];
		[[self possession] setValue:[NSNumber numberWithInt:[[[self valueField] text] intValue]]];
    }
	
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	[[self possession] setImage:image];

	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -

- (void)doneButtonPressed:(id)sender
{
    if ([self possession] == nil) {
        [self setPossession:[[Possession alloc] init]];
    }
    
    if ([[[self possession] name] isEqualToString:[[self nameField] text]] == NO) {
        [[self possession] setName:[[self nameField] text]];
    }
    
    NSNumber *newValue = [NSNumber numberWithInt:[[[self valueField] text] intValue]];
    
    if ([[[self possession] value] isEqualToNumber:newValue] == NO) {
        [[self possession] setValue:newValue];
    }
    
	[[self delegate] possessionDetailViewController:self
                                  didEditPossession:[self possession]];
    
    if ([self isModal]) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	UIAlertView *alertView =
	[[UIAlertView alloc] initWithTitle:@"Undo"
							   message:@"Would you like to undo?"
							  delegate:self
					 cancelButtonTitle:@"Don’t Undo"
					 otherButtonTitles:@"Undo", nil];

	[alertView show];
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
		[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIActionSheet *actionSheet =
		[[UIActionSheet alloc] initWithTitle:nil
									delegate:self
						   cancelButtonTitle:@"Cancel"
					  destructiveButtonTitle:nil
						   otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
		
		[actionSheet showInView:[self view]];
	}
	else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		[self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
}

- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
	UIImagePickerController *imagePickerController =
	[[UIImagePickerController alloc] init];
	
	[imagePickerController setSourceType:sourceType];
	
	[imagePickerController setDelegate:self];

	[self presentModalViewController:imagePickerController animated:YES];
}

@end
