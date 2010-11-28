//
//  Flight.m
//  MLE
//
//  Created by Mohamed Ashraf on 11/18/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import "Flight.h"


@implementation Flight

@synthesize airlineId;
@synthesize airlineName;
@synthesize flightId;
@synthesize route;	
@synthesize scheduled;
@synthesize estimated;
@synthesize status;
@synthesize date;
@synthesize carrierType;
@synthesize backgroundColor;
@synthesize foregroundColor;
@synthesize textColor;
@synthesize nameShadowColor;
@synthesize timeShadowColor;
@synthesize inbound;
@synthesize favorite;

#pragma mark -
#pragma mark Class Methods

+ (BOOL)isFavorite:(NSString *)flightNumber {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *favoritesFile = [documentsDirectoryPath stringByAppendingPathComponent:@"favorites.plist"];	
	NSMutableDictionary *favoritesDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:favoritesFile];
	BOOL result;
	if ([favoritesDictionary objectForKey:flightNumber] != nil) {
		result = YES;
	}
	else {
		result = NO;
	}

	return result;
}

#pragma mark -
#pragma mark PLIST File Update Methods

- (void)updateFavoritesFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *favoritesFile = [documentsDirectoryPath stringByAppendingPathComponent:@"favorites.plist"];
	NSMutableDictionary *favoritesDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:favoritesFile];
	
	if (favoritesDictionary == nil) {
		favoritesDictionary = [[NSMutableDictionary alloc] init];
	}
	
	NSMutableDictionary *thisFlight = [[NSMutableDictionary alloc] init];
	[thisFlight setObject:self.airlineId forKey:@"airlineId"];	
	[thisFlight setObject:self.airlineName forKey:@"airlineName"];
	NSLog(@"%@", self.airlineName);
	[thisFlight setObject:self.flightId forKey:@"flightId"];
	[thisFlight setObject:self.route forKey:@"route"];
	[thisFlight setObject:self.scheduled forKey:@"scheduled"];
	if (self.estimated != nil) {
		[thisFlight setObject:self.estimated forKey:@"estimated"];
	}	
	if (self.status != nil) {
		[thisFlight setObject:self.status forKey:@"status"];
	}
	[thisFlight setObject:self.date forKey:@"date"];
	[thisFlight setObject:self.carrierType forKey:@"carrierType"];
	[thisFlight setObject:[NSNumber numberWithBool:self.inbound] forKey:@"inbound"];
	[thisFlight setObject:[NSNumber numberWithBool:self.favorite] forKey:@"favorite"];

	NSLog(@"This flight: %d", [thisFlight count]);
	
	[favoritesDictionary removeObjectForKey:self.flightId];
	NSLog(@"%d", [favoritesDictionary count]);
	
	if (self.favorite == YES) {
		[favoritesDictionary setObject:thisFlight forKey:self.flightId];
		NSLog(@"Set favorite");
	}
	
	NSLog(@"%d", [favoritesDictionary count]);	
	[favoritesDictionary writeToFile:favoritesFile atomically:YES];
	NSLog(@"%d", [favoritesDictionary count]);		
	[thisFlight release];
}

#pragma mark -
#pragma mark Settings Favorite Method

- (void)toggleFavorite {
	
	if (self.favorite) {
		self.favorite = NO;
	}
	else {
		self.favorite = YES;
	}
	
	[self updateFavoritesFile];
}

#pragma mark -
#pragma mark Memory management

-(void)dealloc {
	
	[airlineId release];
	[airlineName release];
	[flightId release];
	[route release];
	[scheduled release];
	[estimated release];
	[status release];
	[date release];
	[carrierType release];
	[backgroundColor release];
	[foregroundColor release];
	[textColor release];
	[nameShadowColor release];
	[timeShadowColor release];
	[super dealloc];
}


@end
