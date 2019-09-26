//
//  HQTFTaskCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskCell.h"
#import "TFMainTaskModel.h"

@interface HQTFTaskCell ()
@property (weak, nonatomic) IBOutlet UIButton *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textView;
@property (weak, nonatomic) IBOutlet UILabel *sourseLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;
@property (weak, nonatomic) IBOutlet UIView *priority;

@end

@implementation HQTFTaskCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = ClearColor;
    self.bgView.backgroundColor = WhiteColor;
    self.topLine.hidden = YES;
    self.textView.numberOfLines = 0;
    self.textView.textColor = ExtraLightBlackTextColor;
    self.textView.font = FONT(14);
    self.textView.userInteractionEnabled = NO;
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = FONT(20);
    self.titleLabel.numberOfLines = 0;
    
    self.sourseLabel.textColor = FinishedTextColor;
    self.sourseLabel.font = FONT(12);
//    self.titleLabel.backgroundColor = RedColor;
//    self.textView.backgroundColor = GreenColor;
    [self.typeButton setTitleColor:RedColor forState:UIControlStateNormal];
    [self.typeButton setTitleColor:RedColor forState:UIControlStateHighlighted];
}


+ (instancetype)taskCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFTaskCell" owner:self options:nil] lastObject];
}



+ (HQTFTaskCell *)taskCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFTaskCell";
    HQTFTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self taskCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/** 动态刷新 */
-(void)refreshTaskCellWithModel:(id)model{
    
    TFMainTaskModel *task = (TFMainTaskModel*)model;
    
    // 是否申请延期
    switch (task.taskDelay) {
        case 0:
        {
            [self.image setImage:[UIImage imageNamed:@"选择12"] forState:UIControlStateNormal];
            [self.image setImage:[UIImage imageNamed:@"选择12"] forState:UIControlStateHighlighted];
        }
            break;
        case 1:
        {
            [self.image setImage:[UIImage imageNamed:@"选择12copy"] forState:UIControlStateNormal];
            [self.image setImage:[UIImage imageNamed:@"选择12copy"] forState:UIControlStateHighlighted];
        }
            break;
            
        default:
            break;
    }
    
    // 任务标题
    self.titleLabel.text = task.taskTitle;
    
    CGSize titleSize = [HQHelper sizeWithFont:FONT(21) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:task.taskTitle];
    self.titleHeight.constant = titleSize.height;
    
    // 任务内容
    self.textView.text = task.taskContent;
    
    if (task.taskContent && ![task.taskContent isEqualToString:@""]) {
        
        CGSize contentSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:task.taskContent];
        self.contentHeight.constant = contentSize.height+5;
        self.contentTop.constant = 8;
    }else{
        
        self.contentHeight.constant = 0;
        self.contentTop.constant = 0;
    }
    
    // 来源
    self.sourseLabel.text = task.taskSource;
    
    // 时间
    [self.typeButton setTitle:[HQHelper nsdateToTime:[task.taskDate longLongValue] formatStr:@"MM-dd"] forState:UIControlStateNormal];
    [self.typeButton setTitle:[HQHelper nsdateToTime:[task.taskDate longLongValue] formatStr:@"MM-dd"] forState:UIControlStateHighlighted];
}

