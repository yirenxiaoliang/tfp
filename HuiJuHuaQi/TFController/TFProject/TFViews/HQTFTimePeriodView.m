//
//  HQTFTimePeriodView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTimePeriodView.h"

#define PickerWidth Long(50)
#define PickerRowHeight Long(50)

@interface HQTFTimePeriodView ()<UIPickerViewDelegate,UIPickerViewDataSource>


/** hours */
@property (nonatomic, strong) NSMutableArray *hours;
/** minutes */
@property (nonatomic, strong) NSMutableArray *minutes;

/** date1 */
@property (nonatomic, weak) UIPickerView *date1;
/** date2 */
@property (nonatomic, weak) UIPickerView *date2;
/** date3 */
@property (nonatomic, weak) UIPickerView *date3;
/** date4 */
@property (nonatomic, weak) UIPickerView *date4;
/** time */
@property (nonatomic, weak) UILabel *time;


/** 开始hour */
@property (nonatomic, copy) NSString *startHour;
/** 开始minute */
@property (nonatomic, copy) NSString *startMinute;
/** 结束hour */
@property (nonatomic, copy) NSString *endHour;
/** 结束minute */
@property (nonatomic, copy) NSString *endMinute;

/**
 * 事件回调处理函数(带参数)
 */
@property (nonatomic, copy) ActionArray timeSpArray;

/** 关闭函数 */
@property (nonatomic, strong) ActionHandler onDismiss;
@end


@implementation HQTFTimePeriodView

