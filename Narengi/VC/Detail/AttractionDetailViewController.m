//
//  AttractionDetailViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "AttractionDetailViewController.h"
#import "PageCell.h"
#import "AttractionSmallCollectionViewCell.h"
#import "SearchDetailHomeCollectionViewCell.h"
#import "CityDetailHouseCollectionReusableView.h"


@interface AttractionDetailViewController ()<HouseCellDelegate>

@property (nonatomic,strong) AttractionObject *attractionObject;

@property (weak, nonatomic  ) IBOutlet UIView *containerView;
@property (weak, nonatomic  ) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIView *parentView;

@property (weak, nonatomic) IBOutlet UILabel              *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel              *housecountStrLabel;
@property (weak, nonatomic) IBOutlet UILabel              *descriptionLabel;
@property (weak, nonatomic) IBOutlet CustomFaMediumFontLabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *titleLabel;
@property (weak, nonatomic) IBOutlet HWViewPager      *imageCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *houseCollection;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) CGFloat   headerFade;
@property (nonatomic) NSInteger scrollViewContentHeightsize;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewContentLayoutConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseCollectionHeightConstrain;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceToNav;

@property (nonatomic) BOOL isForFisrttime;
@property (nonatomic) CGFloat spaceToNavPreviousValue;
@end

@implementation AttractionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars     = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    //GradientLayer
    [self insertGradientToView:self.containerView];
    
    //scrollView delegate
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
    //register Nibs
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"PagerCell" bundle:nil] forCellWithReuseIdentifier:@"pageCellID"];
    
    [self.houseCollection  registerNib:[CityDetailHouseCollectionReusableView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cityDetailHouseCollectionRV"];
    
    self.imageCollectionView.pagingEnabled = YES;
    
    [self.houseCollection registerNib:[UINib nibWithNibName:@"SearchDetailHomeCell" bundle:nil] forCellWithReuseIdentifier:@"homeCellID"];
    
    self.isForFisrttime = YES;
    
    self.navigationView.alpha = 0;
    _headerFade                     = 130.0f;
    self.spaceToNavPreviousValue = self.spaceToNav.constant;
    
    
    //Get Data For firstTime
    [self addParametrsToURL];
    [self getData];
    
    
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleClickOnCollectionView:)];
    lpgr.delegate = self;
    [self.houseCollection addGestureRecognizer:lpgr];
    
}

-(void)handleSingleClickOnCollectionView:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.houseCollection];
    NSIndexPath *indexPath = [self.houseCollection indexPathForItemAtPoint:p];
    
    AroundPlaceObject *aroundObj = self.attractionObject.housesArr[indexPath.row];
    
    [self goToDetailWithArroundObject:aroundObj];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.navigationView.alpha == 1?UIStatusBarStyleDefault:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidLayoutSubviews
{
    
    
    
    self.spaceToNav.constant = self.imageCollectionView.frame.size.height;
    [self.houseCollection layoutIfNeeded];
    if (self.spaceToNavPreviousValue != self.spaceToNav.constant ) {
        
        [self.houseCollection layoutIfNeeded];
        self.scrollViewContentHeightsize = self.spaceToNav.constant+40 ;
        self.spaceToNavPreviousValue = self.spaceToNav.constant;
    }
    
}

-(void)changeContentSize :(NSArray *)arr{
    
    __block NSInteger content = self.scrollViewContentHeightsize;
    __block NSInteger collectionContent;
    [arr enumerateObjectsUsingBlock:^(AroundPlaceObject *obj, NSUInteger idx, BOOL *stop) {
        
        content += ([UIScreen mainScreen].bounds.size.width) * 5 /8;
        collectionContent += ([UIScreen mainScreen].bounds.size.width) * 5 /8;
        
    }];
    
    self.scrollViewContentHeightsize = content;
    self.ViewContentLayoutConstrain.constant = self.scrollViewContentHeightsize;
    [self.parentView layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,self.scrollViewContentHeightsize);
    self.houseCollectionHeightConstrain.constant = collectionContent;
    [self.houseCollection layoutIfNeeded];
    
    self.isForFisrttime = NO;
    
    
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
        
        CGFloat headerScaleFactor = -(scrollOffset) / self.imageCollectionView.bounds.size.height;
        
        CGFloat headerSizevariation = ((self.imageCollectionView.bounds.size.height * (1.0 + headerScaleFactor)) - self.imageCollectionView.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.imageCollectionView.layer.transform = headerTransform;
        
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
    
    self.url =[self fixUrl:self.url withParametrs:@[@{@"name":@"filter[house]",@"value":@"10"}]];
    
}

-(void)getData{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:self.url.absoluteString andWithParametrs:nil andWithBody:nil andIsFullPath:YES];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            if (!serverRs.hasErro) {
                
                if (serverRs.backData !=nil ) {
                    
                    AroundPlaceObject *obj  = [[[NarengiCore sharedInstance] parsAroudPlacesWith:@[serverRs.backData] andwithType:@"Attraction" andIsDetail:YES] firstObject];
                    self.attractionObject = obj.attractionObject;
                    
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
    
    
    self.nameLabel.text = self.attractionObject.name;
    self.descriptionLabel.text = @"این یه جازبه باحال از خیلی وقت پیش که داریم کم کم نابودش میکنیم راحت بشیم.";
    self.housecountStrLabel.text = self.attractionObject.aroundHousesText;
    self.titleLabel.text = self.attractionObject.name;
    [self.imageCollectionView reloadData];
    [self.houseCollection reloadData];
    
    self.cityNameLabel.text  = self.attractionObject.cityName;
    [self changeContentSize:self.attractionObject.housesArr];
    
}

#pragma mark -collection delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

     if (collectionView == self.imageCollectionView){
        PageCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCellID" forIndexPath:indexPath];
        [collectionCell.backImageView sd_setImageWithURL:self.attractionObject.imageUrls[indexPath.row] placeholderImage:nil];
        
        return collectionCell;
        
    }
    else{
        
        
        HouseObject *houseObj = ((AroundPlaceObject *)[self.attractionObject.housesArr objectAtIndex:indexPath.row]).houseObject;
        
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
        
        pagerCell.imageUrls = houseObj.imageUrls;
        pagerCell.hostUrl   = houseObj.host.hostURL;
        pagerCell.delegate  = self;
        
        [pagerCell.pages reloadData];
        pagerCell.rateImg.image = IMG(([NSString stringWithFormat:@"%f",houseObj.roundedRate]));
        
        return pagerCell;
    }
    
    
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

     if (collectionView == self.imageCollectionView){
        return self.attractionObject.imageUrls.count ;
    }
    else{
        return self.attractionObject.housesArr.count;
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
    

     if (collectionView == self.imageCollectionView){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.width);
    }
    else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /8 );
    }
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView ==  self.houseCollection) {
        return CGSizeMake(0., 40);
    }
    else{
        return CGSizeMake(0., 0);
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:@"cityDetailHouseCollectionRV"
                                                                               forIndexPath:indexPath];
    
    
    CityDetailHouseCollectionReusableView* header_view = (CityDetailHouseCollectionReusableView*) cell;
    
    
    
    return header_view;
}


-(void)delegateTouchAvatar:(SearchDetailHomeCollectionViewCell *)cell
{
    //[self goToDetailWithArroundObject:aroundObj];
}

#pragma mark - navigation


- (IBAction)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


#pragma mark -map
- (IBAction)mapButtonClicked:(UIButton *)sender {
    
    [self gotoMapFromCityWithHouses:self.attractionObject.housesArr andWithTitle:self.attractionObject.name];
    
}

@end
