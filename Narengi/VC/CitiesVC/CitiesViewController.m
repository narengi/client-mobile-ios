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

@interface CitiesViewController()
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *nameArr;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong) NSArray *resultArr;
@property (nonatomic,strong) NSArray *allresults;

@end
@implementation CitiesViewController


-(void)viewDidLoad{

    [self registerCollectionCellWithName:@"CitiesCollectionViewCell" andWithId:@"citiesCellID" forCORT:self.collectionView];
    self.nameArr = @[@"Abadan",@"Esfehan",@"Tehran",@"Tabriz"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.searchTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    self.allresults = [[NSArray alloc]initWithArray:[self allCountries]];
    [self setUpAutocompleteTable];
    
    [self getData];

    
}
- (IBAction)menuButtonClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row == 4) {
        
        PagerCollectionViewCell *pagerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pagerCellID" forIndexPath:indexPath];
        pagerCell.row = 5;
        [pagerCell.pages reloadData];
        return pagerCell;
        
    }
    else{
    
        CitiesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"citiesCellID" forIndexPath:indexPath];
        cell.backImg.image = IMG(([NSString stringWithFormat:@"c%ld",(long)indexPath.row+1]) );
        cell.titleLabel.text = self.nameArr[indexPath.row];
        return cell;
    }
    
    
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
    
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
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
    
    cell.enLabel.text =  self.resultArr[indexPath.row] ;
    //cell.enLabel.text =  [[[self.stationsArr objectAtIndex:indexPath.row] enName] uppercaseString];
    
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

    
    
}

