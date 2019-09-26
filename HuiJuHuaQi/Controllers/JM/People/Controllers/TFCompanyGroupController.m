//
//  TFCompanyGroupController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyGroupController.h"
#import "HQTFUploadFileView.h"
#import "TFAddCompanyPeopleController.h"
#import "HQDepartmentModel.h"
#import "TFPeopleManageDepartmentCell.h"
#import "TFPeopleManagePeopleCell.h"
#import "TFDepartmentManageController.h"
#import "FDActionSheet.h"
#import "AlertView.h"
#import "TFBarcodeInviteController.h"
#import "TFPeopleBL.h"
#import "TFChatPeopleInfoController.h"

@interface TFCompanyGroupController ()<UITableViewDelegate,UITableViewDataSource,FDActionSheetDelegate,HQBLDelegate>
/** UITableView *tableViewq */
@property (nonatomic, weak) UITableView *tableView;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;
/** selectPeoples */
@property (nonatomic, strong) NSMutableArray *selectPeoples;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** company */
@property (nonatomic, weak) UILabel *company;

/** selectIndexpath */
@property (nonatomic, strong) NSIndexPath *selectIndexpath;

/** 用于调整部门 */
@property (nonatomic, assign) BOOL adjust;
/** 用于获取未分配部门 */
@property (nonatomic, assign) BOOL isNoDistribution;

/** 单选 */
@property (nonatomic, strong) HQEmployModel *selectEmployee;

/** 权限 */
@property (nonatomic, assign) BOOL isPermission;


@end

@implementation TFCompanyGroupController

-(NSMutableArray *)selectPeoples{
    if (!_selectPeoples) {
        _selectPeoples = [NSMutableArray arrayWithArray:self.employees];
    }
    return _selectPeoples;
}
-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
        
        
//        for (NSInteger i = 0; i < 10; i ++) {
//            
//            HQDepartmentModel *model = [[HQDepartmentModel alloc] init];
//            
//            model.departmentName = [NSString stringWithFormat:@"部门%ld",i];
//            model.open = @0;
//            
//            NSMutableArray<HQEmployModel> *employs = [NSMutableArray<HQEmployModel> array];
//            for (NSInteger j = 0; j < 5; j++) {
//                
//                HQEmployModel *employ = [[HQEmployModel alloc] init];
//                employ.employeeName = [NSString stringWithFormat:@"张小龙%ld",j];
//                employ.position = [NSString stringWithFormat:@"职务%ld",j];
//                employ.selectState = @0;
//                [employs addObject:employ];
//                
//            }
//            model.employees = employs;
//            [_peoples addObject:model];
//        }
        
    }
    return _peoples;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self.peopleBL requestDepartmentListWithParentDepartmentId:nil];
    
//    self.company.text = [NSString stringWithFormat:@"%@(%ld)",TEXT(UM.userLoginInfo.company.company_name),[[NSUserDefaults standardUserDefaults] integerForKey:CompanyTotalPeople]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    [self setupTableViewHeader];
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
//    [self.peopleBL requestGetDepartmentWithPageNo:1 pageSize:100];
}


#pragma mark - 成员管理四个按钮
- (void)setupFourBtns{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-64-50,SCREEN_WIDTH,50}];
    view.backgroundColor = WhiteColor;
    [self.view addSubview:view];
    view.layer.shadowColor = LightGrayTextColor.CGColor;
    view.layer.shadowOffset = CGSizeMake(0, -1);
    view.layer.shadowRadius = 0.5;
    view.layer.shadowOpacity = 0.5;
    
    NSArray *names = @[@"调整部门",@"更换角色",@"激活提醒",@"停用"];
    
    for (NSInteger i = 0; i < 4; i++) {
        
        UIButton *btn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH/4 * i,0,SCREEN_WIDTH/4,50} target:self action:@selector(btnClicked:)];
        btn.tag = 0x123 + i;
        btn.titleLabel.font = FONT(17);
        [view addSubview:btn];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        [btn setTitle:names[i] forState:UIControlStateHighlighted];
        [btn setTitleColor:GreenColor forState:UIControlStateHighlighted];
        [btn setTitleColor:GreenColor forState:UIControlStateNormal];
    }
    
}

