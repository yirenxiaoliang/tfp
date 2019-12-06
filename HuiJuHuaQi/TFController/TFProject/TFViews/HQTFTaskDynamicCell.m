//
//  HQTFTaskDynamicCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskDynamicCell.h"
#import "HQTFImageCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "YYLabel.h"

#define CollectionItemWidth ((SCREEN_WIDTH - Long(105))/3.0)

@interface HQTFTaskDynamicCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UIView *fileView;
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fileTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fileHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headT;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet YYLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vioceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceTopH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopH;

/** model */
@property (nonatomic, strong) TFTaskDynamicModel *taskDynamic;

/** model */
@property (nonatomic, strong) NSMutableArray *images;

/** voiceUrl */
@property (nonatomic, strong) TFFileModel *voiceUrl;

/** model */
@property (nonatomic, strong) TFCustomerCommentModel *model ;
/** hybirdModel */
@property (nonatomic, strong) TFTaskHybirdDynamicModel *hybirdModel ;


@end

@implementation HQTFTaskDynamicCell

-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 20;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.titleLabel.font = FONT(16);
    
    self.titleLabel.textColor = LightBlackTextColor;
    self.titleLabel.font = FONT(14);
    
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    self.contentLabel.font = FONT(14);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.backgroundColor = ClearColor;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HQTFImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HQTFImageCollectionViewCell"];
    
    self.timeLabel.textColor = LightGrayTextColor;
    self.timeLabel.font = FONT(12);
    
    [self.voiceBtn addTarget:self action:@selector(voiceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.fileTop.constant = 0;
    self.fileHeight.constant = 0;
    self.fileView.hidden = YES;
//    self.fileView.backgroundColor = RedColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fileClicked)];
    [self.fileView addGestureRecognizer:tap];
    self.timeLabel.hidden = YES;
}

- (void)fileClicked{
    
    if ([self.delegate respondsToSelector:@selector(taskDynamicCell:didClickFile:)]) {
        [self.delegate taskDynamicCell:self didClickFile:self.voiceUrl];
    }
}

- (void)voiceBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(taskDynamicCell:didClickVoice:)]) {
        [self.delegate taskDynamicCell:self didClickVoice:self.voiceUrl];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HQTFImageCollectionViewCell" forIndexPath:indexPath];
    
    id obj = self.images[indexPath.row];
    if ([obj isKindOfClass:[UIImage class]]) {
        cell.image.image = obj;
    }else{
        [cell.image sd_setImageWithURL:[HQHelper URLWithString:self.images[indexPath.row]] placeholderImage:[HQHelper createImageWithColor:GrayTextColor]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(CollectionItemWidth, CollectionItemWidth);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HQTFImageCollectionViewCell *cell = (HQTFImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(taskDynamicCell:didClickImage:)]) {
        [self.delegate taskDynamicCell:self didClickImage:cell.image];
    }
}



+ (instancetype)taskDynamicCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFTaskDynamicCell" owner:self options:nil] lastObject];
}

+ (HQTFTaskDynamicCell *)taskDynamicCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFTaskDynamicCell";
    HQTFTaskDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self taskDynamicCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
    return cell;
}

/** 计算文本size，当文本小于最大宽度时返回本身的宽度 */
+ (CGSize)caculateTextSizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth{
    
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = maxSize;
    container.maximumNumberOfRows = 0;
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:[self attributedStringWithText:text font:14.0]];
    
    CGFloat textW = layout.textBoundingSize.width > maxSize.width ? maxSize.width : layout.textBoundingSize.width;
    
    
    return CGSizeMake(textW, layout.textBoundingSize.height);
    
}

/** 普通文本转成带表情的属性文本 */
+ (NSAttributedString *)attributedStringWithText:(NSString *)text font:(CGFloat)font{
    
    return [LiuqsDecoder decodeWithPlainStr:text font:[UIFont systemFontOfSize:font]];
}


/** 刷新自定义评论 */

- (void)refreshCommentCellWithCustomModel:(TFCustomerCommentModel *)model{
    
    self.model = model;
    
    self.model.fileType = [self.model.fileType stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            self.headImage.backgroundColor = HeadBackground;
        }else{
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
            self.headImage.backgroundColor = WhiteColor;
        }
        
    }];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateHighlighted completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            self.headImage.backgroundColor = GreenColor;
        }else{
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
            self.headImage.backgroundColor = WhiteColor;
        }
        
    }];
    
