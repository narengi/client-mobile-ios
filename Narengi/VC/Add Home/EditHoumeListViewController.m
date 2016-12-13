//
//  EditHoumeListViewController.m
//  Narengi
//
//  Created by Morteza Hoseinizade on 12/13/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "EditHoumeListViewController.h"
#import "EditHomeTableViewCell.h"

@interface EditHoumeListViewController ()

@property (nonatomic,strong) NSArray *titlesArr;

@end

@implementation EditHoumeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArr = @[@{@"title":@"اطلاعات عمومی مسکن",@"type":@""},@{@"title":@"موقعیت مکانی روی نقشه",@"type":@""},@{@"title":@"نوع مسکن",@"type":@""},@{@"title":@"اطلاعات اتاق",@"type":@""},@{@"title":@"اطلاعات مهمان",@"type":@""},@{@"title":@"امکانات",@"type":@""},@{@"title":@"تصاویر",@"type":@""},@{@"title":@"روزهای قابل سرویس‌دهی",@"type":@""}];
    
    self.title  = @"ویرایش اطلاعات مسکن";
    [self changeLeftIcontoBack];
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

@end
