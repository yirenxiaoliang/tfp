//
//  TFCustomChangeCell.m
//  HuiJuHuaQi
//
//  Created by HQ-30 on 2017/12/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomChangeCell.h"

@interface TFCustomChangeCell ()


@end

@implementation TFCustomChangeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *box = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未选中"]];
        [self.contentView addSubview:box];
        self.box = box;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = LightBlackTextColor;
        label.font = FONT(14);
        [self.contentView addSubview:label];
        self.name = label;
        
        [box mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
        
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(45);
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}



+ (instancetype)customChangeCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFCustomChangeCell";
    TFCustomChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomChangeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.topLine.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