//    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",model.employee_name,@"发表了评论"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@   %@",model.employee_name,[HQHelper nsdateToTimeNowYear:[model.datetime_time longLongValue]]];
    self.contentLabel.attributedText = [HQTFTaskDynamicCell attributedStringWithText:model.content font:14.0];
    self.timeLabel.text = [HQHelper nsdateToTimeNowYear:[model.datetime_time longLongValue]];
    
    CGSize size = [HQTFTaskDynamicCell caculateTextSizeWithText:model.content maxWidth:(SCREEN_WIDTH - Long(95))];
    
    NSInteger type = 0;
    [self.images removeAllObjects];
    if (([[model.fileType lowercaseString] isEqualToString:@"mp3"] || [[model.fileType lowercaseString] isEqualToString:@"amr"])) {// 语音
        type = 1;
        TFFileModel *file = [[TFFileModel alloc] init];
        file.file_url = model.fileUrl;
        file.voiceDuration = model.voiceTime;
        file.employeeId = model.employee_id;
        file.employeeName = model.employee_name;
        file.photograph = model.picture;
        file.createTime = model.datetime_time;
        file.file_type = model.fileType;
        file.file_size = model.fileSize;
        file.file_name = model.fileName;
        self.voiceUrl = file;
        
//        [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[model.voiceTime floatValue]/1000 > 60.0 ? 60.0 : [model.voiceTime floatValue]/1000] forState:UIControlStateNormal];
//        [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[model.voiceTime floatValue]/1000 > 60.0 ? 60.0 : [model.voiceTime floatValue]/1000] forState:UIControlStateHighlighted];
        
        [HQHelper cacheFileWithUrl:model.fileUrl fileName:file.file_name completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSError *error1;
            
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&error1];
            if (error1) {
                HQLog(@"初始化失败哦");
                return ;
            }
            [HQHelper saveCacheFileWithFileName:file.file_name data:data];
            
            player.numberOfLoops = 0; //不循环
            [player setVolume:1.0];
            [player prepareToPlay];
            dispatch_async(dispatch_get_main_queue(), ^{

                self.model.voiceTime = @(player.duration);

                [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",player.duration > 60.0 ? 60.0 : player.duration] forState:UIControlStateNormal];
                [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",player.duration > 60.0 ? 60.0 : player.duration] forState:UIControlStateHighlighted];
            });

        } fileHandler:^(NSString *path) {
            
            NSError *error1;
            
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:&error1];
            if (error1) {
                HQLog(@"初始化失败哦");
                return ;
            }
            
            player.numberOfLoops = 0; //不循环
            [player setVolume:1.0];
            [player prepareToPlay];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.model.voiceTime = @(player.duration);
                
                [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",player.duration > 60.0 ? 60.0 : player.duration] forState:UIControlStateNormal];
                [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",player.duration > 60.0 ? 60.0 : player.duration] forState:UIControlStateHighlighted];
            });
        }];
        
    }else if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]|| [[model.fileType lowercaseString] isEqualToString:@"jpeg"]){// 图片
        type = 2;
        if (model.fileUrl) {
            [self.images addObject:model.fileUrl];
        }
    }else if (model.fileType && ![model.fileType isEqualToString:@""]){
        type = 3;
        
        TFFileModel *file = [[TFFileModel alloc] init];
        file.file_url = model.fileUrl;
        file.voiceDuration = model.voiceTime;
        file.employeeName = model.employee_name;
        file.photograph = model.picture;
        file.createTime = model.datetime_time;
        file.file_type = model.fileType;
        file.file_size = model.fileSize;
        file.file_name = model.fileName;
        self.voiceUrl = file;
    }
    
    switch (type) {
        case 0:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
        case 1:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = NO;
            self.voiceTopH.constant = 10;
            self.vioceH.constant = 30;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
            [self.voiceBtn setImage:[UIImage imageNamed:@"语音气泡"] forState:UIControlStateNormal];
            [self.voiceBtn setImage:[UIImage imageNamed:@"语音气泡"] forState:UIControlStateHighlighted];
            [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[model.voiceTime floatValue]/1000 > 60.0 ? 60 : [model.voiceTime floatValue]/1000] forState:UIControlStateNormal];
            [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[model.voiceTime floatValue]/1000 > 60.0 ? 60 : [model.voiceTime floatValue]/1000] forState:UIControlStateHighlighted];
            [self.voiceBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
            [self.voiceBtn setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
            
            
            
            
        }
            break;
        case 2:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = NO;
            self.collectionTopH.constant = 10;
            self.collectionH.constant = CollectionItemWidth;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
            
        case 3:// 文件
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 10;
            self.fileHeight.constant = 40;
            self.fileView.hidden = NO;
            self.fileName.text = model.fileName;
            self.fileImage.image = [HQHelper file_typeWithFileModel:self.voiceUrl];
            [self.imageView setImage:[HQHelper createImageWithColor:RedColor]];
        }
            break;
            
        default:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
    }
    
    [self.collectionView reloadData];
}

