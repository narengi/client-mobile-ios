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
#import "MoreFacilityCollectionViewCell.h"
#import "OwnerTableViewCell.h"
#import "CommentSectionHeaderView.h"
#import "CommentTableViewCell.h"
#import "PropertyView.h"
#import "HWViewPager.h"
#import "FacilitiesViewController.h"
#import "CommentsViewController.h"

@interface HouseDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *mapViewImg;
@property (weak, nonatomic) IBOutlet UIImageView *startsImg;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;

@property (weak, nonatomic) IBOutlet UIView *priceLabelcontainer;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *propertyView;


@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITableView *ownerTableView;
@property (weak, nonatomic) IBOutlet HWViewPager *image2CollectionView;

@property (weak, nonatomic) IBOutlet HWViewPager *imagesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *facilitiesCollectionView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *conView;


@property (nonatomic) CGFloat   headerFade;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableHeightconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ownerTableViewHeightConstraint;

@property (nonatomic,strong) NSArray     *ownerDesArr;
@property (nonatomic,strong) HouseObject *houseObj;


@property (weak, nonatomic) IBOutlet UILabel *bedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;


@end

@implementation HouseDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars     = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.scrollView.clipsToBounds = YES;

    [self registerNibFiles];
    
    [self.facilitiesCollectionView setTransform:CGAffineTransformMakeScale(-1, 1)];

    
    //scrollView delegate
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
    self.ownerDesArr = @[@"پروفایل مالک",@"ارتباط با مالک",@"خدمات و خدمت‌های اضافی",@"شرایط و قوانین"];
    self.navigationView.alpha = 0;
    self.headerFade = [UIScreen mainScreen].bounds.size.width - 150;
    
    //Get Data For firstTime
    [self addParametrsToURL];
    [self getData];
    


}


-(void)registerNibFiles{

    //register Nibs for collection
    [self.imagesCollectionView registerNib:[UINib nibWithNibName:@"PagerCell" bundle:nil] forCellWithReuseIdentifier:@"pageCellID"];
    self.imagesCollectionView.pagingEnabled = YES;
    
    [self.image2CollectionView registerNib:[UINib nibWithNibName:@"PagerCell" bundle:nil] forCellWithReuseIdentifier:@"pageCellID"];
    self.image2CollectionView.pagingEnabled = YES;
    
    [self.facilitiesCollectionView registerNib:[UINib nibWithNibName:@"FacilityCell" bundle:nil] forCellWithReuseIdentifier:@"facilityCell"];
    [self.facilitiesCollectionView registerNib:[UINib nibWithNibName:@"MoreFacilityCell" bundle:nil] forCellWithReuseIdentifier:@"moreFacilityCell"];
    self.facilitiesCollectionView.scrollEnabled = NO;
    
    //register Nibs for Tableviews
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil]  forCellReuseIdentifier:@"commentCellID"];
    [self.ownerTableView registerNib:[UINib nibWithNibName:@"OwnerDesCell" bundle:nil]  forCellReuseIdentifier:@"ownerCellID"];

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
    
    if ((object == self.scrollView) && ([keyPath isEqualToString:@"contentOffset"] == YES)) {
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

    
    if (scrollOffset == 0) {
        self.image2CollectionView.alpha = 1;
    }
    else{
        self.image2CollectionView.alpha = 0;
    }
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
    
    self.url =[self fixUrr:self.url withParametrs:@[@{@"name":@"filter[review]",@"value":@"3"},@{@"name":@"filter[feature]",@"value":@"1000"}]];
    
}

-(void)getData{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:self.url.absoluteString andWithParametrs:nil andWithBody:nil andIsFullPath:YES];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            if (!serverRs.hasErro) {
                
                if (serverRs.backData !=nil ) {
                    
                    AroundPlaceObject *obj  = [[[NarengiCore sharedInstance] parsAroudPlacesWith:@[serverRs.backData] andwithType:@"House" andIsDetail:YES] firstObject];
                    self.houseObj = obj.houseObject;
                    
                    [self setDataForView];
                }
                else{
                    //show erro if nedded
                }
            }
        });
    });
    
}


-(void)loadPorperties{
    
    self.typeLabel.text       = self.houseObj.type;
    self.roomcountLabel.text  = [self.houseObj.bedroomCount stringByAppendingString:@" اتاق خواب"];
    self.guestCountLabel.text = [self.houseObj.guestCount stringByAppendingString:@" مهمان"];
    self.bedCountLabel.text   = [self.houseObj.bedroomCount stringByAppendingString:@" تخت"];

}

