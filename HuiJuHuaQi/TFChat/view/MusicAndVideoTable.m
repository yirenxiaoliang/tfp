//
//  MusicTable.m
//  ChatTest
//
//  Created by Season on 2017/5/19.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "MusicAndVideoTable.h"

@implementation MusicAndVideoTable
{
    
    FileType fileType;
    NSMutableArray *videoInfos;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedAssets = [NSMutableArray array];
        videoInfos = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc]init];
        [self registerClass:[ChooseFileCell class] forCellReuseIdentifier:@"ChooseFileCell"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (fileType == FileTypeVideo) {
        
        return videoInfos.count;
    }
    else {
        
        return _musics.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseFileCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (fileType == FileTypeVideo) {
        
        [cell setAsset:videoInfos[indexPath.row] IsSelected:[_selectedAssets containsObject:videoInfos[indexPath.row]]];
    }
    else {
        [cell setMusic:_musics[indexPath.row] IsSelected:[_selectedAssets containsObject:cell.info]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseFileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_musics.count) {

        // 判断是否选中
        if ([_selectedAssets containsObject:cell.info]) {
            
            [_selectedAssets removeObject:cell.info];
        }
        else {
            [_selectedAssets addObject:cell.info];
        }
    }
    if (videoInfos.count) {
        
        // 判断是否选中
        if ([_selectedAssets containsObject:cell.asset]) {
            
            [_selectedAssets removeObject:cell.asset];
        }
        else {
            [_selectedAssets addObject:cell.asset];
        }
    }
    [tableView reloadData];
}


- (BOOL) containAsset:(NSDictionary *)asset{
    
    
    for (NSDictionary *dic in _selectedAssets) {
        
        if ([dic[@"name"] isEqualToString:asset[@"name"]]) {
            
            return YES;
        }
    }
    return  NO;
}

/**
 设置视频
 
 @param assets 视频信息
 */
- (void)setAssets:(NSMutableArray<PHAsset *> *)assets {
    
    _assets = assets;
    
    __weak typeof(self) weakSelf = self;
    
    for (PHAsset *asset in assets) {
    
       __block NSMutableDictionary *videoinfo = [NSMutableDictionary dictionary];
        
        // 获取视频创建时间
        NSDate *date = asset.creationDate;
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        
        dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";//指定转date得日期格式化形式
        
        [videoinfo setValue:[dateFormatter stringFromDate:date] forKey:@"time"];
        
        
        __block NSString *path;
        
        PHVideoRequestOptions *voptions = [[PHVideoRequestOptions alloc]init];
        
        voptions.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:voptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            if (asset && [asset isKindOfClass:[AVURLAsset class]] && [NSString stringWithFormat:@"%@",((AVURLAsset *)asset).URL].length > 0) {
                
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                
                [videoinfo setValue:UIImageJPEGRepresentation([weakSelf getThumbnailImage:urlAsset], .5) forKey:@"thumbnail"];
 
                
                // 视频的相册路径，不是绝对路径，不能用来直接播放
                NSURL *url = urlAsset.URL;
                path = [url absoluteString];
                
                // 获取文件
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                [videoinfo setValue:[weakSelf unitCalc:data.length] forKey:@"size"];
                
                
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
                
                dateFormatter.dateFormat=@"yyyy-MM-dd_hh:mm:ss";//指定转date得日期格式化形式
                
                NSString *fileName = [NSString stringWithFormat:@"%@.%@",[dateFormatter stringFromDate:date],[[path componentsSeparatedByString:@"."] lastObject]];
                
                // 将文件写入沙盒目录，用以播放
                
                [videoinfo setValue:[weakSelf videoWithData:data withFileName:fileName andVideoUrlPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]] forKey:@"video"];
                [videoinfo setValue:[[path componentsSeparatedByString:@"/"] lastObject] forKey:@"name"];
                
                [videoInfos addObject:videoinfo];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf reloadData];
                });
                
            }
        }];
        
        
        
       
    }
    
    fileType = FileTypeVideo;
    [self reloadData];
}

-(UIImage *)getThumbnailImage:(AVURLAsset *)asset {
    if (asset) {
        
        
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        gen.appliesPreferredTrackTransform = YES;
        // 设置图片的最大size(分辨率)
        gen.maximumSize = CGSizeMake(300, 169);
        CMTime time = CMTimeMakeWithSeconds(0.0, 600); //取第0秒，一秒钟600帧
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        if (error) {
            UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
            return placeHoldImg;
        }
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        return thumb;
    } else {
        UIImage *placeHoldImg = [UIImage imageNamed:@"posters_default_horizontal"];
        return placeHoldImg;
    }
}


/**
 设置音乐

 @param musics 音乐信息
 */
- (void)setMusics:(NSMutableArray *)musics {
    
    _musics = musics;
    fileType = FileTypeMusic;
    [self reloadData];
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

/**
将原始视频的NSData数据,写入沙盒

@param data 原视频data
@param fileName 目标文件名
@param KVideoUrlPath 目标路径
*/
- (NSString *)videoWithData:(NSData *)data withFileName:(NSString *)fileName andVideoUrlPath:(NSString *)KVideoUrlPath{
    
    
    
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
        return nil;
    }
    
    
    fseek(file, 0, SEEK_END);                               // 移到文件末尾
    fwrite((void *)[data bytes], data.length, 1, file);       // 写入数据
    data = nil;
    fclose(file);
    
    
    
    return videoPath;
}
@end
