//
//  AddPhotoViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/10/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "AddPhotoViewController.h"

#import "DZNPhotoPickerController.h"
#import "DZNPhotoEditorViewController.h"
#import "UIImagePickerController+Edit.h"
#import "GBKUIButtonProgressView.h"
#import <AFNetworking.h>
#import "SelectAvailableDateViewController.h"


@interface AddPhotoViewController ()<DZNPhotoPickerControllerDelegate,UIActionSheetDelegate,UIPopoverControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    UIPopoverController *_popoverController;
    UIActionSheet *_actionSheet;
    NSDictionary *_photoPayload;
}

@property (weak, nonatomic) IBOutlet UIImageView *Img1;
@property (weak, nonatomic) IBOutlet UIImageView *Img2;
@property (weak, nonatomic) IBOutlet UIImageView *Img3;
@property (weak, nonatomic) IBOutlet UIImageView *Img4;
@property (weak, nonatomic) IBOutlet UIImageView *Img5;
@property (weak, nonatomic) IBOutlet UIImageView *Img6;
@property (weak, nonatomic) IBOutlet UIImageView *Img7;
@property (weak, nonatomic) IBOutlet UIImageView *Img8;
@property (weak, nonatomic) IBOutlet UIImageView *Img9;
@property (weak, nonatomic) IBOutlet UIImageView *Img10;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@property (nonatomic,strong) NSMutableArray *imagesStateMuArr;

@property (nonatomic) NSInteger currentImgTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTopSpace;
@property (weak, nonatomic) IBOutlet AddHomeButton *preButton;
@property (weak, nonatomic) IBOutlet AddHomeButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation AddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.containerViewHeight.constant = ([UIScreen mainScreen].bounds.size.width/2) + (3 * ( ([UIScreen mainScreen].bounds.size.width/4)))+91;
    [self.view layoutIfNeeded];
    
    self.imagesStateMuArr = [[NSMutableArray alloc] init];
    
    for (int  i = 0; i<10; i++) {
        [self.imagesStateMuArr addObject:@{@"type":@"loacal",@"selected":@NO}];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [self changeLeftIcontoBack];
    self.title = @"تصاویر";
    [self addTapActionOnImgaes];
    
    if (self.isComingFromEdit) {
        
        self.stepsViewHeightConstraint.constant  = 0;
        [self.containerView layoutIfNeeded];
        self.scrollTopSpace.constant = 0;
        [self.scrollView layoutIfNeeded];
        self.containerView.hidden = YES;
        
        [self.preButton setTitle:@"انصراف" forState:UIControlStateNormal];
        [self.nextButton setTitle:@"تایید" forState:UIControlStateNormal];
        
        [self loadImages];
    }
    else{
        
        [self changeRightButtonToClose];
        
    }
    
    self.navigationItem.hidesBackButton = YES;

}

//-(void)setUpStatusButtons{
//
//    for (int i = 1; i< 11; i++) {
//        
//        GBKUIButtonProgressView *statusButton = (GBKUIButtonProgressView *)[self valueForKey:[NSString stringWithFormat: @"statusView%d",i]];
//        
//        [statusButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        statusButton.hidden = YES;
//    }
//}

-(void)cancelButtonClicked:(GBKUIButtonProgressView *)sender{

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STEPCHANGED" object:[NSNumber numberWithInteger:7]];
}

-(void)addTapActionOnImgaes{

    for (int i = 1; i< 11; i++) {
        
        UIImageView *imageView = (UIImageView *)[self valueForKey:[NSString stringWithFormat: @"Img%d",i]];
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImagesDetected:)];
        singleTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:singleTap];
    }
    
}

-(void)tapOnImagesDetected:(UITapGestureRecognizer *)tap{

    NSInteger tagOfImg = tap.view.tag;
    self.currentImgTag = tagOfImg;
    
    [self showImportActionSheet];

    
}

