//
//  PossessionDetailViewController.m
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "PossessionDetailViewController.h"

#import "Possession.h"


@interface PossessionDetailViewController()

- (void)doneButtonPressed:(id)sender;

@end


@implementation PossessionDetailViewController

@synthesize nameField;
@synthesize valueField;
@synthesize possession;
@synthesize modal;
@synthesize delegate;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self nameField] setText:[[self possession] name]];
    [[self valueField] setText:[[[self possession] value] stringValue]];
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

@end
