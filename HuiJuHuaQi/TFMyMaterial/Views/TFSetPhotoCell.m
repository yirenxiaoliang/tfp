//
//  TFSetPhotoCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSetPhotoCell.h"

@implementation TFSetPhotoCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.photoImg.layer.cornerRadius = 45/2.0;
    self.photoImg.layer.masksToBounds = YES;
}

+ (instancetype)TFSetPhotoCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFSetPhotoCell" owner:self options:nil] lastObject];
}



+ (instancetype)SetPhotoCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFSetPhotoCell";
    TFSetPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFSetPhotoCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
