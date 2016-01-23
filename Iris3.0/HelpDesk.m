
//
//  HelpDesk.m
//  WayFinder
//
//  Created by Openwave Computing on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  HelpDesk Class by Ahshif Abdeen 

#import "HelpDesk.h"

@implementation HelpDesk

@synthesize device;
@synthesize requestObject;
@synthesize alertOkButtonPressed;

#pragma mark - Singleton methods

+ (HelpDesk*)sharedInstance
{
    static HelpDesk *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[[self class] alloc] init];
        
        
        //Set the device value here 
        
        if ([sharedInstance isDeviceiPad]){
            sharedInstance.device = @"iPad";
        }else{
            if ([sharedInstance isDeviceiPodTouch]){
                sharedInstance.device = @"iPod";
                
            }else{
                sharedInstance.device = @"iPhone";
            }
            
        } 
    });
    return sharedInstance;
    
}


#pragma mark - Validation of Strings


- (BOOL)isFieldEmpty:(NSString *)string{
    
    if ([[self trimSpaces:string] length] <= 0){
        
        return YES;
        
    }
    return  NO; 
    
}

- (NSString *)trimSpaces:(NSString *)string{
    
    return [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (BOOL)isEmailValid:email{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isPhoneNumberValid:(id)number{
    
    NSString *phoneRegex = @"[0-9+-]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phoneTest evaluateWithObject:number];
    return isValid;
    
}





- (BOOL)isPasswordSame:(NSString *)password confirmPassword:(NSString *)confirmPassword{

    if ([password compare:confirmPassword] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
    
}

- (BOOL)isStringGreaterThanSixCharacters:(NSString*)string{
    if ([string length]>=6) {
        return YES;
    }
    return NO;
}

//Username Validation goes here

- (BOOL)isValidFirstName:strSource{
    NSString *usernameRegex = @"[A-Z-a-z- ]+";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    BOOL isValid = [usernameTest evaluateWithObject:strSource];
    return isValid;
}
- (BOOL)isValidLastName:strSource{
    NSString *LastnameRegex = @"[A-Z-a-z- ]+";
    NSPredicate *LastnameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",LastnameRegex ];
    BOOL isValid = [LastnameTest evaluateWithObject:strSource];
    return isValid;
}


- (BOOL)isValidGroupName:strSource{
    NSString *usernameRegex = @"[A-Z-a-z-0-9 ]+";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    BOOL isValid = [usernameTest evaluateWithObject:strSource];
    return isValid;
}

- (BOOL)isValidMobileNumber:strSource{
    
    NSString *usernameRegex =  @"^([0-9]+)?([\\,\\.]([0-9]{1,2})?)?$";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    BOOL isValid = [usernameTest evaluateWithObject:strSource];
    return isValid;
}


#pragma mark - Internet Stuff

- (BOOL)isInternetAvailable{

    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    BOOL internet;
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
        internet = NO;
    } else {
        internet = YES;
    }
    return internet;
}

- (void)alertUserAboutNetwork{
    //Check Internet Connection and Alert
    if (![[HelpDesk sharedInstance] isInternetAvailable]) {
//        [[SlideAlert sharedSlideAlert] emergencyHideSlideAlertView];
//        [[SlideAlert sharedSlideAlert] showSlideAlertViewWithStatus:@"Failure" withText:@"Network Offline"];
    }
}

- (BOOL)validateUrl:(NSString *)url{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
}

#pragma mark - Web Service Encryption

- (NSString *)getMD5Hash:(NSString *)string{
    
    return [string MD5];
    
}

- (NSString *)getBase64:(NSString *)string{
    
    [Base64 initialize];
    
    NSData *stringData = [string dataUsingEncoding:NSASCIIStringEncoding];
    return [Base64 encode:stringData];
    
}

#pragma mark - Device Check


- (BOOL)isDeviceiPad{
    
#ifdef UI_USER_INTERFACE_IDIOM
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}

- (BOOL)isDeviceiPodTouch{
    
    //iPhone Simulator
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]){
        return NO;
    }else
        return YES;
}

- (BOOL)isiOS4Installed{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if([version floatValue ] >= 4.0){
        return YES;
    }
    return NO;
    
}

#pragma mark - Alerts

- (void)showConfirmaionAlert:(NSString *)title withMessage:(NSString *)message forRequestedObject:(id)reqObject{
    self.requestObject = reqObject;
    UIAlertView *confirmationMessage = [[UIAlertView alloc] initWithTitle:title  
                                                                  message:message  
                                                                 delegate:self  
                                                        cancelButtonTitle:@"Cancel"  
                                                        otherButtonTitles:@"Ok",nil];  
    [confirmationMessage show];  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            self.alertOkButtonPressed = NO;
            break;
        case 1:
            self.alertOkButtonPressed = YES;
            break;
        default:
            break;
    }
    
    //Return back the control to requested object 
   // [requestObject performSelectorOnMainThread:@selector(alertConfirmationDelegate) withObject:nil waitUntilDone:YES];
}

