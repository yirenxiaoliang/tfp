//
//  AudioPlayerController.m
//  ChatTest
//
//  Created by 肖胜 on 2017/5/21.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "AudioPlayerController.h"
#import <AVFoundation/AVFoundation.h>
@interface AudioPlayerController ()
{
    
    AVAudioPlayer *audioPlayer;     // 音乐播放器，必须为全局，不然无法播放
    NSDictionary *_music;           // 音乐信息
    UISlider *progressSlider;       // 滑杆兼进度条，当前播放进度以及进度修改
    NSTimer *timer;                 // 定时器
    UILabel *currentTimeLabel;      // 当前播放时间显示
    
}
@end

@implementation AudioPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BGCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = _music[@"name"];
    [self initSubviews];
    
}

- (void)initSubviews {
    
    // 音乐蜂蜜
    UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 125, SCREEN_WIDTH-140, SCREEN_WIDTH-140)];
    photoView.image = [UIImage imageWithData:_music[@"image"]];
    photoView.userInteractionEnabled = YES;
    [self.view addSubview:photoView];
    
    // 播放按钮
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake((photoView.width-50)/2.0, (photoView.width-50)/2.0, 50, 50);
    [photoView addSubview:playBtn];
    [playBtn setImage:[UIImage imageNamed:@"mplay"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"mpause"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 当前播放时间
    currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 60, 50, 20)];
    currentTimeLabel.text = @"00:00";
    currentTimeLabel.textColor = [UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1];
    currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    currentTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:currentTimeLabel];
    
    // 进度条
    progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(currentTimeLabel.right + 2, currentTimeLabel.top, SCREEN_WIDTH - 120, currentTimeLabel.height)];
    progressSlider.minimumValue = 0;
    progressSlider.maximumValue = audioPlayer.duration;
    progressSlider.continuous = NO;
    [progressSlider addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:progressSlider];
    
    // 总时长
    UILabel *totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressSlider.right + 2, currentTimeLabel.top, 50, 20)];
    totalTimeLabel.text = @"04:23";
    totalTimeLabel.textColor = [UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1];
    totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    totalTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:totalTimeLabel];
    
    totalTimeLabel.text = [self secondToString:audioPlayer.duration];
    
}


/**
 将秒转换成mm:ss格式显示

 @param second 秒数
 @return 格式字符串
 */
- (NSString *)secondToString:(NSTimeInterval)second {
    
    return [NSString stringWithFormat:@"%02d:%02d",(int)second / 60, (int)second % 60];
}

/**
 slider拖动

 @param slider slider
 */
- (void)changeAction:(UISlider *)slider {
    
    audioPlayer.currentTime = slider.value;
}

- (void)playAction:(UIButton *)button {
    
    button.selected = !button.selected;
    
    // 播放
    if (button.selected) {
        
        [audioPlayer play];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
           
            [progressSlider setValue:audioPlayer.currentTime animated:YES];
            currentTimeLabel.text = [self secondToString:audioPlayer.currentTime];
        }];
        
    }
    // 暂停
    else {
        
        [audioPlayer pause];
        [timer invalidate];
        timer = nil;
    }
}


/**
 初始化播放器

 @param music 音乐信息
 @return self
 */
- (instancetype)initWithAudioInfo:(NSDictionary *)music {
    
    self = [super init];
    if (self) {
        
        _music = music;
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:music[@"video"]] error:NULL];
        audioPlayer.numberOfLoops = -1;
        audioPlayer.volume = 0.8;
        [audioPlayer prepareToPlay];
        
    }
    return self;
}


/**
 返回时停止播放，释放播放器
 
 @param animated 
 */
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [audioPlayer stop];
    audioPlayer = nil;
    
}



@end
