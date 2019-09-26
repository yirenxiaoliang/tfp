//
//  TFEnterCustomCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/22.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterCustomCell.h"

@interface TFEnterCustomCell ()
@property (weak, nonatomic) IBOutlet UIImageView *enterImage;
@property (weak, nonatomic) IBOutlet UILabel *line;

@end

@implementation TFEnterCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = ExtraLightBlackTextColor;
    self.contentView.backgroundColor = ClearColor;
    self.backgroundColor = ClearColor;
    self.line.backgroundColor = HexColor(0xdae0e7);
}
+(instancetype)enterCustomCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFEnterCustomCell" owner:self options:nil] lastObject];
}

+(instancetype)enterCustomCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFEnterCustomCell";
    TFEnterCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFEnterCustomCell enterCustomCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

@end
