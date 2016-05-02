//
//  BookViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/2/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "BookViewController.h"
#import "BillTableViewCell.h"
#import "BookFacilityTableViewCell.h"
#import "BookFacilityHeaderView.h"
#import "BillHeaderView.h"
#import "SuccessReserveViewController.h"

@interface BookViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableDictionary *_eventsByDate;
    NSMutableArray *_datesSelected;
    
}

@property (nonatomic,strong) NSDate *arriveDate;
@property (nonatomic,strong) NSDate *leaveDate;
@property (nonatomic,strong) NSDate *lastAvailabeDate;

@property (nonatomic,strong) NSArray *availableDates;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *arriveDateLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *leaveDateLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *totalDaysLabel;
@property (weak, nonatomic) IBOutlet CustomFaBoldLabel *guestCountLabel;

@property (weak, nonatomic) IBOutlet IranButton *continuebutton;
@property (nonatomic) NSInteger  guestCount;

@property (weak, nonatomic) IBOutlet UITableView *facilityTableView;
@property (weak, nonatomic) IBOutlet UITableView *billTableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facilityTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *billTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parentViewHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong)  NSMutableArray *priceListArr;
@property (weak, nonatomic) IBOutlet UIView *parentView;

@end

@implementation BookViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars     = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.continuebutton setBorderWithColor: RGB(10, 187, 120, 1) andWithWidth:1 withCornerRadius:2];

    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    
    _datesSelected = [NSMutableArray new];
    
    self.guestCount = 1;
    self.guestCountLabel.text = [NSString stringWithFormat:@"%ld",self.guestCount];
    
    [self registerNibs];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseObjRecived:) name:@"houseObjectForBokking" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentNotificationRecived:) name:@"paymentNotificationRecived" object:nil];

    

}

-(void)checkBill{

    self.totalFee = 0;
    self.priceListArr = [[NSMutableArray alloc] init];

    if (self.arriveDate != nil && self.leaveDate != nil) {
        
        PriceObject *pernightPrice = [[PriceObject alloc] init];
        
        pernightPrice.name  = [NSString stringWithFormat:@"%ld شب × %ld تومان",[self calculateDays],self.houseObj.price  ];
        pernightPrice.fee  = [self calculateDays] * self.houseObj.price ;
        
        self.totalFee += pernightPrice.fee;
        [self.priceListArr  addObject:pernightPrice];
    }
    else{
        
        PriceObject *pernightPrice = [[PriceObject alloc] init];
        
        pernightPrice.name  = [NSString stringWithFormat:@"-"];
        pernightPrice.fee  = 0 ;
        
        [self.priceListArr  addObject:pernightPrice];
        
    }


    if (self.guestCount > [self.houseObj.guestCount integerValue]) {
        
        PriceObject *extraGuestPrice = [[PriceObject alloc] init];
        extraGuestPrice.name  = [NSString stringWithFormat:@"%ld × مهمان اضافی",[self calculateExtraGuest]];
        extraGuestPrice.fee  = [self calculateExtraGuest] * self.houseObj.extraGuestPrice;
        
        self.totalFee += extraGuestPrice.fee;
        [self.priceListArr  addObject:extraGuestPrice];
        
    }

    
    [self.houseObj.exteraServices enumerateObjectsUsingBlock:^(ExtraServiceObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isSelected) {
            
            PriceObject *priceObj = [[PriceObject alloc] init];
            priceObj.fee  = obj.price;
            priceObj.name = obj.name;
            self.totalFee += obj.price;
            [self.priceListArr  addObject:priceObj];

        }
    }];
    
    PriceObject *rentPrice = [[PriceObject alloc] init];
    rentPrice.name  = @"حق سرویس";
    
    if (self.houseObj.commissionObj.rate > 0) {
        rentPrice.fee += (self.totalFee * self.houseObj.commissionObj.rate )/100;
    }
    else{
        rentPrice.fee  = self.houseObj.commissionObj.fee;
    }
    [self.priceListArr  addObject:rentPrice];
    
    self.totalFee += rentPrice.fee;
    
    PriceObject *totalPrice = [[PriceObject alloc] init];
    totalPrice.name  = @"مجموع";
    totalPrice.fee  = self.totalFee;
    [self.priceListArr  addObject:totalPrice];
    
    [self.billTableview reloadData];
    [self.facilityTableView reloadData];
    
    
    
}
-(void)updateUI{

    if (self.houseObj.exteraServices.count > 0) {
        self.facilityTableHeight.constant = self.houseObj.exteraServices.count * 55 + 40;
    }
    else
        self.facilityTableHeight.constant = 0;
    
    if (self.priceListArr.count > 0) {
        self.billTableHeight.constant = (self.priceListArr.count + 1) * 40;
    }
    else
        self.billTableHeight.constant = 0;
    
    [self.facilityTableView layoutIfNeeded];
    [self.billTableview layoutIfNeeded];
    
    [self.view layoutIfNeeded];

    
    self.parentViewHeight.constant = self.billTableview.frame.origin.y + self.billTableHeight.constant + 100;
    
    [self.parentView layoutIfNeeded];
    [self.view layoutIfNeeded];
}