#pragma mark - Smart Functions

- (void)scrollViewAnimation:(UIScrollView*)scrollView pointX:(float)xOffset pointY:(float)yOffset{
    //Set ScrollView Animation
    [UIScrollView beginAnimations:@"scrollAnimation" context:nil];
    [UIScrollView setAnimationDuration:0.1];
    [scrollView setContentOffset:CGPointMake(xOffset, yOffset)];
    [UIScrollView commitAnimations];
}

- (NSString *)getStringByEliminatingNull:(NSString *)string{
    return (NSString*)string == (NSString*)[NSNull null] ? @"" : string;
}

#pragma mark - Get Maximum date

- (NSDate *)getMaximumDateForDatePicker{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    //Set the year for the user to select only older than 18; Reduce 18 from the current date and show to the user
    [comps setYear:-18];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    return maxDate;
}

- (NSString*)convertMMMdyyyy:(NSString*)dateToBeConverted{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"MMM d, yyyy"];
    NSDate *date1 = [dateFormat1 dateFromString:dateToBeConverted];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormat2 stringFromDate:date1];
}

- (NSString*)convertyyyyMMdd:(NSString*)dateToBeConverted{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormat1 dateFromString:dateToBeConverted];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MMM d, yyyy"];    
    return [dateFormat2 stringFromDate:date1];
}

- (NSString*)convertMediumStyle:(NSString*)dateToBeConverted{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateStyle:NSDateFormatterMediumStyle];
    NSDate *date1 = [dateFormat1 dateFromString:dateToBeConverted];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MMM d, yyyy"];    
    return [dateFormat2 stringFromDate:date1];
}

//2012-11-28 15:41:12
- (NSString*)convertFromWebServiceDateAndTime:(NSString*)dateToBeConverted{
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [dateFormat1 dateFromString:dateToBeConverted];
    
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MMM d, yyyy HH:mm "];    
    return [dateFormat2 stringFromDate:date1];
}

-(BOOL)isValidString:(NSString *)string
{
    return YES;
}

- (void)requestPUSHNotification{
    
    
//    NSString *reqMode = @"Get User Notification";
//    
//    
//    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
//    //[arguments setObject:[OnDeck sharedInstance].userID forKey:@"user_id"];
//    
//    [WebServices sharedInstance].webRequestBackGroundMode = (WebRequestMode *)WEB_REQUEST_PUSH_NOTIFICATIONS;
//    [[WebServices sharedInstance] composeWebRequestFromArguments:arguments webRequestBackGroundMode:[WebServices sharedInstance].webRequestBackGroundMode responseWithStatus:^(NSString *status){
//        // Stop Loading
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        
//        if ([status compare:@"Success"] == NSOrderedSame) {
//            NSLog(@"%@ - Success", reqMode);
//            
//        }
//        else{
//            NSLog(@"%@ - Failure", reqMode);
//        }
//    }];
//    
    
    
}

//- (void)requestInviteUsers:(NSMutableDictionary *)arguments{
//    
//    
//    NSString *reqMode = @"Get User Notification";
//    
//    [WebServices sharedInstance].webRequestBackGroundMode = (WebRequestMode *)WEB_REQUEST_INVITE_USERS;
//    [[WebServices sharedInstance] composeWebRequestFromArguments:arguments webRequestBackGroundMode:[WebServices sharedInstance].webRequestBackGroundMode responseWithStatus:^(NSString *status){
//        // Stop Loading
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        
//        if ([status compare:@"Success"] == NSOrderedSame) {
//            NSLog(@"%@ - Success", reqMode);
//            
//        }
//        else{
//            NSLog(@"%@ - Failure", reqMode);
//        }
//    }];
//    
//    
//
//    
//}


#pragma mark - Caching Images Stuff

- (NSString *)composedNameForImageCache:(NSString *)url{
    NSString *composedName = url;
    composedName = [composedName stringByReplacingOccurrencesOfString:@"/"  withString:@""];
    composedName = [composedName stringByReplacingOccurrencesOfString:@"."  withString:@""];
    composedName = [composedName stringByReplacingOccurrencesOfString:@":"  withString:@""];
    composedName = [composedName stringByReplacingOccurrencesOfString:@"-"  withString:@""];
    composedName= [NSString stringWithFormat:@"%@%@",composedName,@".png"];
    return composedName;
}

