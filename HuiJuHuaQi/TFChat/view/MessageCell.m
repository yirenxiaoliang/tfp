//
//  MessageCell.m
//  ChatTest
//
//  Created by Season on 2017/5/16.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "MessageCell.h"
#import "TFIMContentData.h"
#import "PubMethods.h"
#import "FileManager.h"
#import <WebKit/WebKit.h>

#import <MediaPlayer/MediaPlayer.h>

#define imgWidth 100
#define imgHeight 135
@interface MessageCell ()

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *name;

//是否显示时间
@property (nonatomic, strong) NSNumber *isShowTime;

@property (nonatomic, strong) TFFMDBModel *dbModel;

@property (nonatomic, strong) UILabel *readLab;

@property (nonatomic, strong) UIView *documentsView;

//语音时长
@property (nonatomic, strong) UILabel *voiceTimeLab;


@property (nonatomic, strong) UILabel *fileNameLab;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UIImageView *pictureImg;

@property (nonatomic, strong) UILabel *sizeLab;

@property (nonatomic, strong) UIActivityIndicatorView *acview;

@property (nonatomic, strong) UIButton *unsendButton;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MessageCell
{
    YYLabel *msgLabel;
    UIButton *playBtn; //播放按钮
    
    UIButton *headImage;
    
    int64_t user;
    
    NSString *chatContent;
    
    NSString *videoUrl;
    
}


- (TFFMDBModel *)dbModel {

    if (!_dbModel) {
        
        _dbModel = [[TFFMDBModel alloc] init];
    }
    return _dbModel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (instancetype)messageCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)initSubviews {
    
    self.contentView.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    
    // 1、创建时间
    self.labelTime = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xFFFFFF) titleFont:12 bgColor:kUIColorFromRGB(0xC2C2C2)];
    self.labelTime.layer.cornerRadius = 5.0;
    self.labelTime.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.labelTime];
    
    
    // 气泡框
    UIImage *image = [UIImage imageNamed:@"Group 3"];
    self.boxImage = [[UIImageView alloc]initWithImage:image];
    self.boxImage.userInteractionEnabled = YES;
    [self.contentView addSubview:self.boxImage];
    self.boxImage.contentMode = UIViewContentModeScaleToFill;
    
    UITapGestureRecognizer *tapVoice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)];
    
    [self.boxImage addGestureRecognizer:tapVoice];
    
    
    //发送失败按钮
    self.unsendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.unsendButton.userInteractionEnabled = YES;
    [self.unsendButton setImage:IMG(@"wechat_resendbut5") forState:UIControlStateNormal];
    [self.unsendButton addTarget:self action:@selector(reSendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.unsendButton];
    
    
    //语音时长
    self.voiceTimeLab = [[UILabel alloc] init];
    
    self.voiceTimeLab.textAlignment = NSTextAlignmentRight;
    self.voiceTimeLab.font = FONT(12);
    self.voiceTimeLab.textColor = kUIColorFromRGB(0xC2C2C2);
    
    [self addSubview:self.voiceTimeLab];
    
    //内容
    msgLabel = [YYLabel new];
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.numberOfLines = 0;
    msgLabel.userInteractionEnabled = YES;
    msgLabel.tag = 100;
    [self.boxImage addSubview:msgLabel];
    
    UITapGestureRecognizer *msgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(masTapAction:)];
    
    [msgLabel addGestureRecognizer:msgTap];
    
    UILongPressGestureRecognizer *lo = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];

    [msgLabel addGestureRecognizer:lo];
    
    /*******       文件        *******/
    self.documentsView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.documentsView.userInteractionEnabled = YES;
    self.documentsView.tag = 103;
    [self.boxImage addSubview:_documentsView];
    
    //长按文件
    UILongPressGestureRecognizer *fileLong = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [self.documentsView addGestureRecognizer:fileLong];
    
    //点击文件
    UITapGestureRecognizer *fileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushFile)];
    
    [_documentsView addGestureRecognizer:fileTap];
    
    _pictureImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    
    [_documentsView addSubview:_pictureImg];
    
    
    
    _fileNameLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xA9A9A9) titleFont:12 bgColor:ClearColor];
    _fileNameLab.textAlignment = NSTextAlignmentLeft;
    
    [_documentsView addSubview:_fileNameLab];
    
    
    
    _nameLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xA9A9A9) titleFont:10 bgColor:ClearColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    
    [_documentsView addSubview:_nameLab];
    
    
    
    _sizeLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xA9A9A9) titleFont:10 bgColor:ClearColor];
    _sizeLab.textAlignment = NSTextAlignmentLeft;
    
    [_documentsView addSubview:_sizeLab];
    
   

    
    /*******               *******/
    
    //已读未读
    self.readLab = [[UILabel alloc] init];
    
    self.readLab.textAlignment = NSTextAlignmentRight;
    self.readLab.font = FONT(14);
    
    [self addSubview:self.readLab];
    
    UITapGestureRecognizer *read = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readPeoples)];
    
    read.numberOfTapsRequired = 1;
    
    [self.readLab addGestureRecognizer:read];
    
    
    // 头像
    headImage = [UIButton buttonWithType:UIButtonTypeCustom];
    headImage.frame = CGRectMake(SCREEN_WIDTH-40, 15, 30, 30);
    headImage.tag = 102;
    headImage.userInteractionEnabled = YES;
    [self.contentView addSubview:headImage];
    
    UILongPressGestureRecognizer *headLong = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [headImage addGestureRecognizer:headLong];
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction:)];
    headTap.numberOfTapsRequired = 1;
    [headImage addGestureRecognizer:headTap];
    
    //名字
    self.userName = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
    
    [self.contentView addSubview:self.userName];
    
    // 图片消息
    _preView = [[UIImageView alloc]init];
    _preView.layer.cornerRadius = 4.0;
    _preView.layer.masksToBounds = YES;
    _preView.contentMode = UIViewContentModeScaleAspectFill;
    [self.boxImage addSubview:_preView];
    
    // 图片消息
    _photo = [[UIImageView alloc]init];
    _photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviewPhoto:)];
    [_photo addGestureRecognizer:tap];
    _photo.layer.cornerRadius = 4.0;
    _photo.layer.masksToBounds = YES;
    _photo.contentMode = UIViewContentModeScaleAspectFill;
    _photo.tag = 101;
    [self.boxImage addSubview:_photo];
    
    UILongPressGestureRecognizer *lon = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];

    [_photo addGestureRecognizer:lon];
    
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"mplay"] forState:UIControlStateNormal];
    playBtn.tag = 105;
    [self.boxImage addSubview:playBtn];
    
    [playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *playLong = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [playBtn addGestureRecognizer:playLong];
    
}

