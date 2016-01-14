//
//  CommentsViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/14/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentDetailTableViewCell.h"

@interface CommentsViewController ()

@property (nonatomic,strong) NSArray *commentsArr;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentDetailVCID" forIndexPath:indexPath];
    
    CommentObject *commentObj = [self.commentsArr objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = commentObj.writerName;
    cell.descriptionLabel.text = commentObj.message;
    cell.rateImg = 
    
    return cell;
}

@end
