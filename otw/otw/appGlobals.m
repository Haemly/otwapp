//
//  appGlobals.m
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import "appGlobals.h"

@implementation appGlobals

+ (id)sharedGlobals
{
    static appGlobals *sharedMyGlobals = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyGlobals = [[self alloc] init];
    });
    
    return sharedMyGlobals;
}

// Initialize
- (id)init
{
    if (self = [super init])
    {
        _databaseName = @"database.sqlite";
    }
    
    return self;
}

@end
