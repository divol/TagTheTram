//
//  tttAppDelegate.m
//  TagTheTram
//
//  Created by divol on 12/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import "tttAppDelegate.h"

//coredata not a good elegant idea
//#import "LineModel.h"
//#import "StationModel.h"

#import "tttDatabase.h"

@implementation tttAppDelegate


#pragma mark lifecicle
- (void)dealloc
{
    
    
    [hostReach release];
    
    [loadingView release];
    [_window release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // [self resetStore]; //delete the data store
    
    //add some control over network availability
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];

    
   // hostReach = [[Reachability reachabilityWithHostName: @"modulaweb.fr"] retain];
     hostReach = [[Reachability reachabilityWithHostName: @"apple.com"] retain];
	[hostReach startNotifier];
     
    
   
    
    [self getStopsList:YES];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [hostReach stopNotifier];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [hostReach startNotifier];
    [self getStopsList:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}







#pragma mark -
#pragma Reachability


-(void)reachabilityMessage:(Reachability*)curReach{
    
    NSString* statusString= @"";
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];

    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
            connectionRequired= NO;
            
            [self alertUser:statusString];
            
            
            
            
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            break;
        }
    }
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
        [self alertUser:statusString];
    }
}

#pragma mark -
#pragma mark Called by Reachability whenever status changes.

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self reachabilityMessage:curReach];
}






#pragma mark httpRequestDelegate

 


- (void)request:(httpRequest *)request didFinishWithData:(NSData*)data{
    
    
    
   // if (!data){
        //something goes wrong : no internet or wifi
        //loading last data saved or if first time copy resource version into Document folder
        
    
        
  //  }else{
       // backup a copy for unconnected tests
        
        
  //  }
    data = [[tttDatabase currentDatabase] manageData:data];
    
    //JSON parsing
    NSError * jsonParsingError=nil;
    
    NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
                             
                             
    NSString *status = [result objectForKey:@"status"];
    NSDictionary * lines = [result objectForKey:@"response"];
    
    if ([@"ok" isEqualToString:status]){
        //diff kind ok request are available
        switch (request.kind) {
            case getStopsList:{

                //nop
            }
                break;
                
            case getStopsListFull:
            {
                
                [[tttDatabase currentDatabase] setLines:lines];
            }


                break;
        }
    }else{
        [self alertUser:@"JSSON status not ok"];
    }
    [self hideLoading]; 
    //tell world data is ok
   
        
     [[NSNotificationCenter defaultCenter] postNotificationName:@"STATIONS_LOADED" object:nil];
          
}


- (void)request:(httpRequest *)request didFailWithError:(httpRequestErrorType)errorType{
    
    
    [self request:request didFinishWithData:NULL];
    
    // [self hideLoading];
}

#pragma mark utils
- (void)alertUser:(NSString*)message {
    
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(message,nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
    
    
    
    
}

#pragma mark show messages
-(void)showLoading{
    
    if(!loadingView){
        loadingView = [[[MBProgressHUD alloc] initWithWindow:self.window]retain];
       
        [loadingView setMode:MBProgressHUDModeIndeterminate];
        [loadingView setLabelText:NSLocalizedString(@"Loading...",nil)];
         [self.window addSubview:loadingView];
    }
	
    
    
    
    [self.window bringSubviewToFront:loadingView];
    [loadingView show:YES];
}

-(void)hideLoading{
    [loadingView show:NO];
    [self.window sendSubviewToBack:loadingView];
    
}

#pragma data fetch
//req apitam
-(void)getStopsList:(BOOL)full{
    
   
    
        NSString *path;
        httpRequest *req;
        NSURL *url=nil;
        httpRequestKind kind;
        
        [self performSelectorOnMainThread:@selector(showLoading) withObject:nil waitUntilDone:NO];
       
    
   
    if (full){
        path=@"http://modulaweb.fr/apitam/?request=getStopsList&fullInfos=1";
        kind = getStopsListFull;
    }else{
         path=@"http://modulaweb.fr/apitam/?request=getStopsList";
         kind = getStopsList;
    }
    url =  [[NSURL alloc ]initWithString:path];
    
    req = [[[httpRequest alloc]initWithURL:url]retain];
    if(req){
        req.delegate=self;
        req.kind=kind;
        [req startRequest];
    }
    [url release];
    [req autorelease];
     
}

@end
