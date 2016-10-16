//
//  LCTGreaterThanGestureRecognizer.m
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTGreaterThanGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>


#define CGPointDistanceFromPoint(p1, p2) (sqrtf(powf((p2.x - p1.x), 2.0f) + powf((p2.y - p1.y), 2.0f)))

// The minimum amount a user's finger must move to trigger one half of the swipe.
static const CGFloat kMinimumSwipeDistance = 50.0f;


@implementation LCTGreaterThanGestureRecognizer {
	CGPoint _beginningPoint;
	CGPoint _midPoint;
	BOOL _receivedDownRightSwipe;
	BOOL _receivedDownLeftSwipe;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	_beginningPoint = [touch locationInView:[self view]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint newPoint = [touch locationInView:[self view]];
	
	if (_receivedDownRightSwipe == NO) {
		if (newPoint.x >= _beginningPoint.x &&
			newPoint.y >= _beginningPoint.y) {
			CGFloat distance = CGPointDistanceFromPoint(newPoint, _beginningPoint);
			
			if (distance >= kMinimumSwipeDistance) {
				_midPoint = newPoint;
				_receivedDownRightSwipe = YES;
			}
		}
		else {
			[self setState:UIGestureRecognizerStateFailed];
		}
	}
	else if (newPoint.x >= _midPoint.x &&
			 newPoint.y >= _midPoint.y) {
		// Still going in the original direction, don't start looking for new distance.
		_midPoint = newPoint;
	}
	else if (newPoint.x <= _midPoint.x &&
			 newPoint.y >= _midPoint.y) {
		CGFloat distance = CGPointDistanceFromPoint(newPoint, _midPoint);
		
		if (distance >= kMinimumSwipeDistance) {
			_receivedDownLeftSwipe = YES;
		}
	}
	else {
		[self setState:UIGestureRecognizerStateFailed];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_receivedDownRightSwipe && _receivedDownRightSwipe) {
		[self setState:UIGestureRecognizerStateRecognized];
	}
	else {
		[self setState:UIGestureRecognizerStateFailed];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self setState:UIGestureRecognizerStateFailed];	
}

- (void)reset
{
	[super reset];
	
	_beginningPoint = CGPointZero;
	_midPoint = CGPointZero;
	_receivedDownRightSwipe = NO;
}

@end
