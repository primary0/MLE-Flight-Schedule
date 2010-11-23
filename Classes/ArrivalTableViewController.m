//
//  ArrivalTableViewController.m
//  MLE
//
//  Created by Mohamed Ashraf on 11/10/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import "ArrivalTableViewController.h"
#import "Schedule.h"
#import "Flight.h"
#import "LoadingView.h"

@implementation ArrivalTableViewController

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.title = @"Arrivals";
	
	self.loadingView = [LoadingView loadingViewInView:self.view];
		
	Schedule *flightSchedule = [[Schedule alloc] init];
	flightSchedule.url = [NSString stringWithString:ARRIVALS_URL];
	self.schedule = flightSchedule;
	[flightSchedule release];
	
	[self loadData];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}

@end

