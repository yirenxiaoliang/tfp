//
//  TFScheduleTimeView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFScheduleTimeView.h"
#import "HQBaseCell.h"
#import "NSDate+Calendar.h"
#import "NSDate+NSString.h"

@interface TFScheduleTimeView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *dayTableView;

/** times */
@property (nonatomic, strong) NSMutableArray *times;

/** selectTime */
@property (nonatomic, assign) long long selectTime;

/** timeCellWidth */
@property (nonatomic, assign) CGFloat timeCellWidth;

/** type */
@property (nonatomic, assign) NSInteger type;

/** timelabel */
@property (nonatomic, strong) UILabel *timelabel;
/** nowBtn */
@property (nonatomic, strong) UIButton *nowBtn;

@end

@implementation TFScheduleTimeView

-(NSMutableArray *)times{
    if (!_times) {
        _times = [NSMutableArray array];
        
    }
    return _times;
}

-(void)getDataSourceWithTimeSp:(long long)timeSp{
    
    self.selectTime = timeSp;
    CGFloat labelW = SCREEN_WIDTH/7;
    self.timeCellWidth = labelW;
    
    NSDate *selectDate = [NSDate dateWithTimeIntervalSince1970:timeSp/1000];
    
    NSDate *first = [selectDate firstDayOfTheWeek];// 本周第一天
    [self.times removeAllObjects];
    
    if (self.type == 0) {
        
        for (NSInteger i = -7; i < 14; i ++) {
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.day = i;
            
            NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:first options:0];
            [self.times addObject:date];
        }
        [_dayTableView reloadData];
        _dayTableView.contentOffset = CGPointMake(0, 7 * _timeCellWidth);
        
    }else{
        
        
        for (NSInteger i = -10; i < 11; i ++) {
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.month = i;
            
            NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:selectDate options:0];
            [self.times addObject:date];
        }
        [_dayTableView reloadData];
        _dayTableView.contentOffset = CGPointMake(0, 7 * _timeCellWidth);
        
    }
    
}


- (instancetype)initWithFrame:(CGRect)frame withSelectTime:(long long)selectTime withType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.selectTime = selectTime;
        if (selectTime == 0) {
            self.selectTime = [HQHelper getNowTimeSp];
        }
        [self setupChildView];
        [self getDataSourceWithTimeSp:selectTime];
    }
    return self;
}

- (void)setupChildView{
    
    
    self.backgroundColor = WhiteColor;
    
    if (self.type == 0) {
        
        NSArray *week = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        CGFloat labelW = SCREEN_WIDTH/week.count;
        self.timeCellWidth = labelW;
        
        for (NSInteger i = 0 ; i < week.count; i ++) {
            UILabel *label = [HQHelper labelWithFrame:(CGRect){labelW*i,10,labelW,Long(35)} text:week[i] textColor:ExtraLightBlackTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
            [self addSubview:label];
            if (i==0 || i == week.count-1) {
                label.textColor = FinishedTextColor;
            }
        }
    }else{

        UILabel *label = [HQHelper labelWithFrame:(CGRect){15,10,SCREEN_WIDTH-30,Long(35)} text:@"我的日程（月）" textColor:ExtraLightBlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        [self addSubview:label];
    }
    
    _dayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Long(35), SCREEN_WIDTH, Long(60)) style:UITableViewStylePlain];
    _dayTableView.dataSource = self;
    _dayTableView.delegate = self;
    _dayTableView.bounces = NO;
    _dayTableView.pagingEnabled = YES;
    _dayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dayTableView.showsHorizontalScrollIndicator = NO;
    _dayTableView.showsVerticalScrollIndicator = NO;
    _dayTableView.transform  = CGAffineTransformMakeRotation(-M_PI/2);
    _dayTableView.frame = CGRectMake(0, Long(35), SCREEN_WIDTH, Long(60));
    [self addSubview:_dayTableView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0,Long(90),SCREEN_WIDTH,Long(40)}];
    [self addSubview:bgView];
    bgView.backgroundColor = BackGroudColor;
    bgView.userInteractionEnabled = YES;
    
    if (self.type == 0) {
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,Long(40)} text:[HQHelper nsdateToTime:self.selectTime formatStr:@"yyyy-MM-dd"] textColor:LightBlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        [bgView addSubview:label];
        self.timelabel = label;
        
        UIButton *btn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-80,0,80,Long(40)} target:self action:@selector(btnClick)];
        [btn setTitle:@"今天" forState:UIControlStateNormal];
        [btn setTitleColor:HexAColor(0xff6f00, 1) forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        [bgView addSubview:btn];
        self.nowBtn = btn;
    }else{
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,Long(40)} text:[HQHelper nsdateToTime:self.selectTime formatStr:@"yyyy年MM月"] textColor:LightBlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        [bgView addSubview:label];
        self.timelabel = label;
