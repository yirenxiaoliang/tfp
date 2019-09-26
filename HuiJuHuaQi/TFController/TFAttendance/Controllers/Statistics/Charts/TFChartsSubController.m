//
//  TFChartsSubController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChartsSubController.h"
#import "TFPCPeoplesCell.h"
#import "TFAttendanceBL.h"
#import "TFGroupListModel.h"
#import "TFAttendanceGroupModel.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "TFPCStatisticsHeadCell.h"
#import "TFSelectDateView.h"

@interface TFChartsSubController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFPCStatisticsHeadCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@property (nonatomic, assign) long long punchDate;

@property (nonatomic, strong) TFAttendanceGroupModel *ruleModel;

@property (nonatomic, strong) NSArray *peoples;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFChartsSubController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    [self setupTableView];
    
    if (self.type == 0) {
        self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
    }
    else if (self.type == 1) {
        self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM"] formatStr:@"yyyy-MM"];
    }
    else {
        self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM"] formatStr:@"yyyy-MM"];
    }
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AttendanceGroupList" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        self.ruleModel = x.object;
        [self requestData];
    }];
}

-(void)requestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {
        [self.attendanceBL requestAttendanceEarlyDataWithAttendanceDate:@(self.punchDate) groupId:self.ruleModel.id];
    }else if (self.type == 1){
        [self.attendanceBL requestAttendanceHardworkingDataWithAttendanceMonth:@(self.punchDate) groupId:self.ruleModel.id];
    }else{
        [self.attendanceBL requestAttendanceLateDataWithAttendanceMonth:@(self.punchDate) groupId:self.ruleModel.id];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.tableView.mj_header endRefreshing];
    if (resp.cmdId == HQCMD_attendanceEarlyRank) {
        self.peoples = resp.body;
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_attendanceLateRank) {
        self.peoples = resp.body;
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_attendanceHardworkingRank) {
        self.peoples = resp.body;
        [self.tableView reloadData];
    }
    if (self.peoples.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = nil;
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        [self requestData];
    }];
    tableView.mj_header = header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.peoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        TFPCStatisticsHeadCell *cell = [TFPCStatisticsHeadCell PCStatisticsHeadCellWithTableView:tableView];
        cell.lable.textColor = ExtraLightBlackTextColor;
        [cell.calendarBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
        if (self.type == 0) {
            if ([HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"] == self.punchDate) {
                
                [cell.calendarBtn setTitle:[NSString stringWithFormat:@"今天(%@)",[NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy.MM.dd"]]] forState:UIControlStateNormal];
            }else{
                [cell.calendarBtn setTitle:[NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy.MM.dd"]] forState:UIControlStateNormal];
            }
            cell.lable.text = [NSString stringWithFormat:@"按上班时间排序"];
        }else if (self.type == 1){
            [cell.calendarBtn setTitle:[NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy.MM"]] forState:UIControlStateNormal];
            cell.lable.text = [NSString stringWithFormat:@"按工作时长排序"];
        }else{
            [cell.calendarBtn setTitle:[NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:self.punchDate formatStr:@"yyyy.MM"]] forState:UIControlStateNormal];
            cell.lable.text = [NSString stringWithFormat:@"按迟到次数和时长排序"];
        }
        cell.bottomLine.hidden = YES;
        cell.delegate = self;
        cell.backgroundColor = BackGroudColor;
        return cell;
    }else{
        
        TFPCPeoplesCell *cell = [TFPCPeoplesCell PCPeoplesCellWithTableView:tableView];
        TFRankPeopleModel *model = self.peoples[indexPath.row];
        [cell configStatisticsChartsCellWithModel:model index:indexPath.row];
        if (self.type == 2) {
            cell.statusBtn.hidden = YES;
        }
        if (self.peoples.count - 1 == indexPath.row) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 44;
    }
    
    return 70;
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
        
        [self requestData];
        
    }];
    
}
@end
