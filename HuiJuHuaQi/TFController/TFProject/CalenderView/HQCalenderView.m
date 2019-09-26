//
//  HQCalenderView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/22.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQCalenderView.h"
#import "HQSubCalenderView.h"

#import "HQCalendarLogic.h"
#import "NSDate+Calendar.h"

//#import "JBCalendarLogic.h"
#import "JBCalendarDate.h"

#define ItemMargin 15
#define ItemWidth ((SCREEN_WIDTH - 2 * ItemMargin)/7)


@interface HQCalenderView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, HQSubCalenderDelegate>


@property (nonatomic, strong) UITableView *tableview;

//当前选中月份
@property (nonatomic, strong) UILabel *showMonthLabel;

////当前选择的时间
//@property (nonatomic, strong) NSDate *selectedDate;


//  计算日期
//@property (nonatomic, strong) JBCalendarLogic *calendarLogic;

@property (nonatomic, strong) HQCalendarLogic *calendarLogic;


@property (nonatomic, strong) NSMutableArray *leftMutArr;


@property (nonatomic, strong) NSMutableArray *nowMutArr;


@property (nonatomic, strong) NSMutableArray *rightMutArr;


@property (nonatomic, strong) NSMutableArray *threeCalendarMutArr;

//@property (nonatomic, strong) HQSubCalenderView *leftSubCalenderView;
//
//@property (nonatomic, strong) HQSubCalenderView *nowSubCalenderView;
//
//@property (nonatomic, strong) HQSubCalenderView *rightSubCalenderView;

@end


@implementation HQCalenderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
    
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,206,44}];
        [self addSubview:view];
        view.centerX = SCREEN_WIDTH/2;
        
        UIButton *beforeMonthBtn = [HQHelper buttonWithFrame:CGRectMake(9, 0, 44, 44)
                                              normalImageStr:@"rowLeft_img"
                                                highImageStr:nil
                                                      target:self
                                                      action:@selector(beforeOrNextMonthWithBtn:)];
        beforeMonthBtn.tag = 100;
//        beforeMonthBtn.backgroundColor = [UIColor orangeColor];
        [view addSubview:beforeMonthBtn];
        
        

        
        
        NSString *showMonthStr = [NSString stringWithFormat:@"%d年%d月", (int)[NSDate date].year, (int)[NSDate date].month];
        _showMonthLabel = [HQHelper labelWithFrame:CGRectMake(beforeMonthBtn.right, 13, 100, 18)
                                                      text:showMonthStr
                                                 textColor:LightBlackTextColor
                                             textAlignment:NSTextAlignmentCenter
                                                      font:FONT(18)];
//        [_showMonthLabel sizeToFit];
        [view addSubview:_showMonthLabel];
        
        
        
        UIButton *nextMonthBtn = [HQHelper buttonWithFrame:CGRectMake(_showMonthLabel.right, 0, 44, 44)
                                            normalImageStr:@"rowRight_img"
                                              highImageStr:nil
                                                    target:self
                                                    action:@selector(beforeOrNextMonthWithBtn:)];
        nextMonthBtn.tag = 101;
//        nextMonthBtn.backgroundColor = [UIColor orangeColor];
        [view addSubview:nextMonthBtn];
        
        
        
        UIButton *todayBtn = [HQHelper buttonOfMainButtonWithFrame:CGRectMake(SCREEN_WIDTH-18-60 + 10, 0, 60, 44)
                                                             title:@"今天"
                                                       normalColor:[UIColor clearColor]
                                                         highColor:[UIColor clearColor]
                                                     disabledColor:[UIColor clearColor]
                                                        titleColor:BlackTextColor
                                                     disTitleColor:nil
                                                              font:FONT(15)
                                                            target:self
                                                            action:@selector(didTodayActionWithBtn:)];
//        todayBtn.tag = 101;
        [self addSubview:todayBtn];
        todayBtn.hidden = YES;
        
        
