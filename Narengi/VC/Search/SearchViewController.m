//
//  SearchViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/3/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDetailViewController.h"
#import "SearchSectionView.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewContainerTrailingSpace;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger curentRequestcount;
@property (nonatomic,strong) NSArray *resultArray;
@property (nonatomic,strong) NSArray *histoyArray;
@property (nonatomic) BOOL isShowingHistory;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.searchViewContainer.layer.cornerRadius  = 15;
    self.searchViewContainer.layer.masksToBounds = YES;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAnimationfinished) name:@"modalTransitionLoaded" object:nil];
    
    [self.searchTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.histoyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];
    self.isShowingHistory = YES;
    
   
}

-(void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - animation

-(void)handleAnimationfinished{
    
    self.searchViewContainerTrailingSpace.constant = 25;
    
    [UIView animateWithDuration:.2
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         [self.searchTextField becomeFirstResponder];
                     }];
    
}

- (IBAction)dismiss:(UIButton *)sender {
    
    self.searchViewContainerTrailingSpace.constant = 75;
    
    [UIView animateWithDuration:.2
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         [self dismissViewControllerAnimated:YES completion:nil];
                         
    }];
    
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    if (self.isShowingHistory)
        return 1;
    
    else
        return self.resultArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isShowingHistory)
        return  self.histoyArray.count;
    
    else
        return [self.resultArray[section] count];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    if (self.isShowingHistory ) {
        cell.titleLabel.text = self.histoyArray[indexPath.row];
        cell.Img.image = IMG(@"RecentSearches");
    }
    else{
    
        AroundPlaceObject *aroundObj = self.resultArray[indexPath.section][indexPath.row];
        
        if ([aroundObj.type isEqualToString:@"House"])
            cell.titleLabel.text = aroundObj.houseObject.name;
        
        
        else if ([aroundObj.type isEqualToString:@"Attraction"])
            cell.titleLabel.text = aroundObj.attractionObject.name;
        
        
        else if ([aroundObj.type isEqualToString:@"City"])
            cell.titleLabel.text = aroundObj.cityObject.name;
        cell.Img.image = IMG(@"");
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowingHistory) {
        
        [self performSegueWithIdentifier:@"goToSearchDetailVC" sender:self.histoyArray[indexPath.row]];
    }
    else{
    
        AroundPlaceObject *aroundObj = self.resultArray[indexPath.section][indexPath.row];
        [self goTodetailWithUrl:aroundObj.urlStr andWithType:aroundObj.type];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    SearchSectionView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"SearchSection" owner:self options:nil] objectAtIndex:0];
    if (self.isShowingHistory) {
        
        headerView.titleLabel.text = @"تاریخچه";
    }
    else{
        
        AroundPlaceObject *aroundObj = self.resultArray[section][0];
        
        if ([aroundObj.type isEqualToString:@"House"])
            headerView.titleLabel.text = @"خانه‌ها";
        
        
        else if ([aroundObj.type isEqualToString:@"Attraction"])
            headerView.titleLabel.text = @"جاذبه‌ها";
        
        
        else if ([aroundObj.type isEqualToString:@"City"])
            headerView.titleLabel.text = @"شهرها";
    }
    
    
    return headerView;
}

-(void)reloadCollctionWithanimation{
    
    [UIView transitionWithView:self.tableView
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void)
     {
         [self.tableView reloadData];
     }
                    completion:nil];
    
}


#pragma mark - textFiled

- (void)textDidChanged:(id)sender
{
    
    if (self.searchTextField.text.length == 0) {
     
        self.histoyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];
        self.isShowingHistory = YES;
        [self reloadCollctionWithanimation];
    }
    else{
        
        self.isShowingHistory = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
            
            ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:@"suggestion" andWithParametrs:@[@"filter[selection][city]=4",@"filter[selection][attraction]=4",@"filter[selection][house]=4",[NSString stringWithFormat:@"term =%@",self.searchTextField.text]] andWithBody:nil];
            
            self.curentRequestcount++;
            dispatch_async(dispatch_get_main_queue(),^{
                
                self.curentRequestcount--;
                self.resultArray = @[];
                if (self.curentRequestcount == 0 && !self.isShowingHistory) {
                    
                    if (!serverRs.hasErro) {
                        
                        if (serverRs.backData !=nil ) {
                            
                            self.resultArray = [[NarengiCore sharedInstance] parsSuggestions:serverRs.backData];
                           [self reloadCollctionWithanimation];
                            
                        }
                        else{
                            //show erro if nedded
                        }
                    }
                    
                }
            });
        });
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    NSArray *histpryArr  = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];

    NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:histpryArr];
    
    for (NSString *str in histpryArr) {
        
        [muArr addObject:str];
    }

    
    // check term exist alreay or not 
    NSInteger indexes = [muArr indexOfObjectPassingTest:^BOOL(NSString *obj, NSUInteger idx, BOOL *stop)
    {
        return [obj isEqualToString:textField.text];
    }];
    
    if (indexes == NSNotFound ) {
        
        [muArr insertObject:textField.text atIndex:0];
        if (muArr.count > 5 ){
            muArr = [[NSMutableArray alloc]initWithArray:[muArr subarrayWithRange:NSMakeRange(0, 5)]];
            
        }
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[muArr copy] forKey:@"searchHistory"];
    }
    
    [self performSegueWithIdentifier:@"goToSearchDetailVC" sender:textField.text];
    
    return YES;
    
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"goToSearchDetailVC"]) {
        
        SearchDetailViewController *searchDetailVc = segue.destinationViewController;
        searchDetailVc.termrStr = sender;
    }
    
}



@end
