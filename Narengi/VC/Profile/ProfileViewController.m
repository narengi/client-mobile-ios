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
#import "HouseCollectionViewCell.h"
#import "PageCell.h"
#import "PagerCollectionViewCell.h"
#import "EditProfileViewController.h"
#import "MBProgressHUD.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView    *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel        *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identityHeightConstant;
@property (weak, nonatomic) IBOutlet UIView *identityView;

@property (weak, nonatomic) IBOutlet UICollectionView *houseCollectionView;

@property (nonatomic) CGFloat   headerFade;
@property (nonatomic) BOOL isShowAllHouseButton  ;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *titleLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseCollectinViewHeight;

@property (nonatomic,strong) HostObject *hostObj;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *signoutButton;
@property (weak, nonatomic) IBOutlet UIButton *setting1Button;
@property (weak, nonatomic) IBOutlet UIButton *signout1Button;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *back1Button;

@property (weak, nonatomic) IBOutlet UIView *beforeLoadView;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *errorView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //register Nibs for Tableviews
    [self registerCollectionCellWithName:@"CitiesCollectionViewCell" andWithId:@"citiesCellID" forCORT:self.houseCollectionView];
    [self.houseCollectionView registerNib:[UINib nibWithNibName:@"HouseCell" bundle:nil] forCellWithReuseIdentifier:@"houseCellID"];

    
    [self.houseCollectionView registerNib:[UINib nibWithNibName:@"AllHousesCell" bundle:nil] forCellWithReuseIdentifier:@"seeAllHousesCellID"];
    
    
    
    [self.houseCollectionView  registerNib:[CityDetailHouseCollectionReusableView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cityDetailHouseCollectionRV"];
    
    
    //scrollView delegate
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    _headerFade                     = ([UIScreen mainScreen].bounds.size.width/2) -50;
    self.navigationView.alpha = 0;

    
    [self getData];
    
    
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleClickOnCollectionView:)];
    lpgr.delegate = self;
    [self.houseCollectionView addGestureRecognizer:lpgr];
    
    if (self.isModal) {
        [self.backButton  setImage:IMG(@"CloseBtnShadow") forState:UIControlStateNormal];
        [self.back1Button setImage:IMG(@"CloseBtnOrange") forState:UIControlStateNormal];
    }
    self.houseCollectionView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.navigationView.alpha == 1?UIStatusBarStyleDefault:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
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
        
        self.backButton.alpha = 1;
        self.signoutButton.alpha = 1;
        self.settingButton.alpha = 1;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.navigationView.alpha = 1;
            self.backButton.alpha = 0;
            self.signoutButton.alpha = 0;
            self.settingButton.alpha = 0;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
        }];
    }
    else if(scrollOffset < _headerFade &&  self.navigationView.alpha == 1.0){ //make the header disappear
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.navigationView.alpha = 0;
            self.backButton.alpha = 1;
            self.signoutButton.alpha = 1;
            self.settingButton.alpha = 1;
            
        } completion: ^(BOOL finished) {
            
            self.navigationView.hidden = YES;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
        }];
    }
    
}

#pragma mark - Data


-(void)getData{
    
    self.errorView.hidden  = YES;
    
    if(![Reachability reachabilityForInternetConnection].isReachable){
        
        [self showErrorButtonWithMessage:@"اتصال اینترنت را بررسی کنید"];
    }
    else{
        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud setUserInteractionEnabled:NO];
        [hud showAnimated:YES];
        hud.contentColor = RGB(252, 61, 0, 1);
        hud.label.text = @"در حال دریافت اطلاعات";
        hud.label.font = [UIFont fontWithName:@"IRANSansMobileFaNum" size:15];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
            
            ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:[self.urlStr addBaseUrl] andWithParametrs:nil andWithBody:nil andIsFullPath:YES];
            
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                if (!serverRs.hasErro) {
                    
                    if (serverRs.backData !=nil ) {
                        
                        self.hostObj  = [[NarengiCore sharedInstance] parsHost:serverRs.backData isDetail:YES];
                        if (self.hostObj.houseArr. count > 2) {
                            
                            AroundPlaceObject *around = [[AroundPlaceObject alloc] init];
                            HouseObject *house = [[HouseObject alloc] init];
                            house.isOnlyButton = YES;
                            around.houseObject = house;
                            
                            NSMutableArray *muarr = [[NSMutableArray alloc] initWithArray:self.hostObj.houseArr];
                            
                            [muarr addObject:around];
                            
                            self.hostObj.houseArr = [muarr copy];
                        }
                        
                        [self setDataForView];
                    }
                    else{
                        [self showErrorButtonWithMessage:@"اشکال در ارتباط"];
                    }
                }
                else{
                
                    [self showErrorButtonWithMessage:@"اشکال در ارتباط"];

                }
                
                [hud hideAnimated:YES];

            });
        });
    }
    
}

-(void)showErrorButtonWithMessage:(NSString *)meesage{
    
    self.errorView.hidden  = NO;
    self.messageLabel.text = meesage;
    
}