//        CGRectMake(9 + Long(51*j) , Long(33*i), Long(51), Long(33))
        UIView *weeksView = [[UIView alloc] initWithFrame:CGRectMake(18, 44, SCREEN_WIDTH-36, 18)];
        weeksView.backgroundColor = WhiteColor;
        [self addSubview:weeksView];
        
        
        for (int i=0; i<7; i++) {
            
            UILabel *weekdayLabel = [HQHelper labelWithFrame:CGRectMake(i*Long(ItemWidth), 3, Long(ItemWidth), 16)
                                                        text:nil
                                                   textColor:ExtraLightBlackTextColor
                                               textAlignment:NSTextAlignmentCenter
                                                        font:FONT(16)];
            [weeksView addSubview:weekdayLabel];
            
            if (i == 0 ||  i==6) {
                weekdayLabel.textColor = GreenColor;
            }
            
            
            switch (i) {
                    
                case 0:
                    weekdayLabel.text = @"日";
                    break;
                case 1:
                    weekdayLabel.text = @"一";
                    break;
                case 2:
                    weekdayLabel.text = @"二";
                    break;
                case 3:
                    weekdayLabel.text = @"三";
                    break;
                case 4:
                    weekdayLabel.text = @"四";
                    break;
                case 5:
                    weekdayLabel.text = @"五";
                    break;
                case 6:
                    weekdayLabel.text = @"六";
                    break;
                    
                default:
                    break;
            }
            
        }
        
        
        
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, weeksView.bottom, SCREEN_WIDTH, self.height) style:UITableViewStylePlain];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsHorizontalScrollIndicator = NO;
        _tableview.showsVerticalScrollIndicator   = NO;
        _tableview.transform  = CGAffineTransformMakeRotation(-M_PI/2);
        _tableview.frame = CGRectMake(0, weeksView.bottom + 10, SCREEN_WIDTH, self.height-weeksView.bottom + 20);
        _tableview.delegate   = self;
        _tableview.dataSource = self;
        
        _tableview.pagingEnabled = YES;
        _tableview.bounces = NO;
        [self addSubview:_tableview];
        
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableview.bottom-0.5, SCREEN_WIDTH, 0.5)];
//        lineView.backgroundColor = CellSeparatorColor;
//        [self addSubview:lineView];
        
        
        
        self.calendarLogic = [HQCalendarLogic defaultCalendarLogic];
        
        _threeCalendarMutArr = [[NSMutableArray alloc] init];
        _leftMutArr  = [[NSMutableArray alloc] init];
        _nowMutArr   = [[NSMutableArray alloc] init];
        _rightMutArr = [[NSMutableArray alloc] init];
        
        
        self.startSelectDate = [NSDate date];
        self.selectDate = self.startSelectDate;
        
        [self getCalendarDate:self.selectDate];

        _tableview.contentOffset = CGPointMake(0, SCREEN_WIDTH);
    }
    return self;
}



- (void)getCalendarDate:(NSDate *)date
{
    
    _showMonthLabel.text = [NSString stringWithFormat:@"%d年%d月", (int)date.year, (int)date.month];

    [_threeCalendarMutArr removeAllObjects];
    
    NSArray *arr1 = [self.calendarLogic getSomeOneMonthMessage:[date firstDayOfThePreviousMonth]];
    
    NSArray *arr2 = [self.calendarLogic getSomeOneMonthMessage:[date firstDayOfTheMonth]];
    
    NSArray *arr3= [self.calendarLogic getSomeOneMonthMessage:[date firstDayOfTheFollowingMonth]];
    
    [_threeCalendarMutArr addObject:arr1];
    [_threeCalendarMutArr addObject:arr2];
    [_threeCalendarMutArr addObject:arr3];
    
    [_tableview reloadData];
    
//    HQLog(@"%@ %@  %@", arr1 , arr2, arr3);
}



//- (void)didTodayActionWithBtn:(UIButton *)button
//{
//
//    _selectDate = [NSDate date];
//    
//    [self getCalendarDate:_selectDate];
//    _tableview.contentOffset = CGPointMake(0, SCREEN_WIDTH);
//    
//    
//    
//    JBCalendarDate *date = [JBCalendarDate dateFromNSDate:_selectDate];
//    if ([self.delegate respondsToSelector:@selector(calenderView:scrollActionWithDate:)]) {
//        
//        [self.delegate calenderView:self scrollActionWithDate:date];
//    }
//
//
//    [_tableview reloadData];
//}


//上一个月或下一个月
- (void)beforeOrNextMonthWithBtn:(UIButton *)button
{
    
    CGPoint newOffset = _tableview.contentOffset;
    if (button.tag == 100) { //上个月
        newOffset.y = 0;
        
    } else { //下个月
        newOffset.y = 2 * SCREEN_WIDTH;
    }

    [_tableview setContentOffset:newOffset animated:YES];
    
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:_tableview afterDelay:0.35];
}



