//
//  TFDateView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFDateView.h"

@interface TFDateView ()<UIPickerViewDelegate,UIPickerViewDataSource>

/** 年月日时分日期选择 */
@property (weak, nonatomic)  UIDatePicker *datePicker;
/** 自定义日期选择 */
@property (weak, nonatomic)  UIPickerView *pickerView;

/** 确定后返回的选中时间字符串 */
@property (nonatomic , copy) NSString *selectedDate;
/** type */
@property (nonatomic, assign) DateViewType type;

/** 月数组 */
@property (nonatomic , strong)NSMutableArray *months;
/** 年数组 */
@property (nonatomic , strong)NSMutableArray *years;
/** 时数组 */
@property (nonatomic , strong)NSMutableArray *hours;
/** 分数组 */
@property (nonatomic , strong)NSMutableArray *minutes;
/** 秒数组 */
@property (nonatomic , strong)NSMutableArray *seconds;

/** 年 */
@property (nonatomic , copy) NSString *year;
/** 月 */
@property (nonatomic , copy) NSString *month;
/** 时 */
@property (nonatomic , copy) NSString *hour;
/** 分 */
@property (nonatomic , copy) NSString *minute;
/** 秒 */
@property (nonatomic , copy) NSString *second;
@end

@implementation TFDateView

