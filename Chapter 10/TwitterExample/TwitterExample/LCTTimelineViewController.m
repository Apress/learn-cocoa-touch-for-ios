//
//  LCTTimelineViewController.m
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTTimelineViewController.h"

#import <Twitter/Twitter.h>

#import "LCTTwitterController.h"


@interface LCTTimelineViewController () {
	NSTimer *_reloadTimer;
	NSArray *_tweets;
	dispatch_queue_t _profileImageQueue;
	dispatch_semaphore_t _profileImageSemaphore;
}

@property (strong) UIFont *tweetFont;
@property (strong) UIFont *usernameFont;

- (void)reloadButtonPressed:(id)sender;
- (void)reloadTweets:(NSTimer *)reloadTimer;
- (void)tweetButtonPressed:(id)sender;

@end

@implementation LCTTimelineViewController

@synthesize tweetFont = _tweetFont;
@synthesize usernameFont = _usernameFont;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
	
    if (self) {
        [self setTitle:@"Timeline"];
		
		UIBarButtonItem *reloadButton =
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
													  target:self
													  action:@selector(reloadButtonPressed:)];
		[[self navigationItem] setLeftBarButtonItem:reloadButton];
		
		UIBarButtonItem *tweetButton =
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
													  target:self
													  action:@selector(tweetButtonPressed:)];
		[[self navigationItem] setRightBarButtonItem:tweetButton];
		
		_profileImageQueue = dispatch_queue_create("com.learncocoatouch.profileImageQueue",
												   DISPATCH_QUEUE_CONCURRENT);
		
		_profileImageSemaphore = dispatch_semaphore_create(3);
		
		_tweetFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:19.0f];
		_usernameFont = [UIFont italicSystemFontOfSize:14.0f];
    }
	
    return self;
}

- (void)dealloc
{
	dispatch_release(_profileImageQueue);
	dispatch_release(_profileImageSemaphore);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	LCTTwitterController *twitterController = [LCTTwitterController sharedInstance];
	
	NSString *title = [self title];
	
	[self setTitle:@"Authorizing…"];
	[twitterController authorizeAccountWithCompletionHandler:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self setTitle:@"Loading Tweets…"];
		});
		
		[twitterController getTweetsInUserTimelineWithCompletionHandler:^(NSArray *tweets) {
			_tweets = tweets;
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[self setTitle:title];
				[[self tableView] reloadData];
			});
		}];
	}];

	_reloadTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
													target:self
												  selector:@selector(reloadTweets:)
												  userInfo:nil
												   repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
	[_reloadTimer invalidate];
	_reloadTimer = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:CellIdentifier];
	}
    
    // Configure the cell...
	NSDictionary *tweet = [_tweets objectAtIndex:[indexPath row]];
	
	[[cell textLabel] setText:[tweet objectForKey:@"text"]];
	[[cell detailTextLabel] setText:[[tweet objectForKey:@"user"] objectForKey:@"name"]];
	
	NSString *profileImageURI = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
	NSURL *profileImageURL = [NSURL URLWithString:profileImageURI];
	
	NSURLRequest *profileImageURLRequest = [NSURLRequest requestWithURL:profileImageURL];
	
	dispatch_async(_profileImageQueue, ^{
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		dispatch_semaphore_wait(_profileImageSemaphore, DISPATCH_TIME_FOREVER);
		
		NSData *imageData = [NSURLConnection sendSynchronousRequest:profileImageURLRequest
												  returningResponse:&response
															  error:&error];
		
		dispatch_semaphore_signal(_profileImageSemaphore);
		
		UIImage *image = [UIImage imageWithData:imageData];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[[cell imageView] setImage:image];
			[cell setNeedsLayout];
		});
	});
	
	[[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
	[[cell textLabel] setNumberOfLines:0];
	[[cell textLabel] setTextColor:[UIColor whiteColor]];
	[[cell textLabel] setFont:[self tweetFont]];
	[[cell detailTextLabel] setTextColor:[UIColor whiteColor]];
	[[cell detailTextLabel] setFont:[self usernameFont]];

    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	
	if (row % 2) {
		[cell setBackgroundColor:[UIColor grayColor]];
	}
	else {
		[cell setBackgroundColor:[UIColor lightGrayColor]];
	}
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat maxWidth = 240.0f;
	
	NSDictionary *tweet = [_tweets objectAtIndex:[indexPath row]];
	
	NSString *tweetText = [tweet objectForKey:@"text"];
	NSString *tweetUsername = [[tweet objectForKey:@"user"] objectForKey:@"name"];
	
	// Get the height of the tweet over multiple lines
	CGSize tweetSizeConstraints = CGSizeMake(maxWidth, FLT_MAX);
	
	CGSize tweetSize = [tweetText sizeWithFont:[self tweetFont]
							 constrainedToSize:tweetSizeConstraints
								 lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat tweetHeight = tweetSize.height;
	
	// Get the height of the username on a single line
	CGSize usernameSize = [tweetUsername sizeWithFont:[self usernameFont]];
	CGFloat usernameHeight = usernameSize.height;
	
	return tweetHeight + usernameHeight + 8.0f;
}


- (void)reloadButtonPressed:(id)sender
{
	[[LCTTwitterController sharedInstance] getTweetsInUserTimelineWithCompletionHandler:^(NSArray *tweets) {
		_tweets = tweets;
		
		[[self tableView] performSelectorOnMainThread:@selector(reloadData)
										   withObject:nil
										waitUntilDone:NO];
	}];
}

- (void)reloadTweets:(NSTimer *)reloadTimer
{
	LCTTwitterController *twitterController = [LCTTwitterController sharedInstance];
	
	[twitterController getTweetsInUserTimelineWithCompletionHandler:^(NSArray *tweets) {
		_tweets = tweets;
		
		[[self tableView] performSelectorOnMainThread:@selector(reloadData)
										   withObject:nil
										waitUntilDone:NO];
	}];
}

- (void)tweetButtonPressed:(id)sender
{
	TWTweetComposeViewController *viewController =
	[[TWTweetComposeViewController alloc] init];
	
	[self presentModalViewController:viewController animated:YES];
}

@end
