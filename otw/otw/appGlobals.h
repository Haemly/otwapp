//
//  appGlobals.h
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface appGlobals : NSObject

+ (id)sharedGlobals;

@property (nonatomic, strong) NSString* databasePath;
@property (nonatomic, strong) NSString* databaseName;

@property (nonatomic, strong) NSString* usercode;
@property (nonatomic, strong) NSString* createID;
@property (nonatomic, strong) NSString* connectID;

@property (nonatomic, strong) NSString* passengerLocation;


@end
