//
//  LCTViewController.m
//  LocaleNumbers
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTViewController.h"

@interface LCTViewController ()

@end

@implementation LCTViewController

@synthesize noStyleLabel;
@synthesize decimalStyleLabel;
@synthesize currencyStyleLabel;
@synthesize percentStyleLabel;
@synthesize scientificStyleLabel;
@synthesize spellOutStyleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
		self.navigationItem.leftBarButtonItem = doneButton;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	NSNumber *number = [NSNumber numberWithDouble:1000.42];
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	
	[numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
	[[self noStyleLabel] setText:[numberFormatter stringFromNumber:number]];
	
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[[self decimalStyleLabel] setText:[numberFormatter stringFromNumber:number]];
	
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[[self currencyStyleLabel] setText:[numberFormatter stringFromNumber:number]];
	
	[numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
	[[self percentStyleLabel] setText:[numberFormatter stringFromNumber:number]];
	
	[numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
	[[self scientificStyleLabel] setText:[numberFormatter stringFromNumber:number]];
	
	[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
	[[self spellOutStyleLabel] setText:[numberFormatter stringFromNumber:number]];
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
