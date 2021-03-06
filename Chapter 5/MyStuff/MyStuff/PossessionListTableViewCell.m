//
//  PossessionListTableViewCell.m
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//


#import "PossessionListTableViewCell.h"

#import "Possession.h"


@implementation PossessionListTableViewCell {
	BOOL isObservingPossession;
}

@synthesize possession = _possession;

static NSString * const kPossessionImageKeyPath = @"image";
static NSString * const kPossessionNameKeyPath = @"name";
static NSString * const kPossessionValueKeyPath = @"value";

- (void)dealloc
{
	if (isObservingPossession == YES) {
		[_possession removeObserver:self forKeyPath:kPossessionImageKeyPath];
		[_possession removeObserver:self forKeyPath:kPossessionNameKeyPath];
		[_possession removeObserver:self forKeyPath:kPossessionValueKeyPath];
		isObservingPossession = NO;
	}
}

- (void)setPossession:(Possession *)possession
{
	if (isObservingPossession == YES) {
		[_possession removeObserver:self forKeyPath:kPossessionImageKeyPath];
		[_possession removeObserver:self forKeyPath:kPossessionNameKeyPath];
		[_possession removeObserver:self forKeyPath:kPossessionValueKeyPath];
		isObservingPossession = NO;
	}
	
	_possession = possession;
	
	if (_possession != nil) {
		[_possession addObserver:self
					  forKeyPath:kPossessionImageKeyPath
						 options:(NSKeyValueObservingOptionInitial |
								  NSKeyValueObservingOptionNew)
						 context:NULL];
		
		[_possession addObserver:self
					  forKeyPath:kPossessionNameKeyPath
						 options:(NSKeyValueObservingOptionInitial |
								  NSKeyValueObservingOptionNew)
						 context:NULL];
		
		[_possession addObserver:self
					  forKeyPath:kPossessionValueKeyPath
						 options:(NSKeyValueObservingOptionInitial |
								  NSKeyValueObservingOptionNew)
						 context:NULL];
		
		isObservingPossession = YES;
	}
}

- (void)prepareForReuse
{
	[self setPossession:nil];
	
	[super prepareForReuse];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	id newObject = [change objectForKey:NSKeyValueChangeNewKey];
	
	if ([newObject isKindOfClass:[NSNull class]]) {
		newObject = nil;
	}
	
	if (object == [self possession]) {
		if ([keyPath isEqualToString:kPossessionImageKeyPath]) {
			[[self imageView] setImage:newObject];
		}
		else if ([keyPath isEqualToString:kPossessionNameKeyPath]) {
			[[self textLabel] setText:newObject];
		}
		else if ([keyPath isEqualToString:kPossessionValueKeyPath]) {
			[[self detailTextLabel] setText:[newObject stringValue]];
		}
	}
}

@end
