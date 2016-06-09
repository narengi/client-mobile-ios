//
//  SelectGuestCountViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/9/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectGuestCountViewController.h"
#import "SetPricesViewController.h"


@interface SelectGuestCountViewController ()

@property (nonatomic) NSInteger  roomCount;
@property (nonatomic) NSInteger  bedCount;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *roomCountLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *bedCountLabel;


@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@end

@implementation SelectGuestCountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self changeLeftIcontoBack];
    [self changeRightButtonToClose];

    
    self.title = @"اطلاعات اتاق";

    self.bedCount      = 0;
    self.roomCount     = 0;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STEPCHANGED" object:[NSNumber numberWithInteger:4]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - buttons

- (IBAction)roomIncreaseButtonclicked:(UIButton *)sender {
    
    self.roomCount = self.roomCount +1;
    [self updateLabels];
}
- (IBAction)roomDecreaseButtonclicked:(UIButton *)sender {
    
    self.roomCount = self.roomCount-1;
    
    if (self.roomCount < 0) {
        self.roomCount = 0;
    }
    [self updateLabels];
}

- (IBAction)bedIncreaseButtonclicked:(UIButton *)sender {
    
    self.bedCount = self.bedCount+1;
    [self updateLabels];
}
- (IBAction)bedDecreaseButtonclicked:(UIButton *)sender {
    
    self.bedCount = self.bedCount-1;
    
    if (self.bedCount < 0) {
        self.bedCount = 0;
    }
    
    [self updateLabels];
}


-(void)updateLabels{

    self.bedCountLabel.text      = [NSString stringWithFormat:@"%ld",(long)self.bedCount ];
    self.roomCountLabel.text     = [NSString stringWithFormat:@"%ld",(long)self.roomCount ];
    

    self.houseObj.bedCount      = [NSString stringWithFormat:@"%ld",(long)self.bedCount ];
    self.houseObj.bedroomCount  = [NSString stringWithFormat:@"%ld",(long)self.roomCount ];
    
}


- (IBAction)nextButtonClicked:(UIButton *)sender {
    
    if ([self.priceTextField.text integerValue] > 0) {
     
        [self sendPriceToServer];
    }
    else{
        [self showError:@"لطفا هزینه اجاره‌بها را درست وارد کنید"];
    }
    

}
-(void)sendPriceToServer{


    REACHABILITY
    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"PUT" andWithService:[NSString stringWithFormat: @"houses/%@",self.houseObj.ID ] andWithParametrs:nil andWithBody:[self makeJson] andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [SVProgressHUD dismiss];
            if (!serverRs.hasErro) {
                
                
                self.houseObj =  [(AroundPlaceObject *)[[[NarengiCore sharedInstance] parsAroudPlacesWith:@[serverRs.backData] andwithType:@"House" andIsDetail:YES] firstObject] houseObject];
                
                [self performSegueWithIdentifier:@"gotoSetelectExtraPrice" sender:nil];
                
                
            }
            else{
                
                if (serverRs.backData != nil ) {
                    
                    //show error
                    NSString *erroStr = [[serverRs.backData objectForKey:@"error"] objectForKey:@"message"];
                    [self showError:erroStr];
                }
                else{
                    
                    [self showError:@"اشکال در ارتباط با سرور"];
                    
                }
            }
        });
    });
    
}
#pragma mark - sendChanges


-(NSData *)makeJson{
    
    NSMutableDictionary* bodyDict =[[NSMutableDictionary alloc] init];
    
    [bodyDict addEntriesFromDictionary: @{@"Spec":@{@"bedroomCount":[NSNumber numberWithInteger: self.roomCount ],@"bedCount":[NSNumber numberWithInteger:self.bedCount]},@"Price":@{@"Price":self.priceTextField.text}}];
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[bodyDict copy] options:0 error:nil];
    
    
    return bodyData;
}

-(void)CheckPrice{
    
    
        
//        if ([self.extraGuestPriceTextField.text integerValue] > 0) {
//            
//            self.houseObj.price = [self.priceTextField.text integerValue];
//            self.houseObj.extraGuestPrice = [self.extraGuestPriceTextField.text integerValue];
//            
//            [self performSegueWithIdentifier:@"" sender:nil];
//        }
//        else{
//            
//            [self showError:@"لطفا هزینه مهمان‌اضافی را درست وارد کنید"];
//            
//        }
    
}

- (IBAction)preButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"gotoSetelectExtraPrice"]) {
        
        SetPricesViewController *vc  = segue.destinationViewController;
        vc.houseObj = self.houseObj;
    }
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
