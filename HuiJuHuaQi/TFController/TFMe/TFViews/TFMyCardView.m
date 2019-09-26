//
//  TFMyCardView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMyCardView.h"
#import "TFEmployeeCModel+CoreDataClass.h"
#import "YYLabel.h"

@interface TFMyCardView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UIView *enterView;
@property (weak, nonatomic) IBOutlet YYLabel *descBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterH;
@end


@implementation TFMyCardView

-(void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 0) {
        self.enterH.constant = 41;
        self.enterView.hidden = NO;
    }else{
        self.enterH.constant = 0;
        self.enterView.hidden = YES;
    }
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgView.backgroundColor = WhiteColor;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.borderColor = CellSeparatorColor.CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowColor = LightGrayTextColor.CGColor;
    self.bgView.layer.shadowRadius = 5;
    self.bgView.layer.shadowOpacity = 0.7;
    
    
    self.nameLabel.font = FONT(20);
    self.nameLabel.textColor = BlackTextColor;
    
    self.descBtn.textColor = ExtraLightBlackTextColor;
    self.descBtn.font = FONT(16);
    
    self.companyLabel.textColor = GrayTextColor;
    self.companyLabel.font = FONT(14);
    self.companyLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyClicked)];
    [self.companyLabel addGestureRecognizer:tap2];
    
    self.cardLabel.textColor = GrayTextColor;
    self.cardLabel.font = FONT(14);
    
    self.headBtn.layer.cornerRadius = 25;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.titleLabel.font = FONT(16);
    
    self.sexImage.contentMode = UIViewContentModeScaleToFill;
    
    self.enterView.layer.cornerRadius = 4;
//    self.enterView.layer.borderColor = CellSeparatorColor.CGColor;
//    self.enterView.layer.borderWidth = 0.5;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = CellSeparatorColor;
    [self.enterView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.enterView.mas_top);
        make.left.mas_equalTo(self.enterView.mas_left);
        make.right.mas_equalTo(self.enterView.mas_right);
        make.height.mas_equalTo(@(0.5));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterClicked)];
    [self.enterView addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(descBtnClicked)];
    [self.descBtn addGestureRecognizer:tap1];
    self.descBtn.userInteractionEnabled = YES;
    
    [self.headBtn addTarget:self action:@selector(headBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)companyClicked{
    
    if ([self.delegate respondsToSelector:@selector(clickedCompanyBtn)]) {
        [self.delegate clickedCompanyBtn];
    }
}

- (void)headBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(clickedHeadBtn)]) {
        [self.delegate clickedHeadBtn];
    }
}

- (void)descBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(clickedDescriptBtn)]) {
        [self.delegate clickedDescriptBtn];
    }
}

- (void)enterClicked{
    
    if ([self.delegate respondsToSelector:@selector(clickedEnterBtn)]) {
        [self.delegate clickedEnterBtn];
    }
    
}

+ (instancetype)myCardView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFMyCardView" owner:self options:nil] lastObject];
}

-(void)refreshMyCardViewWithEmployee:(TFEmpEmployeeInfoModel *)model{
    
    self.nameLabel.text = model.employee_name;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",model.mood,model.sign];
    if (str && ![str isEqualToString:@""]) {
        
        self.descBtn.attributedText = [self attributedStringWithText:str font:16];
    }else{
        
        self.descBtn.attributedText = [[NSAttributedString alloc] initWithString:@"添加工作状态..." attributes:@{NSForegroundColorAttributeName:HexColor(0x999999)}];
    }
    
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            [self.headBtn setTitle:@"" forState:UIControlStateHighlighted];
        }else{
            [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateHighlighted];
        }
        
    }];
    
    self.companyLabel.text = UM.userLoginInfo.company.company_name;
    
    if (IsStrEmpty(model.sex)) {
        self.sexImage.hidden = YES;
    }else{
        self.sexImage.hidden = NO;
        if ([model.sex isEqualToString:@"0"]) {
            
            self.sexImage.image = IMG(@"男");
        }else if ([model.sex isEqualToString:@"1"]) {
            
            self.sexImage.image = IMG(@"女");
        }
    }
}

-(void)refreshMyCardView{
    
    TFEmployeeCModel *model = UM.userLoginInfo.employee;
    
    self.nameLabel.text = model.employee_name;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",model.mood,model.sign];
    
    if (str && ![str isEqualToString:@""]) {
        
        self.descBtn.attributedText = [self attributedStringWithText:str font:16];
    }else{
        
        self.descBtn.attributedText = [[NSAttributedString alloc] initWithString:@"添加工作状态..." attributes:@{NSForegroundColorAttributeName:HexColor(0x999999)}];
    }
    
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (image) {
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            [self.headBtn setTitle:@"" forState:UIControlStateHighlighted];
        }else{
            [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateHighlighted];
        }
        
    }];
    
    self.companyLabel.text = UM.userLoginInfo.company.company_name;
    
    if (IsStrEmpty(model.sex)) {
        self.sexImage.hidden = YES;
    }else{
        self.sexImage.hidden = NO;
        if ([model.sex isEqualToString:@"0"]) {
            
            self.sexImage.image = IMG(@"男");
        }else if ([model.sex isEqualToString:@"1"]) {
            
            self.sexImage.image = IMG(@"女");
        }
    }
}

/** 普通文本转成带表情的属性文本 */
- (NSAttributedString *)attributedStringWithText:(NSString *)text font:(CGFloat)font{
    
    NSMutableAttributedString *str = [LiuqsDecoder decodeWithPlainStr:text font:[UIFont systemFontOfSize:font]];
    
    [str addAttribute:NSForegroundColorAttributeName value:HexColor(0x999999) range:NSMakeRange(0, str.length)];
    
    return str;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
