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
