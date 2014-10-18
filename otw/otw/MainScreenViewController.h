//
//  MainScreenViewController.h
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface MainScreenViewController : UIViewController

@property (nonatomic) sqlite3 *database;
@property (nonatomic) sqlite3_stmt *compiledStatement;

@property (strong, nonatomic) IBOutlet UITextField *textfieldGenerateCode;
@property (strong, nonatomic) IBOutlet UITextField *textfieldConnectCode;
- (IBAction)generateButton:(id)sender;
- (IBAction)connectButton:(id)sender;



@end
