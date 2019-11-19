//
//  TFProjectMenberManageController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectMenberManageController.h"
#import "TFProjectMenberCell.h"
#import "TFProjectRoleController.h"
#import "TFProjectTaskBL.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFProjectPeopleModel.h"
#import "TFTransferTaskController.h"

@interface TFProjectMenberManageController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,HQBLDelegate,UIAlertViewDelegate>
/** tableView */
@property (nonatomic, weak)  UITableView *tableView;

/** menbers */
@property (nonatomic, strong) NSMutableArray *menbers;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** TFProjectPeopleModel */
@property (nonatomic, strong) TFProjectPeopleModel *selectPeople;

/** privilege */
@property (nonatomic, copy) NSString *privilege;


@end

@implementation TFProjectMenberManageController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)menbers{
    if (!_menbers) {
        _menbers = [NSMutableArray array];
        
    }
    return _menbers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requsetGetProjectPeopleWithProjectId:self.projectId];
    if (self.type == 0) {
        [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];
    }else{
        [self setupNavigation];
    }
    
    [self setupTableView];
    self.navigationItem.title = [NSString stringWithFormat:@"成员管理"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_deleteProjectPeopleTransferTask) {// 判断是否需要交接
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dict = resp.body;
        if ([dict valueForKey:@"taskCount"] && [[[dict valueForKey:@"taskCount"] description] isEqualToString:@"0"]) {// 没任务
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要移除该项目成员吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            [alert show];
            
        }else{// 需结交任务
            
            TFTransferTaskController *transfer = [[TFTransferTaskController alloc] init];
            transfer.projectId = self.projectId;
            transfer.deletePeople = self.selectPeople;
            transfer.deleteAction = ^{
                [self.menbers removeObject:self.selectPeople];
                [self.tableView reloadData];
                self.navigationItem.title = [NSString stringWithFormat:@"成员管理(%ld)",self.menbers.count];
            };
            [self.navigationController pushViewController:transfer animated:YES];
            
        }
        
    }
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"11"]) {
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            [self setupNavigation];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getProjectPeople) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.isTransfer) {
            TFProjectPeopleModel *peo = self.selectPeoples[0];
            NSMutableArray *arr = [NSMutableArray array];
            for (TFProjectPeopleModel *model in resp.body) {
                
                if ([peo.project_member_id isEqualToNumber:model.project_member_id]) {
                    continue;
                }
                [arr addObject:model];
            }
            
            self.menbers = arr;
            
            if (self.menbers.count == 0) {
                
                self.tableView.backgroundView = self.noContentView;
            }else{
                self.tableView.backgroundView = [UIView new];
            }
            self.navigationItem.title = [NSString stringWithFormat:@"成员管理(%ld)",self.menbers.count];
            
        }else{
            
            self.menbers = resp.body;
            
            if (self.menbers.count == 0) {
                
                self.tableView.backgroundView = self.noContentView;
            }else{
                self.tableView.backgroundView = [UIView new];
            }
            self.navigationItem.title = [NSString stringWithFormat:@"成员管理(%ld)",self.menbers.count];
            
            for (TFProjectPeopleModel *model in self.selectPeoples) {
                
                for (TFProjectPeopleModel *pe in self.menbers) {
                    
                    if ([model.employee_id?:model.id isEqualToNumber:pe.employee_id]) {
                        pe.selectState = @1;
                        break;
                    }
                }
            }
            
        }
        
        if (self.noselectPeoples) {

            for (NSDictionary *dd in self.noselectPeoples) {
                BOOL have = NO;
                for (TFProjectPeopleModel *pe in self.menbers) {
                    
                    if ([dd valueForKey:@"id"] && [[pe.employee_id description] isEqualToString:[[dd valueForKey:@"id"] description]]) {
                        [self.menbers removeObject:pe];
                        have = YES;
                        break;
                    }
                }
                if (have) {
                    break;
                }
            }
        }
        
        [self.tableView reloadData];
        
    }
    if (resp.cmdId == HQCMD_addProjectPeople) {
        
        [self.projectTaskBL requsetGetProjectPeopleWithProjectId:self.projectId];

    }
    
    if (resp.cmdId == HQCMD_deleteProjectPeople) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"删除成功" toView:self.view];
        [self.menbers removeObject:self.selectPeople];
        self.navigationItem.title = [NSString stringWithFormat:@"成员管理(%ld)",self.menbers.count];
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


