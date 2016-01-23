//
//  OnDeck.h
//  GDSWayFinder
//
//  Created by Openwave Computing on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpDesk.h"
@interface OnDeck : NSObject{
    
    BOOL isDeviceOrSimulator;
}

@property (nonatomic, retain) id refPresntedVC;

@property (nonatomic, retain) NSString *strPanic;

@property (nonatomic, assign) BOOL isDeviceOrSimulator;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, assign) BOOL isDeviceiPhone5;
@property (nonatomic, retain) NSString *strDeviceVersion;

@property (nonatomic, retain) NSString *strName;
@property (nonatomic, retain) NSString *strUserName;
@property (nonatomic, retain) NSString *strPassword;


@property (nonatomic, retain) NSUserDefaults *userPreferences;
@property (nonatomic, assign) BOOL isProfilePicUploaded;
@property (nonatomic, assign) BOOL dismissPickUpView;
@property (nonatomic, assign) BOOL isMenuOpen;
@property (nonatomic, assign) BOOL isLocationAvailable;






- (void)loadUserInfo;
- (BOOL)isUserAlreadyExists;
- (void)setAutoSignIn;
- (void)signOutUser;



+ (OnDeck *)sharedInstance;





@end
