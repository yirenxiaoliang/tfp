//
//  HQCalenderItemView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/22.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQCalenderItemView.h"
#import "NSDate+Calendar.h"

#define ItemMargin 15
#define ItemWidth ((SCREEN_WIDTH - 2 * ItemMargin)/7)
@implementation HQCalenderItemView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.backgroundColor = [UIColor cyanColor];
        
        self.greenBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Long(ItemWidth), Long(40))];
        self.greenBgView.backgroundColor = GreenColor;
//        self.greenBgView.layer.cornerRadius  = self.greenBgView.width/2;
//        self.greenBgView.layer.masksToBounds = YES;
        self.greenBgView.center = CGPointMake(self.width/2, self.height/2);
        self.greenBgView.hidden = YES;
        [self addSubview:self.greenBgView];
        
        
        
        self.dayLabel = [HQHelper labelWithFrame:CGRectMake(0, 0, Long(ItemWidth), Long(40))
                                            text:nil
                                       textColor:LightBlackTextColor
                                   textAlignment:NSTextAlignmentCenter
                                            font:FONT(16)];
        self.dayLabel.center = self.greenBgView.center;
        [self addSubview:self.dayLabel];
        
        
        
        
//        self.grayPointView = [[UIView alloc] initWithFrame:CGRectMake(self.greenBgView.right-3,
//                                                                     self.greenBgView.top-3,
//                                                                     6,
//                                                                     6)];
//        self.grayPointView.backgroundColor = GrayTextColor;
//        self.grayPointView.layer.cornerRadius  = self.grayPointView.width / 2;
//        self.grayPointView.layer.masksToBounds = YES;
//        self.grayPointView.hidden = YES;
//        self.grayPointView.centerX = self.width / 2;
//        self.grayPointView.top = self.dayLabel.bottom;
//        [self addSubview:self.grayPointView];
        
        

        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorForTapGR:)];
        [self addGestureRecognizer:tapGR];
        
    }
    return self;
}



//- (void)setPreviousUnit:(BOOL)previousUnit
//{
//    _previousUnit = previousUnit;
//    
//    if (_previousUnit | _nextUnit) {
//        
//        self.dayLabel.textColor = NOSelectDateColor;
//    }else {
//        
//        self.dayLabel.textColor = CurrentMonthDateColor;
//    }
//}


//- (void)setNextUnit:(BOOL)nextUnit
//{
//    _nextUnit = nextUnit;
//    
//    if (_previousUnit | _nextUnit) {
//        
//        self.dayLabel.textColor = NOSelectDateColor;
//    }else {
//        
//        self.dayLabel.textColor = CurrentMonthDateColor;
//    }
//}


- (void)setDate:(JBCalendarDate *)date
{
    _date = date;
    
//    self.selected = NO;
    
    self.dayLabel.text = [NSString stringWithFormat:@"%d", (int)date.day];
}


//- (void)setSelectDate:(NSDate *)selectDate
//{
//    _selectDate = selectDate;
//    
//    self.greenBgView.hidden = YES;
//    
//    
//    if (_previousUnit | _nextUnit) {
//        
//        return;
//    }
//    
//    
//    if (_selectDate.year == _date.year
//        &&   _selectDate.month == _date.month
//        &&   _selectDate.day  ==  _date.day)
//    {
//        self.greenBgView.hidden = NO;
//        self.dayLabel.textColor = WhiteColor;
//        self.grayPointView.hidden = YES;
//    }
//    
//    
//    if ([self futureTimeState] && _futureTimeCanDidBool == NO) {
//    
//        self.greenBgView.hidden = YES;
//        self.dayLabel.textColor = NOSelectDateColor;
//    }
//}


