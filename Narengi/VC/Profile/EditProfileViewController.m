//
//  EditProfileViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 2/11/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "EditProfileViewController.h"

#import "DZNPhotoPickerController.h"
#import "DZNPhotoEditorViewController.h"
#import "UIImagePickerController+Edit.h"
#import "SelectBirthDayViewController.h"
#import "NSDateFormatter+Persian.h"
#import "PhoneValidateViewController.h"
#import "SelectGenderViewController.h"
#import "SelectProvinceViewController.h"
#import "SelectCityViewController.h"
#import <AFNetworking.h>

@interface EditProfileViewController ()<DZNPhotoPickerControllerDelegate,UIActionSheetDelegate,
UIPopoverControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>

{
    UIPopoverController *_popoverController;
    UIActionSheet *_actionSheet;
    NSDictionary *_photoPayload;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField  *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *lastNameTextField;

@property (weak, nonatomic) IBOutlet UIButton     *addAvatarButton;

@property (weak, nonatomic) IBOutlet UIImageView  *avatarImg;


@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;



@property (weak, nonatomic) IBOutlet UILabel              *birthdayLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *genderLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *provinceLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *cityLabel;


@property (nonatomic,strong) NSDate   *selectedBirthDayDate;

@property (nonatomic,strong) NSString *selectedBirthDayDateStr;
@property (nonatomic,strong) NSString *selectedGender;

@property (nonatomic,strong) UserObject *userObject;
@property ( nonatomic)  BOOL didSelectImg;

@property ( nonatomic)  BOOL fisrtNameValid;
@property ( nonatomic)  BOOL lastNameValid;
@property ( nonatomic)  BOOL didSelectedGender;

@property (nonatomic,strong) NSDictionary *selectedProvince;
@property (nonatomic,strong) NSString *selectedCity;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userObject = [[ NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"userObject"];
    
    //setUpAll necessory 
    [self setUpView];
    
    //scrollView delegate
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];

    
    
    [SDWebImageDownloader.sharedDownloader setValue:[[NarengiCore sharedInstance] makeAuthurizationValue ] forHTTPHeaderField:@"authorization"];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpView{

    self.aboutTextView.font = [UIFont fontWithName:@"IRANSansMobileFaNum" size:13];
    self.aboutTextView.textAlignment = NSTextAlignmentRight;

    if (self.userObject.fisrtName.length > 0)
        self.nameTextField.text = self.userObject.fisrtName;
        
    
    if (self.userObject.lastName.length > 0)
        self.lastNameTextField.text = self.userObject.lastName;
    
    if (self.userObject.bio.length > 0)
        self.aboutTextView.text = self.userObject.bio;
    
    if (self.userObject.city.length > 0)
        self.cityLabel.text = self.userObject.city;
    
    if (self.userObject.province.length > 0)
        self.provinceLabel.text = self.userObject.province;
    
    
    [SDWebImageDownloader.sharedDownloader setValue:[[NarengiCore sharedInstance] makeAuthurizationValue ] forHTTPHeaderField:@"authorization"];
    
    [self.avatarImg sd_setImageWithURL:self.userObject.avatarUrl placeholderImage:IMG(@"nil") options:SDWebImageRefreshCached];
    
    if (self.userObject.birthDate != nil ) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:[[self.userObject.birthDate componentsSeparatedByString:@"T"] firstObject]];
        
        NSDateFormatter *validFormat = [[NSDateFormatter alloc] init];
        [validFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd"];
        
        NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
        dayFormat = [format change];
        [dayFormat setDateFormat:@"EEEE"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat = [format changetoShortFormmat];
        
        
        self.birthdayLabel.text  = [[dateFormat stringFromDate:date] stringByReplacingOccurrencesOfString:@" ه‍.ش." withString:@""];
    }
    
    if (self.userObject.gender != nil) {
        
        if ([self.userObject.gender isEqualToString:@"male"]){
            self.genderLabel.text  = @"مرد";
            self.selectedGender = @"male";
        }
        
        else{
            self.genderLabel.text  = @"زن";
            self.selectedGender = @"female";
        }
    }
    
    [self validateTextFields];
    

}


#pragma mark - textField
- (IBAction)textFieldsChanged:(UITextField *)sender {
    
    [self validateTextFields];
}
- (IBAction)textFieldsBeginEditing:(UITextField *)sender {
    [self validateTextFields];
}
- (IBAction)textFieldsEndEditing:(UITextField *)sender {
    [self validateTextFields];
}

-(void)validateTextFields{
    
    if ([[self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
        self.fisrtNameValid = NO;
    
    else
        self.fisrtNameValid = YES;
    
    if ([[self.lastNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
        self.lastNameValid = NO;
    
    else
        self.lastNameValid = YES;
    
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




#pragma mark - Avatar Picker
- (IBAction)selectAvatarBt:(UIButton *)sender {
    
    [self showImportActionSheet:sender];
}


- (void)showImportActionSheet:(id)sender
{
    _actionSheet = [UIActionSheet new];
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [_actionSheet addButtonWithTitle:NSLocalizedString(@"Take Photo", nil)];
    }
    
    [_actionSheet addButtonWithTitle:NSLocalizedString(@"Choose Photo", nil)];
    
    if (self.didSelectImg) {
        [_actionSheet addButtonWithTitle:NSLocalizedString(@"Delete Photo", nil)];
    }
    
    
    [_actionSheet setCancelButtonIndex:[_actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)]];
    [_actionSheet setDelegate:self];
    [_actionSheet showInView:self.view];
}





- (void)presentPhotoEditor:(id)sender
{
    UIImage *image = _photoPayload[UIImagePickerControllerOriginalImage];
    if (!image) image = self.avatarImg.image;
    
    DZNPhotoEditorViewControllerCropMode cropMode = [_photoPayload[DZNPhotoPickerControllerCropMode] integerValue];
    
    DZNPhotoEditorViewController *editor = [[DZNPhotoEditorViewController alloc] initWithImage:image];
    editor.cropMode = (cropMode != DZNPhotoEditorViewControllerCropModeNone) ? : DZNPhotoEditorViewControllerCropModeSquare;
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:editor];
    
    [editor setAcceptBlock:^(DZNPhotoEditorViewController *editor, NSDictionary *userInfo){
        [self updateImageWithPayload:userInfo];
        [self dismissController:editor];
    }];
    
    [editor setCancelBlock:^(DZNPhotoEditorViewController *editor){
        [self dismissController:editor];
    }];
    
    [self presentController:controller sender:sender];
}

- (void)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType sender:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.navigationBar.tintColor = [UIColor whiteColor];
    
    picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    
    picker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        
        if (picker.cropMode == DZNPhotoEditorViewControllerCropModeNone) {
            [weakSelf handleImagePicker:picker withMediaInfo:info];
        }
    };
    
    picker.cancellationBlock = ^(UIImagePickerController *picker) {
        [weakSelf dismissController:picker];
    };
    
    [self presentController:picker sender:sender];
}

- (void)handleImagePicker:(UIImagePickerController *)picker withMediaInfo:(NSDictionary *)info
{
    [self updateImageWithPayload:info];
    [self dismissController:picker];
}

-(void)photoPickerController:(DZNPhotoPickerController *)picker didFinishPickingPhotoWithInfo:(NSDictionary *)userInfo
{
}
-(void)photoPickerControllerDidCancel:(DZNPhotoPickerController *)picker
{
}
-(void)photoPickerController:(DZNPhotoPickerController *)picker didFailedPickingPhotoWithError:(NSError *)error
{
}
- (void)updateImageWithPayload:(NSDictionary *)payload
{
    _photoPayload = payload;
    
    NSLog(@"OriginalImage : %@", payload[UIImagePickerControllerOriginalImage]);
    NSLog(@"EditedImage : %@", payload[UIImagePickerControllerEditedImage]);
    NSLog(@"MediaType : %@", payload[UIImagePickerControllerMediaType]);
    NSLog(@"CropRect : %@", NSStringFromCGRect([ payload[UIImagePickerControllerCropRect] CGRectValue]));
    NSLog(@"ZoomScale : %f", [ payload[DZNPhotoPickerControllerCropZoomScale] floatValue]);
    
    NSLog(@"CropMode : %@", payload[DZNPhotoPickerControllerCropMode]);
    NSLog(@"PhotoAttributes : %@", payload[DZNPhotoPickerControllerPhotoMetadata]);
    
    UIImage *image = payload[UIImagePickerControllerEditedImage];
    if (!image) image = payload[UIImagePickerControllerOriginalImage];
    
    self.avatarImg.image = image;
    self.navigationItem.rightBarButtonItem.enabled = image ? YES : NO;
    self.didSelectImg = YES;
}

- (void)saveImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

- (void)resetContent
{
    _photoPayload = nil;
    self.didSelectImg = NO;
   //self.avatarImg.image = IMG(@"AvatarPlaceHolder");
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)presentController:(UIViewController *)controller sender:(id)sender
{
    if (_popoverController.isPopoverVisible) {
        [_popoverController dismissPopoverAnimated:YES];
        _popoverController = nil;
    }
    
    if (_actionSheet.isVisible) {
        _actionSheet = nil;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        controller.preferredContentSize = CGSizeMake(320.0, 520.0);
        
        _popoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        [_popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        
        [self presentViewController:controller animated:YES completion:NULL];
        
    }
}

- (void)dismissController:(UIViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [_popoverController dismissPopoverAnimated:YES];
    }
    else {
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self handleImagePicker:picker withMediaInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self handleImagePicker:picker withMediaInfo:nil];
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Take Photo", nil)]) {
        [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera sender:self.navigationItem.leftBarButtonItem];
    }
    else if ([buttonTitle isEqualToString:NSLocalizedString(@"Choose Photo", nil)]) {
        
        
        [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary sender:self.navigationItem.leftBarButtonItem];
    }
    
    else if ([buttonTitle isEqualToString:NSLocalizedString(@"Edit Photo",nil)]) {
        [self presentPhotoEditor:self.navigationItem.rightBarButtonItem];
    }
    else if ([buttonTitle isEqualToString:NSLocalizedString(@"Delete Photo",nil)]) {
        [self resetContent];
    }
}



#pragma mark - gender
- (IBAction)genderButtonClicked:(UIButton *)sender {
 
    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
    SelectGenderViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"genderPicker"];
    
    if (self.selectedGender != nil) {
     
        if ([self.selectedGender isEqualToString:@"male"])
            vc.selectedGenderStr  = @"male";
        
        else
            vc.selectedGenderStr  = @"female";
    }
    
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    formSheet.presentationController.contentViewSize = CGSizeMake(300, 150);
    
    formSheet.presentationController.portraitTopInset = 10;
    
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.contentViewCornerRadius = 8.0;
    formSheet.presentationController.shouldCenterVertically = YES;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
        SelectGenderViewController *datePickerVC = (SelectGenderViewController *)presentedFSViewController;
        
        if (datePickerVC.selectedGenderStr.length > 0) {
            
            self.selectedGender = datePickerVC.selectedGenderStr;
            self.didSelectedGender = YES;
            
            if ([self.selectedGender isEqualToString:@"male"])
                self.genderLabel.text  = @"مرد";
            
            
            else
                self.genderLabel.text  = @"زن";
        }
        else{
            self.didSelectedGender = NO;
        }
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];

}
#pragma mark - birthday pick
- (IBAction)selectBithdayButtonClicked:(UIButton *)sender {
    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
    SelectBirthDayViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"datePickview"];
    
    if (self.selectedBirthDayDate != nil ) {
        vc.previousDate = self.selectedBirthDayDate;
    }
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    
    formSheet.presentationController.contentViewSize = CGSizeMake(300, 250);
    
    formSheet.presentationController.portraitTopInset = 10;
    
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.contentViewCornerRadius = 8.0;
    formSheet.presentationController.shouldCenterVertically = YES;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
        SelectBirthDayViewController *datePickerVC = (SelectBirthDayViewController *)presentedFSViewController;
        
        if (datePickerVC.didSelectDate) {
            self.selectedBirthDayDate = datePickerVC.previousDate;
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSString *str = [format stringFromDate:self.selectedBirthDayDate];
            self.selectedBirthDayDateStr = str;
            self.birthdayLabel.text = datePickerVC.selectedDateStr;
            
        }
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];
}



