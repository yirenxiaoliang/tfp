//
//  HQTFBenchCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFBenchCell.h"
#import "TFMainScheduleModel.h"

@interface HQTFBenchCell ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titteHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;

@end

@implementation HQTFBenchCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = BackGroudColor;
    self.bgView.backgroundColor = WhiteColor;
    self.topLine.hidden = YES;
    
    self.textView.textColor = ExtraLightBlackTextColor;
    self.textView.font = FONT(14);
    self.textView.userInteractionEnabled = NO;
    self.textView.numberOfLines = 0;
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = FONT(20);
    self.titleLabel.numberOfLines = 0;
//    self.textView.backgroundColor = GreenColor;
//    self.titleLabel.backgroundColor = RedColor;
    
    self.sourceLabel.textColor = HexColor(0xa0a0ae);
    self.sourceLabel.font = FONT(12);
    

}

+ (instancetype)benchCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFBenchCell" owner:self options:nil] lastObject];
}



+ (HQTFBenchCell *)benchCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFBenchCell";
    HQTFBenchCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self benchCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bottomLine.hidden = YES;
    return cell;
}

/** 动态刷新 */
-(void)refreshBenchCellWithModel:(id)model
{
    TFMainScheduleModel *schedule = (TFMainScheduleModel *)model;
    
    // 日程类型
    switch (schedule.scheduleType) {
        case 0:
        {
            self.typeImage.image = [UIImage imageNamed:@"投票气泡"];
        }
            break;
        case 1:
        {
            self.typeImage.image = [UIImage imageNamed:@"审批气泡"];
        }
            break;
        case 2:
        {
            self.typeImage.image = [UIImage imageNamed:@"任务气泡"];
        }
            break;
        case 3:
        {
            self.typeImage.image = [UIImage imageNamed:@"订单气泡"];
        }
            break;
        case 4:
        {
            self.typeImage.image = [UIImage imageNamed:@"日程气泡"];
        }
            break;
        case 5:
        {
            self.typeImage.image = [UIImage imageNamed:@"公告气泡"];
        }
            break;
            
        default:
            break;
    }
    
    // 日程标题
    self.titleLabel.text = schedule.scheduleTitle;
    
    CGSize titleSize = [HQHelper sizeWithFont:FONT(21) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:schedule.scheduleTitle];
    self.titteHeight.constant = titleSize.height;
    
    // 日程内容
    self.textView.text = schedule.scheduleContent;
    if (schedule.scheduleContent && ![schedule.scheduleContent isEqualToString:@""]) {
        
        CGSize contentSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:schedule.scheduleContent];
        self.contentHeight.constant = contentSize.height+5;
        self.contentTop.constant = 8;
    }else{
        
        self.contentTop.constant = 0;
        self.contentHeight.constant = 0;
    }
    
    // 日程来源
    self.sourceLabel.text = [NSString stringWithFormat:@"来源：%@",schedule.scheduleSource];
    
}

/** 固定刷新 */
-(void)refreshSolidBenchCellWithModel:(id)model
{
    TFMainScheduleModel *schedule = (TFMainScheduleModel *)model;
    
    self.titleLabel.numberOfLines = 1;
    
    NSInteger line = [HQHelper returnLineNumberOfString:schedule.scheduleContent font:FONT(14) textWidth:SCREEN_WIDTH-75];
    
    if (line<=0) {
        self.textView.hidden = YES;
        self.contentTop.constant = 0;
        self.textView.numberOfLines = 0;
        self.contentHeight.constant = 0;
    }else if (line == 1){
        self.textView.hidden = NO;
        self.contentTop.constant = 8;
        self.textView.numberOfLines = 1;
        self.contentHeight.constant = 19;
    }else{
        self.textView.hidden = NO;
        self.contentTop.constant = 8;
        self.textView.numberOfLines = 2;
        self.contentHeight.constant = 34;
    }
    
    // 日程类型
    switch (schedule.scheduleType) {
        case 0:
        {
            self.typeImage.image = [UIImage imageNamed:@"投票气泡"];
        }
            break;
        case 1:
        {
            self.typeImage.image = [UIImage imageNamed:@"审批气泡"];
        }
            break;
        case 2:
        {
            self.typeImage.image = [UIImage imageNamed:@"任务气泡"];
        }
            break;
        case 3:
        {
            self.typeImage.image = [UIImage imageNamed:@"订单气泡"];
        }
            break;
        case 4:
        {
            self.typeImage.image = [UIImage imageNamed:@"日程气泡"];
        }
            break;
        case 5:
        {
            self.typeImage.image = [UIImage imageNamed:@"公告气泡"];
        }
            break;
            
        default:
            break;
    }
    
    // 日程标题
    self.titleLabel.text = schedule.scheduleTitle;
    
//    CGSize titleSize = [HQHelper sizeWithFont:FONT(21) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:schedule.scheduleTitle];
    //    self.titteHeight.constant = titleSize.height;
        self.titteHeight.constant = 22;
    
    // 日程内容
    self.textView.text = schedule.scheduleContent;
//    CGSize contentSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:schedule.scheduleContent];
//    self.contentHeight.constant = contentSize.height+5;
    
    // 日程来源
    self.sourceLabel.text = [NSString stringWithFormat:@"来源：%@",schedule.scheduleSource];
    
}




/** 动态高度 */
+(CGFloat)refreshBenchCellHeightWithModel:(id)model{
    
    CGFloat height = 8;//cell间距
    height += 17;// 顶部
    
    TFMainScheduleModel *schedule = (TFMainScheduleModel *)model;
    CGSize titleSize = [HQHelper sizeWithFont:FONT(21) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:schedule.scheduleTitle];
    height += titleSize.height;
    
    if (schedule.scheduleContent && ![schedule.scheduleContent isEqualToString:@""]) {
        height += 8;// 标题与内容之间的间距
        
        CGSize contentSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:schedule.scheduleContent];
        
        height += contentSize.height+5;//内容高
    }
    height += 8;// 来源与内容之间的间距
    
    height += 13;// 来源高度
    
    height += 15;// 底部
    
    
    return height;
}
/** 固定高度 */
+(CGFloat)refreshSolidBenchCellHeightWithModel:(id)model{
    
    TFMainScheduleModel *schedule = (TFMainScheduleModel *)model;
    NSInteger line = [HQHelper returnLineNumberOfString:schedule.scheduleContent font:FONT(14) textWidth:SCREEN_WIDTH-75];
    
    if (line<=0) {
        return 82;
    }else if (line == 1){
        return 110;
    }else{
        return 130;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
