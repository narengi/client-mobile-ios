//
//  SetPricesViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SetPricesViewController.h"
#import "SelectFacilityViewController.h"

@interface SetPricesViewController ()
@property (weak, nonatomic) IBOutlet UITextField *extraGuestPriceTextField;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *guestCountLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *maxGuestCountLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *guestCountTitleLabel;

@property (nonatomic) NSInteger  guestCount;
@property (nonatomic) NSInteger  maxGuestCount;


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet AddHomeButton *preButton;
@property (weak, nonatomic) IBOutlet AddHomeButton *nextButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepsViewHeightConstraint;

@end

@implementation SetPricesViewController

- (void)viewDidLoad {
    
    [self changeLeftIcontoBack];
    
    self.title = @"اطلاعات مهمان";
    
    
    [super viewDidLoad];
    
    if (self.isComingFromEdit) {
        
        self.stepsViewHeightConstraint.constant  = 0;
        [self.containerView layoutIfNeeded];
        [self.guestCountTitleLabel layoutIfNeeded];
        [self fillData];
        self.containerView.hidden = YES;
        
        [self.preButton setTitle:@"انصراف" forState:UIControlStateNormal];
        [self.nextButton setTitle:@"تایید" forState:UIControlStateNormal];
        
    }
    else{
        
        self.maxGuestCount = 1;
        self.guestCount    = 1;
        [self changeRightButtonToClose];
        
    }
    
    
    self.navigationItem.hidesBackButton = YES;

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STEPCHANGED" object:[NSNumber numberWithInteger:5]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - buttons

- (IBAction)guestIncreaseButtonclicked:(UIButton *)sender {
    
    self.guestCount = self.guestCount +1;
    self.maxGuestCount  = self.guestCount;
    
    
    [self updateLabels];
}
- (IBAction)guestDecreaseButtonclicked:(UIButton *)sender {
    
    self.guestCount = self.guestCount-1;
    
    if (self.guestCount == 0) {
        self.guestCount = 1;
    }
    self.maxGuestCount  = self.guestCount;
    
    [self updateLabels];
}
- (IBAction)maxGuestIncreaseButtonclicked:(UIButton *)sender {
    
    self.maxGuestCount = self.maxGuestCount +1;
    [self updateLabels];
    
}
- (IBAction)maxGuestDecreaseButtonclicked:(UIButton *)sender {
    
    self.maxGuestCount = self.maxGuestCount -1;
    if (self.maxGuestCount < self.guestCount) {
        self.maxGuestCount  = self.guestCount;
    }
    [self updateLabels];
}

-(void)updateLabels{
    
    self.guestCountLabel.text    = [NSString stringWithFormat:@"%ld",(long)self.guestCount ];
    self.maxGuestCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.maxGuestCount ];
    self.houseObj.maxGuestCount = self.maxGuestCount;
    self.houseObj.guestCount    = [NSString stringWithFormat:@"%ld",(long)self.guestCount ];
}


- (IBAction)submitButtonClicked:(UIButton *)sender {
    
    [self sendPriceToServer];
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
                
                if (self.isComingFromEdit) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"oneFuckingHouseChanged" object:self.houseObj];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else{
                    [self performSegueWithIdentifier:@"goToSelectFacilityVCID" sender:nil];
                }
                
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
    
    if ([self.extraGuestPriceTextField.text integerValue] > 0) {
    
        [bodyDict addEntriesFromDictionary: @{@"spec":@{@"guest_count":[NSNumber numberWithInteger: self.guestCount ],@"max_guest_count":[NSNumber numberWithInteger:self.maxGuestCount]},@"Price":@{@"extraGuestPrice":[self.extraGuestPriceTextField.text fixPersianArabaicnumberString]}}];
    }
    else{
        
        [bodyDict addEntriesFromDictionary: @{@"spec":@{@"guest_count":[NSNumber numberWithInteger: self.guestCount ],@"max_guest_count":[NSNumber numberWithInteger:self.maxGuestCount]}}];
        
    }
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[bodyDict copy] options:0 error:nil];
    
    
    return bodyData;
}
- (IBAction)preButtonClciked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"goToSelectFacilityVCID"]) {
        
        SelectFacilityViewController *vc  = segue.destinationViewController;
        vc.houseObj = self.houseObj;
    }
}

#pragma mark - edit

-(void)fillData{
    
    self.extraGuestPriceTextField.text = [NSString stringWithFormat:@"%ld", (long)self.houseObj.extraGuestPrice ];
    
    
    self.maxGuestCount  = self.houseObj.maxGuestCount;
    self.guestCount = [self.houseObj.guestCount integerValue];
    
    [self updateLabels];
}

@end
