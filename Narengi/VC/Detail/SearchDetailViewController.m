//
//  SearchDetailViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "SearchDetailAttractionCollectionViewCell.h"
#import "SearchDetailCityCollectionViewCell.h"
#import "HouseCollectionViewCell.h"

#import "SearchDetailHomeCollectionViewCell.h"

@interface SearchDetailViewController ()<HouseCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSInteger curentRequestcount;
@property NSInteger skipCount;
@property UIRefreshControl *refreshControl;


@end

@implementation SearchDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initSearchBar];
   // [self changeRightIcontoMap];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HouseCell" bundle:nil] forCellWithReuseIdentifier:@"houseCellID"];

    
    [self reloadCollctionWithanimation];
    
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self changeLeftIcontoBack];
    
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleClickOnCollectionView:)];
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
    [self getDataForFirstTime];
    
    
}

-(void)addPullToRefresh{
    
    self.collectionView.alwaysBounceVertical = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.refreshControl = [[UIRefreshControl alloc]
                           init];
    [self.refreshControl addTarget:self action:@selector(getDataForFirstTime) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


-(void)handleSingleClickOnCollectionView:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    AroundPlaceObject *aroundObj = self.aroundPArr[indexPath.row];
    
    [self goToDetailWithArroundObject:aroundObj];
    
}
-(void)initSearchBar{


    UISearchBar *searchbar =[[UISearchBar alloc] initWithFrame:CGRectMake(-10, 0, 120, 30)];
    self.navigationItem.titleView = searchbar;
    searchbar.delegate = self;
    
    searchbar.layer.cornerRadius = 20;
    searchbar.searchBarStyle = UISearchBarStyleMinimal;
    searchbar.tintColor = [UIColor redColor];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextAlignment:NSTextAlignmentRight];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

-(void)delegateTouchAvatar:(SearchDetailHomeCollectionViewCell *)cell
{
   // [self goTodetailWithUrl:cell.hostUrl andWithType:@"Profile"];
}





#pragma mark -search


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    self.termrStr = searchText;
    [self getDataForFirstTime];
}

-(void)getDataForFirstTime{
    
    self.aroundPArr = [[NSMutableArray alloc] init];
    self.skipCount = 1;
    [self getDataForFirstTime:YES];
}

-(void)getDataForFirstTime:(BOOL)firstTime{

    NSArray *parametrs = @[@"perpage=25",[NSString stringWithFormat:@"page=%ld",(long)self.skipCount],[NSString stringWithFormat: @"term=%@",self.termrStr]];

    REACHABILITY
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
                            
                            [self.aroundPArr addObjectsFromArray:arr];
                            
                            if (firstTime)
                                [self addLoadMore];
                            
                            
                        }
                        else{
                            [self.collectionView .mj_footer removeFromSuperview];
                        }
                        
                        [self reloadCollctionWithanimation];
                     
                        
                        self.skipCount ++;
                    }
                    else{
                        //show erro if nedded
                    }
                }
                
                
                [self.collectionView.mj_footer endRefreshing];
                [self.refreshControl endRefreshing];
                [self.collectionView reloadData];
                
            }
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


-(void)reloadCollctionWithanimation{
    
    [UIView transitionWithView:self.collectionView
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void)
     {
         [self.collectionView reloadData];
     }
                    completion:nil];
    
}

@end
