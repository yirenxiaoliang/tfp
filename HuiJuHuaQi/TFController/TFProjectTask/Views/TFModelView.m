//
//  TFModelView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFModelView.h"


@interface TFModelView ()

/** appliction */
@property (nonatomic, strong) TFApplicationModel *appliction;
/** module */
@property (nonatomic, strong) TFModuleModel *module;

@end

@implementation TFModelView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(12);
    self.nameLabel.numberOfLines = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
    [self addGestureRecognizer:tap];
    
    [self.handleBtn addTarget:self action:@selector(handleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = ClearColor;
    
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
}

- (void)handleBtnClicked{
    
    self.handleBtn.selected = !self.handleBtn.selected;
    if ([self.delegate respondsToSelector:@selector(didClickedHandleBtnWithModelView:module:)]) {
        [self.delegate didClickedHandleBtnWithModelView:self module:self.module];
    }
}

- (void)tapClicked{
    
    if ([self.delegate respondsToSelector:@selector(didClickedmodelView:application:module:)]) {
        [self.delegate didClickedmodelView:self application:self.appliction module:self.module];
    }
}


+ (instancetype)modelView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFModelView" owner:nil options:nil] lastObject];
}


-(void)refreshViewWithApplication:(TFApplicationModel *)appliction type:(NSInteger)type{
    
    self.nameLabel.text = appliction.name?:appliction.chinese_name;
    if ([appliction.icon_type isEqualToString:@"1"]) {// 网络图片
        [self.imageView sd_setImageWithURL:[HQHelper URLWithString:appliction.icon_url]];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }else{// 本地图片
        [self.imageView setImage:IMG(IsStrEmpty(appliction.icon)?appliction.icon_url:appliction.icon)];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    self.imageView.backgroundColor = [HQHelper colorWithHexString:appliction.icon_color]?:GreenColor;
    self.appliction = appliction;
    
    if (type == 0) {
        self.handleBtn.hidden = YES;
    }else{
        
        self.handleBtn.hidden = NO;
        
        if (type == 1) {// +
            self.handleBtn.selected = NO;
        }else{// -
            self.handleBtn.selected = YES;
        }
    }
    
}

-(void)refreshViewWithModule:(TFModuleModel *)module type:(NSInteger)type{
    
    self.nameLabel.text = module.chinese_name;
    if ([module.icon_type isEqualToString:@"1"]) {// 网络图片
        [self.imageView sd_setImageWithURL:[HQHelper URLWithString:module.icon_url]];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.backgroundColor = [HQHelper colorWithHexString:module.icon_color]?[HQHelper colorWithHexString:module.icon_color]:GreenColor;
    }else{// 本地图片
        if (module.icon && ![module.icon isEqualToString:@""] && ![module.icon isEqualToString:@"null"]) {
            [self.imageView setImage:IMG(module.icon)];
            self.imageView.backgroundColor = [HQHelper colorWithHexString:module.icon_color]?[HQHelper colorWithHexString:module.icon_color]:GreenColor;
        }else if (module.icon_url && ![module.icon_url isEqualToString:@""] && ![module.icon_url isEqualToString:@"null"]) {
            [self.imageView setImage:IMG(module.icon_url)];
            self.imageView.backgroundColor = [HQHelper colorWithHexString:module.icon_color]?[HQHelper colorWithHexString:module.icon_color]:GreenColor;
        }else{
            [self.imageView setImage:IMG(module.chinese_name)];
            self.imageView.backgroundColor = WhiteColor;
        }
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    self.module = module;
    
    if (type == 0) {
        self.handleBtn.hidden = YES;
    }else{
        
        self.handleBtn.hidden = NO;
        
        if (type == 1) {// +
            self.handleBtn.selected = NO;
        }else{// -
            self.handleBtn.selected = YES;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
