//
//  PagerCollectionViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/12/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "PagerCollectionViewCell.h"
#import "PageCell.h"


@interface PagerCollectionViewCell ()<UICollectionViewDataSource>
@end

@implementation PagerCollectionViewCell



#pragma mark - CollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PageCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCellID" forIndexPath:indexPath];
    [collectionCell.backImageView sd_setImageWithURL:[NSURL URLWithString:@"http://149.202.20.233:3500/images/city/Tehran.jpg"]placeholderImage:nil];
    
    return collectionCell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrls.count ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

@end
