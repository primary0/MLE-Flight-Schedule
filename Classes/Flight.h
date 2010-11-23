//
//  Flight.h
//  MLE
//
//  Created by Mohamed Ashraf on 11/18/10.
//  Copyright 2010 primary0.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 <Flight>
 <AirLineID>QR</AirLineID>
 <AirLineName>Qatar Airways</AirLineName>
 <FlightID>QR 382</FlightID>
 <Route1>Doha</Route1>
 <Route2> </Route2>
 <Route3> </Route3>
 <Route4> </Route4>
 <Route5> </Route5>
 <Route6> </Route6>
 <Scheduled>14:20</Scheduled>
 <Estimated>14:10</Estimated>
 <Status>LA</Status>
 <Gate> </Gate>
 <Date>20101118</Date>
 <PrimaryFlight> </PrimaryFlight>
 <CarrierType>I</CarrierType>
 </Flight>	 
*/

@interface Flight : NSObject {
	
	NSString	*airlineId;
	NSString	*airlineName;
	NSString	*flightId;
	NSString	*route;	
	NSString	*scheduled;
	NSString	*estimated;
	NSString	*status;
	NSString	*date;
	NSString	*carrierType;
	UIColor		*backgroundColor;
	UIColor		*foregroundColor;
	UIColor		*textColor;
	UIColor		*nameShadowColor;
	UIColor		*timeShadowColor;
	BOOL		inbound;
}

@property (nonatomic, retain) NSString	*airlineId;
@property (nonatomic, retain) NSString	*airlineName;
@property (nonatomic, retain) NSString	*flightId;
@property (nonatomic, retain) NSString	*route;
@property (nonatomic, retain) NSString	*scheduled;
@property (nonatomic, retain) NSString	*estimated;
@property (nonatomic, retain) NSString	*status;
@property (nonatomic, retain) NSString	*date;
@property (nonatomic, retain) NSString	*carrierType;
@property (nonatomic, retain) UIColor	*backgroundColor;
@property (nonatomic, retain) UIColor	*foregroundColor;
@property (nonatomic, retain) UIColor	*textColor;
@property (nonatomic, retain) UIColor	*nameShadowColor;
@property (nonatomic, retain) UIColor	*timeShadowColor;
@property (nonatomic) BOOL inbound;

@end
