//
//  HQPlayerView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/3/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQPlayerView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *playBtn;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playAndTitleDisLayout;

@property (nonatomic,strong)NSURL * recorderUrl;

@property (nonatomic,assign)CGFloat soundceTime;

- (IBAction)playVedioAction:(id)sender;

- (IBAction)deleteVedioAction:(id)sender;

- (void)refreshPlayCellWithTitle:(NSString *)titleStr
                             Url:(NSString *)recorderUrlStr
                    voiceTimeInt:(NSInteger)voiceTimeInt
                    netWorkState:(BOOL)netWorkState;


@end
