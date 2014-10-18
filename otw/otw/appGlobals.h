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


@end
