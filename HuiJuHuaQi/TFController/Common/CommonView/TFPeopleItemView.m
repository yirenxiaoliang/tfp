//
//  TFPeopleItemView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPeopleItemView.h"
#import "TFParameterModel.h"


@interface TFPeopleItemView ()

/** headBtn */
@property (nonatomic, weak) UIButton *headBtn;

/** employee */
@property (nonatomic, strong) HQEmployModel *employee;
/** department */
@property (nonatomic, strong) TFDepartmentModel *department;
/** parameter */
@property (nonatomic, strong) TFParameterModel *parameter;

/** clearBtn */
@property (nonatomic, weak) UIButton *clearBtn;

/** type */
@property (nonatomic, assign) BOOL clear;


@end

@implementation TFPeopleItemView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupChild];
    }
    return  self;
}

- (void)setupChild{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    button.userInteractionEnabled = NO;
    self.headBtn = button;
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    self.headBtn.titleLabel.font = FONT(26);
    [self.headBtn setTitleColor:GrayTextColor forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-10);
        
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    self.nameLabel = label;
    label.textColor = BlackTextColor;
    label.font = FONT(13);
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@20);
        
    }];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:clearBtn];
    [clearBtn setImage:[UIImage imageNamed:@"清除"] forState:UIControlStateNormal];
    [clearBtn setImage:[UIImage imageNamed:@"清除"] forState:UIControlStateHighlighted];
    self.clearBtn = clearBtn;
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@18);
        make.width.equalTo(@18);
        
    }];
    
    [clearBtn addTarget:self action:@selector(clearBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.hidden = YES;
    
    [self.headBtn setTitle:@"" forState:UIControlStateNormal];
}

- (void)clearBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(clearBtnClickedWithEmployee:)]) {
        [self.delegate clearBtnClickedWithEmployee:self.employee];
    }
    
}

/** 刷新四种参数 */
-(void)refreshPeopleViewWithParameter:(TFParameterModel *)parameter withClear:(BOOL)clear{
    
    self.headBtn.titleLabel.font = FONT(16);
    if ([[parameter.id description] isEqualToString:@""]) {
        return;
    }
    self.parameter = parameter;
    self.clear = clear;
    
    if (clear) {
        self.clearBtn.hidden = NO;
    }else{
        self.clearBtn.hidden = YES;
    }
    
    if ([parameter.type isEqualToNumber:@0]) {// 部门
        [self.headBtn setBackgroundImage:IMG(@"部门") forState:UIControlStateNormal];
    }else if ([parameter.type isEqualToNumber:@1]){// 人员
        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:parameter.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                
                
                [self.headBtn setTitle:[HQHelper nameWithTotalName:parameter.name] forState:UIControlStateNormal];
                [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                self.headBtn.backgroundColor = HeadBackground;
                
            }else{
                
                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
                [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                self.headBtn.backgroundColor = WhiteColor;
            }
        }];
    }else if ([parameter.type isEqualToNumber:@2]){// 角色
        
        [self.headBtn setTitle:[HQHelper nameWithTotalName:parameter.name] forState:UIControlStateNormal];
        [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        self.headBtn.backgroundColor = HeadBackground;
    }else if ([parameter.type isEqualToNumber:@3]){// 参数
        
        [self.headBtn setTitle:[HQHelper nameWithTotalName:parameter.name] forState:UIControlStateNormal];
        [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        self.headBtn.backgroundColor = HeadBackground;
    }
    
    
    self.nameLabel.text = parameter.name;
}
/** 刷新人 */
-(void)refreshPeopleViewWithEmployee:(HQEmployModel *)employee withClear:(BOOL)clear{
    
    self.headBtn.titleLabel.font = FONT(16);
    if ([[employee.id description] isEqualToString:@""]) {
        return;
    }
    self.employee = employee;
    self.clear = clear;
    
    if (clear) {
        self.clearBtn.hidden = NO;
    }else{
        self.clearBtn.hidden = YES;
    }
    
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:employee.picture?:employee.photograph] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
            
            
            [self.headBtn setTitle:[HQHelper nameWithTotalName:employee.employeeName?:employee.employee_name] forState:UIControlStateNormal];
            [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.headBtn.backgroundColor = HeadBackground;
            
        }else{
            
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.headBtn.backgroundColor = WhiteColor;
        }
    }];
    
    
    self.nameLabel.text = employee.employeeName?:employee.employee_name;
}

/** 刷新部门 */
-(void)refreshPeopleViewWithDepartment:(TFDepartmentModel *)department withClear:(BOOL)clear{
    
    self.headBtn.titleLabel.font = FONT(16);
    if ([[department.id description] isEqualToString:@""]) {
        return;
    }
    self.department = department;
    self.clear = clear;
    
    if (clear) {
        self.clearBtn.hidden = NO;
    }else{
        self.clearBtn.hidden = YES;
    }
    
    [self.headBtn setTitle:[HQHelper nameWithTotalName:department.name] forState:UIControlStateNormal];
    [self.headBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.headBtn.backgroundColor = HeadBackground;
    
    self.nameLabel.text = department.name;
}

/** +样式 */
-(void)refreshAddType{
    
//    [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:BackGroudColor] forState:UIControlStateNormal];
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"加人"] forState:UIControlStateNormal];
//    [self.headBtn setTitle:@"+" forState:UIControlStateNormal];
    self.nameLabel.text = @"添加";
    self.headBtn.titleLabel.font = FONT(26);
    self.clearBtn.hidden = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
