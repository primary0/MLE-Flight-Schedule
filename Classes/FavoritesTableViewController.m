//
//  FavoritesViewController.m
//  MLE
//
//  Created by Mohamed Ashraf on 11/27/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "Flight.h"
#import "UIColor+i7HexColor.h"

@implementation FavoritesTableViewController

@synthesize flights;
@synthesize nibLoadedCell;
@synthesize navigationBar;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	NSMutableArray *flightsArray = [[[NSMutableArray alloc] init] autorelease];
	self.flights = flightsArray;
	
	// FAVORITES FILE
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *favoritesFile = [documentsDirectoryPath stringByAppendingPathComponent:@"favorites.plist"];	
	NSMutableDictionary *flightsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:favoritesFile];
	
	// COLORS FILE
	
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AirlineData" ofType:@"plist"];
	NSDictionary *colorsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];	
	
	// LOOP
	NSArray *flightsDictionaryKeys = [flightsDictionary allKeys];
	
	if (flightsDictionary != nil) {
		for(NSString *key in flightsDictionaryKeys) {
			Flight *flight = [[Flight alloc] init];
			NSMutableDictionary *currentFlight = [flightsDictionary objectForKey:key];
			flight.airlineId = [currentFlight objectForKey:@"airlineId"];
			flight.airlineName = [NSString stringWithString:[currentFlight objectForKey:@"airlineName"]];
			flight.flightId = [currentFlight objectForKey:@"flightId"];
			flight.route = [currentFlight objectForKey:@"route"];
			flight.scheduled = [currentFlight objectForKey:@"scheduled"];
			if ([currentFlight objectForKey:@"estimated"]) {
				flight.estimated = [currentFlight objectForKey:@"estimated"];
			}
			if ([currentFlight objectForKey:@"status"]) {
				flight.status = [currentFlight objectForKey:@"status"];
			}						
			flight.date = [currentFlight objectForKey:@"date"];
			flight.carrierType = [currentFlight objectForKey:@"carrierType"];
			flight.inbound = [[currentFlight objectForKey:@"inbound"] boolValue];
			flight.favorite = [[currentFlight objectForKey:@"favorite"] boolValue];
			
			
			NSDictionary *colorsForCurrentFlight = [colorsDictionary objectForKey:[currentFlight valueForKey:@"flightId"]];
			
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
				flight.foregroundColor	= [UIColor darkGrayColor];
				flight.textColor		= [UIColor darkGrayColor];
				flight.nameShadowColor	= [UIColor whiteColor];
				flight.timeShadowColor	= [UIColor whiteColor];
			}						
			
			[self.flights addObject:flight];
			[flight release];
		}
	}	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.flights count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"FlightCell" owner:self options:NULL];
		cell = self.nibLoadedCell;
    }
	
	// ASSIGN FLIGHT OBJECT
	
	Flight *flight;
	flight = [self.flights objectAtIndex:indexPath.row];
	
	// SETUP LABEL DEFINITIONS
	
	//RRSGlowLabel *nameLabel = (RRSGlowLabel *) [cell viewWithTag:1]; // DECLARATION FOR GLOW EFFECT
	UILabel *nameLabel = (UILabel *) [cell viewWithTag:1];	
	UILabel *flightNumberLabel = (UILabel *) [cell viewWithTag:2];
	UILabel *routeLabel = (UILabel *) [cell viewWithTag:3];
	UILabel *timeLabel = (UILabel *) [cell viewWithTag:4];
	UILabel *statusLabel = (UILabel *) [cell viewWithTag:5];
	
	nameLabel.text = nil;
	flightNumberLabel.text = nil;
	routeLabel.text = nil;
	timeLabel.text = nil;
	statusLabel.text = nil;
	
	// FLIGHT NUMBER
	
	flightNumberLabel.text = flight.flightId;	
	
	// ROUTE
	
	routeLabel.text = flight.route;
	
	// TIMES
	
	if (flight.estimated == nil) {
		timeLabel.text = flight.scheduled;
	}
	else {
		timeLabel.text = flight.estimated;
		statusLabel.text = [NSString stringWithString:@"Estimated"];
	}	
	
	// FLIGHT STATUS
	
	if (flight.status != nil) {
		statusLabel.text = timeLabel.text;
		timeLabel.text = flight.status;
	}
	
	// COLORS
	
	nameLabel.textColor			= flight.foregroundColor;
	flightNumberLabel.textColor = flight.textColor;
	routeLabel.textColor		= flight.textColor;
	timeLabel.textColor			= flight.textColor;
	statusLabel.textColor		= flight.textColor;
	nameLabel.shadowColor		= flight.nameShadowColor;	
	timeLabel.shadowColor		= flight.timeShadowColor;	
	statusLabel.shadowColor		= flight.timeShadowColor;
	
	// SETTING BEFORE ENABLING GLOW EFFECT
	// nameLabel.shadowColor = nil; 
	
	
	// AIRLINE NAME
	
	nameLabel.text = flight.airlineName;
	
	// TEXT GLOW
	// MUST FIRST CHANGE LABEL CLAS TO RRSGlowLabel
	//
	// nameLabel.glowColor = nameLabel.textColor;
	// nameLabel.glowOffset = CGSizeMake(0.0, 0.0);
    // nameLabel.glowAmount = 0.5;	
	
	// DONE, RETURN
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	Flight *flight;
	flight = [self.flights objectAtIndex:indexPath.row];	
	cell.backgroundColor = flight.backgroundColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.flights = nil;
}

- (void)dealloc {
	[navigationBar release];
	[nibLoadedCell release];
	[flights release];
    [super dealloc];
}


@end

