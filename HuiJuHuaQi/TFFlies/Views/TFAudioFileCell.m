//
//  TFAudioFileCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAudioFileCell.h"
#import <AVFoundation/AVFoundation.h>

@interface TFAudioFileCell ()<AVAudioPlayerDelegate>
{
    __block CGFloat timeout;
}

@property (weak, nonatomic) IBOutlet UIImageView *logoImgV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

@property(nonatomic,assign)CGFloat time;

@property(nonatomic,assign)CGFloat time2;
/** 音频播放器 */
@property (nonatomic,strong)AVAudioPlayer *player;

@property(nonatomic,strong) NSTimer * backTimer;
/** model */
@property (nonatomic, strong) HQAudioModel *model;
/** pause */
@property (nonatomic, assign) BOOL pause;


@end

@implementation TFAudioFileCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.startTime.textAlignment = NSTextAlignmentCenter;
    self.endTime.textAlignment = NSTextAlignmentCenter;
    
    self.slider.continuous = YES;// 设置可连续变化
    self.slider.minimumTrackTintColor = kUIColorFromRGB(0x51D0B1); //滑轮左边颜色，如果设置了左边的图片就不会显示
    self.slider.maximumTrackTintColor = kUIColorFromRGB(0xE7E7E7); //滑轮右边颜色，如果设置了右边的图片就不会显示
    self.slider.thumbTintColor = kUIColorFromRGB(0x51D0B1);//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
    
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响
    self.slider.userInteractionEnabled = NO;
    self.slider.value = 0;
    
    [self.playBtn setImage:[UIImage imageNamed:@"音频播放"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"音频暂停"] forState:UIControlStateSelected];
    
    //    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(playerStop)];
    //    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.playBtn addTarget:self action:@selector(playVedioAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.endTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:0.00]];
    self.startTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:0.00]];
}

//- (void)sliderValueChanged:(id *)sender{
//    
//    UISlider *slider = (UISlider *)sender;
//    self.endTime.text = [NSString stringWithFormat:@"%.1f", slider.value];
//}
- (void)sliderValueChanged:(id)sender {
    
    self.slider = (UISlider *)sender;
    self.endTime.text = [NSString stringWithFormat:@"%.1f", self.slider.value];
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
        
        self.endTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:self.time]];
        self.startTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:self.time2]];
        
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    self.playBtn.selected = NO;
    self.slider.value = 0;
    [self.backTimer invalidate];
    self.pause = NO;
    //    if ([self.model.voiceDuration integerValue] > 0) {
    //
    //        self.backTime.text = [NSString stringWithFormat:@"%.0f\"",[self.model.voiceDuration floatValue]/1000 ];
    //    }else{
    
    self.endTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:_player.duration]];
    self.startTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:0.00]];
    //    }
    self.time2 = 0;
}

-(void)timeUpMethod:(NSTimer *)timer{
    
    
    self.time -= 0.1;
    self.time2 += 0.1;
    
    self.endTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:self.time]];
    self.startTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:self.time2]];
    
    CGFloat value = 0;
    
    //    if ([self.model.voiceDuration integerValue] > 0) {
    //        value = (([self.model.voiceDuration integerValue]/1000 ) * 1.0 - self.time)*1.0/([self.model.voiceDuration integerValue]/1000 )*1.0;
    //    }else{
    
    value = (_player.duration - self.time)*1.0/(_player.duration)*1.0;
    //    }
    
    
    [self.slider setValue:value animated:YES];
    
    if (self.time <= 0) {
        
        [timer invalidate];
        
        self.playBtn.selected = NO;
        
        //        if ([self.model.voiceDuration integerValue] > 0) {
        //
        //            self.backTime.text = [NSString stringWithFormat:@"%.0f\"",[self.model.voiceDuration floatValue]/1000 ];
        //        }else{
        
        self.endTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:_player.duration]];
        self.startTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:0.00]];
        //        }
        
        self.slider.value = 0;
        self.time = 0;
    }
    
    
}

-(void)refreshAudioFileCellWithAudioModel:(HQAudioModel *)model withType:(NSInteger)type{
    
    self.model = model;
//    if (type == 0) {
//        self.bgView.hidden = YES;
//        self.timeLabel.hidden = NO;
//    }else{
//        self.bgView.hidden = NO;
//        self.timeLabel.hidden = YES;
//    }
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSString *fileName = [NSString stringWithFormat:@"%@.mp3",[HQHelper stringForMD5WithString:model.voiceUrl]];
    [HQHelper cacheFileWithUrl:self.model.voiceUrl fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        NSError *error1;
         _player = [[AVAudioPlayer alloc] initWithData:data error:&error1];
        if (error1 && error1.code ==1954115647) {
            _player= [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEGLayer3 error:&error1];

        }

        if (error1) {
            HQLog(@"播放器初始化失败%@",error1);
            return ;
        }
        
        [HQHelper saveCacheFileWithFileName:fileName data:data];
        
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
            
            self.endTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:_player.duration]];
            self.startTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:0.00]];
            
        });
        
        
    } fileHandler:^(NSString *path) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        NSError *error1;
        _player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:&error1];
        if (error1 && error1.code ==1954115647) {
            _player= [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] fileTypeHint:AVFileTypeMPEGLayer3 error:&error1];
            
        }
        
        if (error1) {
            HQLog(@"播放器初始化失败%@",error1);
            return ;
        }// 设置属性
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
            
            self.endTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:_player.duration]];
            self.startTime.text = [NSString stringWithFormat:@"%@",[HQHelper getMMSSFromSS:0.00]];
            
        });
    }];
    
}

+ (instancetype)audioFileCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAudioFileCell" owner:self options:nil] lastObject];
}

+ (instancetype)audioFileCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFAudioFileCell";
    TFAudioFileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self audioFileCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