- (void)setupNavigation{
    
    self.navigationItem.title = [NSString stringWithFormat:@"成员管理(%ld)",self.menbers.count];
    
    if (self.type == 0) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addMenber) text:@"添加" textColor:GreenColor];
    }else{
        if (self.isMulti) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
        }
    }
}

- (void)sure{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFProjectPeopleModel *model in self.menbers) {
        
        if ([model.selectState isEqualToNumber:@1]) {
            
            if (self.isTransfer) {
                [arr addObject:model];
            }else{
                
                HQEmployModel *em = [[HQEmployModel alloc] init];
                em.employeeName = model.employee_name;
                em.employee_name = model.employee_name;
                em.id = model.employee_id;
                em.project_member_id = model.id;
                em.picture = model.employee_pic;
                [arr addObject:em];
            }
        }
    }
    
    if (arr.count == 0) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    
    if (self.parameterAction) {
        self.parameterAction(arr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addMenber{
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    
    NSMutableArray *peoples = [NSMutableArray array];
    for (TFProjectPeopleModel *model in self.menbers) {
        HQEmployModel *em = [[HQEmployModel alloc] init];
        em.id = model.employee_id;
        [peoples addObject:em];
    }
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = NO;
    scheduleVC.noSelectPoeples = peoples;
    scheduleVC.actionParameter = ^(NSArray *parameter) {
        
        NSString *str = @"";
        for (HQEmployModel *em in parameter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[em.id description]]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length - 1];
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.projectTaskBL requsetAddProjectPeopleWithProjectId:self.projectId peoplesIds:str];
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
    
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
    return self.menbers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFProjectMenberCell *cell = [TFProjectMenberCell projectMenberCellWithTableView:tableView];
    
    TFProjectPeopleModel *model = self.menbers[indexPath.row];
    
    [cell.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.employee_pic] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [cell.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [cell.headImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [cell.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
        }
    } ];
    cell.nameLabel.text = model.employee_name;
    cell.powerLabel.text = model.project_role_name;
    cell.type = self.type;
    cell.topLine.hidden = NO;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    
    if (self.type == 1) {
        if ([model.selectState isEqualToNumber:@1]) {
            cell.enterImg.image = IMG(@"完成");
        }else{
            cell.enterImg.image = nil;
        }
    }else{
        cell.enterImg.hidden = ![self.privilege containsString:@"12"] || [[model.project_role description] isEqualToString:@"1"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectPeopleModel *model = self.menbers[indexPath.row];
    
    if (self.type == 0) {
        
        if (![self.projectModel.project_status isEqualToString:@"0"]) {
            if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
                [MBProgressHUD showError:@"项目已归档" toView:self.view];
            }
            if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
                [MBProgressHUD showError:@"项目已暂停" toView:self.view];
            }
            return;
        }
        if (![self.privilege containsString:@"12"]  || [[model.project_role description] isEqualToString:@"1"]) {
            return;
        }
        self.selectPeople = model;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"项目角色",@"移除成员",nil];
        [sheet showInView:self.view];
    }else{
        
        if (self.isMulti) {
            
            model.selectState = [model.selectState isEqualToNumber:@1]?@0:@1;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            self.selectPeople = model;
            HQEmployModel *em = [[HQEmployModel alloc] init];
            em.employeeName = model.employee_name;
            em.employee_name = model.employee_name;
            em.id = model.employee_id;
            em.picture = model.employee_pic;
            em.project_member_id = model.project_member_id;
            if (self.parameterAction) {
                self.parameterAction(@[em]);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        TFProjectRoleController *role = [[TFProjectRoleController alloc] init];
        role.projectId = self.projectId;
        role.recordId = self.selectPeople.project_member_id;
        role.actionParameter = ^(NSDictionary *parameter) {
            
            self.selectPeople.project_role = [parameter valueForKey:@"roleId"];
            self.selectPeople.project_role_name = [parameter valueForKey:@"roleName"];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:role animated:YES];
    }
    
    if (buttonIndex == 1) {
        
        // 先判断需不需要交接任务
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requsetDeleteProjectPeopleTransferTaskWithProjectMemberId:self.selectPeople.project_member_id];
        
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.projectTaskBL requsetDeleteProjectPeopleWithRecordId:self.selectPeople.project_member_id recipient:nil];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
