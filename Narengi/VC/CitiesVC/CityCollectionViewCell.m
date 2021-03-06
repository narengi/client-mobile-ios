//
//  CityCollectionViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/2/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CityCollectionViewCell.h"
#import "PageCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation CityCollectionViewCell



-(void)awakeFromNib{

    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    CGSize size ;
    if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height)
        
        size = CGSizeMake(([UIScreen mainScreen].bounds.size.width )/2, ([UIScreen mainScreen].bounds.size.width)/2 * 5 /8 );
    else
    {
        
        size =CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /8 );
    }
    self.pages =[[HWViewPager alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) collectionViewLayout:layout];
    self.pages.allowsSelection = YES;
    [self.pages setPagerDelegate:self];

    
    self.pages.showsHorizontalScrollIndicator = NO;
    self.pages.showsVerticalScrollIndicator   = NO;
    self.pages.pagingEnabled                  = YES;
    
    [self.pages setDataSource:self];
    [self.pages setDelegate:self];
    
        [self.pages setPagerDelegate:self];
    [self.pages registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.pages setBackgroundColor:[UIColor whiteColor]];
    
    [self.belowContentView addSubview:self.pages];
    
    [self.pages registerNib:[UINib nibWithNibName:@"PagerCell" bundle:nil] forCellWithReuseIdentifier:@"pageCellID"];
    
    [self bringSubviewToFront:self.titleLabel];
    [self bringSubviewToFront:self.descriptionLabel];
    
    

    self.titleLabel.shadowColor  = kShadowColor1;
    self.titleLabel.shadowOffset = kShadowOffset;
    self.titleLabel.shadowBlur   = kShadowBlur;
    
    

}


#pragma mark - CollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PageCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCellID" forIndexPath:indexPath];
    [collectionCell.backImageView sd_setImageWithURL:self.imageUrls[indexPath.row] placeholderImage:nil];
    
    return collectionCell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageUrls.count ;
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
    
    if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height)
        
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width )/2, ([UIScreen mainScreen].bounds.size.width)/2 * 5 /8 );
    else
    {
        
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /8 );
    }
    
}

-(void)pagerDidSelectedPage:(NSInteger)selectedPage
{
    
}


@end
