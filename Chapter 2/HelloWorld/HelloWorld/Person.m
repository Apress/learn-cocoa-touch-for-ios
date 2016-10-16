//
//  Person.m
//  HelloWorld
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize firstName;


- (id)initWithFirstName:(NSString *)fName
			   lastName:(NSString *)lName
			  birthYear:(NSInteger)bYear
{
	self = [super init];
	
	if (self) {
		firstName = fName;
		lastName = lName;
		birthYear = bYear;
	}
	
	return self;
}

- (NSString *)displayName
{
	return [NSString stringWithFormat:@"%@, %@", lastName, firstName];
}

- (NSString *)lastName
{
	return lastName;
}

- (NSInteger)birthYear
{
	return birthYear;
}

- (void)setLastName:(NSString *)name
{
	lastName = name;
}

- (void)setBirthYear:(NSInteger)year
{
	birthYear = year;
}

@end