- (void)playAudio {

    if ([self.chatFileType isEqualToNumber:@3]) {
        
        if ([self.delegate respondsToSelector:@selector(playVoice:imageView:)]) {
            
            [self.delegate playVoice:self.dbModel imageView:self.boxImage];
        }
    }
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressRecognizer {

    [self becomeFirstResponder];

    //2.设置UIMenuController
    UIMenuController * menu = [UIMenuController sharedMenuController];
    
    if (longPressRecognizer.view.tag == 100) { //文本消息
        
        if (user == [UM.userLoginInfo.employee.sign_id  integerValue]) { //发送的
            
            if ([self.dbModel.clientTimes longLongValue]+1000*60*2 >= [HQHelper getNowTimeSp]) {
                
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(revoke:)];
                UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(burn:)];
                UIMenuItem * item3 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
                
                menu.menuItems = @[item1,item2,item3];
            }
            else {
            
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(burn:)];
                UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
                
                menu.menuItems = @[item1,item2];
            }
            
        }
        else { //接收的
            
            UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(burn:)];
            UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
            
            menu.menuItems = @[item1,item2];
        }
        
        NSLog(@"%d",menu.isMenuVisible);
        //当长按label的时候，这个方法会不断调用，menu就会出现一闪一闪不断显示，需要在此处进行判断
        if (menu.isMenuVisible)return;
        /**
         *  设置UIMenuController的显示相关信息
         *
         *  @param targetRect UIMenuController 需要指向的矩形框
         *  @param targetView targetRect会以targetView的左上角为坐标原点进行显示
         */
        [menu setTargetRect:msgLabel.bounds inView:msgLabel];
        
    }
    else if (longPressRecognizer.view.tag == 101) { //图片消息
    
        if (user == [UM.userLoginInfo.employee.sign_id  integerValue]) { //发送的
            
            if ([self.dbModel.clientTimes longLongValue]+1000*60*2 >= [HQHelper getNowTimeSp]) { //两分钟之内
            
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(revoke:)];
                UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
                
                menu.menuItems = @[item1,item2];
            }
            else {
            
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
                
                menu.menuItems = @[item1];
            }
            
            
            
        }
        else { //接收的
            
            UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
            
            menu.menuItems = @[item1];
        }
        
        NSLog(@"%d",menu.isMenuVisible);
        //当长按label的时候，这个方法会不断调用，menu就会出现一闪一闪不断显示，需要在此处进行判断
        if (menu.isMenuVisible)return;
        /**
         *  设置UIMenuController的显示相关信息
         *
         *  @param targetRect UIMenuController 需要指向的矩形框
         *  @param targetView targetRect会以targetView的左上角为坐标原点进行显示
         */
        [menu setTargetRect:_photo.bounds inView:_photo];
        
    }

    else if (longPressRecognizer.view.tag == 103) { //文件
    
        if (user == [UM.userLoginInfo.employee.sign_id  integerValue]) { //发送的
            
            if ([self.dbModel.clientTimes longLongValue]+1000*60*2 >= [HQHelper getNowTimeSp]) { //两分钟之内
                
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(revoke:)];
                UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
                
                menu.menuItems = @[item1,item2];
            }
            else {
                
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
                
                menu.menuItems = @[item1];
            }
            
        }
        else { //接收的
            
            UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
            
            menu.menuItems = @[item1];
        }
        
        if (menu.isMenuVisible)return;
        /**
         *  设置UIMenuController的显示相关信息
         *
         *  @param targetRect UIMenuController 需要指向的矩形框
         *  @param targetView targetRect会以targetView的左上角为坐标原点进行显示
         */
        [menu setTargetRect:self.documentsView.bounds inView:self.documentsView];

    }
    else if (longPressRecognizer.view.tag == 104) {
    
        NSLog(@"长按语音...");
        if (user == [UM.userLoginInfo.employee.sign_id  integerValue]) { //发送的
            
            if ([self.dbModel.clientTimes longLongValue]+1000*60*2 >= [HQHelper getNowTimeSp]) { //两分钟之内
                
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(revoke:)];
                
                menu.menuItems = @[item1];
            }
            else {
            
                menu.menuItems = @[];
            }


        }
        else {
        
            
            menu.menuItems = @[];
        }
        
        if (menu.isMenuVisible)return;
        
        [menu setTargetRect:self.boxImage.bounds inView:self.boxImage];

    }
    else if (longPressRecognizer.view.tag == 105) { //视频
        
        if (user == [UM.userLoginInfo.employee.sign_id  integerValue]) { //发送的
            
            if ([self.dbModel.clientTimes longLongValue]+1000*60*2 >= [HQHelper getNowTimeSp]) { //两分钟之内
                
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(revoke:)];
                UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
                
                menu.menuItems = @[item1,item2];
            }
            else {
                
                UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
                
                menu.menuItems = @[item1];
            }
            
        }
        else { //接收的
            
            UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(transitive:)];
            
            menu.menuItems = @[item1];
        }
        
        if (menu.isMenuVisible)return;
        /**
         *  设置UIMenuController的显示相关信息
         *
         *  @param targetRect UIMenuController 需要指向的矩形框
         *  @param targetView targetRect会以targetView的左上角为坐标原点进行显示
         */
        [menu setTargetRect:self.documentsView.bounds inView:self.documentsView];
        
    }
    
    else {
    
        if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
            
            if ([self.dbModel.chatType isEqualToNumber:@1]) { //群聊才能@
                
                if (![self.dbModel.senderID isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                    
                    if ([self.delegate respondsToSelector:@selector(longPressAT:)]) {
                        
                        [self.delegate longPressAT:self.dbModel];
                    }
                }
                
            }
            
        }else if (longPressRecognizer.state == UIGestureRecognizerStateEnded){
            // do something
        }


    }
    
    [menu setMenuVisible:YES animated:YES];


}

//点击头像
- (void)headTapAction:(UITapGestureRecognizer *)recognizer {

    if ([self.delegate respondsToSelector:@selector(headImgClicked:)]) {
        
        [self.delegate headImgClicked:self.dbModel];
    }
}

//重发信息
- (void)reSendAction:(UIButton *)button {

    if ([self.delegate respondsToSelector:@selector(reSendMessage:)]) {
        
        [self.delegate reSendMessage:self.dbModel];
    }
}

#pragma mark 长按系列方法
//撤回
- (void)revoke:(UIMenuController *)menu {
    
    if ([self.delegate respondsToSelector:@selector(revokeMessage:)]) {
        
        [self.delegate revokeMessage:self.dbModel];
    }
}

