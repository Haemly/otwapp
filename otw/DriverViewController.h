//
//  DriverViewController.h
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *labelCode;

//Add time buttons
- (IBAction)plus1:(id)sender;
- (IBAction)plus2:(id)sender;
- (IBAction)plus5:(id)sender;
- (IBAction)plus10:(id)sender;
- (IBAction)plus15:(id)sender;
- (IBAction)plus30:(id)sender;

@property (nonatomic, strong) NSArray *messages;
@property (strong, nonatomic) IBOutlet UITableView *messageTableView;
@end
