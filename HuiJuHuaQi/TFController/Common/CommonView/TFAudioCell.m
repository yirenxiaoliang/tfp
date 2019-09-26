//
//  TFAudioCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAudioCell.h"
#import <AVFoundation/AVFoundation.h>

@interface TFAudioCell ()<AVAudioPlayerDelegate>
{
    __block CGFloat timeout;
}
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *backTime;
@property(nonatomic,assign)CGFloat time;
/** 音频播放器 */
@property (nonatomic,strong)AVAudioPlayer *player;

@property(nonatomic,strong) NSTimer * backTimer;
/** model */
//@property (nonatomic, strong) TFNoteDetailModel *model;
/** model */
@property (nonatomic, strong) HQAudioModel *model;
/** pause */
@property (nonatomic, assign) BOOL pause;


@end

@implementation TFAudioCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.timeLabel.textColor = FinishedTextColor;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = FONT(16);
    
    self.backTime.textColor = FinishedTextColor;
    self.backTime.textAlignment = NSTextAlignmentCenter;
    self.backTime.font = FONT(12);
    
    self.sliderView.continuous = YES;// 设置可连续变化
    self.sliderView.minimumTrackTintColor = GreenColor; //滑轮左边颜色，如果设置了左边的图片就不会显示
    self.sliderView.maximumTrackTintColor = LightGrayTextColor; //滑轮右边颜色，如果设置了右边的图片就不会显示
    self.sliderView.thumbTintColor = GreenColor;//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
    [self.sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响
    self.sliderView.userInteractionEnabled = NO;
    
    [self.timeBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [self.timeBtn setImage:[UIImage imageNamed:@"暂停player"] forState:UIControlStateSelected];
    
//    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(playerStop)];
//    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.timeBtn addTarget:self action:@selector(playVedioAction:) forControlEvents:UIControlEventTouchUpInside];
}
/** 当播放器停止播放时操作 */
- (void)playerStop{
    
    if (!self.player.isPlaying) {
        self.timeBtn.selected = NO;
        self.sliderView.value = 0;
        [self.backTimer invalidate];
//        if ([self.model.voiceDuration integerValue] > 0) {
//
//            self.backTime.text = [NSString stringWithFormat:@"%.0f\"",[self.model.voiceDuration floatValue]/1000 ];
//        }else{
        
            self.backTime.text = [NSString stringWithFormat:@"%.0f\"",_player.duration];
//        }
    }
}

- (void)sliderValueChanged:(UISlider *)slider{
    
    
}

- (void)playVedioAction:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    
    btn.selected =!btn.selected;
    
    if (btn.selected == YES) {
        if (!self.pause) {
            self.time = _player.duration;
        }
        _player.volume = 1.0;
        [_player play];
        [self.backTimer invalidate];
        self.backTimer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeUpMethod:) userInfo:nil repeats:YES];
        
    } else {
        
        [self.player pause];
        self.pause = YES;
        [self.backTimer invalidate];
//        self.backTimer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeUpMethod:) userInfo:nil repeats:YES];
        
        self.backTime.text = [NSString stringWithFormat:@"%.0f\"",self.time];
        
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    self.timeBtn.selected = NO;
    self.sliderView.value = 0;
    [self.backTimer invalidate];
    self.pause = NO;
//    if ([self.model.voiceDuration integerValue] > 0) {
//
//        self.backTime.text = [NSString stringWithFormat:@"%.0f\"",[self.model.voiceDuration floatValue]/1000 ];
//    }else{
    
        self.backTime.text = [NSString stringWithFormat:@"%.0f\"",_player.duration];
//    }
    
}


-(void)timeUpMethod:(NSTimer *)timer{
    
    
    self.time -= 0.1;
    
    self.backTime.text = [NSString stringWithFormat:@"%.0f\"",self.time];
    
    CGFloat value = 0;
    
//    if ([self.model.voiceDuration integerValue] > 0) {
//        value = (([self.model.voiceDuration integerValue]/1000 ) * 1.0 - self.time)*1.0/([self.model.voiceDuration integerValue]/1000 )*1.0;
//    }else{
    
        value = (_player.duration - self.time)*1.0/(_player.duration)*1.0;
//    }
    
    
    [self.sliderView setValue:value animated:YES];
    
    if (self.time <= 0) {
        
        [timer invalidate];
        
        self.timeBtn.selected = NO;
        
//        if ([self.model.voiceDuration integerValue] > 0) {
//
//            self.backTime.text = [NSString stringWithFormat:@"%.0f\"",[self.model.voiceDuration floatValue]/1000 ];
//        }else{
        
            self.backTime.text = [NSString stringWithFormat:@"%.0f\"",_player.duration];
//        }
        
        self.sliderView.value = 0;
        self.time = 0;
    }
    
    
}