-(void)showImportActionSheet{

    _actionSheet = [UIActionSheet new];
    
    if ([[self.imagesStateMuArr[self.currentImgTag-1] objectForKey:@"selected"] boolValue]) {
        [_actionSheet addButtonWithTitle:NSLocalizedString(@"Delete Photo", nil)];
    }
    else{
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            [_actionSheet addButtonWithTitle:NSLocalizedString(@"Take Photo", nil)];
        }
        [_actionSheet addButtonWithTitle:NSLocalizedString(@"Choose Photo", nil)];
    }
    
    
    [_actionSheet setCancelButtonIndex:[_actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)]];
    [_actionSheet setDelegate:self];
    [_actionSheet showInView:self.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)delteButtonClicked:(UIButton *)sender {
    
    
}
- (void)presentPhotoEditor:(id)sender
{
    UIImage *image = _photoPayload[UIImagePickerControllerOriginalImage];
    
    UIImageView *selectedImgV =  (UIImageView *)[self valueForKey:[NSString stringWithFormat: @"Img%ld",(long)self.currentImgTag]];

    if (!image) image = selectedImgV.image;
    
//    DZNPhotoEditorViewControllerCropMode cropMode = [_photoPayload[DZNPhotoPickerControllerCropMode] integerValue];
    
    DZNPhotoEditorViewController *editor = [[DZNPhotoEditorViewController alloc] initWithImage:image];
    editor.cropMode = DZNPhotoEditorViewControllerCropModeCustom;
    
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
    
    picker.cropMode = DZNPhotoEditorViewControllerCropModeCustom;
    picker.cropSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/2);
    
    picker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        
       // if (picker.cropMode == DZNPhotoEditorViewControllerCropModeNone) {
            [weakSelf handleImagePicker:picker withMediaInfo:info];
       // }
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
    
    
    UIImageView *selectedImgV =  (UIImageView *)[self valueForKey:[NSString stringWithFormat: @"Img%ld",(long)self.currentImgTag]];

    selectedImgV.image = image;
    [self.imagesStateMuArr replaceObjectAtIndex:self.currentImgTag-1 withObject:@{@"type":@"loacal",@"selected":@YES}];
    
    //[self startUploadImg];
}

- (void)resetContent
{
    
    NSDictionary *curentDict = self.imagesStateMuArr [self.currentImgTag-1 ];
    
    if ([[curentDict objectForKey:@"type"] isEqualToString:@"loacal"]) {
       
        _photoPayload = nil;
        [self.imagesStateMuArr replaceObjectAtIndex:self.currentImgTag-1 withObject:@{@"type":@"loacal",@"selected":@NO}];
        
        UIImageView *selectedImgV =  (UIImageView *)[self valueForKey:[NSString stringWithFormat: @"Img%ld",(long)self.currentImgTag]];
        selectedImgV.image = IMG(@"AvatarPlaceHolder");
    }
    else{
        
        [self deleteImageFromServerWithDictionary:curentDict andWithImage:(UIImageView *)[self valueForKey:[NSString stringWithFormat: @"Img%ld",(long)self.currentImgTag]]];
        //call delete image API
    }
    
}

-(void)deleteImageFromServerWithDictionary:(NSDictionary *)dict andWithImage:(UIImageView *)imageView{

    __block UIImageView *selectedImgV =  imageView;
    
    REACHABILITY
    
    [SVProgressHUD showWithStatus:@"در حال ارسال اطلاعات" maskType:SVProgressHUDMaskTypeGradient];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        ServerResponse *serverRs = [[NarengiCore sharedInstance] sendRequestWithMethod:@"DELETE" andWithService:[NSString stringWithFormat: @"medias/remove/%@",[dict objectForKey:@"mediaID"] ] andWithParametrs:nil andWithBody:nil andIsFullPath:NO];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [SVProgressHUD dismiss];
            if (!serverRs.hasErro) {
                
                [self.imagesStateMuArr replaceObjectAtIndex:self.currentImgTag-1 withObject:@{@"type":@"loacal",@"selected":@NO}];
                
                selectedImgV =  (UIImageView *)[self valueForKey:[NSString stringWithFormat: @"Img%ld",(long)self.currentImgTag]];
                selectedImgV.image = IMG(@"AvatarPlaceHolder");
                
                [self removeUrlFromHouseObj:[dict objectForKey:@"url"]];
            }
            else{
                
                if (serverRs.backData != nil ) {
                    
                    //show error
                    NSString *erroStr = [[serverRs.backData objectForKey:@"error"] objectForKey:@"message"];
                    [self showError:erroStr];
                }
                else{
                    
                    [self showError:@"اشکال در ارتباط با سرور"];
                    
                }
            }
        });
    });
    
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


#pragma mark - upload

