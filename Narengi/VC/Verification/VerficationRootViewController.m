//
//  VerficationRootViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/25/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "VerficationRootViewController.h"

@interface VerficationRootViewController ()
@property (weak, nonatomic) IBOutlet UIView *introContainerView;
@property (weak, nonatomic) IBOutlet UIView *identifierView;


@end

@implementation VerficationRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isComingFromHouse) {
        
        [self changeRightIcontoDismiss];
    }
    else{
        [self changeLeftIcontoBack];
    }
    
    self.title = @"تایید هوییت";
    
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    NSString *didSeeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"didSeeVerificationIntro"];
    if (didSeeStr != nil){
        self.identifierView.alpha     = 1;
        self.introContainerView.alpha = 0;
    }
    else{
        self.identifierView.alpha     =0;
        self.introContainerView.alpha = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