#pragma mark -data

- (IBAction)saveButtonClicked:(UIButton *)sender {
    
    if ( self.fisrtNameValid && self.lastNameValid) {
        [self sendUserData];
        
        if (self.didSelectImg) {
            
            [self sendProfileImg];
        }
        
        
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"وارد کردن نام، نام‌خانوادگی،ایمیل و تلفن همراه الزامیست"];
    }
    
}

-(void)sendProfileImg{

    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2. Create an `NSMutableURLRequest`.
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST"
                                                                    URLString:[NSString stringWithFormat:@"%@medias/upload/userprofile",BASEURL]
                                                                   parameters:@{}
                                                    constructingBodyWithBlock:^(id formData) {
                                                        
                                                        
                                                        NSData *imageData = UIImageJPEGRepresentation(self.avatarImg.image, 0.4);
                                                        
                                                        [formData appendPartWithFileData:imageData
                                                                                    name:@"files"
                                                         
                                                                                fileName:@"myimage.jpg"
                                                                                mimeType:@"image/jpeg"];
//
                                                    } error:nil];
    
    [request addValue:[[NarengiCore sharedInstance] makeAuthurizationValue] forHTTPHeaderField:@"authorization"];
    
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                         
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                     }];
    
    
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        [SVProgressHUD showProgress:(float)totalBytesWritten/totalBytesExpectedToWrite status:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
        NSLog(@"Wrote %f", (float)totalBytesWritten/totalBytesExpectedToWrite);
    }];
    
    // 5. Begin!
    [operation start];
}

