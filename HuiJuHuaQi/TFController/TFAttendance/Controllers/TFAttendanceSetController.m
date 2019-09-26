//
//  TFAttendanceSetController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendanceSetController.h"
#import "HQSelectTimeCell.h"
#import "TFPCRuleController.h"
#import "TFAttendanceWayController.h"
#import "TFClassesManagerController.h"
#import "TFRelatedAprrovalController.h"
#import "TFOtherSetController.h"
#import "TFClassesDetailController.h"

@interface TFAttendanceSetController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation TFAttendanceSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    self.titles = [NSArray array];
    self.titles = @[@"打卡规则",@"考勤方式",  @"班次管理", @"排班详情", @"其他设置", @"关联审批单", @"插件管理"];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    
    cell.requireLabel.hidden = YES;
    cell.timeTitle.text = self.titles[indexPath.row];
    cell.topLine.hidden = NO;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 0) { //打卡规则
        
        TFPCRuleController *ruleVC = [[TFPCRuleController alloc] init];
        
        [self.navigationController pushViewController:ruleVC animated:YES];
    }
    else if (indexPath.row == 1) { //考勤方式
        
        TFAttendanceWayController *wayVC = [[TFAttendanceWayController alloc] init];
        
        [self.navigationController pushViewController:wayVC animated:YES];
        
    }
    else if (indexPath.row == 2) { //班次管理
        
        TFClassesManagerController *classManager = [[TFClassesManagerController alloc] init];
        
        [self.navigationController pushViewController:classManager animated:YES];
        
    }
    else if (indexPath.row == 3) { //排班详情
        
        TFClassesDetailController *classesDetailVC = [[TFClassesDetailController alloc] init];
        
        [self.navigationController pushViewController:classesDetailVC animated:YES];
        
    }
    else if (indexPath.row == 4) { //其他设置
        
        TFOtherSetController *otherSetVC = [[TFOtherSetController alloc] init];
        
        [self.navigationController pushViewController:otherSetVC animated:YES];
        
    }
    else if (indexPath.row == 5) { //关联审批单
        
        TFRelatedAprrovalController *relatedVC = [[TFRelatedAprrovalController alloc] init];
        
        [self.navigationController pushViewController:relatedVC animated:YES];
        
    }
    else if (indexPath.row == 6) { //插件管理
        
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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

@end
