//
//  FilesViewController.m
//  ChatTest
//
//  Created by Season on 2017/5/19.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "FilesViewController.h"
#import "MusicAndVideoTable.h"
#import "FSSegment.h"
#import "ImageCollectionCell.h"

@interface FilesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    NSMutableArray <PHAsset *> *imageAssets;
    NSMutableArray <PHAsset *> *videoAssets;
    NSMutableArray <PHAsset *> *selectedAssets;
    NSMutableArray *musics;
    UICollectionView *imagesCollection;
    MusicAndVideoTable *videoTable;
    MusicAndVideoTable *musicTable;
    NSMutableArray *currentArray;
    FileType fileType;
    BOOL hasAuthorized;     // 初次授权时用户授权成功，因初次授权成功后回调结果会调用两次，防止数据请求两次
}
@end

@implementation FilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
    
    // 开启子线程处理数据，获取系统相册中图片和视频文件
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        currentArray = [NSMutableArray array];
        
        selectedAssets = [NSMutableArray array];
        
        [self initData];
    });
}

- (void)initData {
    
    
    imageAssets = [self getAllAssetInPhotoAblumWithAscending:NO MediaType:PHAssetMediaTypeImage];
    
    videoAssets = [self getAllAssetInPhotoAblumWithAscending:NO MediaType:PHAssetMediaTypeVideo];
    
    musics = [self getMusicFile];
    
    currentArray = imageAssets;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        
        [imagesCollection reloadData];
        
        [musicTable setMusics:musics];
        
        [videoTable setAssets:videoAssets];
    });
    
}

- (NSMutableArray *)getMusicFile {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"小幸运" ofType:@"mp3"];
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *dictAtt = [fm attributesOfItemAtPath:filePath error:nil];
    
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue: [NSString stringWithFormat:@"%.2fM",[[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024)] forKey:@"size"];
    [content setValue:[[filePath componentsSeparatedByString:@"/"] lastObject]forKey:@"name"];
    [content setValue:filePath forKey:@"video"];
    [content setValue: [[NSString stringWithFormat:@"%@", [dictAtt objectForKey:@"NSFileCreationDate"]] substringToIndex:19] forKey:@"time"];
    
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    AVURLAsset *mp3Assent = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    NSString *format = [mp3Assent availableMetadataFormats][0];
    for (AVMetadataItem *metadataItem in [mp3Assent metadataForFormat:format]) {
        
        id item = metadataItem.value;
        if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
            
           [content setValue:item forKey:@"image"];
        }
    }

    [arr addObject:@{@"content":content,@"fileType":@(FileTypeMusic)}];
    
    return arr;
}


- (void)initSubviews {
    
    self.title = @"文件列表";
    self.navigationController.navigationBar.translucent = NO;
    FSSegment *segment = [[FSSegment alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) Titles:@[@"图片",@"视频",@"音乐"] NormalTitleColor:[UIColor blackColor] SelectedTitleColor:[UIColor orangeColor]];
    [self.view addSubview:segment];
    [segment setBlock:^(NSInteger index){
        
        selectedAssets = [NSMutableArray array];
        
        fileType = index;
        if (fileType == FileTypeVideo) {
        
            [imagesCollection reloadData];
            [musicTable reloadData];
            videoTable.hidden = NO;
            imagesCollection.hidden = YES;
            musicTable.hidden = YES;
        
            
        }
        else if (fileType == FileTypeMusic) {
            
            [imagesCollection reloadData];
            [videoTable reloadData];
            musicTable.hidden = NO;
            imagesCollection.hidden = YES;
            videoTable.hidden = YES;
        }
        else {
            
            [videoTable reloadData];
            [musicTable reloadData];
            imagesCollection.hidden = NO;
            musicTable.hidden = YES;
            videoTable.hidden = YES;
        }
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 50, 30);
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0, 0, 50, 30);
    [sendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16 ];
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-25)/4.0, (SCREEN_WIDTH-25)/4.0);
    
    imagesCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(5, segment.bottom, SCREEN_WIDTH-10, SCREEN_HEIGHT-segment.bottom-64) collectionViewLayout:layout];
    imagesCollection.backgroundColor = [UIColor whiteColor];
    [imagesCollection registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"ImageCollectionCell"];
    imagesCollection.delegate = self;
    imagesCollection.dataSource = self;
    [self.view addSubview:imagesCollection];
    
    videoTable =[[MusicAndVideoTable alloc]initWithFrame:imagesCollection.frame];
    videoTable.hidden = YES;
    [self.view addSubview:videoTable];
    
    musicTable = [[MusicAndVideoTable alloc]initWithFrame:imagesCollection.frame];
    musicTable.hidden = YES;
    [self.view addSubview:musicTable];
    
}


