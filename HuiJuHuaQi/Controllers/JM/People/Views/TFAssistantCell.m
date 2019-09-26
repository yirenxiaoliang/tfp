//
//  TFAssistantCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAssistantCell.h"


@interface TFAssistantCell ()

/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 头像 */
@property (nonatomic, weak) UIButton *headBtn;
/** nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;
/** 已读 */
@property (nonatomic, weak) UIView *readView;
/** descLabel */
@property (nonatomic, weak) UILabel *descLabel;
/** 镖旗 */
@property (nonatomic, weak) UIButton *flagBtn;
/** paopao */
@property (nonatomic, weak) UIImageView *paopaoView;
/** contentLabel */
@property (nonatomic, weak) UILabel *contentLabel;
/** people */
@property (nonatomic, weak) UILabel *peopleLabel;
/** endTime */
@property (nonatomic, weak) UILabel *endTimeLabel;


@end

@implementation TFAssistantCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupChildView];
    }
    
    return self;
}

- (void)setupChildView{
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    timeLabel.textColor = WhiteColor;
    timeLabel.font = FONT(12);
    timeLabel.backgroundColor = HexColor(0xc2c2c2, 1);
    self.timeLabel = timeLabel;
    
    // 头像
    UIButton *headBtn = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(headBtnClicked)];
    [self.contentView addSubview:headBtn];
    headBtn.layer.cornerRadius = 2;
    headBtn.layer.masksToBounds = YES;
    self.headBtn = headBtn;
    
    // nameLabel
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    nameLabel.textColor = ExtraLightBlackTextColor;
    nameLabel.font = FONT(14);
    self.nameLabel = nameLabel;
    
    // 已读
    UIView *readView = [[UIView alloc] init];
    [self.contentView addSubview:readView];
    self.readView = readView;
    readView.layer.masksToBounds = YES;
    readView.layer.cornerRadius = 4;
    readView.backgroundColor = HexColor(0xffc057, 1);
    
    // descLabel
    UILabel *descLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descLabel];
    descLabel.textColor = LightGrayTextColor;
    descLabel.font = FONT(14);
    self.descLabel = descLabel;
    
    // 镖旗
    UIButton *flagBtn = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(flagBtnClicked)];
    [self.contentView addSubview:flagBtn];
    self.flagBtn = flagBtn;
    
    // paopao
    UIImageView *paopaoView = [[UIImageView alloc] init];
    [self.contentView addSubview:paopaoView];
    self.paopaoView = paopaoView;
    
    // contentLabel
    UILabel *contentLabel = [[UILabel alloc] init];
    [paopaoView addSubview:contentLabel];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = BlackTextColor;
    contentLabel.font = FONT(16);
    self.contentLabel = contentLabel;
    
    // people
    UILabel *peopleLabel = [[UILabel alloc] init];
    [paopaoView addSubview:peopleLabel];
    peopleLabel.textColor = FinishedTextColor;
    peopleLabel.font = FONT(14);
    self.peopleLabel = peopleLabel;
    
    // endTime
    UILabel *endTimeLabel = [[UILabel alloc] init];
    [paopaoView addSubview:endTimeLabel];
    endTimeLabel.textColor = FinishedTextColor;
    endTimeLabel.font = FONT(14);
    self.endTimeLabel = endTimeLabel;
}

- (void)headBtnClicked{
    
}
- (void)flagBtnClicked{
    
}

+(instancetype)assistantCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFAssistantCell";
    TFAssistantCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFAssistantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
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
