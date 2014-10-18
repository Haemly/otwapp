//
//  ViewController.h
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface EnterInfoViewController : UIViewController

@property (nonatomic) sqlite3_stmt *compiledStatement;

@end

