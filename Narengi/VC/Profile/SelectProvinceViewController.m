//
//  SelectProvinceViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectProvinceViewController.h"
#import "SelectProvinceTableViewCell.h"

@interface SelectProvinceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) NSArray *provinceArr;
@property (nonatomic,strong) NSArray *searchResult;

@end

@implementation SelectProvinceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isSelectProvince = NO;
    [self getAllProvince];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
    return self.searchResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectProvinceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectProvinceCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.searchResult[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedProvince = self.searchResult[indexPath.row];
    self.isSelectProvince = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - data

-(void)getAllProvince{

    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
         ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService: @"basic-info/provinces" andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [SVProgressHUD dismiss];
            
            if (!response.hasErro) {
            
                [self makeProvinceArr:response.backData];
                
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
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        });
    });
}

-(void)makeProvinceArr:(NSDictionary *)dict{

    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    [dict.allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        NSMutableArray *cityMuArr = [[NSMutableArray alloc] init];
        [[dict objectForKey:obj] enumerateObjectsUsingBlock:^(NSDictionary *innerObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [cityMuArr addObject:[innerObj objectForKey:@"city"]];
        }];
        
        NSDictionary *tempDict = @{@"name":obj,@"cities":[cityMuArr copy]};

        [muArr addObject:tempDict];
        
    }];
    
    self.provinceArr  = [muArr copy];
    self.searchResult = [muArr copy];
    [self.tableView reloadData];
}


#pragma mark -textfield

- (IBAction)textFieldChanged:(UITextField *)sender {
    
    NSString *searchText = [sender.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchText.length > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains [cd] %@",searchText ];
        self.searchResult = [self.provinceArr filteredArrayUsingPredicate:predicate];
    }
    else{
        
        self.searchResult = self.provinceArr;
    }
    
    [self.tableView reloadData];

}

@end
