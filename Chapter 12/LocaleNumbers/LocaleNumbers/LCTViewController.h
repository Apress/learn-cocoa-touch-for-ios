//
//  LCTViewController.h
//  LocaleNumbers
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *noStyleLabel;
@property (strong, nonatomic) IBOutlet UILabel *decimalStyleLabel;
@property (strong, nonatomic) IBOutlet UILabel *currencyStyleLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentStyleLabel;
@property (strong, nonatomic) IBOutlet UILabel *scientificStyleLabel;
@property (strong, nonatomic) IBOutlet UILabel *spellOutStyleLabel;

@end
