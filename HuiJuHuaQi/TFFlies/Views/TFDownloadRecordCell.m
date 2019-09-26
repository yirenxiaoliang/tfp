//
//  TFDownloadRecordCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFDownloadRecordCell.h"


@implementation TFDownloadRecordCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.photoImg.layer.cornerRadius = 18.0;
    self.photoImg.layer.masksToBounds = YES;
}

+ (instancetype)TFDownloadRecordCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFDownloadRecordCell" owner:self options:nil] lastObject];
}



+ (instancetype)DownloadRecordCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFDownloadRecordCell";
    TFDownloadRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFDownloadRecordCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
