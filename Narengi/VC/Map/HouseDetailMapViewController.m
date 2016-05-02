//
//  HouseDetaiMapViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/2/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "HouseDetailMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

@interface HouseDetailMapViewController ()<GMSMapViewDelegate>

@end

@implementation HouseDetailMapViewController
{
    BOOL firstLocationUpdate_;
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.title = @"نقشه";
    [self changeLeftIcontoBack];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.geoPoint.lat
                                                            longitude:self.geoPoint.lat
                                                                 zoom:12];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    // Listen to the myLocation property of GMSMapView.
    [self addObserver:self
           forKeyPath:@"myLocation"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    self.view = mapView_;
    mapView_.delegate = self;
    
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    [self drawCircle];
    
}

-(void)drawCircle{
    
    CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(self.geoPoint.lat, self.geoPoint.lat);
    GMSCircle *circ = [GMSCircle circleWithPosition:circleCenter
                                             radius:2000];
    
    circ.fillColor   = RGB(243, 90, 0, .3);
    circ.strokeColor = RGB(243, 90, 0, .3);
    circ.tappable = YES;

    circ.map = mapView_;
}
- (void)dealloc {
    [self removeObserver:self
              forKeyPath:@"myLocation"
                 context:NULL];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
    
    
}






@end
