//
//  TFSelectFolderCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectFolderCell.h"

@interface TFSelectFolderCell ()

@end

@implementation TFSelectFolderCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self.selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    
}

+ (instancetype)TFSelectFolderCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFSelectFolderCell" owner:self options:nil] lastObject];
}


+ (instancetype)SelectFolderCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFSelectFolderCell";
    TFSelectFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFSelectFolderCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

- (void)selectAction {

    if ([self.delegate respondsToSelector:@selector(selectFolder:)]) {
        
        [self.delegate selectFolder:self.index];
    }
}

@end