-(void)houseObjRecived:(NSNotification *)notification{

    self.houseObj = notification.object;
    [self checkBill];
    [self updateUI];
    
     [self getValidDates];
}

-(void)registerNibs{

    [self registerCellWithName:@"BookFacilityCell" andWithIdentifier:@"bookFacilityCellID" andTableView:self.facilityTableView];
    [self registerCellWithName:@"BillCell" andWithIdentifier:@"billCellID" andTableView:self.billTableview];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.facilityTableView)
        return self.houseObj.exteraServices.count;
    
    else
        return self.priceListArr.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.facilityTableView) {
        
        BookFacilityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookFacilityCellID" forIndexPath:indexPath];
        ExtraServiceObject *extraObj = [self.houseObj.exteraServices objectAtIndex:indexPath.row];
        cell.titleLabel.text = extraObj.name;
        cell.priceLabel.text  = [NSString stringWithFormat:@"%ld تومان", extraObj.price ];
        
        if (extraObj.isSelected)
            cell.stateImg.image = IMG(@"amenitieschecked");
        else
            cell.stateImg.image = IMG(@"amenitiesoption");
        
        if ( indexPath.row == self.priceListArr.count -1 )
            cell.lineLabel.hidden = NO;
        
        else
            cell.lineLabel.hidden = YES;
            
        
        
        return cell;

    }
    else{
        
        BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCellID" forIndexPath:indexPath];
        
        PriceObject *priceObj = [self.priceListArr objectAtIndex:indexPath.row];
        cell.titleLabel.text  = priceObj.name;
        cell.priceLabel.text  = [NSString stringWithFormat:@"%ld تومان", priceObj.fee ];
        
        if ( indexPath.row == self.priceListArr.count -1 ){
            cell.lineLabel.hidden = NO;
            cell.priceLabel.textColor = RGB (10, 187, 120, 1);
            cell.priceLabel.font  = [cell.priceLabel.font fontWithSize:15];
        }
        else{
            cell.lineLabel.hidden = YES;
            cell.priceLabel.textColor = RGB (0, 0, 0, 1);
            cell.priceLabel.font  = [cell.priceLabel.font fontWithSize:13];

        }
        
        
        return cell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.facilityTableView)
        
        return 55;
    
    else
        return 40;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.facilityTableView){
    
        BookFacilityHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"BookFacilityHeader" owner:self options:nil] objectAtIndex:0];
        
        return headerView;
    }
        
    
    else{
        
        BillHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"BillHeader" owner:self options:nil] objectAtIndex:0];
        
        return headerView;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView ==  self.facilityTableView) {
        
        ExtraServiceObject *extraObj = [self.houseObj.exteraServices objectAtIndex:indexPath.row];
        extraObj.isSelected = !extraObj.isSelected;
        NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:self.houseObj.exteraServices];
        [muArr replaceObjectAtIndex:indexPath.row withObject:extraObj];
        
        self.houseObj.exteraServices = [muArr copy];
        [self checkBill];
        [self updateUI];

        
    }

}


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
    
    // Another day of the current month
    else{
        
        
        if([self isInAvailableDates:dayView.date]){
            
            dayView.circleView.hidden = YES;
            dayView.dotView.hidden = YES;
            dayView.textLabel.textColor = [UIColor blackColor];
            
        }
        else{
            
            dayView.circleView.hidden = YES;
            dayView.dotView.hidden = YES;
            dayView.textLabel.textColor = [UIColor lightGrayColor];
        }

        
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
    
    if (self.arriveDate == nil) {
        
        
        if([self isInAvailableDates:dayView.date]){
            
            self.arriveDate = dayView.date;
            [_datesSelected addObject:dayView.date];
            
            [_calendarManager reload];
            [self changeLabels];
            return;
        }
        else
            [SVProgressHUD showErrorWithStatus:@"این روز قابل رزرو کردن نیست"];


        
    }
    else if (self.leaveDate == nil ){
        
        self.leaveDate = dayView.date;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        if ([self.arriveDate compare:dayView.date] == NSOrderedAscending) {
            [self addDatebetweenTwoDate:self.arriveDate andarriveDate:dayView.date];
            
            if (![self isAllDatesBetweenAreOk]) {
                
                [_datesSelected removeAllObjects];
                self.leaveDate = nil;
                
                [_datesSelected addObject:self.arriveDate];
                
                [SVProgressHUD showErrorWithStatus:@"روزهای بین دو روز انتخاب شده قبلا رزو شده‌اند"];
            }
            
            

            
        }
        else if ([self.arriveDate compare:dayView.date] == NSOrderedDescending){
            
            NSDate *tempDate = self.arriveDate;;
            self.arriveDate = self.leaveDate;
            self.leaveDate = tempDate;
            
            [_datesSelected removeAllObjects];
            [_datesSelected addObject:dayView.date];
            [self addDatebetweenTwoDate:self.arriveDate andarriveDate:self.leaveDate];
            
            if (![self isAllDatesBetweenAreOk]) {
                
                [_datesSelected removeAllObjects];
                self.leaveDate = nil;
                
                [_datesSelected addObject:self.arriveDate];
                
                [SVProgressHUD showErrorWithStatus:@"روزهای بین دو روز انتخاب شده قبلا رزو شده‌اند"];
            }
            
        }
        else{
            
        }
        
       
        
        
        
        [_calendarManager reload];
        [self changeLabels];
        
        return;
    }
    else{
        
        
        if([self isInAvailableDates:dayView.date]){
            
            [_datesSelected removeAllObjects];
            self.arriveDate = dayView.date;
            self.leaveDate = nil;
            
            [_datesSelected addObject:dayView.date];
            [_calendarManager reload];
            
            [self changeLabels];

        }
        else
            [SVProgressHUD showErrorWithStatus:@"این روز قابل رزرو کردن نیست"];
        
    }
    
}


