//
//  HQSubCalenderView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/22.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSubCalenderView.h"
#import "HQCalenderItemView.h"

#import "JBCalendarDate.h"
#import "NSDate+Calendar.h"

#define TileCountInOneLine  7

#define MaxTileRowInUnit_Month    6

#define ItemMargin 15
#define ItemWidth ((SCREEN_WIDTH - 2 * ItemMargin)/TileCountInOneLine)

@interface HQSubCalenderView () <HQCalenderItemDelegate>

//  当前Unit中的TileViews
@property (nonatomic, retain) NSMutableArray *tileViewsInSelectedUnit;


@property (nonatomic, assign) dispatch_once_t onceToken;


@property (nonatomic, strong) NSMutableArray *calenderMutArr;


@property (nonatomic, strong) NSArray *grayPointArr;

@property (nonatomic, strong) NSArray *redPointArr;


@end


@implementation HQSubCalenderView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        self.tileViewsInSelectedUnit = [[NSMutableArray alloc] init];
        
//        _futureTimeCanDidBool = futureTimeCanDidBool;
        
        [self initViewWithSubCalenderView];
        
    }
    return self;
}



- (void)initViewWithSubCalenderView
{
  
    for (NSInteger i = 0; i < MaxTileRowInUnit_Month; i++) {
        
        for (NSInteger j = 0; j < TileCountInOneLine; j++) {
            
            HQCalenderItemView *tileView = [[HQCalenderItemView alloc] initWithFrame:CGRectMake(ItemMargin + Long(ItemWidth*j) , Long((40 + 2)*i), Long(ItemWidth), Long(40))];
//            tileView.futureTimeCanDidBool = _futureTimeCanDidBool;
            tileView.delegate = self;
            [self addSubview:tileView];
            [self.tileViewsInSelectedUnit addObject:tileView];
        }
    }
}

-(void)setIsEnd:(BOOL)isEnd{
    _isEnd = isEnd;
    
    [self refreshSubCalenderViewWithCalenderArr:_calenderMutArr startSelectDate:_startSelectDate endSelectDate:_endSelectDate];
}


- (void)refreshSubCalenderViewWithCalenderArr:(NSArray *)calenderArr
                              startSelectDate:(NSDate *)startSelectDate
                                endSelectDate:(NSDate *)endSelectDate
{
    
    _startSelectDate = startSelectDate;
    _endSelectDate = endSelectDate;
    
    for (HQCalenderItemView *tileView in self.tileViewsInSelectedUnit) {
        tileView.greenBgView.hidden = YES;
        tileView.dayLabel.backgroundColor = [UIColor clearColor];
    }
    
    
    _calenderMutArr = [NSMutableArray arrayWithArray:calenderArr];
    
    if (_calenderMutArr.count != 3) {
        return;
    }
    
    int monthTilesCount = 0;
    
    NSArray *daysInFinalWeekOfPreviousMonth  = _calenderMutArr[0];
    NSArray *daysInSelectedMonth             = _calenderMutArr[1];
    NSArray *daysInFirstWeekOfFollowingMonth = _calenderMutArr[2];
    
    
    
    if (daysInFinalWeekOfPreviousMonth && daysInFinalWeekOfPreviousMonth.count > 0) {
        for (JBCalendarDate *date in daysInFinalWeekOfPreviousMonth) {
            HQCalenderItemView *tileView = [self.tileViewsInSelectedUnit objectAtIndex:monthTilesCount];
            
            tileView.isEnd = self.isEnd;
            tileView.date = date;
            tileView.startSelectDate = startSelectDate;
            tileView.endSelectDate = endSelectDate;
            
            
            monthTilesCount++;
        }
    }
    
    
    
    if (daysInSelectedMonth && daysInSelectedMonth.count > 0) {
        for (JBCalendarDate *date in daysInSelectedMonth) {
            HQCalenderItemView *tileView = [self.tileViewsInSelectedUnit objectAtIndex:monthTilesCount];
            
            tileView.isEnd = self.isEnd;
            tileView.date = date;
            
            tileView.dayLabel.backgroundColor = [UIColor clearColor];
            tileView.dayLabel.font = FONT(16);
            if (date.day == [NSDate date].day  &&  date.month == [NSDate date].month  && date.year == [NSDate date].year)
            {
                tileView.dayLabel.font = FONT(14);
                tileView.dayLabel.text = @"今天";
                tileView.dayLabel.textColor = HexColor(0xbc96ab, 1);
                tileView.dayLabel.backgroundColor = HexColor(0xf2f2f2, 1);
            }
            
            
            tileView.startSelectDate = startSelectDate;
            tileView.endSelectDate = endSelectDate;
            
            
            [self.tileViewsInSelectedUnit addObject:tileView];
            
            monthTilesCount++;
        }
    }
    
    
    
    if (daysInFirstWeekOfFollowingMonth && daysInFirstWeekOfFollowingMonth.count > 0) {
        for (JBCalendarDate *date in daysInFirstWeekOfFollowingMonth) {
            HQCalenderItemView *tileView = [self.tileViewsInSelectedUnit objectAtIndex:monthTilesCount];
            
            tileView.isEnd = self.isEnd;
            tileView.date = date;
            tileView.startSelectDate = startSelectDate;
            tileView.endSelectDate = endSelectDate;
            
            monthTilesCount++;
        }
    }
    
}










