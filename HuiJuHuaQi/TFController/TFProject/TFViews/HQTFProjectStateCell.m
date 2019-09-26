//
//  HQTFProjectStateCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectStateCell.h"

@interface HQTFProjectStateCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@end

@implementation HQTFProjectStateCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.titleLabel.font = FONT(14);
    self.titleLabel.text = @"状态";
    
}

-(void)setType:(ProjectStateCellType)type{
    _type = type;
    
    switch (type) {
        case ProjectStateCellGoOn:
        {
            
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"进行中state"] forState:UIControlStateHighlighted];
            
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"进行中state"] forState:UIControlStateNormal];
        }
            break;
        case ProjectStateCellPause:
        {
            
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已暂停state"] forState:UIControlStateHighlighted];
            
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已暂停state"] forState:UIControlStateNormal];
        }
            break;
        case ProjectStateCellFinish:
        {
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已完成state"] forState:UIControlStateHighlighted];
            
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已完成state"] forState:UIControlStateNormal];
            
        }
            break;
        case ProjectStateCellOutDate:
        {
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已超期state"] forState:UIControlStateHighlighted];
            
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已超期state"] forState:UIControlStateNormal];
            
        }
            break;
        case ProjectStateCellDelete:
        {
            
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已删除state"] forState:UIControlStateHighlighted];
            
            [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已删除state"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

+ (instancetype)projectStateCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFProjectStateCell" owner:self options:nil] lastObject];
}

+ (HQTFProjectStateCell *)projectStateCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFProjectStateCell";
    HQTFProjectStateCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self projectStateCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
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
