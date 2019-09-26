//
//  HQTFSelectDateView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFSelectDateView.h"
//#import "HQCalenderView.h"
#import "NSDate+NSString.h"
//#import "JBCalendarDate.h"

#define LabelWidth 115
#define LeftMargin 70


#define ItemMargin 15
#define ItemWidth ((SCREEN_WIDTH - 2 * ItemMargin)/7)

@interface HQTFSelectDateView ()

/** _calenderView */
//@property (nonatomic, strong) HQCalenderView *calenderView;

/** startLabel */
@property (nonatomic, weak) UILabel *startLabel;
/** endLabel */
@property (nonatomic, weak) UILabel *endLabel;
/** startView */
@property (nonatomic, weak) UIButton *startView;
/** endView */
@property (nonatomic, weak) UIButton *endView;
/** endBtn */
@property (nonatomic, weak) UIButton *endBtn;
/** startBtn */
@property (nonatomic, weak) UIButton *startBtn;



/**
 * 左按钮被点击函数
 */
@property (nonatomic, strong) ActionHandler onLeftTouched;

/**
 * 右按钮被点击函数
 */
@property (nonatomic, strong) ActionParameter onRightTouched;

/**
 * 关闭函数
 */
@property (nonatomic, strong) ActionHandler onDismiss;


@property (nonatomic, strong) NSDate *startSelectDate;
@property (nonatomic, strong) NSDate *endSelectDate;

/** isEnd */
@property (nonatomic, assign) BOOL isEnd;
@end

@implementation HQTFSelectDateView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
        
    }
    return self;
}