- (void)setStartSelectDate:(NSDate *)startSelectDate
{
    
    _startSelectDate = startSelectDate;
    
    for (NSInteger i = 0; i < MaxTileRowInUnit_Month; i++) {
        
        for (NSInteger j = 0; j < TileCountInOneLine; j++) {
            
            HQCalenderItemView *tileView = self.tileViewsInSelectedUnit[i*j + j];
            tileView.isEnd = self.isEnd;
            tileView.startSelectDate = startSelectDate;
        }
    }

}

-(void)setEndSelectDate:(NSDate *)endSelectDate{
    _endSelectDate = endSelectDate;
    
    for (NSInteger i = 0; i < MaxTileRowInUnit_Month; i++) {
        
        for (NSInteger j = 0; j < TileCountInOneLine; j++) {
            
            HQCalenderItemView *tileView = self.tileViewsInSelectedUnit[i*j + j];
            tileView.isEnd = self.isEnd;
            tileView.endSelectDate = endSelectDate;
        }
    }

    
}

//- (void)setGrayPointArr:(NSArray *)grayPointArr
//{
//    _grayPointArr = grayPointArr;
//    
//    for (NSInteger i = 0; i < MaxTileRowInUnit_Month; i++) {
//        
//        for (NSInteger j = 0; j < TileCountInOneLine; j++) {
//            
//            HQCalenderItemView *tileView = self.tileViewsInSelectedUnit[i*j + j];
//            
//            
//            for (id dateLong in grayPointArr) {
//                
//                
//                NSDate *date = [NSDate dateWithTimeIntervalSince1970:(long)dateLong/1000];
//                
//                
//                
//                if (tileView.date.year == date.year
//                    &&   tileView.date.year == date.month
//                    &&   tileView.date.year  ==  date.day)
//                {
//                    tileView.grayPointView.hidden = NO;
//                    
//                }else {
//                    
//                    tileView.grayPointView.hidden = YES;
//                }
//
//            }
//            
//        }
//    }
//}




