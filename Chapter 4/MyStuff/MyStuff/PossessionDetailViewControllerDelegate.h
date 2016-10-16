//
//  PossessionDetailViewControllerDelegate.h
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Possession;
@class PossessionDetailViewController;

@protocol PossessionDetailViewControllerDelegate <NSObject>

@required

- (void)possessionDetailViewController:(PossessionDetailViewController *)detailViewController
                     didEditPossession:(Possession *)possession;

@end
