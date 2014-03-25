//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Jaime Hernandez on 3/25/14.
//  Copyright (c) 2014 Jaime Hernandez. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>
{
    NSDictionary *returnedLocationsDictionary;
    NSArray      *returnedLocationsArray;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property MKPointAnnotation* locationAnnotation;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Get location (Mobile Makers//
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.89373984, -87.63532979);
        
    // Display the location in a certain size
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
    
    // tell the map the region it will display
    self.myMapView.region = region;
    
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error;
        returnedLocationsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        returnedLocationsArray = returnedLocationsDictionary[@"row"];
        
        // Loop thru all the results and put pins on the map
        for (NSDictionary *loopedLocations in returnedLocationsArray) {
            
            double returnedLatitude  = [loopedLocations[@"latitude"]doubleValue];
            double returnedLongitude = [loopedLocations[@"longitude"]doubleValue];
            
            CLLocationCoordinate2D locations = CLLocationCoordinate2DMake(returnedLatitude, returnedLongitude);
            
            // create the point and and display it
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = locations;
            
            //create the callout text with route and stop cta_stop_name
            annotation.title = loopedLocations[@"cta_stop_name"];
            annotation.subtitle = loopedLocations[@"routes"];
            
            
            // add the place to the mapView ---
            [self.myMapView addAnnotation:annotation];
            [self.myMapView reloadInputViews];

            
        }
    }];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
    MKAnnotationView *pin = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.canShowCallout = YES;
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"awesome");
}

@end