- (void)btnClicked:(UIButton *)button{
    
    if (!self.selectPeoples.count) {
        
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    switch (button.tag-0x123) {
        case 0:
        {
            
            TFDepartmentManageController *depart = [[TFDepartmentManageController alloc] init];
            depart.actionParameter = ^(NSArray *arr){
                
                NSMutableArray *ids = [NSMutableArray array];
                
                for (HQEmployModel *model in self.selectPeoples) {
                    
                    [ids addObject:model.id];
                }
                HQDepartmentModel *depart = arr[0];
                self.adjust = YES;
//                [self.peopleBL requestDepartmentUpdateWithEmployeeIds:ids departmentId:depart.id];
            };
            [self.navigationController pushViewController:depart animated:YES];
        }
            break;
        case 1:
        {
            // 角色类型0其他1所有者2管理员3成员4访客
            for (HQEmployModel *model in self.selectPeoples) {
                
                if ([model.roleType isEqualToNumber:@1]) {
                    [MBProgressHUD showError:@"公司创建者不能变更角色" toView:self.view];
                    return;
                }
            }
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"更换角色" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"所有者",@"管理员",@"成员",@"访客", nil];
            [sheet show];
            
        }
            break;
        case 2:
        {
            [AlertView showAlertView:@"激活提醒" msg:@"发送激活提醒短信给成员" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                
            } onRightTouched:^{
                
//                NSMutableArray *ids = [NSMutableArray array];
//                
                for (HQEmployModel *model in self.selectPeoples) {
                    model.employeeId = model.id;
                }
//                [self.peopleBL requestActiveAlertWithEmployees:self.selectPeoples];
                
            }];
        }
            break;
        case 3:
        {
            [AlertView showAlertView:@"停用成员" msg:@"停用后，将无法登录当前企业" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                
            } onRightTouched:^{
                
                NSMutableArray *ids = [NSMutableArray array];
                
                for (HQEmployModel *model in self.selectPeoples) {
                    
                    [ids addObject:model.id];
        
                }
//                [self.peopleBL requestEmployeeDisabeldWithEmployeeIds:ids disabled:@1];
            }];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    NSMutableArray *ids = [NSMutableArray array];
    // 角色类型0其他1所有者2管理员3成员4访客
    for (HQEmployModel *model in self.selectPeoples) {
        
        [ids addObject:model.id];
        model.roleType = @(buttonIndex+1);
        model.selectState = @0;
        if (buttonIndex == 0) {
            model.roleName = @"所有者";
        }else if (buttonIndex == 1) {
            model.roleName = @"管理员";
        }else if (buttonIndex == 2) {
            model.roleName = @"成员";
        }else if (buttonIndex == 3) {
            model.roleName = @"访客";
        }
    }
    self.adjust = YES;
//    [self.peopleBL requestRoleUpdateWithEmployeeIds:ids roleType:buttonIndex+1];
    
}

#pragma mark - navi
- (void)setupNavigation {
    self.navigationItem.title = @"企业成员";
    
    if (self.type == 0) {
        
        if (self.isPermission) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(createClicked) image:@"菜单" highlightImage:@"菜单"];
        }else{
            
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }else if (self.type == 1) {
        
        [self setupFourBtns];
        
    }else{
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    }
    
}
- (void)createClicked{
    
    [HQTFUploadFileView showAlertView:@"更多操作" withType:4 parameterAction:^(id parameter) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self handleWithType:[parameter integerValue]];
        });
    
    }];
}


- (void)sure{
    
    if (!self.selectPeoples.count) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    
    if (self.actionParameter) {
        [self.navigationController popViewControllerAnimated:NO];
        self.actionParameter(self.selectPeoples);
    }
    
}


