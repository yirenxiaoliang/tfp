//
//  TFOtherSetItemCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFOtherSetItemCell.h"

@implementation TFOtherSetItemCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.setBtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
}

//配置数据
- (void)configOtherSetItemCellWithTableView:(NSInteger)type {
    
    if (type == 1) {
        
        self.contentTF.hidden = YES;
        self.titleTopCons.constant = 9.0;
        [self.setBtn setTitle:@"新增" forState:UIControlStateNormal];
    }
    else {
        
        self.contentTF.hidden = NO;
        self.titleTopCons.constant = -2.0;
        [self.setBtn setTitle:@"设置" forState:UIControlStateNormal];
    }
    
    [self.setBtn setTitleColor:GreenColor forState:UIControlStateNormal];
}

- (void)setAction {
    
    if ([self.delegate respondsToSelector:@selector(setButtonClicked:)]) {
        
        [self.delegate setButtonClicked:self.indexPath];
    }
}

+ (instancetype)TFOtherSetItemCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFOtherSetItemCell" owner:self options:nil] lastObject];
}

+ (instancetype)otherSetItemCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFOtherSetItemCell";
    TFOtherSetItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFOtherSetItemCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
