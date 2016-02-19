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


@interface EditProfileViewController ()<DZNPhotoPickerControllerDelegate,UIActionSheetDelegate,
UIPopoverControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

{
    UIPopoverController *_popoverController;
    UIActionSheet *_actionSheet;
    NSDictionary *_photoPayload;
}

@property (weak, nonatomic) IBOutlet UITextField  *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField  *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton     *maleButton;
@property (weak, nonatomic) IBOutlet UIButton     *womenButton;
@property (weak, nonatomic) IBOutlet UIButton     *addAvatarButton;

@property (weak, nonatomic) IBOutlet UIImageView  *avatarImg;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *nameTextFieldContainerView;
@property (weak, nonatomic) IBOutlet UIView *emailContainerView;
@property (weak, nonatomic) IBOutlet UIView *phoneContainerView;
@property (weak, nonatomic) IBOutlet UIView *genderContainerView;
@property (weak, nonatomic) IBOutlet UIView *birthDayContainerView;

@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *emailValidationStateLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *phoneValidationStateLabel;
@property (weak, nonatomic) IBOutlet UILabel              *birthdayLabel;

@property (nonatomic,strong) NSDate *selectedBirthDayDate;


@property (nonatomic,strong) UserObject *userObject;
@property ( nonatomic)  BOOL didSelectImg;


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
    

    
    if (self.userObject.fisrtName.length > 0)
        self.nameTextField.text = self.userObject.fisrtName;
        
    
    if (self.userObject.lastName.length > 0)
        self.lastNameTextField.text = self.userObject.lastName;
    
    if (self.userObject.cellNumber.length > 0)
        self.emailTextField.text = self.userObject.cellNumber;
        
    
    if (self.userObject.email.length > 0)
        self.emailTextField.text = self.userObject.email;
    
    [self checkValidations];
}

-(void)checkValidations{

    
    //Check email and phone validation
    
    if ([self.emailTextField.text isEqualToString:self.userObject.email]) {
        
        if (self.userObject.emailVerification == nil || !self.userObject.emailVerification.isVerified) {
            
            self.emailValidationStateLabel.text = @"تایید نشده";
            self.emailValidationStateLabel.textColor = [UIColor redColor];
        }
        else{
            
            self.emailValidationStateLabel.text = @"تایید شده";
            self.emailValidationStateLabel.textColor = [UIColor clearColor];
        }
    }
    else{
        
        self.emailValidationStateLabel.text = @"تایید نشده";
        self.emailValidationStateLabel.textColor = [UIColor redColor];
    
    }

    
    if ([self.phoneTextField.text isEqualToString:self.userObject.cellNumber]) {
        
        if (self.userObject.phoneVerification == nil || !self.userObject.phoneVerification.isVerified) {
            
            self.phoneValidationStateLabel.text      = @"تایید نشده";
            self.phoneValidationStateLabel.textColor = [UIColor redColor];
        }
        else{
            
            self.phoneValidationStateLabel.text      = @"تایید شده";
            self.phoneValidationStateLabel.textColor = [UIColor clearColor];
        }
    }
    else{
        
        self.phoneValidationStateLabel.text = @"تایید نشده";
        self.phoneValidationStateLabel.textColor = [UIColor redColor];
        
    }
}

#pragma mark - textField
- (IBAction)textFieldsChanged:(UITextField *)sender {
}
- (IBAction)textFieldsBeginEditing:(UITextField *)sender {
}
- (IBAction)textFieldsEndEditing:(UITextField *)sender {
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



- (void)presentPhotoSearch:(id)sender
{
    DZNPhotoPickerController *picker = [DZNPhotoPickerController new];
    picker.allowsEditing = NO;
    picker.cropMode = DZNPhotoEditorViewControllerCropModeSquare;
    picker.initialSearchTerm = @"California";
    picker.enablePhotoDownload = YES;
    picker.allowAutoCompletedSearch = YES;
    
    [picker setFinalizationBlock:^(DZNPhotoPickerController *picker, NSDictionary *info){
        [self updateImageWithPayload:info];
        [self dismissController:picker];
    }];
    
    [picker setFailureBlock:^(DZNPhotoPickerController *picker, NSError *error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
    [picker setCancellationBlock:^(DZNPhotoPickerController *picker){
        [self dismissController:picker];
    }];
    
    [self presentController:picker sender:sender];
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
    self.avatarImg.image = IMG(@"AvatarPlaceHolder");
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

#pragma mark - birthday pick
- (IBAction)selectBithdayButtonClicked:(UIButton *)sender {
    
    UIStoryboard *storybord =[UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
    SelectBirthDayViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"datePickview"];
    
    if (self.selectedBirthDayDate != nil ) {
        vc.previousDate = self.selectedBirthDayDate;
    }
    
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:vc];
    
    
    formSheet.presentationController.contentViewSize = CGSizeMake(300, [UIScreen mainScreen].bounds.size.height - 60);
    
    formSheet.presentationController.portraitTopInset = 10;
    
    formSheet.allowDismissByPanningPresentedView = YES;
    formSheet.contentViewCornerRadius = 8.0;
    
    
    formSheet.willPresentContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
    };
    formSheet.didDismissContentViewControllerHandler = ^(UIViewController *presentedFSViewController){
        
        SelectBirthDayViewController *datePickerVC = (SelectBirthDayViewController *)presentedFSViewController;
        
        if (datePickerVC.didSelectDate) {
            self.selectedBirthDayDate = datePickerVC.previousDate;
        }
    };
    
    [self presentViewController:formSheet animated:YES completion:nil];
}



#pragma mark -data

- (IBAction)saveButtonClicked:(UIButton *)sender {
    
}

-(void)sendUserData{

    
}


- (IBAction)dismissButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