- (NSArray *)allCountries
{
    NSArray *countries =
    @[
      @"Abkhazia",
      @"Afghanistan",
      @"Aland",
      @"Albania",
      @"Algeria",
      @"American Samoa",
      @"Andorra",
      @"Angola",
      @"Anguilla",
      @"Antarctica",
      @"Antigua & Barbuda",
      @"Argentina",
      @"Armenia",
      @"Aruba",
      @"Australia",
      @"Austria",
      @"Azerbaijan",
      @"Bahamas",
      @"Bahrain",
      @"Bangladesh",
      @"Barbados",
      @"Belarus",
      @"Belgium",
      @"Belize",
      @"Benin",
      @"Bermuda",
      @"Bhutan",
      @"Bolivia",
      @"Bosnia & Herzegovina",
      @"Botswana",
      @"Brazil",
      @"British Antarctic Territory",
      @"British Virgin Islands",
      @"Brunei",
      @"Bulgaria",
      @"Burkina Faso",
      @"Burundi",
      @"Cambodia",
      @"Cameroon",
      @"Canada",
      @"Cape Verde",
      @"Cayman Islands",
      @"Central African Republic",
      @"Chad",
      @"Chile",
      @"China",
      @"Christmas Island",
      @"Cocos Keeling Islands",
      @"Colombia",
      @"Commonwealth",
      @"Comoros",
      @"Cook Islands",
      @"Costa Rica",
      @"Cote d'Ivoire",
      @"Croatia",
      @"Cuba",
      @"Cyprus",
      @"Czech Republic",
      @"Democratic Republic of the Congo",
      @"Denmark",
      @"Djibouti",
      @"Dominica",
      @"Dominican Republic",
      @"East Timor",
      @"Ecuador",
      @"Egypt",
      @"El Salvador",
      @"England",
      @"Equatorial Guinea",
      @"Eritrea",
      @"Estonia",
      @"Ethiopia",
      @"European Union",
      @"Falkland Islands",
      @"Faroes",
      @"Fiji",
      @"Finland",
      @"France",
      @"Gabon",
      @"Gambia",
      @"Georgia",
      @"Germany",
      @"Ghana",
      @"Gibraltar",
      @"GoSquared",
      @"Greece",
      @"Greenland",
      @"Grenada",
      @"Guam",
      @"Guatemala",
      @"Guernsey",
      @"Guinea Bissau",
      @"Guinea",
      @"Guyana",
      @"Haiti",
      @"Honduras",
      @"Hong Kong",
      @"Hungary",
      @"Iceland",
      @"India",
      @"Indonesia",
      @"Iran",
      @"Iraq",
      @"Ireland",
      @"Isle of Man",
      @"Israel",
      @"Italy",
      @"Jamaica",
      @"Japan",
      @"Jersey",
      @"Jordan",
      @"Kazakhstan",
      @"Kenya",
      @"Kiribati",
      @"Kosovo",
      @"Kuwait",
      @"Kyrgyzstan",
      @"Laos",
      @"Latvia",
      @"Lebanon",
      @"Lesotho",
      @"Liberia",
      @"Libya",
      @"Liechtenstein",
      @"Lithuania",
      @"Luxembourg",
      @"Macau",
      @"Macedonia",
      @"Madagascar",
      @"Malawi",
      @"Malaysia",
      @"Maldives",
      @"Mali",
      @"Malta",
      @"Mars",
      @"Marshall Islands",
      @"Mauritania",
      @"Mauritius",
      @"Mayotte",
      @"Mexico",
      @"Micronesia",
      @"Moldova",
      @"Monaco",
      @"Mongolia",
      @"Montenegro",
      @"Montserrat",
      @"Morocco",
      @"Mozambique",
      @"Myanmar",
      @"Nagorno Karabakh",
      @"Namibia",
      @"NATO",
      @"Nauru",
      @"Nepal",
      @"Netherlands Antilles",
      @"Netherlands",
      @"New Caledonia",
      @"New Zealand",
      @"Nicaragua",
      @"Niger",
      @"Nigeria",
      @"Niue",
      @"Norfolk Island",
      @"North Korea",
      @"Northern Cyprus",
      @"Northern Mariana Islands",
      @"Norway",
      @"Olympics",
      @"Oman",
      @"Pakistan",
      @"Palau",
      @"Palestine",
      @"Panama",
      @"Papua New Guinea",
      @"Paraguay",
      @"Peru",
      @"Philippines",
      @"Pitcairn Islands",
      @"Poland",
      @"Portugal",
      @"Puerto Rico",
      @"Qatar",
      @"Red Cross",
      @"Republic of the Congo",
      @"Romania",
      @"Russia",
      @"Rwanda",
      @"Saint Barthelemy",
      @"Saint Helena",
      @"Saint Kitts & Nevis",
      @"Saint Lucia",
      @"Saint Vincent & the Grenadines",
      @"Samoa",
      @"San Marino",
      @"Sao Tome & Principe",
      @"Saudi Arabia",
      @"Scotland",
      @"Senegal",
      @"Serbia",
      @"Seychelles",
      @"Sierra Leone",
      @"Singapore",
      @"Slovakia",
      @"Slovenia",
      @"Solomon Islands",
      @"Somalia",
      @"Somaliland",
      @"South Africa",
      @"South Georgia & the South Sandwich Islands",
      @"South Korea",
      @"South Ossetia",
      @"South Sudan",
      @"Spain",
      @"Sri Lanka",
      @"Sudan",
      @"Suriname",
      @"Swaziland",
      @"Sweden",
      @"Switzerland",
      @"Syria",
      @"Taiwan",
      @"Tajikistan",
      @"Tanzania",
      @"Thailand",
      @"Togo",
      @"Tonga",
      @"Trinidad & Tobago",
      @"Tunisia",
      @"Turkey",
      @"Turkmenistan",
      @"Turks & Caicos Islands",
      @"Tuvalu",
      @"Uganda",
      @"Ukraine",
      @"United Arab Emirates",
      @"United Kingdom",
      @"United Nations",
      @"United States",
      @"Uruguay",
      @"US Virgin Islands",
      @"Uzbekistan",
      @"Vanuatu",
      @"Vatican City",
      @"Venezuela",
      @"Vietnam",
      @"Wales",
      @"Western Sahara",
      @"Yemen",
      @"Zambia",
      @"Zimbabwe"
      ];
    
    return countries;
}

#pragma mark - textFiled

- (void)textDidChanged:(id)sender
{
    

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.searchTextField.frame.origin.x] forKey:@"PADDING"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.searchTextField.frame.size.width] forKey:@"widthAutoCompleteTable"];
    


    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",self.searchTextField.text];
   self.resultArr =  [self.allresults filteredArrayUsingPredicate:sPredicate];

    
    [resulViewList show];
    [resulViewList reloadListData];
    //self.resultArr = []
    
}





@end