+ (CGFloat)refreshCommentCellHeightWithCustomModel:(TFCustomerCommentModel *)model{
    model.fileType = [model.fileType stringByReplacingOccurrencesOfString:@"." withString:@""];
    // 上边距 + 下边距
    CGFloat height = 15 + 15;
    
    height += 15;// title
    
    // 按内容计算高度
    CGSize size = [HQTFTaskDynamicCell caculateTextSizeWithText:model.content maxWidth:(SCREEN_WIDTH - Long(95))];
    
    NSInteger type = 0;
    
    if ([[model.fileType lowercaseString] isEqualToString:@"mp3"] || [[model.fileType lowercaseString] isEqualToString:@"amr"]) {// 语音
        type = 1;
        
    }else if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]|| [[model.fileType lowercaseString] isEqualToString:@"jpeg"]){// 图片
        type = 2;
    }else if(model.fileType && ![model.fileType isEqualToString:@""]){
        
        type = 3;
    }
    
    
    switch (type) {
        case 0:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
        case 1:
        {
            height += (30 + 10);
        }
            break;
        case 2:
        {
            height += (CollectionItemWidth + 10);
        }
            break;
        case 3:
        {
            height += (40+10);
        }
            break;
            
        default:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
    }
    
    // Time
//    height += 25;
    
    return height;
    

}

