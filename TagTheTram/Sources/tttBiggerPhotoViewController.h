//
//  tttBiggerPhotoViewController.h
//  TagTheTram
//
//  Created by divol on 15/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tttBiggerPhotoViewController : UIViewController<MFMailComposeViewControllerDelegate,UIActionSheetDelegate>{
    

}
@property (nonatomic, strong) IBOutlet UIImageView* imageStation;
@property (nonatomic, strong) IBOutlet UILabel    * titleStation;
@property (nonatomic, strong) IBOutlet UILabel    * datetimeStation;


@property (strong, nonatomic) NSDictionary *photo;

- (IBAction) close:(id)sender; // to close this modal
- (IBAction)socialAction:(id)sender; //to share
-(void)setPhoto:(NSDictionary*)photo; //the photo to show
@end
