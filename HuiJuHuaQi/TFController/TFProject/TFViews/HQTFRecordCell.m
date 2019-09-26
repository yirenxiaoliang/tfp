//
//  HQTFRecordCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRecordCell.h"

@interface HQTFRecordCell ()
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation HQTFRecordCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 20;
    self.headImage.layer.masksToBounds = YES;
    self.titleLable.textColor = ExtraLightBlackTextColor;
    self.titleLable.numberOfLines = 0;
    self.descLabel.textColor = LightGrayTextColor;
    
    // 假数据
//    [self.headImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//    [self.headImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateHighlighted];
//    self.titleLable.text = @"这是一些假数据这是一些假数据这是一些假数据这是一些假数据这是一些假数据这是一些假数据这是一些假数据这是一些假数据";
//    self.descLabel.text = @"这是一些假数据这是一些假数据";
}


- (void)refreshRecordCellWithModel:(TFTaskLogContentModel *)model{
    
    [self.headImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",model.employeeName, model.content];
    
    self.titleLable.text = str;
    self.descLabel.text = [HQHelper nsdateToTimeNowYearNowMonthNowDay:[model.createTime longLongValue]];
    
}

+ (CGFloat)refreshRecordCellHeightWithModel:(TFTaskLogContentModel *)model{
    
    CGFloat height = 15 + 15;
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",model.employeeName, model.content];
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-75,MAXFLOAT} titleStr:str];
    
    height += size.height;
    
    height += 8;
    
    height += 18;
    
    return height;
}

+ (instancetype)recordCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFRecordCell" owner:self options:nil] lastObject];
}

+ (HQTFRecordCell *)recordCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFRecordCell";
    HQTFRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self recordCell];
    }
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
