//
//  Possession.m
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "Possession.h"

@implementation Possession

@synthesize name;
@synthesize value;

#pragma mark - NSCoding Protocol Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [self init];
	
	if (self) {
		[self setName:[aDecoder decodeObjectForKey:@"name"]];
		[self setValue:[aDecoder decodeObjectForKey:@"value"]];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:[self name]
				  forKey:@"name"];
	[aCoder encodeObject:[self value]
				  forKey:@"value"];
}

#pragma mark -

@end