-(void)sendUserData{
    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *response = [[NarengiCore sharedInstance] sendRequestWithMethod:@"PUT" andWithService: @"accounts/update" andWithParametrs:nil andWithBody:[self makejson] andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            [SVProgressHUD dismiss];
            
            if (!response.hasErro) {

                [SVProgressHUD showSuccessWithStatus:@"اطلاعات با موفقیت ذخیره شد"];

                if (!self.userObject.phoneVerification.isVerified) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil]; 
                }
            }
            else{
                
                if (response.backData != nil ) {
                    
                    //show error
                    NSString *erroStr = [[response.backData objectForKey:@"error"] objectForKey:@"message"];
                    [self showError:erroStr];
                }
                else{
                    
                    [self showError:@"اشکال در ارتباط با سرور"];
                    
                }
                
            }
        });
        
    });
    
}

-(NSData *)makejson{

    NSMutableDictionary* bodyDict =[[NSMutableDictionary alloc] init];

    [bodyDict addEntriesFromDictionary: @{@"firstName":self.nameTextField.text,@"lastName":self.lastNameTextField.text}];
    
    if (self.selectedBirthDayDate != nil) {
        [bodyDict addEntriesFromDictionary:@{@"birthDate":self.selectedBirthDayDateStr}];
    }
    if (self.selectedGender != nil) {
        [bodyDict addEntriesFromDictionary:@{@"gender":self.selectedGender}];
    }
    
    NSString *bioText = [self.aboutTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (bioText.length  > 0) {
        [bodyDict addEntriesFromDictionary:@{@"bio":self.aboutTextView.text}];
    }
    if (self.selectedProvince != nil) {
        [bodyDict addEntriesFromDictionary:@{@"province":[self.selectedProvince objectForKey:@"name"]}];
    }
    if (self.selectedCity.length  > 0) {
        [bodyDict addEntriesFromDictionary:@{@"city":self.selectedCity}];
    }
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[bodyDict copy] options:0 error:nil];
    
    
    return bodyData;
    
}