-(NSMutableArray *)hours{
    if (!_hours) {
        
        _hours = [NSMutableArray array];
        
        NSMutableArray *hour = [NSMutableArray array];
        for (NSInteger i = 0; i < 24; i ++) {
            
            NSString *str = [NSString stringWithFormat:@"%02ld",i];
            [hour addObject:str];
        }
        
        for (NSInteger i = 0; i < 7; i ++) {
            
            [_hours addObjectsFromArray:hour];
        }
        
    }
    return _hours;
}
-(NSMutableArray *)minutes{
    if (!_minutes) {
        _minutes = [NSMutableArray array];
        
        
        NSMutableArray *minute = [NSMutableArray array];
        for (NSInteger i = 0; i < 60; i ++) {
            
            NSString *str = [NSString stringWithFormat:@"%02ld",i];
            [minute addObject:str];
        }
        
        for (NSInteger i = 0; i < 3; i ++) {
            
            [_minutes addObjectsFromArray:minute];
        }

    }
    return _minutes;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    UIPickerView *date1 = [[UIPickerView alloc] initWithFrame:(CGRect){(SCREEN_WIDTH/2-2*PickerWidth)/2-10,55,PickerWidth,Long(245)}];
    date1.delegate = self;
    date1.showsSelectionIndicator = YES;
    [self addSubview:date1];
    date1.tag = 0x1111;
    self.date1 = date1;
    
    UIPickerView *date2 = [[UIPickerView alloc] initWithFrame:(CGRect){CGRectGetMaxX(date1.frame),55,PickerWidth,Long(245)}];
    date2.delegate = self;
    date2.showsSelectionIndicator = YES;
    [self addSubview:date2];
    date2.tag = 0x1112;
    self.date2 = date2;
    
    
    UIPickerView *date3 = [[UIPickerView alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2 + (SCREEN_WIDTH/2-2*PickerWidth)/2-10,55,PickerWidth,Long(245)}];
    date3.delegate = self;
    date3.showsSelectionIndicator = YES;
    [self addSubview:date3];
    date3.tag = 0x1113;
    self.date3 = date3;
    
    
    UIPickerView *date4 = [[UIPickerView alloc] initWithFrame:(CGRect){CGRectGetMaxX(date3.frame),55,PickerWidth,Long(245)}];
    date4.delegate = self;
    date4.showsSelectionIndicator = YES;
    [self addSubview:date4];
    date4.tag = 0x1114;
    self.date4 = date4;

    
    UIView *topView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,55}];
    [self addSubview:topView];
    topView.backgroundColor = WhiteColor;
    topView.layer.borderColor = CellSeparatorColor.CGColor;
    topView.layer.borderWidth = 0.5;
    
    UILabel *timeDesc = [[UILabel alloc] init];
    [topView addSubview:timeDesc];
    timeDesc.font = FONT(16);
    timeDesc.textColor = ExtraLightBlackTextColor;
    timeDesc.text = @"时间段";
    [timeDesc sizeToFit];
    timeDesc.origin = CGPointMake(15, (55-timeDesc.size.height)/2);
    
    
    UILabel *time = [[UILabel alloc] init];
    [topView addSubview:time];
    time.font = FONT(20);
    time.textColor = LightBlackTextColor;
    time.text = @"18:18 - 18:50";
    time.size = CGSizeMake(200, 21);
    time.origin = CGPointMake(CGRectGetMaxX(timeDesc.frame)+10, (55-time.size.height)/2);
    self.time = time;
    
    
    UIButton *finishBtn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-55-10,0,55,55} target:self action:@selector(clearTime)];
    [finishBtn setTitle:@"清空" forState:UIControlStateNormal];
    [finishBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [topView addSubview:finishBtn];
    
    
    self.backgroundColor = HexAColor(0xf2f2f2, 1);
    
    
    UIView *middleView = [[UIView alloc] initWithFrame:(CGRect){0,(Long(245)+55-PickerRowHeight-55-3)/2+55,SCREEN_WIDTH,PickerRowHeight+3}];
    middleView.userInteractionEnabled = NO;
    [self addSubview:middleView];
    middleView.layer.borderWidth = 0.5;
    middleView.layer.borderColor = LightGrayTextColor.CGColor;
    
    UILabel *colon1 = [[UILabel alloc] init];
    [middleView addSubview:colon1];
    colon1.font = BFONT(20);
    colon1.textColor = BlackTextColor;
    colon1.text = @":";
    [colon1 sizeToFit];
    colon1.origin = CGPointMake(SCREEN_WIDTH/4-10, (PickerRowHeight-colon1.size.height)/2);
    
    UILabel *colon2 = [[UILabel alloc] init];
    [middleView addSubview:colon2];
    colon2.font = BFONT(20);
    colon2.textColor = BlackTextColor;
    colon2.text = @":";
    [colon2 sizeToFit];
    colon2.origin = CGPointMake(3*SCREEN_WIDTH/4-10, (PickerRowHeight-colon1.size.height)/2);
    
    UILabel *line = [[UILabel alloc] init];
    [middleView addSubview:line];
    line.size = CGSizeMake(25, 2);
    line.backgroundColor = LightBlackTextColor;
    line.center = CGPointMake(middleView.centerX-10, middleView.height/2);
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,55+Long(245),SCREEN_WIDTH,60}];
    [self addSubview:view];
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH/2 * i,0,SCREEN_WIDTH/2,60} target:self action:@selector(twoBtnClicked:)];
        [view addSubview:btn];
        btn.backgroundColor = WhiteColor;
        btn.titleLabel.font = FONT(20);
        btn.tag = 0x123 + i;
        if (i == 0) {
            
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateHighlighted];
            [btn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
            [btn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
        }else{
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn setTitle:@"确定" forState:UIControlStateHighlighted];
            [btn setTitleColor:GreenColor forState:UIControlStateNormal];
            [btn setTitleColor:GreenColor forState:UIControlStateHighlighted];
        }
    }
    
    
    UIView *sepeview = [[UIView alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2,0,0.5,20}];
    sepeview.backgroundColor = CellSeparatorColor;
    sepeview.centerY = view.height/2;
    [view addSubview:sepeview];
    
}

