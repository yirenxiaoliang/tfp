//
//  FunctionView.m
//  ChatTest
//
//  Created by Season on 2017/5/16.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "FunctionView.h"

#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
@implementation FunctionView

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
        self.backgroundColor = BGCOLOR;
        [self initSubviews];
        
    }
    return self;
}

- (void)initSubviews {
    
    CGFloat itemWidth = SCREEN_WIDTH / 4.0;
    CGFloat itemHeight = itemWidth + 30;
    NSArray *normalImageNames = @[@"MoreView_Image_Normal",@"MoreView_Photograph_Normal",@"MoreView_ShortVideo_Normal",@"MoreView_File_Normal"];

    NSArray *titles = @[@"照片",@"拍照",@"小视频",@"文件"];
    for (int i = 0; i < titles.count; i++) {
        
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(i % 4 * itemWidth, i / 4 * itemHeight, itemWidth, itemHeight)];
        control.tag = 100 + i;
        [control addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
        
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((itemWidth-50)/2.0, (itemHeight-80)/2.0, 50, 50)];
        logoImg.image = [UIImage imageNamed:normalImageNames[i]];
        [control addSubview:logoImg];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, logoImg.bottom, itemWidth, 30)];
        titleLabel.text = titles[i];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [control addSubview:titleLabel];
    }
    
}


/**
 功能选择

 @param control 功能按钮
 */
- (void)chooseAction:(UIControl *)control {
    
    // 开始选择毁掉，用户在聊天界面监听以收起键盘
    if (_functionBlock) {
        
        _functionBlock(0,nil,NO);
    }
    switch (control.tag-100) {
        case ChatMoreFunctionSystemPhoto:   // 系统相册
        {
            DNImagePickerController *imagePicker = [[DNImagePickerController alloc]init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:NULL];
            imagePicker.imagePickerDelegate = self;
            
        }
            break;
        case ChatMoreFunctionTakePhoto:     // 拍照
        {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *camera = [[UIImagePickerController alloc]init];
                camera.sourceType = UIImagePickerControllerSourceTypeCamera;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:camera animated:YES completion:NULL];
                camera.delegate = self;
            }
        }
            break;
        case ChatMoreFunctionFile:          // 文件
        {
            FilesViewController *fileVC = [[FilesViewController alloc]init];
            [fileVC setFileBlock:^(NSArray *files,FileType type){
                
                if (_functionBlock) {
                    
                    _functionBlock(ChatMoreFunctionFile,files,type);
                }
            }];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:fileVC] animated:YES completion:NULL];
        }
            break;
        default:                            // 小视频
        {
            XSVideoViewController *videoVC = [[XSVideoViewController alloc] init];
            videoVC.delegate = self;
            videoVC.savePhotoAlbum = YES;
            [videoVC startAnimationWithType:XSVideoViewShowTypeSingle];
            [self endEditing:YES];
        }
            break;
    }
    
    
  
}

// 相册图片选择代理
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage {
   
    
    NSMutableArray *imgs = [NSMutableArray array];
    for (ALAsset *asset in imageAssets) {
        
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imgs addObject:image];
    }
    if (_functionBlock) {
        
        _functionBlock(ChatMoreFunctionSystemPhoto,imgs,NO);
    }

}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker {
    
    [imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

// 拍照代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    if (_functionBlock) {
        
        _functionBlock(ChatMoreFunctionTakePhoto,@[[self fixOrientation:image]],NO);
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


// 保存图片至相册回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
     [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 小视频拍摄回调
- (void)videoViewController:(XSVideoViewController *)videoController didRecordVideo:(XSVideoModel *)videoModel {
    
    if (_functionBlock) {
        
        UIImage *thumImage = [UIImage imageWithContentsOfFile:videoModel.thumAbsolutePath];
        
        _functionBlock(ChatMoreFunctionMiniVideo,@{@"thumbnail":[self fixOrientation:thumImage],@"video":videoModel.videoAbsolutePath},NO);
    }
    
}


/**
 修复图片旋转问题

 @param aImage 原图
 @return image
 */
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    
    
    if (aImage==nil || !aImage) {
        
        return nil;
        
    }
    
    
    
    // No-op if the orientation is already correct
    
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    
    
    
    // We need to calculate the proper transformation to make the image upright.
    
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImageOrientation orientation=aImage.imageOrientation;
    
    int orientation_=orientation;
    
    switch (orientation_) {
            
        case UIImageOrientationDown:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            break;
            
            
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            break;
            
    }
    
    
    
    switch (orientation_) {
            
        case UIImageOrientationUpMirrored:{
            
        }
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
            
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
    }
    
    
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    
    // calculated above.
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             
                                             CGImageGetColorSpace(aImage.CGImage),
                                             
                                             CGImageGetBitmapInfo(aImage.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    
    
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            // Grr...
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            //            CGImageRelease(aImage.CGImage);
            UIGraphicsEndImageContext();
            break;
            
        default:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            //            CGImageRelease(aImage.CGImage);
            UIGraphicsEndImageContext();
            break;
            
    }
    
    
    
    // And now we just create a new UIImage from the drawing context
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    
    CGImageRelease(cgimg);
    
    aImage=img;
    
    img=nil;
    
    return aImage;
    
}
@end