- (void)handleWithType:(NSInteger)type{
    switch (type) {
        case 0:
        {
            TFAddCompanyPeopleController *add = [[TFAddCompanyPeopleController alloc] init];
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        case 1:
        {
            TFBarcodeInviteController *barcode = [[TFBarcodeInviteController alloc] init];
            [self.navigationController pushViewController:barcode animated:YES];
        }
            break;
        case 2:
        {
            TFDepartmentManageController *department = [[TFDepartmentManageController alloc] init];
            department.type = 1;
            [self.navigationController pushViewController:department animated:YES];
        }
            break;
        case 3:
        {
            TFCompanyGroupController *group = [[TFCompanyGroupController alloc] init];
            group.type = 1;
            [self.navigationController pushViewController:group animated:YES];
        }
            break;
            
        default:
            break;
    }

}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    if (self.type == 0 || self.type == 2) {
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    }else{
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 50, 0);
    }
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)setupTableViewHeader{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-15,40}];
    [view addSubview:label];
    label.textColor = LightGrayTextColor;
    label.font = FONT(14);
    label.text = @"";
    self.company = label;
    
    
    if (self.type == 0 || self.type == 1) {
        self.tableView.tableHeaderView = view;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.peoples.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HQDepartmentModel *model = self.peoples[section];
    if ([model.open isEqualToNumber:@0]) {
        return 1;
    }else{
        return 1+model.employees.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    HQDepartmentModel *model = self.peoples[indexPath.section];
    
    if (indexPath.row == 0) {
        TFPeopleManageDepartmentCell *cell = [TFPeopleManageDepartmentCell peopleManageDepartmentCellWithTableView:tableView];
        [cell refreshPeopleManageDepartmentCellWithModel:model];
        return cell;
        
    }else{
        TFPeopleManagePeopleCell *cell = [TFPeopleManagePeopleCell peopleManagePeopleCellWithTableView:tableView];
        [cell refreshPeopleManagePeopleCellWithModel:model.employees[indexPath.row-1] type:self.type];
        
        if (indexPath.row == model.employees.count) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        
        return  cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    HQDepartmentModel *model = self.peoples[indexPath.section];
    
    
    if (indexPath.row == 0) {
        
        self.selectIndexpath = indexPath;
        
        if ([model.open isEqualToNumber:@0] || model.open == nil) {
            
            model.open = @1;
            
            if (self.adjust) {
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                [self.peopleBL requestGetEmployeeByParamWithPageNo:1 pageSize:10000 departmentId:model.id isNo:nil];
            }else{
                
                if (model.employees == nil) {
                    
                    if (indexPath.section == 0) {
                        
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                        [self.peopleBL requestGetEmployeeByParamWithPageNo:1 pageSize:10000 departmentId:nil isNo:@0];
                    }else{
                        
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        self.isNoDistribution = NO;
//                        [self.peopleBL requestGetEmployeeByParamWithPageNo:1 pageSize:10000 departmentId:model.id isNo:nil];
                    }
                    
                }else{
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            
        }else{
            
            model.open = @0;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }else{
        
        HQEmployModel *employee = model.employees[indexPath.row-1];
        if (self.type == 1 || self.type == 2) {// 管理
            
            if (!self.isSingle) {
                
                employee.selectState = ([employee.selectState isEqualToNumber:@0] || employee.selectState == nil)?@1:@0;
                
                NSMutableArray *allPeople = [NSMutableArray array];
                
                for (HQDepartmentModel *model in self.peoples) {
                    
                    for (HQEmployModel *employ in model.employees) {
                        
                        [allPeople addObject:employ];
                    }
                }
                
                [self.selectPeoples removeAllObjects];
                for (HQEmployModel *emp in allPeople) {
                    
                    if (emp.selectState != nil && [emp.selectState isEqualToNumber:@1]) {
                        [self.selectPeoples addObject:emp];
                    }
                }
                
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                
                if (!self.selectEmployee) {
                    
                    for (HQDepartmentModel *model in self.peoples) {
                        for (HQEmployModel *employee in model.employees) {
                            
                            employee.selectState = @0;
                        }
                    }

                }
                
                self.selectEmployee.selectState = @0;
                employee.selectState = @1;
                
                self.selectEmployee = employee;
                
                [self.selectPeoples removeAllObjects];
                [self.selectPeoples addObject:employee];
                
                [tableView reloadData];
            }
            
        }else{
            TFChatPeopleInfoController *peopleInfo = [[TFChatPeopleInfoController alloc] init];
            peopleInfo.employee = employee;
            [self.navigationController pushViewController:peopleInfo animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 50;
    }
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
