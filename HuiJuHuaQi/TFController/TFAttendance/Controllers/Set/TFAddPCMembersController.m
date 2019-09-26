//
//  TFAddPCMembersController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPCMembersController.h"
#import "HQTFInputCell.h"
#import "TFAddPeoplesCell.h"
#import "TFAddPCRuleController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFAttendanceBL.h"

@interface TFAddPCMembersController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,TFAddPeoplesCellDelegate,HQBLDelegate>

@property (nonatomic, weak) UITableView *tableView;

/** 考勤组名称 */
@property (nonatomic, copy) NSString *attendanceName;

/** 考勤人员 */
@property (nonatomic, strong) NSMutableArray *attendancers;

/** 无需考勤人员 */
@property (nonatomic, strong) NSMutableArray *noAttendancers;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@end

@implementation TFAddPCMembersController

- (NSMutableArray *)attendancers {
    
    if (!_attendancers) {
        
        _attendancers = [NSMutableArray arrayWithArray:self.atdPersons];
    }
    return _attendancers;
}

- (NSMutableArray *)noAttendancers {
    
    if (!_noAttendancers) {
        
        _noAttendancers = [NSMutableArray arrayWithArray:self.noAtdPersons];
    }
    return _noAttendancers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    self.attendanceName = self.atdName;
    [self setupTableView];
    
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    
}
/** 处理数据 */
-(NSDictionary *)handDataWithDict:(NSDictionary *)di{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.id) {
        [dict setObject:self.id forKey:@"id"];// 考勤组id
    }
    [dict setObject:self.attendanceName forKey:@"name"];// 考勤组名字
    // 考勤人员
    NSMutableArray *persons = [NSMutableArray array];
    for (HQEmployModel *emp in self.attendancers) {
        NSMutableDictionary *tt = [NSMutableDictionary dictionary];
        if (emp.id) {
            [tt setObject:emp.id forKey:@"id"];
        }
        if (emp.picture) {
            [tt setObject:emp.picture forKey:@"picture"];
        }
        NSString *name = emp.employeeName?:emp.employee_name;
        if (emp.name?:name) {
            [tt setObject:emp.name?:name forKey:@"name"];
        }
        
        if (emp.value) {
            [tt setObject:emp.value forKey:@"value"];
        }
        if (emp.sign_id) {
            [tt setObject:emp.sign_id forKey:@"sign_id"];
        }
        if (emp.type) {
            [tt setObject:emp.type forKey:@"type"];
        }else{
            [tt setObject:@1 forKey:@"type"];
        }
        [persons addObject:tt];
    }
    [dict setObject:persons forKey:@"attendanceusers"];
    // 不需考勤人员
    NSMutableArray *nopersons = [NSMutableArray array];
    for (HQEmployModel *emp in self.noAttendancers) {
        NSMutableDictionary *tt = [NSMutableDictionary dictionary];
        if (emp.id) {
            [tt setObject:emp.id forKey:@"id"];
        }
        if (emp.picture) {
            [tt setObject:emp.picture forKey:@"picture"];
        }
        NSString *name = emp.employeeName?:emp.employee_name;
        if (emp.name?:name) {
            [tt setObject:emp.name?:name forKey:@"name"];
        }
        
        if (emp.sign_id) {
            [tt setObject:emp.sign_id forKey:@"sign_id"];
        }
        if (emp.value) {
            [tt setObject:emp.value forKey:@"value"];
        }
        if (emp.type) {
            [tt setObject:emp.type forKey:@"type"];
        }else{
            [tt setObject:@1 forKey:@"type"];
        }
        [nopersons addObject:dict];
    }
    [dict setObject:nopersons forKey:@"excludedusers"];
    // 考勤类型，0:固定班次，1排班制，2：自由打卡
    if ([di valueForKey:@"attendance_type"]) {
        [dict setObject:[di valueForKey:@"attendance_type"] forKey:@"attendanceType"];
    }else{
        [dict setObject:@"0" forKey:@"attendanceType"];
    }
    // 考勤班次设置
    NSInteger index = [[di valueForKey:@"attendance_type"] integerValue];
    if (index == 0 || index == 2) {
        NSMutableArray *ids = [NSMutableArray array];
        NSArray *work = [di valueForKey:@"work_day_list"];
        for (NSInteger i = 0; i < 7; i ++) {
            if (work.count>i) {
                NSNumber *num = work[i];
                [ids addObject:num];
            }else{
                [ids addObject:@0];
            }
        }
        [dict setObject:ids forKey:@"workdaylist"];
    }
    if (index == 2) {// 自由打卡
        if ([di valueForKey:@"attendance_start_time"]) {
            [dict setObject:[di valueForKey:@"attendance_start_time"] forKey:@"attendanceStartTime"];
        }
    }else{
        [dict setObject:@"" forKey:@"attendanceStartTime"];
    }
    // 必须打卡日期
    if ([di valueForKey:@"must_punchcard_date"]) {
        [dict setObject:[di valueForKey:@"must_punchcard_date"] forKey:@"mustPunchcardDate"];
    }else{
        [dict setObject:@[] forKey:@"mustPunchcardDate"];
    }
    // 不需打卡日期
    if ([di valueForKey:@"no_punchcard_date"]) {
        [dict setObject:[di valueForKey:@"no_punchcard_date"] forKey:@"noPunchcardDate"];
    }else{
        [dict setObject:@[] forKey:@"noPunchcardDate"];
    }
    // 自动排休
    if (index == 0) {
        [dict setObject:[di valueForKey:@"holiday_auto_status"] forKey:@"holidayAutoStatus"];
    }
    // 考勤地点
    NSMutableArray *adds = [NSMutableArray array];
    NSArray *addresses = [di valueForKey:@"attendance_address"];
    for (NSDictionary *mo in addresses) {
        if ([mo valueForKey:@"id"]) {
            [adds addObject:[mo valueForKey:@"id"]];
        }
    }
    [dict setObject:adds forKey:@"attendanceAddress"];
    
    // 考勤WiFi
    NSMutableArray *wifis = [NSMutableArray array];
    NSArray *wifiDatas = [di valueForKey:@"attendance_wifi"];
    for (NSDictionary *mo in wifiDatas) {
        if ([mo valueForKey:@"id"]) {
            [wifis addObject:[mo valueForKey:@"id"]];
        }
    }
    [dict setObject:wifis forKey:@"attendanceWIFI"];
    
    // 外勤打卡
    if ([di valueForKey:@"outworker_status"]) {
        [dict setObject:[di valueForKey:@"outworker_status"] forKey:@"outworkerStatus"];
    }
    // 人脸打卡
    if ([di valueForKey:@"face_status"]) {
        [dict setObject:[di valueForKey:@"face_status"] forKey:@"faceStatus"];
    }
    
    // 生效
    if ([di valueForKey:@"effective_date"]) {
        [dict setObject:[di valueForKey:@"effective_date"] forKey:@"effectiveDate"];
    }
    
    return dict;
}

