//
//  HQSelectTimeCell.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSelectTimeCell.h"
#import "NSDate+Calendar.h"

@interface HQSelectTimeCell ()




@end

@implementation HQSelectTimeCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.timeTitle.text = @"时间";
    self.timeTitle.textColor = CellTitleNameColor;
    self.timeTitle.font = FONT(14);
    self.time.textColor = BlackTextColor;
    self.time.font = FONT(16);
    
    self.time.textAlignment = NSTextAlignmentLeft;
    self.time.text = @"";
    
}


+ (instancetype)selectTimeCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQSelectTimeCell" owner:self options:nil] lastObject];
}


+ (instancetype)selectTimeCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"selectTimeCell";
    HQSelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self selectTimeCell];
    }
    cell.layer.masksToBounds = YES;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    _timeTitleWidthLayout.constant = [HQHelper sizeWithFont:_timeTitle.font
                                                    maxSize:CGSizeMake(1000, 20)
                                                   titleStr:_timeTitle.text].width + 17;
    
//    if (_arrowShowState) {
//        
//        self.arrow.hidden = NO;
//        self.arrowWidth.constant = 18;
//    }else {
//        
//        self.arrow.hidden = YES;
//        self.arrowWidth.constant = 4;
//    }
}



- (void)setArrowShowState:(BOOL)arrowShowState
{
    _arrowShowState = arrowShowState;
    
    if (_arrowShowState) {
        
        self.arrow.hidden = NO;
        self.arrowWidth.constant = 18;
    }else {
        
        self.arrow.hidden = YES;
        self.arrowWidth.constant = 4;
    }
}


- (void)arrowHidden{
    
    self.arrow.hidden = YES;
    self.arrowWidth.constant = 4;
}



+ (CGFloat)getSelectTimeCellHeight:(NSString *)title
                           content:(NSString *)content
                    arrowShowState:(BOOL)arrowShowState
{

    CGFloat cellHeight = 22;
    
    CGFloat titleWidth = [HQHelper sizeWithFont:FONT(17)
                                        maxSize:CGSizeMake(1000, 20)
                                       titleStr:title].width + 17;
    CGFloat arrowWidth;
    if (arrowShowState) {
        arrowWidth = 18;
    }else {
        arrowWidth = 4;
    }
    
    CGFloat textWidth = SCREEN_WIDTH - titleWidth - arrowWidth - 20;
    
    NSInteger contentLineNum = [HQHelper returnLineNumberOfString:content font:FONT(17) textWidth:textWidth];
    
    cellHeight += contentLineNum * 20;
    
    return cellHeight;
}



@end
