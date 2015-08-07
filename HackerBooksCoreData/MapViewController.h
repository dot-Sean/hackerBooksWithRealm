//
//  MapViewController.h
//  HackerBooksRealm
//
//  Created by Jose Manuel Franco on 6/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
@import MapKit;

@interface MapViewController: UIViewController <XLFormRowDescriptorViewController,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end
