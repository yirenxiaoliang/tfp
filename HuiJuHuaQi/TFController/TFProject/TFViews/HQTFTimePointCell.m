//
//  HQTFTimePointCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTimePointCell.h"
#import "GFCalendarView.h"
//#import "HQCalenderView.h"
//#import "JBCalendarDate.h"


#define ItemMargin 15
#define ItemWidth ((SCREEN_WIDTH - 2 * ItemMargin)/7)

@interface HQTFTimePointCell ()

/** _calenderView */
@property (nonatomic, strong) GFCalendarView *calendar;


@end

@implementation HQTFTimePointCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChild];
    }
    return self;
}

- (void)setupChild{
    
    
//    _calenderView = [[HQCalenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Long(33*6)+44+18)];
//    _calenderView.futureTimeCanDidBool = YES;
//    UIView *sepa = [[UIView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(_calenderView.frame) - 0.5, SCREEN_WIDTH, 0.5}];
//    sepa.backgroundColor = CellSeparatorColor;
//    [_calenderView addSubview:sepa];
//    _calenderView.delegate = self;
//    [self addSubview:_calenderView];
    [self setupddd];
    
    self.startSelectDate = [NSDate date];
    
}
- (void)setupddd{
    CGFloat width = SCREEN_WIDTH - 20.0;
    CGPoint origin = CGPointMake(10.0, 20);
    
    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    calendar.selectDate = [NSDate date];
    calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        
    };
    calendar.selectDateAction = ^(NSDate *parameter) {
        
        HQLog(@"%@",parameter);
        if ([self.delegate respondsToSelector:@selector(timePointCellWithDate:)]) {
            [self.delegate timePointCellWithDate:parameter];
        }
    };
    self.calendar = calendar;
    [self.contentView addSubview:calendar];
}

-(void)setStartSelectDate:(NSDate *)startSelectDate{
    _startSelectDate = startSelectDate;
    self.calendar.selectDate = startSelectDate;
//    _calenderView.selectDate = startSelectDate;
}


//- (void)calenderView:(HQCalenderView *)calenderView selectedDate:(JBCalendarDate *)date isEnd:(BOOL)isEnd{
//    
//    if (!isEnd) {// 开始
//        
//        NSDate *select = [date nsDate];
//        
//        if ([self.delegate respondsToSelector:@selector(timePointCellWithDate:)]) {
//            [self.delegate timePointCellWithDate:select];
//        }
//        
//    }else{// 截止
//        
//        
//    }
//    
//}

+(instancetype)timePointCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"HQTFTimePointCell";
    HQTFTimePointCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFTimePointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