//- (void)setCalenderMutArr:(NSMutableArray *)calenderMutArr
//{
//    
//    int monthTilesCount = 0;
//    
//    _calenderMutArr = calenderMutArr;
//    
//    
//    if (_calenderMutArr.count != 3) {
//        return;
//    }
//    
//    
//    NSArray *daysInFinalWeekOfPreviousMonth  = _calenderMutArr[0];
//    NSArray *daysInSelectedMonth             = _calenderMutArr[1];
//    NSArray *daysInFirstWeekOfFollowingMonth = _calenderMutArr[2];
//    
//    
//    
//    if (daysInFinalWeekOfPreviousMonth && daysInFinalWeekOfPreviousMonth.count > 0) {
//        for (JBCalendarDate *date in daysInFinalWeekOfPreviousMonth) {
//            HQCalenderItemView *tileView = [self.tileViewsInSelectedUnit objectAtIndex:monthTilesCount];
//            tileView.previousUnit = YES;
//            tileView.nextUnit = NO;
//            
//            tileView.date       = date;
//            tileView.selectDate = self.selectDate;
//            
//            monthTilesCount++;
//        }
//    }
//    
//    
//    
//    if (daysInSelectedMonth && daysInSelectedMonth.count > 0) {
//        for (JBCalendarDate *date in daysInSelectedMonth) {
//            HQCalenderItemView *tileView = [self.tileViewsInSelectedUnit objectAtIndex:monthTilesCount];
//            tileView.previousUnit = NO;
//            tileView.nextUnit = NO;
//            
//            
//            tileView.redPointView.hidden = YES;
//            for (int i=0; i<_redPointArr.count; i++) {
//                
//                
//                NSDate *redDate = [NSDate dateWithTimeIntervalSince1970:[_redPointArr[i] integerValue]];
//                if (redDate.year == date.year
//                    &&  redDate.month == date.month
//                    &&  redDate.day == redDate.day)
//                {
//                    tileView.redPointView.hidden = NO;
//                }
//            }
//            
//            
////            tileView.redPointView.hidden = NO;
////            if ([date compare:self.selectedDate] == NSOrderedSame) {
////                tileView.selected = YES;
////                self.selectedUnitTileView = tileView;
////            } else {
////                tileView.selected = NO;
////            }
//            tileView.date       = date;
//            tileView.selectDate = self.selectDate;
////            tileView.dayLabel.text = [NSString stringWithFormat:@"%ld", date.day];
////            tileView.dayLabel.textColor = BlackTextColor;
//            
//            if (date.day == [NSDate date].day  &&  date.month == [NSDate date].month  && date.year == [NSDate date].year)
//            {
//                tileView.dayLabel.text = @"今天";
//                tileView.dayLabel.textColor = RedColor;
//                
////                tileView.redBgView.hidden = YES;
//            }
////            else {
////                tileView.redBgView.hidden = NO;
////            }
//            
//            [self.tileViewsInSelectedUnit addObject:tileView];
//            
//            monthTilesCount++;
//        }
//        
////        [self performSelector:@selector(reloadEvents)];
//    }
//    
//    
//    
//    if (daysInFirstWeekOfFollowingMonth && daysInFirstWeekOfFollowingMonth.count > 0) {
//        for (JBCalendarDate *date in daysInFirstWeekOfFollowingMonth) {
//            HQCalenderItemView *tileView = [self.tileViewsInSelectedUnit objectAtIndex:monthTilesCount];
//            tileView.previousUnit = NO;
//            tileView.nextUnit = YES;
//            tileView.selected = NO;
//            tileView.date     = date;
//            tileView.selectDate = self.selectDate;
////            tileView.dayLabel.text = [NSString stringWithFormat:@"%ld", date.day];
////            tileView.dayLabel.textColor = LightTextColor;
//            
//            monthTilesCount++;
//        }
//    }
//
//}




#pragma mark -
#pragma mark - JBUnitTileViewDelegate
//  点击了上一个Unit中的某个unitTileView
- (void)tappedInPreviousUnitOnUnitTileView:(HQCalenderItemView *)unitTileView
{
    if ([self.delegate respondsToSelector:@selector(subCalenderView:selectedOnPreviousUnitWithDate:)]) {
        [self.delegate subCalenderView:self selectedOnPreviousUnitWithDate:unitTileView.date];
    }
}

//  点击当前Unit中的某个unitTileView
- (void)tappedInSelectedUnitOnUnitTileView:(HQCalenderItemView *)unitTileView isEnd:(BOOL)isEnd
{
    
    
    if ([self.delegate respondsToSelector:@selector(subCalenderView:selectedDate:isEnd:)]) {
        [self.delegate subCalenderView:self selectedDate:unitTileView.date isEnd:isEnd];
    }
}

//  点击了下一个Unit中的某个unitTileView
- (void)tappedInNextUnitOnUnitTileView:(HQCalenderItemView *)unitTileView
{
    if ([self.delegate respondsToSelector:@selector(subCalenderView:selectedOnNextUnitWithDate:)]) {
        [self.delegate subCalenderView:self selectedOnNextUnitWithDate:unitTileView.date];
    }
}




@end
