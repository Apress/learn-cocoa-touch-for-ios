//
//  LCTTwitterController.m
//  TwitterExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTTwitterController.h"

#import <Accounts/Accounts.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Twitter/Twitter.h>

#import "LCTTweet.h"

static NSString * const kSavedTwitterAccountKey = @"SavedTwitterAccount";

@implementation LCTTwitterController {
	ACAccountStore *_accountStore;
	ACAccount *_twitterAccount;
}

+ (id)sharedInstance
{
	static id _sharedInstance = nil;
	
	if (_sharedInstance == nil) {
		_sharedInstance = [[self alloc] init];
	}
	
	return _sharedInstance;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		_accountStore = [[ACAccountStore alloc] init];
		
		// If we've previously saved the account, load it now.
		NSString *accountId = [[NSUserDefaults standardUserDefaults] stringForKey:kSavedTwitterAccountKey];
		
		if (accountId) {
			_twitterAccount = [_accountStore accountWithIdentifier:accountId];
		}

	}
	
	return self;
}

- (void)authorizeAccountWithCompletionHandler:(void (^)(void))handler
{
	if (_twitterAccount == nil) {
		ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		[_accountStore requestAccessToAccountsWithType:accountType 
								 withCompletionHandler:^(BOOL granted, NSError *error) {
									 if (granted) {
										 NSArray *twitterAccounts =
										 [_accountStore accountsWithAccountType:accountType];
										 
										 if ([twitterAccounts count] > 0) {
											 _twitterAccount =
											 [twitterAccounts objectAtIndex:0];
											 
											 NSString *identifier =
											 [_twitterAccount identifier];
											 
											 [userDefaults setObject:identifier
															  forKey:kSavedTwitterAccountKey];
											 [userDefaults synchronize];
										 }
									 }
									 
									 if (handler != NULL) {
										 handler();
									 }
								 }];
	}
	else {
		if (handler != NULL) {
			handler();
		}
	}
}

// https://api.twitter.com/1/statuses/home_timeline.json

- (void)getTweetsInUserTimelineWithCompletionHandler:(void(^)(NSArray *tweets))handler
{
	NSString *timelinePath = @"https://api.twitter.com/1/statuses/home_timeline.json";
	NSURL *timelineURL = [NSURL URLWithString:timelinePath];
	
	TWRequest *timelineRequest = [[TWRequest alloc] initWithURL:timelineURL
													 parameters:nil
												  requestMethod:TWRequestMethodGET];
	
	[timelineRequest setAccount:_twitterAccount];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	[timelineRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

		if (responseData) {
			id topLevelObject = [NSJSONSerialization JSONObjectWithData:responseData
																options:0
																  error:NULL];
			
			if ([topLevelObject isKindOfClass:[NSArray class]]) {
				if (handler != NULL) {
					handler(topLevelObject);
				}
			}
		}
	}];
}

- (void)getTweetsNearStreetAddress:(NSString *)streetAddress
					  searchRadius:(NSUInteger)searchRadiusInMeters
				 completionHandler:(void (^)(NSArray *))handler
{
	// Geocode the address
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	
	[geocoder geocodeAddressString:streetAddress
				 completionHandler:^(NSArray *placemarks,
									 NSError *error) {
		if ([placemarks count] > 0) {
			CLPlacemark *placemark = [placemarks objectAtIndex:0];
			
			CLLocation *location = [placemark location];
			
			if (location != nil) {
				// Now that we have the address, we can search Twitter.
				[self getTweetsNearLocation:location
							   searchRadius:searchRadiusInMeters
						  completionHandler:handler];
			}
		}
		else {
			NSLog(@"Error geocoding %@: %@", streetAddress, error);
		}
	}];
}

- (void)getTweetsNearLocation:(CLLocation *)location
				 searchRadius:(NSUInteger)searchRadiusInMeters
			completionHandler:(void (^)(NSArray *))handler
{
	NSString *searchURI =
	[NSString stringWithFormat:
	 @"http://search.twitter.com/search.json?geocode=%f,%f,%fkm",
	 [location coordinate].latitude,
	 [location coordinate].longitude,
	 (float)searchRadiusInMeters / 1000.0f];
	
	NSURL *searchURL = [NSURL URLWithString:searchURI];
	
	TWRequest *searchRequest = [[TWRequest alloc] initWithURL:searchURL
												   parameters:nil
												requestMethod:TWRequestMethodGET];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	[searchRequest performRequestWithHandler:^(NSData *responseData,
											   NSHTTPURLResponse *response,
											   NSError *error) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		if (responseData) {
			id topLevelObject = [NSJSONSerialization JSONObjectWithData:responseData
																options:0
																  error:NULL];
			
			if ([topLevelObject isKindOfClass:[NSDictionary class]]) {
				NSArray *results = [topLevelObject objectForKey:@"results"];
				
				if ([results isKindOfClass:[NSArray class]] && [results count] > 0) {
					NSMutableArray *tweets = [NSMutableArray array];
					
					for (NSDictionary *tweetDict in results) {
						LCTTweet *tweet = [[LCTTweet alloc] init];
						[tweet setText:[tweetDict objectForKey:@"text"]];
						
						[tweet setUsername:
						 [tweetDict objectForKey:@"from_user_name"]];
						
						// Not every tweet has an exact location.
						NSDictionary *geoDict = [tweetDict objectForKey:@"geo"];
						if ([geoDict isKindOfClass:[NSDictionary class]]) {
							NSArray *coords = [geoDict objectForKey:@"coordinates"];
							float latitude = [[coords objectAtIndex:0] floatValue];
							float longitude = [[coords objectAtIndex:1] floatValue];
							
							CLLocation *location =
							[[CLLocation alloc] initWithLatitude:latitude
													   longitude:longitude];
							
							[tweet setLocation:location];
						}
						else {
							// Here, location is the location received from the geocoder
							[tweet setLocation:location];
						}
						
						[tweets addObject:tweet];
					}
					
					if (handler != NULL) {
						handler(tweets);
					}
				}
				else {
					NSLog(@"No results.");
				}
			}
		}
		else {
			NSLog(@"Error searching: %@", error);
		}
	}];
}

@end