//        HexAColor(0xff6f00, 1)
        UIButton *btn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-80,0,80,Long(40)} target:self action:@selector(btnClick)];
        
        [btn setTitle:@"本月" forState:UIControlStateNormal];
        [btn setTitleColor:HexAColor(0xff6f00, 1) forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        [bgView addSubview:btn];
        
        self.nowBtn = btn;
    }
}

- (void)btnClick{
    
    [self getDataSourceWithTimeSp:[HQHelper getNowTimeSp]];
    if (self.type == 0) {
        
        self.timelabel.text = [HQHelper nsdateToTime:self.selectTime formatStr:@"yyyy-MM-dd"];
    }else{
        self.timelabel.text = [HQHelper nsdateToTime:self.selectTime formatStr:@"yyyy年MM月"];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(scheduleTimeView:selectTimeSp:)]) {
        [self.delegate scheduleTimeView:self selectTimeSp:self.selectTime];
    }
    [self.dayTableView reloadData];
}


#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.times.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.width/7;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        UIButton *dayLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        dayLabel.userInteractionEnabled = NO;
        dayLabel.frame = CGRectMake((self.timeCellWidth-Long(35))/2, Long(Long(25)/2), Long(35), Long(35));
        dayLabel.tag = 1001;
        dayLabel.layer.cornerRadius  = dayLabel.width / 2;
        dayLabel.layer.masksToBounds = YES;
        [cell.contentView addSubview:dayLabel];
    }
    
    NSDate *time = self.times[indexPath.row];
    NSDate *selectDate = [NSDate dateWithTimeIntervalSince1970:self.selectTime/1000];
    UIButton *dayLabel = [cell.contentView viewWithTag:1001];
    
    if (self.type == 0) {
        
        [dayLabel setTitle:[time getday] forState:UIControlStateNormal];
        if (time.year == selectDate.year && time.month == selectDate.month && time.day == selectDate.day) {
            
            [dayLabel setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [dayLabel setTitleColor:WhiteColor forState:UIControlStateSelected];
        }else {
            [dayLabel setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [dayLabel setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        }
    }else{
        
        [dayLabel setTitle:[time getmonth] forState:UIControlStateNormal];
        if (time.year == selectDate.year && time.month == selectDate.month ) {
            
            [dayLabel setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [dayLabel setTitleColor:WhiteColor forState:UIControlStateSelected];
        }else {
            [dayLabel setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            [dayLabel setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self scrollViewWithPage:indexPath.row-1];
    NSDate *date = self.times[indexPath.row];
    [self getDataSourceWithTimeSp:[date getTimeSp]];
    if (self.type == 0) {
        
        self.timelabel.text = [HQHelper nsdateToTime:self.selectTime formatStr:@"yyyy-MM-dd"];
    }else{
        self.timelabel.text = [HQHelper nsdateToTime:self.selectTime formatStr:@"yyyy年MM月"];
        
    }
    if ([self.delegate respondsToSelector:@selector(scheduleTimeView:selectTimeSp:)]) {
        [self.delegate scheduleTimeView:self selectTimeSp:self.selectTime];
    }
    [tableView reloadData];
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
    
    CGFloat contentOffSetY = scrollView.contentOffset.y;
    CGFloat rowNum = contentOffSetY / SCREEN_WIDTH;
    HQLog(@"==========%f=========",rowNum);
    
    [self scrollViewWithPage:rowNum];
}



- (void)scrollViewWithPage:(NSInteger)page
{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _dayTableView.contentOffset = CGPointMake(0, page * SCREEN_WIDTH);
    } completion:^(BOOL finished) {
        
        NSDate *date = self.times[page*7];
        [self getDataSourceWithTimeSp:[date getTimeSp]];
        
        if ([self.delegate respondsToSelector:@selector(scheduleTimeView:selectTimeSp:)]) {
            [self.delegate scheduleTimeView:self selectTimeSp:self.selectTime];
        }
        
    }];
    if (self.type == 0) {
        
        self.timelabel.text = [HQHelper nsdateToTime:self.selectTime formatStr:@"yyyy-MM-dd"];
    }else{
        self.timelabel.text = [HQHelper nsdateToTime:self.selectTime formatStr:@"yyyy年MM月"];
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
