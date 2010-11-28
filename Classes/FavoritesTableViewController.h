//
//  FavoritesViewController.h
//  MLE
//
//  Created by Mohamed Ashraf on 11/27/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flight;

@interface FavoritesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *flights;
	UITableViewCell *nibLoadedCell;		
	IBOutlet UINavigationBar *navigationBar;
}

@property (nonatomic, retain) NSMutableArray *flights;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

@end