- (void)twoBtnClicked:(UIButton *)button{
    
    switch (button.tag - 0x123) {
        case 0:
        {
            [self dismiss];
        }
            break;
        case 1:
        {
            [self finished];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)clearTime{
    
    self.startHour = @"00";
    self.startMinute = @"00";
    self.endHour = @"00";
    self.endMinute = @"00";
    
    [self finished];
}

- (void)finished{
    
    NSMutableArray *times = [NSMutableArray array];
    NSString *start = [NSString stringWithFormat:@"%@:%@",self.startHour,self.startMinute];
    NSString *end = [NSString stringWithFormat:@"%@:%@",self.endHour,self.endMinute];
    
    
    [times addObject:start];
    [times addObject:end];

    
    if (self.timeSpArray) {
        self.timeSpArray(times);
    }
    
    [self dismiss];
}


- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
}

/** pickerView 代理 */
// 每个滚动条中有多少row
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (pickerView.tag - 0x1111) {
        case 0:
        {
            return self.hours.count;
        }
            break;
        case 1:
        {
            return self.minutes.count;
        }
            break;
        case 2:
        {
            return self.hours.count;
        }
            break;
        case 3:
        {
            return self.minutes.count;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
    
}

/** 设置初始时间 */
- (void)setBeginTimeWithStartTimeSp:(long long)startTimeSp endTimeSp:(long long )endTimeSp{
    
    NSString *start = [HQHelper nsdateToTime:startTimeSp formatStr:@"HH:mm"];
    NSString *end = [HQHelper nsdateToTime:endTimeSp formatStr:@"HH:mm"];
    
    NSArray *starts = [start componentsSeparatedByString:@":"];
    NSArray *ends = [end componentsSeparatedByString:@":"];
    
    NSAssert(starts.count == 2 && ends.count == 2, @"数组长度不为2，字符串处理有问题");
    
    for (NSInteger i = 24*3; i<24*4; i ++) {
        NSString *string = self.hours[i];
        NSString *start1 = starts[0];
        if ([start1 isEqualToString:string]) {
            [self.date1 selectRow:i inComponent:0 animated:NO];
            self.startHour = start1;
            break;
        }
    }
    
    for (NSInteger i = 60*1; i<60*2; i ++) {
        NSString *string = self.minutes[i];
        NSString *start2 = starts[1];
        if ([start2 isEqualToString:string]) {
            [self.date2 selectRow:i inComponent:0 animated:NO];
            self.startMinute = start2;
            break;
        }
    }
    
    for (NSInteger i = 24*3; i<24*4; i ++) {
        NSString *string = self.hours[i];
        NSString *end1 = ends[0];
        if ([end1 isEqualToString:string]) {
            [self.date3 selectRow:i inComponent:0 animated:NO];
            self.endHour = end1;
            break;
        }
    }
    
    for (NSInteger i = 60*1; i<60*2; i ++) {
        NSString *string = self.minutes[i];
        NSString *end2 = ends[1];
        if ([end2 isEqualToString:string]) {
            [self.date4 selectRow:i inComponent:0 animated:NO];
            self.endMinute = end2;
            break;
        }
    }
    
    self.time.text = [NSString stringWithFormat:@"%@:%@ - %@:%@",self.startHour,self.startMinute,self.endHour,self.endMinute];
}



// 有多少滚动条
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
// 每个row中显示字符串
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (pickerView.tag - 0x1111) {
        case 0:
        {
            return self.hours[row];
        }
            break;
        case 1:
        {
            return self.minutes[row];
        }
            break;
        case 2:
        {
            return self.hours[row];
        }
            break;
        case 3:
        {
            return self.minutes[row];
        }
            break;
            
        default:
            break;
    }
    

    return @"";
}
// 每个滚动条row高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return PickerRowHeight;
}

// 每个滚动条row宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return PickerWidth;
    
}
// 滚动停止选中的row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (pickerView.tag-0x1111) {
        case 0:
        {
            self.startHour = self.hours[row];
            
            for (NSInteger i = 24*3; i<24*4; i ++) {
                NSString *string = self.hours[i];
                if ([self.startHour isEqualToString:string]) {
                    [self.date1 selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
        }
            break;
        case 1:
        {
            
            self.startMinute = self.minutes[row];
            for (NSInteger i = 60*1; i<60*2; i ++) {
                NSString *string = self.minutes[i];
                if ([self.startMinute isEqualToString:string]) {
                    [self.date2 selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
        }
            break;
        case 2:
        {
            self.endHour = self.hours[row];
            
            for (NSInteger i = 24*3; i<24*4; i ++) {
                NSString *string = self.hours[i];
                if ([self.endHour isEqualToString:string]) {
                    [self.date3 selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            
        }
            break;
        case 3:
        {
            
            self.endMinute = self.minutes[row];
            for (NSInteger i = 60*1; i<60*2; i ++) {
                NSString *string = self.minutes[i];
                if ([self.endMinute isEqualToString:string]) {
                    [self.date4 selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    self.time.text = [NSString stringWithFormat:@"%@:%@ - %@:%@",self.startHour,self.startMinute,self.endHour,self.endMinute];
    
}

/**
 * 时间段选择
 *
 * @param startTimeSp 开始时间
 * @param endTimeSp   结束时间
 * @param timeSpArray 时间戳数组（存放开始于结束时间戳）
 */
+ (void) selectTimeViewWithStartTimeSp:(long long)startTimeSp
                             endTimeSp:(long long)endTimeSp
                           timeSpArray:(ActionArray)timeSpArray
{
    
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
    
    
    HQTFTimePeriodView *view = [[HQTFTimePeriodView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-Long(245)-55-60,SCREEN_WIDTH,Long(245)+55+60}];
    [view setBeginTimeWithStartTimeSp:startTimeSp endTimeSp:endTimeSp];
    view.timeSpArray = timeSpArray;
    
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
        view.y = SCREEN_HEIGHT - (Long(245)+55+60);
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
