//
//  ScheduleTableViewController.m
//  MLE
//
//  Created by Mohamed Ashraf on 11/10/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "Schedule.h"
#import "Flight.h"
#import "FlightViewController.h"
#import "UIColor+i7HexColor.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "ShadowView.h"
// #import "RRSGlowLabel.h" // GLOW EFFECT LIBRARY

#pragma mark -
#pragma mark Custom Interfaces

// PULL DOWN REFRESH VIEW PRIVATE INTERFACE

@interface ScheduleTableViewController (Private)
- (void)dataSourceDidFinishLoadingNewData;
@end

@interface UITableView (Reload)
- (void)reloadData:(BOOL)animated;
@end

#pragma mark -
#pragma mark Shadow View custom implementation.

@interface ScheduleTableViewController (PrivateMethods)
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end

#pragma mark -
#pragma mark Custom Implementation for animated tableview reload.

@implementation UITableView (Reload)
- (void)reloadData:(BOOL)animated {
	[self reloadData];
	if (animated) {
		CATransition *animation = [CATransition animation];
		[animation setDelegate:self.delegate];	// optional
		[animation setType:kCATransitionFade];
		[animation setDuration:0.3];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[animation setFillMode: @"extended"];
		[[self layer] addAnimation:animation forKey:@"reloadAnimation"];
	}
}
@end

#pragma mark -
#pragma mark Main Implementation and synthesize

@implementation ScheduleTableViewController

@synthesize schedule;
@synthesize tableData;
@synthesize searchData;
@synthesize nibLoadedCell;
@synthesize reloading=_reloading;
@synthesize dataBuffer;
@synthesize loadingView;
@synthesize segmentButtons;
@synthesize navigationBar;
@synthesize footerShadowView;

#pragma mark -
#pragma mark Segment Controls

-(void) switchSegment {
		
	switch (self.segmentButtons.selectedSegmentIndex) {
		case 0:
			self.tableData = self.schedule.international;
			break; 
		case 1:
			self.tableData = self.schedule.domestic;
			break;
	}
	
	[self.tableView reloadData:YES];
}

#pragma mark -
#pragma mark Network Connection

-(void)loadData {
	
	NSURL *urlObject = [[NSURL alloc] initWithString:self.schedule.url];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlObject];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
		
	[connection release];
	[request release];
	[urlObject release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	if (self.dataBuffer == nil) {
		self.dataBuffer = [NSMutableData dataWithData:data];
	}
	else {
		[self.dataBuffer appendData:data];
	}
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection {	
	
	// PARSE XML DATA
	
	[self.schedule parseData:dataBuffer];
	
	// PICK SCHEDULE TO USE AS PER SEGMENT SELECTED AND LOAD TABLEVIEW
	
	switch (self.segmentButtons.selectedSegmentIndex) {
		case 0:
			self.tableData = [NSMutableArray arrayWithArray:self.schedule.international];
			break; 
		case 1:
			self.tableData = [NSMutableArray arrayWithArray:self.schedule.domestic];
			break;
	}
	
	[self.tableView reloadData];
	
	// CLEAR dataBuffer OBJECT, WILL BE USED FOR PULL DOWN REFRESH/RELOADS
	
	self.dataBuffer = nil;
	
	// LOADING VIEW NEEDS TO BE HIDDEN DURING FIRST LAUNCH
	// PULL DOWN REFRESH NEEDS TO BE RETRACTED DURING OTHER RELOADS
	
	if (firstLaunch == YES) {
		firstLaunch = NO;
		[self.loadingView performSelector:@selector(removeView) withObject:nil];
	}
	else {
		[self doneLoadingTableViewData];
	}
	
	if (self.tableView.hidden == YES) {
		[self.tableView setHidden:NO];
	}
	
	// SCROLL TO TOP CELL, HIDE SEARCH BAR
	
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];	
    
	if ([self.tableData count] < 0) {
        self.tableView.scrollEnabled = NO;
    }	
	else {
		self.tableView.scrollEnabled = YES;
	}
}


-(void)connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: [error localizedDescription]
														 message: [error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show]; 
	[errorAlert release];
	
	if (firstLaunch == YES) {
		firstLaunch = NO;
		[self.loadingView performSelector:@selector(removeView) withObject:nil];	
	}
	else {
		[self doneLoadingTableViewData];
	}
}

#pragma mark -
#pragma mark Pull Down to Refresh View

- (void)reloadTableViewDataSource{
	[self loadData];
	[self.tableView reloadData];
}