- (void)setupChild{
    
    self.backgroundColor = WhiteColor;
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:(CGRect){LeftMargin,10,LabelWidth,22}];
    startLabel.text = [[NSDate date] getVerticalYearMonthDay];
    startLabel.font = FONT(16);
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.textColor = HexAColor(0x8c96ab, 1);
    [self addSubview:startLabel];
    self.startLabel = startLabel;
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:(CGRect){SCREEN_WIDTH-LeftMargin-LabelWidth,10,LabelWidth,22}];
    endLabel.font = FONT(16);
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.text = [[NSDate date] getVerticalYearMonthDay];
    endLabel.textColor = HexAColor(0x8c96ab, 1);
    [self addSubview:endLabel];
    self.endLabel = endLabel;
    
    UIButton *startBtn = [HQHelper buttonWithFrame:(CGRect){LeftMargin,CGRectGetMaxY(startLabel.frame),LabelWidth,30} target:self action:@selector(startDateClick:)];
    startBtn.titleLabel.font = FONT(18);
    [startBtn setTitle:@"开始日期" forState:UIControlStateNormal];
    [startBtn setTitle:@"开始日期" forState:UIControlStateHighlighted];
    [startBtn setTitle:@"开始日期" forState:UIControlStateSelected];
    [startBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [startBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    [startBtn setTitleColor:GreenColor forState:UIControlStateSelected];
    startBtn.selected = YES;
    [self addSubview:startBtn];
    self.startBtn = startBtn;
    
    UIButton *endBtn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-LeftMargin-LabelWidth,CGRectGetMaxY(endLabel.frame),LabelWidth,30} target:self action:@selector(endDateClick:)];
    endBtn.titleLabel.font = FONT(18);
    [endBtn setTitle:@"截止日期" forState:UIControlStateNormal];
    [endBtn setTitle:@"截止日期" forState:UIControlStateHighlighted];
    [endBtn setTitle:@"截止日期" forState:UIControlStateSelected];
    [endBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [endBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    [endBtn setTitleColor:GreenColor forState:UIControlStateSelected];
    [self addSubview:endBtn];
    self.endBtn = endBtn;
    
    UIButton *startView = [UIButton buttonWithType:UIButtonTypeCustom];
    startView.frame = (CGRect){CGRectGetMinX(startBtn.frame),CGRectGetMaxY(startBtn.frame) + 5,LabelWidth,3};
    [startView setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [startView setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
    [startView setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateSelected];
    startView.selected = YES;
    [self addSubview:startView];
    self.startView = startView;
    
    UIButton *endView = [UIButton buttonWithType:UIButtonTypeCustom];
    endView.frame = (CGRect){CGRectGetMinX(endBtn.frame),CGRectGetMaxY(endBtn.frame) + 5,LabelWidth,3};
    [endView setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [endView setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
    [endView setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateSelected];
    [self addSubview:endView];
    self.endView = endView;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = (CGRect){10,CGRectGetMaxY(startLabel.frame)-10,44,44};
    [cancel setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [cancel setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateHighlighted];
    [self addSubview:cancel];
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = (CGRect){SCREEN_WIDTH-44-10,CGRectGetMaxY(endLabel.frame)-10,44,44};
    [sure setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateNormal];
    [sure setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateHighlighted];
    [self addSubview:sure];
    [sure addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(startView.frame),SCREEN_WIDTH,0.5}];
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
    
//    _calenderView = [[HQCalenderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sepeView.frame) + 20, SCREEN_WIDTH, Long(ItemWidth*6)+44+18)];
//    UIView *sepa = [[UIView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(_calenderView.frame) - 0.5, SCREEN_WIDTH, 0.5}];
//    sepa.backgroundColor = CellSeparatorColor;
//    [_calenderView addSubview:sepa];
//    _calenderView.delegate = self;
//    _calenderView.isEnd = NO;
    self.startSelectDate = [NSDate date];
//    [self addSubview:_calenderView];
    
}

- (void)startDateClick:(UIButton *)button{
    
    self.startView.selected = YES;
    self.startBtn.selected = YES;
    self.endView.selected = NO;
    self.endBtn.selected = NO;
    self.isEnd = NO;
}
- (void)endDateClick:(UIButton *)button{
    
    self.startView.selected = NO;
    self.startBtn.selected = NO;
    self.endView.selected = YES;
    self.endBtn.selected = YES;
    self.isEnd = YES;
}

- (void)cancelClick{
    
    if (self.onLeftTouched) self.onLeftTouched();
    [self dismiss];
}

- (void)sureClick{
    
    if (!self.startSelectDate || !self.endSelectDate) {
        [MBProgressHUD showError:@"请选择截止时间" toView:KeyWindow];
        return;
    }
    if (self.onRightTouched) self.onRightTouched(@[self.startSelectDate,self.endSelectDate]);
    [self dismiss];
}

- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
    
}

-(void)setIsEnd:(BOOL)isEnd{
    _isEnd = isEnd;
    
//    _calenderView.isEnd = isEnd;
}


//- (void)calenderView:(HQCalenderView *)calenderView selectedDate:(JBCalendarDate *)date isEnd:(BOOL)isEnd{
//    
//    if (!isEnd) {// 开始
//        self.startLabel.text = [[date nsDate] getVerticalYearMonthDay];
//        self.startSelectDate = [date nsDate];
//    }else{// 截止
//        
//        self.endLabel.text = [[date nsDate] getVerticalYearMonthDay];
//        self.endSelectDate = [date nsDate];
//    }
//    
//}

/**
 * 选择日期
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showDateViewOnLeftTouched:(ActionHandler)onLeftTouched
                onRightTouched:(ActionParameter)onRightTouched {
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x1234554321] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x1234554321;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    
    // 告警窗体
    HQTFSelectDateView *view = [[HQTFSelectDateView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-Long(440),SCREEN_WIDTH,Long(440)}];
    
    view.onLeftTouched = onLeftTouched;
    view.onRightTouched = onRightTouched;
    view.onDismiss = ^(void) {
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    };
    
    view.tag = 0x445;
    
    [bgView addSubview:view];
    [window addSubview:bgView];
    
    
    // 显示窗体
    [window makeKeyAndVisible];
}



+ (void)tapBgView:(UIButton *)tap{
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.25 animations:^{
        [window viewWithTag:0x1234554321].alpha = 0;
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x1234554321] removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
