//
//  HQSendMessageView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/7.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSendMessageView.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#define bgViewWidth 168
#define toolBarHeight  48


@interface HQSendMessageView () <UITextViewDelegate,AVAudioRecorderDelegate>


@property (nonatomic, strong) UIButton *messageBtn;    //切换语音还是文本按钮

@property (nonatomic, strong) UIButton *voiceBtn;      //长按发送语音按钮


@property (nonatomic, strong) UIButton *sendBtn;       //发送文本

@property (nonatomic, strong) CADisplayLink *link;       //定时监听
@property (nonatomic, weak)  UIImageView *animationView; // 录音动画
@property (nonatomic, weak)  UIImageView *recordView; // 录音图
@property (nonatomic, weak) UILabel *backTimeLabel;// 倒计时label

@property (nonatomic,strong)AVAudioRecorder *recorder;
@property (nonatomic,strong)NSURL * recorderUrl;
@property (nonatomic,strong)NSURL * mp3RecorderUrl;
@property (nonatomic,strong)NSMutableDictionary *audioDict;  // 存放录音信息的字典

@property (nonatomic , assign)BOOL autoStop;
@property (nonatomic , assign)BOOL cancel;
@property (nonatomic , assign)BOOL backRecord;

@end


@implementation HQSendMessageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        UIButton *hideBtn = [HQHelper buttonWithFrame:frame target:self action:@selector(hideSendMessageView)];
        [self addSubview:hideBtn];
        
        
        [self initSendMessageView:NO];
        
        
        
    }
    
    return self;
}


- (void)initSendMessageView:(BOOL)operationTextType
{
    
    self.backgroundColor = HexAColor(0x000000, .4);
    
    
    
    _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-toolBarHeight, SCREEN_WIDTH, toolBarHeight)];
    _toolBarView.backgroundColor = BackGroudColor;
    [self addSubview:_toolBarView];
    
    
    
    _messageBtn  = [HQHelper buttonWithFrame:CGRectMake(10, 10, toolBarHeight - 20, toolBarHeight - 20)
                              normalImageStr:@"EaseUIResource.bundle/chatBar_record"
                                highImageStr:@"EaseUIResource.bundle/chatBar_record"
                                      target:self
                                      action:@selector(changeMessageType)];
    [_toolBarView addSubview:_messageBtn];
    
    
    
    
    _contentTextView = [[HQAdviceTextView alloc] initWithFrame:CGRectMake(toolBarHeight, 5, SCREEN_WIDTH-2*toolBarHeight-10, toolBarHeight - 10)];
    _contentTextView.font = FONT(15);
    _contentTextView.layer.cornerRadius  = 4;
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.layer.borderWidth = 0.5;
    _contentTextView.layer.borderColor = [CellSeparatorColor CGColor];
    _contentTextView.delegate = self;
    
    
    if (operationTextType == YES) {
        
        _messageBtn.hidden = YES;
        
        if (_senderType == 0) {
            
            
        }else{
            
//            for (HQEmployCModel * cmodel in UM.userLoginInfo.employee) {
            
                if( [UM.userLoginInfo.employee.id isEqualToNumber:_recivicePeopleName] ){
                    
                    _contentTextView.placeholder = [NSString stringWithFormat:@"回复:%@",UM.userLoginInfo.employee.employee_name];
//                    break;
                    
                }
                
//            }
        }
        
        
        _contentTextView.placeholderColor = HexAColor(0xbfbfbf, 1);
        _contentTextView.x = 12;
        _contentTextView.width +=36;
    }
    
    
    [_toolBarView addSubview:_contentTextView];
    
    
    
    
    _voiceBtn = [HQHelper buttonOfMainButtonWithFrame:_contentTextView.frame
                                                title:@"按住说话"
                                          normalColor:BackGroudColor
                                            highColor:LightGrayTextColor
                                        disabledColor:nil
                                           titleColor:LightBlackTextColor
                                        disTitleColor:nil
                                                 font:FONT(19)
                                               target:self
                                               action:@selector(sendMessageVoiceAction)];
    [_voiceBtn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    [_voiceBtn addTarget:self
                  action:@selector(beginMessageVoiceAction)
        forControlEvents:UIControlEventTouchDown];
    
    [_voiceBtn addTarget:self
                  action:@selector(cancelMessageVoiceAction)
        forControlEvents:UIControlEventTouchUpOutside];
    
    _voiceBtn.layer.cornerRadius  = 4;
    _voiceBtn.layer.masksToBounds = YES;
    _voiceBtn.layer.borderWidth = 0.5;
    _voiceBtn.layer.borderColor = [CellSeparatorColor CGColor];
    _voiceBtn.hidden = YES;
    [_toolBarView addSubview:_voiceBtn];
    
    
    
    
    CGRect sendBtnFrame = CGRectMake(_contentTextView.right + 8, 8, toolBarHeight - 5, toolBarHeight - 15);
    _sendBtn = [HQHelper buttonOfMainButtonWithFrame:sendBtnFrame
                                               title:@"发送"
                                         normalColor:GreenColor
                                           highColor:GreenColor
                                       disabledColor:WhiteColor
                                          titleColor:WhiteColor
                                       disTitleColor:GrayTextColor
                                                font:FONT(15)
                                              target:self
                                              action:@selector(sendMessageTextAction)];
    _sendBtn.layer.cornerRadius  = 4;
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.borderWidth = 0.5;
    _sendBtn.layer.borderColor = [CellSeparatorColor CGColor];
    [_toolBarView addSubview:_sendBtn];
}


