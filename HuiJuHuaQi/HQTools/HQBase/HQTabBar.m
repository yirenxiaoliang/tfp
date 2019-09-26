//
//  HQTabBar.m
//  HuiJuHuaQi
//
//  Created by hq001 on 15/12/24.
//  Copyright © 2015年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTabBar.h"
#import "UIView+Extension.h"

@interface HQTabBar()
@property (nonatomic, weak) UIButton *plusBtn;
@property (nonatomic,assign) BOOL flag;
@end

@implementation HQTabBar

@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"添加选中"] forState:UIControlStateSelected];

        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        self.flag = YES;
        
    }
    return self;
}

/**
 *  加号按钮点击
 */
- (void)plusClick
{
    // 通知代理
    
    if ([self.delegateTwo respondsToSelector:@selector(tabBar:DidClickedPlusButton:)]) {
        [self.delegateTwo tabBar:self DidClickedPlusButton:self.plusBtn];
    }
}

//隐藏tabbar

-(void)setIsHidden:(BOOL)isHidden
{
    self.hidden=isHidden;
    if (isHidden==YES)
    {
        self.hidden=YES;
        
    }
    else
    {
        self.hidden=NO;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height * 0.5 - 0.5 * BottomM;
    
    // 2.设置其他tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonW;
            // 设置x
            child.x = tabbarButtonIndex * tabbarButtonW;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
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