//-(void)timeMinus{
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.1*NSEC_PER_SEC, 0); //每0.1秒执行
//    
//    
//    dispatch_source_set_event_handler(_timer, ^{
//        
//        if(self.time<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                
//                self.timeBtn.selected = NO;
//                self.backTime.text = [NSString stringWithFormat:@"%ld\"",[self.model.voiceDuration integerValue]];
//                self.sliderView.value = 0;
//                
//                
//            });
//        }else{
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                
//                
//                self.backTime.text = [NSString stringWithFormat:@"%.0f\"",self.time];
//                
//                CGFloat value = ([self.model.voiceDuration integerValue] * 1.0 - self.time)*1.0/[self.model.voiceDuration integerValue]*1.0;
//                
//                [self.sliderView setValue:value animated:YES];
//                
//            });
//        }
//    });
//    
//    
//    
//    dispatch_resume(_timer);
//    
//}
//



//-(void)refreshAudioCellWithModel:(TFNoteDetailModel *)model withType:(NSInteger)type{
//    
//    self.model = model;
//    if (type == 0) {
//        self.bgView.hidden = YES;
//        self.timeLabel.hidden = NO;
//    }else{
//        self.bgView.hidden = NO;
//        self.timeLabel.hidden = YES;
//    }
//    
//    self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",[model.voiceDuration integerValue] ];
//    self.backTime.text = [NSString stringWithFormat:@"%ld\"",[model.voiceDuration integerValue] ];
//}

-(void)refreshAudioCellWithAudioModel:(HQAudioModel *)model withType:(NSInteger)type{
    
    self.model = model;
    if (type == 0) {
        self.bgView.hidden = YES;
        self.timeLabel.hidden = NO;
    }else{
        self.bgView.hidden = NO;
        self.timeLabel.hidden = YES;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.mp3",[HQHelper stringForMD5WithString:model.voiceUrl]];
    
    [HQHelper cacheFileWithUrl:self.model.voiceUrl fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // 保存文件
        [HQHelper saveCacheFileWithFileName:fileName data:data];
        
        NSError *error1;
        // 通过网络data数据创建播放器
        _player = [[AVAudioPlayer alloc] initWithData:data error:&error1];
        if (error1) {
            HQLog(@"播放器初始化失败%@",error1);
            return ;
        }
        // 设置属性
        _player.numberOfLoops = 0; //不循环
        _player.delegate = self;
        _player.meteringEnabled = YES;
        [_player setVolume:1.0];
        [_player updateMeters];
        [_player prepareToPlay];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新
            
            // player初始化完成后
            if ([self.delegate respondsToSelector:@selector(audioCell:withPlayer:)]) {
                [self.delegate audioCell:self withPlayer:_player];
            }
            
            self.timeLabel.text = [NSString stringWithFormat:@"%.0f\"",_player.duration>60.0?60:_player.duration];
            self.backTime.text = [NSString stringWithFormat:@"%.0f\"",_player.duration>60.0?60:_player.duration];
            
        });

        
    } fileHandler:^(NSString *path) {
        
        NSError *error1;
        // 通过网络data数据创建播放器
        _player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:&error1];
        if (error1) {
            HQLog(@"播放器初始化失败%@",error1);
            return ;
        }
        // 设置属性
        _player.numberOfLoops = 0; //不循环
        _player.delegate = self;
        _player.meteringEnabled = YES;
        [_player setVolume:1.0];
        [_player updateMeters];
        
        [_player prepareToPlay];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新
            
            // player初始化完成后
            if ([self.delegate respondsToSelector:@selector(audioCell:withPlayer:)]) {
                [self.delegate audioCell:self withPlayer:_player];
            }
            
            self.timeLabel.text = [NSString stringWithFormat:@"%.0f\"",_player.duration>60.0?60:_player.duration];
            self.backTime.text = [NSString stringWithFormat:@"%.0f\"",_player.duration>60.0?60:_player.duration];
            
        });
    }];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 处理耗时操作的代码块...
//        
//        NSURL *someURL = [HQHelper URLWithString:self.model.voiceUrl];
//        
//        NSData *audioData = [NSData dataWithContentsOfURL:someURL];
//        
//        //            if (!_player) {
//        NSError *error;
//        // 通过网络data数据创建播放器
//        _player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
//        // 设置属性
//        _player.numberOfLoops = 0; //不循环
//        _player.delegate = self;
//        [_player setVolume:1.0];
//        if (error) {
//            HQLog(@"播放器初始化失败%@",error);
//        }
//        [_player prepareToPlay];
//        //通知主线程刷新
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //回调或者说是通知主线程刷新
//            
//            // player初始化完成后
//            if ([self.delegate respondsToSelector:@selector(audioCell:withPlayer:)]) {
//                [self.delegate audioCell:self withPlayer:_player];
//            }
//            
//            self.time = _player.duration;
//            
//            if ([model.voiceDuration integerValue] > 0) {
//                
//                self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",[model.voiceDuration integerValue] ];
//                self.backTime.text = [NSString stringWithFormat:@"%ld\"",[model.voiceDuration integerValue] ];
//            }else{
//                
//                self.timeLabel.text = [NSString stringWithFormat:@"%.0f\"",_player.duration];
//                self.backTime.text = [NSString stringWithFormat:@"%.0f\"",_player.duration];
//            }
//        }); 
//        
//    });
    
}


+ (instancetype)audioCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAudioCell" owner:self options:nil] lastObject];
}

+ (instancetype)audioCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFAudioCell";
    TFAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self audioCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
