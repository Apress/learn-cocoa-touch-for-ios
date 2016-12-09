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


@interface PossessionListViewController() {
    NSMutableArray *_possessions;
}

- (void)addItemButtonPressed:(id)sender;
- (Possession *)possessionAtIndex:(NSUInteger)index;

@end

@implementation PossessionListViewController

#pragma mark - Object Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        Possession *iPhone = [[Possession alloc] init];
        [iPhone setName:@"iPhone 4S"];
        [iPhone setValue:[NSNumber numberWithInt:649]];
        
        Possession *iPad = [[Possession alloc] init];
        [iPad setName:@"iPad"];
        [iPad setValue:[NSNumber numberWithInt:499]];
        
        _possessions = [NSMutableArray arrayWithObjects:iPhone, iPad, nil];
        
        [self setTitle:@"My Stuff"];
        
        UIBarButtonItem *addItemButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addItemButtonPressed:)];
        [[self navigationItem] setRightBarButtonItem:addItemButton];
    }
    
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self tableView] reloadData];
}

#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    
    Possession *possession = [self possessionAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[possession name]];
    [[cell detailTextLabel] setText:[[possession value] stringValue]];
    
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
    }
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

@end
