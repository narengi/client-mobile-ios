//
//  MyHousesViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/7/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "MyHousesViewController.h"
#import "MyHousesTableViewCell.h"
#import "AroundPlaceObject.h"
#import "EditHoumeListViewController.h"



@interface MyHousesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *houseArr;
@property UIRefreshControl *refreshControl;
@property NSInteger skipCount;



@end

@implementation MyHousesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self changeLeftButton];
    [self changeRighNavigationToClose];
    self.title = @"مهمان‌پذیری";
    
    [self registerCellWithName:@"MyHomeCell" andWithIdentifier:@"myHousesCellID" andTableView:self.tableView];
    [self getMyHomeForFirstTime];
    [self addPullToRefresh];
    
    [SDWebImageDownloader.sharedDownloader setValue:[[NarengiCore sharedInstance] makeAuthurizationValue ] forHTTPHeaderField:@"authorization"];

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseChanged:) name:@"oneFuckingHouseChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteHouse:) name:@"deleteHouseNotification" object:nil];
    
}

-(void)houseChanged:(NSNotification *)notification{
    
    HouseObject *houseObj = notification.object;
    
    NSInteger curentIdx = [self.houseArr indexOfObjectPassingTest:^BOOL(AroundPlaceObject *obj, NSUInteger idx, BOOL *stop)
                            {
                                if ([obj.houseObject.ID isEqualToString:houseObj.ID] ) {
                                    
                                    return YES;
                                }
                                else{
                                    return NO;
                                }
                                
                                
                            }];
    
    if (curentIdx != NSNotFound) {
        
        AroundPlaceObject *aroundObj = self.houseArr[curentIdx];
        aroundObj.houseObject = houseObj;
        
        [self.houseArr replaceObjectAtIndex:curentIdx withObject:aroundObj];
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curentIdx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        
        AroundPlaceObject *aroundObj = [[AroundPlaceObject alloc] init];
        aroundObj.houseObject   = notification.object;
        
        [self.houseArr addObject:aroundObj];
        
        [self.tableView reloadData];
    }
    
    
}

-(void)deleteHouse:(NSNotification *)notification{

    HouseObject *houseObj = notification.object;
    
    NSInteger curentIdx = [self.houseArr indexOfObjectPassingTest:^BOOL(AroundPlaceObject *obj, NSUInteger idx, BOOL *stop)
                           {
                               if ([obj.houseObject.ID isEqualToString:houseObj.ID] ) {
                                   
                                   return YES;
                               }
                               else{
                                   return NO;
                               }
                               
                               
                           }];
    if (curentIdx != NSNotFound) {
        
        [self.houseArr removeObjectAtIndex:curentIdx];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curentIdx inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    }
    
}

-(void)addPullToRefresh{
    
    
    self.refreshControl = [[UIRefreshControl alloc]
                           init];
    [self.refreshControl addTarget:self action:@selector(getMyHomeForFirstTime) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor darkGrayColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changeLeftButton{

    UIImage *buttonImage = [UIImage imageNamed:@"AddListing"];
    UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addbutton setImage:buttonImage forState:UIControlStateNormal];
    addbutton.frame = CGRectMake(0, 0, 32, 32);
    addbutton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:addbutton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    [addbutton addTarget:self action:@selector(goToAddHome) forControlEvents:UIControlEventTouchUpInside];
}
-(void)goToAddHome{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddHome" bundle:nil];
    
    UINavigationController *addHouseNavVC = [storyboard instantiateViewControllerWithIdentifier:@"addHomNavigationVC"];
    [self presentViewController:addHouseNavVC animated:YES completion:nil];
}

-(void)getAllMyHoumes{
    
}


#pragma mark - data

-(void)getMyHomeForFirstTime{

    self.houseArr = [[NSMutableArray alloc] init];
    self.skipCount = 1;
    [self getMyHomeForFirstTime:YES];
}

-(void)getMyHomeForFirstTime:(BOOL)firstTime{

    NSArray *parametrs = @[@"perpage=20",[NSString stringWithFormat:@"page=%ld",(long)self.skipCount]];
    
    REACHABILITY
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:MYHOUSEHSERVICE andWithParametrs:parametrs andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (!serverRs.hasErro) {
                if (serverRs.backData !=nil ) {
                    
                    NSArray *arr = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData andwithType:@"House" andIsDetail:YES];
                    
                    
                    if (arr.count > 0) {
                        
                        [self.houseArr addObjectsFromArray:arr];
                        
                        if (firstTime)
                            [self addLoadMore];
                        
                    }
                    else{
                        [self.tableView .mj_footer removeFromSuperview];
                    }
                    

                    self.skipCount ++;

   
                }
                else{
                }
                
            }
            
            [self.tableView.mj_footer endRefreshing];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];

        });
    });
}

#pragma mark - load more

-(void)addLoadMore{
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(insertRowAtBottom )];
    
}

-(void)insertRowAtBottom{
    
    [self getMyHomeForFirstTime:NO];
}

#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.houseArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    MyHousesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHousesCellID" forIndexPath:indexPath];
    
    HouseObject *house = [(AroundPlaceObject*)self.houseArr[indexPath.row] houseObject];
    
    cell.nameLabel.text = house.name;
    
    cell.roomCountLabel.text = [house.bedroomCount stringByAppendingString:@" اتاق"];
    cell.houseTypeLabel.text = house.type;
    cell.bedCountLabel.text  = [house.bedCount stringByAppendingString:@" تخت"];
    
    if (house.imageUrls.count > 0) {
        [cell.img sd_setImageWithURL:house.imageUrls[0] placeholderImage:nil];
    }
    
//    cell.editButton.tag = cell.viewButton.tag = cell.deleteButton.tag = indexPath.row;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@         " , house.cost];
    
    
    cell.availableFirstDay.text = [NSString stringWithFormat:@"اولین تاریخ آزاد: %@",house.firstDateStr];
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AroundPlaceObject *aroundObj = self.houseArr[indexPath.row];
    [self goToDetailWithArroundObject:aroundObj];
    
}

-(void)goToEditHomeWithHouseObj:(HouseObject *)houseObj{

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddHome" bundle:nil];
    
    EditHoumeListViewController *editHouseVC = [storyboard instantiateViewControllerWithIdentifier:@"editHoueListVC"];
    editHouseVC.houseObj = houseObj;
    [self showViewController:editHouseVC sender:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 296;
}




- (IBAction)editButtonClicked:(UIButton *)sender {
    
    HouseObject *house = [(AroundPlaceObject*)self.houseArr[sender.tag] houseObject];
    
    [self goToEditHomeWithHouseObj:house];

}


-(void)changeRighNavigationToClose{
    
    UIImage *buttonImage = [UIImage imageNamed:@"CloseIconOrange"];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:buttonImage forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0, 0, 45, 45);
    menuButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.rightBarButtonItem = customBarItem;
    [menuButton addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)closeButton{

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
