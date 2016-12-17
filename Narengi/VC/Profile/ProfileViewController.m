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

@property (weak, nonatomic) IBOutlet UICollectionView *houseCollectionView;

@property (nonatomic) CGFloat   headerFade;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *titleLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseCollectinViewHeight;

@property (nonatomic,strong) HostObject *hostObj;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //register Nibs for Tableviews
    [self.houseCollectionView registerNib:[UINib nibWithNibName:@"SearchDetailHomeCell" bundle:nil] forCellWithReuseIdentifier:@"homeCellID"];
    [self.houseCollectionView  registerNib:[CityDetailHouseCollectionReusableView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cityDetailHouseCollectionRV"];
    
    
    //scrollView delegate
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    _headerFade                     = [UIScreen mainScreen].bounds.size.width/2;
    self.navigationView.alpha = 0;

    
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.navigationView.alpha == 1?UIStatusBarStyleDefault:UIStatusBarStyleLightContent];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    
    
    if (scrollOffset < 0) {
        
        CGFloat headerScaleFactor = -(scrollOffset) / self.avatarImg.bounds.size.height;
        
        CGFloat headerSizevariation = ((self.avatarImg.bounds.size.height * (1.0 + headerScaleFactor)) - self.avatarImg.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.avatarImg.layer.transform = headerTransform;
        
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


-(void)getData{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:[self.urlStr addBaseUrl] andWithParametrs:nil andWithBody:nil andIsFullPath:YES];
        
        
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
    self.titleLabel.text       = self.hostObj.displayName;

    [self.avatarImg sd_setImageWithURL:self.hostObj.imageUrl placeholderImage:nil];
    self.avatarImg.layer.masksToBounds = YES;
    
        
    [self.houseCollectionView reloadData];
    
    self.houseCollectinViewHeight.constant = ((([UIScreen mainScreen].bounds.size.width) * 5 /8)*self.hostObj.houseArr.count)+(self.hostObj.houseArr.count > 0 ? 40 : 0);;
    
    
    [self.conView layoutIfNeeded];
    
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
    pagerCell.coverImg.alpha        = 0;
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
- (IBAction)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

@end
