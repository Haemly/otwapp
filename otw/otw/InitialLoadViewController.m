//
//  blahViewController.m
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import "InitialLoadViewController.h"
#import "appGlobals.h"

@interface InitialLoadViewController ()

@end

@implementation InitialLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Get database path
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    [[appGlobals sharedGlobals] setDatabasePath:[documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[appGlobals sharedGlobals] databaseName]]]];
    
    [self checkAndCreateDatabase];
    
    //Check if initial info was set, and go to appropriate screen
    if ([self checkIfInfoEntered]) {
        [self performSegueWithIdentifier:@"segueToMain" sender:self];
    } else {
        [self performSegueWithIdentifier:@"segueToEnterInfo" sender:self];
    }
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

-(BOOL)checkIfInfoEntered {
    NSString *setinfo;
    
    if (sqlite3_open([[[appGlobals sharedGlobals] databasePath] UTF8String], &_database) == SQLITE_OK)
    {
        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT infoset FROM initialload"];
        const char *sql_stmt = [sqlStatement UTF8String];
        
        if (sqlite3_prepare_v2(_database, sql_stmt, -1, &_compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(_compiledStatement) == SQLITE_ROW)
            {
                setinfo = ((char *)sqlite3_column_text(_compiledStatement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(_compiledStatement, 0)] : @"";
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
    
    //If setinto is set to 1 in localdatabase, skip set info screen
    
    if ([setinfo isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
    
    return NO;
}

-(void)checkAndCreateDatabase
{
    // Check if the SQLite database has already been saved to the user's device, if not then copy it over
    BOOL success;
    
    // Create a FileManager object, we will use this to check the status of the database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the user's file system
    success = [fileManager fileExistsAtPath:[[appGlobals sharedGlobals] databasePath]];
    
    // If the database already exists then return without doing anything
    if (success)
    {
        NSLog(@"Database Already Exists");
    }
    else
    {
        // If not then proceed to copy the database from the application to the user's file system
        
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[appGlobals sharedGlobals] databaseName]];
        
        // Copy the database from the package to the user's file system
        [fileManager copyItemAtPath:databasePathFromApp toPath:[[appGlobals sharedGlobals] databasePath] error:nil];
        
        NSLog(@"Database Created");
        NSLog(@"Database Path: %@", [[appGlobals sharedGlobals] databasePath]);
    }
}


@end
