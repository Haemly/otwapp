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

- (IBAction)plus1:(id)sender {
    [self addTime:1];
}

- (IBAction)plus2:(id)sender {
    [self addTime:2];
}

- (IBAction)plus5:(id)sender {
    [self addTime:5];
}

- (IBAction)plus10:(id)sender {
    [self addTime:10];
}

- (IBAction)plus15:(id)sender {
    [self addTime:15];
}

- (IBAction)plus30:(id)sender {
    [self addTime:30];
}

- (void)addTime:(int)time {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://otw.bobbywhite.ca/add_time.php?usercode=%@&time=%i&timestamp=%f", [[appGlobals sharedGlobals] usercode], time, [[NSDate date] timeIntervalSince1970]]]];
    
    //Response
    NSURLResponse *response;
    NSError *error2;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error2];
    NSString *responseMsg = [[NSString alloc] initWithData:POSTReply encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", responseMsg);
}


@end
