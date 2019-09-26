//
//  TFLateEarlyItemCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLateEarlyItemCell.h"

@interface TFLateEarlyItemCell ()
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *firstTime;
@property (weak, nonatomic) IBOutlet UILabel *secondTime;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;


@property (nonatomic, strong) TFLateNigthWalk *model;
@end

@implementation TFLateEarlyItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstName.textColor = LightBlackTextColor;
    self.firstTime.textColor = LightBlackTextColor;
    self.secondName.textColor = LightBlackTextColor;
    self.secondTime.textColor = LightBlackTextColor;
    self.line.backgroundColor = CellSeparatorColor;
    [self.setBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    self.setBtn.titleLabel.font = FONT(12);
    self.firstName.font = FONT(14);
    self.firstTime.font = FONT(14);
    self.secondTime.font = FONT(14);
    self.secondName.font = FONT(14);
    self.backgroundColor = HexColor(0xF8FBFE);
    [[self.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([self.delegate respondsToSelector:@selector(lateEarlyItemCellDidClickedSetting:)]) {
            [self.delegate lateEarlyItemCellDidClickedSetting:self.model];
        }
    }];
}

-(void)refreshLateEarlyItemCellWithModel:(TFLateNigthWalk *)model{
    self.model = model;
    self.firstName.text = @"第一天下班晚走";
    self.secondName.text = @"第二天上班晚到";
    if (!IsStrEmpty(model.nigthwalkmin)) {
        self.firstTime.text = [NSString stringWithFormat:@"%@小时",model.nigthwalkmin];
    }else{
        self.firstTime.text = @"";
    }
    if (!IsStrEmpty(model.lateMin)) {
        self.secondTime.text = [NSString stringWithFormat:@"%@小时",model.lateMin];
    }else{
        self.secondTime.text = @"";
    }
}

+(instancetype)lateEarlyItemCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFLateEarlyItemCell" owner:self options:nil] lastObject];
}
+ (instancetype)lateEarlyItemCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFLateEarlyItemCell";
    TFLateEarlyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self lateEarlyItemCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
