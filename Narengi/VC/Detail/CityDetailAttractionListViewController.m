//
//  CityDetailAttractionListViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 12/31/15.
//  Copyright © 2015 Morteza Hosseinizade. All rights reserved.
//

#import "CityDetailAttractionListViewController.h"
#import "SearchDetailAttractionCollectionViewCell.h"


@interface CityDetailAttractionListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic ) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray          *attractionsArray;

@end

@implementation CityDetailAttractionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initNavigationTitle];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchDetaillAttractionCell" bundle:nil] forCellWithReuseIdentifier:@"attractionCellID"];


    
    [[UINavigationBar appearance] setTranslucent:YES];


    //Get Data For firstTime
    [self addParametrsToURL];
    [self getData];
    [self changeLeftIcontoBack];
    
    [[UINavigationBar appearance] setBarTintColor: [UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"IRANSansMobileFaNum-Medium" size:15.0], NSFontAttributeName,nil]];

    
}
-(void)initNavigationTitle{

    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *titleAtDic = @{NSForegroundColorAttributeName : RGB(85, 85, 85, 1),NSFontAttributeName:[UIFont fontWithName:@"IRANSansMobileFaNum-Medium" size:15.0],NSParagraphStyleAttributeName:paragraphStyle} ;
    
    NSDictionary *subTitleAtDic = @{NSForegroundColorAttributeName : RGB(85, 85, 85, 1) ,NSFontAttributeName:[UIFont fontWithName:@"IRANSansMobileFaNum-Medium" size:10],NSParagraphStyleAttributeName:paragraphStyle} ;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageTitle:@"جاذبه‌های گردشگری" andWithSubTitle:self.cityObj.name WithAttributes:@[titleAtDic,subTitleAtDic] size:CGSizeMake(220, 60)]];
    
    [self.navigationItem setTitleView:imageView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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

#pragma mark - Data
-(void) addParametrsToURL{
    
    self.url =[self fixUrr:self.url withParametrs:@[@{@"name":@"filter[limit]",@"value":@"10"}]];
    
}

-(void)getData{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:self.url.absoluteString andWithParametrs:nil andWithBody:nil andIsFullPath:YES];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            if (!serverRs.hasErro) {
                
                if (serverRs.backData !=nil ) {
                    
                    self.attractionsArray  = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData andwithType:@"Attraction" andIsDetail:YES] ;
                    
                    [self.collectionView reloadData];
                }
                else{
                    //show erro if nedded
                }
            }
        });
    });
    
}




- (UIImage *)imageTitle:(NSString *)tile andWithSubTitle :(NSString *)subTitle WithAttributes:(NSArray *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [tile drawInRect:CGRectMake(0, 10, size.width, size.height) withAttributes:[attributes objectAtIndex:0]];
    [subTitle drawInRect:CGRectMake(0, 33, size.width, size.height) withAttributes:[attributes objectAtIndex:1]];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
