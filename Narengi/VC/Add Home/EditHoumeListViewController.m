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


@interface EditHoumeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *titlesArr;

@end

@implementation EditHoumeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArr = @[@{@"title":@"اطلاعات عمومی مسکن",@"type":@""},@{@"title":@"موقعیت مکانی روی نقشه",@"type":@""},@{@"title":@"نوع مسکن",@"type":@""},@{@"title":@"اطلاعات اتاق",@"type":@""},@{@"title":@"اطلاعات مهمان",@"type":@""},@{@"title":@"امکانات",@"type":@""},@{@"title":@"تصاویر",@"type":@""},@{@"title":@"روزهای قابل سرویس‌دهی",@"type":@""}];
    
    self.title  = @"ویرایش اطلاعات مسکن";
    [self changeLeftIcontoBack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseChanged:) name:@"oneFuckingHouseChanged" object:nil];
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
    
    return self.titlesArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EditHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editHomeCellID" forIndexPath:indexPath];
    
    NSDictionary *dict = self.titlesArr[indexPath.row];
    
    cell.titleLable.text = [dict objectForKey:@"title"];
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    return  cell;
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
            [self performSegueWithIdentifier:@"goToEditFacilityVCID" sender:nil];
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
    
}

@end
