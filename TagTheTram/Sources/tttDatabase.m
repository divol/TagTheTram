//
//  tttDatabase.m
//  TagTheTram
//
//  Created by divol on 15/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//
//singleton
//

#import "tttDatabase.h"


static tttDatabase *_instance;

@implementation tttDatabase

@synthesize  lines;


+(tttDatabase*)currentDatabase
{
	@synchronized(self) {
		
        
       
        
        if (_instance == nil) {
			
            _instance = [[super allocWithZone:NULL] init];
            
            [_instance loadPhotoDB];
        }
    
    }
    return _instance;
}


//little sorting function
static NSInteger sort(NSString *obj1, NSString *obj2, void *context) {
    
    if(obj1.integerValue < obj2.integerValue)
        return NSOrderedAscending;
    else if(obj1.integerValue > obj2.integerValue)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
    
    
    
    
//Queries

-(NSArray *)getNameOfLines{
    NSAssert(lines!=nil,@"self.lines NULL into currentDatabase");
    
    //as we just want Tram and no Buses, block to the 4 firsts
    NSArray * array =[[lines allKeys]sortedArrayUsingFunction:sort context:NULL];
    
    NSMutableArray*aresult = [NSMutableArray array];
    
    for (NSString *line in array){
        if ([line integerValue] < maxnumtramline){
            [aresult addObject:line];
        }
    }
    return aresult;
}

-(NSArray *)getStations:(NSString*)line{
    
    //return array of {"Albert 1er":{"id":"74400610","lat":"43.6165153431063","lon":"3.87407454752208","name":"Place Albert 1er","town":"Montpellier","lines":[]}
    
     if ([line integerValue] < maxnumtramline){
         return [lines objectForKey:line];
     }
    return NULL;
}

-(NSDictionary *)getStationOfLine:(NSInteger)pos ofLine: (NSString*)line{
    
// return {"id":"74401594","lat":"43.6102238810038","lon":"3.85488316568175","name":"Astruc","town":"Montpellier","lines":[]}
    return [[[[self getStations:line]objectAtIndex:pos]allValues]objectAtIndex:0];
}

-(NSString *)getAttrStation:(NSDictionary *)station withAttr:(NSString *) attr{
    return [station objectForKey:attr];
}


-(NSString *)getIdStation:(NSDictionary *)station {
    return [self getAttrStation:station withAttr:idStation];
}


#pragma mark photo part

-(void)loadPhotoDB{
    
    if (photos){
        [photos release];
    }
    NSURL* url=  [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"photos.json"];
     NSError * error=nil;
    NSData *data = [[NSData alloc]initWithContentsOfURL:url options:0 error:&error];
   
    if (data){
         photos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        [data release];
    }else{
         photos =[NSMutableDictionary dictionary];
    }
    [photos retain];

}

-(void)savePhotoDB{
     NSError * error=nil;
    NSURL* url=  [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"photos.json"];
    
    NSData *datatosave = [NSJSONSerialization dataWithJSONObject:photos options:NSJSONWritingPrettyPrinted error:&error];
    if (datatosave)
        [datatosave writeToURL:url options:NSDataWritingFileProtectionNone error:&error];
    
}


-(NSArray *)getPhotosOfStation:(NSString *) idstation{
    
    id dd=[photos objectForKey:idstation];
    
    return dd;
    
}

-(NSDictionary *)getPhotoOfStation:(NSInteger)pos ofStation:(NSString *) idstation{
    return [[photos objectForKey:idstation]objectAtIndex:pos];
}



-(NSString *)getAttrPhoto:(NSDictionary *)station withAttr:(NSString *) attr{
    return [station objectForKey:attr];
}


-(void)addPhotoToStation:(NSString *)label withDate:(NSString *)date withPath:(NSString *)path     tostation:(NSString *) idstation{
    NSMutableDictionary *entry =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 label,labelPhoto,
                                 date,datePhoto,
                                 path,pathPhoto,nil];
    
    
    NSMutableArray *photosOfStation = [photos objectForKey:idstation];
    if (!photosOfStation){
        //empty
        photosOfStation = [NSMutableArray array];
        [photos setObject:photosOfStation  forKey:idstation];
        
    }
    [photosOfStation addObject:entry];
 
}


-(NSMutableDictionary *)makePhotoEntry:(NSString *)label withDate:(NSString *)date withPath:(NSString *)path{
    NSMutableDictionary *entry =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 label,labelPhoto,
                                 date,datePhoto,
                                 path,pathPhoto,nil];
    
    return entry;
}


-(void)addPhotoEntryToStation:(NSMutableDictionary *)entry tostation:(NSString *) idstation{
    
    
    
    NSMutableArray *photosOfStation = [photos objectForKey:idstation];
    if (!photosOfStation){
        //empty
        photosOfStation = [NSMutableArray array];
        [photos setObject:photosOfStation  forKey:idstation];
        
    }
    [photosOfStation addObject:entry];
    
}

-(void)removePhotoFromStation:(NSInteger)rang fromstation:(NSString*)idstation {
    NSMutableArray *photosOfStation = [photos objectForKey:idstation];
    NSDictionary *photo= [photosOfStation objectAtIndex:rang];
    NSString *path = [self getAttrPhoto:photo withAttr:pathPhoto];
    
    [photosOfStation removeObjectAtIndex:rang];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager]removeItemAtPath:path error:NULL];
    }
    [self savePhotoDB];
    
}

#pragma mark files

- (NSURL *)applicationDocumentsDirectory
{
    //already into AppDelgate
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//get a folder to store photos, sharable with itunes, one per station

-(NSURL *) getPhotoFolder:(NSString *)folder{
    
    NSURL* url=  [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PhotoStations"]URLByAppendingPathComponent:folder];
    
    //need to verify and create directory
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return url;
}

//unique filename for photo
//simple alogo based on time
- (NSString*)generateUniqueFileName:(NSString *)filename
{
    // Extenstion string is like @".png"
    
    NSDate *time = [NSDate date];
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MM-yyyy-hh-mm-ss"];
    NSString *timeString = [df stringFromDate:time];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@%@",filename, timeString, @".png"];
    
    [df release];
    return fileName;
}

-(NSURL *) createImagePath:(NSString *)filename{
    
    return  [[self getPhotoFolder:filename] URLByAppendingPathComponent:[self generateUniqueFileName:filename]];
    
}

-(NSData *)manageData:(NSData *)data{
    NSError * error=nil;
    NSURL* target=  [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"tamtag.json"];
    if (!data){
        //something goes wrong : no internet or wifi
        //loading last data saved or if first time copy resource version into Document folder
        
        
         NSData *olddata = [[NSData alloc]initWithContentsOfURL:target options:0 error:&error];
        if (olddata){
            
            return [olddata autorelease];
        }else{
            NSString *source = [[NSBundle mainBundle] pathForResource:@"tamtag.json" ofType:nil];
            olddata = [[NSData alloc]initWithContentsOfFile:source options:0 error:&error];
        }
        return [olddata autorelease];
        
        
    }else{
        // backup a copy for unconnected tests
        
        
       
        [data writeToURL:target options:NSDataWritingFileProtectionNone error:&error];
        return data;
    }
}



#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self currentDatabase]retain];
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


@end
