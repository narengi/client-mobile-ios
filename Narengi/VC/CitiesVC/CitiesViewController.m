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

@interface CitiesViewController()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong) NSArray *resultArr;
@property (nonatomic,strong) NSArray *allresults;
@property (nonatomic,strong) NSArray *aroundPArr;
@property (nonatomic) NSInteger curentRequestcount;

@end
@implementation CitiesViewController


-(void)viewDidLoad{

    
    //Register for nobfile
    [self registerCollectionCellWithName:@"CitiesCollectionViewCell" andWithId:@"citiesCellID" forCORT:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.searchTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self setUpAutocompleteTable];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellWithReuseIdentifier:@"cityCellID"];
    
    [self getData];

    
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
        PagerCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pagerCellID"
                                                                                       forIndexPath:indexPath];
        
        pagerCell.titleLabel.text = aroundObj.attractionObject.name;
        pagerCell.priceLabel.text = @"";
        pagerCell.owner.text      = @"";
        [pagerCell.pages reloadData];
        
        return pagerCell;
    }
    
    else  {
        
        CityCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cityCellID"
                                                                                       forIndexPath:indexPath];
        pagerCell.titleLabel.text = aroundObj.cityObject.name;
      //  pagerCell.priceLabel.text = [NSString stringWithFormat:@"%@ تعداد" ,aroundObj.cityObject.houseCount ];
      //  pagerCell.owner.text      = @"";
        pagerCell.imageUrls       = aroundObj.cityObject.imageUrls;
        [pagerCell.pages reloadData];
        
        [pagerCell bringSubviewToFront:pagerCell.titleLabel];
        [pagerCell bringSubviewToFront:pagerCell.descriptionLabel];
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
        
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width )/2, ([UIScreen mainScreen].bounds.size.width)/2 * 5 /7 );
    else
    {
        
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width) * 5 /7 );
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


#pragma mark - XDPopupListView

-(void)setUpAutocompleteTable{
    
    resulViewList = [[XDPopupListView alloc] initWithBoundView:self.searchTextField dataSource:self delegate:self popupType:XDPopupListViewDropDown];
    
    [resulViewList.tableView  registerNib:[UINib nibWithNibName:@"AutocompleteCell"
                                                        bundle:[NSBundle mainBundle]]
                  forCellReuseIdentifier:@"ddd"];
    

    
    [self.searchTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}
- (CGFloat)itemCellHeight:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)itemCell:(NSIndexPath *)indexPath
{
    if (self.resultArr.count == 0) {
        return nil;
    }
    static NSString *identifier = @"ddd";
    AutoCompleteTableViewCell *cell = [resulViewList.tableView dequeueReusableCellWithIdentifier:identifier] ;
    
    AroundPlaceObject *aroundObj = self.resultArr[indexPath.row];
    
    if ([aroundObj.type isEqualToString:@"House"]) {
        
        cell.enLabel.text = aroundObj.houseObject.name;
    }
    
    else if ([aroundObj.type isEqualToString:@"Attraction"]) {
        
        cell.enLabel.text = aroundObj.attractionObject.name;
    }
    
    else if ([aroundObj.type isEqualToString:@"City"]) {
        
         cell.enLabel.text = aroundObj.cityObject.name;
    }
    
    return cell;
}

- (void)clickedListViewAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (resulViewList.isShowing) {
        
        self.searchTextField.text = [[self.resultArr objectAtIndex:indexPath.row] name];

    }
}

#pragma mark - Keyboard

- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    [resulViewList dismiss];
}



#pragma mark - data


-(void)getData{

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:@"search" andWithParametrs:nil andWithBody:nil];
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (!serverRs.hasErro) {
                if (serverRs.backData !=nil ) {
                   
                    self.aroundPArr = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData];
                    [self.collectionView reloadData];
                }
                else{
                }
                
            }
        });
    });
    
}



#pragma mark - textFiled

- (void)textDidChanged:(id)sender
{
    

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.searchTextField.frame.origin.x] forKey:@"PADDING"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.searchTextField.frame.size.width] forKey:@"widthAutoCompleteTable"];
    

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
       ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService:@"search" andWithParametrs:@[[NSString stringWithFormat:@"term=%@",self.searchTextField.text]] andWithBody:nil];

        self.curentRequestcount++;
        dispatch_async(dispatch_get_main_queue(),^{
            
            self.curentRequestcount--;
            if (self.curentRequestcount == 0) {
                
                if (!serverRs.hasErro) {
                    
                    if (serverRs.backData !=nil ) {
                        
                        self.resultArr = [[NarengiCore sharedInstance] parsAroudPlacesWith:serverRs.backData];

                    }
                    else{
                    }
                }
                
            }
        });
    });


    
    [resulViewList show];
    [resulViewList reloadListData];
    //self.resultArr = []
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    
    return YES;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"goToDetail"]) {
        
        AroundDetailViewController *aroundDetailVc = segue.destinationViewController;
        aroundDetailVc.aroundObject = sender;
    }
    
    
}



@end
