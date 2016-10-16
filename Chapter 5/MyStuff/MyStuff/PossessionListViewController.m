//
//  PossessionListViewController.m
//  MyStuff
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "PossessionListViewController.h"

#import "Possession.h"
#import "PossessionDetailViewController.h"
#import "PossessionListTableViewCell.h"


@interface PossessionListViewController() {
    NSMutableArray *_possessions;
}

- (void)addItemButtonPressed:(id)sender;
- (Possession *)possessionAtIndex:(NSUInteger)index;
- (void)savePossessionsToDisk;
- (void)loadPossessionsFromDisk;
- (NSString *)possessionsArchivePath;

@end

@implementation PossessionListViewController

#pragma mark - Object Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
		[self loadPossessionsFromDisk];
        
        [self setTitle:@"My Stuff"];
        
        UIBarButtonItem *addItemButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addItemButtonPressed:)];
        [[self navigationItem] setRightBarButtonItem:addItemButton];
		
		[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[_possessions removeObjectAtIndex:[indexPath row]];
		
		NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
		[tableView deleteRowsAtIndexPaths:indexPaths
						 withRowAnimation:UITableViewRowAnimationAutomatic];
		
		[self savePossessionsToDisk];
	}
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	  toIndexPath:(NSIndexPath *)destinationIndexPath
{
	id movingObject = [_possessions objectAtIndex:[sourceIndexPath row]];
	
	[_possessions removeObjectAtIndex:[sourceIndexPath row]];
	[_possessions insertObject:movingObject atIndex:[destinationIndexPath row]];
	
	[self savePossessionsToDisk];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_possessions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"PossessionCell";
    
    PossessionListTableViewCell *cell = (PossessionListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PossessionListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
												  reuseIdentifier:cellIdentifier];
    }
	    
    Possession *possession = [self possessionAtIndex:[indexPath row]];
    
	[cell setPossession:possession];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - UITableViewDelegate Protocol Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PossessionDetailViewController *detailViewController =
    [[PossessionDetailViewController alloc] initWithNibName:nil
                                                     bundle:nil];
    
    [detailViewController setDelegate:self];
    
    [detailViewController setPossession:[self possessionAtIndex:[indexPath row]]];
    
    [[self navigationController] pushViewController:detailViewController
                                           animated:YES];
}

#pragma mark PossessionDetailViewControllerDelegate Protocol Methods

- (void)possessionDetailViewController:(PossessionDetailViewController *)detailViewController
                     didEditPossession:(Possession *)possession
{
    if ([_possessions containsObject:possession] == NO) {
        [_possessions addObject:possession];
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[_possessions indexOfObject:possession]
													   inSection:0];
		NSArray *indexPaths = [NSArray arrayWithObject:newIndexPath];
		
		[[self tableView] insertRowsAtIndexPaths:indexPaths
								withRowAnimation:UITableViewRowAnimationAutomatic];
    }
	
	[self savePossessionsToDisk];
}

#pragma mark -

- (void)addItemButtonPressed:(id)sender
{
    PossessionDetailViewController *detailViewController =
    [[PossessionDetailViewController alloc] initWithNibName:nil
                                                     bundle:nil];
        
    [detailViewController setDelegate:self];
    [detailViewController setModal:YES];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [self presentModalViewController:navigationController
                            animated:YES];
}

- (Possession *)possessionAtIndex:(NSUInteger)index
{
    return [_possessions objectAtIndex:index];
}

- (void)savePossessionsToDisk
{
	[NSKeyedArchiver archiveRootObject:_possessions
								toFile:[self possessionsArchivePath]];
}

- (void)loadPossessionsFromDisk
{
	_possessions = [NSKeyedUnarchiver unarchiveObjectWithFile:[self possessionsArchivePath]];
	
	if (_possessions == nil) {
		_possessions = [NSMutableArray array];
	}
}

- (NSString *)possessionsArchivePath
{
	NSString *documentsPath =
	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
										 NSUserDomainMask,
										 YES) objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:@"possessions.archive"];
}

@end
