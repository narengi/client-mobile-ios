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
@property (nonatomic,strong) NSArray *aroundPArr;
@property (nonatomic) NSInteger curentRequestcount;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property UIRefreshControl *refreshControl;


@end
@implementation CitiesViewController


-(void)viewDidLoad{

    
    //Register for nobfile
    
    self.title = @"موقعیت جغرافیایی";

    [self registerCollectionCellWithName:@"CitiesCollectionViewCell" andWithId:@"citiesCellID" forCORT:self.collectionView];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellWithReuseIdentifier:@"cityCellID"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"AttractionCell" bundle:nil] forCellWithReuseIdentifier:@"attractionCellID"];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HouseCell" bundle:nil] forCellWithReuseIdentifier:@"houseCellID"];

   
    [self initSearchcontainerView];
    
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars     = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleClickOnCollectionView:)];
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
    
    
    [self addPullToRefresh];
    [self getData];
    
    [SDWebImageDownloader.sharedDownloader setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];

}

-(void)addPullToRefresh{

    self.collectionView.alwaysBounceVertical = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.refreshControl = [[UIRefreshControl alloc]
                           init];
    [self.refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    
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

-(void)initSearchcontainerView{

    self.searchContainerView.layer.cornerRadius  = 15;
    self.searchContainerView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.searchContainerView addGestureRecognizer:singleFingerTap];
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

    
    AroundPlaceObject *aroundObj = self.aroundPArr[indexPath.row];
   
//    
//    if ([aroundObj.type isEqualToString:@"House"]) {
    
        HouseCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"houseCellID"
                                                                                       forIndexPath:indexPath];
        
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
//    }
//    
//    else if ([aroundObj.type isEqualToString:@"Attraction"]) {
//        
//        AttractionCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attractionCellID"
//                                                                                       forIndexPath:indexPath];
//        
//        pagerCell.titleLabel.text       = aroundObj.attractionObject.name;
//        pagerCell.cityLabel.text        = aroundObj.attractionObject.cityName;
//        pagerCell.descriptionLabel.text = aroundObj.attractionObject.aroundHousesText;
//        
//        pagerCell.imageUrls = aroundObj.attractionObject.imageUrls;
//        [pagerCell.pages reloadData];
//        
//        return pagerCell;
//    }
//    
//    else  {
//        
//        CityCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cityCellID"
//                                                                                       forIndexPath:indexPath];
//        pagerCell.titleLabel.text       = aroundObj.cityObject.name;
//        pagerCell.descriptionLabel.text = aroundObj.cityObject.houseCountText;
//        
//        pagerCell.imageUrls       = aroundObj.cityObject.imageUrls;
//        
//        [pagerCell.pages reloadData];
//        
//        return pagerCell;
//    }
 
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


-(void)getData{

    REACHABILITY
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:SEARCHSERVICE andWithParametrs:@[@"filter[limit]=40",@"filter[skip]=0"] andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (!serverRs.hasErro) {
                if (serverRs.backData !=nil ) {
                   
                    self.aroundPArr = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData andwithType:nil andIsDetail:NO];
                    
                    [UIView transitionWithView:self.collectionView
                                      duration:0.35f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^(void)
                     {
                         [self.collectionView reloadData];
                     }
                                    completion:nil];
                    
                }
                else{
                }
                
                [self.refreshControl endRefreshing];

                
            }
        });
    });
    
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
