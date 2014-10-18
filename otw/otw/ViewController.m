//
//  ViewController.m
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import "ViewController.h"
#import "appGlobals.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[[appGlobals sharedGlobals] databasePath]];
        
        // Copy the database from the package to the user's file system
        [fileManager copyItemAtPath:databasePathFromApp toPath:[[appGlobals sharedGlobals] databasePath] error:nil];
        
        NSLog(@"Database Created");
        NSLog(@"Database Path: %@", [[appGlobals sharedGlobals] databasePath]);
    }
}

@end
