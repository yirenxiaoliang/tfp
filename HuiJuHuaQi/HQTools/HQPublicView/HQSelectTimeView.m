//
//  HQSelectTimeView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/20.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSelectTimeView.h"
#import "NSDate+Calendar.h"

@interface HQSelectTimeView ()<UIPickerViewDelegate>
/** 取消 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/** 确定 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/** 时间显示label */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 清空按钮 */
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/** 年月日时分日期选择 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
/** 自定义日期选择 */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
/** 时间背景 */
@property (weak, nonatomic) IBOutlet UIView *timeBg;
@property (weak, nonatomic) IBOutlet UIView *sepeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeBgH;
/** 时间类型 */
@property (nonatomic , assign) SelectTimeViewType type;
/** 左按钮被点击函数 */
@property (nonatomic, strong) ActionHandler onLeftTouched;
/**  右按钮被点击函数  */
@property (nonatomic, strong) Action onRightTouched;
/** 关闭函数 */
@property (nonatomic, strong) ActionHandler onDismiss;
/** 确定后返回的选中时间字符串 */
@property (nonatomic , copy) NSString *selectedDate;
/** 月数组 */
@property (nonatomic , strong)NSMutableArray *months;
/** 周数组 */
@property (nonatomic , strong)NSMutableArray *weeks;
/** 分数组 */
@property (nonatomic , strong)NSMutableArray *miuths;
/** 年 */
@property (nonatomic , copy) NSString *year;
/** 初始年 */
@property (nonatomic , copy) NSString *temYear;
/** 月 */
@property (nonatomic , copy) NSString *month;
/** 周 */
@property (nonatomic , copy) NSString *week;
/** 分 */
@property (nonatomic , copy) NSString *miuth;

/** 时间标题 */
@property (nonatomic , copy) NSString *timeTitle;
@end

@implementation HQSelectTimeView

- (NSMutableArray *)months{
    if (_months == nil) {
        _months = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 1; i < 13; i ++) {
            [arr addObject:[NSString stringWithFormat:@"%02d月", i]];
        }
        
        for (int j = 0; j < 201; j ++) {
            [_months addObjectsFromArray:arr];
        }
        
    }
    return _months;
}


- (NSMutableArray *)weeks{
    if (_weeks == nil) {
        _weeks = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 1; i < 55; i ++) {
            [arr addObject:[NSString stringWithFormat:@"%02d周", i]];
        }
        
        for (int j = 0; j < 51; j ++) {
            [_weeks addObjectsFromArray:arr];
        }
    }
    return _weeks;
}

- (NSMutableArray *)miuths{
    if (_miuths == nil) {
        _miuths = [NSMutableArray array];
        for (NSInteger i = 0; i < 27; i ++) {
            if (i == 0) {
                [_miuths addObject:@"关闭"];
            }else{
                [_miuths addObject:[NSString stringWithFormat:@"%0ld分钟", i + 4]];
            }
        }
    }
    return _miuths;
}



