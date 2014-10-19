//
//  PassengerViewController.h
//  otw
//
//  Created by Bobby White on 2014-10-18.
//  Copyright (c) 2014 bobbywhite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PassengerViewController : UIViewController <CLLocationManagerDelegate>
- (IBAction)button:(id)sender;

@end
