//
//  FlightViewController.m
//  MLE
//
//  Created by Mohamed Ashraf on 11/22/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FlightViewController.h"
#import "Flight.h"

@implementation FlightViewController
@synthesize flight;
@synthesize nibDetailCell;
@synthesize nibHeaderCell;
@synthesize headerBackground;
@synthesize tableView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	// VIEW TITLE AND NAV BUTTON
	
	self.title = self.flight.flightId;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];

	
	// VIEW HEADER SECTION
	
	UILabel *airlineNameLabel = (UILabel *) [self.view viewWithTag:1];
	UILabel *descriptionLabel = (UILabel *) [self.view viewWithTag:2];
	
	airlineNameLabel.text = self.flight.airlineName;
	airlineNameLabel.textColor = self.flight.foregroundColor;
	airlineNameLabel.shadowColor = self.flight.nameShadowColor;
	
	if (flight.inbound) {
		descriptionLabel.text = [NSString stringWithFormat:@"From %@ to Male'", self.flight.route];
	}
	else {
		descriptionLabel.text = [NSString stringWithFormat:@"From Male' to %@", self.flight.route];
	}
	descriptionLabel.textColor = self.flight.textColor;
	
	// VIEW HEADER STYLING
	
	self.headerBackground.backgroundColor = self.flight.backgroundColor;	
	self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	// THE RETURN VARIABLES ARE INCREMENTED BY 1
	// THIS ADDS AN ADDITIONAL ROW (FOR THE TITLE) TO EACH SECTION
	
	int result;
	switch (section) {
		case 0:
			if (self.flight.status == nil) {
				result = 2;
			}
			else {
				result = 3;
			}
			break; 
		case 1:
			if (self.flight.estimated == nil) {
				result = 3;				
			}
			else {
				result = 4;
			}
			break;
		case 2:
			result = 2;
			break;
	}
	return result;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];

	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor darkGrayColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:16];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0); // TO CENTER ALIGN
	// headerLabel.highlightedTextColor = [UIColor whiteColor]; // HIGHLIGHTED TEXT COLOR
	
	NSString *result;
	switch (section) {
		case 0:
			if (self.flight.status == nil) {
				result = [NSString stringWithString:@"Flight Number"];
			}
			else {
				result = [NSString stringWithString:@"Flight Status"];
			}			
			break;
		case 1:
			result = [NSString stringWithString:@"Flight Times"];
			break; 
		case 2:
			result = [NSString stringWithString:@"Push Notifications"];
			break;
	}
	
	headerLabel.text = result;
	[customView addSubview:headerLabel];
	
	return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}
 
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:self options:NULL];
	[[NSBundle mainBundle] loadNibNamed:@"DetailHeaderCell" owner:self options:NULL];
	UITableViewCell *cell = self.nibDetailCell;
	UITableViewCell *headerCell = self.nibHeaderCell;
	
	cell.userInteractionEnabled = NO;
    
	// SETUP LABEL DEFINITIONS
	
	UILabel *keyLabel = (UILabel *) [cell viewWithTag:1];	
	UILabel *valueLabel = (UILabel *) [cell viewWithTag:2];
	UILabel *headerLabel = (UILabel *) [headerCell viewWithTag:1];
	
	keyLabel.text = nil;
	valueLabel.text = nil;
	headerLabel.text = nil;
	
	// SET FIELD TEXTS
	
	switch (indexPath.section) {
			
		// FIRST SECTION: STATUS AND FLIGHT NUMBER
			
		case 0:
			switch (indexPath.row) {
				case 0:
					headerLabel.text = [NSString stringWithString:@"Flight Status"];
					cell = headerCell;
					break;
				case 1:
					keyLabel.text = [NSString stringWithString:@"Flight Number"];
					valueLabel.text = [NSString stringWithFormat:@"%@", self.flight.flightId];
					break;
				case 2:
					keyLabel.text = [NSString stringWithString:@"Status"];	
					valueLabel.text = [NSString stringWithFormat:@"%@", self.flight.status];
					
					break;
			}
			break;	
			
		// SECOND SECTION: TIMES
			
		case 1:
			switch (indexPath.row) {
				case 0:
					headerLabel.text = [NSString stringWithString:@"Flight Times"];
					cell = headerCell;
					break;
				case 1:
					cell.textLabel.text = self.flight.date;
					cell.textLabel.textAlignment = UITextAlignmentCenter;
					cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
					cell.textLabel.textColor = [UIColor whiteColor];
					cell.textLabel.shadowColor = [UIColor blackColor];
					break;
				case 2:
					keyLabel.text = [NSString stringWithString:@"Scheduled Time"];
					valueLabel.text = [NSString stringWithFormat:@"%@", self.flight.scheduled];
					break;
				case 3:
					keyLabel.text = [NSString stringWithString:@"Estimated Time"];
					valueLabel.text = [NSString stringWithFormat:@"%@", self.flight.estimated];
					break;
			}
			break;
			
		// THIRD SECTION: PUSH NOTIFICATIONS SECTION
			
		case 2:
			switch (indexPath.row) {
				case 0:
					headerLabel.text = [NSString stringWithString:@"Push Notifications"];
					cell = headerCell;
					break;
				case 1:
										
					// PUSH NOTIFICATIONS SWITCH CELL
					// REMOVE EXISTING LABELS (THE ONES SET IN THE XIB) FROM CELL
					
					[keyLabel removeFromSuperview];
					[valueLabel removeFromSuperview];
					
					
					// SET LABEL AND SWITCH
					
					cell.textLabel.text = @"Flight status alerts";
					cell.textLabel.textColor = [UIColor whiteColor];
					cell.textLabel.font = [UIFont systemFontOfSize:14];
					cell.textLabel.shadowColor = [UIColor blackColor];
					[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
					
					UISwitch *nSwitch = [[UISwitch alloc] init];
					nSwitch.tag = 9;
					cell.accessoryView = nSwitch;
					[nSwitch release];
					
					cell.userInteractionEnabled = YES;
					break;
			}						
			break;
	}
	
	// DONE, RETURN
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[nibHeaderCell release];
	[tableView release];
	[headerBackground release];
	[nibDetailCell release];
	[flight release];
    [super dealloc];
}


@end

