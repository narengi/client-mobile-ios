//
//  SelectAvailableDateViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 6/11/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectAvailableDateViewController.h"


@interface SelectAvailableDateViewController ()
{
    
    NSMutableDictionary *_eventsByDate;
    NSMutableArray *_datesSelected;
    
}
@end

@implementation SelectAvailableDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeLeftIcontoBack];
    [self changeRightButtonToClose];
    self.title = @"روز‌های قابل رزرو";
    
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    
    _datesSelected = [NSMutableArray new];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STEPCHANGED" object:[NSNumber numberWithInteger:8]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - CalendarManager delegate

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    
    
    [dayView setTransform:CGAffineTransformMakeScale(-1, 1)];
    
    //today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
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
        dayView.textLabel.textColor = [UIColor grayColor];
    }
    
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
    
    if([self isInDatesSelected:dayView.date]){
        
        [_datesSelected removeObject:dayView.date];
         [_calendarManager reload];
    }
    else{
        
        [_datesSelected addObject:dayView.date];
        
        [_calendarManager reload];
//        [self changeLabels];
        return;
    }
    
    
    
    
}

- (BOOL)isInDatesSelected:(NSDate *)date
{
    for(NSDate *dateSelected in _datesSelected){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - buttons
- (IBAction)goToNextStep:(UIButton *)sender {
    
    [self sendDates];
    
}

- (IBAction)preButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - send Data


-(void)sendDates{

    REACHABILITY
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"PUT" andWithService:[NSString stringWithFormat: @"houses/%@",self.houseObj.ID ] andWithParametrs:nil andWithBody:[self makeJson] andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [SVProgressHUD dismiss];
            if (!serverRs.hasErro) {
                
                
                self.houseObj =  [(AroundPlaceObject *)[[[NarengiCore sharedInstance] parsAroudPlacesWith:@[serverRs.backData] andwithType:@"House" andIsDetail:YES] firstObject] houseObject];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"houseInsertStatus" object:nil];

                [self dismissViewControllerAnimated:YES completion:nil];
                
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


-(NSArray *)makeDatesArr{


    NSMutableArray *stringDatesArr= [[ NSMutableArray alloc] init];
    
    [_datesSelected enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss zzz"];
        NSString *result = [df stringFromDate:obj];
        
        [stringDatesArr addObject:result];
        
    }];
    
    return [stringDatesArr copy];
    
}


-(NSData *)makeJson{

    NSMutableDictionary* bodyDict =[[NSMutableDictionary alloc] init];
    [bodyDict addEntriesFromDictionary: @{@"availableDates":[self makeDatesArr]}];
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[bodyDict copy] options:0 error:nil];
    
    return  bodyData;
}



@end