-(void)setDataForView{
    
    
    self.titleLabel.text       = self.houseObj.name;
    self.navTitleLabel.text    = self.houseObj.name;
    self.cityNameLabel.text    = self.houseObj.cityName;
    self.descriptionLabel.text = self.houseObj.summary;
    
    self.reviewCountLabel.text = [NSString stringWithFormat:@"( %@ رای )",self.houseObj.reviewCount];

    
    self.startsImg.image = IMG(([NSString stringWithFormat:@"%f",self.houseObj.roundedRate]));
    self.avatarImg.layer.cornerRadius  = 40;
    self.avatarImg.layer.masksToBounds = YES;
    self.avatarImg.layer.borderWidth = 4;
    self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.avatarImg sd_setImageWithURL:self.houseObj.host.imageUrl placeholderImage:nil];
    self.mapViewImg.layer.masksToBounds  = YES;
 
    NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&%@&sensor=true",self.houseObj.geoObj.lat, self.houseObj.geoObj.lng,[NSString stringWithFormat:@"zoom=14&size=%.fx200",[UIScreen mainScreen].nativeBounds.size.width ]];
    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.mapViewImg sd_setImageWithURL:mapUrl placeholderImage:nil];
    
    [self loadPorperties];

    [self.imagesCollectionView reloadData];
    [self.image2CollectionView reloadData];
    [self.facilitiesCollectionView reloadData];
    [self.commentsTableView reloadData];
    [self.ownerTableView reloadData];
    
    
    
    self.commentTableHeightconstraint.constant = (70*self.houseObj.commentsArr.count)+(self.houseObj.commentsArr.count > 0 ? 80 : 0);
    
    self.ownerTableViewHeightConstraint.constant  = 60*4;
    
    [self.commentsTableView layoutIfNeeded];
    [self.ownerTableView layoutIfNeeded];
    
    self.contentViewHeightConstraint.constant = self.ownerTableView.frame.origin.y + (60*4)+60;
    [self.conView layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.contentViewHeightConstraint.constant+50);

    
    
}

#pragma mark -collection delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (collectionView == self.imagesCollectionView ||(collectionView == self.image2CollectionView) ){
        PageCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCellID" forIndexPath:indexPath];
        [collectionCell.backImageView sd_setImageWithURL:self.houseObj.imageUrls[indexPath.row] placeholderImage:nil];
        
        return collectionCell;
        
    }
    else
    {

        
        if (self.houseObj.canShowMoreFacility) {
         
            if (indexPath.row < self.houseObj.shownFacilities.count-1) {
                HomeFacilityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"facilityCell" forIndexPath:indexPath];
                
                FacilityObject *facilityObj = self.houseObj.shownFacilities[indexPath.row];
                cell.titleLabel.text = facilityObj.name;
                
                return cell;
            }
            else{

                MoreFacilityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreFacilityCell" forIndexPath:indexPath];
                
                cell.titleLabel.text = self.houseObj.shownFacilities[indexPath.row];;
                
                return cell;
            }

        }
        else{
            HomeFacilityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"facilityCell" forIndexPath:indexPath];
            
            FacilityObject *facilityObj = self.houseObj.shownFacilities[indexPath.row];
            cell.titleLabel.text = facilityObj.name;
            
            return cell;
            
        }

        return nil;
    }
 
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
   
    if (collectionView == self.imagesCollectionView || (collectionView == self.image2CollectionView) ){
        return self.houseObj.imageUrls.count ;
    }
    else{
        return self.houseObj.facilityArr.count;
    }
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
    
    
    if (collectionView == self.imagesCollectionView || (collectionView == self.image2CollectionView )){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.width);
    }
    else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width/self.houseObj.shownFacilities.count, 75 );
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.facilitiesCollectionView) {
        
        if ([self.houseObj.shownFacilities[indexPath.row] isKindOfClass:[NSString class]]) {
            
            //show facility modal
            
            [self showFacilities];
            
        }
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = self.image2CollectionView.frame.size.width;
    NSInteger currentPage = self.image2CollectionView.contentOffset.x / pageWidth;
    
    [self.imagesCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    
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
        return self.houseObj.commentsArr.count;
    }
    else{
        return 4;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.commentsTableView) {
        return 80;
    }
    else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    CommentSectionHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CommentSectionView" owner:self options:nil] objectAtIndex:0];
    headerView.rateImg.image = IMG(([NSString stringWithFormat:@"big%f",self.houseObj.roundedRate]));
    headerView.rateCountLabel.text = [NSString stringWithFormat:@"بر اساس %@ رای",self.houseObj.reviewCount];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.commentsTableView) {
        CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCellID" forIndexPath:indexPath];
        CommentObject *commentObj =  self.houseObj.commentsArr[indexPath.row];
        commentCell.titleLabel.attributedText = commentObj.attributeStr;
        
        return commentCell;
    }
    else{
        
        OwnerTableViewCell *ownerDesCell = [tableView dequeueReusableCellWithIdentifier:@"ownerCellID" forIndexPath:indexPath];
        
        ownerDesCell.label.text = self.ownerDesArr[indexPath.row];
        ownerDesCell.img.image = IMG(([NSString stringWithFormat:@"ownerProfile%ld",(long)indexPath.row]));
        return ownerDesCell;
        
    }


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.commentsTableView) {
        return 70;
    }
    else{
        return 60;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.commentsTableView) {
    
        [self showCommentDetails];
    }else
    {
        if (indexPath.row == 0) {
            [self goTodetailWithUrl:self.houseObj.host.hostURL andWithType:@"Profile"];
        }
    }
    
}

#pragma mark - facilities

-(void)showFacilities{

    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FacilitiesViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"facilitiesVCID"];
    
    vc.facilitiesArr = self.houseObj.facilityArr;
    
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

- (IBAction)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - button
- (IBAction)rentButtonClicked:(IranButton *)sender {
    
    [self goToRegister];
}

@end
