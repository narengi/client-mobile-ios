//
//  SearchViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/3/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "SearchViewController.h"

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
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:YES];
    
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isShowingHistory )
        return  self.histoyArray.count;
    
    else
        return self.resultArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    if (self.isShowingHistory ) {
        cell.titleLabel.text = self.histoyArray[indexPath.row];
    }
    else{
    
        AroundPlaceObject *aroundObj = self.resultArray[indexPath.row];
        
        if ([aroundObj.type isEqualToString:@"House"])
            cell.titleLabel.text = aroundObj.houseObject.name;
        
        
        else if ([aroundObj.type isEqualToString:@"Attraction"])
            cell.titleLabel.text = aroundObj.attractionObject.name;
        
        
        else if ([aroundObj.type isEqualToString:@"City"])
            cell.titleLabel.text = aroundObj.cityObject.name;
    }
    
    
    return cell;
}

#pragma mark - textFiled

- (void)textDidChanged:(id)sender
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:[NSString stringWithFormat: @"search?term=%@&filter[limit]=20&filter[skip]=0",self.searchTextField.text ] andWithParametrs:nil andWithBody:nil];
        
        self.curentRequestcount++;
        dispatch_async(dispatch_get_main_queue(),^{
            
            self.curentRequestcount--;
            self.resultArray = @[];
            if (self.curentRequestcount == 0) {
                
                //  [self.tableView reloadData];
                if (!serverRs.hasErro) {
                    
                    self.isShowingHistory = NO;
                    if (serverRs.backData !=nil ) {
                        
                        self.resultArray = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData];
                        [self.tableView reloadData];
                        
                    }
                    else{
                    }
                }
                
            }
        });
    });
    
    
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
    
    
    
    return YES;
    
}

@end
