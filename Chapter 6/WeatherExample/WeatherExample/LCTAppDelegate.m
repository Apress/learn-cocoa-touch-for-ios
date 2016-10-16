//
//  LCTAppDelegate.m
//  WeatherExample
//  Learn Cocoa Touch
//
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "LCTAppDelegate.h"

#import "LCTForecast.h"


@implementation LCTAppDelegate {
	NSMutableData *_receivedData;
	NSURLResponse *_receivedResponse;
	NSError *_connectionError;
	NSMutableArray *_forecasts;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	NSURL *weatherURL = [NSURL URLWithString:@"http://weather.yahooapis.com/forecastrss?p=48226"];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:weatherURL];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest
																  delegate:self];
	
	_receivedData = [[NSMutableData alloc] init];
	
	[connection start];
		
    return YES;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	_receivedResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	_connectionError = error;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Response: %@", _receivedResponse);
	
	NSString *receivedString = [[NSString alloc] initWithData:_receivedData
													 encoding:NSUTF8StringEncoding];
	
	NSLog(@"Body: %@", receivedString);
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_receivedData];
	[parser setDelegate:self];
	
	[parser parse];
}

#pragma mark - NSXMLParserDelegate Protocol Methods

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"yweather:forecast"]) {
		LCTForecast *forecast = [[LCTForecast alloc] initWithDictionary:attributeDict];
		[_forecasts addObject:forecast];
	}
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	_forecasts = [NSMutableArray array];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"%@", _forecasts);
}

#pragma mark -

@end
