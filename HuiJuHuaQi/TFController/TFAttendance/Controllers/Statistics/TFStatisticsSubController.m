 //
//  TFStatisticsSubController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsSubController.h"
#import "TFStatisticsPeoplesCell.h"
#import "TFPCPeoplesController.h"
#import "TFPCMonthItemController.h"
#import "TFAttendanceBL.h"
#import "TFPCPeoplesCell.h"
#import "TFPCStatisticsHeadCell.h"
#import "TFAttendanceStatisticsModel.h"
#import "TFSelectDateView.h"
#import "TFRefresh.h"
#import "TFAttendanceMonthController.h"

@interface TFStatisticsSubController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFPCStatisticsHeadCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@property (nonatomic, assign) long long punchDate;

/** 日统计数据 */
@property (nonatomic, strong) TFAttendanceStatisticsModel *statisticsModel;

@end

@implementation TFStatisticsSubController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    
    self.titles = [NSArray array];
    
    if (self.type == 0) {
        self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
    }
    else if (self.type == 1) {
        self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM"] formatStr:@"yyyy-MM"];
    }
    else {
        self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM"] formatStr:@"yyyy-MM"];
    }
    [self setupTableView];
    
    [self reloadData];
}

-(void)reloadData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {
        [self.attendanceBL requestDayStatisticsDataWithAttendanceDay:@(self.punchDate)];
    }
    else if (self.type == 1) {
        [self.attendanceBL requestMonthStatisticsDataWithAttendanceMonth:@(self.punchDate)];
    }
    else {
        [self.attendanceBL requestMyMonthStatisticsDataWithAttendanceMonth:@(self.punchDate)];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView.mj_header endRefreshing];
    if (resp.cmdId == HQCMD_myMonthStatistics) {// 我的
        self.statisticsModel = resp.body;
        for (TFStatisticsTypeModel *de in self.statisticsModel.dataList) {
            NSMutableArray<Optional,TFEmployModel> *arr = [NSMutableArray<Optional,TFEmployModel> array];
            TFEmployModel *em = [[TFEmployModel alloc] init];
            [arr addObject:em];
            em.attendanceList = de.attendanceList;
            de.employeeList = arr;
        }
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_attendanceDayStatistics) {// 日统计
        self.statisticsModel = resp.body;
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_attendanceMonthStatistics) {// 月统计
        self.statisticsModel = resp.body;
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-TabBarHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        [self reloadData];
    }];
    tableView.mj_header = header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
        return 3;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0 || section == 1) {
        return 1;
    }else{
        return self.statisticsModel.dataList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        TFPCStatisticsHeadCell *cell = [TFPCStatisticsHeadCell PCStatisticsHeadCellWithTableView:tableView];
        cell.lable.textColor = ExtraLightBlackTextColor;
        if (self.type == 2) {
            cell.lable.text = [NSString stringWithFormat:@"打卡月历  >"];
            cell.lable.textColor = GreenColor;
        }else{
            cell.lable.text = [NSString stringWithFormat:@"%@人参与考勤",self.statisticsModel.attendance_person_number?TEXT([self.statisticsModel.attendance_person_number description]):TEXT([self.statisticsModel.attendancePersonNumber description])];
        }
        if (self.type == 0) {
            [cell.calendarBtn setTitle:[NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy-MM-dd"]] forState:UIControlStateNormal];
        }else {
            [cell.calendarBtn setTitle:[NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy-MM"]] forState:UIControlStateNormal];
        }
        cell.bottomLine.hidden = NO;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1) {
        
        TFPCPeoplesCell *cell = [TFPCPeoplesCell PCPeoplesCellWithTableView:tableView];
        [cell configPCPeoplesCellWithModel:self.statisticsModel.employeeInfo];
        cell.memberLab.hidden = YES;
        cell.statusBtn.hidden = YES;
        cell.headMargin = 0;
        cell.bottomLine.hidden = NO;
        return cell;
    }
    else {
        
        TFStatisticsPeoplesCell *cell = [TFStatisticsPeoplesCell statisticsPeoplesWithTableView:tableView];
        
        TFStatisticsTypeModel *model = self.statisticsModel.dataList[indexPath.row];
        cell.titleLab.text = model.name;
        if (self.type == 2) {
            cell.memberLab.text = [NSString stringWithFormat:@"%ld次",[model.number integerValue]];
        }else{
            cell.memberLab.text = [NSString stringWithFormat:@"%ld人",[model.number integerValue]];
        }
        if ([model.number integerValue] == 0) {
            cell.memberLab.textColor = HexColor(0xEAEAEA);
        }else{
            cell.memberLab.textColor = GrayTextColor;
        }
        if (indexPath.row == self.statisticsModel.dataList.count-1) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 2) {
        
        if (self.type == 0) {
            
            TFStatisticsTypeModel *model = self.statisticsModel.dataList[indexPath.row];
            /** 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批 */
            if ([model.type integerValue] == 0) {// 打卡人数
                
                TFStatisticsTypeModel *model = self.statisticsModel.dataList[indexPath.row];
                TFPCPeoplesController *peoplesVC = [[TFPCPeoplesController alloc] init];
                peoplesVC.punchPeople = model.employeeList;
                peoplesVC.nopunchPeople = model.nopunchClock.employeeList;
                [self.navigationController pushViewController:peoplesVC animated:YES];
                
            }else if ([model.type integerValue] == 1){// 迟到
                
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 2){// 早退
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 3){// 缺卡
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 4){// 旷工
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 5){// 外勤
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 6){// 关联
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else if (self.type == 1){
            
            TFStatisticsTypeModel *model = self.statisticsModel.dataList[indexPath.row];
            /** 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批,  7正常, 8未到打卡时间*/
            if ([model.type integerValue] == 1) {// 迟到
                
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 2){// 早退
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 3){// 缺卡
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 4){// 旷工
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 5){// 外勤
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 6){// 关联
                if (model.employeeList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无人%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else{
            
            TFStatisticsTypeModel *model = self.statisticsModel.dataList[indexPath.row];
            /** 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批,7正常, 8未到打卡时间 */
            if ([model.type integerValue] == 7) {// 正常
                
                if (model.attendanceList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else  if ([model.type integerValue] == 1) {// 迟到
                
                if (model.attendanceList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 2){// 早退
                if (model.attendanceList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 3){// 缺卡
                if (model.attendanceList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 4){// 旷工
                if (model.attendanceList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 5){// 外勤
                if (model.attendanceList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([model.type integerValue] == 6){// 关联
                if (model.attendanceList.count == 0) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"无%@",model.name] toView:self.view];
                    return;
                }
                
                TFPCMonthItemController *vc = [[TFPCMonthItemController alloc] init];
                vc.type = [model.type integerValue];
                vc.peoples = model.employeeList;
                vc.naviTitle = model.name;
                vc.index = self.type;
                vc.date = self.punchDate;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 50;
    }
    if (indexPath.section == 1) {
        
        if (self.type == 2) {
            
            return 80;
        }
        else {
            
            return 0;
            
        }
    }
    else {
        
        return 60;

    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
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

#pragma mark - TFPCStatisticsHeadCellDelegate
-(void)statisticsHeadCellDidSelectDate{
    
    DateViewType type = DateViewType_YearMonthDay;
    NSString *format = @"yyyy-MM-dd";
    if (self.type == 1 || self.type == 2) {
        type = DateViewType_YearMonth;
        format = @"yyyy-MM";
    }
    
    [TFSelectDateView selectDateViewWithType:type timeSp:self.punchDate onRightTouched:^(NSString *time) {
        
        self.punchDate = [HQHelper changeTimeToTimeSp:time formatStr:format];
        
        [self reloadData];
        
    }];
    
}

-(void)statisticsHeadCellDidSelectCalendar{
    if (self.type == 2) {
        TFAttendanceMonthController *calendar = [[TFAttendanceMonthController alloc] init];
//        calendar.punchDate = self.punchDate;
        [self.navigationController pushViewController:calendar animated:YES];
    }
}

@end
