//
//  LCTTwitterController.h
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCTTwitterController : NSObject

+ (id)sharedInstance;

- (void)authorizeAccount;
- (void)getTweetsInUserTimelineWithCompletionHandler:(void(^)(NSArray *tweets))handler;
- (void)postTweet:(NSString *)tweet;

@end
