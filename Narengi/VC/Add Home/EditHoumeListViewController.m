//
//  EditHoumeListViewController.m
//  Narengi
//
//  Created by Morteza Hoseinizade on 12/13/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "EditHoumeListViewController.h"
#import "EditHomeTableViewCell.h"
#import "InsertNameAndDescriptionViewController.h"
#import "SelectLocationViewController.h"
#import "SelectTypeViewController.h"
#import "SelectTypeViewController.h"
#import "SetPricesViewController.h"
#import "SelectGuestCountViewController.h"
#import "SelectFacilityViewController.h"
#import "AddPhotoViewController.h"
#import "SelectAvailableDateViewController.h"
#import "DeleteHomeTableViewCell.h"


@interface EditHoumeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *titlesArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EditHoumeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArr = @[@{@"title":@"اطلاعات عمومی مسکن",@"type":@""},@{@"title":@"موقعیت مکانی روی نقشه",@"type":@""},@{@"title":@"نوع مسکن",@"type":@""},@{@"title":@"اطلاعات اتاق",@"type":@""},@{@"title":@"اطلاعات مهمان",@"type":@""},@{@"title":@"امکانات",@"type":@""},@{@"title":@"تصاویر",@"type":@""},@{@"title":@"روزهای قابل سرویس‌دهی",@"type":@""}];
    
    self.title  = @"ویرایش اطلاعات مسکن";
    [self changeLeftIcontoBack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseChanged:) name:@"oneFuckingHouseChanged" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DeleteHouseCell" bundle:nil] forCellReuseIdentifier:@"deleteHomeCell"];
    
 
    self.navigationItem.hidesBackButton = YES;
}

-(void)houseChanged:(NSNotification *)notification{

    self.houseObj = notification.object;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.titlesArr.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row < self.titlesArr.count) {
        EditHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editHomeCellID" forIndexPath:indexPath];
        
        NSDictionary *dict = self.titlesArr[indexPath.row];
        
        cell.titleLable.text = [dict objectForKey:@"title"];
        cell.indexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        
        return  cell;
    }
    else{
        
        DeleteHomeTableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:@"deleteHomeCell" forIndexPath:indexPath];

        return deleteCell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row ) {
        case 0:
            [self performSegueWithIdentifier:@"goToEditInfoVCID" sender:nil];
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"goToEditLocationVCID" sender:nil];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"goToEditTypeVCID" sender:nil];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"goToEditGuestCountVCID" sender:nil];
            break;
            
        case 4:
            [self performSegueWithIdentifier:@"goToEditPriceVCID" sender:nil];
            break;
            
        case 5:
            [self performSegueWithIdentifier:@"goToEditFacilityVCID" sender:nil];
            break;
        case 6:
            [self performSegueWithIdentifier:@"goToEditPhotoVCID" sender:nil];
            break;
            
        case 7:
            [self performSegueWithIdentifier:@"goToEditAvailableDatesVCID" sender:nil];
            break;
        case 8:
            [self showDeleteHouseAlert];
            break;
            
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    if ([segue.identifier isEqualToString:@"goToEditInfoVCID"]) {
        
        InsertNameAndDescriptionViewController *vc = segue.destinationViewController;
        vc.isComingFromEdit = YES;
        vc.houseObj = self.houseObj;
    }
    else if ([segue.identifier isEqualToString:@"goToEditLocationVCID"]){
        
        SelectLocationViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
        vc.isComingFromEdit = YES;
    }
    else if ([segue.identifier isEqualToString:@"goToEditTypeVCID"]){
        
        SelectTypeViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
        vc.isComingFromEdit = YES;
    }
    else if ([segue.identifier isEqualToString:@"goToEditGuestCountVCID"]){
        
        SelectGuestCountViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
        vc.isComingFromEdit = YES;
    }
    else if ([segue.identifier isEqualToString:@"goToEditPriceVCID"]){
        
        SetPricesViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
        vc.isComingFromEdit = YES;
    }
    else if ([segue.identifier isEqualToString:@"goToEditFacilityVCID"]){
        
        SelectFacilityViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
        vc.isComingFromEdit = YES;
    }
    else if ([segue.identifier isEqualToString:@"goToEditPhotoVCID"]){
        
        AddPhotoViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
        vc.isComingFromEdit = YES;
    }
    else if ([segue.identifier isEqualToString:@"goToEditAvailableDatesVCID"]){
        
        SelectAvailableDateViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
        vc.isComingFromEdit = YES;
    }
    
}

#pragma mark - button


-(void)showDeleteHouseAlert{
    
    UIAlertController *buyAlert = [UIAlertController alertControllerWithTitle:@""
                                                                      message:[NSString stringWithFormat:@"آیا از حذف خانه %@ اطمینان دارید؟",self.houseObj.name]
                                                               preferredStyle:UIAlertControllerStyleAlert                   ];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"تایید"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         
                         {
                             [self sendDeleteHouseRequest];
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"انصراف"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [buyAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [buyAlert addAction: ok];
    [buyAlert addAction: cancel];
    
    [self presentViewController:buyAlert animated:YES completion:nil];
}

-(void)sendDeleteHouseRequest{
    
    
    REACHABILITY
    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"Delete" andWithService:[NSString stringWithFormat:@"%@/%@",HOUSESERVICE,self.houseObj.ID] andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (!serverRs.hasErro) {
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteHouseNotification" object:self.houseObj];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                [self showError:@"اشکال در ارسال اطلاعات"];
            }
            
            [SVProgressHUD dismiss];
            
        });
    });
    
    
}

@end
