//
//  CityDetailAttractionListViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/31/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CityDetailAttractionListViewController.h"
#import "SearchDetailAttractionCollectionViewCell.h"

@interface CityDetailAttractionListViewController ()
@property (weak, nonatomic ) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray          *attractionsArray;
@property (nonatomic,strong) NSURL            *url;

@end

@implementation CityDetailAttractionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return self.attractionsArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    AroundPlaceObject *aroundObj = self.attractionsArray[indexPath.row];
    

        SearchDetailAttractionCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attractionCellID" forIndexPath:indexPath];
        
        pagerCell.titleLabel.text       = aroundObj.attractionObject.name;
        pagerCell.descriptionLabel.text = aroundObj.attractionObject.aroundHousesText;
        
        pagerCell.imageUrls = aroundObj.attractionObject.imageUrls;
        [pagerCell.pages reloadData];
        return  pagerCell;

    
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

#pragma mark - data



@end
