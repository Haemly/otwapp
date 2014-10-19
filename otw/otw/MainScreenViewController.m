//
//  MainScreenViewController.m
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import "MainScreenViewController.h"
#import "appGlobals.h"
#import "sharedFunctions.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    //Hide the nav bar
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generateButton:(id)sender {
    [[appGlobals sharedGlobals] setUsercode:[sharedFunctions generateCode]];
    [self sendGeneratedCodeToPHP];
    [self performSegueWithIdentifier:@"segueToDriver" sender:self];
}

- (void)setCreateID {
    [[appGlobals sharedGlobals] setCreateID:[sharedFunctions generateCode]];
}

- (IBAction)connectButton:(id)sender {
    [self setConnectID];
    
    NSString *enteredCode = [[self textfieldConnectCode] text];
    NSString *connectID = [[appGlobals sharedGlobals] connectID];
    NSLog(@"%@", connectID);
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];

    //This array will hold the data being sent to php
    NSMutableArray *phpData = [[NSMutableArray alloc] init];
    
    //Create object that holds data
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:enteredCode forKey:@"usercode"];
    [dict setObject:connectID forKey:@"connectID"];
    [dict setObject:timestamp forKey:@"timestamp"];
    
    [phpData addObject:dict];
    
    //Prepare data to be sent to php
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:phpData options:kNilOptions error:&error];
    NSString *post = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://otw.bobbywhite.ca/passenger_intake.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    //Response
    NSURLResponse *response;
    NSError *error2;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error2];
    NSString *responseMsg = [[NSString alloc] initWithData:POSTReply encoding:NSUTF8StringEncoding];
    NSLog(@"Account creation response: %@", responseMsg);
    
    //Segue to passenger view controller
    [self performSegueWithIdentifier:@"segueToPassenger" sender:self];
}

- (void)setConnectID {
    [[appGlobals sharedGlobals] setConnectID:[sharedFunctions generateCode]];
}

- (void)sendGeneratedCodeToPHP {
    //Generate code for createID
    [self setCreateID];
    
    NSString *usercode = [[appGlobals sharedGlobals] usercode];
    NSString *createID = [[appGlobals sharedGlobals] createID];
    NSString *firstName;
    NSString *lastName;
    NSString *email;
    NSString *phone;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    if (sqlite3_open([[[appGlobals sharedGlobals] databasePath] UTF8String], &_database) == SQLITE_OK)
    {
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT first_name, last_name, email, phone_number FROM userinfo"];
        const char *sql_stmt = [sqlStatement UTF8String];
        
        if (sqlite3_prepare_v2(_database, sql_stmt, -1, &_compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(_compiledStatement) == SQLITE_ROW)
            {
                firstName = ((char *)sqlite3_column_text(_compiledStatement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(_compiledStatement, 0)] : @"";
                lastName = ((char *)sqlite3_column_text(_compiledStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(_compiledStatement, 1)] : @"";
                email = ((char *)sqlite3_column_text(_compiledStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(_compiledStatement, 2)] : @"";
                phone = ((char *)sqlite3_column_text(_compiledStatement, 3)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(_compiledStatement, 3)] : @"";
            } else {
                NSLog(@"Error: %s", sqlite3_errmsg(_database));
            }
        } else {
            NSLog(@"Error: %s", sqlite3_errmsg(_database));
        }
        
        sqlite3_finalize(_compiledStatement);
    } else {
        NSLog(@"Error: %s", sqlite3_errmsg(_database));
    }
    sqlite3_close(_database);
    
    NSLog(@"%@", firstName);

    //This array will hold the data being sent to php
    NSMutableArray *phpData = [[NSMutableArray alloc] init];
    
    //Create object that holds data
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usercode forKey:@"usercode"];
    [dict setObject:createID forKey:@"createID"];
    [dict setObject:firstName forKey:@"first_name"];
    [dict setObject:lastName forKey:@"last_name"];
    [dict setObject:email forKey:@"email"];
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:timestamp forKey:@"timestamp"];
    
    [phpData addObject:dict];
    
    //Prepare data to be sent to php
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:phpData options:kNilOptions error:&error];
    NSString *post = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://otw.bobbywhite.ca/accept_code.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    //Response
    NSURLResponse *response;
    NSError *error2;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error2];
    NSString *responseMsg = [[NSString alloc] initWithData:POSTReply encoding:NSUTF8StringEncoding];
    NSLog(@"Account creation response: %@", responseMsg);
}
@end
