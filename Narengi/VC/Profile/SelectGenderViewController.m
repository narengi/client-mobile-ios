//
//  SelectGenderViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/3/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectGenderViewController.h"

@interface SelectGenderViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;

@end

@implementation SelectGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if (self.selectedGenderStr != nil) {
        if ([self.selectedGenderStr isEqualToString:@"male"])
            [self.genderPicker selectRow:0 inComponent:0 animated:YES];
        
        else
            [self.genderPicker selectRow:1 inComponent:0 animated:YES];
    }
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (row == 0)
        return @"مرد";
    else
        return @"زن";
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        self.selectedGenderStr = @"male";
    }
    else{
        self.selectedGenderStr = @"female";
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonclicked:(IranButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)selectbuttonclicked:(IranButton *)sender {
    
    if (self.selectedGenderStr == nil ) {
        self.selectedGenderStr = @"male";
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
