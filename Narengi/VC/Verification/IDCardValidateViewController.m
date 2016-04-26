//
//  IDCardValidateViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 4/26/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "IDCardValidateViewController.h"
#import "DZNPhotoPickerController.h"
#import "DZNPhotoEditorViewController.h"
#import "UIImagePickerController+Edit.h"
#import "VerficationRootViewController.h"
@interface IDCardValidateViewController ()<UIActionSheetDelegate,
UIPopoverControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIPopoverController *_popoverController;
    UIActionSheet *_actionSheet;
    NSDictionary *_photoPayload;
}

@property (weak, nonatomic)  UIImageView  *avatarImg;
@property ( nonatomic)  BOOL didSelectImg;
@property (weak, nonatomic) IBOutlet IranButton *selectImgButton;


@end

@implementation IDCardValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [self changeRightIconToSkip];
    [self.selectImgButton setBorderWithColor:RGB(88, 88 , 88, 1) andWithWidth:1 withCornerRadius:2];

    self.title = @"ارسال مدرک شناسایی";
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Avatar Picker
- (IBAction)selectIDCardImgBt:(UIButton *)sender {
    
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
    [self sendData];
    
    
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

#pragma mark - data
-(void)sendData{

    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    if (self.didSelectImg) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
            BOOL status = [[NarengiCore sharedInstance] sendServerRequestIDCardImageWithImage:UIImageJPEGRepresentation(self.avatarImg.image, 0.4)];
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                if (status) {
                    [SVProgressHUD showSuccessWithStatus:@"اطلاعات با موفقیت ذخیره شد"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [self showtryAgainAlert];

                }
            });
        });
    }
}
-(void)showtryAgainAlert{

    UIAlertController *exitAlert = [UIAlertController alertControllerWithTitle:@"ارسال کارت شناسایی شما موفقیت آمیز نبود!"
                                                                       message: @"تلاش دوباره"
                                                                preferredStyle:UIAlertControllerStyleAlert                   ];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"بله"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             
                             [exitAlert dismissViewControllerAnimated:YES completion:nil];
                             [self sendData];
                             
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"خیر"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [exitAlert dismissViewControllerAnimated:YES completion:nil];
                                 [self popToVerification];
                                 
                             }];
    
    [exitAlert addAction: ok];
    [exitAlert addAction: cancel];
    
    [self presentViewController:exitAlert animated:YES completion:nil];
}
-(void)popToVerification{
    
        NSArray *viewControllers = [[self navigationController] viewControllers];
        for( int i=0;i<[viewControllers count];i++){
            id obj=[viewControllers objectAtIndex:i];
            if([obj isKindOfClass:[VerficationRootViewController class]]){
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - back

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

@end
