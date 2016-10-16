//
//  LCTTweetMapViewController.m
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTTweetMapViewController.h"

#import "LCTTwitterController.h"
#import "LCTTweet.h"

@interface LCTTweetMapViewController ()

@end


@implementation LCTTweetMapViewController

@synthesize searchTextField = _searchTextField;
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[self setSearchTextField:nil];
	[self setMapView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextFieldDelegate Protocol Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	NSString *searchText = [textField text];
	
	if ([searchText length] == 0) {
		return NO;
	}
	
	LCTTwitterController *twitterController = [LCTTwitterController sharedInstance];
	
	void (^completionHandler)(NSArray *) = ^(NSArray *tweets) {
		NSArray *currentAnnotations = [[self mapView] annotations];
		
		[[self mapView] removeAnnotations:currentAnnotations];
		[[self mapView] addAnnotations:tweets];
		
		// Get the location from a tweet to center the map
		LCTTweet *tweet = [tweets objectAtIndex:0];
		CLLocationCoordinate2D coordinate = [[tweet location] coordinate];
		
		[[self mapView] setRegion:MKCoordinateRegionMake(coordinate,
														 MKCoordinateSpanMake(0.1, 0.1))
						 animated:YES];
	};
	
	[twitterController getTweetsNearStreetAddress:searchText
									 searchRadius:1000
								completionHandler:completionHandler];
	
	return YES;
}

#pragma mark - MKMapViewDelegate Protocol Methods
//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//	// return the default view.
//	return nil;
//}


@end
