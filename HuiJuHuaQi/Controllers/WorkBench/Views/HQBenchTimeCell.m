//
//  HQBenchTimeCell.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/9/2.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBenchTimeCell.h"
#import "HQBaseTableViewCell.h"
#import "NSDate+Calendar.h"
//#import "JBCalendarDate.h"




@interface HQBenchTimeCell () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>


@property (strong, nonatomic) UIView *centerView;


@property (strong, nonatomic) UIButton *todayBtn;


@property (strong, nonatomic) UILabel *timeLabel;


@property (strong, nonatomic) UITableView *dayTableView;


@property (strong, nonatomic) UIView *grayLineView;


@property (assign, nonatomic) CGFloat timeCellWidth;


@property (strong, nonatomic) NSMutableArray *daySps;


@end


@implementation HQBenchTimeCell


+ (HQBenchTimeCell *)benchTimeCellWithTableView:(UITableView *)tableView
{
    
    static NSString *indentifier = @"benchTimeCell";
    HQBenchTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        
        cell = [[HQBenchTimeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"voteOptionCell"];
    }
    
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _timeCellWidth = (SCREEN_WIDTH-24) / 7;
        
        
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, SCREEN_WIDTH-24, 100)];
        _centerView.backgroundColor = [UIColor whiteColor];

        
        
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_centerView.bounds
                                                      byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                            cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _centerView.layer.mask = shape;
        [self.contentView addSubview:_centerView];
        
        
        
        _todayBtn = [HQHelper buttonWithFrame:CGRectMake(0, 0, _timeCellWidth, 38)
                               normalImageStr:@"今"
                                 highImageStr:@"今"
                                       target:self
                                       action:@selector(didTodayAction)];
        [_centerView addSubview:_todayBtn];
        
        
        
        _timeLabel = [HQHelper labelWithFrame:CGRectMake(0, 10, _centerView.width, 15)
                                         text:@"dgadgfd"
                                    textColor:BlackTextColor
                                textAlignment:NSTextAlignmentCenter font:FONT(14)];
        [_centerView addSubview:_timeLabel];
        
        
        
        _dayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, _centerView.width, 36)
                                                     style:UITableViewStylePlain];
        _dayTableView.dataSource = self;
        _dayTableView.delegate = self;
        _dayTableView.bounces = NO;
        _dayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dayTableView.showsHorizontalScrollIndicator = NO;
        _dayTableView.showsVerticalScrollIndicator   = NO;
        _dayTableView.transform  = CGAffineTransformMakeRotation(-M_PI/2);
        _dayTableView.frame = CGRectMake(0, 35, _centerView.width, 36);
        [_centerView addSubview:_dayTableView];
        
        _grayLineView = [[UIView alloc] initWithFrame:CGRectMake(_timeCellWidth*3/2, _dayTableView.bottom, 0.5, _centerView.height - _dayTableView.height)];
        _grayLineView.backgroundColor = CellSeparatorColor;
        [_centerView addSubview:_grayLineView];
    }
    
    return self;
}




- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    self.lineView.hidden = YES;
    
    _centerView.height = self.height - 12;
    
    _grayLineView.height = _centerView.height - _dayTableView.bottom;
}



- (void)didTodayAction
{
    
    if ([self.delegate respondsToSelector:@selector(selectTimeSpWithTimeCellDelegate:)]) {
        
        [self.delegate selectTimeSpWithTimeCellDelegate:[HQHelper getNowTimeSp]];
    }
    
    [self refreshBenchTimeCellWithSelectTimeSp:[HQHelper getNowTimeSp]];
}


- (void)refreshBenchTimeCellWithSelectTimeSp:(long long)selectTimeSp
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:selectTimeSp/1000];
    
    NSString *timeStr = [HQHelper nsdateToTime:selectTimeSp formatStr:@"MM/dd"];
    
    NSString *weekDayStr = @"";
    switch ([date componentsOfDay].weekday) {
        case 1:
            weekDayStr = @"周日";
            break;
        case 2:
            weekDayStr = @"周一";
            break;
        case 3:
            weekDayStr = @"周二";
            break;
        case 4:
            weekDayStr = @"周三";
            break;
        case 5:
            weekDayStr = @"周四";
            break;
        case 6:
            weekDayStr = @"周五";
            break;
        case 7:
            weekDayStr = @"周六";
            break;
        default:
            break;
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@", timeStr, weekDayStr];
    
    
    
    _daySps = [NSMutableArray array];
    long long oneDaySp = 24 * 60 * 60 * 1000;
    for (int i=0; i<21; i++) {
        
        long long daySp = selectTimeSp - 8*oneDaySp + i*oneDaySp;
        [_daySps addObject:@(daySp)];
    }
    
    [_dayTableView reloadData];
    _dayTableView.contentOffset = CGPointMake(0, 7 * _timeCellWidth);
}



#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _daySps.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return _timeCellWidth;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HQBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
    
    if (cell == nil) {
        
        cell = [[HQBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"timeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        
        UILabel *dayLabel = [HQHelper labelWithFrame:CGRectMake((_timeCellWidth-24) / 2, 1, 24, 24)
                                                text:@""
                                           textColor:GrayTextColor
                                       textAlignment:NSTextAlignmentCenter
                                                font:FONT(14)];
        dayLabel.tag = 1001;
        dayLabel.layer.cornerRadius  = dayLabel.width / 2;
        dayLabel.layer.masksToBounds = YES;
        [cell.contentView addSubview:dayLabel];
    }
    
    UILabel *dayLabel = (UILabel *)[cell.contentView viewWithTag:1001];
    long long daySp = [_daySps[indexPath.row] longLongValue];
    dayLabel.text = [HQHelper nsdateToTime:daySp formatStr:@"dd"];
    if (indexPath.row == 8) {
        
        dayLabel.backgroundColor = GreenColor;
        dayLabel.textColor = WhiteColor;
    }else {
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.textColor = GrayTextColor;
    }
//    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self scrollViewWithPage:indexPath.row-1];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    if (decelerate == NO) {
        
        [self scrollViewPageAnimation:scrollView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self scrollViewPageAnimation:scrollView];
}


- (void)scrollViewPageAnimation:(UIScrollView *)scrollView
{
    
    
    NSLog(@"%f", scrollView.contentOffset.y);
    NSInteger contentOffSetY = scrollView.contentOffset.y;
    NSInteger rowNum = contentOffSetY / _timeCellWidth;
    if (contentOffSetY % (NSInteger)_timeCellWidth > _timeCellWidth / 2) {
        
        rowNum++;
    }
    
    [self scrollViewWithPage:rowNum];
}



- (void)scrollViewWithPage:(NSInteger)page
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        
        _dayTableView.contentOffset = CGPointMake(0, page * _timeCellWidth);
    } completion:^(BOOL finished) {
        
        
        long long timeSp = [_daySps[page+1] longLongValue];
        if ([self.delegate respondsToSelector:@selector(selectTimeSpWithTimeCellDelegate:)]) {
            
            [self.delegate selectTimeSpWithTimeCellDelegate:timeSp];
        }
        
        [self refreshBenchTimeCellWithSelectTimeSp:timeSp];
    }];
}





@end













