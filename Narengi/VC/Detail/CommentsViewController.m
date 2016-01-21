//
//  CommentsViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/14/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "CommentsViewController.h"
#import "IranButton.h"
#import "CommentDetailTableViewCell.h"

@interface CommentsViewController ()

@property (nonatomic,strong) NSArray     *commentsArr;
@property (weak, nonatomic ) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet IranButton *closeButton;


@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentDetailCell" bundle:nil] forCellReuseIdentifier:@"commentDetailVCID"];
    
    self.closeButton.layer.cornerRadius  = 5;
    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.borderWidth   = 1;
    self.closeButton.layer.borderColor   = RGB(136, 136, 136, 1).CGColor;
    
    
    self.tableView.estimatedRowHeight = 40.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getData];
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
    return self.commentsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CommentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentDetailVCID" forIndexPath:indexPath];
    
    CommentObject *commentObj = [self.commentsArr objectAtIndex:indexPath.row];
    
    cell.nameLabel.text        = commentObj.writerName;
    cell.descriptionLabel.text = commentObj.message;
    cell.dateLabel.text        = commentObj.dateStr;
    [cell.avatarImg sd_setImageWithURL:commentObj.imageUrl placeholderImage:nil];
    cell.rateImg.image = IMG(([NSString stringWithFormat:@"%f",commentObj.roundedRate]));

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewAutomaticDimension;
    
}

#pragma mark - Data
-(void)getData{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:[NSString stringWithFormat: @"/houses/%@/reviews",self.houseIDStr] andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            if (!serverRs.hasErro) {
                
                if (serverRs.backData !=nil ) {
                    
                    self.commentsArr = [[NarengiCore sharedInstance]parsComments: serverRs.backData ];
                    [self.tableView reloadData];
                }
                else{
                    //showError
                }
            }
        });
    });
    
}
- (IBAction)closeButton:(IranButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