//复制
- (void)burn:(UIMenuController *)menu {

    
    
    if ([self.delegate respondsToSelector:@selector(copyMessage:)]) {
        
        [self.delegate copyMessage:msgLabel];
    }
}

//转发
- (void)transitive:(UIMenuController *)menu {
    
    if ([self.delegate respondsToSelector:@selector(transitiveMessage:)]) {
        
        [self.delegate transitiveMessage:self.dbModel];
    }
}

#pragma mark 计算方法
/** 计算文本size，当文本小于最大宽度时返回本身的宽度 */
+ (CGSize)caculateTextSizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth{
    
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = maxSize;
    container.maximumNumberOfRows = 0;
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:[MessageCell attributedStringWithText:text font:16]];
    
    CGFloat textW = layout.textBoundingSize.width > maxSize.width ? maxSize.width : layout.textBoundingSize.width;
    
    
    return CGSizeMake(textW, layout.textBoundingSize.height);
    
}

/** 普通文本转成带表情的属性文本 */
+ (NSAttributedString *)attributedStringWithText:(NSString *)text font:(CGFloat)font{
    
    return [LiuqsDecoder decodeWithPlainStr:text font:[UIFont systemFontOfSize:font]];
}

#pragma mark - 对控件权限进行设置
/**
 *  设置label可以成为第一响应者
 *
 *  @注意：不是每个控件都有资格成为第一响应者
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/**
 *  设置label能够执行那些具体操作
 *
 *  @param action 具体操作
 *
 *  @return YES:支持该操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if(action == @selector(revoke:) || action == @selector(burn:) || action == @selector(transitive:)) return YES;
    
    return NO;
}


- (void)refreshCell:(TFFMDBModel *)model {
    

    _dbModel = model;
    
    chatContent = [model.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    user = [model.senderID integerValue];
    
    self.chatFileType = model.chatFileType;
    
    if (_dbModel.clientTimes <= 0) {
        
        _dbModel.clientTimes = @([HQHelper getNowTimeSp]);
    }
    
    videoUrl = model.videoUrl;
    
    self.avatar = model.senderAvatarUrl;
    
    self.name = model.senderName;
    
    self.isShowTime = model.showTime;
    
    [self setNeedsLayout];
}

- (void)readPeoples {

    if ([self.delegate respondsToSelector:@selector(readedPeoples:)]) {
        
        [self.delegate readedPeoples:_dbModel];
    }
}

/**
 查看图片
 */
- (void)reviewPhoto:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(previewImg:model:)]) {
        
        [self.delegate previewImg:(UIImageView *)tap.view model:_dbModel];
    }
}


/**
 播放小视频
 */
- (void)playAction {
    
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[HQHelper stringForMD5WithString:videoUrl]];
    
    [HQHelper cacheFileWithUrl:videoUrl fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        if (error == nil) {
           
            // 保存文件
            NSString *filePath = [HQHelper saveCacheFileWithFileName:fileName data:data];
            
            if (filePath) {// 写入成功
    
                AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
                //2、创建视频播放视图的控制器
                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
                //3、将创建的AVPlayer赋值给控制器自带的player
                playerVC.player = player;
                //4、跳转到控制器播放
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVC animated:YES completion:nil];
                [playerVC.player play];
                
            }
        }else{
            [MBProgressHUD showError:@"读取文件失败" toView:KeyWindow];
        }
        
    } fileHandler:^(NSString *path) {
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
        //2、创建视频播放视图的控制器
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
        //3、将创建的AVPlayer赋值给控制器自带的player
        playerVC.player = player;
        //4、跳转到控制器播放
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVC animated:YES completion:nil];
        [playerVC.player play];
        
    }];

}

//点击文件
- (void)pushFile {

    if ([self.delegate respondsToSelector:@selector(chatFileClicked:)]) {
        
        [self.delegate chatFileClicked:self.dbModel];
    }
}

#pragma mark 图片处理

- (void)setImageLayer:(UIImageView *)imageView {

    CALayer *lay = [[CALayer alloc] init];
//    lay.name = @"layer";
    // 设置图层显示的内容为拉伸过的MaskImgae
    lay.contents = (__bridge id _Nullable)([imageView.image CGImage]);
    // 设置拉伸范围(注意：这里contentsCenter的CGRect是比例（不是绝对坐标）)
    lay.contentsCenter = [self CGRectCenterRectForResizableImage:imageView.image];
    // 设置图层大小与chatImgView相同
    lay.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    // 设置比例
    lay.contentsScale = [UIScreen mainScreen].scale;
    // 设置不透明度
    lay.opacity = 1;
    // 设置裁剪范围
    imageView.layer.mask = lay;
    // 设置裁剪掉超出的区域
    imageView.layer.masksToBounds = YES;
}

//比例
- (CGRect)CGRectCenterRectForResizableImage:(UIImage *)image {
    
    return CGRectMake(image.capInsets.left/image.size.width, image.capInsets.top/image.size.height, (image.size.width - image.capInsets.right - image.capInsets.left)/image.size.width, (image.size.height - image.capInsets.bottom - image.capInsets.top)/image.size.height);
    
    
}

- (void)fileFormat:(TFFMDBModel *)model {

    model.fileSuffix = [model.fileSuffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([[model.fileSuffix lowercaseString] isEqualToString:@"jpg"] ||[[model.fileSuffix lowercaseString] isEqualToString:@"jpeg"] ||[[model.fileSuffix lowercaseString] isEqualToString:@"png"] ||[[model.fileSuffix lowercaseString] isEqualToString:@"gif"]) {
        

//        NSString *pictureUrl = [NSString stringWithFormat:@"%@&width=35",model.fileUrl];
//        NSLog(@"pictureUrl:%@",pictureUrl);
        [self.pictureImg sd_setImageWithURL:[HQHelper URLWithString:model.fileUrl] placeholderImage:IMG(@"未知文件")];
    }
    
    else if ([[model.fileSuffix lowercaseString] isEqualToString:@"mp3"]){// 语音
        
        //        [self.pictureImg setImage:[UIImage imageNamed:@"mp3"]];
        self.pictureImg.image = IMG(@"mp3");
        
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"mp4"] ||
              [[model.fileSuffix lowercaseString] isEqualToString:@"mov"]){// 语音
        
        //        [self.pictureImg setImage:[UIImage imageNamed:@"mp3"]];
        self.pictureImg.image = IMG(@"mp4");
        
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"doc"] || [[model.fileSuffix lowercaseString] isEqualToString:@"docx"]){// doc
        
        self.pictureImg.image = IMG(@"doc");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"xls"] || [[model.fileSuffix lowercaseString] isEqualToString:@"xlsx"]){// xls
        
        self.pictureImg.image = IMG(@"xls");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"ppt"] || [[model.fileSuffix lowercaseString] isEqualToString:@"pptx"]){// ppt
        
        self.pictureImg.image = IMG(@"ppt");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"ai"]){// ai
        
        self.pictureImg.image = IMG(@"ai");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"cdr"]){// cdr
        
        self.pictureImg.image = IMG(@"cdr");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"dwg"]){// dwg
        
        self.pictureImg.image = IMG(@"dwg");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"ps"]){// ps
        
        self.pictureImg.image = IMG(@"ps");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"pdf"]){// pdf
        
        self.pictureImg.image = IMG(@"pdf");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"txt"]){// txt
        
        self.pictureImg.image = IMG(@"txt");
        
    }else if ([[model.fileSuffix lowercaseString] isEqualToString:@"zip"] ||
              [[model.fileSuffix lowercaseString] isEqualToString:@"rar"]){// zip
        
        self.pictureImg.image = IMG(@"zip");
        
    }else{
        
        self.pictureImg.image = IMG(@"未知文件");
        
    }
    
    _fileNameLab.text = _dbModel.fileName;
    _nameLab.text = _dbModel.senderName;
    _sizeLab.text = [HQHelper fileSizeForKB:[_dbModel.fileSize integerValue]];

}