-(void)setStartSelectDate:(NSDate *)startSelectDate{
    
    
    _startSelectDate = startSelectDate;
    
    if (self.isEnd) {
        return;
    }
    
    
    // 今天之前
    if ([[NSDate date] timeIntervalSince1970] > [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"%ld-%ld-%ld 23:59:59", _date.year,_date.month,_date.day]]) {
        
        self.dayLabel.textColor = NOSelectDateColor;
    }else{
        
        self.dayLabel.textColor = CurrentMonthDateColor;
    }
    
    
    
    
    if ([NSDate date].year == _date.year
        &&   [NSDate date].month == _date.month
        &&   [NSDate date].day  ==  _date.day)
    {
        self.dayLabel.backgroundColor = HexColor(0xf2f2f2, 1);
        self.greenBgView.hidden = YES;
        self.dayLabel.textColor = CurrentMonthDateColor;
        
    }
    
    if (startSelectDate.year == _date.year
        &&   startSelectDate.month == _date.month
        &&   startSelectDate.day  ==  _date.day)
    {
        self.greenBgView.hidden = NO;
        self.dayLabel.textColor = WhiteColor;
        self.dayLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    if (self.endSelectDate.year == _date.year
        &&   self.endSelectDate.month == _date.month
        &&   self.endSelectDate.day  ==  _date.day)
    {
        self.greenBgView.hidden = NO;
        self.dayLabel.textColor = WhiteColor;
        self.dayLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    if (self.startSelectDate && self.endSelectDate) {
        
        if (([[_date nsDate] timeIntervalSince1970] >= [self.startSelectDate timeIntervalSince1970]) && ([[_date nsDate] timeIntervalSince1970] <= [self.endSelectDate timeIntervalSince1970])) {
            
            self.dayLabel.backgroundColor = [UIColor clearColor];
            self.greenBgView.hidden = NO;
            self.dayLabel.textColor = WhiteColor;
        }
        
    }
    
}

-(void)setEndSelectDate:(NSDate *)endSelectDate{
    
    _endSelectDate = endSelectDate;
    
    if (!self.isEnd) {
        return;
    }
    if ([NSDate date].year == _date.year
        &&   [NSDate date].month == _date.month
        &&   [NSDate date].day  ==  _date.day)
    {
        self.dayLabel.backgroundColor = HexColor(0xf2f2f2, 1);
        self.greenBgView.hidden = YES;
        self.dayLabel.textColor = CurrentMonthDateColor;
        
    }
    
    if (self.startSelectDate.year == _date.year
        &&   self.startSelectDate.month == _date.month
        &&   self.startSelectDate.day  ==  _date.day)
    {
        self.greenBgView.hidden = NO;
        self.dayLabel.textColor = WhiteColor;
        self.dayLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    if (endSelectDate.year == _date.year
        && endSelectDate.month == _date.month
        && endSelectDate.day  ==  _date.day)
    {
        self.greenBgView.hidden = NO;
        self.dayLabel.textColor = WhiteColor;
        self.dayLabel.backgroundColor = [UIColor clearColor];
        
    }

    
    if (self.startSelectDate && self.endSelectDate) {
        // 开始时间和截止时间都存在时，选中两者之间的
        if (([HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"%ld-%ld-%ld 23:59:59", _date.year,_date.month,_date.day]] >= [self.startSelectDate timeIntervalSince1970]) && ([[_date nsDate] timeIntervalSince1970] <= [self.endSelectDate timeIntervalSince1970])) {
            
            self.dayLabel.backgroundColor = [UIColor clearColor];
            self.greenBgView.hidden = NO;
            self.dayLabel.textColor = WhiteColor;
        }else{
            // 截止时间之后
            if (([[_date nsDate] timeIntervalSince1970] > [self.endSelectDate timeIntervalSince1970])) {
                
                self.greenBgView.hidden = YES;
                self.dayLabel.textColor = CurrentMonthDateColor;
            }else{
                // 今天至开始时间
                if (([[_date nsDate] timeIntervalSince1970] < [self.startSelectDate timeIntervalSince1970]) && ([HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"%ld-%ld-%ld 23:59:59", _date.year,_date.month,_date.day]] >= [[NSDate date] timeIntervalSince1970])) {
                    
                    
                    self.dayLabel.textColor = CurrentMonthDateColor;
                }else{// 今天之前时间
                    
                    self.dayLabel.textColor = NOSelectDateColor;
                }
                
                
            }
            
        }
        
    }

    
}




