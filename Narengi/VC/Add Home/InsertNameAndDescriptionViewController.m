//
//  InsertNameAndDescriptionViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/6/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "InsertNameAndDescriptionViewController.h"
#import "SZTextView.h"
#import "SelectProvinceViewController.h"
#import "SelectCityViewController.h"
#import "SelectLocationViewController.h"

@interface InsertNameAndDescriptionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIView *titleViewcontainer;
@property (weak, nonatomic) IBOutlet UIView *desctiptionContainerView;
@property (weak, nonatomic) IBOutlet SZTextView *desciptionTextView;
@property (weak, nonatomic) IBOutlet SZTextView *addressTextView;
@property (weak, nonatomic) IBOutlet SZTextView *paymentDesc;
@property (nonatomic,strong) NSDictionary *selectedProvince;
@property (nonatomic,strong) NSString *selectedCity;
@property (nonatomic,strong) NSString *selectedProvinceStr;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *provinceLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *cityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTopSpace;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet AddHomeButton *nextButton;


@end

@implementation InsertNameAndDescriptionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"عنوان و توضیح";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.isComingFromEdit) {
        
        self.stepsViewHeightConstraint.constant  = 0;
        [self.containerView layoutIfNeeded];
        self.scrollTopSpace.constant = 0;
        [self.scrollView layoutIfNeeded];
        [self fillData];
        self.containerView.hidden = YES;
        [self changeLeftIcontoBack];
        
        [self.nextButton setTitle:@"تایید" forState:UIControlStateNormal];

    }
    else{
    
        self.houseObj = [[HouseObject alloc] init];
        [self changeRightButtonToClose];

    }
    
    self.navigationItem.hidesBackButton = YES;

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STEPCHANGED" object:[NSNumber numberWithInteger:1]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - check Fields

-(BOOL)checkAllFields{

    if ([self checkTitle]) {
        if ([self checkDesciption]) {
            if (self.desciptionTextView.text.length < 501) {
                
                if ([self checkProvinceAndCity]) {
                    
                    if ([self checkAddress]) {
                        
                        return YES;
                    }
                    else{
                        return NO;
                    }
                }
                else{
                    [self showError:@"استان و شهر را انتخاب کنید"];
                    return NO;
                    
                }
            }
            else{
                [self showError:@"طول توضیحات باید بیشتر از ۵۰۰ کارکتر نباشد"];
                return  NO;
            }
            
        }
        else{
            
            [self showError:@"طول توضیحات باید بیشتر از ۱۰ کارکتر باشد"];
            return NO;
        }
    }
    else{
        [self showError:@"طول عنوان باید بیشتر از ۵ کارکتر باشد"];
        return NO;
        
    }
}

