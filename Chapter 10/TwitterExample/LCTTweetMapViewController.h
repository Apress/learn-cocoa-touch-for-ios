//
//  LCTTweetMapViewController.h
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LCTTweetMapViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>

@property (strong) IBOutlet UITextField *searchTextField;
@property (strong) IBOutlet MKMapView *mapView;

@end
