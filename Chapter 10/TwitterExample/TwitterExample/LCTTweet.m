//
//  LCTTweet.m
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTTweet.h"


@implementation LCTTweet

@synthesize text = _text;
@synthesize username = _username;
@synthesize location = _location;

#pragma mark - MKAnnotation Protocol Methods

- (NSString *)title
{
	return [self text];
}

- (NSString *)subtitle
{
	return [self username];
}

- (CLLocationCoordinate2D)coordinate
{
	return [[self location] coordinate];
}

#pragma mark -

@end
