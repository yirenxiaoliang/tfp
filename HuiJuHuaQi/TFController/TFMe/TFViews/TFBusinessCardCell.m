//
//  TFBusinessCardCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBusinessCardCell.h"


@interface TFBusinessCardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@end

@implementation TFBusinessCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cardImageView.layer.borderColor = CellSeparatorColor.CGColor;
    self.cardImageView.layer.borderWidth = 0.5;
    self.cardImageView.layer.cornerRadius = 3;
    self.cardImageView.layer.masksToBounds = YES;
}


- (void)refreshBusinessCardCellWithType:(NSInteger)type{
    
    self.cardImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"businessCard%ld%ld",type,type]];
    
}

+ (instancetype)businessCardCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFBusinessCardCell" owner:self options:nil] lastObject];
}



+ (TFBusinessCardCell *)businessCardCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFBusinessCardCell";
    TFBusinessCardCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self businessCardCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