- (IBAction)dismissButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Province and city
- (IBAction)selectProvinceClicked:(UIButton *)sender {

    [self goToSelectProvince];
}

- (IBAction)selectCityClicked:(UIButton *)sender {

    if (self.selectedProvince !=  nil) {
        [self goToSelectCity];
    }
    else{
        
        UIAlertController *exitAlert = [UIAlertController alertControllerWithTitle:@"نارنگی"
                                                                           message: @"ابتدا استان را انتخاب کنید"
                                                                    preferredStyle:UIAlertControllerStyleAlert                   ];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"تایید"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 [exitAlert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [exitAlert addAction: ok];
        
        [self presentViewController:exitAlert animated:YES completion:nil];
    }
}

-(void)goToSelectProvince{

    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
    SelectProvinceViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"selectProvinceVCID"];
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    
    formSheet.presentationController.contentViewSize = CGSizeMake(300, 400);
    formSheet.presentationController.portraitTopInset = 10;
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheet.contentViewCornerRadius = 8.0;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
        SelectProvinceViewController *vc = (SelectProvinceViewController *)presentedFSViewController;
        if (vc.isSelectProvince) {
            
            self.selectedProvince = vc.selectedProvince;
            self.provinceLabel.text = [self.selectedProvince objectForKey:@"name"];
            
        }
        
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];
}


-(void)goToSelectCity{
    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
    SelectCityViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"selectCityVCID"];
    
    vc.cityArr = [self.selectedProvince objectForKey:@"cities"];
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    
    formSheet.presentationController.contentViewSize = CGSizeMake(300, 400);
    formSheet.presentationController.portraitTopInset = 10;
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheet.contentViewCornerRadius = 8.0;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
        SelectCityViewController *vc = (SelectCityViewController *)presentedFSViewController;
        if (vc.isSelectCity) {
            
            self.selectedCity = vc.selectedCity;
            self.cityLabel.text = self.selectedCity ;
        }
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];
}




@end
