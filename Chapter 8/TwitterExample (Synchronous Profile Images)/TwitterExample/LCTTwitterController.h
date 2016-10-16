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

- (void)authorizeAccountWithCompletionHandler:(void(^)(void))handler;
- (void)getTweetsInUserTimelineWithCompletionHandler:(void(^)(NSArray *tweets))handler;

@end
