//
//  HQTFThreeLabelCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFThreeLabelCell.h"

@interface HQTFThreeLabelCell ()


@end


@implementation HQTFThreeLabelCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.leftLabel.textColor = ExtraLightBlackTextColor;
    self.rightLabel.textColor = GreenColor;
    
}

+ (instancetype)threeLabelCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFThreeLabelCell" owner:self options:nil] lastObject];
}

+ (HQTFThreeLabelCell *)threeLabelCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFThreeLabelCell";
    HQTFThreeLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self threeLabelCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
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
