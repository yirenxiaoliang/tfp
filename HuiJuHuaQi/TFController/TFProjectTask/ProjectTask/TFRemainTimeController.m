//
//  TFRemainTimeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRemainTimeController.h"
#import "HQSelectTimeCell.h"
#import "TFSelectPeopleCell.h"
#import "TFSelectDateView.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFEndBeforeController.h"
#import "TFProjectTaskBL.h"
#import "TFRemindWayController.h"

@interface TFRemainTimeController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** footer */
@property (nonatomic, weak) UIView *footer;

/** remain */
@property (nonatomic, strong) NSNumber *remain;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;

/** time */
@property (nonatomic, copy) NSString *time;

/** unit */
@property (nonatomic, assign) NSInteger unit;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** ways */
@property (nonatomic, strong) NSArray *ways;

/** remindWay */
@property (nonatomic, copy) NSString *remindWay;

/** remindId */
@property (nonatomic, strong) NSNumber *remindId;


@end

@implementation TFRemainTimeController

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
        HQEmployModel *employee = [[HQEmployModel alloc] init];
        employee.id = UM.userLoginInfo.employee.id;
        employee.employee_name = UM.userLoginInfo.employee.employee_name;
        employee.employeeName = UM.userLoginInfo.employee.employee_name;
        employee.photograph = UM.userLoginInfo.employee.picture;
        [_peoples addObject:employee];
    }
    return _peoples;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.remain = @0;
    self.remindWay = @"企信";
    self.ways = @[@{@"way":@0,@"name":@"企信",@"select":@0}];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    if (self.taskType == 0) {// 项目任务
        [self.projectTaskBL requestGetTaskRemainWithTaskId:self.taskId taskType:@1];
    }else if (self.taskType == 1) {// 项目子任务
        [self.projectTaskBL requestGetTaskRemainWithTaskId:self.taskId taskType:@2];
    }else if (self.taskType == 2) {// 个人任务
        [self.projectTaskBL requsetGetPersonnelTaskRemindWithTaskId:self.taskId fromType:@0];
    }else{// 个人子任务
        [self.projectTaskBL requsetGetPersonnelTaskRemindWithTaskId:self.taskId fromType:@1];
    }
    
    [self setupTableView];
    [self setupNavi];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectTaskRemain || resp.cmdId == HQCMD_getPersonnelTaskRemind) {
        
        NSArray *arr = resp.body;
        if (arr.count) {
            NSDictionary *dict = arr[0];
            self.remindId = [dict valueForKey:@"id"];
            self.remain = @([[dict valueForKey:@"remind_type"] integerValue]-1);
            if ([self.remain isEqualToNumber:@0]) {
                
                self.time = [HQHelper nsdateToTime:[[dict valueForKey:@"remind_time"] longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
            }else{
                self.time = [[dict valueForKey:@"before_deadline"] description];
                self.unit = [[dict valueForKey:@"remind_unit"] integerValue];
            }
            
            NSMutableArray *peoples = [NSMutableArray array];
            for (NSDictionary *pe in [dict valueForKey:@"reminder"]) {
                HQEmployModel *em = [[HQEmployModel alloc] initWithDictionary:pe error:nil];
                if (em) {
                    [peoples addObject:em];
                }
            }
            self.peoples = peoples;
            
            NSArray *wayStrs = [[dict valueForKey:@"remind_way"] componentsSeparatedByString:@","];
            NSMutableArray *ways = [NSMutableArray array];
            NSString *str = @"";
            for (NSString *ss in wayStrs) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if ([ss isEqualToString:@"0"]) {
                    [dict setObject:@"企信" forKey:@"name"];
                }else if ([ss isEqualToString:@"1"]){
                    [dict setObject:@"企业微信" forKey:@"name"];
                }else if ([ss isEqualToString:@"2"]){
                    [dict setObject:@"钉钉" forKey:@"name"];
                }else if ([ss isEqualToString:@"3"]){
                    [dict setObject:@"邮件" forKey:@"name"];
                }
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"name"]]];
                [dict setObject:@1 forKey:@"select"];
                [dict setObject:@([ss integerValue]) forKey:@"way"];
                [ways addObject:dict];
            }
            self.ways = ways;
            if (str.length) {
                str = [str substringToIndex:str.length-1];
            }
            self.remindWay = str;
            
            [self.tableView reloadData];
        }
        
    }
    
    if (resp.cmdId == HQCMD_saveProjectTaskRemain) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_updateProjectTaskRemain) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_savePersonnelTaskRemind) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if (resp.cmdId == HQCMD_updatePersonnelTaskRemind) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


- (void)setupNavi{
    self.navigationItem.title = @"提醒";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GrayTextColor];
}

