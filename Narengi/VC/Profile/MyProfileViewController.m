//
//  MyProfileViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 3/27/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *nameLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *membershipAgeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bioLabelHeight;

@property (nonatomic,strong) UserObject *userObject;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MyProfileViewController


-(void)viewDidLoad

{
    [super viewDidLoad];
    [self addLeftAndRightButton];
 
    
    self.title = @"پروفایل";
    //scrollView delegate
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self setupView];

    [self getData];
}

-(void)setupView{
    
    self.userObject = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];

    self.nameLabel.text = [[self.userObject.fisrtName stringByAppendingString:@" "] stringByAppendingString:self.userObject.lastName];
    
    [SDWebImageDownloader.sharedDownloader setValue:[[NarengiCore sharedInstance] makeAuthurizationValue ] forHTTPHeaderField:@"Authorization"];
    
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user-profiles/picture",BASEURL]] placeholderImage:nil options:SDWebImageRefreshCached];
    
    if (self.userObject.bio.length > 0) {
        self.aboutLabel.text = self.userObject.bio;
    }
    else{
       self.aboutLabel.text =@"-";
    }
    if (self.userObject.province.length > 0) {
    
        if (self.userObject.city.length > 0)
            self.cityLabel.text = [NSString stringWithFormat:@"%@، %@",self.userObject.province, self.userObject.city];
        else
            self.cityLabel.text = self.userObject.province;
    }
    else
        self.cityLabel.text = @"-";
    

    
}




#pragma mark - scrollViewDelegate

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context != (__bridge void *)self) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ((object == self.scrollView) && ([keyPath isEqualToString:@"contentOffset"] == YES)) {
        [self scrollViewDidScrollWithOffset:self.scrollView.contentOffset.y];
        return;
    }
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    
    CATransform3D headerTransform = CATransform3DIdentity;
    
    
    if (scrollOffset < 0) {
        
        CGFloat headerScaleFactor = -(scrollOffset) / self.avatarImg.bounds.size.height;
        
        CGFloat headerSizevariation = ((self.avatarImg.bounds.size.height * (1.0 + headerScaleFactor)) - self.avatarImg.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.avatarImg.layer.transform = headerTransform;
        
    }
    
    
    
    
}

-(void)addLeftAndRightButton{

    
    UIButton *editButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [editButton setImage:IMG(@"ResulsOnMap") forState:UIControlStateNormal];
    
    [editButton addTarget:self action:@selector(goToEdit) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    
    UIButton *closeButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [closeButton setImage:IMG(@"CloseIconOrange") forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *closeBarItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItem = closeBarItem;

}

-(void)goToEdit{

    [self performSegueWithIdentifier:@"goToEditProfileFromMyAccount" sender:nil];
}

-(void)closeButton{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)verificationbuttonClicked:(IranButton *)sender {
    
    [self performSegueWithIdentifier:@"goToVerficationRoot" sender:nil];
}
- (IBAction)reservationHistoryClicked:(IranButton *)sender {
}
- (IBAction)commentsHistoryButtonClicked:(IranButton *)sender {
}
- (IBAction)introduceToFriendsButtonClicked:(IranButton *)sender {
}
- (IBAction)extiButtonClicked:(IranButton *)sender {
    
    UIAlertController *exitAlert = [UIAlertController alertControllerWithTitle:@"حساب کاربری"
                                                                               message: @"آیا از خروج اطمینان دارید؟"
                                                                        preferredStyle:UIAlertControllerStyleAlert                   ];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"بله"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             //erase all data user 
                             [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"fuckingLoginedOrNOT"];
                             [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userObject"];
                             
                             [exitAlert dismissViewControllerAnimated:YES completion:nil];
                             [self dismissViewControllerAnimated:YES completion:nil];
                             

                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"خیر"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [exitAlert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [exitAlert addAction: ok];
    [exitAlert addAction: cancel];
    
    [self presentViewController:exitAlert animated:YES completion:nil];
}

#pragma mark - updateUserData

-(void)getData{
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"GET" andWithService: @"user-profiles" andWithParametrs:nil andWithBody:nil andIsFullPath:NO];

        dispatch_async(dispatch_get_main_queue(),^{
            
            if (!response.hasErro && response.backData != nil) {
                UserObject *userObj = [[NarengiCore sharedInstance ] parsUserObject:response.backData];
                [[NSUserDefaults standardUserDefaults] rm_setCustomObject:userObj forKey:@"userObject"];
                
                [self setupView];
            }
            
        });
    });
}

@end
