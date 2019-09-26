//
//  HQTFRelateCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRelateCell.h"


@interface HQTFRelateCell ()


@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *outTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLaout;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation HQTFRelateCell


-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleName.textColor = BlackTextColor;
    self.time.textColor = ExtraLightBlackTextColor;
    self.outTime.textColor = ExtraLightBlackTextColor;
    self.outTime.layer.borderWidth = 0.5;
    self.outTime.layer.cornerRadius = 2;
    self.outTime.layer.masksToBounds = YES;
    self.outTime.layer.borderColor = GreenColor.CGColor;
    
    self.bottomLine.hidden = NO;
    self.headMargin = 15;
    
    self.editBtn.titleLabel.font = FONT(14);
    self.changeBtn.titleLabel.font = FONT(14);
    [self.editBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.changeBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    self.editBtn.hidden = YES;
    self.changeBtn.hidden = YES;
}

-(void)setEnterImg:(NSString *)enterImg{
    
    _enterImg = enterImg;
    
    [self.enterImage setImage:[UIImage imageNamed:enterImg] forState:UIControlStateNormal];
    [self.enterImage setImage:[UIImage imageNamed:enterImg] forState:UIControlStateHighlighted];
}
/** 地址 */
- (void)refreshCellWithLocation:(TFLocationModel *)model withType:(NSInteger)type{
    
    self.titleName.text = model.name;
    self.time.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.address];
    self.editBtn.userInteractionEnabled = NO;
    self.changeBtn.userInteractionEnabled = NO;
    self.enterImage.userInteractionEnabled = NO;
    
    if (type == 0) {
        self.centerLaout.constant = -13;
        self.time.hidden = NO;
        self.outTime.hidden = YES;
    }else{
        
        self.centerLaout.constant = 0;
        self.time.hidden = YES;
        self.outTime.hidden = YES;
    }
    
}

- (void)refreshCellWithModel:(HQCustomerModel *)model withType:(NSInteger)type{
    
    self.titleName.text = model.customerTitle;
    self.time.text = model.time;
    self.outTime.text = @"超期";
    
    if (type == 0) {
        self.centerLaout.constant = -13;
        self.time.hidden = NO;
        self.outTime.hidden = NO;
    }else{
        
        self.centerLaout.constant = 0;
        self.time.hidden = YES;
        self.outTime.hidden = YES;
    }
    
}


/**  当前公司 */
- (void)refreshCellWithCompany:(NSString *)company withType:(NSInteger)type{
    
    self.titleName.text = @"当前企业：";
    self.titleName.font = FONT(14);
    self.time.font = FONT(16);
    self.titleName.textColor = ExtraLightBlackTextColor;
    self.time.textColor = GreenColor;
    self.time.text = company;
    self.outTime.hidden = YES;
    self.enterImage.hidden = YES;
    if (type == 1) {
        self.editBtn.hidden = NO;
        self.changeBtn.hidden = NO;
    }else{
        self.editBtn.hidden = YES;
        self.changeBtn.hidden = YES;
    }
}
- (IBAction)editClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickedEditBtn)]) {
        [self.delegate clickedEditBtn];
    }
}

- (IBAction)changeClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickedChangeBtn)]) {
        [self.delegate clickedChangeBtn];
    }
}

+ (instancetype)relateCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFRelateCell" owner:self options:nil] lastObject];
}

+ (HQTFRelateCell *)relateCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFRelateCell";
    HQTFRelateCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.topLine.hidden = YES;
    if (!cell) {
        cell = [self relateCell];
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