- (NSMutableArray *)months{
    if (_months == nil) {
        _months = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 1; i < 13; i ++) {
            [arr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        
        for (int j = 0; j < 201; j ++) {
            [_months addObjectsFromArray:arr];
        }
        
    }
    return _months;
}

- (NSMutableArray *)years{
    
    if (!_years) {
        _years = [NSMutableArray array];
        
        for (NSInteger i = 1000; i < 9999; i ++) {
            [_years addObject:[NSString stringWithFormat:@"%ld", i]];
        }
        
    }
    return _years;
}
- (NSMutableArray *)hours{
    if (_hours == nil) {
        _hours = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            [arr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        
        for (int j = 0; j < 201; j ++) {
            [_hours addObjectsFromArray:arr];
        }
        
    }
    return _hours;
}
- (NSMutableArray *)minutes{
    if (_minutes == nil) {
        _minutes = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 60; i ++) {
            [arr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        
        for (int j = 0; j < 101; j ++) {
            [_minutes addObjectsFromArray:arr];
        }
        
    }
    return _minutes;
}
- (NSMutableArray *)seconds{
    if (_seconds == nil) {
        _seconds = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 60; i ++) {
            [arr addObject:[NSString stringWithFormat:@"%02d", i]];
        }
        
        for (int j = 0; j < 101; j ++) {
            [_seconds addObjectsFromArray:arr];
        }
        
    }
    return _seconds;
}


-(instancetype)initWithFrame:(CGRect)frame withType:(DateViewType)type{
    if (self = [super initWithFrame:frame]) {
        
        [self setupChildWithType:type];
    }
    return self;
}

- (void)setupChildWithType:(DateViewType)type{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:self.bounds];
    [self addSubview:datePicker];
    self.datePicker = datePicker;
    if (type == DateViewType_YearMonthDayHourMinute) {
        
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }else{
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    [datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    [self addSubview:pickerView];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    
    self.backgroundColor = WhiteColor;
}


-(void)setType:(DateViewType)type{
    _type = type;
    
    switch (type) {
        case DateViewType_YearMonthDay:
        case DateViewType_YearMonthDayHourMinute:
        {
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
        }
            break;
            
        default:
        {
            self.datePicker.hidden = YES;
            self.pickerView.hidden = NO;
        }
            break;
    }
    
}

-(void)setTimeSp:(long long)timeSp{
    _timeSp = timeSp;
    
    self.year  = [HQHelper nsdateToTime:timeSp formatStr:@"yyyy"];
    self.month = [HQHelper nsdateToTime:timeSp formatStr:@"MM"];
    self.hour = [HQHelper nsdateToTime:timeSp formatStr:@"HH"];
    self.minute = [HQHelper nsdateToTime:timeSp formatStr:@"mm"];
    self.second = [HQHelper nsdateToTime:timeSp formatStr:@"ss"];
    
    switch (self.type) {
        case DateViewType_YearMonthDayHourMinute:
        {
            self.selectedDate = [HQHelper nsdateToTime:timeSp formatStr:@"YYYY-MM-dd HH:mm"];
            self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
        }
            break;
        case DateViewType_YearMonthDay:
        {
            self.selectedDate = [HQHelper nsdateToTime:timeSp formatStr:@"YYYY-MM-dd"];
            self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
        }
            break;
        case DateViewType_YearMonth:
        {
            
            // 修改选中位置至最中间
            for (int i = 0; i < self.years.count; i ++) {
                NSString *obj = self.years[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.year]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            // 修改选中位置至最中间
            for (int i = 12*100; i < 12*101; i ++) {
                NSString *obj = self.months[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.month]) {
                    [self.pickerView selectRow:i inComponent:1 animated:NO];
                    break;
                }
            }
            
            self.selectedDate = [NSString stringWithFormat:@"%@-%@",self.year,self.month];
        }
            break;
        case DateViewType_Year:
        {
            // 修改选中位置至最中间
            for (int i = 0; i < self.years.count; i ++) {
                NSString *obj = self.years[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.year]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            self.selectedDate = [NSString stringWithFormat:@"%@",self.year];
            
        }
            break;
        case DateViewType_HourMinuteSecond:
        {
            
            // 修改选中位置至最中间
            for (int i = 24*100; i < 24*101; i ++) {
                NSString *obj = self.hours[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.hour]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            
            
            // 修改选中位置至最中间
            for (int i = 60*50; i < 60*51; i ++) {
                NSString *obj = self.minutes[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.minute]) {
                    [self.pickerView selectRow:i inComponent:1 animated:NO];
                    break;
                }
            }
            
            // 修改选中位置至最中间
            for (int i = 60*50; i < 60*51; i ++) {
                NSString *obj = self.seconds[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.second]) {
                    [self.pickerView selectRow:i inComponent:2 animated:NO];
                    break;
                }
            }
            self.selectedDate = [NSString stringWithFormat:@"%@:%@:%@",self.hour,self.minute,self.second];
        }
            break;
        case DateViewType_HourMinute:
        {
            
            // 修改选中位置至最中间
            for (int i = 24*100; i < 24*101; i ++) {
                NSString *obj = self.hours[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.hour]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            
            
            // 修改选中位置至最中间
            for (int i = 60*50; i < 60*51; i ++) {
                NSString *obj = self.minutes[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.minute]) {
                    [self.pickerView selectRow:i inComponent:1 animated:NO];
                    break;
                }
            }
            self.selectedDate = [NSString stringWithFormat:@"%@:%@",self.hour,self.minute];
        }
            break;
        case DateViewType_Hour:
        {
            
            // 修改选中位置至最中间
            for (int i = 24*100; i < 24*101; i ++) {
                NSString *obj = self.hours[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.hour]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            self.selectedDate = [NSString stringWithFormat:@"%@@",self.hour];
        }
            break;
            
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(dateView:selectDate:)]) {
        [self.delegate dateView:self selectDate:self.selectedDate];
    }
}



/** 监听DatePicker值改变 */
- (void)datePickerChange:(UIDatePicker *)datePicker{
    
    
    switch (self.type) {
        case DateViewType_YearMonthDayHourMinute:// 年月日时分
        {
            self.selectedDate = [HQHelper getYearMonthDayHourMiuthWithDate:self.datePicker.date];
        }
            break;
        case DateViewType_YearMonthDay:// 年月日
        {
            self.selectedDate = [HQHelper getYearMonthDayWithDate:self.datePicker.date];
        }
            break;
            
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(dateView:selectDate:)]) {
        [self.delegate dateView:self selectDate:self.selectedDate];
    }
    
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if (self.type == DateViewType_YearMonth) {
        return 2;
    }else if (self.type == DateViewType_Year) {
        return 1;
    }else if (self.type == DateViewType_HourMinuteSecond) {
        return 3;
    }else if (self.type == DateViewType_HourMinute) {
        return 2;
    }else {
        return 1;
    }
    
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (self.type == DateViewType_YearMonth) {
        if (component == 0) {
            return self.years.count;
        }else{
            return self.months.count;
        }
    }else if (self.type == DateViewType_Year) {
        return self.years.count;
    }else if (self.type == DateViewType_HourMinuteSecond) {
        if (component == 0) {
            return self.hours.count;
        }else if (component == 0) {
            return self.minutes.count;
        }else{
            return self.seconds.count;
        }
    }else if (self.type == DateViewType_HourMinute) {
        if (component == 0) {
            return self.hours.count;
        }else{
            return self.minutes.count;
        }
    }else {
        return self.hours.count;
    }
}

// 每个row中显示字符串
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (self.type == DateViewType_YearMonth) {
        
        if (component == 0) {
            return [NSString stringWithFormat:@"%@年",self.years[row]];
        }else{
            return [NSString stringWithFormat:@"%@月",self.months[row]];
        }
    }else if (self.type == DateViewType_Year) {
        
        return [NSString stringWithFormat:@"%@年",self.years[row]];
    }else if (self.type == DateViewType_HourMinuteSecond) {
        
        if (component == 0) {
            return [NSString stringWithFormat:@"%@",self.hours[row]];
        }else if (component == 1) {
            return [NSString stringWithFormat:@"%@",self.minutes[row]];
        }else{
            return [NSString stringWithFormat:@"%@",self.seconds[row]];
        }
    }else if (self.type == DateViewType_HourMinute) {
        
        if (component == 0) {
            return [NSString stringWithFormat:@"%@",self.hours[row]];
        }else{
            return [NSString stringWithFormat:@"%@",self.minutes[row]];
        }
    }else {
        
        return [NSString stringWithFormat:@"%@",self.hours[row]];
    }
}

// 每个滚动条row高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 34;
}

