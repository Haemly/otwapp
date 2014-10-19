//
//  PassengerViewController.m
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import "PassengerViewController.h"
#import "appGlobals.h"

@interface PassengerViewController ()

@end

@implementation PassengerViewController {
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)viewDidDisappear:(BOOL)animated
{
    
    [locationManager stopUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ([[[appGlobals sharedGlobals] passengerLat] isEqualToString:@""]) {
        [[appGlobals sharedGlobals] setPassengerLat:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude]];
        [[appGlobals sharedGlobals] setPassengerLong:[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude]];
    } else {
        [locationManager stopUpdatingLocation];
        [self updatePassengerLocation];
    }
}

- (void)updatePassengerLocation {
    NSString *usercode = [[appGlobals sharedGlobals] usercode];
    NSString *connectID = [[appGlobals sharedGlobals] connectID];
    NSString *passengerLat = [[appGlobals sharedGlobals] passengerLat];
    NSString *passengerLong = [[appGlobals sharedGlobals] passengerLong];
    NSLog(@"Connect ID: %@", connectID);
    
    //This array will hold the data being sent to php
    NSMutableArray *phpData = [[NSMutableArray alloc] init];
    
    //Create object that holds data
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usercode forKey:@"usercode"];
    [dict setObject:connectID forKey:@"connectID"];
    [dict setObject:passengerLat forKey:@"passengerLat"];
    [dict setObject:passengerLong forKey:@"passengerLong"];
    
    [phpData addObject:dict];
    
    //Prepare data to be sent to php
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:phpData options:kNilOptions error:&error];
    NSString *post = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://otw.bobbywhite.ca/update_passenger_gps.php"]];
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
    NSLog(@"Update Passenger GPS: %@", responseMsg);
}

- (IBAction)button:(id)sender {
    NSLog(@"%@", [[appGlobals sharedGlobals] passengerLat]);
}

@end
