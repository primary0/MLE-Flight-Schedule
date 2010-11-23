//
//  FlightViewController.h
//  MLE
//
//  Created by Mohamed Ashraf on 11/22/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flight;

@interface FlightViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	Flight *flight;
	UITableView *tableView;
	UITableViewCell *nibDetailCell;
	UIView *headerBackground;
}

@property (nonatomic, retain) Flight *flight;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibDetailCell;
@property (nonatomic, retain) IBOutlet UIView *headerBackground;

@end
