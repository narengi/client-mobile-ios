//
//  ProfileViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserObject.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView    *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel        *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *descriptionLabel;

@property (weak, nonatomic) IBOutlet UITableView      *commentsTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *houseCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableHeightconstraint;

@property (nonatomic,strong) UserObject *user;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
