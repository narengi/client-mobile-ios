//
//  ProfileViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 1/21/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserObject.h"
#import "CityDetailHouseCollectionReusableView.h"
#import "CommentTableViewCell.h"
#import "CommentsViewController.h"
#import "SearchDetailHomeCollectionViewCell.h"


@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView    *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel        *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UITableView      *commentsTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *houseCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *memberagaeLabel;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableHeightconstraint;

@property (nonatomic,strong) HostObject *hostObj;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //register Nibs for Tableviews
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil]  forCellReuseIdentifier:@"commentCellID"];
    [self.houseCollectionView registerNib:[UINib nibWithNibName:@"SearchDetailHomeCell" bundle:nil] forCellWithReuseIdentifier:@"homeCellID"];
    [self.houseCollectionView  registerNib:[CityDetailHouseCollectionReusableView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cityDetailHouseCollectionRV"];
    [self addParametrsToURL];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
//    [[UIApplication sharedApplication] setStatusBarStyle:self.navigationView.alpha == 1?UIStatusBarStyleDefault:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark - Data
-(void) addParametrsToURL{
    
    self.url =[self fixUrr:self.url withParametrs:@[@{@"name":@"filter[review]",@"value":@"3"}]];
    
}

-(void)getData{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:self.url.absoluteString andWithParametrs:nil andWithBody:nil andIsFullPath:YES];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            if (!serverRs.hasErro) {
                
                if (serverRs.backData !=nil ) {
                    
                    self.hostObj  = [[NarengiCore sharedInstance] parsHost:serverRs.backData isDetail:YES];
                    
                    [self setDataForView];
                }
                else{
                    //show erro if nedded
                }
            }
        });
    });
    
}

-(void)setDataForView{
    
    
    self.nameLabel.text        = self.hostObj.displayName;
    self.cityNameLabel.text    = self.hostObj.locationText;
    self.descriptionLabel.text = self.hostObj.descriptionStr;
    self.jobLabel.text         = self.hostObj.career;
    self.memberagaeLabel.text  = self.hostObj.memberFrom;

    [self.avatarImg sd_setImageWithURL:self.hostObj.imageUrl placeholderImage:nil];
    
        
    [self.commentsTableView reloadData];
    
    
    
    self.commentTableHeightconstraint.constant = (70*self.hostObj.commentsArr.count);
    
    [self.commentsTableView layoutIfNeeded];
    
//    self.contentViewHeightConstraint.constant = self.ownerTableView.frame.origin.y + (60*4)+60;
    [self.conView layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.contentViewHeightConstraint.constant+50);
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.hostObj.commentsArr.count;

    
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.commentsTableView) {
//        return 80;
//    }
//    else{
//        return 0;
//    }
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    CommentSectionHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CommentSectionView" owner:self options:nil] objectAtIndex:0];
//    headerView.rateImg.image = IMG(([NSString stringWithFormat:@"big%f",self.houseObj.roundedRate]));
//    headerView.rateCountLabel.text = [NSString stringWithFormat:@"بر اساس %@ رای",self.houseObj.reviewCount];
//    
//    return headerView;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCellID" forIndexPath:indexPath];
        CommentObject *commentObj =  self.hostObj.commentsArr[indexPath.row];
        commentCell.titleLabel.attributedText = commentObj.attributeStr;
        
        return commentCell;

    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self showCommentDetails];
    
}

-(void)showCommentDetails{
    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentsViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"commentsVC"];
    
    vc.houseIDStr = @"1";
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    
    formSheet.presentationController.contentViewSize = CGSizeMake(300, [UIScreen mainScreen].bounds.size.height - 60);
    
    formSheet.presentationController.portraitTopInset = 10;
    
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.contentViewCornerRadius = 8.0;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];
    
}


#pragma mark -collection delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseObject *houseObj = ((AroundPlaceObject *)[self.hostObj.houseArr objectAtIndex:indexPath.row]).houseObject;
    
    SearchDetailHomeCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCellID" forIndexPath:indexPath];
    
    NSString *str = @"";
    str = [str stringByAppendingString:houseObj.cost];
    str = [str stringByAppendingString:@"   "];
    
    pagerCell.priceLabel.text       = str;
    pagerCell.descriptionLabel.text = houseObj.featureSummray;
    pagerCell.titleLabel.text       = houseObj.name;
    [pagerCell.coverImg sd_setImageWithURL:houseObj.host.imageUrl placeholderImage:nil];
    pagerCell.priceLabel.layer.cornerRadius = 10;
    pagerCell.priceLabel.layer.masksToBounds = YES;
    
    pagerCell.imageUrls       = houseObj.imageUrls;
    [pagerCell.pages reloadData];
    pagerCell.rateImg.image = IMG(([NSString stringWithFormat:@"%f",houseObj.roundedRate]));
    
    return pagerCell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

    return self.hostObj.houseArr.count;
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *) collectionView
                        layout:(UICollectionViewLayout *) collectionViewLayout
        insetForSectionAtIndex:(NSInteger) section {
    
        return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /8 );
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0., 40);

    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:@"cityDetailHouseCollectionRV"
                                                                               forIndexPath:indexPath];
    
    
    CityDetailHouseCollectionReusableView* header_view = (CityDetailHouseCollectionReusableView*) cell;
    
    
    
    return header_view;
}

@end
