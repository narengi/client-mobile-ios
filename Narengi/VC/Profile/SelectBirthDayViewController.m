//
//  SelectBirthDayViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/19/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectBirthDayViewController.h"
#import "NSDateFormatter+Persian.h"

@interface SelectBirthDayViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SelectBirthDayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"]];
    
    
    NSCalendar *persCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    [self.datePicker setCalendar:persCalendar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




- (IBAction)selectButton:(UIButton *)sender {
    
    NSDateFormatter *validFormat = [[NSDateFormatter alloc] init];
    [validFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    dayFormat = [format change];
    [dayFormat setDateFormat:@"EEEE"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat = [format changetoShortFormmat];

    
   self.selectedDateStr  = [[dateFormat stringFromDate:self.datePicker.date] stringByReplacingOccurrencesOfString:@" ه‍.ش." withString:@""];
    
  //   NSDate *startDate    = self.datePicker.date;
  //  self.selectedDateStr  = [dateFormat stringFromDate:startDate];
    
    self.previousDate = self.datePicker.date;
    
    self.didSelectDate = YES;
     [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)calcelButton:(UIButton *)sender {
    
    self.didSelectDate = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