- (void)awakeFromNib{
    
    [super awakeFromNib];
//    self.datePicker.locale = nil;
    [self.cancelBtn setTitleColor:GrayTextColor forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
    
    
    [self.sureBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    
    self.timeBg.layer.borderWidth = 0.5;
    self.timeBg.layer.borderColor = CellSeparatorColor.CGColor;
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = CellSeparatorColor.CGColor;
    self.datePicker.backgroundColor = CellSeparatorColor;
    self.pickerView.backgroundColor = CellSeparatorColor;
    // UIDatePickerModeTime 上下午 时分
    // UIDatePickerModeDate  年月日
    // UIDatePickerModeDateAndTime 月日周 上下午 时分
    // UIDatePickerModeCountDownTimer  时分
    [self.datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    self.datePicker.timeZone = timeZone;
    
    switch (self.type) {
        case SelectTimeViewType_YearMonthDayHourMiuth:// 年月日时分
        {
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
        }
            break;
        case SelectTimeViewType_YearMonthDay:// 年月日
        {
            
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
        }
            break;
        case SelectTimeViewType_YearMonth:// 年月
        {
            
            self.datePicker.hidden = YES;
            self.pickerView.hidden = NO;
            
        }
            break;
        case SelectTimeViewType_YearWeek:// 年周
        {
            
            self.datePicker.hidden = YES;
            self.pickerView.hidden = NO;
        }
            break;
            
        case SelectTimeViewType_Miuth:// 分
        {
            
            self.datePicker.hidden = YES;
            self.pickerView.hidden = NO;
        }
            break;
            
        case SelectTimeViewType_HourMiuth:// 时分
        {
            self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.deleteBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    self.deleteBtn.titleLabel.font = FONT(18);
    self.sepeW.constant = 0.5;
    self.sepeView.backgroundColor = CellSeparatorColor;
}

/** 监听DatePicker值改变 */
- (void)datePickerChange:(UIDatePicker *)datePicker{
    
    
    switch (self.type) {
        case SelectTimeViewType_YearMonthDayHourMiuth:// 年月日时分
        {
            self.selectedDate = [HQHelper getYearMonthDayHourMiuthWithDate:self.datePicker.date];
        }
            break;
        case SelectTimeViewType_YearMonthDay:// 年月日
        {
            self.selectedDate = [HQHelper getYearMonthDayWithDate:self.datePicker.date];
        }
            break;

        case SelectTimeViewType_HourMiuth:// 时分
        {
            self.selectedDate = [HQHelper getHourMiuthWithDate:self.datePicker.date];
        }
            break;
            
        default:
            break;
    }
    
    self.timeLabel.text = self.selectedDate;
    
    self.timeLabel.attributedText = [self attributeTextWithStartString:[NSString stringWithFormat:@"%@:",self.timeTitle] WithEndString:self.selectedDate];
}
/** 设置初始时间 */
- (void)setBeginTimeWithTimeSp:(long long)timeSp{
    
    
    self.year  = [HQHelper nsdateToTime:timeSp formatStr:@"yyyy年"];
    self.temYear = [self.year substringWithRange:NSMakeRange(0, 4)];
    self.week  = [NSString stringWithFormat:@"%02ld周",(NSInteger)[[NSDate dateWithTimeIntervalSince1970:timeSp/1000] week]];
    self.month = [HQHelper nsdateToTime:timeSp formatStr:@"MM月"];
    
    switch (self.type) {
            
            // datePicker
        case SelectTimeViewType_YearMonthDayHourMiuth:// 年月日时分
        {
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
            self.selectedDate = [HQHelper nsdateToTime:timeSp formatStr:@"yyyy-MM-dd HH:mm"];
            self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
        }
            break;
        case SelectTimeViewType_YearMonthDay:// 年月日
        {
            
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
            self.selectedDate = [HQHelper nsdateToTime:timeSp formatStr:@"yyyy-MM-dd"];
            self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
        }
            break;
        case SelectTimeViewType_HourMiuth:// 时分
        {
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
            self.selectedDate = [HQHelper nsdateToTime:timeSp formatStr:@"HH:mm"];
            self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
        }
            break;
            
            
           // pickerView
        case SelectTimeViewType_YearMonth:// 年月
        {
            
            self.datePicker.hidden = YES;
            self.pickerView.hidden = NO;
            self.selectedDate = [HQHelper nsdateToTime:timeSp formatStr:@"yyyy年MM月"];
            self.pickerView.delegate = self;
            
            for (int i = 1200; i < 1320; i ++) {
                NSString *obj = self.months[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.month]) {
                    [self.pickerView selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
            
        }
            break;
        case SelectTimeViewType_YearWeek:// 年周
        {
            
            self.datePicker.hidden = YES;
            self.pickerView.hidden = NO;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp / 1000];
            self.selectedDate = [HQHelper getYearWeekWithDate:date];
            self.pickerView.delegate = self;
            
            for (int i = 1350; i < 1404; i ++) {
                NSString *obj = self.weeks[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.week]) {
                    [self.pickerView selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
            
        }
            break;
        case SelectTimeViewType_Miuth:// 分
        {
            
            self.datePicker.hidden = YES;
            self.pickerView.hidden = NO;
            
            if (timeSp == 0) {
                self.selectedDate = @"关闭";
            }else{
                self.selectedDate = [NSString stringWithFormat:@"%lld分钟",timeSp];
            }
            self.pickerView.delegate = self;
            self.miuth = self.selectedDate;
            
            for (int i = 0; i < 27; i ++) {
                NSString *obj = self.miuths[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.miuth]) {
                    [self.pickerView selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    
    self.timeLabel.text = self.selectedDate;
    
    if (self.type == SelectTimeViewType_YearWeek) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp / 1000];
       
        self.timeLabel.text = [self weekPadWithdate:date];
        
    }
    
    self.timeLabel.attributedText = [self attributeTextWithStartString:[NSString stringWithFormat:@"%@:",self.timeTitle] WithEndString:self.selectedDate];
    
}

/** 将两段字符串弄成属性文本 */
- (NSAttributedString *)attributeTextWithStartString:(NSString *)startString WithEndString:(NSString *)endString{
    
    NSString *total = [startString stringByAppendingString:endString];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:total];
    [string addAttribute:NSForegroundColorAttributeName value:ExtraLightBlackTextColor range:[total rangeOfString:startString]];
    [string addAttribute:NSForegroundColorAttributeName value:LightBlackTextColor range:[total rangeOfString:endString]];
    [string addAttribute:NSFontAttributeName value:FONT(16) range:[total rangeOfString:startString]];
    [string addAttribute:NSFontAttributeName value:FONT(20) range:[total rangeOfString:endString]];
    
    return string;
}


/** 获取某周起始日期 */
- (NSString *)weekPadWithdate:(NSDate *)date{
    
    // 这周第一天
    NSDate *firstWeek = [date firstDayOfTheWeek];
    NSString *firstWeekDay = [HQHelper getYearMonthDayWithDate:firstWeek];
    NSString *lastWeekDay = @"";
    
    // 当月天数
    NSUInteger numDay = [date numberOfDaysInMonth];
    // 获取这周第一天
    NSUInteger day = [firstWeek day];
    NSUInteger month = [firstWeek month];
    NSUInteger year = [firstWeek year];
    NSUInteger lastDay = 0;
    if (day + 7 > numDay) {
        lastDay = day + 7 - numDay;
        lastWeekDay = [NSString stringWithFormat:@"%@%02ld/%02ld", [firstWeekDay substringToIndex:5], month + 1,lastDay];
        
        if (month == 12) {
            lastWeekDay = [NSString stringWithFormat:@"%02ld/01/%02ld", year + 1,lastDay];
        }
    }else{
        lastDay = day + 7;
        lastWeekDay = [NSString stringWithFormat:@"%@%02ld", [firstWeekDay substringToIndex:8], lastDay];
    }
    
    
    return [NSString stringWithFormat:@"%@ - %@", firstWeekDay, lastWeekDay];
}


/** pickerView 代理 */
// 每个滚动条中有多少row
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (self.type == SelectTimeViewType_YearMonth) {
        return self.months.count;
    }else if (self.type == SelectTimeViewType_YearWeek){
        return self.weeks.count;
    }else{
        return self.miuths.count;
    }
    
    
}

// 有多少滚动条
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
// 每个row中显示字符串
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (self.type) {
        case SelectTimeViewType_YearMonth:// 年月
        {
            return self.months[row];
        }
            break;
        case SelectTimeViewType_YearWeek:// 年周
        {
            return self.weeks[row];
        }
            break;
            
        case SelectTimeViewType_Miuth:// 日时分
        {
            return self.miuths[row];
        }
            break;
            
        default:
            break;

    }
    
    return @"";
}
// 每个滚动条row高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 34;
}

// 每个滚动条row宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
        return 150;
    
}
// 滚动停止选中的row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (self.type) {
        case SelectTimeViewType_YearMonth:// 年月
        {
            self.month = self.months[row];
            NSInteger year = row / 12;
            NSInteger month = row % 12 + 1;
            NSInteger tem = [self.temYear integerValue] + (year - 100);
            self.temYear = [NSString stringWithFormat:@"%04ld", tem];
            self.year = [NSString stringWithFormat:@"%04ld年", tem];
            self.month = [NSString stringWithFormat:@"%02ld月", month];
            // 确定字符串
            self.selectedDate = [NSString stringWithFormat:@"%@%@",self.year, self.month];
            self.timeLabel.text = self.selectedDate;
            // 修改选中位置至最中间
            for (int i = 1200; i < 1320; i ++) {
                NSString *obj = self.months[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.month]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            
            
        }
            break;
        case SelectTimeViewType_YearWeek:// 年周
        {
            
            self.week = self.weeks[row];
            NSInteger year = row / 54;
            NSInteger week = row % 54 + 1;
            NSInteger tem = [self.temYear integerValue] + (year - 25);
            self.temYear = [NSString stringWithFormat:@"%04ld", tem];
            self.year = [NSString stringWithFormat:@"%04ld年", tem];
            self.week = [NSString stringWithFormat:@"%02ld周", week];
            
            // 判断周是否为这一年中应有
            NSString *temStr = [NSString stringWithFormat:@"%@12月31日 12:00", self.year];
            long long miao = [HQHelper changeTimeToTimeSp:temStr formatStr:@"yyyy年MM月dd日 HH:mm"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:miao];
            
            NSUInteger weekInt = [date weekOfDayInYear];
            HQLog(@"---------%ld", weekInt);
            
            NSUInteger weekNum = [date week];
            HQLog(@"*********%ld", weekNum);
            
            
            if (weekInt == weekNum) {// 一年中最后一天在最后一周
                if (week > weekInt) {// 大于说明周数超过一年中最大的一周
                    
                    self.week = [NSString stringWithFormat:@"%02ld周", weekInt];
                    
                    // 滚动至一年中最后一周
                    for (NSInteger i = row - 4; i < row; i ++) {
                        NSString *obj = self.weeks[i];
                        if ([obj isEqualToString:self.week]) {
                            [self.pickerView selectRow:i inComponent:0 animated:YES];
                            break;
                        }
                    }
                }

            }else{// 一年中最后一天不在最后一周
                
                if (week > weekInt - 1) {// 大于说明周数超过一年中最大的一周
                    
                    self.week = [NSString stringWithFormat:@"%02ld周", weekInt - 1];
                    
                    // 滚动至一年中最后一周
                    for (NSInteger i = row - 4; i < row; i ++) {
                        NSString *obj = self.weeks[i];
                        if ([obj isEqualToString:self.week]) {
                            [self.pickerView selectRow:i inComponent:0 animated:YES];
                            break;
                        }
                    }
                }
                
            }
            
            
            
            
            // 确定字符串
            self.selectedDate = [NSString stringWithFormat:@"%@%@",self.year, self.week];
            self.timeLabel.text = self.selectedDate;
            
            long long timeSp = [HQHelper changeWeekTimeToTimeSp:self.selectedDate];
            
            NSDate *datePad = [NSDate dateWithTimeIntervalSince1970:timeSp / 1000];
            
            self.timeLabel.text = [self weekPadWithdate:datePad];
            
            // 修改选中位置至最中间
            for (int i = 1350; i < 1404; i ++) {
                NSString *obj = self.weeks[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.week]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            
            
        }
            break;
            
        case SelectTimeViewType_Miuth:// 分
        {
            self.miuth = self.miuths[row];
            self.selectedDate = self.miuth;
            self.timeLabel.text = self.selectedDate;
            
        }
            break;
            
        default:
            break;
            
    }
}



- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismiss];
    if (self.onLeftTouched) self.onLeftTouched();
}


- (IBAction)sureClick:(UIButton *)sender {

    [self dismiss];
    if (self.onRightTouched) self.onRightTouched(self.selectedDate);
}
- (IBAction)deleteClick:(id)sender {
    
    [self dismiss];
    if (self.onRightTouched) self.onRightTouched(@"");
}

- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
}

/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectTimeViewWithType:(SelectTimeViewType)type
                           timeSp:(long long)timeSp
                      LeftTouched:(ActionHandler)onLeftTouched
                   onRightTouched:(Action)onRightTouched
{
  
    
    [self selectTimeViewWithType:type
                          timeSp:timeSp
                       timeTitle:@"截止时间"
                     LeftTouched:onLeftTouched
                  onRightTouched:onRightTouched];
}


/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param timeTitle   时间标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectTimeViewWithType:(SelectTimeViewType)type
                         timeSp:(long long)timeSp
                      timeTitle:(NSString *)timeTitle
                    LeftTouched:(ActionHandler)onLeftTouched
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
    HQSelectTimeView *view = [[[NSBundle mainBundle] loadNibNamed:@"HQSelectTimeView" owner:nil options:nil] firstObject];
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, Long(300));
    view.type = type;
    
    view.timeTitle = timeTitle;
    
    [view setBeginTimeWithTimeSp:timeSp];
    //    [view setTime];
    view.onLeftTouched = onLeftTouched;
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
        view.y = SCREEN_HEIGHT - Long(300);
        bgView.alpha = 1;
        
    }];
    // 显示窗体
    [window makeKeyAndVisible];
}
/**
 * 时间选择
 *
 * @param dateType 时间选择器类型
 * @param timeSp   开始时间
 * @param timeTitle   时间标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) selectTimeViewWithType:(SelectTimeViewType)type
                         timeSp:(long long)timeSp
                     showHeader:(BOOL)show
                    LeftTouched:(ActionHandler)onLeftTouched
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
    HQSelectTimeView *view = [[[NSBundle mainBundle] loadNibNamed:@"HQSelectTimeView" owner:nil options:nil] firstObject];
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, Long(300-55));
    view.type = type;
    view.timeBg.hidden = YES;
    view.pickerView.backgroundColor = WhiteColor;
    view.datePicker.backgroundColor = WhiteColor;
    view.timeBgH.constant = 0;
    
    [view setBeginTimeWithTimeSp:timeSp];
    //    [view setTime];
    view.onLeftTouched = onLeftTouched;
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
        view.y = SCREEN_HEIGHT - Long(300-55);
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
