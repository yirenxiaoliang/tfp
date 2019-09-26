//
//  TFSelectCalendarView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectCalendarView.h"
#import "TFDateView.h"
#import "TFCalendarView.h"

@interface TFSelectCalendarView()<TFDateViewDelegate,TFCalendarViewDelegate>

/** type */
@property (nonatomic, assign) DateViewType type;
/** timeSp */
@property (nonatomic, assign) long long timeSp;

/**  右按钮被点击函数  */
@property (nonatomic, strong) Action onRightTouched;
/** 关闭函数 */
@property (nonatomic, strong) ActionHandler onDismiss;

/** 确定后返回的选中时间字符串 */
@property (nonatomic , copy) NSString *date;
/** 确定后返回的选中时间字符串 */
@property (nonatomic , copy) NSString *time;
/** 确定后返回的选中时间字符串 */
@property (nonatomic , copy) NSString *selectedDate;

/** dateView */
@property (nonatomic, strong) TFDateView *dateView;

/** calendarView */
@property (nonatomic, strong) TFCalendarView *calendarView;


/** dateLabel */
@property (nonatomic, weak) UILabel *dateLabel;
/** timeLabel */
@property (nonatomic, weak) UILabel *timeLabel;
/** dateLine */
@property (nonatomic, weak) UIView *dateLine;
/** timeLine */
@property (nonatomic, weak) UIView *timeLine;


@end

@implementation TFSelectCalendarView



-(instancetype)initWithFrame:(CGRect)frame withType:(DateViewType)type timeSp:(long long)timeSp{
    if (self = [super initWithFrame:frame]) {
        
        self.type = type;
        self.timeSp = timeSp;
        
        [self setupChild];
        
    }
    return self;
}