- (BOOL)isURL:(NSString *)url {
    if(url.length < 1)
        return NO;
    if (url.length>4 && [[url substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",url];
    } else {
        url = url;
    }
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    
    return [urlTest evaluateWithObject:url];
}

- (NSArray*)getURLFromStr:(NSString *)string {
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                options:0
                                                  range:NSMakeRange(0, [string length])];
    
    //NSString *subStr;
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch;
        substringForMatch = [string substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    return arr;
}

- (void)needHightText:(NSString *)wholeText {
    
    //    点击事件用的YYLabel框架，
//    YYLabel *mainLabel = [[YYLabel alloc]initWithFrame:CGRectMake(0, 100, 400, 100)];
//    [self addSubview:mainLabel];
//
//    mainLabel.numberOfLines = 0;
//    mainLabel.textColor = [UIColor purpleColor];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:wholeText];
    text.yy_font = [UIFont systemFontOfSize:16];
    NSError *error;
    NSDataDetector *dataDetector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *arrayOfAllMatches=[dataDetector matchesInString:wholeText options:NSMatchingReportProgress range:NSMakeRange(0, wholeText.length)];
    //NSMatchingOptions匹配方式也有好多种，我选择NSMatchingReportProgress，一直匹配
    
    //我们得到一个数组，这个数组中NSTextCheckingResult元素中包含我们要找的URL的range，当然可能找到多个URL，找到相应的URL的位置，用YYlabel的高亮点击事件处理跳转网页
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        
        NSLog(@"%@",NSStringFromRange(match.range));
        [text yy_setTextHighlightRange:match.range//设置点击的位置
                                 color:GreenColor
                       backgroundColor:[UIColor whiteColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 NSLog(@"这里是点击事件");
                                 //跳转用的WKWebView
                                 WKWebView *webView = [[WKWebView alloc] initWithFrame:self.bounds];
                                 [self addSubview:webView];
                                 [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[wholeText substringWithRange:match.range]]]];
                                 
                             }];
    }
    msgLabel.userInteractionEnabled = YES;
    msgLabel.attributedText = text;
}

- (void)masTapAction:(UITapGestureRecognizer *)tap {
    
    NSString *URL;
    NSArray *urlArr = [NSArray array];
    if([self isURL:chatContent]) {
        URL = chatContent;
    } else {
        urlArr = [self getURLFromStr:chatContent];
        if (urlArr.count>0) {
            
            URL = urlArr[0];
        }
        
    }
    
    if (URL) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
    }
}

- (void)timerAction {
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [DataBaseHandle queryRecodeWithChatId:_dbModel.chatId];
        
        if ([_dbModel.isRead isEqualToNumber:@2]) {
            
            _dbModel.isRead = @3;
            
            [DataBaseHandle updateChatRoomReadStateWithData:_dbModel];
            
            HQLog(@"发送失败...");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendFailedNotification" object:_dbModel];
            
            [self.timer invalidate];
        }
    });
    
}

/* cell的高度 */
+ (CGFloat)refreshHeightCellWithModel:(TFFMDBModel *)model{
    CGFloat height = 0;
    
    if ([model.chatFileType isEqualToNumber:@1]) {// 文本消息
        
        // 根据文字内容计算宽高
        height = [self caculateTextSizeWithText:model.content maxWidth:SCREEN_WIDTH-106-63-23].height;
        
        if (height < 30) {
            
            if ([model.senderID longLongValue] == [UM.userLoginInfo.employee.sign_id longLongValue]) {// 自己发的
                
                if ([model.showTime isEqualToNumber:@1]) {
                    
                    return  60+30;
                }else{
                    
                    return  60+0;
                }
            }else{// 别人发的
                
                if ([model.showTime isEqualToNumber:@1]) {
                    
                    return  60+50;
                }else{
                    
                    return  60+20;
                }
            }
        }
        else{
            
            if ([model.senderID longLongValue] == [UM.userLoginInfo.employee.sign_id longLongValue]) {// 自己发的
                
                if ([model.showTime isEqualToNumber:@1]) {
                    return height + 35 + 30;
                }else{
                    
                    return height + 35 + 0;
                }
            }else{
                
                if ([model.showTime isEqualToNumber:@1]) {
                    return height + 35 + 50;
                }else{
                    
                    return height + 35 + 20;
                }
            }
        }
    }
    else if ([model.chatFileType isEqualToNumber:@2] || [model.chatFileType isEqualToNumber:@5]) {// 图片及小视频
        
        if ([model.senderID longLongValue] == [UM.userLoginInfo.employee.sign_id longLongValue]) {// 自己发的
            
            if ([model.showTime isEqualToNumber:@1]) {
                
                return 100+65+20;
            }else{
                return 100+65+0;
            }
        }else{
            
            if ([model.showTime isEqualToNumber:@1]) {
                return 100+65+20+20;
            }else{
                return 100+65+20+0;
            }
        }
    }
    else if ([model.chatFileType isEqualToNumber:@3]) {// 语音
        
        if ([model.senderID longLongValue] == [UM.userLoginInfo.employee.sign_id longLongValue]) {// 自己发的
            
            if ([model.showTime isEqualToNumber:@1]) {
                
                return 38 + 25 + 30;
            }else{
                return 38 + 25;
            }
        }else{
            if ([model.showTime isEqualToNumber:@1]) {
                
                return 38 + 25 + 20 + 30;
            }else{
                return 38 + 25 + 20;
            }
        }
    }
    else if ([model.chatFileType isEqualToNumber:@4]) {// 文件
        
        if ([model.senderID longLongValue] == [UM.userLoginInfo.employee.sign_id longLongValue]) {// 自己发的
            
            if ([model.showTime isEqualToNumber:@1]) {
                
                return 62+20+30;
            }else{
                return 62+20;
            }
        }else{
            
            if ([model.showTime isEqualToNumber:@1]) {
                return 62+40+30;
            }else{
                return 62+40;
            }
        }
    }
    else if ([model.chatFileType isEqualToNumber:@7]) {// 提示
        
        // 根据文字内容计算宽高
        height = [HQHelper calculateStringWithAndHeight:model.content cgsize:CGSizeMake(SCREEN_WIDTH-126, MAXFLOAT) wordFont:FONT(12)].height;
        
        
        if ([model.showTime isEqualToNumber:@1]) {
            
        }else{
            
        }
        if (height < 20) {
            
            return 90;
        }
        
        return height+80;
    }
    
    
    return height;
}

