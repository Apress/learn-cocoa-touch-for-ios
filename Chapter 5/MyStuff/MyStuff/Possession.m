//
//  Possession.m
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "Possession.h"

static NSString * const kNameKey = @"name";
static NSString * const kValueKey = @"value";

@implementation Possession

@synthesize image;
@synthesize name;
@synthesize value;

#pragma mark - NSCoding Protocol Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [self init];
	
	if (self) {
		[self setName:[aDecoder decodeObjectForKey:kNameKey]];
		[self setValue:[aDecoder decodeObjectForKey:kValueKey]];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:[self name]
				  forKey:kNameKey];
	[aCoder encodeObject:[self value]
				  forKey:kValueKey];
}

#pragma mark -

@end
