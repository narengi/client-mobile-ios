//
//  SelectBirthDayViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/19/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectBirthDayViewController.h"

@interface SelectBirthDayViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SelectBirthDayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"]];
    
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    [self.datePicker setCalendar:persCalendar];
    self.datePicker.maximumDate = [NSDate new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)selectButton:(UIButton *)sender {
    
}
- (IBAction)calcelButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
