//
//  tttSecondViewController.m
//  TagTheTram
//
//  Created by divol on 12/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import "tttMapViewController.h"
#import "tttDatabase.h"

#import "tttStationLocation.h"

@interface tttMapViewController ()
-(void)drawStationsOnMap;
@end

@implementation tttMapViewController
@synthesize _mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.zoomEnabled = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawStationsOnMap) name:@"STATIONS_LOADED" object:nil];
    
    [self drawStationsOnMap];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)trackUser:(id)sender{
    [_mapView setUserTrackingMode:true];
}


-(void)addMyAnnotations{
    NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
   NSArray* lines = [[tttDatabase currentDatabase] getNameOfLines];
    if (lines){
        NSMutableArray *anno = [NSMutableArray array];
        NSMutableDictionary* dicotemp =[NSMutableDictionary dictionary]; // to filter same stations
        for(NSString * line in lines){
            
            NSArray * stations = [[tttDatabase currentDatabase]getStations:line];
             for(NSDictionary * stationentry in stations){
                NSDictionary * station = [ [stationentry allValues]objectAtIndex:0];
                 
                 NSString* lat = [[tttDatabase currentDatabase]getAttrStation:station  withAttr:latStation];
                 NSString* lon = [[tttDatabase currentDatabase]getAttrStation:station  withAttr:lonStation];
                 NSString* theid = [[tttDatabase currentDatabase]getAttrStation:station  withAttr:idStation];
                 NSString* name = [[tttDatabase currentDatabase]getAttrStation:station  withAttr:nameStation];
                 
                 
                 CLLocationCoordinate2D coordinate;
                 coordinate.latitude =  lat.doubleValue;
                 coordinate.longitude =  lon.doubleValue;
                 
                 NSString *ligne=line;
                                 
                 //create annotation
                 tttStationLocation *annotation = [[tttStationLocation alloc] initWithName:name lignes:ligne coordinate:coordinate stationid:theid station:station] ;
                 
                 //verify if annotation if allready present
                 tttStationLocation *annotationPrevious=nil;
                 if (theid){
                    annotationPrevious =  [dicotemp objectForKey:theid];
                 }
                 if (annotationPrevious){
                     ligne = [NSString stringWithFormat:@"%@, %@",annotationPrevious.lignes,line];
                     annotationPrevious.lignes=ligne;
                     
                 }else{
                     [anno addObject:annotation];
                      if (theid){
                          [dicotemp setObject:annotation forKey:theid];
                      }
                 }
                 
                 
                 [annotation release];

             }
        }
    if (anno.count){
        
        [_mapView addAnnotations:anno];
    }
}
    [autoreleasepool release];
    
    
}
-(void)drawStationsOnMap{
    
    
    
    
    [NSThread detachNewThreadSelector:@selector(addMyAnnotations) toTarget:self withObject:nil];

   
       
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mapView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self set_mapView:nil];
    [super viewDidUnload];
}



#pragma mark delegate 


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"tttStationLocation";
    if ([annotation isKindOfClass:[tttStationLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    lastlocation = (tttStationLocation*)view.annotation;
    
    [self performSegueWithIdentifier:@"pintophoto" sender:self];
    
   
    }


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (lastlocation){
        
        if([segue.destinationViewController respondsToSelector:@selector(setStation:)]){
        [segue.destinationViewController setStation:lastlocation.station];
        
        }
    }
}


@end
