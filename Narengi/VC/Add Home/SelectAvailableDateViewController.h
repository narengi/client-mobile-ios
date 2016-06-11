//
//  SelectAvailableDateViewController.h
//  Narengi
//
//  Created by Morteza Hosseinizade on 6/11/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>


@interface SelectAvailableDateViewController : UIViewController<JTCalendarDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (nonatomic,strong) HouseObject *houseObj;

@end
