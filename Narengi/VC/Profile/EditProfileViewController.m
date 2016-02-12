//
//  EditProfileViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/11/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@property (weak, nonatomic) IBOutlet UIView       *nameTextFieldContainerView;
@property (weak, nonatomic) IBOutlet UITextField  *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField  *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton     *maleButton;
@property (weak, nonatomic) IBOutlet UIButton     *womenButton;
@property (weak, nonatomic) IBOutlet UILabel      *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIImageView  *avatarImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton     *addAvatarButton;
@property (weak, nonatomic) IBOutlet UIView *emailContainerView;
@property (weak, nonatomic) IBOutlet UIView *phoneContainerView;
@property (weak, nonatomic) IBOutlet UIView *genderContainerView;
@property (weak, nonatomic) IBOutlet UIView *birthDayContainerView;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *emailValidationStateLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *phoneValidationStateLabel;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    //scrollView delegate
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpView{
    
    [self.nameTextFieldContainerView setBorderWithColor:RGB(235, 235, 235, 1) andWithWidth:1 withCornerRadius:2];
    
    [self.emailContainerView setBorderWithColor:RGB(90, 90, 90, 1) andWithWidth:1 withCornerRadius:2];
    [self.phoneContainerView setBorderWithColor:RGB(90, 90, 90, 1) andWithWidth:1 withCornerRadius:2];
    
    [self.genderContainerView setBorderWithColor:RGB(235, 235, 235, 1) andWithWidth:1 withCornerRadius:2];
    [self.birthDayContainerView setBorderWithColor:RGB(235, 235, 235, 1) andWithWidth:1 withCornerRadius:2];
    
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


- (IBAction)saveButtonClicked:(UIButton *)sender {
    
}
- (IBAction)dismissButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
