//
//  TFTaskDetailCooperationCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailCooperationCell.h"

@interface TFTaskDetailCooperationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *visableLabel;
@property (weak, nonatomic) IBOutlet UILabel *cooperationPeople;

@end

@implementation TFTaskDetailCooperationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.image = IMG(@"cooperaPro");
    self.visableLabel.textColor = ExtraLightBlackTextColor;
    self.cooperationPeople.textColor = ExtraLightBlackTextColor;
    self.switchBtn.onTintColor = GreenColor;
    
}

- (IBAction)switchChange:(id)sender {
    if ([self.delegate respondsToSelector:@selector(taskDetailCooperationCellHandleSwitchBtn:)]) {
        [self.delegate taskDetailCooperationCellHandleSwitchBtn:sender];
    }
}


+(instancetype)taskDetailCooperationCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailCooperationCell" owner:self options:nil] lastObject];
}
+(instancetype)taskDetailCooperationCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailCooperationCell";
    TFTaskDetailCooperationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailCooperationCell taskDetailCooperationCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
