//
//  tttImageViewControlerViewController.h
//  TagTheTram
//
//  Created by divol on 13/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface tttImageViewControler : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

    NSDictionary *station; //cur station
    NSMutableDictionary* curphoto;
    
    
     UIImagePickerController *cameraUI;
    
}

- (IBAction)photoAction:(id)sender;

@property (strong, nonatomic) NSDictionary *station;


@end
