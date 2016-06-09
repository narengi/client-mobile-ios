//
//  StepViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 6/6/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "StepViewController.h"

@interface StepViewController ()

@property (nonatomic) NSInteger currentPage;

@end

@implementation StepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stepChanged:) name:@"STEPCHANGED" object:nil];

    [super viewWillAppear:YES];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    
    
}
-(void)viewDidLayoutSubviews{
    
    [self setCornerRadiusInView:self.view];
}

-(void)stepChanged:(NSNotification *)notification{

    self.currentPage = [notification.object integerValue];
}

-(void)checkStyleForViewWithCurrentTag: (NSInteger )tag{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setCornerRadiusInView:(UIView*)view
{
    
    if ([view isKindOfClass:[UILabel class]])
    {
        
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        
        if (self.currentPage >= 1) {
           
            if (view.tag < self.currentPage) {
                view.backgroundColor = [UIColor greenColor];
                ((UILabel *)view).textColor = [UIColor whiteColor];
            }
            else if (view.tag == self.currentPage){
                view.backgroundColor = [UIColor orangeColor];
                ((UILabel *)view).textColor = [UIColor whiteColor];
            }
            else{
                view.backgroundColor = [UIColor lightGrayColor];
                ((UILabel *)view).textColor = [UIColor darkGrayColor];
            }
        }
        
        
        ((UILabel *)view).font = [UIFont fontWithName:@"IRANSansMobileFaNum-Medium" size:13];
    }
    
    if (view.subviews.count > 0)
    {
        for (UIView *sview in view.subviews)
        {
            [self setCornerRadiusInView:sview];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
