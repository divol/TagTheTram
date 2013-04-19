//
//  tttStationLocation.h
//  TagTheTram
//
//  Created by divol on 15/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface tttStationLocation : NSObject<MKAnnotation>{
    NSString *_name;
    NSString *_lignes;
    NSString *_stationID;
    CLLocationCoordinate2D _coordinate;
    NSDictionary *_station;
}

@property (copy) NSString *name;
@property (copy) NSString *lignes;
@property (copy) NSString *stationID;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy) NSDictionary *station;

- (id)initWithName:(NSString*)name lignes:(NSString*)lignes coordinate:(CLLocationCoordinate2D)coordinate  stationid:(NSString*)stationid station:(NSDictionary *)station;

@end