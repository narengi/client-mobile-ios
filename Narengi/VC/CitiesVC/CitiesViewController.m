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
#import "AutoCompleteTableViewCell.h"
#import "AroundDetailViewController.h"
#import "CityCollectionViewCell.h"
#import "MainHomeCollectionViewCell.h"
#import "AttractionCollectionViewCell.h"
#import "ModalAnimator.h"
#import "SearchViewController.h"

@interface CitiesViewController()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong) NSArray *resultArr;
@property (nonatomic,strong) NSArray *allresults;
@property (nonatomic,strong) NSArray *aroundPArr;
@property (nonatomic) NSInteger curentRequestcount;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;

@end
@implementation CitiesViewController


-(void)viewDidLoad{

    
    //Register for nobfile
    [self registerCollectionCellWithName:@"CitiesCollectionViewCell" andWithId:@"citiesCellID" forCORT:self.collectionView];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellWithReuseIdentifier:@"cityCellID"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AttractionCell" bundle:nil] forCellWithReuseIdentifier:@"attractionCellID"];

   
    [self initSearchcontainerView];
    [self getData];

    
}

-(void)initSearchcontainerView{

    self.searchContainerView.layer.cornerRadius  = 15;
    self.searchContainerView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer{

    
    UIStoryboard *storyboard = self.storyboard;
    SearchViewController *searchVc = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchVCID"];
    
    searchVc.modalPresentationStyle = UIModalPresentationCustom;
    searchVc.transitioningDelegate = self;
    
    searchVc.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = self.view.bounds;
    [searchVc.view insertSubview:beView atIndex:0];
    [self presentViewController:searchVc animated:YES completion:nil];
    
    
}
- (IBAction)menuButtonClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
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
   
    
    if ([aroundObj.type isEqualToString:@"House"]) {
        PagerCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pagerCellID"
                                                                                       forIndexPath:indexPath];
        
        pagerCell.priceLabel.text = aroundObj.houseObject.cost;
        pagerCell.titleLabel.text = aroundObj.houseObject.name;
        pagerCell.owner.text      = aroundObj.houseObject.cityName;
        pagerCell.imageUrls       = aroundObj.houseObject.imageUrls;
        
        [pagerCell.pages reloadData];
        
        return pagerCell;
    }
    
    else if ([aroundObj.type isEqualToString:@"Attraction"]) {
        
        AttractionCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attractionCellID"
                                                                                       forIndexPath:indexPath];
        
        pagerCell.titleLabel.text       = aroundObj.attractionObject.name;
        pagerCell.cityLabel.text        = aroundObj.attractionObject.cityName;
        pagerCell.descriptionLabel.text = aroundObj.attractionObject.aroundHousesText;
        
        pagerCell.imageUrls = aroundObj.attractionObject.imageUrls;
        [pagerCell.pages reloadData];
        
        return pagerCell;
    }
    
    else  {
        
        CityCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cityCellID"
                                                                                       forIndexPath:indexPath];
        pagerCell.titleLabel.text = aroundObj.cityObject.name;
        pagerCell.imageUrls       = aroundObj.cityObject.imageUrls;
        
        [pagerCell.pages reloadData];
        
        return pagerCell;
    }
    

    
   
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // [self performSegueWithIdentifier:@"goToDetail" sender:self.aroundPArr[indexPath.row]];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.searchTextField.frame.size.width] forKey:@"widthAutoCompleteTable"];
    
}



#pragma mark - data


-(void)getData{

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:@"search?filter[limit]=20&filter[skip]=0" andWithParametrs:nil andWithBody:nil];
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (!serverRs.hasErro) {
                if (serverRs.backData !=nil ) {
                   
                    self.aroundPArr = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData];
                    
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
                
            }
        });
    });
    
}






#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"goToDetail"]) {
        
        AroundDetailViewController *aroundDetailVc = segue.destinationViewController;
        aroundDetailVc.aroundObject = sender;
    }
    
    
}

#pragma mark - Transition


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return [[ModalAnimator alloc] initWithShow:YES];
    
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [[ModalAnimator alloc] initWithShow:NO];
    
}





@end
