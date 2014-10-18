//
//  sharedFunctions.m
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import "sharedFunctions.h"

@implementation sharedFunctions

+ (NSString *)generateCode {
    //Request code from php
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://otw.bobbywhite.ca/generate_code.php"]];
    
    //Response
    NSURLResponse *response;
    NSError *error2;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error2];
    NSString *responseMsg = [[NSString alloc] initWithData:POSTReply encoding:NSUTF8StringEncoding];
    NSLog(@"Random Code: %@", responseMsg);
    
    return responseMsg;
}

@end