- (void)setSelectDate:(NSDate *)selectDate
{
    _selectDate = selectDate;
    
    [_tableview reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //往前一个月
    if (scrollView.contentOffset.y == 0) {
        
        
        _selectDate = [_selectDate firstDayOfThePreviousMonth];
        
    //往后一个月
    }else if (scrollView.contentOffset.y == 2 * SCREEN_WIDTH) {
    
        _selectDate = [_selectDate firstDayOfTheFollowingMonth];
    }
    
    
    [self getCalendarDate:_selectDate];
    _tableview.contentOffset = CGPointMake(0, SCREEN_WIDTH);
    
    
    
    JBCalendarDate *date = [JBCalendarDate dateFromNSDate:_selectDate];
    if ([self.delegate respondsToSelector:@selector(calenderView:scrollActionWithDate:)]) {
        
        [self.delegate calenderView:self scrollActionWithDate:date];
    }
    
}


- (void)setNowMutArr:(NSMutableArray *)nowMutArr
{
    _nowMutArr = nowMutArr;
    
    [_tableview reloadData];
}

-(void)setIsEnd:(BOOL)isEnd{
    _isEnd = isEnd;
    
    [_tableview reloadData];
}


#pragma mark - UITableViewDelegate  And  DataSorce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return _threeCalendarMutArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"calender"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"calender"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        
        HQSubCalenderView *nowSubCalenderView = [[HQSubCalenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _tableview.height)];
        
        nowSubCalenderView.delegate = self;
        nowSubCalenderView.tag = 100;
        [cell.contentView addSubview:nowSubCalenderView];
    }
    
    HQSubCalenderView *nowSubCalenderView = (HQSubCalenderView *)[cell.contentView viewWithTag:100];
    [nowSubCalenderView refreshSubCalenderViewWithCalenderArr:_threeCalendarMutArr[indexPath.row]
                                                   startSelectDate:self.startSelectDate endSelectDate:self.endSelectDate];

    
    nowSubCalenderView.isEnd = self.isEnd;
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_WIDTH;
}



#pragma mark -
#pragma mark - JBUnitGridViewDelegate
/**************************************************************
 *@Description:选中了当前Unit的上一个Unit中的时间点
 *@Params:
 *  subCalenderView:当前subCalenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)subCalenderView:(HQSubCalenderView *)subCalenderView selectedOnPreviousUnitWithDate:(JBCalendarDate *)date
{
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.tag = 100;
//    [self beforeOrNextMonthWithBtn:button];
    
    
    if ([self.delegate respondsToSelector:@selector(calenderView:selectedOnPreviousUnitWithDate:)]) {
        
        [self.delegate calenderView:self selectedOnPreviousUnitWithDate:date];
    }
}

/**************************************************************
 *@Description:选中了当前Unit中的时间点
 *@Params:
 *  subCalenderView:当前subCalenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)subCalenderView:(HQSubCalenderView *)subCalenderView selectedDate:(JBCalendarDate *)date isEnd:(BOOL)isEnd
{
    
    if ([self.delegate respondsToSelector:@selector(calenderView:selectedDate:isEnd:)]) {
        
        [self.delegate calenderView:self selectedDate:date isEnd:isEnd];
    }
    
    if (!isEnd) {
        self.startSelectDate = [date nsDate];
    }else{
        
        self.endSelectDate = [date nsDate];
    }
    
}

-(void)setStartSelectDate:(NSDate *)startSelectDate{
    
    _startSelectDate = startSelectDate;
    
    [self getCalendarDate:startSelectDate];
    
    [_tableview reloadData];
    
}

-(void)setEndSelectDate:(NSDate *)endSelectDate{
    
    _endSelectDate = endSelectDate;
    
    [_tableview reloadData];
}

/**************************************************************
 *@Description:选中了当前Unit的下一个Unit中的时间点
 *@Params:
 *  subCalenderView:当前subCalenderView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)subCalenderView:(HQSubCalenderView *)subCalenderView selectedOnNextUnitWithDate:(JBCalendarDate *)date
{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.tag = 101;
//    [self beforeOrNextMonthWithBtn:button];
    
    if ([self.delegate respondsToSelector:@selector(calenderView:selectedOnNextUnitWithDate:)]) {
        
        [self.delegate calenderView:self selectedOnNextUnitWithDate:date];
    }
    
}





@end
