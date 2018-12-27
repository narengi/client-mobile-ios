//
//  PagerCollectionViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 11/12/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "PagerCollectionViewCell.h"

@implementation PagerCollectionViewCell


#pragma mark - CollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCellID" forIndexPath:indexPath];
    
    
    
    return collectionCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.row +1;
}

@end
