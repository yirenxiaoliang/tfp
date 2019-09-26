//
//  HQBaseTableViewCell.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/26.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseTableViewCell.h"

@interface HQBaseTableViewCell ()



@end

@implementation HQBaseTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _topLine =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _topLine.backgroundColor = HexColor(0xd9d9d9);
        [self.contentView addSubview:_topLine];
        _topLine.hidden = YES;
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = HexColor(0xd9d9d9);
        [self.contentView addSubview:_lineView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}




- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
    _topLine =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    _topLine.backgroundColor = HexColor(0xd9d9d9);
    [self.contentView addSubview:_topLine];
    _topLine.hidden = YES;
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    _lineView.backgroundColor = HexColor(0xd9d9d9);
    [self.contentView addSubview:_lineView];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)layoutSubviews
{
    _topLine.top = 0;
    _lineView.bottom = self.contentView.height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)model
{
    return 0;
}

@end
