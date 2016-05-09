//
//  SelectTypeViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/9/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectTypeViewController.h"
#import "SelectTypeTableViewCell.h"
#import "SelectGuestCountViewController.h"

@interface SelectTypeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *houseTypesArr;
@property (nonatomic) NSInteger selectedIdx;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDictionary *selectedDict;

@end

@implementation SelectTypeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self getHouseTypes];
    [self changeLeftIcontoBack];
    [self changeRightButtonToClose];

    self.title = @"نوع مسکن";
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houseTypesArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectTypeCellID" forIndexPath:indexPath];
    
    NSDictionary *typeDict  = self.houseTypesArr[indexPath.row];
    cell.titleLabel.text = [typeDict objectForKey:@"faName"];
    
    if ([[typeDict objectForKey:@"isSelected"] boolValue]) {
        cell.checkBoxImg.image  = IMG(@"amenitieschecked");
    }
    else{
        
        cell.checkBoxImg.image = IMG(@"amenitiesoption");
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    
    NSMutableArray *muarr = [[NSMutableArray alloc] init];
    [self.houseTypesArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
         NSMutableDictionary *typeDict  = [[NSMutableDictionary alloc] initWithDictionary:obj];
        if (idx == indexPath.row) {
            [typeDict setObject:@YES forKey:@"isSelected"];
        }
        else{
            [typeDict setObject:@NO forKey:@"isSelected"];
        }
        [muarr addObject:[typeDict copy]];
    }];
    
    self.houseTypesArr = [muarr copy];
    self.selectedDict = self.houseTypesArr[indexPath.row];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - data
-(void)getHouseTypes{

    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService: @"houses/settings/house-types" andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [SVProgressHUD dismiss];
            
            if (!response.hasErro) {
                
                [self makeTypes:response.backData];
                
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
-(void)makeTypes:(NSArray*)arr{

    NSMutableArray *typeMuArr = [[NSMutableArray alloc] init];
    
    [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = @{@"enName":obj.allKeys[0],@"faName":[obj objectForKey:obj.allKeys[0]],@"isSelected":@NO};
        [typeMuArr addObject:dict];
        
    }];
    
    self.houseTypesArr = [typeMuArr copy];
    [self.tableView reloadData];
}
- (IBAction)nextButtonClicked:(UIButton *)sender {
    
    if (self.selectedDict  != nil ) {
    
        [self performSegueWithIdentifier:@"goToSelectGuestCountVC" sender:nil];
    }
    else{
        [self showErro:@"لطفا نوع مسکن را انتخاب کنید"];

    }
    
}

- (IBAction)preButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    SelectGuestCountViewController *vc  = segue.destinationViewController;
    vc.houseObj = self.houseObj;
    
}
@end
