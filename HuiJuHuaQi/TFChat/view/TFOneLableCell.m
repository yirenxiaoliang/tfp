//
//  TFOneLableCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFOneLableCell.h"

@interface TFOneLableCell ()

@end

@implementation TFOneLableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.enterBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    self.contentView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    

}


- (void)addAction {
    
    if ([self.delegate respondsToSelector:@selector(addPCDateClicked:)]) {
        
        [self.delegate addPCDateClicked:self];
    }
}

+ (instancetype)TFOneLableCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFOneLableCell" owner:self options:nil] lastObject];
}


+ (instancetype)OneLableCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFOneLableCell";
    TFOneLableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFOneLableCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
