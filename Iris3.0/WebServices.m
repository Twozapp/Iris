
//  WebServices.m
//  GDS WayFinder
//
//  Created by Openwave Computing on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices.h"
#import <Foundation/Foundation.h>
#import "HelpDesk.h"
#import "OnDeck.h"





#define PASS_KEY @"FBSJALWL3850JDNAJF93QKL402JJK53N"

//development
//static const NSString *baseURL = @"http://192.9.200.10/eastandlo/api/";
//public
static const NSString *baseURL = @"http://198.57.226.173:8080/irisservices/v3.0/";

//http://124.124.73.180/eastandlo/

//OWCstatic const NSString *baseURL = @"http://owcprojects.com/eastandlo/api/";




@implementation WebServices{
    NSString *jsonStingResponse;
}

@synthesize webRequestMode;

#pragma mark - Singleton methods

+ (WebServices *)sharedInstance{
    static WebServices *sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
    
}

#pragma mark - Compose Web Requests

- (void)composeWebRequestFromArguments:(NSMutableDictionary *)args forWebRequestMode:(WebRequestMode *)webReqMode responseWithStatus:(void(^)(NSMutableArray *))handler{
    
    NSString *webRequest;
    
    switch ((int)[WebServices sharedInstance].webRequestMode) {
            
            
            
        case WEB_REQUEST_LOGIN:
            
            //username=nimbles&password=nimbles&mobileid=&mobiletype=
        {
            webRequest = [NSString stringWithFormat:@"username=%@&password=%@&mobileid=&mobiletype=",[args objectForKey:@"email"],[args objectForKey:@"password"]];
            
        }
            break;
            
        default:
            break;
    }
    
    NSLog(@"Web Request = %@",webRequest);
    
    
    //Passing the web request string to get the encrypted data
    [[WebServices sharedInstance] composedWebRequest:webRequest dataAfterEncryption:^(NSData *encryptedData){
        
        //Post the encrypted data to get the response
        [[WebServices sharedInstance] postWebRequest:encryptedData responseFromServer:^(NSMutableDictionary *response){
            
            [[WebServices sharedInstance] getValuesFromResponse:response forWebRequestMode:[WebServices sharedInstance].webRequestMode withTheStatus:^(NSMutableArray *status){
                handler(status);
            }];
        }];
    }];
    
}

#pragma mark - Core Web Service Methods

- (void)composedWebRequest:(NSString *)webRequest dataAfterEncryption:(void(^)(NSData *))handler{
    
    
    NSData *postData = [webRequest dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    handler(postData);}

- (void)postWebRequest:(NSData *)postData responseFromServer:(void(^)(NSMutableDictionary *))handler{
    
    
    NSURL *url;
    switch ((int)[WebServices sharedInstance].webRequestMode) {
            
        case WEB_REQUEST_LOGIN:
        {
            url = [NSURL URLWithString:@"http://198.57.226.173:8080/irisservices/v3.0/login"];
            
        }
            break;
            
        default:break;
    }
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    //Perform request and get JSON back as a NSData object
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String as Response = %@", json_string);
    
    //Parse the JSON string into a dictionary
    NSMutableDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    //Passes the response to the handler
    handler(parsedResponse);
    
    
    
    
    
    
    
}

#pragma mark - Get Values into Dictionaries

- (void)getValuesFromResponse:(NSMutableDictionary*)withResponse forWebRequestMode:(WebRequestMode *)webReqMode withTheStatus:(void(^)(NSMutableArray *))handler{
    
    switch ((int)[WebServices sharedInstance].webRequestMode) {
            
        case WEB_REQUEST_LOGIN:{
            
            NSLog(@"response %@",withResponse);
            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            response = [withResponse objectForKey:@"response"];
            if ([[response objectForKey:@"Msg"] isEqualToString:@"success"]){
                //NSString *errorCode;
//                for(id key in response) {
//                    if ([key isEqualToString:@"success"]){
//                        //Do nothing continue the next iteration
//                        continue;
//                    }els
                
                       // [OnDeck sharedInstance].strName = [[[response objectForKey:key] objectForKey:@"role"] objectForKey:@"name"];
                        [OnDeck sharedInstance].strUserName =
                        [response objectForKey:@"username"];
                        [OnDeck sharedInstance].strPassword = [response  objectForKey:@"password"];
                        
                    //}
               // }
                
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Success"];
                
                handler(arraySucess);
                
                return;
            }
            
            
            else if ([[withResponse objectForKey:@"error"] isEqualToString:@"OWCE34"]){
                
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"WroungEmail"];
                handler(arraySucess);
                
                return;
                
            }
            
            else {
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Failure"];
                handler(arraySucess);
                
                return;
                            }
        }
            
            
            break;
             
        default:
            break;
    }
    
    
}



@end