- (void)changeMessageType
{
    
    _messageBtn.selected = !_messageBtn.selected;
    
    if (_messageBtn.selected) {
        
        [_messageBtn setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_keyboard"]
                     forState:UIControlStateNormal];
        [_messageBtn setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_keyboard"]
                     forState:UIControlStateHighlighted];
        _sendBtn.enabled = NO;
        _voiceBtn.hidden = NO;
        _contentTextView.hidden = YES;
        
        
        
    }else {
        
        [_messageBtn setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_record"]
                     forState:UIControlStateNormal];
        [_messageBtn setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_record"]
                     forState:UIControlStateHighlighted];
        _sendBtn.enabled = YES;
        _voiceBtn.hidden = YES;
        _contentTextView.hidden = NO;
    }
}


#pragma 开始录音
- (void)beginMessageVoiceAction
{
    HQLog(@"begin");
    [self startRecorder];
}

#pragma 停止录音,调录音完成代理发送录音
- (void)sendMessageVoiceAction
{
    
    HQLog(@"send voice");
    [self stopRecorder];
    
}
#pragma mark 取消录音发送
- (void)cancelMessageVoiceAction{
    // 停止录音
    self.cancel = YES;
    [self stopRecorder];
}

- (void)sendMessageTextAction
{
    if (!_contentTextView.text || [_contentTextView.text isEqualToString:@""]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(sendMessageWithText:messageVoice:taskOperationID:)]) {
        
        [self.delegate sendMessageWithText:_contentTextView.text messageVoice:nil taskOperationID:self.taskOperationID];
    }
    
    

    
    if ([self.delegate respondsToSelector:@selector(sendNoVoidWithText:taskType:employID:)]) {
        
        if (_senderType == 0) {

            
            
            [self.delegate sendNoVoidWithText:_contentTextView.text taskType:_senderType employID:nil];
            
            HQLog(@"进来了");
            
            
            
        }else{
            
             [self.delegate sendNoVoidWithText:_contentTextView.text taskType:_senderType employID:_recivicePeopleName];
            
                    HQLog(@"进来了");
            
            
            _contentTextView.placeholder = nil;
            
            
        }
    }
    

    
    _contentTextView.text = @"";
    
    if (self.type == SendMessageViewDefault) {
        [_contentTextView resignFirstResponder];
        [self removeFromSuperview];
    }
}


- (void)setRecivicePeopleName:(NSNumber *)recivicePeopleName
{
    
    _recivicePeopleName = recivicePeopleName;
#warning new Core Data
//    for (HQEmployCModel * cmodel in [HQUserManager defaultUserInfoManager].userLoginInfo.employes) {
//        
//        if( [cmodel.id isEqualToNumber:recivicePeopleName] ){
//            
//            _contentTextView.placeholder = [NSString stringWithFormat:@"回复:%@",cmodel.employeeName];
//            break;
//        }
//    }
}