- (void)refreshCommentCellWithHybirdModel:(TFTaskHybirdDynamicModel *)model{
    
    self.hybirdModel = model;
    self.timeLabel.textColor = GrayTextColor;
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.headImage.layer.cornerRadius = 14;
    self.headH.constant = self.headW.constant = 28;
    self.headT.constant = 0;
//    self.model.fileType = [self.model.fileType stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    TFFileModel *file = model.information.firstObject;
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            self.headImage.backgroundColor = HeadBackground;
        }else{
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
            self.headImage.backgroundColor = WhiteColor;
        }
        
    }];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateHighlighted completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            self.headImage.backgroundColor = GreenColor;
        }else{
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
            self.headImage.backgroundColor = WhiteColor;
        }
        
    }];
    
    //    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",model.employee_name,@"发表了评论"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@   %@",model.employee_name,[HQHelper nsdateToTimeNowYear:[model.create_time longLongValue]]];
    self.contentLabel.attributedText = [HQTFTaskDynamicCell attributedStringWithText:model.content font:14.0];
    self.timeLabel.text = [HQHelper nsdateToTimeNowYear:[model.create_time longLongValue]];
    
    CGSize size = [HQTFTaskDynamicCell caculateTextSizeWithText:model.content maxWidth:(SCREEN_WIDTH - Long(95))];
    
    NSInteger type = 0;
    [self.images removeAllObjects];
    if (([[file.file_type lowercaseString] isEqualToString:@"mp3"] || [[file.file_type lowercaseString] isEqualToString:@"amr"])) {// 语音
        type = 1;
//        TFFileModel *file = [[TFFileModel alloc] init];
//        file.file_url = model.fileUrl;
//        file.voiceDuration = model.voiceTime;
        file.employeeId = model.employee_id;
        file.employeeName = model.employee_name;
        file.photograph = model.picture;
//        file.createTime = model.datetime_time;
//        file.file_type = model.fileType;
//        file.file_size = model.fileSize;
//        file.file_name = model.fileName;
        self.voiceUrl = file;
        
        //        [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[model.voiceTime floatValue]/1000 > 60.0 ? 60.0 : [model.voiceTime floatValue]/1000] forState:UIControlStateNormal];
        //        [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[model.voiceTime floatValue]/1000 > 60.0 ? 60.0 : [model.voiceTime floatValue]/1000] forState:UIControlStateHighlighted];
        
        [HQHelper cacheFileWithUrl:file.file_url fileName:file.file_name completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSError *error1;
            
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&error1];
            if (error1) {
                HQLog(@"初始化失败哦");
                return ;
            }
            [HQHelper saveCacheFileWithFileName:file.file_name data:data];
            
            player.numberOfLoops = 0; //不循环
            [player setVolume:1.0];
            [player prepareToPlay];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.model.voiceTime = @(player.duration);
                
                [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",player.duration > 60.0 ? 60.0 : player.duration] forState:UIControlStateNormal];
                [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",player.duration > 60.0 ? 60.0 : player.duration] forState:UIControlStateHighlighted];
            });
            
        } fileHandler:^(NSString *path) {
            
            NSError *error1;
            
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:&error1];
            if (error1) {
                HQLog(@"初始化失败哦");
                return ;
            }
            
            player.numberOfLoops = 0; //不循环
            [player setVolume:1.0];
            [player prepareToPlay];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.model.voiceTime = @(player.duration);
                
                [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",player.duration > 60.0 ? 60.0 : player.duration] forState:UIControlStateNormal];
                [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",player.duration > 60.0 ? 60.0 : player.duration] forState:UIControlStateHighlighted];
            });
        }];
        
    }else if ([[file.file_type lowercaseString] isEqualToString:@"jpg"] || [[file.file_type lowercaseString] isEqualToString:@"png"] || [[file.file_type lowercaseString] isEqualToString:@"gif"]|| [[file.file_type lowercaseString] isEqualToString:@"jpeg"]){// 图片
        type = 2;
        if (file.file_url) {
            [self.images addObject:file.file_url];
        }
    }else if (file.file_type && ![file.file_type isEqualToString:@""]){
        type = 3;
        
//        TFFileModel *file = [[TFFileModel alloc] init];
//        file.file_url = model.fileUrl;
//        file.voiceDuration = model.voiceTime;
        file.employeeName = model.employee_name;
        file.photograph = model.picture;
//        file.createTime = model.datetime_time;
//        file.file_type = model.fileType;
//        file.file_size = model.fileSize;
//        file.file_name = model.fileName;
        self.voiceUrl = file;
    }
    
    switch (type) {
        case 0:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
        case 1:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = NO;
            self.voiceTopH.constant = 10;
            self.vioceH.constant = 30;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
            [self.voiceBtn setImage:[UIImage imageNamed:@"语音气泡"] forState:UIControlStateNormal];
            [self.voiceBtn setImage:[UIImage imageNamed:@"语音气泡"] forState:UIControlStateHighlighted];
            [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[file.voiceTime floatValue]/1000 > 60.0 ? 60 : [file.voiceTime floatValue]/1000] forState:UIControlStateNormal];
            [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[file.voiceTime floatValue]/1000 > 60.0 ? 60 : [file.voiceTime floatValue]/1000] forState:UIControlStateHighlighted];
            [self.voiceBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
            [self.voiceBtn setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
            
            
            
            
        }
            break;
        case 2:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = NO;
            self.collectionTopH.constant = 10;
            self.collectionH.constant = CollectionItemWidth;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
            
        case 3:// 文件
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 10;
            self.fileHeight.constant = 40;
            self.fileView.hidden = NO;
            self.fileName.text = file.file_name;
            self.fileImage.image = [HQHelper file_typeWithFileModel:self.voiceUrl];
            [self.imageView setImage:[HQHelper createImageWithColor:RedColor]];
        }
            break;
            
        default:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
    }
    
    [self.collectionView reloadData];
}
+ (CGFloat)refreshCommentCellHeightWithHybirdModel:(TFTaskHybirdDynamicModel *)model{
//    model.fileType = [model.fileType stringByReplacingOccurrencesOfString:@"." withString:@""];
    TFFileModel *file = model.information.firstObject;
    // 上边距 + 下边距
    CGFloat height = 15 + 15;
    
    height += 15;// title
    
    // 按内容计算高度
    CGSize size = [HQTFTaskDynamicCell caculateTextSizeWithText:model.content maxWidth:(SCREEN_WIDTH - Long(95))];
    
    NSInteger type = 0;
    
    if ([[file.file_type lowercaseString] isEqualToString:@"mp3"] || [[file.file_type lowercaseString] isEqualToString:@"amr"]) {// 语音
        type = 1;
        
    }else if ([[file.file_type lowercaseString] isEqualToString:@"jpg"] || [[file.file_type lowercaseString] isEqualToString:@"png"] || [[file.file_type lowercaseString] isEqualToString:@"gif"]|| [[file.file_type lowercaseString] isEqualToString:@"jpeg"]){// 图片
        type = 2;
    }else if(file.file_type && ![file.file_type isEqualToString:@""]){
        
        type = 3;
    }
    
    
    switch (type) {
        case 0:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
        case 1:
        {
            height += (30 + 10);
        }
            break;
        case 2:
        {
            height += (CollectionItemWidth + 10);
        }
            break;
        case 3:
        {
            height += (40+10);
        }
            break;
            
        default:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
    }
    
    // Time
    //    height += 25;
    
    return height;
    
    
}



