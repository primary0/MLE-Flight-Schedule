//
//  FlightSchedule.m
//  Airport
//
//  Created by Mohamed Ashraf on 11/9/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import "Schedule.h"
#import "TouchXML.h"
#import "Flight.h"
#import "UIColor+i7HexColor.h"

@implementation Schedule
@synthesize url;
@synthesize international;
@synthesize domestic;

-(void)populateInternationalAndDomesticSchedules:(NSMutableArray *)schedule {
	
	
	NSLog(@"Begin populating international and domestic");
	
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AirlineData" ofType:@"plist"];
	NSDictionary *colorsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	NSMutableArray *internationalArray = [[NSMutableArray alloc] init];
	NSMutableArray *domesticArray = [[NSMutableArray alloc] init];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	NSDate *date;
	
	for (NSMutableDictionary *flightDictionary in schedule) {
		
		NSLog(@"Processing flight");
		
		Flight *flight = [[Flight alloc] init];
		
		//
		//
		// FLIGHT DATA FIELDS (CLEAN STRING FIELDS)
		
		flight.airlineName	= [flightDictionary valueForKey:@"AirLineName"];
		flight.airlineId	= [flightDictionary valueForKey:@"AirLineID"];
		flight.flightId		= [flightDictionary valueForKey:@"FlightID"];
		flight.carrierType	= [flightDictionary valueForKey:@"CarrierType"];		
		
		//
		//
		// FLIGHT ROUTE
		
		flight.route = [[flightDictionary valueForKey:@"Route1"] stringByReplacingOccurrencesOfString:@"-" withString:@", "];	
		
		//
		//
		// FLIGHT SCHEDULED AND ESTIMATED TIME
		
		flight.scheduled	= [flightDictionary valueForKey:@"Scheduled"];
		flight.estimated	= [[flightDictionary valueForKey:@"Estimated"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		//
		//
		// FLIGHT DATE
				
		[dateFormat setDateFormat:@"yyyyMMdd"];
		date = [dateFormat dateFromString:[flightDictionary valueForKey:@"Date"]];		
		[dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
		flight.date = [NSString stringWithString:[dateFormat stringFromDate:date]];
		
		//
		//
		// FLIGHT COLOR FIELDS
		
		NSDictionary *colorsForCurrentFlight = [colorsDictionary objectForKey:[flightDictionary valueForKey:@"AirLineID"]];
		
		if (colorsForCurrentFlight != nil) {
			flight.backgroundColor	= [UIColor colorWithHexString:[colorsForCurrentFlight objectForKey:@"Background"]];
			flight.foregroundColor	= [UIColor colorWithHexString:[colorsForCurrentFlight objectForKey:@"Foreground"]];
			flight.textColor		= [UIColor colorWithHexString:[colorsForCurrentFlight objectForKey:@"Text"]];	
			flight.nameShadowColor	= [UIColor colorWithHexString:[colorsForCurrentFlight objectForKey:@"Shadow"]];
			
			if ([colorsForCurrentFlight objectForKey:@"TimeShadow"] != nil) {
				flight.timeShadowColor = [UIColor colorWithHexString:[colorsForCurrentFlight objectForKey:@"TimeShadow"]];
			}
			else {
				flight.timeShadowColor = [UIColor colorWithHexString:[colorsForCurrentFlight objectForKey:@"Shadow"]];
			}
		}
		else {						
			flight.backgroundColor	= [UIColor whiteColor];
			flight.foregroundColor	= [UIColor blackColor];
			flight.textColor		= [UIColor blackColor];
			flight.nameShadowColor	= [UIColor whiteColor];
			flight.timeShadowColor	= [UIColor whiteColor];
		}
		
		//		
		//				
		// ADD PROPER AIRLINE NAME FROM DATA FILE, IF PRESENT
		// XML FEED GIVE NAME WAS ASSIGNED EARLIER!
		
		if ([colorsForCurrentFlight objectForKey:@"Name"] != nil) {
			flight.airlineName = [colorsForCurrentFlight objectForKey:@"Name"];
		}
		
		//
		//
		// WRITE FLIGHT STATUS
		
		NSString *statusCode = [[NSString alloc] initWithString:[flightDictionary valueForKey:@"Status"]];
		
		if ([statusCode isEqualToString:@"LA"]) {
			flight.status = [NSString stringWithString:@"Landed"];		
		}
		else if ([statusCode isEqualToString:@"FZ"]) {
			flight.status = [NSString stringWithString:@"Closed"];
		}
		else if ([statusCode isEqualToString:@"BO"]) {
			flight.status = [NSString stringWithString:@"Boarding"];
		}
		else if ([statusCode isEqualToString:@"DP"]) {
			flight.status = [NSString stringWithString:@"Departed"];
		}	
		else if ([statusCode isEqualToString:@"FC"]) {
			flight.status = [NSString stringWithString:@"Final Call"];
		}
		
		[statusCode release];
		
		//
		//
		// CATEGORIZE INTO DOMESSTIC AND INTERNATIONAL
		
		if ([flight.carrierType isEqualToString:@"I"]) {
			[internationalArray addObject:flight];		
		}
		else if ([flight.carrierType isEqualToString:@"D"]) {
			[domesticArray addObject:flight];
		}
		
		//
		//
		// DONE, RELEASE		
		[flight release];
	}	
	
	self.international = internationalArray;
	self.domestic = domesticArray;
	
	[dateFormat autorelease];
	[internationalArray release];
	[domesticArray release];
	
	NSLog(@"Done populating domestic and internation arrays");
}

-(NSMutableArray *)sortScheduleByTime:(NSMutableArray *)schedule {
	
	
	NSLog(@"Begin sorting schedule");
	
	NSMutableArray *result = [[NSMutableArray alloc] init];
	NSString *currentDate = [[NSString alloc] init];	
	NSMutableArray *currentArray;	
	
	NSLog(@"Allocated sort stuff");
	
	int counter;
	for (counter = 0; counter < schedule.count; counter++) {
		
		Flight *flight = [schedule objectAtIndex:counter];
		
		if (![currentDate isEqualToString:flight.date]) {	
			
			NSLog(@"Found a new date... ");
			
			NSMutableArray *newArray = [[NSMutableArray alloc] init];
			[newArray addObject:flight];
			
			NSLog(@"Added flight to date array");
			
			[result addObject:newArray];
			currentArray = newArray;
			[newArray release];
			currentDate = [[NSString stringWithString:flight.date] retain];
		}
		else {
			[currentArray addObject:flight];
			NSLog(@"Added flight to existing date array");
		}
	}
	
	[currentDate release];
	
	return [result autorelease];
	
	NSLog(@"Done sorting and sectioning schedule");
}

-(void)parseData:(NSData *)xmlData {
	
	NSLog(@"Parsing data now...");
	
	CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithData:xmlData options:0 error:nil] autorelease];
	
	NSArray *nodes = NULL;
	nodes = [rssParser nodesForXPath:@"//Flight" error:nil];
	
	NSMutableArray *tempSchedule = [[[NSMutableArray alloc] init] autorelease];
	
	for (CXMLElement *element in nodes) {		
		NSMutableDictionary *flight = [[NSMutableDictionary alloc] init];			
		int counter;
		for(counter = 0; counter < [element childCount]; counter++) {
			[flight setObject:[[element childAtIndex:counter] stringValue] forKey:[[element childAtIndex:counter] name]];
		}
		[tempSchedule addObject:flight];				
		[flight release];
		NSLog(@"Element processed");
	}
	
	//
	//
	// POPULATE INTERNATIONAL AND DOMESTIC ARRAYS
	
	[self populateInternationalAndDomesticSchedules:tempSchedule];
	
	//
	//
	// REASSIGN INTERNATIONAL ARRAY TO SORTED/SECTIONED ARRAY
	
	self.international = [self sortScheduleByTime:self.international];
	
	NSLog(@"International array populated and sorted");
	
	//
	//
	// REASSIGN DOMESTIC ARRAY TO SORTED/SECTIONED ARRAY
	
	self.domestic = [self sortScheduleByTime:self.domestic];
	
	NSLog(@"Domestic array populated and sorted");
}

-(void)dealloc {
	
	[international release];
	[domestic release];
	[url release];
	[super dealloc];
}

@end
