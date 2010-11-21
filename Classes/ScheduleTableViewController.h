//
//  ScheduleTableViewController.h
//  MLE
//
//  Created by Mohamed Ashraf on 11/10/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flight;
@class Schedule;
@class EGORefreshTableHeaderView;
@class LoadingView;
@class ShadowView;

@interface ScheduleTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
	
	
	// Flight schedule and data object
	Schedule *schedule;
	NSMutableArray *tableData;
	NSMutableArray *searchData;
	
	// Pull down refresh view
	EGORefreshTableHeaderView *refreshHeaderView;	
	BOOL _reloading;
	
	// Flight schedule view
	IBOutlet UITableView *scheduleTableView;
	UITableViewCell *nibLoadedCell;	
	
	// Loading View
	LoadingView *loadingView;
	
	// Network Data Buffer
	NSMutableData *dataBuffer;
	
	// Instance variable to hold state
	BOOL firstLaunch;
	BOOL emptyTableView;
	
	// Other UI outlets
	IBOutlet UISegmentedControl *segmentButtons;
	IBOutlet UINavigationBar *navigationBar;
	
	// Shadow view, used as background
    ShadowView *footerShadowView;
	
}

@property (nonatomic, retain) Schedule *schedule;
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NSMutableArray *searchData;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;
@property (nonatomic, retain) LoadingView *loadingView;
@property (nonatomic, retain) NSMutableData *dataBuffer;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentButtons;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) ShadowView *footerShadowView;

// Pull down refresh view
@property(assign,getter=isReloading) BOOL reloading;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)loadData;
- (IBAction)switchSegment;

@end
