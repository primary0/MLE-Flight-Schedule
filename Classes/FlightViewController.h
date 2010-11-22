//
//  FlightViewController.h
//  MLE
//
//  Created by Mohamed Ashraf on 11/22/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flight;

@interface FlightViewController : UITableViewController {

	Flight *flight;

}

@property (nonatomic, retain) Flight *flight;

@end
