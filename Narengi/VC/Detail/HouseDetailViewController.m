//
//  HouseDetailViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "HouseDetailViewController.h"
#import "PageCell.h"
#import "HomeFacilityCollectionViewCell.h"
#import "OwnerTableViewCell.h"
#import "CommentSectionHeaderView.h"
#import "CommentTableViewCell.h"
#import "PropertyView.h"

@interface HouseDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *mapViewImg;
@property (weak, nonatomic) IBOutlet UIImageView *startsImg;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *priceLabelcontainer;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *propertyView;


@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITableView *ownerTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *facilitiesCollectionView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic) CGFloat   headerFade;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableHeightconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ownerTableViewHeightConstraint;

@property (nonatomic,strong) NSArray     *ownerDesArr;
@property (nonatomic,strong) HouseObject *houseObj;

@end

@implementation HouseDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //register Nibs
    [self.imagesCollectionView registerNib:[UINib nibWithNibName:@"PagerCell" bundle:nil] forCellWithReuseIdentifier:@"pageCellID"];
    self.imagesCollectionView.pagingEnabled = YES;
    
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil]  forCellReuseIdentifier:@"commentCellID"];
     [self.ownerTableView registerNib:[UINib nibWithNibName:@"OwnerDesCell" bundle:nil]  forCellReuseIdentifier:@"ownerCellID"];
    
    //scrollView delegate
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
    self.ownerDesArr = @[@"پروفایل مالک",@"ارتباط با مالک",@"خدمات و خدمت‌های اضافی",@"شرایط و قوانین"];
    
    //Get Data For firstTime
    [self addParametrsToURL];
    [self getData];
    
    [self loadPorperties];



}

-(void)loadPorperties{

     PropertyView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"PropertyView" owner:self options:nil] objectAtIndex:0];
    
    [self.propertyView addSubview:headerView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.navigationView.alpha == 1?UIStatusBarStyleDefault:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(375, 1200);
    self.commentTableHeightconstraint.constant = 70*3;
    self.ownerTableViewHeightConstraint.constant  = 60*4;
    
    [self.commentsTableView layoutIfNeeded];
    [self.ownerTableView layoutIfNeeded];
}
-(void)changeContentSize :(NSArray *)arr{
}


#pragma mark - scrollViewDelegate

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context != (__bridge void *)self) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ((object == self.scrollView) &&
        ([keyPath isEqualToString:@"contentOffset"] == YES)) {
        [self scrollViewDidScrollWithOffset:self.scrollView.contentOffset.y];
        return;
    }
}
- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    
    CATransform3D headerTransform = CATransform3DIdentity;
    
    
    if (scrollOffset < 0) {
        
        CGFloat headerScaleFactor = -(scrollOffset) / self.imagesCollectionView.bounds.size.height;
        
        CGFloat headerSizevariation = ((self.imagesCollectionView.bounds.size.height * (1.0 + headerScaleFactor)) - self.imagesCollectionView.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.imagesCollectionView.layer.transform = headerTransform;
        
    }
    
    
    if(scrollOffset > _headerFade && self.navigationView.alpha == 0.0){ //make the header appear
        self.navigationView.alpha = 0;
        self.navigationView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationView.alpha = 1;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
        }];
    }
    else if(scrollOffset < _headerFade &&  self.navigationView.alpha == 1.0){ //make the header disappear
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationView.alpha = 0;
        } completion: ^(BOOL finished) {
            self.navigationView.hidden = YES;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
        }];
    }
    
}


#pragma mark - Data
-(void) addParametrsToURL{
    
    self.url =[self fixUrr:self.url withParametrs:@[@{@"name":@"filter[review]",@"value":@"3"},@{@"name":@"ilter[feature]",@"value":@"4"}]];
    
}

-(void)getData{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:self.url.absoluteString andWithParametrs:nil andWithBody:nil andIsFullPath:YES];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            if (!serverRs.hasErro) {
                
                if (serverRs.backData !=nil ) {
                    
                    AroundPlaceObject *obj  = [[[NarengiCore sharedInstance] parsAroudPlacesWith:@[serverRs.backData] andwithType:@"Attraction" andIsDetail:YES] firstObject];
                 //   self.attractionObject = obj.attractionObject;
                    
                   // [self setDataForView];
                }
                else{
                    //show erro if nedded
                }
            }
        });
    });
    
}
-(void)setDataForView{
    
    
    self.titleLabel.text = self.houseObj.name;
    self.descriptionLabel.text = @"این یه جازبه باحال از خیلی وقت پیش که داریم کم کم نابودش میکنیم راحت بشیم.";
    [self.imagesCollectionView reloadData];
    [self.facilitiesCollectionView reloadData];
    [self.commentsTableView reloadData];
    [self.ownerTableView reloadData];
    
   // [self changeContentSize:self.attractionObject.housesArr];
    
}

#pragma mark -collection delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //if (collectionView == self.imagesCollectionView){
        PageCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCellID" forIndexPath:indexPath];
       // [collectionCell.backImageView sd_setImageWithURL:self.houseObj.imageUrls[indexPath.row] placeholderImage:nil];
        
        return collectionCell;
        
    //}

    
    
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
   
//    if (collectionView == self.imagesCollectionView){
//        return self.houseObj.imageUrls.count ;
//    }
//    else{
//        return self.houseObj.imageUrls.count;
//    }
    return 0;
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
    
    
    if (collectionView == self.imagesCollectionView){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.width);
    }
    else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /8 );
    }
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView ==  self.facilitiesCollectionView) {
        return CGSizeMake(0., 40);
    }
    else{
        return CGSizeMake(0., 0);
    }
    
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.commentsTableView) {
        return 10;
    }
    else{
        return 4;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.commentsTableView) {
        CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCellID" forIndexPath:indexPath];
        return commentCell;
    }
    else{
        
        OwnerTableViewCell *ownerDesCell = [tableView dequeueReusableCellWithIdentifier:@"ownerCellID" forIndexPath:indexPath];
        
        ownerDesCell.label.text = self.ownerDesArr[indexPath.row];
        return ownerDesCell;
        
    }


}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.commentsTableView) {
        return 60;
    }
    else{
        return 71;
    }
}



@end
