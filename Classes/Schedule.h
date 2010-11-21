//
//  Schedule.h
//  Airport
//
//  Created by Mohamed Ashraf on 11/9/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Flight;

@interface Schedule : NSObject <NSXMLParserDelegate> {	
	
	NSMutableArray *international;
	NSMutableArray *domestic;
	NSString *url;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableArray *international;
@property (nonatomic, retain) NSMutableArray *domestic;

-(void)parseData:(NSData *)xmlData;
-(NSMutableArray *)sortScheduleByTime:(NSMutableArray *)schedule;

@end