- (void)doneLoadingTableViewData{
	[self dataSourceDidFinishLoadingNewData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	// PULL DOWN REFRESH CODE
	
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
	
	// FOOTER SHADOW VIEW CODE
	
    CGRect shadowViewRect;
    CGFloat shadowViewHeight = self.view.frame.size.height - self.tableView.contentSize.height + self.tableView.contentOffset.y;
    
    if (shadowViewHeight > 0.0) {
        shadowViewRect = footerShadowView.frame;
        shadowViewRect.origin.y = self.tableView.contentSize.height;
        shadowViewRect.size.height = shadowViewHeight;
        shadowViewRect.size.width = self.view.frame.size.width;
        
        [footerShadowView setFrame:shadowViewRect];
    }	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadTableViewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)dataSourceDidFinishLoadingNewData{
	
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.2];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	[refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	Flight *flight;
	
	if (tableView == self.tableView) {
		flight = [[self.tableData objectAtIndex:section] objectAtIndex:0];		
	}
	if(tableView == self.searchDisplayController.searchResultsTableView){
		flight = [[self.searchData objectAtIndex:section] objectAtIndex:0];
	}
	
	return flight.date;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	int result;
	if (tableView == self.tableView) {
		result = [self.tableData count];
	}
	if(tableView == self.searchDisplayController.searchResultsTableView){
		result = [self.searchData count];
	}
	return result;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int result;
	if (tableView == self.tableView) {
		result = [[self.tableData objectAtIndex:section] count];
	}
	if(tableView == self.searchDisplayController.searchResultsTableView){
		result = [[self.searchData objectAtIndex:section] count];
	}
	return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {		
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"FlightCell" owner:self options:NULL];
		cell = nibLoadedCell;
    }
	
	// ASSIGN FLIGHT OBJECT
	
	Flight *flight;
	
	if (tableView == self.tableView) {
		flight = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	}
	if(tableView == self.searchDisplayController.searchResultsTableView){
		flight = [[self.searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	}
	
	// SETUP LABEL DEFINITIONS
	
	//RRSGlowLabel *nameLabel = (RRSGlowLabel *) [cell viewWithTag:1]; // DECLARATION FOR GLOW EFFECT
	UILabel *nameLabel = (RRSGlowLabel *) [cell viewWithTag:1];	
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
	
	if ([flight.estimated isEqualToString:@""]) {
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
	
	nameLabel.textColor = flight.foregroundColor;
	flightNumberLabel.textColor = flight.textColor;
	routeLabel.textColor = flight.textColor;
	timeLabel.textColor = flight.textColor;
	statusLabel.textColor = flight.textColor;
	nameLabel.shadowColor = flight.nameShadowColor;	
	timeLabel.shadowColor = flight.timeShadowColor;	
	statusLabel.shadowColor = flight.timeShadowColor;
	
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
	
	if (tableView == self.tableView) {
		flight = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	}
	if(tableView == self.searchDisplayController.searchResultsTableView){
		flight = [[self.searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	}
	
	cell.backgroundColor = flight.backgroundColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	FlightViewController *flightViewController = [[FlightViewController alloc] initWithNibName:@"FlightViewController" bundle:nil];

	Flight *flight;
	
	if (tableView == self.tableView) {
		flight = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	}
	if(tableView == self.searchDisplayController.searchResultsTableView){
		flight = [[self.searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	}
	
	flightViewController.flight = flight;
	
	[self.navigationController pushViewController:flightViewController animated:YES];
	[flightViewController release];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchData removeAllObjects];
    for (NSMutableArray *section in tableData) {
		for (Flight *flight in section) {
			NSPredicate *predicate = [NSPredicate predicateWithFormat:
									  @"(SELF contains[cd] %@)", searchText];
						
			BOOL resultFlightNumber = [predicate evaluateWithObject:flight.flightId];
			BOOL resultName = [predicate evaluateWithObject:flight.airlineName];
			BOOL resultRoute = [predicate evaluateWithObject:flight.route];			
			
			if (resultFlightNumber || resultName || resultRoute) {
				[self.searchData addObject:flight];
			}
		}		
	}
	self.searchData = [self.schedule sortScheduleByTime:self.searchData];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// SET A PAGE TITLE. NEEDED FOR THE DETAILVIEW'S BACK BUTTON
	
	switch (self.segmentButtons.selectedSegmentIndex) {
		case 0:
			self.title = @"International";
			break; 
		case 1:
			self.title = @"Domestic";
			break;
	}	
		
	// SOME INSTANCE VARIABLES
	
	firstLaunch = YES;
	emptyTableView = YES;
	
	// INITIALIZE AND ALLOCATE AN NSMUTABLEARRAY FOR SEARCH DATA
	
	NSMutableArray *temp = [[NSMutableArray alloc] init];
	self.searchData = temp;
	[temp release];
	
	// PULL DOWN REFRESH VIEW SETUP
	
	if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height)];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self.tableView addSubview:refreshHeaderView];
		self.tableView.showsVerticalScrollIndicator = YES;
		[refreshHeaderView release];				
	}
	
	// NAVIGATION BAR COLORS SETUP
	
	[self.navigationBar setTintColor:[UIColor grayColor]];
	[self.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
	[self.segmentButtons setTintColor:[UIColor grayColor]];
	
    // FOOTER SHADOW VIEW SETUP
	
    CGRect shadowViewRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.0);
    self.footerShadowView = [[ShadowView alloc] initWithFrame:shadowViewRect];    
	self.tableView.tableFooterView = self.footerShadowView;
}

- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];    
    [self.tableView reloadData];    
    [self scrollViewDidScroll:nil];
    
    // AVOID SCROLLING IF THE TABLE IS EMPTY
	
    if (self.tableView.contentSize.height <= 0.0) {
        self.tableView.scrollEnabled = NO;
    }
}

- (void)viewDidUnload {
	
	refreshHeaderView=nil;	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	
	[searchData release];
	[footerShadowView release];
	[navigationBar release];
	[tableData release];
	[segmentButtons release];
	[dataBuffer release];
	[loadingView release];
	refreshHeaderView = nil;
	[nibLoadedCell release];
	[schedule release];
    [super dealloc];
}

@end