#pragma mark 刷新视图
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.boxImage.layer.mask = nil;
    
    //计算内容宽高
    CGSize conSize = [MessageCell caculateTextSizeWithText:chatContent maxWidth:SCREEN_WIDTH-106-63-23];
    
    //聊天时间显示
    self.labelTime.text = [JCHATStringUtils getFriendlyDateString:[_dbModel.clientTimes longLongValue] forConversation:NO];
    
    CGSize labSize = [HQHelper sizeWithFont:FONT(12) maxSize:CGSizeMake(SCREEN_WIDTH-160, MAXFLOAT) titleStr:self.labelTime.text];
    
    self.labelTime.frame = CGRectMake((SCREEN_WIDTH-labSize.width+14)/2, 10, labSize.width+14, 20);
    
    //是否显示时间
    if ([self.isShowTime isEqualToNumber:@0]) {
        
        self.labelTime.hidden = YES;
        self.labelTime.height = 0;
        self.labelTime.y = 0;
    }
    else {
    
        self.labelTime.hidden = NO;
        self.labelTime.height = 20;
        self.labelTime.y = 10;
    }
    
    //名字
    self.userName.text = self.name;
    self.userName.hidden = NO;
    headImage.hidden = NO;
    //头像
    
    
//    [headImage sd_setImageWithURL:[HQHelper URLWithString:self.avatar] placeholderImage:PlaceholderHeadImage];
    if (![self.avatar isEqualToString:@""]) {
        
        [headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:self.avatar] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (!image) {
                
                [headImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
                [headImage setTitle:[HQHelper nameWithTotalName:self.name] forState:UIControlStateNormal];
                [headImage setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
                [headImage setBackgroundColor:GreenColor];
            }else{
                [headImage setTitle:@"" forState:UIControlStateNormal];
            }
            
        }];
    }
    else {
        
        [headImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [headImage setTitle:[HQHelper nameWithTotalName:self.name] forState:UIControlStateNormal];
        [headImage setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [headImage setBackgroundColor:GreenColor];
    }


    
    self.acview.hidden = YES;
    self.unsendButton.hidden = YES;
    
    self.boxImage.tag = 0x789;
    
    //语音类型气泡可操作
//    if ([self.chatFileType isEqualToNumber:@3]) {
//        
//        self.boxImage.userInteractionEnabled = YES;
//    }
//    else {
//    
//        self.boxImage.userInteractionEnabled = NO;
//    }
    
    
    
#pragma mark 自己发的信息
    //自己发的
    if (user == [UM.userLoginInfo.employee.sign_id  integerValue]) {
        
//        HQEmployModel *empModel= [HQHelper getEmployeeWithSignId:UM.userLoginInfo.employee.sign_id];

//        [headImage sd_setImageWithURL:[HQHelper URLWithString:empModel.photograph] placeholderImage:PlaceholderHeadImage];
        
//        if (![empModel.photograph isEqualToString:@""]) {
//
//            [headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:empModel.photograph] forState:UIControlStateNormal];
//            [headImage setTitle:@"" forState:UIControlStateNormal];
//        }
//        else {
//
//            [headImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
//            [headImage setTitle:[HQHelper nameWithTotalName:empModel.employee_name] forState:UIControlStateNormal];
//            [headImage setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
//            [headImage setBackgroundColor:GreenColor];
//        }
        
        self.readLab.hidden = NO;
        
        //头像
        [headImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.labelTime.mas_bottom).offset(10);
            make.width.height.equalTo(@40);
        }];
        //昵称
        self.userName.hidden = YES;
        [self.userName mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(headImage.mas_left).offset(-12);
            make.bottom.equalTo(self.boxImage.mas_top).offset(-3);
            
            make.height.equalTo(@0);
        }];
        
        /************ 文本消息 ************/
        if ([self.chatFileType isEqualToNumber:@1]) {
            
            _preView.hidden = YES;
            _photo.hidden = YES;
            playBtn.hidden = YES;
            _voiceTimeLab.hidden = YES;
            msgLabel.hidden = NO;
            _documentsView.hidden = YES;

            
            //气泡
            self.boxImage.image = IMG(@"Group 3");
            
            CGFloat width;
            CGFloat height;
            
            if (conSize.width+23<50) {
                
                width = 50;
            }
            else {
            
                width = conSize.width+23;
            }
            
            if (conSize.height+16<38) {
                height = 38;
            }
            else {
                
                height = conSize.height+16;
            }
            
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(headImage.mas_left).offset(-8);
                make.top.equalTo(headImage.mas_top);
                make.width.equalTo(@(width));
                make.height.equalTo(@(height));
                
            }];
            
            if (self.boxImage.width < 50) {
                
                self.boxImage.width = 50;
                self.boxImage.x = SCREEN_WIDTH - 63 - 50;

            }

            self.boxImage.contentMode = UIViewContentModeScaleToFill;
            //内容
