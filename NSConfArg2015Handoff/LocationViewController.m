//
//  LocationViewController.m
//  NSConfArg2015Handoff
//
//  Created by Martín Blech on 2/4/15.
//  Copyright (c) 2015 Martin Blech. All rights reserved.
//

@import MapKit;
@import AddressBook;
#import "LocationViewController.h"
#import "Location.h"

static NSString * const kUserInfoMapCenterLatitude = @"mapCenterLatitude";
static NSString * const kUserInfoMapCenterLongitude = @"mapCenterLongitude";
static NSString * const kUserInfoMapSpanLatitudeDelta = @"mapCenterLatitudeDelta";
static NSString * const kUserInfoMapSpanLongitudeDelta = @"mapCenterLongitudeDelta";

@interface LocationViewController () <MKMapViewDelegate, NSUserActivityDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"LocationSelected"];
    
    [self setMapDefaultLocation:NO];
    [self setMapAnnotations];
    [self setupUserActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.mapView annotationsInMapRect:self.mapView.visibleMapRect].count == 0) {
        [self setMapDefaultLocation:YES];
    }
    [self.mapView setSelectedAnnotations:@[ [Location sharedInstance] ]];
}

# pragma mark - Handoff

- (void)setupUserActivity
{
    if ([self respondsToSelector:@selector(setUserActivity:)]) {
        NSString *activityType = @"com.martinblech.NSConfArg2015Handoff.browsing-location";
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:activityType];
        userActivity.title = @"Browsing NSConfArg 2015 Location";
        userActivity.webpageURL = [NSURL URLWithString:@"http://nsconfarg.com/#ubicacion"];
        userActivity.delegate = self;
        self.userActivity = userActivity;
    }
}

- (void)updateUserActivityState:(NSUserActivity *)activity
{
    MKCoordinateRegion region = self.mapView.region;
    [activity addUserInfoEntriesFromDictionary:@{
        kUserInfoMapCenterLatitude: @(region.center.latitude),
        kUserInfoMapCenterLongitude: @(region.center.longitude),
        kUserInfoMapSpanLatitudeDelta: @(region.span.latitudeDelta),
        kUserInfoMapSpanLongitudeDelta: @(region.span.longitudeDelta),
    }];
}

- (void)restoreUserActivityState:(NSUserActivity *)activity
{
    NSDictionary *userInfo = activity.userInfo;
    if (userInfo[kUserInfoMapCenterLatitude]) {
        CLLocationDegrees centerLatitude = ((NSNumber *)userInfo[kUserInfoMapCenterLatitude]).doubleValue;
        CLLocationDegrees centerLongitude = ((NSNumber *)userInfo[kUserInfoMapCenterLongitude]).doubleValue;
        CLLocationDegrees spanLatitudeDelta = ((NSNumber *)userInfo[kUserInfoMapSpanLatitudeDelta]).doubleValue;
        CLLocationDegrees spanLongitudeDelta = ((NSNumber *)userInfo[kUserInfoMapSpanLongitudeDelta]).doubleValue;
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(centerLatitude, centerLongitude),
                                                           MKCoordinateSpanMake(spanLatitudeDelta, spanLongitudeDelta));
        [self.mapView setRegion:[self.mapView regionThatFits:region]];
    }
}

#pragma mark - NSUserActivityDelegate

- (void)userActivityWasContinued:(NSUserActivity *)userActivity
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.mapView deselectAnnotation:[Location sharedInstance] animated:YES];
    });
}

#pragma mark - Map

- (void)setMapAnnotations
{
    Location *location = [Location sharedInstance];
    [self.mapView addAnnotation:location];
}

- (void)setMapDefaultLocation:(BOOL)animated
{
    Location *location = [Location sharedInstance];
    CLLocationCoordinate2D coordinate = location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:animated];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString * const reuseIdentifier = @"AnnotationView";
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    }
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AnnotationIcon"]];
    annotationView.leftCalloutAccessoryView = leftImageView;
    UIImage *rightButtonImage = [[UIImage imageNamed:@"Directions"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *rightButton = [[UIButton alloc]
                             initWithFrame:CGRectMake(0, 0, rightButtonImage.size.width, rightButtonImage.size.height)];
    [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView = rightButton;
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSDictionary *addressDictionary = @{(NSString *)kABPersonAddressStreetKey: view.annotation.title};
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:view.annotation.coordinate
                                                   addressDictionary:addressDictionary];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(userActivity)]) {
        self.userActivity.needsSave = YES;
    }
}

@end
