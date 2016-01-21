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
#import "SearchDetailHomeCollectionViewCell.h"

@interface SearchDetailViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSInteger curentRequestcount;

@end

@implementation SearchDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initSearchBar];
    [self changeRightIcontoMap];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchDetailCityCell" bundle:nil] forCellWithReuseIdentifier:@"cityCellID"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchDetaillAttractionCell" bundle:nil] forCellWithReuseIdentifier:@"attractionCellID"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchDetailHomeCell" bundle:nil] forCellWithReuseIdentifier:@"homeCellID"];
    
    [self reloadCollctionWithanimation];
    
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self changeLeftIcontoBack];
    
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleClickOnCollectionView:)];
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
    [self serachWithTerm];
    
    
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
    
    [self goTodetailWithUrl:aroundObj.urlStr andWithType:aroundObj.type];
    
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
    
    if ([aroundObj.type isEqualToString:@"House"]) {
        SearchDetailHomeCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCellID" forIndexPath:indexPath];
        
        NSString *str = @"";
        str = [str stringByAppendingString:aroundObj.houseObject.cost];
        str = [str stringByAppendingString:@"   "];
        
        pagerCell.priceLabel.text       = str;
        pagerCell.descriptionLabel.text = aroundObj.houseObject.featureSummray;
        pagerCell.titleLabel.text       = aroundObj.houseObject.name;
        [pagerCell.coverImg sd_setImageWithURL:aroundObj.houseObject.host.imageUrl placeholderImage:nil];
        pagerCell.priceLabel.layer.cornerRadius = 10;
        pagerCell.priceLabel.layer.masksToBounds = YES;
        
        pagerCell.imageUrls       = aroundObj.houseObject.imageUrls;
        [pagerCell.pages reloadData];
        pagerCell.rateImg.image = IMG(([NSString stringWithFormat:@"%f",aroundObj.houseObject.roundedRate]));
        
        return pagerCell;

    }
    else if ([aroundObj.type isEqualToString:@"Attraction"]) {
        SearchDetailAttractionCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attractionCellID" forIndexPath:indexPath];

        pagerCell.titleLabel.text       = aroundObj.attractionObject.name;
        pagerCell.descriptionLabel.text = aroundObj.attractionObject.aroundHousesText;
        
        pagerCell.imageUrls = aroundObj.attractionObject.imageUrls;
        [pagerCell.pages reloadData];
       return  pagerCell;

    }
    
    else  {
        
        SearchDetailCityCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cityCellID" forIndexPath:indexPath];
        
        
        NSString *str = @"";
        str = [str stringByAppendingString:aroundObj.cityObject.houseCountText];
        str = [str stringByAppendingString:@"     "];
        
        pagerCell.nameLabel.text       = aroundObj.cityObject.name;
        pagerCell.residentCountLabel.text = str;
        
        pagerCell.imageUrls       = aroundObj.cityObject.imageUrls;
        pagerCell.desciptionLabel.text = aroundObj.cityObject.summary;
        
        [pagerCell.pages reloadData];
        
        return  pagerCell;

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


#pragma mark -search

-(void)serachWithTerm{

    [self getDataWithText];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    self.termrStr = searchText;
    [self getDataWithText];
}

-(void)getDataWithText{

    REACHABILITY
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:[NSString stringWithFormat: @"search?term=%@&filter[limit]=20&filter[skip]=0",self.termrStr ] andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        self.curentRequestcount++;
        dispatch_async(dispatch_get_main_queue(),^{
            
            self.curentRequestcount--;
            self.aroundPArr = @[];
            if (self.curentRequestcount == 0 ) {
                
                if (!serverRs.hasErro) {
                    
                    if (serverRs.backData !=nil ) {
                        
                        self.aroundPArr = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData andwithType:nil andIsDetail:NO];
                        [self reloadCollctionWithanimation];
                        
                    }
                    else{
                        //show erro if nedded
                    }
                }
                
            }
        });
    });
}



@end
