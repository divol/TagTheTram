//
//  httpRequest.m
//  TagTheTram
//
//  Created by divol on 12/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import "httpRequest.h"


@implementation httpRequest

@synthesize activeDownloadData;
@synthesize urlconnection;
@synthesize url;
@synthesize kind;
#pragma mark -
#pragma mark logic



- (id) initWithURL:(NSURL*)theurl
{
	if ( self = [super init] )
	{
        self.url=theurl;
	}
	
	return self ;
}


- (void)cancelDownload
{
    if (self.urlconnection)
        [self.urlconnection cancel];
    self.urlconnection = nil;
    self.activeDownloadData = nil;
    self.url=nil;
}

- (void)startRequest{
    
    NSAssert(self.url!=nil,@"Provide some url");
    
    self.activeDownloadData = [NSMutableData data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
		
       
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                                 [NSURLRequest requestWithURL:
                                  url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: READ_TIMEOUT] delegate:self startImmediately:YES];
        self.urlconnection = conn;
        [conn release];
    });
}



#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownloadData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownloadData = nil;
    
    // Release the connection now that it's finished
    self.urlconnection = nil;
    
    if([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [self.delegate request:self didFailWithError:httpRequestGeneralError];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if([self.delegate respondsToSelector:@selector(request:didFinishWithData:)]) {
        
        
        [self.delegate request:self didFinishWithData:self.activeDownloadData];
        
        
      
        //NSString *d = [[NSString alloc]initWithData:self.activeDownloadData encoding:NSUTF8StringEncoding];
        //NSLog(d);needed sometimes
      //  [d release];
        
    }
    
    
    self.activeDownloadData = nil;
    
    // Release the connection now that it's finished
    self.urlconnection = nil;
    
}



- (void)dealloc {
    
    [self cancelDownload];
	[super dealloc];
}

@end