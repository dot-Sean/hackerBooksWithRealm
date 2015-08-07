//
//  MapViewController.m
//  HackerBooksRealm
//
//  Created by Jose Manuel Franco on 6/8/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "MapViewController.h"
#import "Location.h"

@interface MapAnnotation : NSObject  <MKAnnotation>
@end

@implementation MapAnnotation
@synthesize coordinate = _coordinate;
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}
@end

@interface MapViewController () <MKMapViewDelegate>


@end

@implementation MapViewController

@synthesize rowDescriptor = _rowDescriptor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    
    
    // Do any additional setup after loading the view.
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    if (self.rowDescriptor.value){
        Location *location=(Location *)self.rowDescriptor.value;
        CLLocation *clObj = [[CLLocation alloc] initWithLatitude:location.latitude
                                                       longitude:location.longitude];
        
        [self.mapView setCenterCoordinate:clObj.coordinate];
        self.title = [NSString stringWithFormat:@"%0.4f, %0.4f", location.latitude, location.longitude];
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.coordinate = self.mapView.centerCoordinate;
        [self.mapView addAnnotation:annotation];
    }else{
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"annotation"];
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    pinAnnotationView.draggable = YES;
    pinAnnotationView.animatesDrop = YES;
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState{
    
    if (newState == MKAnnotationViewDragStateEnding){
        Location *location=
        [[Location alloc]initWithLatitude:view.annotation.coordinate.latitude
                             andLongitude:view.annotation.coordinate.longitude];
        
        self.rowDescriptor.value = location;
        self.title = [NSString stringWithFormat:@"%0.4f, %0.4f", location.latitude, location.longitude];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (newLocation != nil){
        if((newLocation.coordinate.latitude==oldLocation.coordinate.latitude) &&
           (newLocation.coordinate.longitude==oldLocation.coordinate.longitude)){
            
        }else{
            Location *location=
            [[Location alloc]initWithLatitude:newLocation.coordinate.latitude
                                 andLongitude:newLocation.coordinate.longitude];
            
            self.rowDescriptor.value = location;
            self.title = [NSString stringWithFormat:@"%0.4f, %0.4f", location.latitude, location.longitude];

            
            [self.mapView setCenterCoordinate:((CLLocation *)newLocation).coordinate];
            MapAnnotation *annotation = [[MapAnnotation alloc] init];
            annotation.coordinate = self.mapView.centerCoordinate;
            [self.mapView addAnnotation:annotation];
        }
    }
}


@end