//            [self needHightText:chatContent];
            msgLabel.attributedText = [MessageCell attributedStringWithText:chatContent font:16];
            NSString *URL;
            NSArray *urlArr = [NSArray array];
            if([self isURL:chatContent]) {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:msgLabel.attributedText];
                NSRange range1 = [[str string] rangeOfString:chatContent];
                [str addAttribute:NSForegroundColorAttributeName value:GreenColor range:range1];
                [str addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(0, str.length)];
                msgLabel.attributedText = str;
            } else {
                urlArr = [self getURLFromStr:chatContent];
                if (urlArr.count>0) {
                    
                    URL = urlArr[0];
                    
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:msgLabel.attributedText];
                    NSRange range1 = [[str string] rangeOfString:URL];
                    [str addAttribute:NSForegroundColorAttributeName value:GreenColor range:range1];
                    
                    [str addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(0, str.length)];
                    msgLabel.attributedText = str;
                }
                
            }
            
            [msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@8);
                make.top.equalTo(@10);
                make.width.equalTo(@(conSize.width));
                make.height.equalTo(@(conSize.height+2));
                
            }];
            
            [self.readLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(self.boxImage.mas_left).offset(-10);
                make.bottom.equalTo(self.boxImage.mas_bottom);
                make.height.equalTo(@20);
                make.width.equalTo(@85);
            }];

        }
        
        /************* 图片消息 ************/
        else if ([self.chatFileType isEqualToNumber:@2]) {
        
            self.voiceTimeLab.hidden = YES;
            msgLabel.hidden = YES;
            _preView.hidden = NO;
            _photo.hidden = NO;
            playBtn.hidden = YES;
            _documentsView.hidden = YES;
            
            _preView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
            _photo.frame = CGRectMake(0, 0, imgWidth-8, imgHeight);
            playBtn.frame = _photo.frame;
            
            //气泡
            self.boxImage.image = IMG(@"Group 3");
            //气泡
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(headImage.mas_left).offset(-8);
                make.top.equalTo(headImage.mas_top);
                make.width.equalTo(@(imgWidth));
                make.height.equalTo(@(imgHeight));
                
            }];
            
            //裁剪
            [self setImageLayer:self.boxImage];
            
            [_preView sd_setImageWithURL:[HQHelper URLWithString:chatContent] placeholderImage:nil];
            [_photo sd_setImageWithURL:[HQHelper URLWithString:chatContent] placeholderImage:nil];
            
            [self.readLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(self.boxImage.mas_left).offset(-10);
                make.bottom.equalTo(self.boxImage.mas_bottom);
                make.height.equalTo(@20);
                make.width.equalTo(@85);
            }];
            
        }
        
        /************* 语音消息 ************/
        else if ([self.chatFileType isEqualToNumber:@3]) {
        
            _preView.hidden = YES;
            _photo.hidden = YES;
            playBtn.hidden = YES;
            msgLabel.hidden = YES;
            _documentsView.hidden = YES;
            
            self.voiceTimeLab.hidden = NO;
            
            //语音时长显示
            
            self.voiceTimeLab.text = [NSString stringWithFormat:@"%@''",self.dbModel.voiceDuration];
            
            self.boxImage.image = IMG(@"语音气泡3");
            
            //进行动画效果的3张图片（按照播放顺序放置）
            self.boxImage.animationImages = [NSArray arrayWithObjects:
                                             IMG(@"语音气泡1"),
                                             IMG(@"语音气泡2"),
                                             IMG(@"语音气泡3"),nil];
            //设置动画间隔
            self.boxImage.animationDuration = 1;
            self.boxImage.animationRepeatCount = 0;
            self.boxImage.backgroundColor = [UIColor clearColor];
            
            
            self.boxImage.tag = 104;
            UILongPressGestureRecognizer *lon = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            
            [self.boxImage addGestureRecognizer:lon];
            
            
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(headImage.mas_left).offset(-8);
                make.top.equalTo(headImage.mas_top);
                make.width.equalTo(@(imgWidth));
                make.height.equalTo(@40);
            }];
            
            [self.voiceTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(self.boxImage.mas_left).offset(-8);
                make.centerY.equalTo(self.boxImage.mas_centerY).offset(0);
                make.height.equalTo(@17);
                make.width.equalTo(@25);
            }];
            
            [self.readLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(self.boxImage.mas_left).offset(-38);
                make.bottom.equalTo(self.boxImage.mas_bottom);
                make.height.equalTo(@20);
                make.width.equalTo(@85);
            }];

        }
        
        /************* 文件消息 ************/
        else if ([self.chatFileType isEqualToNumber:@4]) {
        
            self.voiceTimeLab.hidden = YES;
            msgLabel.hidden = YES;
            _preView.hidden = YES;
            _photo.hidden = YES;
            playBtn.hidden = YES;
            _documentsView.hidden = NO;
            
            //气泡
            self.boxImage.image = IMG(@"Group 3");
            //气泡
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(headImage.mas_left).offset(-8);
                make.top.equalTo(headImage.mas_top);
                make.width.equalTo(@(SCREEN_WIDTH-126 > 250 ? 250 : SCREEN_WIDTH-126));
                make.height.equalTo(@(62));
                
            }];
            
            
            [self.documentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.boxImage.mas_left).offset(0);
                make.top.equalTo(self.boxImage.mas_top).offset(0);
                make.width.equalTo(@(SCREEN_WIDTH-126 > 250 ? 250 : SCREEN_WIDTH-126 ));
                make.height.equalTo(@62);
            }];
            
            [_pictureImg mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@10);
                make.top.equalTo(@10);
                make.width.equalTo(@35);
                make.height.equalTo(@42);
                
            }];
            [_fileNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_pictureImg.mas_right).offset(5);
                make.top.equalTo(@10);
                make.right.equalTo(@(-10));
                make.height.equalTo(@18);
                
            }];
            [_nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_pictureImg.mas_right).offset(5);
                make.top.equalTo(_fileNameLab.mas_bottom).offset(8);
                make.height.equalTo(@14);
                
            }];
            [_sizeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_nameLab.mas_right).offset(10);
                make.centerY.equalTo(_nameLab.mas_centerY);
                make.height.equalTo(@8);
                
            }];
            
            _fileNameLab.textColor = kUIColorFromRGB(0xFFFFFF);
            _nameLab.textColor = kUIColorFromRGB(0xFFFFFF);
            _sizeLab.textColor = kUIColorFromRGB(0xFFFFFF);
            
