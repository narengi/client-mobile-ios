//
//  SelectLocationViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/7/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectLocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "SelectTypeViewController.h"

@interface SelectLocationViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    BOOL firstLocationUpdate_;
}
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation SelectLocationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self changeLeftIcontoBack];
    [self changeRightButtonToClose];

    self.title = @"موقعیت جغرافیایی";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.758188
                                                            longitude:51.410776
                                                                 zoom:12];
    
    [self.mapView setCamera:camera];
//    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.settings.compassButton    = YES;
    self.mapView.settings.myLocationButton = YES;
    
    // Listen to the myLocation property of GMSMapView.
    
    [self addObserver:self
           forKeyPath:@"myLocation"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    self.mapView.delegate = self;
    
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });
    
    
    

}




- (void)dealloc {
    [self removeObserver:self
              forKeyPath:@"myLocation"
                 context:NULL];
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
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToNextStepButtonClicked:(UIButton *)sender {
    
    CGPoint point = self.mapView.center;
    CLLocationCoordinate2D cordinate = [self.mapView.projection coordinateForPoint:point];

    self.houseObj.geoObj = [[GeoPointObject alloc] initWith:cordinate.latitude andWithLng:cordinate.longitude];
    [self performSegueWithIdentifier:@"goSelectType" sender:nil];
}

- (IBAction)goToPreStepButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    SelectTypeViewController *vc = segue.destinationViewController;
    vc.houseObj = self.houseObj;
    
}


@end