- (IBAction)uploadButtonclicked:(UIButton *)sender {
    
    REACHABILITY
    
    __block NSInteger count = 0;
    
    [self.imagesStateMuArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if ([[obj objectForKey:@"selected"] boolValue]) {
            count ++;
        }
    }];
    
    if (count > 0) {
        [self startUploadAllImg];
    }
    else{
        [self showError:@"لطفا حداقل یک عکس انتخاب کنید"];
    }
    
}
- (IBAction)preButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)startUploadAllImg{
    
    
    
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    // 2. Create an `NSMutableURLRequest`.
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST"
                                                                    URLString:[NSString stringWithFormat:@"%@medias/upload/house/%@",BASEURL,self.houseObj.ID]
                                                                   parameters:@{}
                                                    constructingBodyWithBlock:^(id formData) {
                                                        
                                                        
                                                        [self.imagesStateMuArr enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                            
                                                            
                                                            if ([[obj objectForKey:@"selected"] boolValue] && [[obj objectForKey:@"type"] isEqualToString:@"loacal"]) {
                                                                
                                                                UIImageView *selectedImgV =  (UIImageView *)[self valueForKey:[NSString stringWithFormat: @"Img%ld",idx+1]];
                                                                
                                                                NSData *imageData = UIImageJPEGRepresentation(selectedImgV.image, 0.4);
                                                                
                                                                [formData appendPartWithFileData:imageData
                                                                                            name:@"files"
                                                            
                                                                                        fileName:@"myimage.jpg"
                                                                                        mimeType:@"image/jpeg"];
                                                            }
                                                            
                                                            
                                                        }];
                                                       
                                                    } error:nil];
        
    [request addValue:[[NarengiCore sharedInstance] makeAuthurizationValue] forHTTPHeaderField:@"authorization"];

    
    
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                         [SVProgressHUD showSuccessWithStatus:@"تمامی عکس‌ها بارگذاری شد."];
                                         
                                         if (self.isComingFromEdit) {
                                             
                                             
                                             [self addImageUrls:[[responseObject objectForKey:@"result"] objectForKey:@"uids"]];
                                             
                                             
                                         }
                                         else{
                                             [self performSegueWithIdentifier:@"goToAddAvailabelDates" sender:nil];
                                             NSLog(@"Success %@", responseObject);
                                         }
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                         [SVProgressHUD showErrorWithStatus:@"بارگذاری ‌عکس‌ها با مشکل مواجه شد"];
                                         NSLog(@"Failure %@", error.description);
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


-(void)addImageUrls:(NSArray *)arr{
    
    NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:self.houseObj.imageUrls];
    [arr enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *newUrlStr = [NSString stringWithFormat:@"%@/medias/get/%@",IMAGEBASEURL,obj];
        NSURL *newUrl = [NSURL URLWithString:newUrlStr];
        
        [muArr addObject:newUrl];
    }];
    
    self.houseObj.imageUrls = [muArr copy];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"oneFuckingHouseChanged" object:self.houseObj];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"goToAddAvailabelDates"]) {
        
        SelectAvailableDateViewController *vc = segue.destinationViewController;
        vc.houseObj = self.houseObj;
    }
}

#pragma mark - edit

-(void)loadImages{

    [self.houseObj.imageUrls enumerateObjectsUsingBlock:^(NSURL  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imgView = [self valueForKey:[NSString stringWithFormat: @"Img%ld",idx+1]];
        
        [imgView sd_setImageWithURL:obj placeholderImage:nil];
        
        NSString *imageID = [[[obj absoluteString] componentsSeparatedByString:@"/"] lastObject];
        
        [self.imagesStateMuArr replaceObjectAtIndex:idx withObject:@{@"type":@"url",@"selected":@YES,@"mediaID":imageID,@"url":obj}];

    }];
}

-(void)removeUrlFromHouseObj:(NSURL *)url{

    NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:self.houseObj.imageUrls];
    
    [muArr enumerateObjectsUsingBlock:^(NSURL  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.absoluteString isEqualToString:[url absoluteString]]) {
            
            [muArr removeObjectAtIndex:idx];
            return;
        }
    }];
    
    self.houseObj.imageUrls = [muArr copy];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"oneFuckingHouseChanged" object:self.houseObj];

    
    [self loadImages];
    
}

@end
