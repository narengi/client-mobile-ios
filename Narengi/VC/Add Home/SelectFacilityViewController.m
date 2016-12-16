//
//  SelectFacilityViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectFacilityViewController.h"
#import "SelectFacilityTableViewCell.h"
#import "AddPhotoViewController.h"
#import "FacilityObject.h"

@interface SelectFacilityViewController ()

@property (nonatomic,strong) NSArray      *houseFacilityArr;
@property (nonatomic       ) NSInteger    selectedIdx;
@property (weak, nonatomic ) IBOutlet UITableView  *tableView;
@property (nonatomic,strong) NSDictionary *selectedDict;
@property UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTopSpace;
@property (weak, nonatomic) IBOutlet AddHomeButton *preButton;
@property (weak, nonatomic) IBOutlet AddHomeButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation SelectFacilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getHouseFacilities];
    [self changeLeftIcontoBack];
    
    self.title = @"امکانات";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUPullToRefresh];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);
    
    
    if (self.isComingFromEdit) {
        
        self.stepsViewHeightConstraint.constant  = 0;
        [self.containerView layoutIfNeeded];
        self.scrollTopSpace.constant = 64;
        [self.tableView layoutIfNeeded];
        self.containerView.hidden = YES;
        
        self.selectedDict = @{@"enName":self.houseObj.enType,@"faName":self.houseObj.type};
        
        
        [self.preButton setTitle:@"انصراف" forState:UIControlStateNormal];
        [self.nextButton setTitle:@"تایید" forState:UIControlStateNormal];
    }
    else{
        
        [self changeRightButtonToClose];
        
    }
}

-(void)setUPullToRefresh{
    
    self.refreshControl = [[UIRefreshControl alloc]
                           init];
    [self.refreshControl addTarget:self action:@selector(getHouseFacilities) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor grayColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STEPCHANGED" object:[NSNumber numberWithInteger:6]];
}

#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houseFacilityArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectFacilityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectFacilityCellID" forIndexPath:indexPath];
    
    FacilityObject *facilityObj  = self.houseFacilityArr[indexPath.row];
    
    cell.titleLabel.text = facilityObj.name;
    cell.img.image = IMG(facilityObj.key);
    
    if (facilityObj.available) {
        cell.checkBoxImg.image  = IMG(@"amenitieschecked");
    }
    else{
        
        cell.checkBoxImg.image = IMG(@"amenitiesoption");
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *muarr = [[NSMutableArray alloc] initWithArray:self.houseFacilityArr];
    
     FacilityObject *facilityObj  = self.houseFacilityArr[indexPath.row];
    
    facilityObj.available = !facilityObj.available;
    
    [muarr replaceObjectAtIndex:indexPath.row withObject:facilityObj];
    
    self.houseFacilityArr = [muarr copy];
    
    [self.tableView reloadData];
    
}

#pragma mark - data

-(void)getHouseFacilities{
    
    
    NORMALREACHABILITY
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService: @"house-features" andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [SVProgressHUD dismiss];
            
            if (!response.hasErro) {
                                
                self.houseFacilityArr = [[NarengiCore sharedInstance] parsFacilities:response.backData];
                
                if (self.isComingFromEdit) {
                    [self addAvailableFacilities];
                }
            }
            else{
                
                if (response.backData != nil ) {
                    
                    //show error
                    NSString *erroStr = [[response.backData objectForKey:@"error"] objectForKey:@"message"];
                    [self showError:erroStr];
                }
                else{
                    
                    [self showError:@"اشکال در ارتباط با سرور"];
                    
                }
            }
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];

        });
    });
    
}

- (IBAction)nextButtonClicked:(UIButton *)sender {
    
    
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    
    [self.houseFacilityArr enumerateObjectsUsingBlock:^(FacilityObject  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.available) {
            [muArr addObject:obj];
        }
        
    }];
    
    if (muArr.count > 0) {
        
        self.houseObj.facilityArr  = [muArr copy];
    }
    
    [self sendRequest];
}

- (IBAction)preButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"goToSelectImgesVC"]) {
     
        AddPhotoViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
    }
    
}


#pragma mark - sendChanges
-(void)sendRequest{
    
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
                    
                    [self performSegueWithIdentifier:@"goToSelectImgesVC" sender:nil];
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
    
    if (self.houseObj.facilityArr.count > 0) {
       
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        [self.houseObj.facilityArr enumerateObjectsUsingBlock:^(FacilityObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [muArr addObject:@{@"key":obj.key,@"title":obj.name,@"id":obj.ID}];
        }];
        
         [bodyDict addEntriesFromDictionary: @{@"features":[muArr copy]}];
    }
    else
        [bodyDict addEntriesFromDictionary: @{@"features":@[]}];

    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[bodyDict copy] options:0 error:nil];
    
    
    return bodyData;
}

-(void)addAvailableFacilities{

    NSMutableArray *muarr = [[NSMutableArray alloc] initWithArray:self.houseFacilityArr];
    
    
    [muarr enumerateObjectsUsingBlock:^(FacilityObject  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger curentIdx = [self.houseObj.facilityArr indexOfObjectPassingTest:^BOOL(FacilityObject *innerObj, NSUInteger idx, BOOL *stop)
                               {
                                   if ([innerObj.key isEqualToString:obj.key] ) {
                                       
                                       return YES;
                                   }
                                   else{
                                       return NO;
                                   }
                                   
                                   
                               }];
        if (curentIdx != NSNotFound) {
            
            obj.available = !obj.available;
        }
        
    }];
    
    self.houseFacilityArr = [muarr copy];
    
}

@end
