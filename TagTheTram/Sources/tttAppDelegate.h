//
//  tttAppDelegate.h
//  TagTheTram
//
//  Created by divol on 12/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "httpRequest.h"
#import "MBProgressHUD.h"



@interface tttAppDelegate : UIResponder <UIApplicationDelegate,httpRequestDelegate>{
    Reachability* hostReach;
    MBProgressHUD *loadingView;
}

@property (strong, nonatomic) UIWindow *window;




//
- (void)alertUser:(NSString*)message;


// add some patience
-(void)showLoading;
-(void)hideLoading;
@end
