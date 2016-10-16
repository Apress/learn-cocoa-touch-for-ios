//
//  Possession.h
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Possession : NSObject <NSCoding>

@property (strong) UIImage *image;
@property (copy) NSString *name;
@property (strong) NSNumber *value;

@end
