//
//  TFMyMaterialCardView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMyMaterialCardView.h"

@interface TFMyMaterialCardView ()

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UIImageView *sexImg;

@property (nonatomic, strong) UILabel *departmentLab;

@property (nonatomic, strong) UIButton *photoImg;

@property (nonatomic, strong) UILabel *signLab;

@property (nonatomic, strong) UILabel *num;

@property (nonatomic, strong) UIButton *zanBtn;

@property (nonatomic, strong) YYLabel *emotion;

@end

@implementation TFMyMaterialCardView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WhiteColor;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [CellSeparatorColor CGColor];
        self.layer.cornerRadius = 5.0;
//        self.layer.masksToBounds = YES;
        
        self.layer.shadowColor = HexColor(0xe1e1e1).CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(2,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
        
        
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews {

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 110)];
    
    topView.userInteractionEnabled = YES;
    
    [self addSubview:topView];
    
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewAction)];
    
    [topView addGestureRecognizer:topTap];
    
    //名字
    self.nameLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0x4A4A4A) titleFont:16 bgColor:ClearColor];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    
    [topView addSubview:self.nameLab];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@15);
        make.top.equalTo(@25);
        make.height.equalTo(@22);
        
    }];
    
    //性别
    self.sexImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    
//    if ([_model.sex isEqualToNumber:@0]) {
    
//        self.sexImg.image = IMG(@"男");
//    }
//    else {
//    
//        self.sexImg.image = IMG(@"女");
//    }
    
    [topView addSubview:self.sexImg];
    
    [self.sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.nameLab.mas_right).offset(5);
        make.centerY.equalTo(self.nameLab.mas_centerY);
        make.width.height.equalTo(@10);
        
    }];
    
    //部门
    self.departmentLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xBBBBC3) titleFont:14 bgColor:ClearColor];
    
    self.departmentLab.textAlignment = NSTextAlignmentLeft;
    
    [topView addSubview:self.departmentLab];
    
    [self.departmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@15);
        make.top.equalTo(self.nameLab.mas_bottom).offset(3);
        make.height.equalTo(@20);
        
    }];
    
    //头像
    self.photoImg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoImg.frame = CGRectZero;
    self.photoImg.layer.cornerRadius = 45/2.0;
    self.photoImg.layer.masksToBounds = YES;
    
    
    [topView addSubview:self.photoImg];
    
    [self.photoImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(@25);
        make.width.height.equalTo(@45);
        
    }];
    
    //线
    UILabel *line = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xFFFFFF) titleFont:10 bgColor:kUIColorFromRGB(0xBBBBC3)];
    
    [topView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@0);
        make.bottom.equalTo(topView.mas_bottom).offset(0);
        make.width.equalTo(@(self.width));
        make.height.equalTo(@(0.5));
        
    }];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, self.width, 45)];
    
    bottomView.userInteractionEnabled = YES;
    
    [self addSubview:bottomView];
    
    UITapGestureRecognizer *bottomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewAction)];
    
    [bottomView addGestureRecognizer:bottomTap];
    
    //心情符号
    self.emotion = [[YYLabel alloc] init];
    
    self.emotion.textAlignment = NSTextAlignmentCenter;
    
    [bottomView addSubview:self.emotion];
    
    [self.emotion mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@15);
        make.top.equalTo(@(0));
        make.width.equalTo(@45);
        make.height.equalTo(@45);
        
    }];
    
    //签名
    self.signLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
    
    self.signLab.textAlignment = NSTextAlignmentLeft;
    
    [bottomView addSubview:self.signLab];
    
    [self.signLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@70);
        make.top.equalTo(@(12.5));
        make.height.equalTo(@20);
        
    }];
    
    //点赞数
    self.num = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
    self.num.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.num];
    
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(@(-15));
        make.centerY.equalTo(self.signLab.mas_centerY);
        make.height.equalTo(@20);
        
    }];
    
    //点赞按钮
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.zanBtn addTarget:self action:@selector(zanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.zanBtn setImage:IMG(@"点赞") forState:UIControlStateNormal];
    
    [self addSubview:self.zanBtn];
    
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.num.mas_left).offset(-5);
        make.centerY.equalTo(self.signLab.mas_centerY);
        make.width.equalTo(@45);
        make.height.equalTo(@45);
        
    }];
    
    
}

//刷新视图
- (void)refreshCardViewWithData:(TFEmpInfoModel *)model {

    self.nameLab.text = model.employeeInfo.employee_name;
    
    if ([model.employeeInfo.sex isEqualToString:@"0"]) {
        
        self.sexImg.image = IMG(@"男");
    }
    else if ([model.employeeInfo.sex isEqualToString:@"1"]) {
    
        self.sexImg.image = IMG(@"女");
    }
    
    if (model.departmentInfo.count>0) {
        
        TFEmpDepartmentInfoModel *departmentModel = model.departmentInfo[0];
        self.departmentLab.text = [NSString stringWithFormat:@"%@-%@",departmentModel.department_name,model.employeeInfo.post_name];
    }
    
    self.num.text = [NSString stringWithFormat:@"%@",model.fabulous_count];
    
    if ([model.fabulous_status isEqualToNumber:@0]) {
        
        [self.zanBtn setImage:IMG(@"点赞") forState:UIControlStateNormal];
    }
    else {
    
        [self.zanBtn setImage:IMG(@"赞") forState:UIControlStateNormal];
    }
    
        
    [self.photoImg sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.employeeInfo.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            
            [self.photoImg setTitle:@"" forState:UIControlStateNormal];
        }else{
            
            [self.photoImg setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [self.photoImg setTitle:[HQHelper nameWithTotalName:model.employeeInfo.employee_name] forState:UIControlStateNormal];
            [self.photoImg setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.photoImg.titleLabel.font = FONT(17);
        }
    }];

//    [self.photoImg sd_setImageWithURL:[HQHelper URLWithString:model.employeeInfo.picture] placeholderImage:PlaceholderHeadImage];
    
    self.signLab.text = model.employeeInfo.sign;

    self.emotion.attributedText = [self attributedStringWithText:model.employeeInfo.mood font:14];
    
}

/** 普通文本转成带表情的属性文本 */
- (NSAttributedString *)attributedStringWithText:(NSString *)text font:(CGFloat)font{
    
    return [LiuqsDecoder decodeWithPlainStr:text font:[UIFont systemFontOfSize:font]];
}

#pragma mark 点击事件
- (void)topViewAction {

    if ([self.delegate respondsToSelector:@selector(editPersonalMaterial)]) {
        
        [self.delegate editPersonalMaterial];
    }
}

- (void)bottomViewAction {

    if ([self.delegate respondsToSelector:@selector(editPersonalSign)]) {
        
        [self.delegate editPersonalSign];
    }
}

- (void)zanAction {

    if ([self.delegate respondsToSelector:@selector(zanClicked)]) {
        
        [self.delegate zanClicked];
    }
}

@end
