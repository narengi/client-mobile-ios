//
//  SearchDetailCityCollectionViewCell.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/10/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "SearchDetailCityCollectionViewCell.h"

@implementation SearchDetailCityCollectionViewCell


-(void)awakeFromNib{
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    CGSize size ;
    if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height)
        
        size = CGSizeMake((([UIScreen mainScreen].bounds.size.width )/2)-16,  (([UIScreen mainScreen].bounds.size.width)/2 * 5 /8 )-26);
    else
    {
        
        size =CGSizeMake([UIScreen mainScreen].bounds.size.width -16, ( ([UIScreen mainScreen].bounds.size.width) * 5 /8 )-26);
    }
    self.pages =[[HWViewPager alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) collectionViewLayout:layout];
    
    self.pages.showsHorizontalScrollIndicator = NO;
    self.pages.showsVerticalScrollIndicator   = NO;
    self.pages.pagingEnabled                  = YES;
    
    [self.pages setDataSource:self];
    [self.pages setDelegate:self];
    
    [self.pages registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.pages setBackgroundColor:[UIColor whiteColor]];
    
    [self.containerView addSubview:self.pages];
    
    [self.pages registerNib:[UINib nibWithNibName:@"PagerCell" bundle:nil] forCellWithReuseIdentifier:@"pageCellID"];
    
    self.residentCountLabel.layer.cornerRadius  = 5;
    self.residentCountLabel.layer.masksToBounds = YES;
    
    self.containerView.layer.cornerRadius  = 5;
    self.containerView.layer.masksToBounds = YES;
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
        
        return CGSizeMake((([UIScreen mainScreen].bounds.size.width )/2)-16,  (([UIScreen mainScreen].bounds.size.width)/2 * 5 /8 )-26);
    else
    {
        
       return  CGSizeMake([UIScreen mainScreen].bounds.size.width -16, ( ([UIScreen mainScreen].bounds.size.width) * 5 /8 )-26);
    }

    
}
@end
