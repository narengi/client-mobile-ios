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
@property (nonatomic,strong) NSDictionary *selectedProvince;
@property (nonatomic,strong) NSString *selectedCity;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *provinceLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *cityLabel;

@end

@implementation InsertNameAndDescriptionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"عنوان و توضیح";
    self.houseObj = [[HouseObject alloc] init];
    [self changeRightButtonToClose];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - check Fields

-(BOOL)checkAllFields{

    if ([self checkTitle]) {
        if ([self checkDesciption]) {
            if ([self checkProvinceAndCity]) {
                
                return YES;
            }
            else{
                [self showErro:@"استان و شهر را انتخاب کنید"];
                return NO;
                
            }
        }
        else{
         
            [self showErro:@"طول توضیحات باید بیشتر از ۱۰ کارکتر باشد"];
            return NO;
        }
    }
    else{
        
        [self showErro:@"طول عنوان باید بیشتر از ۵ کارکتر باشد"];
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

    if (self.selectedProvince != nil && self.selectedProvince != nil)
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
            self.provinceLabel.text = [self.selectedProvince objectForKey:@"name"];
            
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
        
        self.houseObj.name = self.titleTextField.text;
        self.houseObj.summary = self.desciptionTextView.text;
        self.houseObj.cityName = [self.selectedProvince objectForKey:@"name"];
        
        [self performSegueWithIdentifier:@"goToInsertLocation" sender:nil];
    }
    
}

- (IBAction)preButtonclicked:(UIButton *)sender {
    
    
}


-(void)changeRightButtonToClose{

    UIImage *buttonImage = [UIImage imageNamed:@"minusbtn"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:buttonImage forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0, 0, 32, 32);
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = customBarItem;
    [closeButton addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)closeClicked{

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectLocationViewController *vc =  segue.destinationViewController;
    vc.houseObj = self.houseObj;
}

@end