// 每个滚动条row宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 100;
    
}
// 滚动停止选中的row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.type == DateViewType_YearMonth) {
        
        if (component == 0) {
            self.year = self.years[row];
            
            
        }else{
            self.month = self.months[row];
            
            // 修改选中位置至最中间
            for (int i = 12*100; i < 12*101; i ++) {
                NSString *obj = self.months[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.month]) {
                    [self.pickerView selectRow:i inComponent:component animated:NO];
                    break;
                }
            }
        }
        
        // 确定字符串
        self.selectedDate = [NSString stringWithFormat:@"%@-%@",self.year, self.month];
        
    }else if (self.type == DateViewType_Year) {
        
        self.year = self.years[row];
        // 确定字符串
        self.selectedDate = [NSString stringWithFormat:@"%@",self.year];
        
    }else if (self.type == DateViewType_HourMinuteSecond) {
        
        if (component == 0) {
            self.hour = self.hours[row];
            
            // 修改选中位置至最中间
            for (int i = 24*100; i < 24*101; i ++) {
                NSString *obj = self.hours[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.hour]) {
                    [self.pickerView selectRow:i inComponent:component animated:NO];
                    break;
                }
            }
            
        }else if (component == 1) {
            
            self.minute = self.minutes[row];
            
            // 修改选中位置至最中间
            for (int i = 60*50; i < 60*51; i ++) {
                NSString *obj = self.minutes[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.minute]) {
                    [self.pickerView selectRow:i inComponent:component animated:NO];
                    break;
                }
            }
        }else{
            
            self.second = self.seconds[row];
            
            // 修改选中位置至最中间
            for (int i = 60*50; i < 60*51; i ++) {
                NSString *obj = self.seconds[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.second]) {
                    [self.pickerView selectRow:i inComponent:component animated:NO];
                    break;
                }
            }
        }
        
        // 确定字符串
        self.selectedDate = [NSString stringWithFormat:@"%@:%@:%@",self.hour, self.minute,self.second];
        
    }else if (self.type == DateViewType_HourMinute) {
        
        if (component == 0) {
            
            self.hour = self.hours[row];
            
            // 修改选中位置至最中间
            for (int i = 24*100; i < 24*101; i ++) {
                NSString *obj = self.hours[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.hour]) {
                    [self.pickerView selectRow:i inComponent:component animated:NO];
                    break;
                }
            }
        }else{
            
            self.minute = self.minutes[row];
            
            // 修改选中位置至最中间
            for (int i = 60*50; i < 60*51; i ++) {
                NSString *obj = self.minutes[i];
                HQLog(@"%@", obj);
                if ([obj isEqualToString:self.minute]) {
                    [self.pickerView selectRow:i inComponent:component animated:NO];
                    break;
                }
            }
        }
        // 确定字符串
        self.selectedDate = [NSString stringWithFormat:@"%@:%@",self.hour, self.minute];
    }else {
        
        self.hour = self.hours[row];
        
        // 修改选中位置至最中间
        for (int i = 24*100; i < 24*101; i ++) {
            NSString *obj = self.hours[i];
            HQLog(@"%@", obj);
            if ([obj isEqualToString:self.hour]) {
                [self.pickerView selectRow:i inComponent:component animated:NO];
                break;
            }
        }
        // 确定字符串
        self.selectedDate = [NSString stringWithFormat:@"%@",self.hour];
    }

    
    if ([self.delegate respondsToSelector:@selector(dateView:selectDate:)]) {
        [self.delegate dateView:self selectDate:self.selectedDate];
    }
}



/**
 * 时间选择
 */
+ (instancetype)selectDateViewWithFrame:(CGRect)frame
                                   type:(DateViewType)type
                                 timeSp:(long long)timeSp{
    
    TFDateView *dateView = [[TFDateView alloc] initWithFrame:frame withType:type];
    dateView.type = type;
    dateView.timeSp = timeSp;
    
    
    return dateView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