- (void)sure{
    
    if (self.remain == nil) {
        [MBProgressHUD showError:@"请选择提醒类型" toView:self.view];
        return;
    }
    
    if ([self.remain isEqualToNumber:@0]) {// 自定义提醒
        
        if (self.time.length == 0) {
            [MBProgressHUD showError:@"请选择提醒时间" toView:self.view];
            return;
        }
        
    }else{// 截止时间提醒
        
        if (self.time.length == 0) {
            [MBProgressHUD showError:@"请输入截止前" toView:self.view];
            return;
        }
    }
    
    if (self.peoples.count == 0) {
        [MBProgressHUD showError:@"请选择被提醒人" toView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:self.taskId forKey:@"task_id"];
    if (self.taskType==0) {
        [dict setObject:@1 forKey:@"from_type"];
    }
    if (self.taskType==1) {
        [dict setObject:@2 forKey:@"from_type"];
    }
    if (self.taskType==2) {
        [dict setObject:@0 forKey:@"from_type"];
    }
    if (self.taskType==3) {
        [dict setObject:@1 forKey:@"from_type"];
    }
    [dict setObject:@([self.remain integerValue] + 1) forKey:@"remind_type"];
    if ([self.remain isEqualToNumber:@0]) {
        [dict setObject:@([HQHelper changeTimeToTimeSp:self.time formatStr:@"yyyy-MM-dd HH:mm"]) forKey:@"remind_time"];
    }else{
        [dict setObject:self.time forKey:@"before_deadline"];
        [dict setObject:@(self.unit) forKey:@"remind_unit"];
    }
    NSString *ways = @"";
    for (NSDictionary *dict in self.ways) {
        
        ways = [ways stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict valueForKey:@"way"]]];
    }
    if (ways.length) {
        ways = [ways substringToIndex:ways.length-1];
    }
    [dict setObject:ways forKey:@"remind_way"];
    
    if (self.projectId) {
        [dict setObject:self.projectId forKey:@"project_id"];
    }
    
    if (self.taskType == 0 || self.taskType == 1) {
        
        NSString *str = @"";
        for (HQEmployModel *model in self.peoples) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.id?:model.employeeId]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length-1];
        }
        [dict setObject:str forKey:@"reminder"];
    }
    else{
        NSMutableArray *peos = [NSMutableArray array];
        for (HQEmployModel *model in self.peoples) {
            NSDictionary *dddd = [model toDictionary];
            if (dddd) {
                [peos addObject:dddd];
            }
        }
        [dict setObject:peos forKey:@"reminder"];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.taskType == 0 || self.taskType == 1) {// 项目任务
        
        if (self.remindId) {// 修改
            [dict setObject:self.remindId forKey:@"id"];
            [self.projectTaskBL requsetUpdateTaskRemainWithDict:dict];
        }else{// 保存
            [self.projectTaskBL requsetSettingTaskRemainWithDict:dict];
        }
    }else{// 个人任务
        
        if (self.remindId) {// 修改
            [dict setObject:self.remindId forKey:@"id"];
            [self.projectTaskBL requsetUpdatePersonnelTaskRemindWithDict:dict];
        }else{// 保存
            [self.projectTaskBL requsetSavePersonnelTaskRemindWithDict:dict];
        }
        
    }
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
    
    
    NSString *str = @"提示：成员必须绑定企业微信、钉钉或邮箱，才能收到提醒。";
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:str];
    UIView *footer = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,size.height + 30}];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,size.height + 15}];
    label.numberOfLines = 0;
    label.textColor = GrayTextColor;
    label.textAlignment = NSTextAlignmentJustified;
    label.font = FONT(14);
    label.text = str;
    [footer addSubview:label];
    tableView.tableFooterView = footer;
    self.footer = footer;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
     
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.timeTitle.textColor = BlackTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            
            cell.timeTitle.text = @"自定义提醒";
            if (self.remain && [self.remain isEqualToNumber:@0]) {
                cell.arrow.image = [UIImage imageNamed:@"完成"];
            }else{
                cell.arrow.image = nil;
            }
        }else{
            if (self.remain && [self.remain isEqualToNumber:@1]) {
                cell.arrow.image = [UIImage imageNamed:@"完成"];
            }else{
                cell.arrow.image = nil;
            }
            cell.timeTitle.text = @"截止时间提醒";
            cell.topLine.hidden = NO;
        }
        return cell;
        
    }else if (indexPath.section == 1){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.timeTitle.textColor = GrayTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = 101;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arrow.image = [UIImage imageNamed:@"下一级浅灰"];
        cell.time.textColor = BlackTextColor;
        cell.time.textAlignment = NSTextAlignmentRight;
        
        if (self.remain) {
            if ([self.remain isEqualToNumber:@0]) {
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:TEXT(self.time) attributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:FONT(16)}];
                cell.time.attributedText = str;
                cell.timeTitle.text = @"提醒时间";
            }else{
                
                NSString *str = @"";
                if (self.unit == 0) {
                    str = @"分钟";
                }else if (self.unit == 1){
                    str = @"小时";
                }else{
                    str = @"天";
                }
                if (!self.time || [self.time isEqualToString:@""]) {
                    str = @"";
                }
                NSString *total = [NSString stringWithFormat:@"%@%@",TEXT(self.time),str];
                NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:total attributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:FONT(16)}];
                NSRange range = [[NSString stringWithFormat:@"%@%@",TEXT(self.time),str] rangeOfString:TEXT(self.time)];
                [attrstr addAttribute:NSForegroundColorAttributeName value:GreenColor range:range];
                
                cell.time.attributedText = attrstr;
                
                cell.timeTitle.text = @"截止前";
            }
        }
        
        return cell;
        
    }else if (indexPath.section == 2){
        
        TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
        cell.titleLabel.text = @"被提醒人";
        [cell refreshSelectPeopleCellWithPeoples:self.peoples structure:@"1" chooseType:@"1" showAdd:YES clear:NO];
        cell.requireLabel.hidden = YES;
        cell.isHiddenName = YES;
        cell.titleLabel.textColor = GrayTextColor;
        cell.titleLabel.font = FONT(16);
        return cell;
        
    }else{
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.timeTitle.textColor = GrayTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = 101;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timeTitle.text = @"提醒方式";
        cell.arrow.image = [UIImage imageNamed:@"下一级浅灰"];
        cell.time.textColor = BlackTextColor;
        cell.time.textAlignment = NSTextAlignmentRight;
        cell.time.text = self.remindWay;
        return cell;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.remain = @0;
        }else{
            self.remain = @1;
        }
        self.time = nil;
        [tableView reloadData];
    }
    
    if (indexPath.section == 1) {
        if ([self.remain isEqualToNumber:@0]) {
            
            long long timeSp = [HQHelper changeTimeToTimeSp:self.time formatStr:@"yyyy-MM-dd HH:mm"];
            
            [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:timeSp<=0?[HQHelper getNowTimeSp]:timeSp onRightTouched:^(NSString *time) {
                
                if ([HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"] < [HQHelper getNowTimeSp]) {
                    [MBProgressHUD showError:@"截止时间不可小于当前时间" toView:self.view];
                    return ;
                }
                
                
                self.time = time;
                [self.tableView reloadData];
            }];
        }else{
            
            TFEndBeforeController *before = [[TFEndBeforeController alloc] init];
            before.time = self.time;
            before.unit = self.unit;
            before.parameterAction = ^(NSDictionary *parameter) {
              
                self.time = [parameter valueForKey:@"time"];
                NSNumber *num = [parameter valueForKey:@"unit"];
                self.unit = [num integerValue];
                
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:before animated:YES];
            
        }
    }
    
    if (indexPath.section == 2) {
        
        TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
        scheduleVC.selectType = 1;
        scheduleVC.isSingleSelect = NO;
        scheduleVC.defaultPoeples = self.peoples;
        //            scheduleVC.noSelectPoeples = model.selects;
        scheduleVC.actionParameter = ^(NSArray *parameter) {
            
            NSString *str = @"";
            for (HQEmployModel *em in parameter) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[em.id description]]];
            }
            if (str.length) {
                str = [str substringToIndex:str.length - 1];
            }
            
            [self.peoples removeAllObjects];
            [self.peoples addObjectsFromArray:parameter];
            
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:scheduleVC animated:YES];
        
    }
    
    if (indexPath.section == 3) {
        TFRemindWayController *way = [[TFRemindWayController alloc] init];
        way.selectWays = self.ways;
        way.parameter = ^(NSArray *parameter) {
            
            self.ways = parameter;
            self.remindWay = @"";
            for (NSDictionary *dict in parameter) {
                self.remindWay = [self.remindWay stringByAppendingString:[NSString stringWithFormat:@"%@、",[dict valueForKey:@"name"]]];
            }
            if (self.remindWay.length) {
                self.remindWay = [self.remindWay substringToIndex:self.remindWay.length-1];
            }
            [self.tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:way animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.remain) {
        
        self.footer.hidden = NO;
    }else{
        if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3) {
            return 0;
        }
        self.footer.hidden = YES;
    }
    
    if (indexPath.section == 2) {
        return 60;
    }
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 24;
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
