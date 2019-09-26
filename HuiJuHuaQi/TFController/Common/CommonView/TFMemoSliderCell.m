//
//  TFMemoSliderCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMemoSliderCell.h"

@implementation TFMemoSliderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bgView addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    }
    return self;
}

+ (instancetype)memoSliderCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFMemoSliderCell";
    TFMemoSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