-(BOOL)checkTitle{
    
    NSString *str = [self.titleTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (str.length > 0){
        if (str.length > 5) {
            return  YES;
        }
        else
            return NO;
    }
    
    else
        return NO;
}

-(BOOL)checkDesciption{

    NSString *str = [self.desciptionTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (str.length > 9){
        return YES;
    }
    
    else
        return NO;
    
}

-(BOOL)checkAddress{
    
    NSString *str = [self.addressTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (str.length > 0){
        if (str.length > 10) {
            return  YES;
        }
        else
            return NO;
    }
    
    else
        return NO;
    
}


-(BOOL)checkProvinceAndCity{

    if (self.selectedProvinceStr != nil && self.selectedCity != nil)
        return YES;
    
    else
        return NO;
    
    
}

#pragma mark - Province and city
- (IBAction)selectProvinceClicked:(UIButton *)sender {
    
    [self goToSelectProvince];
}

- (IBAction)selectCityClicked:(UIButton *)sender {
    
    if (self.selectedProvince !=  nil) {
        [self goToSelectCity];
    }
    else{
        
        UIAlertController *exitAlert = [UIAlertController alertControllerWithTitle:@"نارنگی"
                                                                           message: @"ابتدا استان را انتخاب کنید"
                                                                    preferredStyle:UIAlertControllerStyleAlert                   ];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"تایید"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 [exitAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [exitAlert addAction: ok];
        
        [self presentViewController:exitAlert animated:YES completion:nil];
    }
}

-(void)goToSelectProvince{
    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
    SelectProvinceViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"selectProvinceVCID"];
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    
    formSheet.presentationController.contentViewSize = CGSizeMake(300, 400);
    formSheet.presentationController.portraitTopInset = 10;
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheet.contentViewCornerRadius = 8.0;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
        SelectProvinceViewController *vc = (SelectProvinceViewController *)presentedFSViewController;
        if (vc.isSelectProvince) {
            
            
            self.selectedProvince = vc.selectedProvince;
            
            self.selectedProvinceStr  = [self.selectedProvince objectForKey:@"name"];
            self.provinceLabel.text = self.selectedProvinceStr ;
            
        }
        
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];
}


-(void)goToSelectCity{
    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
    SelectCityViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"selectCityVCID"];
    
    vc.cityArr = [self.selectedProvince objectForKey:@"cities"];
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    
    formSheet.presentationController.contentViewSize = CGSizeMake(300, 400);
    formSheet.presentationController.portraitTopInset = 10;
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheet.contentViewCornerRadius = 8.0;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
        SelectCityViewController *vc = (SelectCityViewController *)presentedFSViewController;
        if (vc.isSelectCity) {
            
            self.selectedCity = vc.selectedCity;
            self.cityLabel.text = self.selectedCity ;
        }
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];
}

#pragma mark -Buttons

- (IBAction)nextButtonClicked:(UIButton *)sender {
    

    if ([self checkAllFields]) {
        
        self.houseObj.name     = self.titleTextField.text;
        self.houseObj.summary  = self.desciptionTextView.text;
        self.houseObj.cityName = [self.selectedProvince objectForKey:@"name"];
        
        [self sendAddHomeRequest ];
        
    }
    
}

-(void)sendAddHomeRequest{

    REACHABILITY
    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:self.isComingFromEdit ? @"PUT" : @"POST" andWithService:self.isComingFromEdit ? [NSString stringWithFormat:@"houses/%@",self.houseObj.ID] : @"houses" andWithParametrs:nil andWithBody:[self makeJson] andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [SVProgressHUD dismiss];
            if (!serverRs.hasErro) {
             
                self.houseObj =  [(AroundPlaceObject *)[[[NarengiCore sharedInstance] parsAroudPlacesWith:@[serverRs.backData] andwithType:@"House" andIsDetail:YES] firstObject] houseObject];
                
                if (self.isComingFromEdit) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"oneFuckingHouseChanged" object:self.houseObj];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else{
                    [self performSegueWithIdentifier:@"goToInsertLocation" sender:nil];
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
-(NSData *)makeJson{

    
    NSMutableDictionary* bodyDict =[[NSMutableDictionary alloc] init];
    
    [bodyDict addEntriesFromDictionary: @{@"Name":self.titleTextField.text,
                                          @"location":@{@"city":self.selectedCity,@"province":self.selectedProvinceStr,@"address":self.addressTextView.text
                                                        }
                                          ,@"Summary":self.desciptionTextView.text}];
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[bodyDict copy] options:0 error:nil];
    
    
    return bodyData;
}

- (IBAction)preButtonclicked:(UIButton *)sender {
    
    
    
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"goToInsertLocation"]) {
       
        SelectLocationViewController *vc =  segue.destinationViewController;
        vc.houseObj = self.houseObj;

    }
}

#pragma mark - edit
-(void)fillData{

    self.selectedProvinceStr     = self.houseObj.province;
    self.selectedCity            = self.houseObj.cityName;
    
    self.titleTextField.text     = self.houseObj.name;
    self.desciptionTextView.text = self.houseObj.summary;
    self.provinceLabel.text      = self.houseObj.province;
    self.cityLabel.text          = self.houseObj.cityName;
    self.addressTextView.text    = self.houseObj.address;
}

@end
