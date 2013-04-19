//
//  tttSecondViewController.h
//  TagTheTram
//
//  Created by divol on 12/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "tttStationLocation.h"

@interface tttMapViewController : UIViewController<MKMapViewDelegate>{
    tttStationLocation *lastlocation;
}
@property (retain, nonatomic) IBOutlet MKMapView *_mapView;
-(IBAction)trackUser:(id)sender;
@end