//            _pictureImg.image = IMG(@"doc");
            [self fileFormat:self.dbModel];
            
        }
        else if ([self.chatFileType isEqualToNumber:@5]) {
        
            self.voiceTimeLab.hidden = YES;
            msgLabel.hidden = YES;
            _photo.hidden = NO;
            _preView.hidden = NO;
            playBtn.hidden = NO;
            _documentsView.hidden = YES;
            
            _preView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
            _photo.frame = CGRectMake(8, 0, imgWidth-8, imgHeight);
            playBtn.frame = _photo.frame;
            
            //气泡
            self.boxImage.image = IMG(@"Group 3");
            //气泡
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(headImage.mas_left).offset(-8);
                make.top.equalTo(headImage.mas_top);
                make.width.equalTo(@(imgWidth));
                make.height.equalTo(@(imgHeight));
                
            }];
            
            //裁剪
            [self setImageLayer:self.boxImage];
            
            [_preView sd_setImageWithURL:[HQHelper URLWithString:chatContent] placeholderImage:nil];
            [_photo sd_setImageWithURL:[HQHelper URLWithString:chatContent] placeholderImage:nil];
            
            [self.readLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(self.boxImage.mas_left).offset(-10);
                make.bottom.equalTo(self.boxImage.mas_bottom);
                make.height.equalTo(@20);
                make.width.equalTo(@85);
            }];

        }
        /********************* 已读未读 *********************/
        
        //群聊
        if ([_dbModel.chatType isEqualToNumber:@1]) {
            
            
            
            if ([_dbModel.readNumbers integerValue]) {
                
                TFFMDBModel *model = [DataBaseHandle queryChatListDataWithChatId:_dbModel.chatId];
                //群成员字符串分割成数组
                NSArray *arr = [model.groupPeoples componentsSeparatedByString:@","];
                
                if ([_dbModel.readNumbers integerValue] == arr.count-1) {
                    
                    self.readLab.text = @"全部已读";
                    self.readLab.textColor = LightGrayTextColor;
                }
                else {
                
                    self.readLab.text = [NSString stringWithFormat:@"%@人已读",_dbModel.readNumbers];
                    self.readLab.textColor = kUIColorFromRGB(0x5592d3);
                }
                
                self.readLab.userInteractionEnabled = YES;
            }
            else {
                //msgLabel.userInteractionEnabled = NO;
                self.readLab.text = @"未读";
                self.readLab.textColor = kUIColorFromRGB(0x5592d3);
                
                self.readLab.userInteractionEnabled = NO;
            }
            
            self.readLab.hidden = NO;
            
        }
        //单聊
        else {
            
            if ([_dbModel.isRead isEqualToNumber:@0]){
                
                self.readLab.hidden = NO;
                
                self.readLab.userInteractionEnabled = NO;
                
                self.readLab.text = @"未读";
                self.readLab.textColor = kUIColorFromRGB(0x5592d3);
                [self.acview stopAnimating];
            }
            else if ([_dbModel.isRead isEqualToNumber:@1]) {
                
                self.readLab.hidden = NO;
                
                self.readLab.userInteractionEnabled = NO;
                
                self.readLab.text = @"已读";
                self.readLab.textColor = LightGrayTextColor;
                [self.acview stopAnimating];
            }
            else if ([_dbModel.isRead isEqualToNumber:@2]) {
                
                self.acview.hidden = NO;
                self.readLab.hidden = YES;
                
                self.readLab.userInteractionEnabled = YES;
                
//                self.readLab.text = @"正在发送";
//                self.readLab.textColor = kUIColorFromRGB(0x20BF9A);
                
                self.acview=[[UIActivityIndicatorView alloc] init];
                [self.acview setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
                [self.contentView addSubview:self.acview];
                [self.acview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.boxImage.mas_centerY);
                    make.right.mas_equalTo(self.boxImage.mas_left).offset(-10);;
                }];
                [self.acview startAnimating];
                
                self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
                
                
            }
            else if ([_dbModel.isRead isEqualToNumber:@3]) {
                
                
                self.unsendButton.hidden = NO;
                self.readLab.hidden = YES;
                
                
                [self.unsendButton mas_remakeConstraints:^(MASConstraintMaker *make) {

                    make.right.equalTo(self.boxImage.mas_left).offset(-10);
                    make.centerY.equalTo(self.boxImage.mas_centerY).offset(0);
                    make.width.height.equalTo(@20);
                }];

                [self.acview stopAnimating];
            }
            
            
        }
        
        
        /******************************************/
        
        
        
    }
    
#pragma mark 他人发的信息
    //收到别人发的
    else {
    
        self.readLab.hidden = YES;
        
        [headImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.labelTime.mas_bottom).offset(10);
            make.width.height.equalTo(@40);
        }];
        //昵称
        [self.userName mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(headImage.mas_right).offset(12);
            make.bottom.equalTo(self.boxImage.mas_top).offset(-3);
            
            make.height.equalTo(@20);
        }];
        
        /** 文本消息 */
        if ([self.chatFileType isEqualToNumber:@1]) {
            
            _preView.hidden = YES;
            _photo.hidden = YES;
            playBtn.hidden = YES;
            self.voiceTimeLab.hidden = YES;
            msgLabel.hidden = NO;
            _documentsView.hidden = YES;
            
            self.boxImage.image = IMG(@"对方气泡");
            
            
            CGFloat width;
            if (conSize.width+23<50) {
                
                width = 50;
            }
            else {
                
                width = conSize.width+23;
            }
            
            CGFloat height;
            if (conSize.height+16<38) {
                height = 38;
            }
            else {
                
                height = conSize.height+16;
            }
            
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(headImage.mas_right).offset(8);
                make.top.equalTo(headImage.mas_centerY);
                make.width.equalTo(@(width));
                make.height.equalTo(@(height));
                
            }];
            
            
            if (self.boxImage.width < 50) {
                
                self.boxImage.width = 50;
                self.boxImage.x = 63;

            }
            if (self.boxImage.height < 38) {
                
                self.boxImage.height = 38;
            }
            
//            self.boxImage.image = [self.boxImage.image stretchableImageWithLeftCapWidth:self.boxImage.image.size.width*0.5 topCapHeight:self.boxImage.image.size.height *0.9];
            
            
            msgLabel.attributedText = [MessageCell attributedStringWithText:chatContent font:16];
            NSString *URL;
            NSArray *urlArr = [NSArray array];
            if([self isURL:chatContent]) {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:msgLabel.attributedText];
                NSRange range1 = [[str string] rangeOfString:chatContent];
                [str addAttribute:NSForegroundColorAttributeName value:GreenColor range:range1];
                [str addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(0, str.length)];
                msgLabel.attributedText = str;
            } else {
                urlArr = [self getURLFromStr:chatContent];
                if (urlArr.count>0) {
                    
                    URL = urlArr[0];
                    
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:msgLabel.attributedText];
                    NSRange range1 = [[str string] rangeOfString:URL];
                    [str addAttribute:NSForegroundColorAttributeName value:GreenColor range:range1];
                    [str addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(0, str.length)];
                    
                    msgLabel.attributedText = str;
                }
                
            }
            
            [msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@15);
                make.top.equalTo(@8);
                make.width.equalTo(@(conSize.width));
                make.height.equalTo(@(conSize.height+2));
                
            }];
            
