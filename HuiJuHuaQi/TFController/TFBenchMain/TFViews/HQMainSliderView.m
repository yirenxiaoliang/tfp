//
//  HQMainSliderView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/1.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQMainSliderView.h"
#import "YPTabBar.h"


@interface HQMainSliderView ()

/** progressMin */
@property (nonatomic, weak) UIView *progressMin;
/** numLabel */
@property (nonatomic, weak) UILabel *numLabel;

@end

@implementation HQMainSliderView


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
    
    self.tabBar = [[YPTabBar alloc] initWithFrame:(CGRect){10,0,SCREEN_WIDTH-20,55}];
    NSMutableArray *items = [NSMutableArray array];
    CGFloat width = (SCREEN_WIDTH-20)/4;
    for (NSInteger i = 0 ;i < 4; i ++) {
        
        YPTabItem *item = [[YPTabItem alloc] initWithFrame:(CGRect){20+i*width,0,width,49}];
        [items addObject:item];
    }
    self.tabBar.items = items;
    [self.tabBar setTitles:@[@"超期任务",@"今天要做",@"明天要做",@"以后要做"]];
    
    self.tabBar.selectedItemIndex = 0;
    self.tabBar.itemTitleColor = ExtraLightBlackTextColor;
    self.tabBar.itemTitleSelectedColor = BlackTextColor;
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:16];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:17];
    self.tabBar.leftAndRightSpacing = 0;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = HexAColor(0xEBEDF0, 1);
    self.tabBar.corner = YES;
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(8, 0, -8, 0) tapSwitchAnimated:YES];
    
    self.tabBar.itemSelectedBgImageView.layer.borderWidth = 0.5;
    self.tabBar.itemSelectedBgImageView.layer.borderColor = HexAColor(0xd7dce0, 1).CGColor;
    
    [self addSubview:self.tabBar];
    self.backgroundColor = WhiteColor;
    
    UIView *progessBg = [[UIView alloc] initWithFrame:(CGRect){0,45,SCREEN_WIDTH,38}];
    [self addSubview:progessBg];
    progessBg.backgroundColor =  HexAColor(0xEBEDF0, 1);
    
    UIView *progressMax = [[UIView alloc] initWithFrame:(CGRect){20,0,SCREEN_WIDTH-20-65,8}];
    [progessBg addSubview:progressMax];
    progressMax.layer.cornerRadius = 4;
    progressMax.layer.masksToBounds = YES;
    progressMax.backgroundColor = HexAColor(0xc8cfd8, 1);
    progressMax.centerY = progessBg.height/2;
    
    UIView *progressMin = [[UIView alloc] initWithFrame:(CGRect){20,0,0,8}];
    [progessBg addSubview:progressMin];
    progressMin.layer.cornerRadius = 4;
    progressMin.layer.masksToBounds = YES;
    progressMin.backgroundColor = GreenColor;
    progressMin.centerY = progessBg.height/2;
    self.progressMin = progressMin;
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(progressMax.frame),0,SCREEN_WIDTH-CGRectGetMaxX(progressMax.frame),38}];
    [progessBg addSubview:numLabel];
    numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel = numLabel;
}

-(NSAttributedString *)attributeStringWithFinishTask:(NSInteger)finish withTotalTask:(NSInteger)total{
    
    NSString *totalString = [NSString stringWithFormat:@"%ld/%ld",finish,total];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:totalString];
    [string addAttribute:NSForegroundColorAttributeName value:GreenColor range:[totalString rangeOfString:[NSString stringWithFormat:@"%ld",finish]]];
    [string addAttribute:NSForegroundColorAttributeName value:LightGrayTextColor range:[totalString rangeOfString:[NSString stringWithFormat:@"/%ld",total]]];
    [string addAttribute:NSFontAttributeName value:FONT(12) range:(NSRange){0,totalString.length}];
    
    return string;
}


-(void)refreshSliderViewWithFinishTask:(NSInteger)finishTask totalTask:(NSInteger)totalTask{
    
    self.numLabel.attributedText = [self attributeStringWithFinishTask:finishTask withTotalTask:totalTask];
    
    if (totalTask == 0) {
        
        self.progressMin.width = 0;
    }else{
        self.progressMin.width = (SCREEN_WIDTH-20-65) * (finishTask*1.0/totalTask*1.0);
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