- (void)saveImageToCache:(UIImage *)image withName:(NSString *)name{
    NSString *composedName = [self composedNameForImageCache:name];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:composedName];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
    // NSLog(@"Saved Path - %@", fullPath);
}

- (UIImage *)loadImageFromCache:(NSString *)name{
    NSString *composedName = [self composedNameForImageCache:name];
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:composedName];
    UIImage *result = [UIImage imageWithContentsOfFile:fullPath];
    
    // Threshold Logic
    // NSLog(@"Loaded Path - %@", fullPath);
    
    // NSLog(@"files array %@", filePathsArray);
    // NSLog(@"files array %i", filePathsArray.count);
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:documentsDirectory error:nil][NSFileSize] unsignedLongLongValue];
    // NSLog(@"File Size - %llu Bytes, %llu kb, %llu mb", fileSize, fileSize/1024, fileSize/(1024*1024));
    
    unsigned long long fileSizeInMB = fileSize/(1024*1024);
    if (fileSizeInMB>30) {
        NSMutableArray *fileArray = [[NSMutableArray alloc] init];
        
        NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
        
        for (NSString *path in directoryEnumerator) {
            if ([[path pathExtension] isEqualToString:@"png"]){
                NSMutableDictionary *fileDict = [[NSMutableDictionary alloc] init];
                [fileDict setObject:path forKey:@"path"];
                [fileDict setObject:[directoryEnumerator fileAttributes] forKey:@"attributes"];
                [fileArray addObject:fileDict];
            }
        }
        
        [fileArray sortUsingComparator: (NSComparator)^(NSDictionary *a, NSDictionary *b){
            NSDate *date1 = [[a objectForKey:@"attributes"] objectForKey: @"NSFileCreationDate"];
            NSDate *date2 = [[b objectForKey:@"attributes"] objectForKey: @"NSFileCreationDate"];
            return [date1 compare:date2];
        }];
        
        if (fileArray.count>0)
            [self removeImageFromCacheWithName:[[fileArray objectAtIndex:0] objectForKey:@"path"]];
    }
    return result;
    
}

- (void)removeImageFromCache:(NSString *)nameWithSymbols{
    NSString *composedName = [self composedNameForImageCache:nameWithSymbols];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:composedName];
    [fileManager removeItemAtPath:fullPath error:nil];
    
    NSLog(@"Removed Path - %@", fullPath);
}

- (void)removeImageFromCacheWithName:(NSString *)fileName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    [fileManager removeItemAtPath:fullPath error:nil];
    
    NSLog(@"Removed Path - %@", fullPath);
}
#pragma mark PopUp


