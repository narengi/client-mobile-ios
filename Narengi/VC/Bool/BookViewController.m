//
//  BookViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/2/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController (){
    NSMutableDictionary *_eventsByDate;
    
    NSMutableArray *_datesSelected;
}

@property (nonatomic,strong) NSDate *fisrtDate;
@property (nonatomic,strong) NSDate *secondDate;


@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars     = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    
    _datesSelected = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CalendarManager delegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    
    
    [dayView setTransform:CGAffineTransformMakeScale(-1, 1)];

    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.userInteractionEnabled = NO;
        dayView.dotView.hidden = YES;
        dayView.textLabel.textColor = [UIColor whiteColor];
        
        
    }
    // Selected date
    else if([self isInDatesSelected:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.hidden = YES;
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.hidden = YES;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    if (self.fisrtDate == nil) {
        
        self.fisrtDate = dayView.date;
        [_datesSelected addObject:dayView.date];
        
        [_calendarManager reload];
        return;
        
    }
    else if (self.secondDate == nil ){
        
        self.secondDate = dayView.date;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        if ([self.fisrtDate compare:self.secondDate] == NSOrderedAscending) {
            [self addDatebetweenTwoDate:self.fisrtDate andSecondDate:dayView.date];
            
        }
        else if ([self.fisrtDate compare:self.secondDate] == NSOrderedDescending){
            
            NSDate *tempDate = self.fisrtDate;;
            self.fisrtDate = self.secondDate;
            self.secondDate = tempDate;
            
            [_datesSelected removeAllObjects];
            [_datesSelected addObject:dayView.date];
            [self addDatebetweenTwoDate:self.fisrtDate andSecondDate:self.secondDate];
            
        }
        else{
            
        }
        
        
        
        [_calendarManager reload];
        
        return;
    }
    else{
        
        [_datesSelected removeAllObjects];
        self.fisrtDate = dayView.date;
        self.secondDate = nil;
        
        [_datesSelected addObject:dayView.date];
        [_calendarManager reload];
        
    }
    
    
    
    
    
}


-(void )addDatebetweenTwoDate :(NSDate *)firstDate andSecondDate:(NSDate *)secondDate{
    
    
    
    NSMutableArray * days = [NSMutableArray new];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *startDate = firstDate;
    NSDateComponents *deltaDays = [NSDateComponents new];
    [deltaDays setDay:1];
    [days addObject:startDate];
    
    while ([startDate compare:secondDate] == NSOrderedAscending) {
        startDate = [calendar dateByAddingComponents:deltaDays toDate:startDate options:0];
        [days addObject:startDate];
        
    }
    [days removeObjectAtIndex:0];
    [_datesSelected addObjectsFromArray:[days copy]];
    
    
}

#pragma mark - Date selection

- (BOOL)isInDatesSelected:(NSDate *)date
{
    for(NSDate *dateSelected in _datesSelected){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
        
    }
    
    return dateFormatter;
}

@end
