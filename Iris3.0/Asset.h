//
//  Asset.h
//  Iris3.0
//
//  Created by Priya on 03/01/16.
//  Copyright © 2016 Priya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Asset : NSObject

@property (nonatomic, strong) NSString *strAssetName;
@property (nonatomic, strong) NSString *strGroupName;
@property (nonatomic, strong) NSString *strAddress;
@property (nonatomic, strong) NSString *strBattery;
@property (nonatomic, strong) NSString *strTemperature;
@property (nonatomic, strong) NSString *strSignal;

@end
