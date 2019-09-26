//
//  TFEmailsDetailHeadView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsDetailHeadView.h"

@interface TFEmailsDetailHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *senderLab;
@property (weak, nonatomic) IBOutlet UILabel *IPLab;
@property (weak, nonatomic) IBOutlet UILabel *receiverLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;


@end

@implementation TFEmailsDetailHeadView


- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self.hideBtn addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)refreshEmailHeadViewWithModel:(TFEmailDetailModel *)model {

    self.titleLab.text = @"关于上次讨论的列表问题";
    
    self.senderLab.text = @"发件人：客户<Patricia Elliott@163.com>";
    
    self.IPLab.text = @"IP地址：36.51.253.36(中国华北北京市)";
    
    self.receiverLab.text = @"收件人：我<yokohu>；苏华Julia Obrien@163.com";
    
    self.timeLab.text = @"时   间：2017-06-04 15:16（星期一）";
}

- (void)hideAction {

    if ([self.delegate respondsToSelector:@selector(hideEmailDetailHeadInfo)]) {
        
        [self.delegate hideEmailDetailHeadInfo];
    }
}

+ (instancetype)emailsDetailHeadView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFEmailsDetailHeadView" owner:self options:nil] lastObject];
}


@end
