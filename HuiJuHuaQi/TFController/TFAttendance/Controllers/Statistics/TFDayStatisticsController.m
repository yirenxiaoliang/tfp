//
//  TFDayStatisticsController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFDayStatisticsController.h"
#import "TFAttendanceBL.h"
#import "TFAttendanceStatisticsModel.h"
#import "TFSelectDateView.h"
#import "TFDayStatisticsView.h"
#import "TFPCPeoplesController.h"
#import "TFPCMonthItemController.h"

@interface TFDayStatisticsController ()<HQBLDelegate,TFDayStatisticsViewDelegate>

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@property (nonatomic, assign) long long punchDate;
/** 日统计数据 */
@property (nonatomic, strong) TFAttendanceStatisticsModel *statisticsModel;

@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, weak) TFDayStatisticsView *circleView;

@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation TFDayStatisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    
    self.punchDate = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
    [self.attendanceBL requestDayStatisticsDataWithAttendanceDay:@(self.punchDate)];
    
    [self setScrollView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

-(void)setScrollView{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-BottomHeight-44}];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = WhiteColor;
    self.scrollView = scrollView;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:(CGRect){15,15,80,30}];
    [scrollView addSubview:dateLabel];
    dateLabel.textColor = GreenColor;
    dateLabel.font = FONT(14);
    dateLabel.userInteractionEnabled = YES;
    self.dateLabel = dateLabel;
    self.dateLabel.text = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:IMG(@"下一级浅灰")];
    arrow.contentMode = UIViewContentModeCenter;
    arrow.frame = CGRectMake(CGRectGetMaxX(dateLabel.frame), 15, 30, 30);
    arrow.transform = CGAffineTransformRotate(arrow.transform, M_PI_2);
    [scrollView addSubview:arrow];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate)];
    [self.dateLabel addGestureRecognizer:tap];
    
    TFDayStatisticsView *circleView = [TFDayStatisticsView dayStatisticsView];
    circleView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 180 + 100 + 270);
    circleView.centerX = SCREEN_WIDTH/2;
    [scrollView addSubview:circleView];
    self.circleView = circleView;
    circleView.delegate = self;
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 180 + 100 + 270 + 100 > scrollView.height ? 180 + 100 + 270 + 100 : scrollView.height);
}

-(void)selectDate{
    [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDay timeSp:self.punchDate onRightTouched:^(NSString *time) {
        
        long long che = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"];
        long long now = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
        if (che > now) {
            [MBProgressHUD showError:@"不能查看将来的数据" toView:KeyWindow];
            return ;
        }
        self.dateLabel.text = time;
        self.punchDate = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"];
      
        // 请求数据
        [self.attendanceBL requestDayStatisticsDataWithAttendanceDay:@(self.punchDate)];
        
    }];
}
#pragma mark - TFDayStatisticsViewDelegate
-(void)dayStatisticsViewDidClickedWithIndex:(NSInteger)index{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFStatisticsTypeModel *model in self.statisticsModel.dataList) {
        if ([model.type integerValue] != 9) {
            [arr addObject:model];
        }
    }
    
    TFStatisticsTypeModel *model = arr[index];
    /** 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批 */
    if ([model.type integerValue] == 0) {// 打卡人数=
        
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
        vc.index = 0;
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
        vc.index = 0;
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
        vc.index = 0;
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
        vc.index = 0;
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
        vc.index = 0;
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
        vc.index = 0;
        vc.date = self.punchDate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceDayStatistics) {// 日统计
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.statisticsModel = resp.body;
        [self.circleView refreshViewWithStatasticsModel:self.statisticsModel];
        
//        self.circleView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 180 + 100 + 270);
//        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 180 + 100 + 270 + 100 > scrollView.height ? 180 + 100 + 270 + 100 : scrollView.height);
        
        self.circleView.height = 180 + (self.statisticsModel.dataList.count - 1 + 2) / 3 * (30 + 90) +10;
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.circleView.height + 100 > self.scrollView.height ? self.circleView.height + 100 : self.scrollView.height);
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