-(void)changeLabels{

    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat = [format changetoShortFormmat];
    
    if (self.arriveDate != nil) {
       self.arriveDateLabel.text =  [[dateFormat stringFromDate:self.arriveDate] stringByReplacingOccurrencesOfString:@" ه‍.ش." withString:@""];

    }
    else{
        self.arriveDateLabel.text  = @"-";
    }
    
    if (self.leaveDate != nil ){
        self.leaveDateLabel.text = [[dateFormat stringFromDate:self.leaveDate] stringByReplacingOccurrencesOfString:@" ه‍.ش." withString:@""];

    }
    else{
        self.leaveDateLabel.text = @"-";
    }
    
    if (self.arriveDate != nil && self.arriveDate != nil  ) {
        self.totalDaysLabel.text = [NSString stringWithFormat:@"%ld شب و %ld روز",(long)[self calculateDays],[self calculateDays]+1];
    }
    else{
        self.totalDaysLabel.text = @"-";
    }

    [self checkBill];
    [self updateUI];

}

-(NSInteger)calculateDays{

    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:self.arriveDate
                                                          toDate:self.leaveDate
                                                         options:NSCalendarWrapComponents];
    
    return [components day];
    
}


-(void )addDatebetweenTwoDate :(NSDate *)arriveDate andarriveDate:(NSDate *)secondDate{
    
    
    
    NSMutableArray * days = [NSMutableArray new];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *startDate = arriveDate;
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

-(BOOL)isInAvailableDates:(NSDate *)date{
    
    for(NSDate *dateSelected in self.availableDates){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isAllDatesBetweenAreOk{
    
    
    for(NSDate *dateSelected in _datesSelected){
        if(![self isInAvailableDates:dateSelected]){
            return NO;
        }
    }
    
    return YES;

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
- (IBAction)cancelButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil]
    ;
}
#pragma mark - guest part
- (IBAction)plusButtonClicked:(id)sender {

    if (self.guestCount != self.houseObj.maxGuestCount ) {
        self.guestCount += 1;
        self.guestCountLabel.text = [NSString stringWithFormat:@"%ld",self.guestCount];
    
        [self checkBill];
        [self updateUI];

    }

}

- (IBAction)minusButtonClicked:(id)sender {
    
    if (self.guestCount != 1) {
        self.guestCount -= 1;
        self.guestCountLabel.text = [NSString stringWithFormat:@"%ld",self.guestCount];
        
        [self checkBill];
        [self updateUI];

    }
    
}

-(NSInteger)calculateExtraGuest{
    
    return self.guestCount - [self.houseObj.guestCount integerValue];
    
}

#pragma mark -data
- (IBAction)continueButtonClicked:(IranButton *)sender {
    
    REACHABILITY
    
    if ((self.arriveDate != nil) && (self.leaveDate != nil )) {
     
        [self showSuccessAlert];
    }
    else{
        
        [SVProgressHUD showErrorWithStatus:@"روزهای رسیدن و ترک کردن به درستی انتخاب نشده است!"];
    }
}
-(void)showSuccessAlert{

    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
    SuccessReserveViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"SuccessReserveVCID"];
    
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    
    formSheet.presentationController.contentViewSize = CGSizeMake(300, 400);
    
    formSheet.presentationController.portraitTopInset = 10;
    
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.contentViewCornerRadius = 8.0;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];
}


