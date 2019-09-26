//
//  TFCreateChildTaskController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateChildTaskController.h"
#import "HQCreatScheduleTitleCell.h"
#import "TFFourBtnCell.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFSelectDateView.h"
#import "TFProjectTaskBL.h"
#import "TFProjectMenberManageController.h"

@interface TFCreateChildTaskController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** time */
@property (nonatomic, copy) NSString *time;

/** taskName */
@property (nonatomic, copy) NSString *taskName;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;


@end

@implementation TFCreateChildTaskController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.present) {
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消" textColor:GreenColor];
    }
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    [self setupTableView];
    self.navigationItem.title = @"添加子任务";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GreenColor];
    self.employee = nil;
}

- (void)sure{
    
    if (!self.taskName || self.taskName.length == 0) {
        [MBProgressHUD showError:@"请输入子任务标题" toView:self.view];
        return;
    }
    
//    if (!self.employee) {
//        [MBProgressHUD showError:@"请选择执行人" toView:self.view];
//        return;
//    }
//    if (!self.time || [self.time isEqualToString:@""]) {
//        [MBProgressHUD showError:@"请选择截止时间" toView:self.view];
//        return;
//    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.type == 0) {
        if (self.parentTaskType) {
            [dict setObject:self.parentTaskType forKey:@"parentTaskType"];
        }
        [dict setObject:self.taskName forKey:@"taskName"];
        if (self.employee.id) {
            [dict setObject:self.employee.id forKey:@"executorId"];
        }
        if (self.time) {
            [dict setObject:@([HQHelper changeTimeToTimeSp:self.time formatStr:@"yyyy-MM-dd HH:mm"]) forKey:@"endTime"];
        }
        if (self.projectId) {
            [dict setObject:self.projectId forKey:@"projectId"];
        }
        if (self.taskId) {
            [dict setObject:self.taskId forKey:@"taskId"];
        }
        [dict setObject:[NSString stringWithFormat:@"project_custom_%@",[self.projectId description]] forKey:@"bean"];
        [dict setObject:@"1" forKey:@"checkStatus"];
        if (self.employee.id) {
            [dict setObject:self.employee.id forKey:@"checkMember"];
        }
        [dict setObject:@"0" forKey:@"associatesStatus"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestCreateChildTaskWithDict:dict];
        
    }else{
        
        [dict setObject:self.taskName forKey:@"name"];
        if (self.employee.id) {
            [dict setObject:self.employee.id forKey:@"executor_id"];
        }
        if (self.time) {
            [dict setObject:@([HQHelper changeTimeToTimeSp:self.time formatStr:@"yyyy-MM-dd HH:mm"]) forKey:@"end_time"];
        }
        if (self.taskId) {
            [dict setObject:self.taskId forKey:@"task_id"];
        }
        if (self.project_custom_id) {
            [dict setObject:self.project_custom_id forKey:@"project_custom_id"];
        }
        if (self.bean_name) {
            [dict setObject:self.bean_name forKey:@"bean_name"];
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestCreatePersonnelChildTaskWithDict:dict];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_createChildTask || resp.cmdId == HQCMD_createPersonnelSubTask) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"添加成功" toView:KeyWindow];
        if (self.refreshAction) {
            self.refreshAction();
        }
        
        if (self.present) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.delegate = self;
        cell.textVeiw.placeholder = @"子任务标题";
        cell.textVeiw.text = self.taskName;
        return cell;
    }else{
        if (indexPath.row == 0) {
            
            TFFourBtnCell *cell = [TFFourBtnCell fourBtnCellWithTableView:tableView];
            [cell refreshFourBtnCellWithEmployee:self.employee];
            cell.bottomLine.hidden = NO;
            return cell;
        }else{
            TFFourBtnCell *cell = [TFFourBtnCell fourBtnCellWithTableView:tableView];
            [cell refreshFourBtnCellWithTime:self.time];
            cell.bottomLine.hidden = YES;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            if (self.type == 0) {
                TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
                member.type = 1;
                member.projectId = self.projectId;
                member.parameterAction = ^(NSArray *parameter) {
                    
                    if (parameter.count) {
                        self.employee = parameter[0];
                    }
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:member animated:YES];
                
            }else{
                TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
                scheduleVC.selectType = 1;
                scheduleVC.isSingleSelect = YES;
                scheduleVC.actionParameter = ^(NSArray *parameter) {
                    
                    if (parameter.count) {
                        self.employee = parameter[0];
                    }
                    [self.tableView reloadData];
                    
                };
                [self.navigationController pushViewController:scheduleVC animated:YES];
            }
            
        }else{
            long long timeSp = [HQHelper changeTimeToTimeSp:self.time formatStr:@"yyyy-MM-dd HH:mm"];
            if (timeSp == 0) {
                timeSp = [HQHelper getNowTimeSp];
            }
            
            [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:timeSp onRightTouched:^(NSString *time) {
                
                long long end = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                
                if (self.taskEndTime > 0) {
                    if (end > self.taskEndTime) {
                        [MBProgressHUD showError:@"子任务截止时间不能大于主任务截止时间" toView:self.view];
                        return ;
                    }
                }
                
                self.time = time;
                
                [self.tableView reloadData];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 116;
    }
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
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

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.taskName = textView.text;
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
