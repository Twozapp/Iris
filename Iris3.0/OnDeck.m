//
//  OnDeck.m
//  GDSWayFinder
//
//  Created by Openwave Computing on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnDeck.h"

@implementation OnDeck

@synthesize refPresntedVC;

@synthesize strPanic;
@synthesize isDeviceOrSimulator;
@synthesize deviceToken;
@synthesize isDeviceiPhone5;
@synthesize strDeviceVersion;
@synthesize userPreferences;
@synthesize strName;
@synthesize strUserName;
@synthesize strPassword;



@synthesize isProfilePicUploaded;
//@synthesize currentBookingID;
@synthesize isMenuOpen;

@synthesize isLocationAvailable;





#pragma mark - Singleton methods

+ (OnDeck*)sharedInstance
{
    static OnDeck *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[[self class] alloc] init];
        
       
#if TARGET_IPHONE_SIMULATOR
        sharedInstance.isDeviceOrSimulator = YES;
#else
        sharedInstance.isDeviceOrSimulator = NO;
#endif
        
       
        sharedInstance.userPreferences = [NSUserDefaults standardUserDefaults];
        
        
        
        

    });
    return sharedInstance;
}

#pragma mark - Auto Sign In

- (void)loadUserInfo{
    
    self.strUserName = [userPreferences stringForKey:@"email"] == nil ? @"" : [userPreferences stringForKey:@"email"];
    self.strPassword = [userPreferences stringForKey:@"password"] == nil ? @"" : [userPreferences stringForKey:@"password"];
   
}

- (BOOL)isUserAlreadyExists{
    
    self.strUserName = [userPreferences stringForKey:@"email"] == nil ? @"" : [userPreferences stringForKey:@"email"];
    self.strPassword = [userPreferences stringForKey:@"password"] == nil ? @"" : [userPreferences stringForKey:@"password"];
   
    if (![self.strUserName  isEqual: @""] && ![self.strPassword  isEqual:@""] ){
        //User Already Exists
        return YES;
    }
    else {
        return NO;
    }
    return NO;
    
   // && ![self.accountType  isEqual:@""
    
}//End of isUserAlreadyLogged method

- (void)setAutoSignIn{
    
    //Store User Information into the device
    [userPreferences setObject:self.strUserName forKey:@"email"];
    [userPreferences setObject:self.strPassword forKey:@"password"];
   
    
    
    //Saving
    [userPreferences synchronize];
}

- (void)signOutUser{
    //Clearing the user preferences
    [userPreferences setObject:@"" forKey:@"email"];
    [userPreferences setObject:@"" forKey:@"password"];
   
    
    [userPreferences synchronize];
    //    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}



@end