- (void)setupChild{
    
    self.backgroundColor = WhiteColor;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,55}];
    [self addSubview:view];
    view.backgroundColor = BackGroudColor;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:clearButton];
    [clearButton setTitle:@"取消" forState:UIControlStateNormal];
    [clearButton setTitle:@"取消" forState:UIControlStateHighlighted];
    clearButton.frame = CGRectMake(0, 0, 60, 55);
    [clearButton setTitleColor:GreenColor forState:UIControlStateNormal];
    [clearButton setTitleColor:GreenColor forState:UIControlStateHighlighted];
    clearButton.titleLabel.font = BFONT(14);
    [clearButton addTarget:self action:@selector(clearClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){(self.width-120-100-70)/2 + 60,0,100,55}];
    [view addSubview:label];
    self.date = [HQHelper nsdateToTime:self.timeSp formatStr:@"yyyy-MM-dd"];
    label.text = self.date;
    label.font = BFONT(14);
    label.textColor = BlackTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    self.dateLabel = label;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateClicked)];
    [label addGestureRecognizer:tap];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){label.x,label.bottom-3,label.width,3}];
    line.backgroundColor = GreenColor;
    [view addSubview:line];
    self.dateLine = line;
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(label.frame),0,70,55}];
    [view addSubview:label1];
    NSString *str = @"";
    if (self.type == DateViewType_HourMinuteSecond) {
        str = @"HH:mm:ss";
    }else if (self.type == DateViewType_HourMinute){
        str = @"HH:mm";
    }else{
        str = @"HH";
    }
    self.time = [HQHelper nsdateToTime:self.timeSp formatStr:str];
    label1.text = self.time;
    label1.font = BFONT(14);
    label1.textColor = BlackTextColor;
    label1.textAlignment = NSTextAlignmentCenter;
    self.timeLabel = label1;
    label1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeClicked)];
    [label1 addGestureRecognizer:tap1];
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:(CGRect){label1.x,label1.bottom-3,label1.width,3}];
    line1.backgroundColor = GreenColor;
    [view addSubview:line1];
    self.timeLine = line1;
    line1.hidden = YES;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateHighlighted];
    button.frame = CGRectMake(self.width-60, 0, 60, 55);
    [button setTitleColor:GreenColor forState:UIControlStateNormal];
    [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
    button.titleLabel.font = BFONT(14);
    [button addTarget:self action:@selector(sureClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    TFDateView *dateView = [TFDateView selectDateViewWithFrame:(CGRect){0,55,self.width,self.height-55} type:self.type timeSp:self.timeSp];
    dateView.delegate = self;
    self.dateView = dateView;
    [self addSubview:dateView];
    dateView.hidden = YES;
    
    NSString *timesStr = [HQHelper nsdateToTime:self.timeSp formatStr:@"yyyy-MM-dd"];
    long long times= [HQHelper changeTimeToTimeSp:timesStr formatStr:@"yyyy-MM-dd"];
    TFCalendarView *calendarView = [TFCalendarView selectCalendarViewWithFrame:(CGRect){0,55,self.width,self.height-55} timeSp:times showChineseCalendar:YES howChineseHoliday:YES];
    calendarView.delegate = self;
    self.calendarView = calendarView;
    [self addSubview:calendarView];
    
    self.selectedDate = [NSString stringWithFormat:@"%@ %@",self.date,self.time];
}

- (void)dateClicked{
    
    self.calendarView.hidden = NO;
    self.dateLine.hidden = NO;
    self.dateView.hidden = YES;
    self.timeLine.hidden = YES;
    
}
- (void)timeClicked{
    
    self.calendarView.hidden = YES;
    self.dateLine.hidden = YES;
    self.dateView.hidden = NO;
    self.timeLine.hidden = NO;
}

#pragma mark - TFDateViewDelegate
-(void)dateView:(TFDateView *)dateView selectDate:(NSString *)selectDate{
    
    self.time = selectDate;
    self.timeLabel.text = self.time;
    self.selectedDate = [NSString stringWithFormat:@"%@ %@",self.date,self.time];
}

#pragma mark - TFCalendarViewDelegate
- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate{
    
    self.date = [HQHelper nsdateToTime:startDate*1000 formatStr:@"yyyy-MM-dd"];
    self.dateLabel.text = self.date;
    self.selectedDate = [NSString stringWithFormat:@"%@ %@",self.date,self.time];
}


- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
}

- (void)sureClicked:(UIButton *)button{
    
    [self dismiss];
    if (self.onRightTouched) self.onRightTouched(self.selectedDate);
}

- (void)clearClicked:(UIButton *)button{
    
    [self dismiss];
//    if (self.onRightTouched) self.onRightTouched(@"");
}


/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectCalendarViewWithType:(DateViewType)type
                             timeSp:(long long)timeSp
                     onRightTouched:(Action)onRightTouched{
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x98765;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    // 告警窗体
    TFSelectCalendarView *view = [[TFSelectCalendarView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-(55+Long(365)),SCREEN_WIDTH,55+Long(365)} withType:type timeSp:timeSp];
    view.type = type;
    view.timeSp = timeSp;
    view.onRightTouched = onRightTouched;
    __weak UIView *weakView = view;
    view.onDismiss = ^(void){
        [UIView animateWithDuration:0.35 animations:^{
            weakView.y = SCREEN_HEIGHT;
            bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
        
    };
    view.tag = 0x11111;
    [bgView addSubview:view];
    [window addSubview:bgView];
    
    // 动画显示
    [UIView animateWithDuration:0.35 animations:^{
        view.y = SCREEN_HEIGHT -(55+Long(365));
        bgView.alpha = 1;
        
    }];
    // 显示窗体
    [window makeKeyAndVisible];

}
+ (void)tapBgView:(UIButton *)tap{
    
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.35 animations:^{
        [window viewWithTag: 0x11111].y = SCREEN_HEIGHT;
        [window viewWithTag:0x98765].alpha = 0;
        
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x98765] removeFromSuperview];
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