//            [self.readLab mas_makeConstraints:^(MASConstraintMaker *make) {
//                
//                make.right.equalTo(self.boxImage.mas_left).offset(-10);
//                make.bottom.equalTo(self.boxImage.mas_bottom).offset(0);
//                make.height.equalTo(@20);
//                make.width.equalTo(@85);
//            }];

            
        }
        
        /** 图片消息 */
        else if ([self.chatFileType isEqualToNumber:@2]) {
            
            self.voiceTimeLab.hidden = YES;
            msgLabel.hidden = YES;
            _photo.hidden = NO;
            _preView.hidden = NO;
            playBtn.hidden = YES;
            _documentsView.hidden = YES;
            
            _preView.frame = CGRectMake(0, 0, imgWidth, imgHeight);
            _photo.frame = CGRectMake(8, 0, imgWidth-8, imgHeight);
            playBtn.frame = _photo.frame;
        
            self.boxImage.image = IMG(@"对方气泡");
            
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(headImage.mas_right).offset(8);
                make.top.equalTo(headImage.mas_centerY);
                make.width.equalTo(@(imgWidth));
                make.height.equalTo(@(imgHeight));
                
            }];
            
            [self setImageLayer:self.boxImage];
//            self.boxImage.image = [self.boxImage.image stretchableImageWithLeftCapWidth:self.boxImage.image.size.width*0.5 topCapHeight:self.boxImage.image.size.height *0.9];
            
            [_preView sd_setImageWithURL:[HQHelper URLWithString:chatContent] placeholderImage:nil];
            [_photo sd_setImageWithURL:[HQHelper URLWithString:chatContent] placeholderImage:nil];

        }
        
        /** 语音消息 */
        else if ([self.chatFileType isEqualToNumber:@3]) {
        
            _preView.hidden = YES;
            _photo.hidden = YES;
            playBtn.hidden = YES;
            msgLabel.hidden = YES;
            _documentsView.hidden = YES;
            
            self.voiceTimeLab.hidden = NO;
            
            //语音时长显示
            
            self.voiceTimeLab.text = [NSString stringWithFormat:@"%@''",self.dbModel.voiceDuration];
            
            self.boxImage.image = IMG(@"对方语音气泡3");
            
            //进行动画效果的3张图片（按照播放顺序放置）
            self.boxImage.animationImages = [NSArray arrayWithObjects:
                                             IMG(@"对方语音气泡1"),
                                             IMG(@"对方语音气泡2"),
                                             IMG(@"对方语音气泡3"),nil];
            //设置动画间隔
            self.boxImage.animationDuration = 1;
            self.boxImage.animationRepeatCount = 0;
            self.boxImage.backgroundColor = [UIColor clearColor];
            
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(headImage.mas_right).offset(8);
                make.top.equalTo(headImage.mas_centerY);
                make.width.equalTo(@(imgWidth));
                make.height.equalTo(@(40));
                
            }];
//            self.boxImage.image = [self.boxImage.image stretchableImageWithLeftCapWidth:8 topCapHeight:25];
            
            
            [self.voiceTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.boxImage.mas_right).offset(8);
                make.centerY.equalTo(self.boxImage.mas_centerY).offset(0);
                make.height.equalTo(@17);
                make.width.equalTo(@25);
            }];

        }

        /** 文件消息 */
        else if ([self.chatFileType isEqualToNumber:@4]) {
        
            self.voiceTimeLab.hidden = YES;
            msgLabel.hidden = YES;
            _preView.hidden = YES;
            _photo.hidden = YES;
            playBtn.hidden = YES;
            _documentsView.hidden = NO;
            
            self.boxImage.image = IMG(@"对方气泡");
            
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(headImage.mas_right).offset(8);
                make.top.equalTo(headImage.mas_centerY);
                make.width.equalTo(@(SCREEN_WIDTH-126 > 250 ? 250 : SCREEN_WIDTH-126));
                make.height.equalTo(@(62));
                
            }];
            
//            self.boxImage.image = [self.boxImage.image stretchableImageWithLeftCapWidth:8 topCapHeight:25];
            
            [self.documentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
               
                make.left.equalTo(self.boxImage.mas_left).offset(0);
                make.top.equalTo(self.boxImage.mas_top).offset(0);
                make.width.equalTo(@(SCREEN_WIDTH-126 > 250 ? 250 : SCREEN_WIDTH-126));
                make.height.equalTo(@62);
            }];
            
            [_pictureImg mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@18);
                make.top.equalTo(@10);
                make.width.equalTo(@35);
                make.height.equalTo(@42);
                
            }];
            [_fileNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_pictureImg.mas_right).offset(5);
                make.top.equalTo(@10);
                make.right.equalTo(@(-10));
                make.height.equalTo(@18);
                
            }];
            [_nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_pictureImg.mas_right).offset(5);
                make.top.equalTo(_fileNameLab.mas_bottom).offset(8);
                make.height.equalTo(@14);
                
            }];
            [_sizeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_nameLab.mas_right).offset(10);
                make.centerY.equalTo(_nameLab.mas_centerY);
                make.height.equalTo(@8);
                
            }];
            
            _fileNameLab.textColor = kUIColorFromRGB(0xA9A9A9);
            _nameLab.textColor = kUIColorFromRGB(0xA9A9A9);
            _sizeLab.textColor = kUIColorFromRGB(0xA9A9A9);
            
            [self fileFormat:self.dbModel];
        }

        /** 视频消息 */
        else if ([self.chatFileType isEqualToNumber:@5]) {
        
            self.voiceTimeLab.hidden = YES;
            msgLabel.hidden = YES;
            _photo.hidden = NO;
            _preView.hidden = NO;
            playBtn.hidden = NO;
            _documentsView.hidden = YES;
            
            _photo.frame = CGRectMake(0, 0, imgWidth, imgHeight);
            playBtn.frame = _photo.frame;
            
            self.boxImage.image = IMG(@"对方气泡");
            
            [self.boxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(headImage.mas_right).offset(8);
                make.top.equalTo(headImage.mas_centerY);
                make.width.equalTo(@(imgWidth));
                make.height.equalTo(@(imgHeight));
                
            }];
            
            [self setImageLayer:self.boxImage];
            
            
            [_photo sd_setImageWithURL:[HQHelper URLWithString:chatContent] placeholderImage:nil];
        }

        

    }
    
    headImage.layer.cornerRadius = 20.0;
    headImage.layer.masksToBounds = YES;

    
}

@end
