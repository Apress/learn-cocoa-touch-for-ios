//
//  Person.h
//  HelloWorld
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
	NSString *firstName;
	NSString *lastName;
	NSInteger	birthYear;
}

@property (nonatomic, copy) NSString *firstName;

@property (getter = isFoo) BOOL foo;

- (BOOL)isFoo;
- (void)setFoo:(BOOL)foo;

- (id)initWithFirstName:(NSString *)firstName
			   lastName:(NSString *)lastName
			  birthYear:(NSInteger)birthYear;

- (NSString *)displayName;

- (NSString *)lastName;
- (void)setLastName:(NSString *)lastName;
- (NSInteger)birthYear;
- (void)setBirthYear:(NSInteger)birthYear;

@end
