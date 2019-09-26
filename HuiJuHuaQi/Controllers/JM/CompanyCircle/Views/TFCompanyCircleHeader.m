//
//  TFCompanyCircleHeader.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleHeader.h"

@interface TFCompanyCircleHeader ()

/** backImage */
@property (nonatomic, weak) UIButton *backImage;
/** headImage */
@property (nonatomic, weak) UIButton *headImage;
/** nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;
/** signLabel */
@property (nonatomic, weak) UILabel *signLabel;

@end

@implementation TFCompanyCircleHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView{
    
    UIButton *backImage = [HQHelper buttonWithFrame:(CGRect){0,0,SCREEN_WIDTH,340} target:self action:@selector(backImageClicked)];
    [self addSubview:backImage];
    [backImage setBackgroundImage:[UIImage imageNamed:@"企业圈底图"] forState:UIControlStateNormal];
    [backImage setBackgroundImage:[UIImage imageNamed:@"企业圈底图"] forState:UIControlStateHighlighted];
    self.backImage = backImage;
    
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    backImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){SCREEN_WIDTH-17- (74), (340)- 2 *  (74)/3, (74), (74)}];
    view.backgroundColor = WhiteColor;
    view.layer.borderColor =HexAColor(0x000000, 0.2).CGColor;
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 37;
    [self addSubview:view];
    
    UIButton *headImage = [HQHelper buttonWithFrame:(CGRect){2,2, (70), (70)} target:self action:@selector(headImageClicked)];
    headImage.backgroundColor = WhiteColor;
//    [headImage setBackgroundImage:PlaceholderHeadImage forState:UIControlStateNormal];
//    [headImage setBackgroundImage:PlaceholderHeadImage forState:UIControlStateHighlighted];
    [view addSubview:headImage];
    self.headImage = headImage;
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 35;
    
    
    UILabel *nameLabel = [HQHelper labelWithFrame:(CGRect){0,CGRectGetMaxY(backImage.frame) - 20 -13, CGRectGetMinX(view.frame)-13,20} text:@"" textColor:WhiteColor textAlignment:NSTextAlignmentRight font:FONT(18)];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    UILabel *signLabel = [HQHelper labelWithFrame:(CGRect){13,CGRectGetMaxY(view.frame) + 13,SCREEN_WIDTH-26,16} text:@"" textColor:ExtraLightBlackTextColor textAlignment:NSTextAlignmentRight font:FONT(14)];
    [self addSubview:signLabel];
    self.signLabel = signLabel;
    
    self.backgroundColor = WhiteColor;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(signLabel.frame)+13);
    
}

-(void)setEmployee:(TFCircleEmployModel *)employee{
    
    _employee = employee;
    
    [self.backImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:employee.microblog_background] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"企业圈底图"]];
    [self.backImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:employee.microblog_background] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"企业圈底图"]];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:employee.photograph] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
            [self.headImage setTitle:@"" forState:UIControlStateHighlighted];
            [self.headImage setBackgroundImage:image forState:UIControlStateHighlighted];
        }else{
            
            [self.headImage setTitle:[HQHelper nameWithTotalName:employee.employeeName] forState:UIControlStateNormal];
            [self.headImage setTitle:[HQHelper nameWithTotalName:employee.employeeName] forState:UIControlStateHighlighted];
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateHighlighted];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
            self.headImage.titleLabel.font = FONT(20);
        }
        
    }];
//    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:employee.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    self.nameLabel.text = employee.employeeName;
    self.signLabel.text = employee.personSignature;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    
    [self.backImage setBackgroundImage:image forState:UIControlStateNormal];
    [self.backImage setBackgroundImage:image forState:UIControlStateHighlighted];
}

-(void)setHeaderType:(CompanyCircleHeaderType)headerType{
    _headerType = headerType;
    
    if (headerType == CompanyCircleHeaderTypeNoDescription) {
        self.signLabel.hidden = YES;
    }
}

- (void)backImageClicked{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleHeaderDidClickedBackground)]) {
        [self.delegate companyCircleHeaderDidClickedBackground];
    }
}

- (void)headImageClicked{
    
    if ([self.delegate respondsToSelector:@selector(companyCircleHeaderDidClickedHeadWithEmployee:)]) {
        [self.delegate companyCircleHeaderDidClickedHeadWithEmployee:self.employee];
    }
}

+ (instancetype)companyCircleHeader{
    
    TFCompanyCircleHeader *header = [[TFCompanyCircleHeader alloc] init];
    
    return header;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
