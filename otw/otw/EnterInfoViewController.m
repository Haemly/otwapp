//
//  ViewController.m
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import "EnterInfoViewController.h"
#import "appGlobals.h"

@interface EnterInfoViewController ()

@end

@implementation EnterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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

//Background tap resign keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)enterInfoButton:(id)sender {
    NSString *firstName = [[self firstName] text];
    NSString *lastName = [[self lastName] text];
    NSString *email = [[self email] text];
    NSString *phone = [[self phoneNumber] text];
    
    //Enter user info into table
    if (sqlite3_open([[[appGlobals sharedGlobals] databasePath] UTF8String], &_database) == SQLITE_OK)
    {
        NSString *sqlStatement = [NSString stringWithFormat:@"UPDATE userinfo SET first_name = '%@', last_name = '%@', email = '%@', phone_number = '%@' WHERE rowID = '1'", firstName, lastName, email, phone];
        const char *sql_stmt = [sqlStatement UTF8String];
        
        if (sqlite3_prepare_v2(_database, sql_stmt, -1, &_compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_exec(_database, sql_stmt, NULL, NULL, 0);
        } else {
            NSLog(@"Error: %s", sqlite3_errmsg(_database));
        }
        sqlite3_finalize(_compiledStatement);
        
        //Set infoset to 1
        NSString *sql2 = [NSString stringWithFormat:@"UPDATE initialload SET infoset = '1'"];
        const char *sql_stmt2 = [sql2 UTF8String];
        
        if (sqlite3_prepare_v2(_database, sql_stmt, -1, &_compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_exec(_database, sql_stmt2, NULL, NULL, 0);
        } else {
            NSLog(@"Error: %s", sqlite3_errmsg(_database));
        }
        sqlite3_finalize(_compiledStatement);
    } else {
        NSLog(@"Error: %s", sqlite3_errmsg(_database));
    }
    sqlite3_close(_database);
    
    [self performSegueWithIdentifier:@"infoToMain" sender:self];
}

@end
