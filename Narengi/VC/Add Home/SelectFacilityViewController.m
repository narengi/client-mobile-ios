//
//  SelectFacilityViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectFacilityViewController.h"
#import "SelectFacilityTableViewCell.h"
#import "SetPricesViewController.h"

@interface SelectFacilityViewController ()

@property (nonatomic,strong) NSArray      *houseFacilityArr;
@property (nonatomic       ) NSInteger    selectedIdx;
@property (weak, nonatomic ) IBOutlet UITableView  *tableView;
@property (nonatomic,strong) NSDictionary *selectedDict;

@end

@implementation SelectFacilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getHouseFacilities];
    [self changeLeftIcontoBack];
    [self changeRightButtonToClose];
    
    self.title = @"امکانات";
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    cell.img.image = IMG([typeDict objectForKey:@"enName"]);
    
    if ([[typeDict objectForKey:@"isSelected"] boolValue]) {
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
    
    BOOL isSelected = [[dict objectForKey:@"isSelected"] boolValue];
    [dict setObject:@(!isSelected) forKey:@"isSelected"];
    
    [muarr replaceObjectAtIndex:indexPath.row withObject:dict];
    
    self.houseFacilityArr = [muarr copy];
    self.selectedDict = self.houseFacilityArr[indexPath.row];
    
    [self.tableView reloadData];
    
}

#pragma mark - data
-(void)getHouseFacilities{
    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService: @"houses/settings/features" andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [SVProgressHUD dismiss];
            
            if (!response.hasErro) {
                
                [self makeFacility:response.backData];
                
            }
            else{
                
                if (response.backData != nil ) {
                    
                    //show error
                    NSString *erroStr = [[response.backData objectForKey:@"error"] objectForKey:@"message"];
                    [self showErro:erroStr];
                }
                else{
                    
                    [self showErro:@"اشکال در ارتباط با سرور"];
                    
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        });
    });
    
}
-(void)makeFacility:(NSArray*)arr{
    
    NSMutableArray *typeMuArr = [[NSMutableArray alloc] init];
    
    [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = @{@"enName":obj.allKeys[0],@"faName":[obj objectForKey:obj.allKeys[0]],@"isSelected":@NO};
        [typeMuArr addObject:dict];
        
    }];
    
    self.houseFacilityArr = [typeMuArr copy];
    [self.tableView reloadData];
}
- (IBAction)nextButtonClicked:(UIButton *)sender {
    
    
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    
    [self.houseFacilityArr enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([[obj objectForKey:@"isSelected"] boolValue]) {
            [muArr addObject:obj];
        }
        
    }];
    
    if (muArr.count > 0) {
        
        self.houseObj.facilityArr  = [muArr copy];
    }
    
    [self performSegueWithIdentifier:@"goToSetPriceID" sender:nil];
    
}

- (IBAction)preButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SetPricesViewController *vc  = segue.destinationViewController;
    vc.houseObj = self.houseObj;
    
}

@end
