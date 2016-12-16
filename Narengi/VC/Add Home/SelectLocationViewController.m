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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTopSpace;
@property (weak, nonatomic) IBOutlet AddHomeButton *preButton;
@property (weak, nonatomic) IBOutlet AddHomeButton *nextButton;


@end

@implementation SelectLocationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self changeLeftIcontoBack];

    self.title = @"موقعیت جغرافیایی";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    GeoPointObject *geoObj = [[GeoPointObject alloc] init];
    
    if (self.isComingFromEdit) {
        
        geoObj = self.houseObj.geoObj;
    }
    else{
        
        geoObj.lat = 35.758188;
        geoObj.lng = 51.410776;
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: geoObj.lat longitude:geoObj.lng
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
    
    
    
    if (self.isComingFromEdit) {
        
        self.stepsViewHeightConstraint.constant  = 0;
        [self.containerView layoutIfNeeded];
        self.scrollTopSpace.constant = 0;
        [self.mapView layoutIfNeeded];
        self.containerView.hidden = YES;
        
        [self.preButton setTitle:@"انصراف" forState:UIControlStateNormal];
        [self.nextButton setTitle:@"تایید" forState:UIControlStateNormal];
    }
    else{
        
        [self changeRightButtonToClose];
        
    }
    

}


-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STEPCHANGED" object:[NSNumber numberWithInteger:2]];
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
    
}
- (IBAction)goToNextStepButtonClicked:(UIButton *)sender {
    
    CGPoint point = self.mapView.center;
    CLLocationCoordinate2D cordinate = [self.mapView.projection coordinateForPoint:point];

    self.houseObj.geoObj = [[GeoPointObject alloc] initWith:cordinate.latitude andWithLng:cordinate.longitude];
    
    
    REACHABILITY
    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"PUT" andWithService:[NSString stringWithFormat: @"houses/%@",self.houseObj.ID ] andWithParametrs:nil andWithBody:[self makeJson] andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [SVProgressHUD dismiss];
            if (!serverRs.hasErro) {
                
                
                self.houseObj =  [(AroundPlaceObject *)[[[NarengiCore sharedInstance] parsAroudPlacesWith:@[serverRs.backData] andwithType:@"House" andIsDetail:YES] firstObject] houseObject];

                if (self.isComingFromEdit) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"oneFuckingHouseChanged" object:self.houseObj];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else{
                    [self performSegueWithIdentifier:@"goSelectType" sender:nil];
                }
                
            }
            else{
                
                if (serverRs.backData != nil ) {
                    
                    //show error
                    NSString *erroStr = [[serverRs.backData objectForKey:@"error"] objectForKey:@"message"];
                    [self showError:erroStr];
                }
                else{
                    
                    [self showError:@"اشکال در ارتباط با سرور"];
                    
                }
            }
        });
    });
}

-(NSData *)makeJson{
    
    
    NSMutableDictionary* bodyDict =[[NSMutableDictionary alloc] init];
    
    [bodyDict addEntriesFromDictionary: @{@"Position":@{@"lat":@(self.houseObj.geoObj.lat),@"lng":@(self.houseObj.geoObj.lng)}}];
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[bodyDict copy] options:0 error:nil];
    
    
    return bodyData;
}

- (IBAction)goToPreStepButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"goSelectType"]) {
        
        SelectTypeViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
    }
    
}



@end
