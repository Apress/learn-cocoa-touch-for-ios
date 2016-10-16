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
	NSArray *_tweets;
}

- (void)reloadButtonPressed:(id)sender;
- (void)tweetButtonPressed:(id)sender;

@end

@implementation LCTTimelineViewController

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
    }
	
    return self;
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
		[self performSelectorOnMainThread:@selector(setTitle:)
							   withObject:@"Loading Tweets…"
							waitUntilDone:NO];

		[twitterController getTweetsInUserTimelineWithCompletionHandler:^(NSArray *tweets) {
			[self performSelectorOnMainThread:@selector(setTitle:)
								   withObject:title
								waitUntilDone:NO];

			_tweets = tweets;
			
			[[self tableView] performSelectorOnMainThread:@selector(reloadData)
											   withObject:nil
											waitUntilDone:NO];
		}];
	}];
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
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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

- (void)tweetButtonPressed:(id)sender
{
	TWTweetComposeViewController *viewController =
	[[TWTweetComposeViewController alloc] init];
	
	[self presentModalViewController:viewController animated:YES];
}

@end
