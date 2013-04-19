//
//  httpRequest.h
//  TagTheTram
//
//  Created by divol on 12/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <Foundation/Foundation.h>



//some errors
typedef enum {
    httpRequestErrorNoNetwork,
    httpRequestGeneralError
} httpRequestErrorType;


typedef enum {
    getStopsList,
    getStopsListFull
} httpRequestKind;



#define READ_TIMEOUT			10.0




@protocol httpRequestDelegate;

@interface httpRequest : NSObject {
    NSURLConnection *urlconnection;
    NSMutableData   *activeDownloadData;
    
    NSURL           *url;  //url of req
    httpRequestKind kind;  //kind of req
}

@property (nonatomic, assign) id <httpRequestDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownloadData;
@property (nonatomic, retain) NSURLConnection *urlconnection;
@property (nonatomic, retain) NSURL           *url;
@property ( assign) httpRequestKind kind;


- (id) initWithURL:(NSURL*)theurl;

- (void)startRequest;

- (void)cancelDownload;
@end


@protocol httpRequestDelegate <NSObject>
@optional
- (void)request:(httpRequest *)request didFinishWithData:(NSData*)data;


- (void)request:(httpRequest *)request didFailWithError:(httpRequestErrorType)errorType;
@end