#pragma mark - 开始录音
-(void)startRecorder{
    
    self.backRecord = NO;
    
    NSError *error = nil;
    
    //激活AVAudioSession
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (session != nil) {
        [session setActive:YES error:nil];
    }else {
        HQLog(@"session error: %@",error);
    }
    
    
    NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
    
    //录音格式
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    //采样率 单位是Hz 常见值 44100 48000 96000 192000
    [recordSetting setValue :[NSNumber numberWithFloat:44100] forKey: AVSampleRateKey];
    //通道数
    [recordSetting setValue :[NSNumber numberWithInt:1] forKey: AVNumberOfChannelsKey];
    //线性采样位数  8 16 32
    [recordSetting setValue :[NSNumber numberWithInt:32] forKey: AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey: AVLinearPCMIsFloatKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey: AVLinearPCMIsBigEndianKey];
    //声音质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    //音频的编码比特率
    [recordSetting setValue:[NSNumber numberWithInt:192000] forKey:AVEncoderBitRateKey];
    
    
    NSString *tmpDir = NSTemporaryDirectory();
    
    NSString *urlPath = [tmpDir stringByAppendingString:@"message.aac"];
    
    _recorderUrl = [NSURL fileURLWithPath:urlPath];
    //实例化AVAudioRecorder对象
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recorderUrl settings:recordSetting error:&error];
    if (error) {
        HQLog(@"recorder error: %@", error);
    }
    
    self.recorder.delegate = self;
    
    [self.recorder recordForDuration:60.0];
    self.recorder.meteringEnabled = YES;
    
    //开始录音
    [self.recorder record];
    
    // 录音动画
    [self recordAnimation];
    
    // 定时监听音量大小
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(minitorSoucePower)];
    self.link = link;
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.autoStop = YES;
    
}

#pragma mark - 监听音量大小，并根据音量大小切换音量动画图片
- (void)minitorSoucePower{
    
    [self.recorder updateMeters];// 一定要更新测量音量，否则无法获取音量值
    CGFloat soucePower = [self.recorder averagePowerForChannel:0];// 平均音量
    CGFloat soucePowerPeak = [self.recorder peakPowerForChannel:0];// 峰值音量
    
    float peakPower = [_recorder averagePowerForChannel:0];
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));// 取对数后值为0 - 1之间
    HQLog(@"%f**********%f-----%f" ,soucePower, soucePowerPeak, peakPowerForChannel);
    
    // 切换图片
    if (peakPowerForChannel >= 0.7) {
        [self.animationView setImage:[UIImage imageNamed:@"音量7"]];
    }else if (peakPowerForChannel >= 0.6) {
        [self.animationView setImage:[UIImage imageNamed:@"音量6"]];
    }else if (peakPowerForChannel >= 0.5) {
        [self.animationView setImage:[UIImage imageNamed:@"音量5"]];
    }else if (peakPowerForChannel >= 0.4) {
        [self.animationView setImage:[UIImage imageNamed:@"音量4"]];
    }else if (peakPowerForChannel >= 0.3) {
        [self.animationView setImage:[UIImage imageNamed:@"音量3"]];
    }else if (peakPowerForChannel >= 0.2) {
        [self.animationView setImage:[UIImage imageNamed:@"音量2"]];
    }else{
        [self.animationView setImage:[UIImage imageNamed:@"音量1"]];
    }
    
    HQLog(@"****************%f*************", self.recorder.currentTime);// 录音时间
    if ([[NSString stringWithFormat:@"%.0lf", self.recorder.currentTime] integerValue] == 51 && !self.backRecord) {// 最后10秒倒计时, 只执行一次
        self.backRecord = YES;
        self.recordView.hidden = YES;
        self.animationView.hidden = YES;
        self.backTimeLabel.hidden = NO;
        [HQHelper backTimeText:self.backTimeLabel];

    }
}

#pragma mark - 结束录音

-(void)stopRecorder{
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [self.recorder stop];
    [self.link invalidate];
    
    NSString *tmpDir = NSTemporaryDirectory();
    
    NSString *urlPath = [tmpDir stringByAppendingString:@"message.aac"];
    
    NSString *mp3UrlPath = [tmpDir stringByAppendingString:@"myMessage.mp3"];
    
    // caf--> mp3
    self.mp3RecorderUrl = [HQHelper recordCafToMp3WithCafUrl:urlPath toMp3Url:mp3UrlPath];
    
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:self.recorderUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    int audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    // 保存录音信息
    self.audioDict = [NSMutableDictionary dictionary];
    self.audioDict[@"audioDurationSeconds"] = @(audioDurationSeconds);
    self.audioDict[@"recorderUrl"] = self.mp3RecorderUrl;
}