-(void)getValidDates{

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
    NSString *startDateStr = [format stringFromDate:[NSDate new]];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.year = 1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextYear = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSString *endDateStr  = [format stringFromDate: nextYear];
    
    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:[NSString stringWithFormat:@"%@/available-dates/start-%@/end-%@",self.houseObj.url,startDateStr,endDateStr] andWithParametrs:nil andWithBody:nil andIsFullPath:YES];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [SVProgressHUD dismiss];
            
            if (!response.hasErro) {
                
                if (response.backData != nil) {
                    
                    [self setAvailabelDates:response.backData];
                }
            }
            else{
                
                if (response.backData != nil ) {
                    
                    //show error
                    NSString *erroStr = [[response.backData objectForKey:@"error"] objectForKey:@"message"];
                    [self showErro:erroStr];
                }
                else{
                    
                    [self showErro:@"اشکال در ارتباط با سرور"];
                    
                }
                
            }
        });
    });
}

-(void)setAvailabelDates:(NSDictionary *)dataFromServer{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    [[dataFromServer objectForKey:@"dates"] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *date = [format dateFromString:[[obj componentsSeparatedByString:@"T"] firstObject] ];
        
        [muArr addObject:date];
        
    }];

    self.availableDates = [muArr copy];
    
    NSDate *date = [format dateFromString:[[[dataFromServer objectForKey:@"lastAllowedDate"] componentsSeparatedByString:@"T"] firstObject] ];
    self.lastAvailabeDate = date;

    
    
}

#pragma mark - notification

-(void)paymentNotificationRecived:(NSNotification *)notification{

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
