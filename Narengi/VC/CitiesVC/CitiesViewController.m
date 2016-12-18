//
//  CitiesViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/2/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CitiesViewController.h"
#import "REFrostedViewController.h"
#import "CitiesCollectionViewCell.h"
#import "PageCell.h"
#import "PagerCollectionViewCell.h"
#import "CityCollectionViewCell.h"
#import "MainHomeCollectionViewCell.h"
#import "AttractionCollectionViewCell.h"
#import "ModalAnimator.h"
#import "SearchViewController.h"
#import "HouseCollectionViewCell.h"
#import "MapViewController.h"


@interface CitiesViewController()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *aroundPArr;
@property (nonatomic) NSInteger curentRequestcount;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property UIRefreshControl *refreshControl;
@property NSInteger skipCount;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong) NSString *termrStr;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


@end
@implementation CitiesViewController


-(void)viewDidLoad{

    
    //Register for nobfile
    
    self.title = @"موقعیت جغرافیایی";

    [self registerCollectionCellWithName:@"CitiesCollectionViewCell" andWithId:@"citiesCellID" forCORT:self.collectionView];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellWithReuseIdentifier:@"cityCellID"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"AttractionCell" bundle:nil] forCellWithReuseIdentifier:@"attractionCellID"];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HouseCell" bundle:nil] forCellWithReuseIdentifier:@"houseCellID"];

    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars     = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleClickOnCollectionView:)];
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
    
    
    [self addPullToRefresh];
    [self getDataForFirstTime];
    
    [SDWebImageDownloader.sharedDownloader setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    
    [self.searchTextField addTarget:self
              action:@selector(textFieldDidChange:)
    forControlEvents:UIControlEventEditingChanged];
    
    
    [self.searchTextField addTarget:self
                             action:@selector(resignFirstResponder:)
        forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;


}

-(void)addPullToRefresh{

    self.collectionView.alwaysBounceVertical = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.refreshControl = [[UIRefreshControl alloc]
                           init];
    [self.refreshControl addTarget:self action:@selector(getDataForFirstTime) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor darkGrayColor]];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)handleSingleClickOnCollectionView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(self.aroundPArr.count > 0){
        
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        
        AroundPlaceObject *aroundObj = self.aroundPArr[indexPath.row];
        
        [self goToDetailWithArroundObject:aroundObj];
    }
}



-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    
    UIStoryboard *storyboard = self.storyboard;
    UINavigationController *searchVc = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"searchNavVCID"];
    
    searchVc.modalPresentationStyle = UIModalPresentationCustom;
    searchVc.transitioningDelegate = self;
    
    searchVc.providesPresentationContextTransitionStyle = YES;
    searchVc.definesPresentationContext = YES;
    
    searchVc.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = self.view.bounds;
    [searchVc.view insertSubview:beView atIndex:0];
    
    [self presentViewController:searchVc animated:YES completion:nil];
    
    
}
- (IBAction)menuButtonClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];

    
    
}

#pragma mark - textfield

-(void)textFieldDidChange:(UITextField *)sender{

    if (sender.text.length == 0) {
        
        self.termrStr = sender.text;
        [self getDataForFirstTime];
    }
    
}


-(void)resignFirstResponder:(UITextField *)sender{

    self.termrStr = sender.text;
    [self getDataForFirstTime];
    
    [sender resignFirstResponder];
}



#pragma mark - collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.aroundPArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (self.aroundPArr.count > 0) {
        AroundPlaceObject *aroundObj = self.aroundPArr[indexPath.row];
        
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
    else{
        
        HouseCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"houseCellID"  forIndexPath:indexPath];
        return pagerCell;
    }

 
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height)
        
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width )/2, ([UIScreen mainScreen].bounds.size.width)/2  * 5 /8 );
    else
    {
        
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /8 );
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *) collectionView
                        layout:(UICollectionViewLayout *) collectionViewLayout
        insetForSectionAtIndex:(NSInteger) section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    
    return 0;
}

#pragma mark - Orientation
- (void)orientationChanged:(NSNotification*)note
{
    [self.collectionView reloadData];
    
}



#pragma mark - data

-(void)getDataForFirstTime{

    self.aroundPArr = [[NSMutableArray alloc] init];
    self.skipCount = 1;
    [self getDataForFirstTime:YES];
}

-(void)getDataForFirstTime:(BOOL)firstTime{

    NSArray *parametrs = @[@"perpage=25",[NSString stringWithFormat:@"page=%ld",(long)self.skipCount],[NSString stringWithFormat: @"term=%@",self.termrStr == nil ? @"" : self.termrStr]];
    
    REACHABILITY
    
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:SEARCHSERVICE andWithParametrs:parametrs andWithBody:nil andIsFullPath:NO];
        
        self.curentRequestcount++;
        dispatch_async(dispatch_get_main_queue(),^{
            
            self.curentRequestcount--;
            
            if (self.curentRequestcount == 0 ) {
                
                if (!serverRs.hasErro) {
                    if (serverRs.backData !=nil ) {
                        
                        NSArray *arr = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData andwithType:nil andIsDetail:NO];
                        if (arr.count > 0) {
                            
                            if (firstTime ){
                                [self addLoadMore];
                                [self.aroundPArr removeAllObjects];

                            }
                            
                            if ( arr.count < 25)
                                [self.collectionView .mj_footer removeFromSuperview];
                            
                            [self.aroundPArr addObjectsFromArray:arr];

                            
                            
                        }
                        else{
                            [self.collectionView .mj_footer removeFromSuperview];
                        }
                        
                        self.skipCount ++;
                        
                        
                    }
                    else{
                    }
                    
                }
            }
            
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            [self.collectionView.mj_footer endRefreshing];
            [self.refreshControl endRefreshing];
            [self.collectionView reloadData];

        });
    });
    
}
#pragma mark - load more

-(void)addLoadMore{
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(insertRowAtBottom )];
    
}

-(void)insertRowAtBottom{
    
    [self getDataForFirstTime:NO];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"goToDetail"]) {
        

    }
    
    
}

#pragma mark - Transition


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return [[ModalAnimator alloc] initWithShow:YES];
    
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [[ModalAnimator alloc] initWithShow:NO];
    
}


#pragma mark -map

- (IBAction)mapButtonClicked:(UIButton *)sender {
    
    
    UIStoryboard *mapStory = [UIStoryboard storyboardWithName:@"Maps" bundle:nil];
    MapViewController *mapVC = [mapStory instantiateViewControllerWithIdentifier:@"mapVCID"];
    
    [self.navigationController pushViewController:mapVC animated:YES];
}

@end
