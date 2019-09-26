//
//  HQTFDateTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFDateTableView.h"
#import "HQTFDateCell.h"
#import "NSDate+Calendar.h"
#import "NSDate+NSString.h"

@interface HQTFDateTableView ()<UITableViewDelegate,UITableViewDataSource>

/** 日期数组 */
@property (nonatomic, strong) NSMutableArray *dates;
/** 前一个月天数 */
@property (nonatomic, assign) NSUInteger preDays;
/** 本月天数 */
@property (nonatomic, assign) NSUInteger nowDays;
/** 下个月天数 */
@property (nonatomic, assign) NSUInteger lastDays;
/** 选中的日期 */
@property (nonatomic, strong) NSIndexPath *selectedIndex;
/** 滚动到的日期 */
@property (nonatomic, strong) NSIndexPath *scrolledIndex;
/** 当前偏移量 */
@property (nonatomic, assign) CGFloat currentOffset;
/** clicked */
@property (nonatomic, assign) BOOL clicked;

@end

@implementation HQTFDateTableView

-(NSArray *)dates{
    if (!_dates) {
        _dates = [self caculate];
//        _dates = [NSMutableArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    }
    return _dates;
}

- (NSMutableArray *)caculate{
    
    NSDate *now = [NSDate date];
    NSUInteger nowDays = [now numberOfDaysInMonth];
    self.nowDays = nowDays;
    // 上个月
    NSDate *pre = [now previousMonth];
    NSUInteger preDays = [pre numberOfDaysInMonth];
    self.preDays = preDays;
    // 下个月
    NSDate *last = [now followingMonth];
    NSUInteger lastDays = [last numberOfDaysInMonth];
    self.lastDays = lastDays;
    
    
    NSString *nowStr = [now getHorizitalYearMonth];
    NSString *preStr = [pre getHorizitalYearMonth];
    NSString *lastStr = [last getHorizitalYearMonth];
    
    
    NSMutableArray *dates = [NSMutableArray array];
    
    for (NSInteger i = 1; i <= preDays; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"%@/%02ld 12:12",preStr,i];
        long long dateSp = [NSDate changeTimeToTimeSp:str formatStr:@"yyyy/MM/dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateSp];
        
        [dates addObject:date];
    }
    
    for (NSInteger i = 1; i <= nowDays; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"%@/%02ld 12:12",nowStr,i];
        long long dateSp = [NSDate changeTimeToTimeSp:str formatStr:@"yyyy/MM/dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateSp];
        
        [dates addObject:date];
    }
    
    
    for (NSInteger i = 1; i <= lastDays; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"%@/%02ld 12:12",lastStr,i];
        long long dateSp = [NSDate changeTimeToTimeSp:str formatStr:@"yyyy/MM/dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateSp];
        
        [dates addObject:date];
    }
    
    NSInteger num = dates.count % 7;
    
    dates = [NSMutableArray arrayWithArray:[dates subarrayWithRange:(NSRange){0,dates.count-num}]];
    
    HQLog(@"%ld",dates.count);
    
    return dates;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupChild];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupChild];
}

- (void)setupChild{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)
                                                 style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator   = NO;
    tableView.pagingEnabled = YES;
    tableView.transform  = CGAffineTransformMakeRotation(-M_PI/2);
    [self addSubview:tableView];
    tableView.frame = CGRectMake(0, 0, self.width, 60);
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    
    self.scrolledIndex = [self caculateIndexPathWithDate:[NSDate date]];
    self.selectedIndex = [NSIndexPath indexPathForRow:self.scrolledIndex.row + 3 inSection:0];
    [self scrollToIndexPath:self.scrolledIndex animated:NO];
}

/** 计算Date所在indexPath */
- (NSIndexPath *)caculateIndexPathWithDate:(NSDate *)date{
    
    NSInteger index = 0;
    NSInteger i;
    HQLog(@"date 年：%ld  月：%ld  日：%ld",date.year,date.month,date.day);
    for (i = 0; i < self.dates.count; i ++) {
        
        NSDate *time = self.dates[i];
        HQLog(@"time 年：%ld  月：%ld  日：%ld",time.year,time.month,time.day);
        
        if (time.year == date.year && time.month == date.month && time.day == date.day) {
            
            index = i;
            break;
        }
    }
    
    if (i < self.dates.count) {
        if (index < 3) {
            
            return [NSIndexPath indexPathForRow:0 inSection:0];
        }else if (index > self.dates.count - 4){
            
            return [NSIndexPath indexPathForRow:self.dates.count -1-7 inSection:0];
        }else{
            return [NSIndexPath indexPathForRow:index-3 inSection:0];
        }
        
    }else{// 没找到
       
        NSDate *first = self.dates[0];
        
        if (first.timeIntervalSince1970 > date.timeIntervalSince1970) {
            return [NSIndexPath indexPathForRow:0 inSection:0];
        }else{
            return [NSIndexPath indexPathForRow:self.dates.count -1-7 inSection:0];
        }
    }
}

/** 滚动到某行 */
- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{
    
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    
    self.currentOffset = self.tableView.contentOffset.y;
}

-(void)setSelectedDate:(NSDate *)selectedDate{
    
    _selectedDate = selectedDate;
    
    self.clicked = NO;
    self.scrolledIndex = [self caculateIndexPathWithDate:selectedDate];
    self.selectedIndex = [NSIndexPath indexPathForRow:self.scrolledIndex.row + 3 inSection:0];
    [self scrollToIndexPath:self.scrolledIndex animated:NO];
    [self.tableView reloadData];
}

#pragma mark - tableView 数据源及代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dates.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQTFDateCell *cell = [HQTFDateCell dateCellWithTableView:tableView];
    cell.date = _dates[indexPath.row];
    if (self.selectedIndex.row == indexPath.row) {
        
        cell.redSelected = YES;
    }else{
        
        cell.redSelected = NO;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_WIDTH/7;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.selectedIndex.row) {
        return;
    }
    
    self.clicked = YES;
    self.selectedIndex = indexPath;
    
    [tableView reloadData];
    
    if (indexPath.row>2 && indexPath.row < self.dates.count-4) {
        
        self.scrolledIndex = [NSIndexPath indexPathForRow:indexPath.row - 3 inSection:0];
        [self scrollToIndexPath:self.scrolledIndex animated:YES];
    }
    
    if ([self.delegate respondsToSelector:@selector(dateTableViewWithSelectedDate:)]) {
        
        [self.delegate dateTableViewWithSelectedDate:self.dates[indexPath.row]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    HQLog(@"***%f****%f*******",self.currentOffset,scrollView.contentOffset.y);
    
    self.clicked = NO;
    if (self.currentOffset <= scrollView.contentOffset.y) {
        NSInteger index = self.scrolledIndex.row + 7;
        if (index>self.dates.count - 1) {
            index = self.dates.count - 1;
        }
        NSDate *date = self.dates[index];
        
        self.scrolledIndex = [self caculateIndexPathWithDate:date];
    }else{
        
        NSInteger index = self.scrolledIndex.row - 7;
        if (index<0) {
            index = 0;
        }
        NSDate *date = self.dates[index];
        
        self.scrolledIndex = [self caculateIndexPathWithDate:date];
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (!self.clicked) {
        
        [self scrollToIndexPath:self.scrolledIndex animated:NO];
        
    }
}




-(void)layoutSubviews{
    [super layoutSubviews];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
