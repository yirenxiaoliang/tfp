//
//  TFLookMoreCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLookMoreCell.h"

@implementation TFLookMoreCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

+ (instancetype)TFLookMoreCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFLookMoreCell" owner:self options:nil] lastObject];
}


+ (instancetype)lookMoreCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFLookMoreCell";
    TFLookMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFLookMoreCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
@end
