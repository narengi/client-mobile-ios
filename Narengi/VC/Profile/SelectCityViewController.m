//
//  SelectCityViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectProvinceTableViewCell.h"

@interface SelectCityViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectProvinceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectProvinceCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = self.cityArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCity = self.cityArr[indexPath.row];
    self.isSelectCity = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
