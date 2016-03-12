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

@interface BookViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableDictionary *_eventsByDate;
    
    NSMutableArray *_datesSelected;
}

@property (nonatomic,strong) NSDate *firstDate;
@property (nonatomic,strong) NSDate *secondDate;

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
    

}

-(void)checkBill{

    self.totalFee = 0;
    self.priceListArr = [[NSMutableArray alloc] init];

    if (self.firstDate != nil && self.secondDate != nil) {
        
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
    rentPrice.fee  = 20000;
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
}

-(void)registerNibs{

    [self registerCellWithName:@"BookFacilityCell" andWithIdentifier:@"bookFacilityCellID" andTableView:self.facilityTableView];
    [self registerCellWithName:@"BillCell" andWithIdentifier:@"billCellID" andTableView:self.billTableview];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark -tableView


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
    
    if (self.firstDate == nil) {
        
        self.firstDate = dayView.date;
        [_datesSelected addObject:dayView.date];
        
        [_calendarManager reload];
        [self changeLabels];
        return;
        
    }
    else if (self.secondDate == nil ){
        
        self.secondDate = dayView.date;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        if ([self.firstDate compare:self.secondDate] == NSOrderedAscending) {
            [self addDatebetweenTwoDate:self.firstDate andSecondDate:dayView.date];
            
        }
        else if ([self.firstDate compare:self.secondDate] == NSOrderedDescending){
            
            NSDate *tempDate = self.firstDate;;
            self.firstDate = self.secondDate;
            self.secondDate = tempDate;
            
            [_datesSelected removeAllObjects];
            [_datesSelected addObject:dayView.date];
            [self addDatebetweenTwoDate:self.firstDate andSecondDate:self.secondDate];
            
        }
        else{
            
        }
        
        
        
        [_calendarManager reload];
        [self changeLabels];
        
        return;
    }
    else{
        
        [_datesSelected removeAllObjects];
        self.firstDate = dayView.date;
        self.secondDate = nil;
        
        [_datesSelected addObject:dayView.date];
        [_calendarManager reload];
        
        [self changeLabels];
        
    }
    
}


-(void)changeLabels{

    NSDateFormatter *validFormat = [[NSDateFormatter alloc] init];
    [validFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat = [format changetoShortFormmat];
    
    if (self.firstDate != nil) {
       self.arriveDateLabel.text =  [[dateFormat stringFromDate:self.firstDate] stringByReplacingOccurrencesOfString:@" ه‍.ش." withString:@""];

    }
    else{
        self.arriveDateLabel.text  = @"-";
    }
    
    if (self.secondDate != nil ){
        self.leaveDateLabel.text = [[dateFormat stringFromDate:self.secondDate] stringByReplacingOccurrencesOfString:@" ه‍.ش." withString:@""];

    }
    else{
        self.leaveDateLabel.text = @"-";
    }
    
    if (self.firstDate != nil && self.secondDate != nil  ) {
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
                                                        fromDate:self.firstDate
                                                          toDate:self.secondDate
                                                         options:NSCalendarWrapComponents];
    
    return [components day];
    
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
- (IBAction)cancelButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil]
    ;
}
#pragma mark - guest part
- (IBAction)plusButtonClicked:(id)sender {
    
    if (self.guestCount != 1) {
        self.guestCount -= 1;
        self.guestCountLabel.text = [NSString stringWithFormat:@"%ld",self.guestCount];
    }

}

- (IBAction)minusButtonClicked:(id)sender {
    
    if (self.guestCount != [self.houseObj.guestCount integerValue]) {
        self.guestCount += 1;
        self.guestCountLabel.text = [NSString stringWithFormat:@"%ld",self.guestCount];
    }
}

#pragma mark -data
- (IBAction)continueButtonClicked:(IranButton *)sender {
}


@end