/** 刷新任务评论 */
- (void)refreshCommentCellWithTaskDynamicItemModel:(TFTaskDynamicItemModel *)model{
    
    //[self.headImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@发布了评论",model.employeeName];
    self.contentLabel.text = model.commentContent;
    self.timeLabel.text = [HQHelper nsdateToTimeNowYearNowMonthNowDay:[model.createTime longLongValue]];
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.commentContent];
    
    NSInteger type = 0;
    [self.images removeAllObjects];
    if (model.fileUrl && ![model.fileUrl isEqualToString:@""] && ![model.voiceDuration isEqualToNumber:@0]) {// 语音
        type = 1;
        TFFileModel *file = [[TFFileModel alloc] init];
        file.file_url = model.fileUrl;
        file.voiceDuration = model.voiceDuration;
        file.employeeId = model.employeeId;
        file.employeeName = model.employeeName;
        file.photograph = model.photograph;
        file.createTime = model.createTime;
        self.voiceUrl = file;
        
    }else if (model.fileUrl && ![model.fileUrl isEqualToString:@""] && [model.voiceDuration isEqualToNumber:@0]){// 图片
        type = 2;
        [self.images addObject:model.fileUrl];
    }
    
    switch (type) {
        case 0:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
        }
            break;
        case 1:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = NO;
            self.voiceTopH.constant = 10;
            self.vioceH.constant = 30;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %.0f\"",[model.voiceDuration floatValue]] forState:UIControlStateNormal];
            [self.voiceBtn setTitleColor:GrayTextColor forState:UIControlStateNormal];
            
        }
            break;
        case 2:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = NO;
            self.collectionTopH.constant = 10;
            self.collectionH.constant = CollectionItemWidth;
        }
            break;
            
        default:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
        }
            break;
    }
    
    [self.collectionView reloadData];
}

+ (CGFloat)refreshCommentCellHeightWithTaskDynamicItemModel:(TFTaskDynamicItemModel *)model{
    
    // 上边距 + 下边距
    CGFloat height = 15 + 15;
    
    height += 15;// title
    
    // 按内容计算高度
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.commentContent];
    
    NSInteger type = 0;
    
    if (model.fileUrl && ![model.fileUrl isEqualToString:@""] && ![model.voiceDuration isEqualToNumber:@0]) {// 语音
        type = 1;
    }else if (model.fileUrl && ![model.fileUrl isEqualToString:@""] && [model.voiceDuration isEqualToNumber:@0]){// 图片
        type = 2;
    }
    
    
    switch (type) {
        case 0:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
        case 1:
        {
            height += (30 + 10);
        }
            break;
        case 2:
        {
            height += (CollectionItemWidth + 10);
        }
            break;
            
        default:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
    }
    
    // Time
    height += 25;
    
    return height;
}

/** 刷新任务动态 */
- (void)refreshDynamicCellWithTaskDynamicItemModel:(TFTaskLogContentModel *)model{
    
    //[self.headImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.titleLabel.text = @"任务操作动态";
    self.contentLabel.text = model.content;
    self.timeLabel.text = [HQHelper nsdateToTimeNowYearNowMonthNowDay:[model.createTime longLongValue]];
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.content];
    
    self.contentLabel.hidden = NO;
    self.contentTopH.constant = 10;
    self.contentH.constant = size.height;
    self.voiceBtn.hidden = YES;
    self.voiceTopH.constant = 0;
    self.vioceH.constant = 0;
    self.collectionView.hidden = YES;
    self.collectionTopH.constant = 0;
    self.collectionH.constant = 0;
}

