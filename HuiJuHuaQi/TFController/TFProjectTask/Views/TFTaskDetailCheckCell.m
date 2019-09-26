//
//  TFTaskDetailCheckCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailCheckCell.h"

@interface TFTaskDetailCheckCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TFTaskDetailCheckCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.titleLabel.font = FONT(14);
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    [self.switchBtn setOnTintColor:GreenColor];
    self.titleLabel.text = @"校验";
    self.switchBtn.on = NO;
    self.headImage.image = IMG(@"checkPro");
}

-(void)setCheck:(BOOL)check{
    _check = check;
    self.switchBtn.on = check;
}

- (IBAction)switchChange:(UISwitch *)sender {
    
    if ([self.delegate respondsToSelector:@selector(taskDetailCheckCellHandleSwicth:)]) {
        [self.delegate taskDetailCheckCellHandleSwicth:sender];
    }
}

+(instancetype)taskDetailCheckCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailCheckCell" owner:self options:nil] lastObject];
}
+(instancetype)taskDetailCheckCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailCheckCell";
    TFTaskDetailCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailCheckCell taskDetailCheckCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
