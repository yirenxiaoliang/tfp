//
//  TFAtdOneTFCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAtdOneTFCell.h"

@implementation TFAtdOneTFCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentTF.userInteractionEnabled = NO;
    [self.enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)enterBtnAction {
    
    if ([self.delegate respondsToSelector:@selector(enterBtnClicked:)]) {
        
        [self.delegate enterBtnClicked:self.tag];
    }
}

+ (instancetype)TFAtdOneTFCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAtdOneTFCell" owner:self options:nil] lastObject];
}

+ (instancetype)atdOneTFCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFAtdOneTFCell";
    TFAtdOneTFCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFAtdOneTFCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