- (void)setNavi {
    
    self.navigationItem.title = @"添加成员";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:GreenColor];
    
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
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = @"考勤组名称";
        cell.requireLabel.hidden = NO;
        cell.enterBtn.hidden = YES;
        cell.textField.placeholder = @"请输入少于10个字名称";
        cell.delegate = self;
        cell.textField.text = self.attendanceName;
        [cell refreshInputCellWithType:0];
        cell.bottomLine.hidden = NO;
        return cell;
    }
    else if (indexPath.row == 1) {
        
        TFAddPeoplesCell *cell = [TFAddPeoplesCell AddPeoplesCellWithTableView:tableView];
        
        cell.requireLabel.hidden = NO;
        cell.titleLabel.text = @"考勤人员";
        cell.delegate = self;
        
        cell.bottomLine.hidden = NO;
        [cell refreshAddPeoplesCellWithPeoples:self.attendancers structure:0 chooseType:0 showAdd:YES row:indexPath.row];
        
        return cell;
        
    }
    else {
        
        TFAddPeoplesCell *cell = [TFAddPeoplesCell AddPeoplesCellWithTableView:tableView];
        
        cell.requireLabel.hidden = YES;
        cell.titleLabel.text = @"无需考勤人员";
        cell.delegate = self;
        
        cell.bottomLine.hidden = YES;
        [cell refreshAddPeoplesCellWithPeoples:self.noAttendancers structure:0 chooseType:0 showAdd:YES row:indexPath.row];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 44;
    }
    return 80;
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

#pragma mark HQTFInputCellDelegate
- (void)inputCellWithTextField:(UITextField *)textField {
    
    self.attendanceName = textField.text;
    
}

#pragma mark TFAddPeoplesCellDelegate
- (void)addPersonel:(NSInteger)index {
    
      //创建一级文件夹
    
    TFMutilStyleSelectPeopleController *selectPeople = [[TFMutilStyleSelectPeopleController alloc] init];
    
    selectPeople.selectType = 1;
    selectPeople.isSingleSelect = NO;
    if (index == 1) {
        selectPeople.defaultPoeples = self.attendancers;
    }else if (index == 2){
        selectPeople.defaultPoeples = self.noAttendancers;
    }
    selectPeople.actionParameter = ^(id parameter) {
        
        if (index == 1) {
            
            // 排除不需考勤人员
            NSMutableArray *arr = [NSMutableArray array];
            for (HQEmployModel *em2 in parameter) {
                BOOL have = NO;
                for (HQEmployModel *em1 in self.noAttendancers) {
                    if ([em1.id isEqualToNumber:em2.id]) {
                        have = YES;
                        break;
                    }
                }
                if (!have) {
                    [arr addObject:em2];
                }
            }
            self.attendancers = arr;
            
        }
        else if (index == 2) {
            
            self.noAttendancers = parameter;
            
            // 排除不需考勤人员
            NSMutableArray *arr = [NSMutableArray array];
            for (HQEmployModel *em2 in self.attendancers) {
                BOOL have = NO;
                for (HQEmployModel *em1 in self.noAttendancers) {
                    if ([em1.id isEqualToNumber:em2.id]) {
                        have = YES;
                        break;
                    }
                }
                if (!have) {
                    [arr addObject:em2];
                }
            }
            self.attendancers = arr;
            
        }
        
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:selectPeople animated:YES];
    
    
}

#pragma mark 确定
- (void)sureAction {
    
    if ([self.attendanceName isEqualToString:@""] || self.attendanceName == nil) {
        
        [MBProgressHUD showError:@"请输入考勤名称" toView:self.view];
        return;
    }
    if (self.attendancers.count == 0 ) {
        
        [MBProgressHUD showError:@"请选择考勤人员" toView:self.view];
        return;
    }
    
    if (self.vcType == 0) {
        
        TFAddPCRuleController *addRuleVC = [[TFAddPCRuleController alloc] init];
        
        addRuleVC.atdName = self.attendanceName;
        addRuleVC.atdPersons = self.attendancers;
        addRuleVC.noAtdPersons = self.noAttendancers;
        
        [self.navigationController pushViewController:addRuleVC animated:YES];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.attendanceBL requestUpdateAttendanceScheduleWithDict:[self handDataWithDict:self.dict]];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceScheduleUpdate) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"修改成功" toView:KeyWindow];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RuleCreateSuccess" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
