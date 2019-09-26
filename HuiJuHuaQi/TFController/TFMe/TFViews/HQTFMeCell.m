//
//  HQTFMeCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFMeCell.h"

@interface HQTFMeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *tilte;

@end

@implementation HQTFMeCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tilte.textColor = BlackTextColor;
    self.tilte.font = FONT(16);
    
}

+ (instancetype)meCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFMeCell" owner:self options:nil] lastObject];
}



+ (HQTFMeCell *)meCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFMeCell";
    HQTFMeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self meCell];
    }
    return cell;
}

-(void)setItem:(HQTFCoopItemModel *)item{
    _item = item;
    
    self.image.image = [UIImage imageNamed:item.image];
    self.tilte.text = item.name;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
