//
//  LCTViewController.m
//  TitularSongs
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface LCTViewController () {
	NSArray *_songs;
}

@end

@implementation LCTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	MPMediaQuery *mediaQuery = [MPMediaQuery songsQuery];
	
	// Iterate through songs, figuring out if they share a title with their album. If
	// they do, add them to an array.
	NSMutableArray *matchingSongs = [[NSMutableArray alloc] init];
	
	// Create a block called on each item; it will add the item to the array if it meets
	// our criteria.
	void (^songBlock)(id, NSUInteger, BOOL *) = ^(id obj, NSUInteger idx, BOOL *stop) {
		MPMediaItem *song = (MPMediaItem *)obj;
		NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
		NSString *albumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
		
		if ([songTitle isEqualToString:albumTitle]) {
			@synchronized(matchingSongs) {
				[matchingSongs addObject:song];
			}
		}
	};
	
	// Iterate through the items in the query, calling songBlock with each.	
	[[mediaQuery items] enumerateObjectsWithOptions:NSEnumerationConcurrent
										 usingBlock:songBlock];
	
	// Now that we have the data, store it in the _songs variable.
	_songs = [NSArray arrayWithArray:matchingSongs];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"songCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:cellIdentifier];
	}
	
	MPMediaItem *song = [_songs objectAtIndex:[indexPath row]];
	
	[[cell textLabel] setText:[song valueForProperty:MPMediaItemPropertyTitle]];
	[[cell detailTextLabel] setText:[song valueForProperty:MPMediaItemPropertyArtist]];
	
	MPMediaItemArtwork *albumArt = [song valueForProperty:MPMediaItemPropertyArtwork];
	CGSize imageSize = CGSizeMake([tableView rowHeight], [tableView rowHeight]);
	
	[[cell imageView] setImage:[albumArt imageWithSize:imageSize]];
	
	return cell;
}

#pragma mark - UITableViewDelegate Protocol Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	MPMediaItem *song = [_songs objectAtIndex:[indexPath row]];
	
	NSArray *items = [NSArray arrayWithObject:song];
	
	MPMediaItemCollection *itemCollection =
	[MPMediaItemCollection collectionWithItems:items];
	
	[[MPMusicPlayerController iPodMusicPlayer]
	 setQueueWithItemCollection:itemCollection];
	
	[[MPMusicPlayerController iPodMusicPlayer] play];
}

#pragma mark -

@end
