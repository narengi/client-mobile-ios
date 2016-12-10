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

@interface SelectFacilityViewController ()

@property (nonatomic,strong) NSArray      *houseFacilityArr;
@property (nonatomic       ) NSInteger    selectedIdx;
@property (weak, nonatomic ) IBOutlet UITableView  *tableView;
@property (nonatomic,strong) NSDictionary *selectedDict;
@property UIRefreshControl *refreshControl;

@end

@implementation SelectFacilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getHouseFacilities];
    [self changeLeftIcontoBack];
    [self changeRightButtonToClose];
    
    self.title = @"امکانات";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUPullToRefresh];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);
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
    
    NSDictionary *typeDict  = self.houseFacilityArr[indexPath.row];
    cell.titleLabel.text = [typeDict objectForKey:@"faName"];
    cell.img.image = IMG([typeDict objectForKey:@"type"]);
    
    if ([[typeDict objectForKey:@"available"] boolValue]) {
        cell.checkBoxImg.image  = IMG(@"amenitieschecked");
    }
    else{
        
        cell.checkBoxImg.image = IMG(@"amenitiesoption");
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *muarr = [[NSMutableArray alloc] initWithArray:self.houseFacilityArr];
    
    NSMutableDictionary *dict  = [[NSMutableDictionary alloc] initWithDictionary: self.houseFacilityArr[indexPath.row]];
    
    BOOL isSelected = [[dict objectForKey:@"available"] boolValue];
    [dict setObject:@(!isSelected) forKey:@"available"];
    
    [muarr replaceObjectAtIndex:indexPath.row withObject:dict];
    
    self.houseFacilityArr = [muarr copy];
    self.selectedDict = self.houseFacilityArr[indexPath.row];
    
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
                
                [self makeFacility:response.backData];
                
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
            
            [self.refreshControl endRefreshing];

        });
    });
    
}
-(void)makeFacility:(NSArray*)arr{
    
    NSMutableArray *typeMuArr = [[NSMutableArray alloc] init];
    
    [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = @{@"type":[obj objectForKey:@"key"],@"faName":[obj objectForKey:@"title"],@"available":@NO};
        [typeMuArr addObject:dict];
        
    }];
    
    self.houseFacilityArr = [typeMuArr copy];
    [self.tableView reloadData];
}
- (IBAction)nextButtonClicked:(UIButton *)sender {
    
    
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    
    [self.houseFacilityArr enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([[obj objectForKey:@"available"] boolValue]) {
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
                
                [self performSegueWithIdentifier:@"goToSelectImgesVC" sender:nil];
                
                
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
        [self.houseObj.facilityArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [muArr addObject:@{@"type":[obj objectForKey:@"type"],@"available":@YES}];
        }];
        
         [bodyDict addEntriesFromDictionary: @{@"FeatureList":[muArr copy]}];
    }
    else
        [bodyDict addEntriesFromDictionary: @{@"FeatureList":@[]}];

    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[bodyDict copy] options:0 error:nil];
    
    
    return bodyData;
}

@end
