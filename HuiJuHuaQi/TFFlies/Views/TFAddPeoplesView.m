//
//  TFAddPeoplesView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPeoplesView.h"

@interface TFAddPeoplesView ()

/** headBtn */
@property (nonatomic, weak) UIButton *headBtn;
/** nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation TFAddPeoplesView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupChild];
    }
    return  self;
}

- (void)setupChild{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    
    self.headBtn = button;
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    self.headBtn.titleLabel.font = FONT(26);
    [self.headBtn setTitleColor:GrayTextColor forState:UIControlStateNormal];
    
    [self.headBtn addTarget:self action:@selector(addPeople) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self.headBtn setTitle:@"" forState:UIControlStateNormal];
    
}
/** 刷新人 */
-(void)refreshPeopleViewWithEmployee:(HQEmployModel *)employee{
    
    NSString *name = @"";
    if (!IsStrEmpty(employee.employee_name)) {
        name = employee.employee_name;
    }else if (!IsStrEmpty(employee.employeeName)) {
        name = employee.employeeName;
    }else if (!IsStrEmpty(employee.name)) {
        name = employee.name;
    }
    if (!employee.type || employee.type.integerValue == 1) {
        
        [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:employee.photograph?employee.photograph:employee.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                
                [self.headBtn setTitle:[HQHelper nameWithTotalName:name] forState:UIControlStateNormal];
                
                [self.headBtn setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
                [self.headBtn setBackgroundColor:GreenColor];
                
            }else{
                
                
                [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:employee.picture] forState:UIControlStateNormal];
                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
                
            }
            
            self.headBtn.titleLabel.font = FONT(14);
        }];
    }else{
        
        [self.headBtn setBackgroundImage:IMG(@"部门") forState:UIControlStateNormal];
        [self.headBtn setTitle:@"" forState:UIControlStateNormal];
        [self.headBtn setTitle:[HQHelper nameWithTotalName:name] forState:UIControlStateNormal];
    }
   
    self.nameLabel.text = name;
}
/** 刷新角色*/
-(void)refreshRoleViewWithEmployee:(TFRoleModel *)employee{
    
    [self.headBtn setTitle:[HQHelper nameWithTotalName:employee.name] forState:UIControlStateNormal];
    self.headBtn.titleLabel.font = FONT(14);
    self.nameLabel.text = employee.name;
    [self.headBtn setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.headBtn setBackgroundColor:GreenColor];
}
/** 刷新管理员 */
-(void)refreshPeopleViewWithManagers:(TFManageItemModel *)employee{
    
    [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:employee.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            [self.headBtn setTitle:[HQHelper nameWithTotalName:employee.employeeName?employee.employeeName:employee.employee_name] forState:UIControlStateNormal];
            self.headBtn.backgroundColor = HeadBackground;
            
        }else{
            
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
            self.headBtn.backgroundColor = WhiteColor;
            
        }
        
    }];
    self.nameLabel.text = employee.employee_name;
}

/** +样式 */
-(void)refreshAddType{
    
    [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:BackGroudColor] forState:UIControlStateNormal];
    [self.headBtn setTitle:@"+" forState:UIControlStateNormal];
    self.nameLabel.text = @"添加";
    
}

- (void)addPeople {

    if ([self.delegate respondsToSelector:@selector(addFolderPeoples)]) {
        

        [self.delegate addFolderPeoples];
    }
}


@end
