//
//  HQPlayerView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/3/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQPlayerView.h"
#import <AVFoundation/AVFoundation.h>


@interface HQPlayerView () <AVAudioPlayerDelegate>

@property (nonatomic, strong)AVAudioPlayer *player;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *employId;
@property (nonatomic, assign) CGFloat time;

@property (nonatomic, strong)UIButton *pauseBtn;

@property (nonatomic, assign) BOOL netWorkState;

@end


@implementation HQPlayerView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    _playAndTitleDisLayout.constant = 12;
    
    
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"减--0"] forState:0];
    
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"减--0"] forState:UIControlStateSelected];
    
    self.progressView.trackImage = [UIImage imageNamed:@"grayLine"];
    self.progressView.progressImage = [UIImage imageNamed:@"greenLine"];
    
    
    
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pauseBtn.frame = self.playBtn.frame;
    [self.pauseBtn setImage:[UIImage imageNamed:@"soundRecording__small_btn"] forState:UIControlStateNormal];
    [self.pauseBtn setImage:[UIImage imageNamed:@"pause_small"] forState:UIControlStateSelected];
    [self addSubview:self.pauseBtn];
    self.pauseBtn.hidden = YES;
    [self.pauseBtn addTarget:self action:@selector(pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(playerStop)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

/** 当播放器停止播放时操作 */
- (void)playerStop{
    
    if (!self.player.isPlaying) {
        self.playBtn.selected = NO;
        self.pauseBtn.selected = NO;
        self.playBtn.hidden = NO;
        self.pauseBtn.hidden = YES;
        self.progressView.progress = 0;
        [self.timer invalidate];
        self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.soundceTime];
    }
}


- (void)pauseBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self.player play];
        self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeUpMethod:) userInfo:nil repeats:YES];
    }else{
//        [self.player pause];
        [self.player stop];
        [self.timer invalidate];
        self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.time];
    }
    
}




- (void)refreshPlayCellWithTitle:(NSString *)titleStr
                             Url:(NSString *)recorderUrlStr
                    voiceTimeInt:(NSInteger)voiceTimeInt
                    netWorkState:(BOOL)netWorkState
{
    
    self.deleteBtn.hidden = YES;
    
    if (titleStr.length == 0) {
        
        _playAndTitleDisLayout.constant = 0;
        _titleLabel.text = @"";
    
    }else {
       
        _playAndTitleDisLayout.constant = 12;
        _titleLabel.text = titleStr;
    }
    
        
    
    
    _timeLabel.text = [NSString stringWithFormat:@"%d\"", (int)voiceTimeInt];
    
    _netWorkState = netWorkState;
    
    _soundceTime = voiceTimeInt;
    
    _recorderUrl = [NSURL URLWithString:recorderUrlStr];
    
}


- (IBAction)playVedioAction:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    
    btn.selected =!btn.selected;
    
    if (_netWorkState == NO) {
        
        if (btn.selected == YES) {
            
            UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
            AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof (audioRouteOverride),&audioRouteOverride);
            
            
//            AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:self.recorderUrl options:nil];
            
            NSError *error = nil;
            
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorderUrl error:&error];
            _player.volume = 1.0;
            
            if (_player) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayerViewTransmitParameter" object:_player];
            }
            
            _player.delegate = self;
            
            [self.player play];
            
            //            [self timeMinus];
            [self.timer invalidate];
            self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.soundceTime];
            _time = self.soundceTime;
            self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeUpMethod:) userInfo:nil repeats:YES];
            
            
        }else{
            
//            [self.player pause];
            [self.player stop];
            btn.selected = NO;
            self.playBtn.hidden = YES;
            self.pauseBtn.hidden = NO;
            
            [self.timer invalidate];
            self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.time];
        }
        
    }else {
        
        if (btn.selected == YES) {
            
            NSString *urlStr = [NSString stringWithFormat:@"%@", [_recorderUrl absoluteString]];
            
            NSURL *someURL = [NSURL URLWithString:urlStr];
            
            NSData *audioData = [NSData dataWithContentsOfURL:someURL];
            
//            if (!_player) {
                NSError *error;
                // 通过网络data数据创建播放器
                _player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
                
//                _player = [[AVAudioPlayer alloc] initWithData:audioData
//                                                 fileTypeHint:AVFileTypeMPEGLayer3
//                                                        error:&error];
                // 设置属性
                _player.numberOfLoops = 0; //不循环
                _player.volume = 1.0;
                _player.delegate = self;
                if (error) {
                    HQLog(@"播放器初始化失败%@",error);
                }
                [_player prepareToPlay];
//            }
            
            if (_player) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayerViewTransmitParameter" object:_player];
            }
            
            [_player play];
            
            [self.timer invalidate];
            self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.soundceTime];
            _time = self.soundceTime ;
            self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeUpMethod:) userInfo:nil repeats:YES];
            
            
            
        } else {
            
            btn.selected = NO;
//            [self.player pause];
            [self.player stop];
//            self.playBtn.hidden = YES;
//            self.pauseBtn.hidden = NO;
            
            [self.timer invalidate];
            
            self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.time];
        }
        
        
        
    }
    

}


-(void)timeMinus{
    
    
    __block CGFloat timeout = self.soundceTime; //倒计时时间
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                _playBtn.selected = NO;
                self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.soundceTime];
                self.progressView.progress = 0;
                
                
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",timeout];
                self.progressView.progress = (self.soundceTime - timeout)/self.soundceTime;
                
            });
            
            timeout--;
            
            
        }
    });
    
    
    
    dispatch_resume(_timer);
}


-(void)timeUpMethod:(NSTimer *)timer{
    
    
    self.time --;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.time];
    
    self.progressView.progress = (self.soundceTime - self.time)/self.soundceTime;
    
    if (self.time == 0) {
        
        [timer invalidate];
        
        _playBtn.selected = NO;
        
        self.timeLabel.text = [NSString stringWithFormat:@"%0.0f\"",self.soundceTime];
        self.progressView.progress = 0;
        self.time = self.soundceTime;
    }
}



- (IBAction)deleteVedioAction:(id)sender {
}
@end
