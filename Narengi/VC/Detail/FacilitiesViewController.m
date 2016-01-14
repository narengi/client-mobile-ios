//
//  FacilitiesViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/14/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "FacilitiesViewController.h"
#import "FacilitiesTableViewCell.h"

@interface FacilitiesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;


@end

@implementation FacilitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.closeButton.layer.cornerRadius  = 5;
    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.borderWidth   = 1;
    self.closeButton.layer.borderColor   = RGB(136, 136, 136, 1).CGColor;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.facilitiesArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FacilitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"facilitiesCellID" forIndexPath:indexPath];
    
    FacilityObject *facilityObj = self.facilitiesArr[indexPath.row];
    cell.titleLabel.text = facilityObj.name;

    return cell;
}
- (IBAction)closeButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