#pragma mark - 录音结束
/** 主动结束录音也会走这个代理，录音时间最大自动结束也会走这个代理 */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    // 停止定时器
    [self.link invalidate];
    
    // 移除动画
    [self removeAnimation];
    
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:self.recorderUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    int audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    
    if (audioDurationSeconds < 1) {
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        [MBProgressHUD showError:@"录音时间太短" toView:window];
        return;
    }
    
    
    NSString *tmpDir = NSTemporaryDirectory();
    
    NSString *urlPath = [tmpDir stringByAppendingString:@"message.aac"];
    
    NSString *mp3UrlPath = [tmpDir stringByAppendingString:@"myMessage.mp3"];
    
    // caf--> mp3
    self.mp3RecorderUrl = [HQHelper recordCafToMp3WithCafUrl:urlPath toMp3Url:mp3UrlPath];
    
    // 保存录音信息
    self.audioDict = [NSMutableDictionary dictionary];
    self.audioDict[@"audioDurationSeconds"] = @(audioDurationSeconds);
    self.audioDict[@"recorderUrl"] = self.mp3RecorderUrl;
    
    
    
    if (!self.cancel) {// 不取消录音，通知代理
        
        if ([self.delegate respondsToSelector:@selector(sendMessageWithText:messageVoice:taskOperationID:)]) {
            
            [self.delegate sendMessageWithText:nil messageVoice:self.audioDict taskOperationID:self.taskOperationID];
        }
    }
    
    
}
#pragma mark - 移除录音动画

- (void)removeAnimation{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
}

#pragma mark - 录音动画
- (void)recordAnimation{
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
    
    // 防止触碰
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    [window addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 0x98765;
    
    // 背景mask窗体
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake((SCREEN_WIDTH - bgViewWidth) * 0.5, (SCREEN_HEIGHT - 49 - bgViewWidth) * 0.5, bgViewWidth, bgViewWidth );
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
//    [window addSubview:bgView];
//    bgView.tag = 0x98765;
    bgView.layer.cornerRadius = 12;
    bgView.layer.masksToBounds = YES;
    
    [view addSubview:bgView];
    view.tag = 0x98765;
    
    // 麦克风图片
    UIImageView *recordView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,bgViewWidth / 2.0,bgViewWidth *3/4.0}];
    [bgView addSubview:recordView];
    [recordView setImage:[UIImage imageNamed:@"麦克风"]];
    recordView.contentMode = UIViewContentModeRight;
    self.recordView = recordView;
    // 音量大小图片
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:(CGRect){bgViewWidth  / 2.0, 0,bgViewWidth * 2 / 5.0,bgViewWidth*3/4.0}];
    [bgView addSubview:animationView];
    [animationView setImage:[UIImage imageNamed:@"音量1"]];
    animationView.contentMode = UIViewContentModeCenter;
    self.animationView = animationView;
    
    // 倒计时label
    UILabel *backTime = [[UILabel alloc] initWithFrame:(CGRect){0, 0, bgViewWidth, bgViewWidth *3/4.0 }];
    [bgView addSubview:backTime];
    backTime.textColor = WhiteColor;
    backTime.textAlignment = NSTextAlignmentCenter;
    backTime.font = FONT(64);
    backTime.text = [NSString stringWithFormat:@"%d", 10];
    self.backTimeLabel = backTime;
    backTime.hidden = YES;
    
    // 手指上划，取消发送
    UILabel *text = [[UILabel alloc] initWithFrame:(CGRect){0 ,bgViewWidth*2/3.0 , bgViewWidth, bgViewWidth /4.0 }];
    [bgView addSubview:text];
    text.font = FONT(17);
    text.textColor = RGBAColor(0xff, 0xff, 0xff, 0.8);
    text.textAlignment = NSTextAlignmentCenter;
    text.text = @"手指上划，取消发送";
    // 显示窗体
    [window makeKeyAndVisible];
}



- (void)hideSendMessageView
{
    [self removeFromSuperview];
}



#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 500) {
        
        textView.text = [textView.text substringToIndex:500];
    }
}

//- (void)textViewDidChangeSelection:(UITextView *)textView;



@end
