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

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.searchViewContainer.layer.cornerRadius  = 15;
    self.searchViewContainer.layer.masksToBounds = YES;
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAnimationfinished) name:@"modalTransitionLoaded" object:nil];

   
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:YES];
    

   
    

}

-(void)handleAnimationfinished{

    self.searchViewContainerTrailingSpace.constant = 25;

    [UIView animateWithDuration:.2
                     animations:^{

                         [self.view layoutIfNeeded];
                     }];
    

}


-(void)viewDidAppear:(BOOL)animated
{
 
    
    [super viewDidAppear:YES];
    
   

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
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    return cell;
}

@end
