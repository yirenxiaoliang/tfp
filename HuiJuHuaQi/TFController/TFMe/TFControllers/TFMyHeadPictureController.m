//
//  TFMyHeadPictureController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMyHeadPictureController.h"
#import "TFPeopleBL.h"
#import "TFLoginBL.h"
#import "MLImageCrop.h"
#import "ZYQAssetPickerController.h"
#import <Photos/Photos.h>
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"

@interface TFMyHeadPictureController ()<UIActionSheetDelegate,HQBLDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,MLImageCropDelegate>

/** imageView */
@property (nonatomic, weak) UIButton *imageView;

@property (nonatomic, strong) TFPeopleBL *peopleBL;
@property (nonatomic, strong)  TFLoginBL*loginBL;

/** image */
@property (nonatomic, strong) UIImage *image;


@end

@implementation TFMyHeadPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
    UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    imageView.center = CGPointMake(self.view.width/2, (self.view.height-64)/2);
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = imageView;
    
    NSURL *url = [HQHelper URLWithString:self.headUrl];
    [imageView sd_setBackgroundImageWithURL:url forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            self.image = image;
            [self.imageView setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.imageView setBackgroundImage:[HQHelper createImageWithColor:GreenColor size:(CGSize){SCREEN_WIDTH,SCREEN_WIDTH}] forState:UIControlStateNormal];
            self.imageView.titleLabel.font = FONT(60);
            [self.imageView setTitle:[HQHelper nameWithTotalName:UM.userLoginInfo.employee.employee_name] forState:UIControlStateNormal];
        }
    }];
 
    [self setupNavi];
}

- (void)setupNavi{
    
    self.navigationItem.title = @"我的头像";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) image:@"headMenu" highlightImage:@"headMenu"];
}

- (void)rightClicked{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择",@"保存照片", nil];
    
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self openCamera];
    }else if (buttonIndex == 1){
        
        [self openAlbum];
    }else{
        
        [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
            if (granted) {
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    // 写入相册
                    [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
                    
                    
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    
                    HQLog(@"success = %d, error = %@", success, error);
                    
                    [MBProgressHUD showError:@"已保存到手机相册" toView:self.view];
                }];
                
            }
            else if (!firstTime )
            {
                [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
            }
        }];
    }
    
}


#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - 打开相册
- (void)openAlbum{
    
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = 1 ; // 选择图片最大数量
            picker.assetsFilter = [ALAssetsFilter allPhotos]; // 可选择所有相册图片
            picker.showEmptyGroups = NO;
            picker.delegate = self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            picker.modalPresentationStyle = UIModalPresentationFullScreen;

            [self.navigationController presentViewController:picker animated:YES completion:NULL];
            
            
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
    
}

#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        imageCrop.ratioOfWidthAndHeight = 800.0f/800.0f;
        imageCrop.image = tempImg;
        [imageCrop showWithAnimation:YES];
    }
    
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    self.image = cropImage;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.peopleBL imageFileWithImages:@[self.image] withVioces:nil];
}


#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.image = image;
    
    [self.peopleBL imageFileWithImages:@[self.image] withVioces:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //修改头像
    if (resp.cmdId == HQCMD_ImageFile) {
        
        NSArray *files = resp.body;
        
        if (files.count) {
            
            TFFileModel *model = files[0];
            
            TFEmployModel *em = [[TFEmployModel alloc] init];
            em.picture = model.file_url;
            if (self.headRefresh) {
                self.headRefresh(model.file_url);
            }
            
            [self.peopleBL requestUpdateEmployeeWithEmployee:em];
            
        }
        
    }
    
    if (resp.cmdId == HQCMD_updateEmployee) {
        
        
        [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
        
        
    }
    
    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        
        if (self.refresh) {
            self.refresh(nil);
        }
        [self.loginBL requestEmployeeList];
        
    }
    
    if (resp.cmdId == HQCMD_employeeList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.imageView setBackgroundImage:self.image forState:UIControlStateNormal];
        [self.imageView setTitle:@"" forState:UIControlStateNormal];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
