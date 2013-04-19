//
//  tttStationLocation.m
//  TagTheTram
//
//  Created by divol on 15/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import "tttStationLocation.h"

@implementation tttStationLocation


@synthesize  name=_name;
@synthesize  lignes=_lignes;
@synthesize  coordinate=_coordinate;
@synthesize  stationID=_stationID; //to retreive station later on click
@synthesize  station=_station;


- (id)initWithName:(NSString*)name lignes:(NSString*)lignes coordinate:(CLLocationCoordinate2D)coordinate  stationid:(NSString*)stationid station:(NSDictionary *)station{
    if ((self = [super init])) {
        _name = [name copy];
        _lignes = [lignes copy];
        _coordinate = coordinate;
        _stationID=[stationid copy];
        _station = [station copy];
        
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown";
    else
        return _name;
}

- (NSString *)subtitle {
    if(_lignes)
        return[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Line: ",nil),_lignes];
    
    return @"";
}

@end