/** 固定刷新 */
-(void)refreshSolidTaskCellWithModel:(id)model{
    
    TFMainTaskModel *task = (TFMainTaskModel*)model;
    self.titleLabel.numberOfLines = 1;
    
    NSInteger line = [HQHelper returnLineNumberOfString:task.taskContent font:FONT(14) textWidth:SCREEN_WIDTH-75];
    
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
    // 紧急度
    switch (task.taskPriority) {
        case 0:
        {
            self.priority.hidden = YES;
            self.priority.backgroundColor = ClearColor;
        }
            break;
        case 1:
        {
            self.priority.hidden = NO;
            self.priority.backgroundColor = HexAColor(0xffc057, 1);
        }
            break;
        case 2:
        {
            self.priority.hidden = NO;
            self.priority.backgroundColor = ClearColor;
            self.priority.backgroundColor = HexAColor(0xff6f00, 1);
        }
            break;
            
        default:
            break;
    }

    // 是否申请延期
    switch (task.taskDelay) {
        case 0:
        {
            [self.image setImage:[UIImage imageNamed:@"选择12"] forState:UIControlStateNormal];
            [self.image setImage:[UIImage imageNamed:@"选择12"] forState:UIControlStateHighlighted];
            
            [self.typeButton setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
            [self.typeButton setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
            [self.typeButton setImage:[UIImage imageNamed:@"截止时间"] forState:UIControlStateNormal];
            [self.typeButton setImage:[UIImage imageNamed:@"截止时间"] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [self.image setImage:[UIImage imageNamed:@"选择12copy"] forState:UIControlStateNormal];
            [self.image setImage:[UIImage imageNamed:@"选择12copy"] forState:UIControlStateHighlighted];
            [self.typeButton setTitleColor:RedColor forState:UIControlStateNormal];
            [self.typeButton setTitleColor:RedColor forState:UIControlStateNormal];
            [self.typeButton setImage:[UIImage imageNamed:@"时间超期"] forState:UIControlStateNormal];
            [self.typeButton setImage:[UIImage imageNamed:@"时间超期"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    // 是否完成
    switch (task.taskFinished) {
        case 0:
        {
            self.titleLabel.textColor = BlackTextColor;
        }
            break;
        case 1:
        {
            self.titleLabel.textColor = FinishedTextColor;
            [self.image setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
            [self.image setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateHighlighted];
            [self.typeButton setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
            [self.typeButton setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
            [self.typeButton setImage:[UIImage imageNamed:@"截止时间"] forState:UIControlStateNormal];
            [self.typeButton setImage:[UIImage imageNamed:@"截止时间"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    // 任务标题
    self.titleLabel.text = task.taskTitle;
    
//    CGSize titleSize = [HQHelper sizeWithFont:FONT(21) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:task.taskTitle];
//    self.titleHeight.constant = titleSize.height;
    self.titleHeight.constant = 22;

    
    // 任务内容
    self.textView.text = task.taskContent;
    
//    if (task.taskContent && ![task.taskContent isEqualToString:@""]) {
//        
//        CGSize contentSize = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:task.taskContent];
//        self.contentHeight.constant = contentSize.height+5;
//        self.contentTop.constant = 8;
//    }else{
//        
//        self.contentHeight.constant = 0;
//        self.contentTop.constant = 0;
//    }
    
    // 来源
    self.sourseLabel.text = task.taskSource;
    
    // 时间
    [self.typeButton setTitle:[NSString stringWithFormat:@" %@",[HQHelper nsdateToTime:[task.taskDate longLongValue] formatStr:@"MM-dd"]] forState:UIControlStateNormal];
    [self.typeButton setTitle:[NSString stringWithFormat:@" %@",[HQHelper nsdateToTime:[task.taskDate longLongValue] formatStr:@"MM-dd"]] forState:UIControlStateHighlighted];

    
}


/** 动态高度 */
+(CGFloat)refreshTaskCellHeightWithModel:(id)model{
    
    
    TFMainTaskModel *task = (TFMainTaskModel*)model;
    CGFloat height = 8;//cell间距
    height += 17;// 顶部
    
    CGSize titleSize = [HQHelper sizeWithFont:FONT(21) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:task.taskTitle];
    height += titleSize.height;
    
    
    if (task.taskContent && ![task.taskContent isEqualToString:@""]) {
        
        CGSize contentSize = [HQHelper sizeWithFont:FONT(15) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:task.taskContent];
        height += 8;// 标题与内容之间的间距
        height += contentSize.height+5;//内容高
    }
    
    height += 8;// 来源与内容之间的间距
    height += 13;// 来源高度
    height += 12;// 底部
    
    
    return height;
}

/** 固定高度 */
+(CGFloat)refreshSolidTaskCellHeightWithModel:(id)model{
    
    TFMainTaskModel *task = (TFMainTaskModel*)model;
    NSInteger line = [HQHelper returnLineNumberOfString:task.taskContent font:FONT(14) textWidth:SCREEN_WIDTH-75];
    
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
