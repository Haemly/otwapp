//
//  DriverViewController.m
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import "DriverViewController.h"
#import "appGlobals.h"

@interface DriverViewController ()

@end

@implementation DriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set label to have the generated code
    [self setGeneratedCodeLabel];
    
    //Label touch control
    UILabel *label = [self labelCode];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [label addGestureRecognizer:tapGesture];
}

- (void)labelTap {
    //Set label contents to iOS clipboard
    NSString *string = [[self labelCode] text];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:string];
    
    NSLog(@"Code Copied To Clipboard");
}

- (void)viewWillAppear:(BOOL)animated
{
    //Hide the nav bar
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setGeneratedCodeLabel {
    [[self labelCode] setText:[[appGlobals sharedGlobals] usercode]];
}

@end
