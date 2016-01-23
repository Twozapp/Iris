//
//  WebServices.h
//  GDS WayFinder
//
//  Created by Openwave Computing on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>




//Declare enum mode for Web Services
typedef enum {
    
    WEB_REQUEST_LOGIN
        
    
    
    
    
    
    
}WebRequestMode;

@interface WebServices : NSObject{
    WebRequestMode *webRequestMode;
}

@property (nonatomic, assign) WebRequestMode *webRequestMode;

+ (WebServices *) sharedInstance;

//Compose Web Request
- (void)composeWebRequestFromArguments:(NSMutableDictionary *)args forWebRequestMode:(WebRequestMode *)webReqMode responseWithStatus:(void(^)(NSMutableArray *))handler;

//Encryption
- (void)composedWebRequest:(NSString *)webRequest dataAfterEncryption:(void(^)(NSData *))handler;

//Post Web Request
- (void)postWebRequest:(NSData *)postData responseFromServer:(void(^)(NSMutableDictionary *))handler;

//Parsing
- (void)getValuesFromResponse:(NSMutableDictionary*)withResponse forWebRequestMode:(WebRequestMode *)webReqMode withTheStatus:(void(^)(NSMutableArray *))handler;



@end
