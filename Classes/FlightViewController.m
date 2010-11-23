//
//  FlightViewController.m
//  MLE
//
//  Created by Mohamed Ashraf on 11/22/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import "FlightViewController.h"
#import "Flight.h"

@implementation FlightViewController
@synthesize flight;
@synthesize nibDetailCell;
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
	
	int result;
	switch (section) {
		case 0:
			if (self.flight.status == nil) {
				result = 1;
			}
			else {
				result = 2;
			}
			break; 
		case 1:
			if (self.flight.estimated == nil) {
				result = 2;				
			}
			else {
				result = 3;
			}
			break;
		case 2:
			result = 1;
			break;
	}
	return result;
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:self options:NULL];
	UITableViewCell *cell = self.nibDetailCell;
	
	cell.userInteractionEnabled = NO;
    
	// SETUP LABEL DEFINITIONS
	
	UILabel *keyLabel = (UILabel *) [cell viewWithTag:1];	
	UILabel *valueLabel = (UILabel *) [cell viewWithTag:2];
	
	keyLabel.text = nil;
	valueLabel.text = nil;
	
	// SET FIELD TEXTS
	
	switch (indexPath.section) {
			
		// FIRST SECTION: STATUS AND FLIGHT NUMBER
			
		case 0:
			switch (indexPath.row) {
				case 0:
					keyLabel.text = [NSString stringWithString:@"Flight Number"];
					valueLabel.text = [NSString stringWithFormat:@"%@", self.flight.flightId];
					break;
				case 1:
					keyLabel.text = [NSString stringWithString:@"Status"];	
					valueLabel.text = [NSString stringWithFormat:@"%@", self.flight.status];
					
					break;
			}
			break;	
			
		// SECOND SECTION
			
		case 1:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = self.flight.date;
					cell.textLabel.textAlignment = UITextAlignmentCenter;
					cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
					cell.textLabel.textColor = [UIColor whiteColor];
					break;
				case 1:
					keyLabel.text = [NSString stringWithString:@"Scheduled Time"];
					valueLabel.text = [NSString stringWithFormat:@"%@", self.flight.scheduled];
					break;
				case 2:
					keyLabel.text = [NSString stringWithString:@"Estimated Time"];
					valueLabel.text = [NSString stringWithFormat:@"%@", self.flight.estimated];
					break;
			}
			break;
			
		// THIRD SECTION
			
		case 2:
			
			// REMOVE EXISTING LABELS (THE ONES SET IN THE XIB) FROM CELL
			
			[keyLabel removeFromSuperview];
			[valueLabel removeFromSuperview];
			
			
			// SET LABEL AND SWITCH
			
			cell.textLabel.text = @"Flight status alerts";
			cell.textLabel.textColor = [UIColor whiteColor];
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			
			UISwitch *nSwitch = [[UISwitch alloc] init];
			nSwitch.tag = 9;
			cell.accessoryView = nSwitch;
			[nSwitch release];
			
			cell.userInteractionEnabled = YES;
			
			break;
	}
	
	// DONE, RETURN
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[tableView release];
	[headerBackground release];
	[nibDetailCell release];
	[flight release];
    [super dealloc];
}


@end

