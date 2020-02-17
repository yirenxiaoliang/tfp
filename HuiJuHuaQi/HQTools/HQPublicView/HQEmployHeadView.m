//
//  HQEmployHeadView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/7/8.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQEmployHeadView.h"

@interface HQEmployHeadView ()
{
    TFEmployeeCModel *_employ;
}

@property (nonatomic, strong) UIButton *headBtn;   //头像

@end


@implementation HQEmployHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self initWithEmployHeadView];
    }
    
    return self;
}


- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self initWithEmployHeadView];
}



- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius  = self.width / 2;
    self.layer.masksToBounds = YES;
    
    _headBtn.layer.cornerRadius  = self.width / 2;
    _headBtn.layer.masksToBounds = YES;
    _headBtn.frame = CGRectMake(0, 0, self.width, self.height);
}



- (void)initWithEmployHeadView
{
    
    self.backgroundColor = LightGrayTextColor;
    

    
    self.headBtn = [HQHelper buttonWithFrame:CGRectMake(0, 0, self.width, self.height)
                                      target:self
                                      action:@selector(didHeadBtnAction)];
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"灰色圆形头像"] forState:UIControlStateNormal];
    [self.headBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self addSubview:self.headBtn];
}


- (void)setTitleFont:(UIFont *)titleFont
{
    _headBtn.titleLabel.font = titleFont;
}


- (void)didHeadBtnAction
{

    if ([self.delegate respondsToSelector:@selector(didEmployHeadViewWithEmployId:quitState:)]) {
        
        [ self.delegate didEmployHeadViewWithEmployId:_employ.id
                                            quitState:[_employ.sign_id boolValue]];
    }
}



- (void)refreshEmployHeadViewWithId:(NSNumber *)employId
{

//    self.layer.cornerRadius  = self.width / 2;
//    self.layer.masksToBounds = YES;
//    
//    _headBtn.layer.cornerRadius  = self.width / 2;
//    _headBtn.layer.masksToBounds = YES;
//    _headBtn.frame = CGRectMake(0, 0, self.width, self.height);

    
    
    _employ = [HQHelper employeeWithEmployeeID:employId];
    
    
    [self.headBtn setTitle:@"" forState:UIControlStateNormal];
    [self.headBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    if ([_employ.sign_id integerValue] == 0) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@", _employ.picture];
        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:urlStr]
                                          forState:UIControlStateNormal
                                  placeholderImage:[UIImage imageNamed:@"灰色圆形头像"]];
        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:urlStr]
                                          forState:UIControlStateHighlighted
                                  placeholderImage:[UIImage imageNamed:@"灰色圆形头像"]];
    }else {
    
        [self.headBtn setTitle:@"离职" forState:UIControlStateNormal];
        [self.headBtn setTitle:@"离职" forState:UIControlStateHighlighted];
    }
}


@end
