//
//  tttDatabase.h
//  TagTheTram
//
//  Created by divol on 15/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <Foundation/Foundation.h>

#define maxnumtramline 5
#define myTown @"Montpellier"


//line and stations keys
#define idStation @"id"
#define latStation @"lat"
#define lonStation @"lon"
#define nameStation @"name"
#define townStation @"town"



//photos keys
#define labelPhoto @"label"
#define datePhoto @"date"
#define pathPhoto @"path"




@interface tttDatabase : NSObject{
    NSDictionary *lines; //dictionary from server, immutable
    
    
    
    NSMutableDictionary*photos; //structure {"stationid1":[{"label":"", "date":"", "path":""},{"label":"", "date":"", "path":""}],"stationid2":[{"label":"", "date":"", "path":""}]}
    
    
    
}
@property (nonatomic, retain) NSDictionary *lines;

+(tttDatabase*)currentDatabase;



// Lines List
-(NSArray *)getNameOfLines;


//Stations List
-(NSArray *)getStations:(NSString*)line;


-(NSDictionary *)getStationOfLine:(NSInteger)pos ofLine: (NSString*)line;

-(NSString *)getAttrStation:(NSDictionary *)station withAttr:(NSString *) attr;

-(NSString *)getIdStation:(NSDictionary *)station ;

#pragma mark photo part

-(void)loadPhotoDB;


-(void)savePhotoDB;

-(NSArray *)getPhotosOfStation:(NSString *) idstation;
-(NSDictionary *)getPhotoOfStation:(NSInteger)pos ofStation:(NSString *) idstation;


-(NSString *)getAttrPhoto:(NSDictionary *)station withAttr:(NSString *) attr;

-(void)addPhotoToStation:(NSString *)label withDate:(NSString *)date withPath:(NSString *)path     tostation:(NSString *) idstation;

-(NSMutableDictionary *)makePhotoEntry:(NSString *)label withDate:(NSString *)date withPath:(NSString *)path;

-(void)addPhotoEntryToStation:(NSMutableDictionary *)entry tostation:(NSString *) idstation;

-(NSURL *) createImagePath:(NSString *)filename;

//manage data/ backup and offline context
-(NSData *)manageData:(NSData *)data;

-(void)removePhotoFromStation:(NSInteger)rang fromstation:(NSString*)idstation;

@end
