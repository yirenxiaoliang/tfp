//
//  TFCooperationPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCooperationPeopleController.h"
#import "TFProjectMenberManageController.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "HQTFTwoLineCell.h"

@interface TFCooperationPeopleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFTwoLineCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFCooperationPeopleController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}
-(NSMutableArray *)peoples{
    
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    if (self.taskType == 0 || self.taskType == 1) {// 项目任务
        
        [self.projectTaskBL requestGetProjectTaskCooperationPeopleListWithProjectId:self.projectId taskId:self.taskId typeStatus:self.taskType==0?@1:@2];
        
    }else{// 个人任务
        [self.projectTaskBL requestGetPersonnelTaskCooperationPeopleListWithTaskId:self.taskId typeStatus:self.taskType==2?@0:@1];
    }
    
    [self setupTableView];
    [self setupNavi];
    
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectTaskCooperationPeopleList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.peoples removeAllObjects];
        
        for (TFProjectPeopleModel *model in resp.body) {
            
            HQEmployModel *em = [[HQEmployModel alloc] init];
            em.id = model.employee_id;
            em.employee_name = model.employee_name;
            em.picture = model.employee_pic;
            em.position = model.post_name;
            em.project_member_id = model.project_member_id;
            
            [self.peoples addObject:em];
        }
        if (self.peoples.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_getPersonnelTaskCooperationPeopleList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.peoples = resp.body;
        
        if (self.peoples.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_addPersonnelTaskCooperationPeople || resp.cmdId == HQCMD_addProjectTaskCooperationPeople) {
        
        [MBProgressHUD showImageSuccess:@"添加成功" toView:self.view];
        
        if (self.peoples.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        if (self.action) {
            self.action(self.peoples);
        }
    }
    
    if (resp.cmdId == HQCMD_deleteProjectTaskCooperationPeople || resp.cmdId == HQCMD_deletePersonnelTaskCooperationPeople) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"移除成功" toView:self.view];
        if (self.peoples.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        [self.tableView reloadData];
        
        if (self.action) {
            self.action(self.peoples);
        }
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


- (void)setupNavi{
    self.navigationItem.title = @"协作人";
    
    
    if (self.taskType == 0 || self.taskType == 1) {// 项目任务
        
        if ([HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_6" role:self.role]) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addPeople) text:@"添加" textColor:GreenColor];
        }
    }else{// 个人任务
        
        if ([self.role isEqualToString:@"0"] || [self.role isEqualToString:@"1"]) {// 创建人，执行人
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addPeople) text:@"添加" textColor:GreenColor];
        }
    }
}
     
- (void)addPeople{
    
    if (self.taskType == 0 || self.taskType == 1) {
        
        if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
            if ([self.project_status isEqualToString:@"1"]) {// 归档
                
                [MBProgressHUD showError:@"项目已归档" toView:self.view];
            }
            if ([self.project_status isEqualToString:@"2"]) {// 暂停
                
                [MBProgressHUD showError:@"项目已暂停" toView:self.view];
            }
            return;
        }
        if ([self.complete_status isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            return;
        }
        TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
        member.type = 1;
        member.projectId = self.projectId;
        member.isMulti = YES;
        member.selectPeoples = self.peoples;
        member.parameterAction = ^(NSArray *parameter) {
            
            NSMutableArray *dicts = [NSMutableArray array];
    
            for (HQEmployModel *em in parameter) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:em.employeeId?:em.id forKey:@"employeeIds"];
                [dict setObject:self.projectId forKey:@"projectId"];
                [dict setObject:self.taskId forKey:@"taskId"];
                [dict setObject:self.taskType==0?@1:@2 forKey:@"typeStatus"];
                [dict setObject:@2 forKey:@"project_task_role"];
                if (self.taskType == 1) {
                    if (self.parentTaskId) {
                        [dict setObject:self.parentTaskId forKey:@"id"];
                    }
                }
                [dicts addObject:dict];
            }
            
            [self.peoples removeAllObjects];
            [self.peoples addObjectsFromArray:parameter];
            [self.tableView reloadData];
            if (self.peoples.count == 0) {
                
                self.tableView.backgroundView = self.noContentView;
            }else{
                self.tableView.backgroundView = [UIView new];
            }
            
            [self.projectTaskBL requestAddProjectTaskCooperationPeopleWithDict:@{@"dataList":dicts}];
        };
        [self.navigationController pushViewController:member animated:YES];
    }else{
        
        if ([self.complete_status isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
            return;
        }
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
            if (self.peoples.count == 0) {
                
                self.tableView.backgroundView = self.noContentView;
            }else{
                self.tableView.backgroundView = [UIView new];
            }
            
            
            [self.projectTaskBL requestAddPersonnelTaskCooperationPeopleListWithTaskId:self.taskId typeStatus:self.taskType==2?@0:@1 employeeIds:str];
        };
        [self.navigationController pushViewController:scheduleVC animated:YES];
        
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
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    if (self.taskType == 0 || self.taskType == 1) {
        [cell refreshCellWithProjectPeopleModel:self.peoples[indexPath.row]];
    }else{
        [cell refreshCellWithEmployeeModel:self.peoples[indexPath.row]];
    }
    cell.isClear = [HQHelper haveTaskAuthWithAuths:self.taskRoleAuths authKey:@"auth_7" role:self.role];
    cell.delegate = self;
    cell.enterImage.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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
#pragma mark - HQTFTwoLineCellDelegate
-(void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    
    if (self.taskType == 0 || self.taskType == 1) {
        
        if (self.project_status && ![self.project_status isEqualToString:@"0"]) {
            if ([self.project_status isEqualToString:@"1"]) {// 归档
                
                [MBProgressHUD showError:@"项目已归档" toView:self.view];
            }
            if ([self.project_status isEqualToString:@"2"]) {// 暂停
                
                [MBProgressHUD showError:@"项目已暂停" toView:self.view];
            }
            return;
        }
    }
    if ([self.complete_status isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"完成的任务不能编辑" toView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.taskType == 0 || self.taskType == 1) {// 项目任务
        
        HQEmployModel *model = self.peoples[enterBtn.tag];
        [self.peoples removeObjectAtIndex:enterBtn.tag];
        
        [self.projectTaskBL requestDeleteProjectTaskCooperationPeopleWithRecordId:model.project_member_id];
        
    }else{
        HQEmployModel *model = self.peoples[enterBtn.tag];
        [self.peoples removeObjectAtIndex:enterBtn.tag];
        
        [self.projectTaskBL requestDeletePersonnelTaskCooperationPeopleWithFromType:self.taskType == 2?@0:@1 taskId:self.taskId employeeIds:[model.employeeId description]];
    }
    
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
