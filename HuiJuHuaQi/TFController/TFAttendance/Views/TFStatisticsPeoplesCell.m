//
//  TFStatisticsPeoplesCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsPeoplesCell.h"

@interface TFStatisticsPeoplesCell ()


@end

@implementation TFStatisticsPeoplesCell


- (void)awakeFromNib {

    [super awakeFromNib];
}

+ (instancetype)statisticsPeoplesCell {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFStatisticsPeoplesCell" owner:self options:nil] lastObject];
}

+ (instancetype)statisticsPeoplesWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"TFStatisticsPeoplesCell";
    TFStatisticsPeoplesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self statisticsPeoplesCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.topLine.hidden = YES;
    return cell;
}

@end
