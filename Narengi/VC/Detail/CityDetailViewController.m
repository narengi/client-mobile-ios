//
//  CityDetailViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CityDetailViewController.h"
#import "PageCell.h"
#import "AttractionSmallCollectionViewCell.h"
#import "SearchDetailHomeCollectionViewCell.h"

CGFloat const offset_HeaderStop = 40.0;
CGFloat const offset_B_LabelHeader = 95.0;
CGFloat const distance_W_LabelHeader = 35.0;
@interface CityDetailViewController ()

@property (nonatomic,strong) CityObject *cityObject;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIView *parentView;

@property (weak, nonatomic) IBOutlet UILabel              *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel              *housecountStrLabel;
@property (weak, nonatomic) IBOutlet UILabel              *descriptionLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *titleLabel;

@property (weak, nonatomic) IBOutlet HWViewPager      *attractionCollectionView;
@property (weak, nonatomic) IBOutlet HWViewPager      *imageCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *houseCollection;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) CGFloat   headerFade;
@property (nonatomic) NSInteger scrollViewContentHeightsize;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewContentLayoutConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseCollectionHeightConstrain;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceToNav;
@property (weak, nonatomic) IBOutlet UIView *collectionHeaderView;

@property (nonatomic) BOOL isForFisrttime;
@property (nonatomic) CGFloat spaceToNavPreviousValue;

@end

@implementation CityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.containerView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.containerView.layer insertSublayer:gradient atIndex:0];
    
   [self.imageCollectionView registerNib:[UINib nibWithNibName:@"PagerCell" bundle:nil] forCellWithReuseIdentifier:@"pageCellID"];
    self.imageCollectionView.pagingEnabled = YES;
    self.attractionCollectionView.pagingEnabled  = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.navigationView.alpha = 0;
    _headerFade                     = 130.0f;
    
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    [self.houseCollection registerNib:[UINib nibWithNibName:@"SearchDetailHomeCell" bundle:nil] forCellWithReuseIdentifier:@"homeCellID"];
    self.isForFisrttime = YES;
    self.spaceToNavPreviousValue = self.spaceToNav.constant;

}
-(void)viewWillAppear:(BOOL)animated{
    

    [[UIApplication sharedApplication] setStatusBarStyle:self.navigationView.alpha == 1?UIStatusBarStyleDefault:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidLayoutSubviews
{
 
 
    
    self.spaceToNav.constant = self.imageCollectionView.frame.size.height;
    [self.collectionHeaderView layoutIfNeeded];
    
    if (self.spaceToNavPreviousValue != self.spaceToNav.constant ) {
     
        [self.houseCollection layoutIfNeeded];
        self.scrollViewContentHeightsize = self.spaceToNav.constant + 154;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Data

-(void)getData{

    NSString *str = self.url.absoluteString;
    NSString *serviceStr  = [[str componentsSeparatedByString:@"v1/"] objectAtIndex:1];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:serviceStr andWithParametrs:nil andWithBody:nil];

        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            if (!serverRs.hasErro) {
                
                if (serverRs.backData !=nil ) {
                    
                    AroundPlaceObject *obj  = [[[NarengiCore sharedInstance] parsAroudPlacesWith:@[serverRs.backData] andwithType:@"City" andIsDetail:YES] firstObject];
                    self.cityObject = obj.cityObject;
                    
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
    
    [self.attractionCollectionView setTransform:CGAffineTransformMakeScale(-1, 1)];

    self.nameLabel.text = self.cityObject.name;
    self.descriptionLabel.text = self.cityObject.summary;
    self.housecountStrLabel.text = self.cityObject.houseCountText;
    self.titleLabel.text = self.cityObject.name;
    [self.imageCollectionView reloadData];
    [self.attractionCollectionView reloadData];
    [self.houseCollection reloadData];
    
    [self changeContentSize:self.cityObject.houses];

}

#pragma mark -collection delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.attractionCollectionView) {
     
        AttractionSmallCollectionViewCell * attractionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"atractionCellID" forIndexPath:indexPath];
        
        AttractionObject *attractionObj = ((AroundPlaceObject *)[self.cityObject.attractions objectAtIndex:indexPath.row]).attractionObject;

        
        [attractionCell.backImageView sd_setImageWithURL:attractionObj.imageUrls[0] placeholderImage:nil];
        attractionCell.titleLabel.text = attractionObj.name;

        return attractionCell;
        
    }
    else if (collectionView == self.imageCollectionView){
        PageCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCellID" forIndexPath:indexPath];
        [collectionCell.backImageView sd_setImageWithURL:self.cityObject.imageUrls[indexPath.row] placeholderImage:nil];
        
        return collectionCell;
        
    }
    else{
        
        
        HouseObject *houseObj = ((AroundPlaceObject *)[self.cityObject.houses objectAtIndex:indexPath.row]).houseObject;
        
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
    

    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.attractionCollectionView) {
        
        return self.cityObject.attractions.count;
    }
    else if (collectionView == self.imageCollectionView){
        return self.cityObject.imageUrls.count ;
    }
    else{
        return self.cityObject.houses.count;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *) collectionView
                        layout:(UICollectionViewLayout *) collectionViewLayout
        insetForSectionAtIndex:(NSInteger) section {
    
    if (collectionView == self.attractionCollectionView) {
        return UIEdgeInsetsMake(0, 30, 0, 30);
    }
    
    else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    
    if (collectionView == self.attractionCollectionView) {
        return 30;
    }
    else{
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.attractionCollectionView) {
        
        return CGSizeMake(140, 80);
    }
    else if (collectionView == self.imageCollectionView){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.width);
    }
    else{
         return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /8 );
    }

}

#pragma mark - navigation

- (IBAction)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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

@end
