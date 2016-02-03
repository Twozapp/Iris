
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
#import "Asset.h"





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
            case WEB_REQUEST_ASSET_OVERVIEW:
        {
            webRequest = [NSString stringWithFormat:@"gatewayoverview/%@?groupid=&subgroupid=",[OnDeck sharedInstance].strauthKey];
        }
            break;
            
            case  WEB_REQUEST_ASSET:
            {
                webRequest = [NSString stringWithFormat:@"%@?groupid=&subgroupid=",[OnDeck sharedInstance].strauthKey];
            }
            
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
            case WEB_REQUEST_ASSET_OVERVIEW:
        {
            url = [NSURL URLWithString:[ NSString stringWithFormat:@"http://198.57.226.173:8080/irisservices/v3.0/assetoverview/%@?groupid=&subgroupid=",[OnDeck sharedInstance].strauthKey]];
        }
            break;
            
            case WEB_REQUEST_ALERT_OVERVIEW:
        {
            url = [NSURL URLWithString:[ NSString stringWithFormat:@"http://198.57.226.173:8080/irisservices/v3.0/alert/%@?alerttype=&gatewayid=&subgroupid=&groupid=1",[OnDeck sharedInstance].strauthKey]];
            
        }
            break;
            
        case WEB_REQUEST_ASSET:
        {
            url = [NSURL URLWithString:[ NSString stringWithFormat:@"http://198.57.226.173:8080/irisservices/v3.0/gatewaysummary/%@?groupid=&subgroupid=&assetgroupid=&assetid=1",[OnDeck sharedInstance].strauthKey]];
            
        }
            break;

           // v3.0/gatewaysummary/{auth}?groupid={String}&subgroupid={String}&assetgroupid={String}&a ssetid={String}
            
        default:break;
    }
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    
    switch ((int)[WebServices sharedInstance].webRequestMode) {
        case WEB_REQUEST_LOGIN:{
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
        }
            
            
            break;
            
        default:{
            [request setHTTPMethod:@"GET"];
        }
            break;
    }
    
    
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    //Perform request and get JSON back as a NSData object
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON String as Response = %@", json_string);
    
    //Parse the JSON string into a dictionary
    if (json_string.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    else
    {
    NSMutableDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    
    //Passes the response to the handler
    handler(parsedResponse);
    }
    
}

#pragma mark - Get Values into Dictionaries

- (void)getValuesFromResponse:(NSMutableDictionary*)withResponse forWebRequestMode:(WebRequestMode *)webReqMode withTheStatus:(void(^)(NSMutableArray *))handler{
    
    switch ((int)[WebServices sharedInstance].webRequestMode) {
            
        case WEB_REQUEST_LOGIN:{
            
            NSLog(@"response %@",withResponse);
            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            response = [withResponse objectForKey:@"response"];
            if ([[response objectForKey:@"Msg"] isEqualToString:@"success"]){
              
                        [OnDeck sharedInstance].strUserName =
                        [response objectForKey:@"username"];
                        [OnDeck sharedInstance].strPassword = [response  objectForKey:@"password"];
                [OnDeck sharedInstance].strauthKey = [[response objectForKey:@"User"] objectForKey:@"authKey"];
                [OnDeck sharedInstance].strRoleName = response[@"User"][@"role"][@"name"];
                        
                    //}
               // }
                
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Success"];
                [arraySucess addObject:[[response objectForKey:@"User"] objectForKey:@"id"]];
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
            case WEB_REQUEST_ASSET_OVERVIEW:
        {
            
            NSLog(@"response %@",withResponse);
            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            response = [withResponse objectForKey:@"response"];
            [OnDeck sharedInstance].strAsset = [response objectForKey:@"noofasset"];
            [OnDeck sharedInstance].strReporting = [response objectForKey:@"noofWasset"];
            [OnDeck sharedInstance].strNotReporting = [response objectForKey:@"noofNWasset"];
            
            
                    }
            break;
            
            case WEB_REQUEST_ALERT_OVERVIEW:
        {
            NSLog(@"response %@",withResponse);
            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            response = [withResponse objectForKey:@"response"];
            [OnDeck sharedInstance].strAlert = @"";
        }
            break;
            
        case WEB_REQUEST_ASSET:
        {
            NSMutableArray *arrAsset = [[NSMutableArray alloc] init];
            NSLog(@"response %@",withResponse);
            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            response = [withResponse objectForKey:@"response"];
            
            if ([[response objectForKey:@"Msg"] isEqualToString:@"Success"]){
                
                
                for(int i = 0; i<[[response objectForKey:@"lastgatewayreport"] count]; i++) {
                
                    
                    Asset *assetList = [[Asset alloc] init];
                    assetList.strAssetName = [[[response objectForKey:@"lastgatewayreport"] objectAtIndex:i] objectForKey:@"assetname"];
                    assetList.strGroupName = [[[response objectForKey:@"lastgatewayreport"] objectAtIndex:i] objectForKey:@"groupname"];
                    assetList.strAddress = [[[response objectForKey:@"lastgatewayreport"] objectAtIndex:i] objectForKey:@"address"];
                    assetList.strBattery = [[[response objectForKey:@"lastgatewayreport"] objectAtIndex:i] objectForKey:@"batt"];
                    assetList.strTemperature = [[[response objectForKey:@"lastgatewayreport"] objectAtIndex:i] objectForKey:@"temperature"];
                    [arrAsset objectAtIndex:i];
                    

                }
            
            
                NSMutableArray * arraySucess = [[NSMutableArray alloc]init];
                [arraySucess addObject:@"Success"];
                [arraySucess addObject:arrAsset];
                
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