/*- (void)actionPopUp: (id)sender viewpresent:(UIView *)presentView stringKey:(NSNumber *)keyString
{
    self.visiblePopTipViews = [NSMutableArray array];
    
    self.contents = [NSDictionary dictionaryWithObjectsAndKeys:
                     // Rounded rect buttons
                     @"Update your current status to peoples and friends", [NSNumber numberWithInt:11],
                     @"Rate Salon", [NSNumber numberWithInt:12],
                     @"Turn on schedule status to enable your week schedules", [NSNumber numberWithInt:13],
                     @"Turn On & Update your weekday routine.", [NSNumber numberWithInt:14],
                     @"Shortlist Salons Using Filters", [NSNumber numberWithInt:15],
                     [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appicon57.png"]], [NSNumber numberWithInt:16],	// content can be a UIView
                     // Nav bar buttons
                     @"Tap here to see What your friends are doing right now!", [NSNumber numberWithInt:21],
                     @"Two popup animations are provided: slide and pop. Tap other buttons to see them both.", [NSNumber numberWithInt:22],
                     // Toolbar buttons
                     @"CMPopTipView will automatically point at buttons either above or below the containing view.", [NSNumber numberWithInt:31],
                     @"The arrow is automatically positioned to point to the center of the target button.", [NSNumber numberWithInt:32],
                     @"CMPopTipView knows how to point automatically to UIBarButtonItems in both nav bars and tool bars.", [NSNumber numberWithInt:33],
                     nil];
    self.titles = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"Title", [NSNumber numberWithInt:21],
                   @"Schedule Status", [NSNumber numberWithInt:52],
                   @"On/Off", [NSNumber numberWithInt:54],
                   @"Weekday Schedule", [NSNumber numberWithInt:53],
                   @"Add", [NSNumber numberWithInt:55],
                   @"Your Status", [NSNumber numberWithInt:56],
                   nil];
    
    // Array of (backgroundColor, textColor) pairs.
    // NSNull for either means leave as default.
    // A color scheme will be picked randomly per CMPopTipView.
    self.colorSchemes = [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:[NSNull null], [NSNull null], nil],
                         [NSArray arrayWithObjects:[UIColor colorWithRed:94.0f/255.0f green:50.0f/255.0f blue:124.0f/255.0f alpha:1.0], [NSNull null], nil],
                         [NSArray arrayWithObjects:[UIColor darkGrayColor], [NSNull null], nil],
                         [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor darkTextColor], nil],
                         [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor blueColor], nil],
                         [NSArray arrayWithObjects:[UIColor colorWithRed:220.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0], [NSNull null], nil],
                         nil];
    
    [self dismissAllPopTipViews];
    {
        //    if (sender == self.currentPopTipViewTarget) {
        //        // Dismiss the popTipView and that is all
        //        self.currentPopTipViewTarget = nil;
        //    }
        //    else {
        NSString *contentMessage = nil;
        UIView *contentView = nil;
        //        NSNumber *key = [NSNumber numberWithInteger:12];
        id content = [self.contents objectForKey:keyString];
        if ([content isKindOfClass:[UIView class]]) {
            contentView = content;
        }
        else if ([content isKindOfClass:[NSString class]]) {
            contentMessage = content;
        }
        else {
            //            contentMessage = @"Schedule Your Status";
            contentMessage = nil;
            
        }
        NSArray *colorScheme = [self.colorSchemes objectAtIndex:1];
        UIColor *backgroundColor = [colorScheme objectAtIndex:0];
        UIColor *textColor = [colorScheme objectAtIndex:1];
        
        NSString *title = [self.titles objectForKey:keyString];
        
       
        
         Some options to try.
 
        //popTipView.disableTapToDismiss = YES;
        //popTipView.preferredPointDirection = PointDirectionUp;
        //popTipView.hasGradientBackground = NO;
        popTipView.cornerRadius = 15.0;
        //popTipView.sidePadding = 30.0f;
        //popTipView.topMargin = 20.0f;
        //popTipView.pointerSize = 50.0f;
        //popTipView.hasShadow = NO;
        
        if (backgroundColor && ![backgroundColor isEqual:[NSNull null]]) {
            popTipView.backgroundColor = backgroundColor;
        }
        if (textColor && ![textColor isEqual:[NSNull null]]) {
            popTipView.textColor = textColor;
        }
        
        popTipView.animation = arc4random() % 2;
        popTipView.has3DStyle = (BOOL)(arc4random() % 2);
        
        popTipView.dismissTapAnywhere = YES;
        //        [popTipView autoDismissAnimated:YES atTimeInterval:3.0];
        
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sender;
            [popTipView presentPointingAtView:button inView:presentView animated:YES];
        }
        else if ([sender isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)sender;
            [popTipView presentPointingAtView:label inView:presentView animated:YES];
            
            
        }
        else if ([sender isKindOfClass:[UISwitch class]]) {
            UISwitch *viewSwitch = (UISwitch *)sender;
            [popTipView presentPointingAtView:viewSwitch inView:presentView animated:YES];
            
            
        }
        
        else if ([sender isKindOfClass:[UISegmentedControl class]]) {
            UISegmentedControl *viewSegmnt = (UISegmentedControl *)sender;
            [popTipView presentPointingAtView:viewSegmnt inView:presentView animated:YES];
            
            
        }
        else if ([sender isKindOfClass:[UIView class]]) {
            UIView *titleView = (UIView *)sender;
            [popTipView presentPointingAtView:titleView inView:presentView animated:YES];
            
            
        }
        
        else
        {
            UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
            [popTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
        }
        
        [self.visiblePopTipViews addObject:popTipView];
        self.currentPopTipViewTarget = sender;
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                             popTipView.center = CGPointMake(popTipView.center.x,
                                                             popTipView.center.y + 20);
                         }
                         completion:NULL];
        
    }
    
}*/
/*- (void)dismissAllPopTipViews
{
    while ([self.visiblePopTipViews count] > 0) {
        CMPopTipView *popTipView = [self.visiblePopTipViews objectAtIndex:0];
        [popTipView dismissAnimated:YES];
        [self.visiblePopTipViews removeObjectAtIndex:0];
    }
}

#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}*/


@end
