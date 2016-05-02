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

//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
//    
//    return YES;
//}
//
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker{
//    
//    NSLog(@"the post title is :%@ %@",marker.userData,marker.title);
//    
//    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 70)]; // Your Created Custom View XIB.
//    
//    UILabel *theLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50,150, 50)];// Create a Custom Label and add it on the custom view.
//    theLabel.text = marker.title; // marker.title is the title of pin.
//    [view addSubview:theLabel];
//    
//    return view;
//}
//
-(void)changeGeo{
    
    [self  makeGeos ];
    NSMutableArray *muaArr = [[NSMutableArray alloc] init];
    
    [self.houseArr enumerateObjectsUsingBlock:^(AroundPlaceObject  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx<3) {
            
            HouseObject *house = obj.houseObject;
            house.geoObj.lat = [self.arr[idx *2] doubleValue];
            house.geoObj.lng = [self.arr[idx *2 +1] doubleValue];
            
            [muaArr addObject:house];

        }
    }];
    self.houseArr = [muaArr copy];
    
    [self addPointsToMap];
    
    
}

-(void)makeGeos{
    
    
    self.arr = @[@35.756934, @51.411119,@35.753451, @51.410593,@35.763259, @51.400009,@35.763259, @51.400009];
}

-(void)addPointsToMap{


   // [mapView_ clear];
    for (HouseObject *house in self.houseArr) {

        GMSMarker *sydneyMarker = [[GMSMarker alloc] init];

        sydneyMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)house.geoObj.lat, (CLLocationDegrees)house.geoObj.lng);

        sydneyMarker.userData = house;
        sydneyMarker.title    = house.name;

        sydneyMarker.map      = mapView_;
//        sydneyMarker.tappable = YES;

    }

}

@end
