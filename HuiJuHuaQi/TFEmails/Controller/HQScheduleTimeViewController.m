//
//  HQScheduleTimeViewController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQScheduleTimeViewController.h"
#import "HQTFTimePointCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFThreeLabelCell.h"
#import "HQTFRepeatSelectView.h"
#import "HQSelectTimeView.h"
#import "NSDate+Calendar.h"

#define ItemMargin 15
#define ItemWidth ((SCREEN_WIDTH - 2 * ItemMargin)/7)
@interface HQScheduleTimeViewController ()<UITableViewDelegate,UITableViewDataSource,HQTFTimePointCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

/** 截止时间段 */
@property (nonatomic, copy) NSString *timePeriod;

@property (nonatomic, strong) NSMutableArray *timeArr;

@end

@implementation HQScheduleTimeViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeTimeNotification" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"日程时间";
    
    self.timeArr = [NSMutableArray array];
    
    [self createTableView];
    
    if (!self.timePeriod) {
        
        self.timePeriod = @"";
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(finishAction) text:@"完成" textColor:kUIColorFromRGB(0x69696C)];
}

- (void)createTableView {
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:BackGroudColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify=@"MySetCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    else
    {
        for(UIView *vv in cell.subviews)
        {
            [vv removeFromSuperview];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if (indexPath.row == 0) {
        
        HQTFTimePointCell *cell = [HQTFTimePointCell timePointCellWithTableView:tableView];
        cell.delegate = self;
        if ([self.deadlineType isEqualToNumber:@0]) {
            cell.startSelectDate = [NSDate dateWithTimeIntervalSince1970:[HQHelper changeTimeToTimeSp:self.date formatStr:@"yyyy-MM-dd HH:mm"]/1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:cell.startSelectDate];
            NSString *start = [strDate substringWithRange:NSMakeRange(5, 5)];

            self.startDate = start;

            
        }else{
            cell.startSelectDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate2 = [dateFormatter stringFromDate:cell.startSelectDate];
            NSString *end = [strDate2 substringWithRange:NSMakeRange(5, 5)];
            self.startDate = end;
        }

        cell.layer.masksToBounds = YES;
        return cell;

    }else if (indexPath.row == 1){
        
        _startId = 1;
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"开始时间";
        cell.arrowShowState = YES;
        cell.time.text = self.startTime;
        cell.bottomLine.hidden = NO;
        return  cell;
  
    }
    else {

    
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"截止时间";
        cell.arrowShowState = YES;
        cell.time.text = self.endTime;
        cell.bottomLine.hidden = YES;
        
        return  cell;
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.contentView.backgroundColor=HexColor(0xFFFFFF, 1);
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        [HQSelectTimeView selectTimeViewWithType:SelectTimeViewType_HourMiuth timeSp:@"10:30" LeftTouched:^{
            
        } onRightTouched:^(NSString *time) {
            
            HQLog(@"%@",time);
            if (indexPath.row == 1) {
                
                self.startTime = time;
            } else if (indexPath.row == 2) {
            
                self.endTime = time;
                
            }

            [self.tableview reloadData];
        }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return Long(ItemWidth*6)+44+18;
    } else {
    
        return 55;
    }
    return 55;
}

#pragma mark - HQTFTimePointCellDelegate
-(void)timePointCellWithDate:(NSDate *)date{
    
    self.yearDate = date;
    self.date = [NSString stringWithFormat:@"%@ 23:59",[HQHelper getYearMonthDayWithDate:date]];
    self.deadlineType = @0;
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)finishAction {

    if (self.startTime == nil||self.endTime == nil||self.startDate == nil) {
        
        [MBProgressHUD showError:@"请选择时间！" toView:self.view];
        return;
    }
    else {
    
        NSUInteger year = [self.yearDate?self.yearDate:[NSDate date] year];
        NSString *timeStr = [NSString stringWithFormat:@"%@-%@ %@",[NSString stringWithFormat:@"%lu",year],self.startDate,self.startTime];
        if ([HQHelper getNowTimeSp]>[HQHelper changeTimeToTimeSp:timeStr formatStr:@"yyyy-MM-dd HH:mm"]) {
            
            [MBProgressHUD showError:@"不能早于当前时间！" toView:self.view];
            return;
        }
        if ([HQHelper changeTimeToTimeSp:self.startTime formatStr:@"HH:mm"]>[HQHelper changeTimeToTimeSp:self.endTime formatStr:@"HH:mm"]) {
            
            [MBProgressHUD showError:@"开始时间不能早于结束时间！" toView:self.view];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTimeNotification" object:self userInfo:@{@"stime":self.startTime,@"etime":self.endTime,@"sdate":self.startDate}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
