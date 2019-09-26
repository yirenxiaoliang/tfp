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
/** model */
@property (nonatomic, strong) TFAssistantFrameModel *frameModel;


@end

@implementation TFAssistantCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupChildView];
        self.backgroundColor = ClearColor;
        self.contentView.backgroundColor = ClearColor;
        self.bottomLine.hidden = YES;
    }
    
    return self;
}

- (void)setupChildView{
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    timeLabel.textColor = WhiteColor;
    timeLabel.font = FONT(12);
    timeLabel.backgroundColor = HexAColor(0xc2c2c2, 1);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel = timeLabel;
    timeLabel.layer.cornerRadius = 4;
    timeLabel.layer.masksToBounds = YES;
    timeLabel.layer.borderWidth = 1;
    timeLabel.layer.borderColor = HexAColor(0xf2f2f2, 1).CGColor;
    
    
    
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
    readView.backgroundColor = HexAColor(0xffc057, 1);
    
    // descLabel
    UILabel *descLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descLabel];
    descLabel.textColor = LightGrayTextColor;
    descLabel.font = FONT(14);
    self.descLabel = descLabel;
    
    // 镖旗
    UIButton *flagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flagBtn addTarget:self action:@selector(flagBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:flagBtn];
    self.flagBtn = flagBtn;
    
    // paopao
    UIImageView *paopaoView = [[UIImageView alloc] init];
    [self.contentView addSubview:paopaoView];
    self.paopaoView = paopaoView;
    paopaoView.contentMode = UIViewContentModeScaleToFill;
    
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
    endTimeLabel.numberOfLines = 0;
}

- (void)headBtnClicked{
    
}
- (void)flagBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(assistantCell:didClikedFlagWithModel:)]) {
        [self.delegate assistantCell:self didClikedFlagWithModel:self.frameModel.assistantModel];
    }
}


-(void)refreshAssistantCellWithAssistantFrameModel:(TFAssistantFrameModel *)model{
    
    self.frameModel = model;
    TFAssistantModel *assistantModel = model.assistantModel;
    
    /** 时间 */
    self.timeLabel.frame = model.timeLabelRect;
    self.timeLabel.text = [HQHelper nsdateToTime:[assistantModel.createDate longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    /** 头像 */
    self.headBtn.frame = model.headBtnRect;
    
    /** nameLabelRect */
    self.nameLabel.frame = model.nameLabelRect;
    
//    switch ([assistantModel.itemId integerValue]) {
//        case AssistantTypeFile:
//        {
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"文件库40"] forState:UIControlStateNormal];
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"文件库40"] forState:UIControlStateHighlighted];
//            self.nameLabel.text = @"文件库助手";
//        }
//            break;
//        case AssistantTypeTask:
//        {
            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"任务40"] forState:UIControlStateNormal];
            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"任务40"] forState:UIControlStateHighlighted];
            self.nameLabel.text = @"任务助手";
//        }
//            break;
//        case AssistantTypeSchedule:
//        {
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"日程40"] forState:UIControlStateNormal];
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"日程40"] forState:UIControlStateHighlighted];
//            self.nameLabel.text = @"日程助手";
//        }
//            break;
//        case AssistantTypeNote:
//        {
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"随手记40"] forState:UIControlStateNormal];
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"随手记40"] forState:UIControlStateHighlighted];
//            self.nameLabel.text = @"随手记助手";
//        }
//            break;
//        case AssistantTypeApproval:
//        {
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"审批40"] forState:UIControlStateNormal];
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"审批40"] forState:UIControlStateHighlighted];
//            self.nameLabel.text = @"审批助手";
//        }
//            break;
//        case AssistantTypeNotice:
//        {
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"公告40"] forState:UIControlStateNormal];
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"公告40"] forState:UIControlStateHighlighted];
//            self.nameLabel.text = @"公告助手";
//        }
//            break;
//        case AssistantTypeReport:
//        {
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"工作汇报40"] forState:UIControlStateNormal];
//            [self.headBtn setBackgroundImage:[UIImage imageNamed:@"工作汇报40"] forState:UIControlStateHighlighted];
//            self.nameLabel.text = @"工作汇报助手";
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    
    
    /** 已读 */
    self.readView.frame = model.readViewRect;
    self.readView.hidden = [assistantModel.isRead isEqualToNumber:@0]?NO:YES;
    
    /** descLabelRect */
    self.descLabel.frame = model.descLabelRect;
    self.descLabel.text = assistantModel.sendContent;
    
    /** 镖旗 */
//    self.flagBtn.frame = model.flagBtnRect;
//    if (!assistantModel.isHandle || [assistantModel.isHandle isEqualToNumber:@0]) {
//        [self.flagBtn setImage:[UIImage imageNamed:@"待处理"] forState:UIControlStateNormal];
//        [self.flagBtn setImage:[UIImage imageNamed:@"待处理"] forState:UIControlStateHighlighted];
//    }else{
//        [self.flagBtn setImage:[UIImage imageNamed:@"待处理1"] forState:UIControlStateNormal];
//        [self.flagBtn setImage:[UIImage imageNamed:@"待处理1"] forState:UIControlStateHighlighted];
//    }
    
    /** paopao */
    self.paopaoView.frame = model.paopaoViewRect;
    NSInteger leftCapWidth = 37 * 0.5f;
    NSInteger topCapHeight = 40 * 0.9f;
    UIImage *image = [UIImage imageNamed:@"普通paopao"];
    if ([assistantModel.priority isEqualToNumber:@1]) {
        image = [UIImage imageNamed:@"紧急paopao"];
    }else if ([assistantModel.priority isEqualToNumber:@2]){
        image = [UIImage imageNamed:@"非常紧急paopao"];
    }
    
    self.paopaoView.image=[image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    /** contentLabelRect */
    self.contentLabel.frame = model.contentLabelRect;
    self.contentLabel.text = assistantModel.msgBody;
    
    /** people */
    self.peopleLabel.frame = model.peopleLabelRect;
    self.peopleLabel.hidden = model.peopleLabelHidden;
    
    
    /** endTime */
    self.endTimeLabel.frame = model.endTimeLabelRect;
    
    // people/time
    if (!assistantModel.comment || [assistantModel.comment isEqualToString:@""]) {
       
        self.peopleLabel.text = [NSString stringWithFormat:@"负责人：%@",assistantModel.createrName];
        self.endTimeLabel.text = [NSString stringWithFormat:@"截止时间：%@",[HQHelper nsdateToTime:[assistantModel.startTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
        
    }else{
        
        self.peopleLabel.text = @"";
        self.endTimeLabel.text = assistantModel.comment;
    }

    switch ([assistantModel.itemId integerValue]) {
        case AssistantTypeFile:
        {
            
        }
            break;
        case AssistantTypeTask:
        {
            self.endTimeLabel.text = [NSString stringWithFormat:@"截止时间：%@",[HQHelper nsdateToTime:[assistantModel.endTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
        }
            break;
        case AssistantTypeSchedule:
        {
            
        }
            break;
        case AssistantTypeNote:
        {
            
        }
            break;
        case AssistantTypeApproval:
        {
            
        }
            break;
        case AssistantTypeNotice:
        {
            
        }
            break;
        case AssistantTypeReport:
        {
            
        }
            break;
            
        default:
            break;
    }

    
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
