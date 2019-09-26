//
//  TFAddPCAprrovalCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/15.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPCAprrovalCell.h"

@interface TFAddPCAprrovalCell ()


@end

@implementation TFAddPCAprrovalCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.textField.userInteractionEnabled = NO;
    self.textField.textColor = BlackTextColor;
}


//配置数据
- (void)configAddPCAprrovalCellWithTableView:(NSArray *)model {
    
    
    
}

+ (instancetype)TFAddPCAprrovalCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAddPCAprrovalCell" owner:self options:nil] lastObject];
}

+ (instancetype)addPCAprrovalCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFAddPCAprrovalCell";
    TFAddPCAprrovalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFAddPCAprrovalCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