-(void)setDataForView{
    
    
    if (!self.isShowAllHouseButton) {
        
        self.beforeLoadView.alpha = 1;
        
        [UIView animateWithDuration:0.5 animations:^(void) {
            
            self.beforeLoadView.alpha = 0;
            
        }
                         completion:^(BOOL finished){
                         }];
    }
    
    
    self.nameLabel.text        = self.hostObj.displayName;
    self.cityNameLabel.text    = self.hostObj.locationText;
    self.titleLabel.text       = self.hostObj.displayName;
    
    self.descriptionLabel.text = self.hostObj.descriptionStr;
    

    [self.avatarImg sd_setImageWithURL:self.hostObj.imageUrl placeholderImage:nil];
    self.avatarImg.layer.masksToBounds = YES;
    
        
    [self.houseCollectionView reloadData];
    
    
    self.identityHeightConstant = 0;
    [self.identityView layoutIfNeeded];
    
    if (self.isShowAllHouseButton) {
        
       self.houseCollectinViewHeight.constant = ((([UIScreen mainScreen].bounds.size.width) * 5 /8) * self.hostObj.houseArr.count) + 30 ;
    }
    else{
        
        self.houseCollectinViewHeight.constant = ((([UIScreen mainScreen].bounds.size.width) * 5 /8) * (self.hostObj.houseArr.count > 2 ? self.hostObj.houseArr.count - 1 : self.hostObj.houseArr.count ))  + (self.hostObj.houseArr.count > 2 ? 40 : 0) + 30 ;
        
    }

    
    if (self.houseCollectinViewHeight.constant < ([UIScreen mainScreen].bounds.size.height)) {
        
        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    
    [self.conView layoutIfNeeded];
    
    
    UserObject *userObject = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];
    
    if (![userObject.ID isEqualToString:self.hostObj.ID]) {
        
        self.settingButton.hidden  = YES;
        self.setting1Button.hidden = YES;
        self.signoutButton.hidden  = YES;
        self.signout1Button.hidden = YES;
    }
    
    
    self.scrollView.alwaysBounceVertical = YES;
}


#pragma mark -collection delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.hostObj.houseArr.count > 0) {
        
        AroundPlaceObject *aroundObj = self.hostObj.houseArr[indexPath.row];
        
        if (aroundObj.houseObject.isOnlyButton) {
          
            UICollectionViewCell *seeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"seeAllHousesCellID"  forIndexPath:indexPath];
            
            return seeCell;
        }
        else{
            HouseCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"houseCellID"  forIndexPath:indexPath];
            
            NSString *str = @"";
            str = [str stringByAppendingString:aroundObj.houseObject.cost == nil ? @"" : aroundObj.houseObject.cost];
            str = [str stringByAppendingString:@"     "];
            
            pagerCell.priceLabel.text       = str;
            pagerCell.descriptionLabel.text = aroundObj.houseObject.summary;
            pagerCell.titleLabel.text       = aroundObj.houseObject.name;
            pagerCell.featuresLabel.text    = aroundObj.houseObject.featureSummray;
            
            pagerCell.imageUrls       = aroundObj.houseObject.imageUrls;
            [pagerCell.pages reloadData];
            
            return pagerCell;
        }
    }
    else{
        
        HouseCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"houseCellID"  forIndexPath:indexPath];
        return pagerCell;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

    return self.hostObj.houseArr.count;
    
}


-(void)handleSingleClickOnCollectionView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(self.hostObj.houseArr.count > 0){
        
        CGPoint p = [gestureRecognizer locationInView:self.houseCollectionView];
        NSIndexPath *indexPath = [self.houseCollectionView indexPathForItemAtPoint:p];
        
        AroundPlaceObject *aroundObj = self.hostObj.houseArr[indexPath.row];
        
        if (aroundObj.houseObject.isOnlyButton) {
           
            [self getAllHouses];
        }
        else{
            [self goToDetailWithArroundObject:aroundObj];
        }
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
    

    AroundPlaceObject *aroundObj = self.hostObj.houseArr[indexPath.row];
    
    if (aroundObj.houseObject.isOnlyButton) {
        
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
    }
    else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /8 );
    }
    
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0., 30);

    
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
    
    if (self.isModal) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    }
    
}

- (IBAction)exitButtonClicked:(UIButton *)sender {
    
    [self showExitAlert];
}
- (IBAction)settingButtonclciked:(id)sender {
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfileViewController *destinationVC = [storyboard instantiateViewControllerWithIdentifier:@"editProfileVCID"];
    
    [self presentViewController:destinationVC animated:YES completion:nil];
    
}

#pragma mark - all houses

-(void)getAllHouses{


    REACHABILITY
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud setUserInteractionEnabled:NO];
    [hud showAnimated:YES];
    hud.contentColor = RGB(252, 61, 0, 1);
    hud.label.text = @"در حال دریافت اطلاعات";
    hud.label.font = [UIFont fontWithName:@"IRANSansMobileFaNum" size:15];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:[NSString stringWithFormat:@"accounts/%@/houses",self.hostObj.ID] andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (!serverRs.hasErro) {
                
                if (serverRs.backData !=nil ) {
                    
                    self.hostObj.houseArr  = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData andwithType:@"House" andIsDetail:YES];
                    
                    self.isShowAllHouseButton = YES;
                    [self setDataForView];
                }
                else{
                   // [self showErrorButtonWithMessage:@"اشکال در ارتباط"];
                }
            }
            else{
                
                //[self showErrorButtonWithMessage:@"اشکال در ارتباط"];
                
            }
            
            [hud hideAnimated:YES];
            
        });
    });
}


-(void)showExitAlert{

    UIAlertController *exitAlert = [UIAlertController alertControllerWithTitle:@"حساب کاربری"
                                                                       message: @"آیا از خروج اطمینان دارید؟"
                                                                preferredStyle:UIAlertControllerStyleAlert                   ];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"بله"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             //erase all data user
                             [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"fuckingLoginedOrNOT"];
                             [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userObject"];
                             
                             [exitAlert dismissViewControllerAnimated:YES completion:nil];
                             
                             if (self.isModal) {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }
                             else{
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                             }
                             
                             
                             
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"خیر"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [exitAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [exitAlert addAction: ok];
    [exitAlert addAction: cancel];
    
    [self presentViewController:exitAlert animated:YES completion:nil];
}
- (IBAction)retyButtonClicked:(UIButton *)sender {
    
    [self getData];
}

@end
