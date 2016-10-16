//
//  LCTForecast.m
//  WeatherExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTForecast.h"

@implementation LCTForecast

@synthesize date = _date;
@synthesize low = _low;
@synthesize high = _high;
@synthesize text = _text;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
	if (self) {
		_date = [[dictionary objectForKey:@"date"] copy];
		_text = [[dictionary objectForKey:@"text"] copy];
		
		_low = [[NSNumber alloc] initWithInt:[[dictionary objectForKey:@"low"] intValue]];
		_high = [[NSNumber alloc] initWithInt:[[dictionary objectForKey:@"high"] intValue]];
	}

	return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, date: <%@>, text: <%@>, low: <%@>, high: <%@>",
			[super description],
			[self date],
			[self text],
			[self low],
			[self high]];
}

@end
