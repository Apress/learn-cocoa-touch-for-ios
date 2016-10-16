//
//  LCTViewController.m
//  RedditSlideshow
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTViewController.h"

static const NSTimeInterval kPictureDisplayTime = 5.0;

@interface LCTViewController () {
    NSUInteger _currentImageIndex;
}

@property (strong) NSMutableArray *imageURLs;
@property (strong) UIImageView *imageView;

- (void)parseJSONData:(NSData *)jsonData;
- (void)startSlideshow;
- (void)loadNextImageInSlideshow;

@end

@implementation LCTViewController

@synthesize imageURLs = _imageURLs;
@synthesize imageView = _imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	NSURL *redditURL = [NSURL URLWithString:@"http://www.reddit.com/r/aww/.json"];
	NSURLRequest *redditURLRequest = [NSURLRequest requestWithURL:redditURL];
	
	[NSURLConnection sendAsynchronousRequest:redditURLRequest
									   queue:[NSOperationQueue currentQueue]
						   completionHandler:^(NSURLResponse *response,
											   NSData *data,
											   NSError *error) {
							   if (data != nil) {
								   [self parseJSONData:data];
								   [self startSlideshow];
							   }
							   else {
								   NSLog(@"Error loading JSON: %@", [error localizedDescription]);
							   }
						   }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

- (void)parseJSONData:(NSData *)jsonData
{
	NSLog(@"%@", [[NSSet set] anyObject]);
	
	[self setImageURLs:[NSMutableArray array]];
	
	NSError *parseError = nil;
	
	id returnedObject = [NSJSONSerialization JSONObjectWithData:jsonData
														options:0
														  error:&parseError];
	
	if (returnedObject != nil) {
		if ([returnedObject isKindOfClass:[NSDictionary class]]) {
			NSDictionary *data = [returnedObject objectForKey:@"data"];
			
			NSArray *children = [data objectForKey:@"children"];
			
			for (NSDictionary *childDict in children) {
				NSString *url = [[childDict objectForKey:@"data"] objectForKey:@"url"];
				
				// Is this an image?
				if ([url hasSuffix:@".png"] ||
					[url hasSuffix:@".jpg"] ||
					[url hasSuffix:@".jpeg"] ||
					[url hasSuffix:@"gif"]) {
					NSURL *imageURL = [NSURL URLWithString:url];
					[[self imageURLs] addObject:imageURL];
				}
			}
		}
	}
	else {
		NSLog(@"Error parsing data: %@", parseError);
	}
}

- (void)startSlideshow
{
	if ([[self imageURLs] count] == 0) {
		return;
	}
	
	// Create an activity indicator view to indicate to the user that the content is loading.
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	CGRect activityIndicatorFrame = [activityIndicatorView frame];
	activityIndicatorFrame.origin = CGPointMake(floorf((CGRectGetWidth([[self view] bounds]) + CGRectGetWidth(activityIndicatorFrame)) / 2.0f),
												floorf((CGRectGetHeight([[self view] bounds]) + CGRectGetHeight(activityIndicatorFrame)) / 2.0f));
	[activityIndicatorView setFrame:activityIndicatorFrame];
	[[self view] addSubview:activityIndicatorView];
	[activityIndicatorView startAnimating];
	
	// Load the first image
    _currentImageIndex = 0;
	NSURL *firstURL = [[self imageURLs] objectAtIndex:0];
	NSURLRequest *firstImageRequest = [NSURLRequest requestWithURL:firstURL];
	
	[NSURLConnection sendAsynchronousRequest:firstImageRequest
									   queue:[NSOperationQueue currentQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
							   UIImage *image = [UIImage imageWithData:data];
							   
							   if (image == nil) {
								   return;
							   }
							   
							   UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
							   
							   [imageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
															   UIViewAutoresizingFlexibleHeight)];
							   [imageView setContentMode:UIViewContentModeScaleAspectFit];
							   
							   [imageView setFrame:[[self view] bounds]];
							   [[self view] addSubview:imageView];
							   [activityIndicatorView removeFromSuperview];
							   
							   [self setImageView:imageView];

							   int64_t popTime =
							   kPictureDisplayTime * NSEC_PER_SEC;
							   
							   dispatch_time_t nextPictureLoadDelay =
							   dispatch_time(DISPATCH_TIME_NOW,
											 popTime);
							   
							   dispatch_after(nextPictureLoadDelay,
											  dispatch_get_main_queue(),
											  ^{
												  [self loadNextImageInSlideshow];
											  });
						   }];
}

- (void)loadNextImageInSlideshow
{
	_currentImageIndex += 1;
	
	if (_currentImageIndex >= [[self imageURLs] count]) {
		return;
	}
	
	NSURL *imageURL = [[self imageURLs] objectAtIndex:_currentImageIndex];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];
	
	[NSURLConnection sendAsynchronousRequest:urlRequest
									   queue:[NSOperationQueue currentQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
							   UIImage *image = [UIImage imageWithData:data];
							   
							   if (image == nil) {
								   return;
							   }
							   
							   UIImageView *nextImageView = [[UIImageView alloc] initWithImage:image];
							   
							   [nextImageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
															   UIViewAutoresizingFlexibleHeight)];
							   [nextImageView setContentMode:UIViewContentModeScaleAspectFit];
							   
							   [nextImageView setFrame:[[self view] bounds]];
							   [nextImageView setAlpha:0.0f];
							   
							   [[self view] addSubview:nextImageView];
							   
							   [UIView animateWithDuration:1.0
												animations:^{
													[[self imageView] setAlpha:0.0f];
													[nextImageView setAlpha:1.0f];
												}
												completion:^(BOOL finished) {
													[[self imageView] removeFromSuperview];
													[self setImageView:nextImageView];
												}];
							   
							   int64_t popTime =
							   kPictureDisplayTime * NSEC_PER_SEC;
							   
							   dispatch_time_t nextPictureLoadDelay =
							   dispatch_time(DISPATCH_TIME_NOW,
											 popTime);
							   
							   dispatch_after(nextPictureLoadDelay,
											  dispatch_get_main_queue(),
											  ^{
												  [self loadNextImageInSlideshow];
											  });

						   }];
}

@end