/**
 发送
 */
- (void)sendAction:(UIButton *)sender {
    
    sender.enabled = NO;
    NSMutableArray *data;
    data = [NSMutableArray array];
    
    switch (fileType) {
        case FileTypeImage: // 图片
        {
            
            for (PHAsset *asset in selectedAssets) {
                
                [data addObject: [self getImageForPHAsset:asset DeliveryModel:PHImageRequestOptionsDeliveryModeHighQualityFormat]];
            }
        }
            break;
        case FileTypeVideo: // 视频
        {
            data = [NSMutableArray arrayWithArray:videoTable.selectedAssets];
        }
            break;
        default:
        {
            data = [NSMutableArray arrayWithArray:musicTable.selectedAssets];
        }
            break;
    }
    
   
    
    
    if (_fileBlock) {
        
        _fileBlock(data,fileType);
    }
    [self dismissAction];
}


/**
 返回
 */
- (void)dismissAction {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionCell" forIndexPath:indexPath];
    [cell setImage:currentArray[indexPath.item] IsSelected:[self containAsset:currentArray[indexPath.item]]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return currentArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = currentArray[indexPath.item];
    
    
    if ([self containAsset:asset]) {
        
        [selectedAssets removeObject:asset];
    }
    else {
        
        if (selectedAssets.count >= 4) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多选择4张" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL]];
            [self presentViewController:alert  animated:YES completion:NULL];
            
            return;
        }
        
        [selectedAssets addObject:asset];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (BOOL)containAsset:(PHAsset *)asset {
    
    return [selectedAssets containsObject:asset];
}




/**
 获取系统相册中所有图片或视频文件

 @param ascending 时间排序
 @return 文件信息数组
 */
- (NSMutableArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending MediaType:(PHAssetMediaType)type
{
    
    // 获取授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    // 如果未授权
    if (status == PHAuthorizationStatusNotDetermined) {
        
        
        // 监听用户初次授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            // 若授权为允许访问
            if (status == PHAuthorizationStatusAuthorized && !hasAuthorized) {
                
                [self initData];
                // 防止此方法调用两次
                hasAuthorized = YES;
                
            }
        }];
        return nil;
    }
    
    // 用户允许访问相册
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未授权访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL]];
        [self presentViewController:alert  animated:YES completion:NULL];
        
        return nil;
    }
    
    
    NSMutableArray<PHAsset *> *tempassets = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:type options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        
        if (![tempassets containsObject:asset]) {
            
            [tempassets addObject:asset];
        }
        
    }];
    // NSLog(@"%ld",assets.count);
    return tempassets;
    
}


/**
 获取asset中图片

 @param asset asset
 @param model 图片类型、高清图或缩略图
 @return 图片
 */
- (NSMutableDictionary *)getImageForPHAsset:(PHAsset *)asset DeliveryModel:(PHImageRequestOptionsDeliveryMode)model{
    
   
    __block NSMutableDictionary *imageInfo = [NSMutableDictionary dictionary];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    // 图片类型
    options.deliveryMode = model;
   
    // block同步
    options.synchronous = YES;
    
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        // 计算文件大小
        [imageInfo setValue:[self unitCalc:imageData.length] forKey:@"size"];
        
        // 获取文件名
        [imageInfo setValue:[[[info[@"PHImageFileURLKey"] absoluteString]componentsSeparatedByString:@"/"] lastObject] forKey:@"name"];
        
        [imageInfo setValue:imageData forKey:@"image"];
    }];
    
    
    return imageInfo;
}


/**
 将NSData字节数转换为KB、MB

 @param length <#length description#>
 @return <#return value description#>
 */
- (NSString *)unitCalc:(NSUInteger)length {
    
    if (length/1024 < 1024) {
        
        return [NSString stringWithFormat:@"%.2fk",length/1024.0];
    }
    else {
        
        return [NSString stringWithFormat:@"%.2fM",length/1024.0/1024.0];
    }
    return @"0";
    
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
