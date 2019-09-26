//
//  TFAtdSingleLableCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAtdSingleLableCell.h"

@implementation TFAtdSingleLableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}


+ (instancetype)TFAtdSingleLableCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAtdSingleLableCell" owner:self options:nil] lastObject];
}

+ (instancetype)atdSingleLableCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFAtdSingleLableCell";
    TFAtdSingleLableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFAtdSingleLableCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
@end
