//
//  CityDetailMapViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/2/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "CityDetailMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

@interface CityDetailMapViewController ()<GMSMapViewDelegate>
@property (nonatomic,strong) NSArray *arr;
@end

@implementation CityDetailMapViewController

{
    GMSMapView *mapView_;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    
    [self changeLeftIcontoBack];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.758188
                                                            longitude:51.410776
                                                                 zoom:12];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.myLocationButton = YES;

    
    self.view = mapView_;
    mapView_.delegate = self;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    [self changeGeo];

}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - map

-(void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay
{
    
    
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{

    AroundPlaceObject *aroundObj = (AroundPlaceObject *)marker.userData;
    
    [self goTodetailWithUrl:aroundObj.urlStr andWithType:aroundObj.type];
    
}
-(void)changeGeo{
    
    [self  makeGeos ];
    
    [self.houseArr enumerateObjectsUsingBlock:^(AroundPlaceObject  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx<3) {
            
            GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
            
            sydneyMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)obj.houseObject.geoObj.lat, (CLLocationDegrees)obj.houseObject.geoObj.lng);
            
            sydneyMarker.title    = obj.houseObject.name;
            sydneyMarker.userData = obj;
            sydneyMarker.map      = mapView_;

        }
    }];
    
    
    
}

-(void)makeGeos{
    
    
    self.arr = @[@35.756934, @51.411119,@35.753451, @51.410593,@35.763259, @51.400009,@35.763259, @51.400009];
}


@end
