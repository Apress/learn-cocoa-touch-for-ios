//
//  LCTTweet.h
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LCTTweet : NSObject <MKAnnotation>

@property (copy) NSString *text;
@property (copy) NSString *username;
@property (copy) CLLocation *location;

@end
