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

@interface MyHousesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *houseArr;
@property UIRefreshControl *refreshControl;


@end

@implementation MyHousesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self changeLeftButton];
    [self changeRighNavigationToMenu];
    self.title = @"مهمان‌پذیری";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseInserted) name:@"houseInsertStatus" object:nil];
    
    [self registerCellWithName:@"MyHomeCell" andWithIdentifier:@"myHousesCellID" andTableView:self.tableView];
    [self getMyHome];
    
    [self addPullToRefresh];
    
    [SDWebImageDownloader.sharedDownloader setValue:[[NarengiCore sharedInstance] makeAuthurizationValue ] forHTTPHeaderField:@"access-token"];


}


-(void)addPullToRefresh{
    
    
    self.refreshControl = [[UIRefreshControl alloc]
                           init];
    [self.refreshControl addTarget:self action:@selector(getMyHome) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor darkGrayColor]];
    
}

-(void)houseInserted{

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
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

    UIImage *buttonImage = [UIImage imageNamed:@"add-avatar"];
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

-(void)getMyHome{

    REACHABILITY
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:MYHOUSEHSERVICE andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (!serverRs.hasErro) {
                if (serverRs.backData !=nil ) {
                    
                    self.houseArr = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData andwithType:@"House" andIsDetail:YES];
                    
                    [self.tableView reloadData];
                }
                else{
                }
                
            }
            
            [self.refreshControl endRefreshing];
        });
    });
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
    cell.bedCountLabel.text  = [house.bedroomCount stringByAppendingString:@" تخت"];
    
    if (house.imageUrls.count > 0) {
        [cell.img sd_setImageWithURL:house.imageUrls[0] placeholderImage:nil];
    }
    
    
    
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 282;
}
@end