+ (CGFloat)refreshDynamicCellHeightWithTaskDynamicItemModel:(TFTaskLogContentModel *)model{
    
    // 上边距 + 下边距
    CGFloat height = 15 + 15;
    
    height += 15;// title
    
    // 按内容计算高度
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.content];
    
    height += (size.height==0?18:size.height + 10);
    
    // Time
    height += 25;
    
    return height;
}



- (void)refreshDynamicCellWithModel:(TFTaskDynamicModel *)model{
    
//    self.taskDynamic = model;
    [self.images removeAllObjects];
    [self.images addObjectsFromArray:model.images];
    //[self.headImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.titleLabel.text = @"张晓天发不了聊天动态";
    self.contentLabel.text = model.dynamicContent;
    self.timeLabel.text = [HQHelper getYearMonthDayHourMiuthWithDate:[NSDate date]];
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.dynamicContent];
    
    NSInteger type = [model.dynamicType integerValue];
    switch (type) {
        case 0:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
        }
            break;
        case 1:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = NO;
            self.voiceTopH.constant = 10;
            self.vioceH.constant = 30;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
        }
            break;
        case 2:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = NO;
            self.collectionTopH.constant = 10;
            self.collectionH.constant = (model.images.count + 2) /3 * CollectionItemWidth + model.images.count/3 * 5;
        }
            break;
            
        default:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
        }
            break;
    }
    
    [self.collectionView reloadData];
}

+ (CGFloat)refreshDynamicCellHeightWithModel:(TFTaskDynamicModel *)model{
    
    // 上边距 + 下边距
    CGFloat height = 15 + 15;
    
    height += 15;// title
    
    // 按内容计算高度
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.dynamicContent];
    
    NSInteger type = [model.dynamicType integerValue];
    
    switch (type) {
        case 0:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
        case 1:
        {
            height += (30 + 10);
        }
            break;
        case 2:
        {
            height += ((model.images.count + 2) /3 * CollectionItemWidth + model.images.count/3 * 5 + 10);
        }
            break;
            
        default:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
    }
    
    // Time
    height += 25;
    
    return height;
    
}


