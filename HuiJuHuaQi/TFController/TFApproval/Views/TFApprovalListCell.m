//
//  TFApprovalListCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalListCell.h"


@interface TFApprovalListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *redImage;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation TFApprovalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectBtn.hidden = YES;
    self.selectBtn.userInteractionEnabled = NO;
    
    self.backgroundColor = ClearColor;
    self.bgView.backgroundColor = WhiteColor;
    self.bgView.layer.cornerRadius = 2;
    self.bgView.layer.masksToBounds = NO;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.shadowColor = GrayTextColor.CGColor;
    self.bgView.layer.shadowRadius = 1;
    self.bgView.layer.shadowOpacity = 0.5;
    
    self.headImage.layer.cornerRadius = 22.5;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.userInteractionEnabled = NO;
    
    self.redImage.image = [HQHelper createImageWithColor:RedColor];
    self.redImage.layer.masksToBounds = YES;
    self.redImage.layer.cornerRadius = 5;
    
    self.typeBtn.layer.cornerRadius = 9;
    self.typeBtn.layer.masksToBounds = YES;
    [self.typeBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    self.typeBtn.userInteractionEnabled = NO;
    [self.typeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.typeBtn.titleLabel.font = FONT(10);
    
    self.titleLab.textColor = BlackTextColor;
    self.titleLab.font = FONT(16);
    
    self.timeLab.textColor = FinishedTextColor;
    self.timeLab.font = FONT(12);
    
    self.redImage.hidden = YES;
}

+ (instancetype)approvalListCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFApprovalListCell" owner:self options:nil] lastObject];
}

-(void)setQuote:(BOOL)quote{
    
    _quote = quote;
    
    self.selectBtn.hidden = !quote;
    self.headImage.hidden = quote;
    if (quote) {
        self.redImage.hidden = YES;
    }
    
}


+ (instancetype)approvalListCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFApprovalListCell";
    TFApprovalListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self approvalListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)refreshCellWithModel:(TFApprovalListItemModel *)model{
    
    self.titleLab.text = [NSString stringWithFormat:@"%@-%@",model.begin_user_name,model.process_name];
    // 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5流程结束 6待提交
    if ([model.process_status isEqualToNumber:@0]) {
        
        [self.typeBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xF7981C)] forState:UIControlStateNormal];
        [self.typeBtn setTitle:@"待审批" forState:UIControlStateNormal];
        
    }else if ([model.process_status isEqualToNumber:@1]) {
        [self.typeBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x549AFF)] forState:UIControlStateNormal];
        [self.typeBtn setTitle:@"审批中" forState:UIControlStateNormal];
        
    }else if ([model.process_status isEqualToNumber:@2]) {
        [self.typeBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x3CBB81)] forState:UIControlStateNormal];
        [self.typeBtn setTitle:@"审批通过" forState:UIControlStateNormal];
        
    }else if ([model.process_status isEqualToNumber:@4]) {
        [self.typeBtn setBackgroundImage:[HQHelper createImageWithColor:GrayTextColor] forState:UIControlStateNormal];
        [self.typeBtn setTitle:@"已撤销" forState:UIControlStateNormal];
        
    }else if ([model.process_status isEqualToNumber:@3]) {
        [self.typeBtn setBackgroundImage:[HQHelper createImageWithColor:RedColor] forState:UIControlStateNormal];
        [self.typeBtn setTitle:@"审批驳回" forState:UIControlStateNormal];
        
    }else if ([model.process_status isEqualToNumber:@6]) {
        [self.typeBtn setBackgroundImage:[HQHelper createImageWithColor:GrayTextColor] forState:UIControlStateNormal];
        [self.typeBtn setTitle:@"待提交" forState:UIControlStateNormal];
        
    }
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headImage setTitle:[HQHelper nameWithTotalName:model.begin_user_name] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(16);
            
        }
        
    }];
    
    self.timeLab.text = [NSString stringWithFormat:@"申请时间：%@",[HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
    
    if ([model.select isEqualToNumber:@1]) {
        self.selectBtn.selected = YES;
        
    }else{
        self.selectBtn.selected = NO;
    }
    
    if ([model.status isEqualToString:@"0"]) {
        self.redImage.hidden = NO;
    }else{
        self.redImage.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
