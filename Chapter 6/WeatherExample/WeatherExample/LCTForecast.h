//
//  LCTForecast.h
//  WeatherExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCTForecast : NSObject

@property (copy) NSString *date;
@property (strong) NSNumber *low;
@property (strong) NSNumber *high;
@property (copy) NSString *text;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
