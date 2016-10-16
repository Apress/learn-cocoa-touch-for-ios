//
//  PossessionListTableViewCell.h
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//


#import <UIKit/UIKit.h>


@class Possession;

@interface PossessionListTableViewCell : UITableViewCell

@property (strong, nonatomic) Possession *possession;

@end
