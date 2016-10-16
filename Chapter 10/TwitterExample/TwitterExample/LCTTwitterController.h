//
//  LCTTwitterController.h
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface LCTTwitterController : NSObject

+ (id)sharedInstance;

- (void)authorizeAccountWithCompletionHandler:(void(^)(void))handler;
- (void)getTweetsInUserTimelineWithCompletionHandler:(void(^)(NSArray *tweets))handler;

- (void)getTweetsNearStreetAddress:(NSString *)streetAddress
					  searchRadius:(NSUInteger)searchRadiusInMeters
				 completionHandler:(void(^)(NSArray *tweets))handler;

- (void)getTweetsNearLocation:(CLLocation *)location
				 searchRadius:(NSUInteger)searchRadiusInMeters
			completionHandler:(void(^)(NSArray *tweets))handler;

@end
