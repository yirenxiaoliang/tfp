//
//  TFTaskDetailRelationCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/20.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailRelationCell.h"

@interface TFTaskDetailRelationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation TFTaskDetailRelationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.image = IMG(@"relation");
    self.headImage.contentMode = UIViewContentModeCenter;
    self.nameLabel.textColor = ExtraLightBlackTextColor;
    self.nameLabel.font = FONT(14);
    self.nameLabel.text = @"关联";
    self.contentLabel.textColor = BlackTextColor;
    self.contentLabel.font = FONT(14);
}

+(instancetype)taskDetailRelationCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailRelationCell" owner:self options:nil] lastObject];
}
+(instancetype)taskDetailRelationCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailRelationCell";
    TFTaskDetailRelationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFTaskDetailRelationCell taskDetailRelationCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
