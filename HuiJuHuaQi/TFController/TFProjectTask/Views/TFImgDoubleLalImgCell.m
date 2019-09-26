//
//  TFImgDoubleLalImgCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFImgDoubleLalImgCell.h"

@interface TFImgDoubleLalImgCell ()

@property (weak, nonatomic) IBOutlet UIButton *heartBtn;
@property (weak, nonatomic) IBOutlet UIButton *enterImg;


@end

@implementation TFImgDoubleLalImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = ExtraLightBlackTextColor;
    [self.heartBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.heartBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    self.heartBtn.titleLabel.font = FONT(14);
    self.nameLabel.font = FONT(14);
    [self.enterImg setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    [self.enterImg setImage:IMG(@"下一级浅灰") forState:UIControlStateHighlighted];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    
    [self.heartBtn setImage:IMG(@"good") forState:UIControlStateNormal];
    [self.heartBtn setImage:IMG(@"good") forState:UIControlStateHighlighted];
    [self.heartBtn setImage:IMG(@"goodS") forState:UIControlStateSelected];
    [self.heartBtn setTitle:@"   点赞" forState:UIControlStateNormal];
    [self.heartBtn setTitle:@"   点赞" forState:UIControlStateHighlighted];
    [self.heartBtn setTitle:@"   已赞" forState:UIControlStateSelected];
    
    [self.heartBtn addTarget:self action:@selector(heartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)heartBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(cellDidClickedFirstBtn)]) {
        [self.delegate cellDidClickedFirstBtn];
    }
}

-(void)refreshCellWithPeoples:(NSArray *)peoples{
    
    BOOL contain = NO;
    
    for (HQEmployModel *model in peoples) {
        if ([model.id isEqualToNumber:UM.userLoginInfo.employee.id]) {
            contain = YES;
            break;
        }
    }
    self.heartBtn.selected = contain;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%ld个赞",peoples.count];
    
}


+ (instancetype)imgDoubleLalImgCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFImgDoubleLalImgCell" owner:self options:nil] lastObject];
}

+ (TFImgDoubleLalImgCell *)imgDoubleLalImgCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFImgDoubleLalImgCell";
    TFImgDoubleLalImgCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self imgDoubleLalImgCell];
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
