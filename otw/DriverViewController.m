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

@implementation DriverViewController {
    CLLocationManager *locationManager;
    BOOL initialSet;
}

static NSString *cellIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Populate pre-determined messages
    self.messages = [[NSArray alloc] initWithObjects:@"Stuck in traffic", @"Stopping at store", @"Running late", @"Almost there", nil];
    cellIdentifier = @"rowCell";
    [self.messageTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    //Set label to have the generated code
    [self setGeneratedCodeLabel];
    
    //Label touch control
    UILabel *label = [self labelCode];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [label addGestureRecognizer:tapGesture];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [self.messages objectAtIndex:indexPath.row];
    cell.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    cell.alpha = 0.90;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self addEvent:[[self messages] objectAtIndex:indexPath.row]];
    NSLog(@"Event added");
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
    
    // Set up location manager
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization]; ;
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager startUpdatingLocation];
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

- (void)addEvent:(NSString *)string {
    //This array will hold the data being sent to php
    NSMutableArray *phpData = [[NSMutableArray alloc] init];
    
    NSString *usercode = [[appGlobals sharedGlobals] usercode];
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSString *who = @"0";
    
    //Create object that holds data
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usercode forKey:@"usercode"];
    [dict setObject:string forKey:@"text"];
    [dict setObject:who forKey:@"who"];
    [dict setObject:timestamp forKey:@"timestamp"];
    
    
    [phpData addObject:dict];
    
    //Prepare data to be sent to php
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:phpData options:kNilOptions error:&error];
    NSString *post = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://otw.bobbywhite.ca/add_event.php"]];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ([[[appGlobals sharedGlobals] driverStartLat] isEqualToString:@""]) {
        [[appGlobals sharedGlobals] setDriverStartLat:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude]];
        [[appGlobals sharedGlobals] setDriverStartLong:[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude]];
    } else if (!initialSet) {
        [self updateDriverInitialPosition];
        initialSet = YES;
    }
}

- (void) updateDriverInitialPosition {
    NSString *usercode = [[appGlobals sharedGlobals] usercode];
    NSString *createID = [[appGlobals sharedGlobals] createID];
    NSString *driverStartLat = [[appGlobals sharedGlobals] driverStartLat];
    NSString *driverStartLong = [[appGlobals sharedGlobals] driverStartLong];
    
    //This array will hold the data being sent to php
    NSMutableArray *phpData = [[NSMutableArray alloc] init];
    
    //Create object that holds data
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usercode forKey:@"usercode"];
    [dict setObject:createID forKey:@"createID"];
    [dict setObject:driverStartLat forKey:@"driverStartLat"];
    [dict setObject:driverStartLong forKey:@"driverStartLong"];
    
    [phpData addObject:dict];
    
    //Prepare data to be sent to php
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:phpData options:kNilOptions error:&error];
    NSString *post = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://otw.bobbywhite.ca/update_driver_initial_gps.php"]];
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
    NSLog(@"Update Driver Initial GPS: %@", responseMsg);
}


@end