- (void)selectorForTapGR:(UITapGestureRecognizer *)tapGR
{
    
    // 今天之前不可选
    if ([[NSDate date] timeIntervalSince1970] > [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"%ld-%ld-%ld 23:59:59", _date.year,_date.month,_date.day]]) {
        
        [MBProgressHUD showError:@"今天之前不可选" toView:KeyWindow];
        return;
        
    }else{
        
        if (!self.isEnd) {// 选开始时间
            
            if (self.endSelectDate) {// 存在结束时间
                
                
                if ([[_date nsDate] timeIntervalSince1970] >= [self.endSelectDate timeIntervalSince1970]) {// 开始时间大于截止时间
                    [MBProgressHUD showError:@"开始时间应小于截止时间" toView:KeyWindow];
                    return;
                }
                
                if ([self.delegate respondsToSelector:@selector(tappedInSelectedUnitOnUnitTileView:isEnd:)]) {
                    [self.delegate tappedInSelectedUnitOnUnitTileView:self isEnd:self.isEnd];
                }
                
            }else{// 不存在结束时间
                
              
                if ([self.delegate respondsToSelector:@selector(tappedInSelectedUnitOnUnitTileView:isEnd:)]) {
                    [self.delegate tappedInSelectedUnitOnUnitTileView:self isEnd:self.isEnd];
                }
            }
            
            
        }else{// 选截止时间
            
            
            // 截止时间跟开始时间一样不可选
            if (_date.year == self.startSelectDate.year && _date.month == self.startSelectDate.month && _date.day == self.startSelectDate.day) {
                [MBProgressHUD showError:@"开始时间不能与截止时间在同一天" toView:KeyWindow];
                
                return;
            }
            
            if (!self.endSelectDate) {
                
                
                if ([self.delegate respondsToSelector:@selector(tappedInSelectedUnitOnUnitTileView:isEnd:)]) {
                    [self.delegate tappedInSelectedUnitOnUnitTileView:self isEnd:self.isEnd];
                }
            }else{
                
                
                if ([self.startSelectDate timeIntervalSince1970] >= [[_date nsDate] timeIntervalSince1970]) {// 开始时间大于截止时间
                    [MBProgressHUD showError:@"开始时间大于截止时间" toView:KeyWindow];
                    return;
                }
                
                if ([self.delegate respondsToSelector:@selector(tappedInSelectedUnitOnUnitTileView:isEnd:)]) {
                    [self.delegate tappedInSelectedUnitOnUnitTileView:self isEnd:self.isEnd];
                }
            }
            
            
        }
        
    }

    
    
    
//    if (self.previousUnit == YES) {   //点的上一个月
//        
//        if ([self.delegate respondsToSelector:@selector(tappedInPreviousUnitOnUnitTileView:)]) {
//            [self.delegate tappedInPreviousUnitOnUnitTileView:self];
//        }
//        
//    }else if (self.nextUnit == YES) {   //点的下一个月
//        
//        if ([self.delegate respondsToSelector:@selector(tappedInNextUnitOnUnitTileView:)]) {
//            [self.delegate tappedInNextUnitOnUnitTileView:self];
//        }
//    
//        
//        
//    }else {  //点的本月
//        
//        
//        if ([self futureTimeState]) {
//            
//            if (_futureTimeCanDidBool == NO) {
//                return;
//            }
//        }
//        
//        
//        if (!self.selected) {
//            if ([self.delegate respondsToSelector:@selector(tappedInSelectedUnitOnUnitTileView:)]) {
//                [self.delegate tappedInSelectedUnitOnUnitTileView:self];
//            }
//        }
//    }
}


//是否为未来日期
//- (BOOL)futureTimeState
//{
//    NSDate *nowDate = [NSDate date];
//    
//    
//    if (nowDate.year > _date.year) {
//        
//        return NO;
//    }
//    
//    
//    if (nowDate.year == _date.year
//        &&   nowDate.month > _date.month)
//    {
//        return NO;
//    }
//    
//    
//    if (nowDate.year == _date.year
//        &&   nowDate.month == _date.month
//        &&   nowDate.day  >=  _date.day)
//    {
//        return NO;
//    }
//    
//    
//    return YES;
//}



@end
