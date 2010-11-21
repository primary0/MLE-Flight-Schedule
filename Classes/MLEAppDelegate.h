//
//  MLEAppDelegate.h
//  MLE
//
//  Created by Mohamed Ashraf on 11/10/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ArrivalNavigationController;

@interface MLEAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    IBOutlet UITabBarController *rootController;
	IBOutlet ArrivalNavigationController *arrivalNavigationController;
	
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet ArrivalNavigationController *arrivalNavigationController;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

@end

