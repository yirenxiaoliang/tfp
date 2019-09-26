//
//  HQTFEndTimeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFEndTimeController.h"
#import "HQTFTimePointCell.h"
#import "HQSelectTimeCell.h"
#import "HQSwitchCell.h"
#import "HQTFThreeLabelCell.h"
#import "HQTFRepeatSelectView.h"
#import "NSDate+NSString.h"

#define ItemMargin 15
#define ItemWidth ((SCREEN_WIDTH - 2 * ItemMargin)/7)

@interface HQTFEndTimeController ()<UITableViewDelegate,UITableViewDataSource,HQSwitchCellDelegate,HQTFTimePointCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** imageView */
@property (nonatomic, strong) UIImageView *imageView;

/** arr */
@property (nonatomic, strong) NSArray *timeArr;

@end

@implementation HQTFEndTimeController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;
    [self setupTableView];
    [self setupNavigation];
//    self.enablePanGesture = NO;
    
    if ([self.deadlineType isEqualToNumber:@2]) {
        
        self.timePeriod = @"";
    }else{
        self.timePeriod = [self caculeteTimeWithTimeSp:[HQHelper changeTimeToTimeSp:self.date formatStr:@"yyyy-MM-dd HH:mm"]];
    }
}
#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:ExtraLightBlackTextColor];
    
    self.navigationItem.title = @"截止时间";
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    NSMutableArray *times = [NSMutableArray array];
    [times addObject:self.deadlineType];
    [times addObject:self.date];
    [times addObject:self.deadlineUnit];
    
    if (self.timeAction) {
        self.timeAction(times);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (section == 1) {
//        return 2;
//    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        HQTFTimePointCell *cell = [HQTFTimePointCell timePointCellWithTableView:tableView];
        cell.delegate = self;
        if ([self.deadlineType isEqualToNumber:@2]) {
            cell.startSelectDate = [NSDate dateWithTimeIntervalSince1970:[HQHelper changeTimeToTimeSp:self.date formatStr:@"yyyy-MM-dd HH:mm"]/1000];
        }else{
            cell.startSelectDate = [NSDate date];
        }
        cell.layer.masksToBounds = YES;
        return cell;
    }else if (indexPath.section == 1){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"设置时间";
        cell.arrowShowState = YES;
//        cell.time.text = [self caculeteTimeWithDate:self.date];
        cell.time.text = self.timePeriod;
        cell.time.textColor = HexColor(0xf41c0d, 1);
        cell.bottomLine.hidden = YES;
        return  cell;
        
//        if (indexPath.row == 0) {
//            
//            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
//            cell.timeTitle.text = @"任务据今日";
//            cell.arrowShowState = YES;
//            cell.time.text = [self caculeteTimeWithDate:self.date];
//            cell.time.textColor = HexColor(0xf41c0d, 1);
//            cell.bottomLine.hidden = NO;
//            return  cell;
//        }
//        else{
//            
//            
//            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
//            cell.delegate = self;
//            cell.title.text = @"关闭倒计时";
//            cell.bottomLine.hidden = YES;
//            cell.switchBtn.on = self.on;
//            return cell;
//        }

    }else{
        
        HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
        cell.leftLabel.text = @"";
        cell.rightLabel.text = @"";
        cell.middleLabel.textColor = GreenColor;
        cell.middleLabel.text = @"清空截止时间";
        cell.bottomLine.hidden = YES;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (indexPath.section == 1) {
        
        NSString *word = @"天";
        NSString *num = @"1";
        if (self.timeArr && self.timeArr.count == 2) {
            word = self.timeArr[0];
            num = self.timeArr[1];
        }
        
        [HQTFRepeatSelectView selectTimeViewWithStartWithType:2 start:word end:num timeArray:^(NSArray *array) {
            
            
            if ([array[0] isEqualToString:@""] && [array[1] isEqualToString:@""]) {// 清空
                self.date = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd HH:mm"];
                self.deadlineType = @2;
                self.deadlineUnit = @0;
                self.timePeriod = @"";
                [self.tableView reloadData];
                return ;
            }
            
            // 0时间点 1分钟 2小时 3天 4周 5月 6年 7秒
            long long time;
            if ([array[0] isEqualToString:@"小时"]) {
                self.deadlineType = @1;
                self.deadlineUnit = @2;
                time = [array[1] integerValue] * 60 * 60 * 1000;
            }else if ([array[0] isEqualToString:@"天"]){
                self.deadlineType = @1;
                self.deadlineUnit = @3;
                time = [array[1] integerValue] * 24 * 60 * 60 * 1000;
            }else{
                self.deadlineType = @1;
                self.deadlineUnit = @1;
                time = [array[1] integerValue] * 60 * 1000;
            }
            
            self.date = [HQHelper nsdateToTime:[HQHelper getNowTimeSp]+time formatStr:@"yyyy-MM-dd HH:mm"];
            self.timePeriod = [NSString stringWithFormat:@"%@%@",array[1],array[0]];
            self.timeArr = array;
            [self.tableView reloadData];
            
        }];
    }
    
    if (indexPath.section == 2) {// 清空截止时间
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return  Long(ItemWidth*6)+44+18;
    }else if (indexPath.section == 1) {
        
        return 55;
    }else{
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }
    return 20;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - HQTFTimePointCellDelegate
-(void)timePointCellWithDate:(NSDate *)date{
    
    self.date = [NSString stringWithFormat:@"%@ 23:59",[HQHelper getYearMonthDayWithDate:date]];
    self.deadlineType = @2;
    self.deadlineUnit = @0;
    self.timePeriod = @"";
//    [self.tableView reloadData];
}

-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    self.on = switchButton.on;
}

/** 计算某个时间点与今天相差 */
- (NSString *)caculeteTimeWithDate:(NSDate *)date{
    
//    HQLog(@"今天：%@====self.date:%@",[HQHelper getYearMonthDayHourMiuthWithDate:[NSDate date]],[HQHelper getYearMonthDayHourMiuthWithDate:self.date]);
    // 多少秒
    NSInteger time = (NSInteger)[date timeIntervalSinceDate:[NSDate date]];
    
    time = ABS(time);
    
    CGFloat day = time/(24*60*60.0);
    
    NSInteger intDay = (NSInteger)day;
    
    CGFloat hour = (day - intDay)*24.0;
    
    NSInteger intHour = (NSInteger)hour;
    
    CGFloat minute = (hour - intHour)*60.0;
    
    NSInteger intMinute = (NSInteger)minute;
    
    NSString *str = [NSString stringWithFormat:@"%ld天  %ld小时  %ld分",intDay,intHour,intMinute];
    
    return str;
}

/** 计算某个时间点与今天相差 */
- (NSString *)caculeteTimeWithTimeSp:(long long)timeSp{
    
    //    HQLog(@"今天：%@====self.date:%@",[HQHelper getYearMonthDayHourMiuthWithDate:[NSDate date]],[HQHelper getYearMonthDayHourMiuthWithDate:self.date]);
    // 多少秒
    long long time = (timeSp-[HQHelper getNowTimeSp])/1000.0;
    
    time = ABS(time);
    
    CGFloat day = time/(24*60*60.0);
    
    NSInteger intDay = (NSInteger)day;
    
    CGFloat hour = (day - intDay)*24.0;
    
    NSInteger intHour = (NSInteger)hour;
    
    CGFloat minute = (hour - intHour)*60.0;
    
    NSInteger intMinute = (NSInteger)minute;
    
    NSString *str = [NSString stringWithFormat:@"%ld天  %ld小时  %ld分",intDay,intHour,intMinute];
    
    return str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