/** 刷新审批评论 */
/*
- (void)refreshApproveCellWithModel:(TFApprovalDynamicModel *)model{
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",model.employeeName,@"发表了评论"];
    self.contentLabel.text = model.talkDatail;
    self.timeLabel.text = [HQHelper nsdateToTimeNowYear:[model.createTime?model.createTime:model.createDate longLongValue]];
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.talkDatail];
    
    NSInteger type = 0;
    [self.images removeAllObjects];
    if ([[model.fileType lowercaseString] isEqualToString:@"mp3"] || [[model.fileType lowercaseString] isEqualToString:@"amr"]) {// 语音
        type = 1;
        TFFileModel *file = [[TFFileModel alloc] init];
        file.fileUrl = model.fileUrl;
        file.voiceDuration = model.voiceTime;
        file.employeeId = model.employeeId;
        file.employeeName = model.employeeName;
        file.photograph = model.photograph;
        file.createTime = model.createDate;
        file.fileType = model.fileType;
        file.fileSize = model.fileSize;
        file.fileName = model.fileName;
        self.voiceUrl = file;
        
    }else if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]){// 图片
        type = 2;
        if (model.fileUrl) {
            [self.images addObject:model.fileUrl];
        }
    }else if (model.fileType && ![model.fileType isEqualToString:@""]){
        type = 3;
        
        TFFileModel *file = [[TFFileModel alloc] init];
        file.fileUrl = model.fileUrl;
        file.voiceDuration = model.voiceTime;
        file.employeeName = model.employeeName;
        file.photograph = model.photograph;
        file.createTime = model.createTime;
        file.fileType = model.fileType;
        file.fileSize = model.fileSize;
        file.fileName = model.fileName;
        self.voiceUrl = file;
    }
    
    switch (type) {
        case 0:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
        case 1:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = NO;
            self.voiceTopH.constant = 10;
            self.vioceH.constant = 30;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
            [self.voiceBtn setImage:[UIImage imageNamed:@"语音气泡"] forState:UIControlStateNormal];
            [self.voiceBtn setImage:[UIImage imageNamed:@"语音气泡"] forState:UIControlStateHighlighted];
            [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %ld\"",[model.voiceTime integerValue]] forState:UIControlStateNormal];
            [self.voiceBtn setTitle:[NSString stringWithFormat:@"  %ld\"",[model.voiceTime integerValue]] forState:UIControlStateHighlighted];
            [self.voiceBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
            [self.voiceBtn setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
        }
            break;
        case 2:
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = NO;
            self.collectionTopH.constant = 10;
            self.collectionH.constant = CollectionItemWidth;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
            
        case 3:// 文件
        {
            self.contentLabel.hidden = YES;
            self.contentTopH.constant = 0;
            self.contentH.constant = 0;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 10;
            self.fileHeight.constant = 40;
            self.fileView.hidden = NO;
            self.fileName.text = model.fileName;
            self.fileImage.image = [HQHelper fileTypeWithFileModel:self.voiceUrl];
        }
            break;
            
        default:
        {
            self.contentLabel.hidden = NO;
            self.contentTopH.constant = 10;
            self.contentH.constant = size.height;
            self.voiceBtn.hidden = YES;
            self.voiceTopH.constant = 0;
            self.vioceH.constant = 0;
            self.collectionView.hidden = YES;
            self.collectionTopH.constant = 0;
            self.collectionH.constant = 0;
            self.fileTop.constant = 0;
            self.fileHeight.constant = 0;
            self.fileView.hidden = YES;
        }
            break;
    }
    
    [self.collectionView reloadData];
    
}
*/
+ (CGFloat)refreshApproveCellHeightWithModel:(TFApprovalDynamicModel *)model{
    
    // 上边距 + 下边距
    CGFloat height = 15 + 15;
    
    height += 15;// title
    
    // 按内容计算高度
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.talkDatail];
    
    NSInteger type = 0;
    
    if ([[model.fileType lowercaseString] isEqualToString:@"mp3"] || [[model.fileType lowercaseString] isEqualToString:@"amr"]) {// 语音
        type = 1;
        
    }else if ([[model.fileType lowercaseString] isEqualToString:@"jpg"] || [[model.fileType lowercaseString] isEqualToString:@"png"] || [[model.fileType lowercaseString] isEqualToString:@"gif"]|| [[model.fileType lowercaseString] isEqualToString:@"jpeg"]){// 图片
        type = 2;
    }else if(model.fileType && ![model.fileType isEqualToString:@""]){
        
        type = 3;
    }
    
    
    switch (type) {
        case 0:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
        case 1:
        {
            height += (30 + 10);
        }
            break;
        case 2:
        {
            height += (CollectionItemWidth + 10);
        }
            break;
        case 3:
        {
            height += (40+10);
        }
            break;
            
        default:
        {
            height += (size.height==0?18:size.height + 10);
        }
            break;
    }
    
    // Time
    height += 25;
    
    return height;
    

}
/** 刷新审批动态   */
- (void)refreshApproveCellWithLogModel:(TFApprovalLogModel *)model{
    
    //[self.headImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.titleLabel.text = @"审批操作动态";
    self.contentLabel.text = model.operationContent;
    self.timeLabel.text = [HQHelper nsdateToTimeNowYearNowMonthNowDay:[model.createTime longLongValue]];
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.operationContent];
    
    self.contentLabel.hidden = NO;
    self.contentTopH.constant = 10;
    self.contentH.constant = size.height;
    self.voiceBtn.hidden = YES;
    self.voiceTopH.constant = 0;
    self.vioceH.constant = 0;
    self.collectionView.hidden = YES;
    self.collectionTopH.constant = 0;
    self.collectionH.constant = 0;
    
}


+ (CGFloat)refreshApproveCellHeightWithLogModel:(TFApprovalLogModel *)model{
    
    // 上边距 + 下边距
    CGFloat height = 15 + 15;
    
    height += 15;// title
    
    // 按内容计算高度
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){(SCREEN_WIDTH - Long(95)),MAXFLOAT} titleStr:model.operationContent];
    
    height += (size.height + 10);
    
    // Time
    height += 25;
    
    return height;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
