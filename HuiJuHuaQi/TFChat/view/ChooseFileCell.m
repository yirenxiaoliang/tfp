//
//  ChooseFileCell.m
//  ChatTest
//
//  Created by 肖胜 on 2017/5/21.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "ChooseFileCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
@implementation ChooseFileCell{
    
    NSString *path;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _info = [NSMutableDictionary dictionary];
        [self selectedImage];
        [self thumbImage];
        [self nameLable];
        [self sizeLabel];
        [self datelabel];
    }
    
    return self;
}

- (UIImageView *)selectedImage {
    
    if (_selectedImage == nil) {
        
        _selectedImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 20, 20)];
        _selectedImage.image = [UIImage imageNamed:@"file_unchoose"];
        [self.contentView addSubview:_selectedImage];
    }
    return _selectedImage;
}

- (UIImageView *)thumbImage {
    
    if (_thumbImage == nil) {
        
        _thumbImage = [[UIImageView alloc]initWithFrame:CGRectMake(_selectedImage.right + 10, 10, 60, 60)];
        
        [self.contentView addSubview:_thumbImage];
    }
    return _thumbImage;
}

- (UILabel *)nameLable {
    
    if (_nameLable == nil) {
        
        _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(_thumbImage.right + 10, _thumbImage.top, self.contentView.width-_thumbImage.right, 15)];
        
        _nameLable.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLable];
    }
    return _nameLable;
}

- (UILabel *)sizeLabel {
 
    if (_sizeLabel == nil) {
        
        _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLable.left, _nameLable.bottom+10, _nameLable.width, 15)];
        _sizeLabel.font = [UIFont systemFontOfSize:14];
        _sizeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_sizeLabel];
    }
    return _sizeLabel;
}

- (UILabel *)datelabel {
    
    if (_datelabel == nil) {
        
        _datelabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLable.left, _thumbImage.bottom-15, _nameLable.width, 15)];
        _datelabel.font = [UIFont systemFontOfSize:14];
        _datelabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_datelabel];
    }
    return _datelabel;
}


/**
 设置音乐

 @param music 音乐响起
 @param isSelected 是否选中
 */
- (void)setMusic:(NSDictionary *)music IsSelected:(BOOL)isSelected {
    
    if (isSelected) {
        
        _selectedImage.image = [UIImage imageNamed:@"file_choose"];
    }
    else {
        _selectedImage.image = [UIImage imageNamed:@"file_unchoose"];
    }

    
    self.sizeLabel.text = music[@"content"][@"size"];
    self.nameLable.text = music[@"content"][@"name"];
    self.thumbImage.image = [UIImage imageWithData:music[@"content"][@"image"]];
    self.datelabel.text = music[@"content"][@"time"];
    
    _info = music[@"content"];
}


/**
 设置视频信息
 
 @param asset PHAsset
 @param isSelected 是否选中
 */
- (void)setAsset:(NSDictionary *)asset IsSelected:(BOOL) isSelected{
    
    
    if (isSelected) {
        
        _selectedImage.image = [UIImage imageNamed:@"file_choose"];
    }
    else {
        
        _selectedImage.image = [UIImage imageNamed:@"file_unchoose"];
    }
    
    _asset = asset;
    
    __weak typeof(self) weakSelf = self;
    
    // 获取视频创建时间
//    NSDate *date = asset.creationDate;
    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    
//    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";//指定转date得日期格式化形式
    
    _datelabel.text = asset[@"time"];
    weakSelf.sizeLabel.text = asset[@"size"];
    weakSelf.nameLable.text = asset[@"name"];
    weakSelf.thumbImage.image = [UIImage imageWithData:asset[@"thumbnail"]];
//    if (_info.count) {
//        
//        self.sizeLabel.text = _info[@"size"];
//        self.nameLable.text = _info[@"name"];
//        self.thumbImage.image = [UIImage imageWithData:_info[@"thumbnail"]];
//        return;
//    }
//    
//    PHVideoRequestOptions *voptions = [[PHVideoRequestOptions alloc]init];
//    voptions.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
//    
//    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:voptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//        if (asset && [asset isKindOfClass:[AVURLAsset class]] && [NSString stringWithFormat:@"%@",((AVURLAsset *)asset).URL].length > 0) {
//            
//            AVURLAsset *urlAsset = (AVURLAsset *)asset;
//            
//            // 视频的相册路径，不是绝对路径，不能用来直接播放
//            NSURL *url = urlAsset.URL;
//            path = [url absoluteString];
//            
//            // 获取文件
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                weakSelf.sizeLabel.text = [weakSelf unitCalc:data.length];
//                weakSelf.nameLable.text = [[path componentsSeparatedByString:@"/"] lastObject];
//                
//                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
//                
//                dateFormatter.dateFormat=@"yyyy-MM-dd_hh:mm:ss";//指定转date得日期格式化形式
//
//                NSString *fileName = [NSString stringWithFormat:@"%@.%@",[dateFormatter stringFromDate:date],[[path componentsSeparatedByString:@"."] lastObject]];
//                
//                // 将文件写入沙盒目录，用以播放
//                [weakSelf videoWithData:data withFileName:fileName andVideoUrlPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]];
    
//                [weakSelf.info setValue:weakSelf.nameLable.text forKey:@"name"];
//                [weakSelf.info setValue:weakSelf.sizeLabel.text forKey:@"size"];
    
//            });
    
//        }
//    }];
    
    // 获取视频缩略图
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//
//    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//       
//        weakSelf.thumbImage.image = [UIImage imageWithData:asset[@"thumbnail"]];
//        [weakSelf.info setValue:imageData forKey:@"thumbnail"];
    
//    }];
    
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(30, 30) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        
//        weakSelf.thumbImage.image = result;
//        
//        NSData *data = UIImagePNGRepresentation(result);
//        if (!data.length) {
//            
//            data = UIImageJPEGRepresentation(result, 1);
//        }
//        [weakSelf.info setValue:data forKey:@"thumbnail"];
//        
//
//    }];

    
}



/**
 将原始视频的NSData数据,写入沙盒

 @param data 原视频data
 @param fileName 目标文件名
 @param KVideoUrlPath 目标路径
 */
- (void)videoWithData:(NSData *)data withFileName:(NSString *)fileName andVideoUrlPath:(NSString *)KVideoUrlPath{
    
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
        
        [fileManager createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
     NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:fileName];
    
    
    const char *cvideoPath = [videoPath UTF8String];
    
    FILE *file = fopen(cvideoPath, "a+");
    
    
    if (NULL == file)
    {
        NSLog(@"Open file error to write data!");
        return ;
    }
    
    
    fseek(file, 0, SEEK_END);                               // 移到文件末尾
    fwrite((void *)[data bytes], data.length, 1, file);       // 写入数据
    data = nil;
    fclose(file);
    
    
    [self.info setValue:videoPath forKey:@"video"];
    
}


/**
 字节转成KB，MB字符串

 @param length 字节长度
 @return 描述
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


@end
