//
//  HQTFTaskOptionController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskOptionController.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQTFPeopleCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFThreeLabelCell.h"
#import "HQTFAddPeopleController.h"
#import "HQTFChoicePeopleController.h"
#import "HQTFProjectDescController.h"
#import "HQTFRepeatRowController.h"
#import "HQTFEndTimeController.h"
#import "AlertView.h"
#import "TFProjectBL.h"

@interface HQTFTaskOptionController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQSwitchCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 任务列表选项 */
@property (nonatomic, strong) HQTFOptionModel *option;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** permission 0:无管理公开项目权限 1：不公开 */
@property (nonatomic, assign) BOOL manageOpenPermission;

@end

@implementation HQTFTaskOptionController

-(HQTFOptionModel *)option{
    
    if (!_option) {
        _option = [[HQTFOptionModel alloc] init];
    }
    return _option;
}

-(void)setListItem:(TFProjectSeeModel *)listItem{
    
    _listItem = listItem;
    self.option.id = listItem.listId;
    self.option.projectId = listItem.project.id;
    self.option.listName = listItem.listName;
    self.option.isPublic = listItem.isPublic;
    self.option.principalId = listItem.principalId;
    self.option.principalName = listItem.principalName;
    self.option.principalPosition = listItem.principalPosition;
    self.option.principalPhotograph = listItem.principalPhotograph;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupTableView];
    [self setupNavigation];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    [self.projectBL getPermissionWithModuleId:@1110];
}

#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
    
    self.navigationItem.title = @"任务列表选项";
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    if ([self.listItem.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.listItem.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    [self.projectBL requestUpdateTaskListWithModel:self.option];
   
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
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }
    return 1;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 0x12345) {
        if (textView.text.length >= 20) {
            
            self.option.listName = [textView.text substringToIndex:20];
            textView.text = self.option.listName;
            [MBProgressHUD showError:@"20个字以内" toView:self.view];
        }else{
            
            self.option.listName = textView.text;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"任务列表名称20个字以内(必填)";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(20);
        cell.textVeiw.text = self.option.listName;
        cell.textVeiw.tag = 0x12345;
        cell.bottomLine.hidden = YES;
        cell.textVeiw.userInteractionEnabled = NO;
        
        return cell;
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            HQTFPeopleCell *cell = [HQTFPeopleCell peopleCellWithTableView:tableView];
            cell.titleLabel.text = @"负责人";
            if (!self.option.principalId) {
                cell.contentLabel.text = @"请添加负责人";
                cell.contentLabel.textColor = PlacehoderColor;
                cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                cell.peoples = @[];
            }else{
                cell.contentLabel.text = @"";
                cell.contentLabel.textColor = LightBlackTextColor;
                cell.contentLabel.textAlignment = NSTextAlignmentRight;
                HQEmployModel *model = [[HQEmployModel alloc] init];
                model.id = self.listItem.principalId;
                model.employeeName = self.listItem.principalName;
                model.position = self.listItem.principalPosition;
                model.photograph = self.listItem.principalPhotograph;
                cell.peoples = @[model];
            }
            
            cell.bottomLine.hidden = NO;
            return cell;
        }else{
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            [cell.switchBtn setOnImage:[HQHelper createImageWithColor:GreenColor]];
            cell.title.text = @"仅列表成员可见";
            cell.switchBtn.on = [self.option.isPublic integerValue]==0?NO:YES;
            return cell;
            
        }
//        else if (indexPath.row == 2) {
//            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
//            cell.timeTitle.text = @"截止日期";
//            cell.arrowShowState = YES;
//            if (!self.option.endTime) {
//                cell.time.text = @"请选择";
//                cell.time.textColor = PlacehoderColor;
//            }else{
//                cell.time.text = [HQHelper nsdateToTime:[self.option.endTime longLongValue] formatStr:@"yyyy-MM-dd"];
//                cell.time.textColor = LightBlackTextColor;
//            }
//            return  cell;
//        }else{
//            
//            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
//            cell.timeTitle.text = @"重复列表";
//            cell.arrowShowState = YES;
//            if (!self.option.repeat) {
//                cell.time.text = @"请选择";
//                cell.time.textColor = PlacehoderColor;
//            }else{
//                cell.time.text = self.option.repeat;
//                cell.time.textColor = LightBlackTextColor;
//            }
//            return  cell;
//            
//            
//        }
    }else{
        
        HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
        cell.leftLabel.text = @"";
        cell.rightLabel.text = @"";
        cell.middleLabel.textColor = GreenColor;
        cell.middleLabel.text = @"删除列表";
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.listItem.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    if ([self.listItem.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    // 100=列表重命名、删除列表、仅列表成员可见
    // 101=切换列表负责人、列表重命名、删除列表、仅列表成员可见
    
    if ([self.listItem.project.isPublic isEqualToNumber:@1]) {
        
        if (self.manageOpenPermission) {
            
            // 有权限
            
        }else{
            
            BOOL contain = NO;// 判断权限
            for (NSNumber *num in self.listItem.listPermissions) {
                
                if ([num isEqualToNumber:@101]) {
                    contain = YES;
                }
            }
            
            if (!contain) {
                
                [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                return;
            }
        }
        
    }else{
        
        BOOL contain = NO;// 判断权限
        for (NSNumber *num in self.listItem.listPermissions) {
            
            if ([num isEqualToNumber:@101]) {
                contain = YES;
            }
        }
        
        if (!contain) {
            
            [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
            return;
        }
    }
    

    
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {// 指派
            
//            HQTFChoicePeopleController *choice = [[HQTFChoicePeopleController alloc] init];
//            choice.isMutual = NO;
//            if (self.option.principalId) {
//                
//                HQEmployModel *model = [[HQEmployModel alloc] init];
//                model.id = self.listItem.principalId;
//                model.employeeName = self.listItem.principalName;
//                model.position = self.listItem.principalPosition;
//                model.photograph = self.listItem.principalPhotograph;
//                choice.employees = @[model];
//            }else{
//                
//                choice.employees = @[];
//            }
//            
//            choice.sectionTitle = @"列表负责人";
//            choice.rowTitle = @"添加负责人";
//            choice.type = ChoicePeopleTypeProjectTaskListPrincipal;
//            choice.isMutual = NO;
//            choice.Id = self.listItem.project.id;
//            choice.projectItem = self.listItem.project;
//            if (self.option.principalId == nil) {
//                choice.instantPush = YES;
//            }
//            
//            choice.actionParameter = ^(NSArray *people){
//              
//                
//                NSMutableArray *ids = [NSMutableArray array];
//                for (HQEmployModel *employ  in people) {
//                    [ids addObject:employ.id?employ.id:employ.employeeId];
//                }
//                
////                [self.projectBL requestUpdateTaskListPrincipalWithTaskListId:self.option.id addEmployeeIds:ids];
//                if (people.count) {
//                    HQEmployModel *employ = people[0];
//                    self.option.principalId = employ.id?employ.id:employ.employeeId;
//                    self.option.principalName = employ.employeeName;
//                    self.option.principalPosition = employ.position;
//                    self.option.principalPhotograph = employ.photograph;
//                    
//                    self.listItem.principalId = employ.id?employ.id:employ.employeeId;
//                    self.listItem.principalName = employ.employeeName;
//                    self.listItem.principalPosition = employ.position;
//                    self.listItem.principalPhotograph = employ.photograph;
//                }
//                
//                [self.tableView reloadData];
//            };
//            
//            [self.navigationController pushViewController:choice animated:NO];
        
            
            HQTFAddPeopleController *addPeople = [[HQTFAddPeopleController alloc] init];
            if (self.option.principalId) {
                
                HQEmployModel *model = [[HQEmployModel alloc] init];
                model.id = self.listItem.principalId;
                model.employeeName = self.listItem.principalName;
                model.position = self.listItem.principalPosition;
                model.photograph = self.listItem.principalPhotograph;
                addPeople.employees = @[model];
            }else{
                
                addPeople.employees = @[];
            }
            
            addPeople.type = ChoicePeopleTypeProjectTaskListPrincipal;
            addPeople.isMutual = NO;
            addPeople.Id = self.listItem.project.id;
            addPeople.projectItem = self.listItem.project;
            addPeople.actionParameter = ^(NSArray *peoples){
                
                NSMutableArray *ids = [NSMutableArray array];
                for (HQEmployModel *employ  in peoples) {
                    [ids addObject:employ.id?employ.id:employ.employeeId];
                }

                if (peoples.count) {
                    HQEmployModel *employ = peoples[0];
                    self.option.principalId = employ.id?employ.id:employ.employeeId;
                    self.option.principalName = employ.employeeName;
                    self.option.principalPosition = employ.position;
                    self.option.principalPhotograph = employ.photograph;

                    self.listItem.principalId = employ.id?employ.id:employ.employeeId;
                    self.listItem.principalName = employ.employeeName;
                    self.listItem.principalPosition = employ.position;
                    self.listItem.principalPhotograph = employ.photograph;
                }
                
                [self.tableView reloadData];
                
            };
            
            [self.navigationController pushViewController:addPeople animated:YES];
        }
        
        if (indexPath.row == 2) {
            HQTFEndTimeController *end = [[HQTFEndTimeController alloc] init];
            [self.navigationController pushViewController:end animated:YES];
        }
        if (indexPath.row == 3) {
            HQTFRepeatRowController *repeat = [[HQTFRepeatRowController alloc] init];
            [self.navigationController pushViewController:repeat animated:YES];
        }
    }
    
    if (indexPath.section == 0) {
        
        HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
        desc.type = 1;
        desc.descString = self.option.listName;
        desc.naviTitle = @"列表名称";
        desc.sectionTitle = @"列表名称";
        desc.placehoder = @"20字以内";
        desc.wordNum = 20;
        desc.descAction = ^(NSString *time){
            
            self.option.listName = time;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:desc animated:YES];
    }
    
    if (indexPath.section == 2) {
        [AlertView showAlertView:@"删除列表" msg:@"删除后该列表无法恢复" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
            
        } onRightTouched:^{
            
            [self.projectBL requestDelProjTaskListWithProjTaskListId:self.option.id];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 90;
    }
    
    return 55;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else if (section == 2){
        return 20;
    }
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

#pragma mark -

-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if ([self.listItem.project.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        [self.tableView reloadData];
        return;
    }
    if ([self.listItem.project.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        [self.tableView reloadData];
        return;
    }
    
    // 100=列表重命名、删除列表、仅列表成员可见
    // 101=切换列表负责人、列表重命名、删除列表、仅列表成员可见
    
    if ([self.listItem.project.isPublic isEqualToNumber:@1]) {
        
        if (self.manageOpenPermission) {
            
            // 有权限
            
        }else{
            
            BOOL contain = NO;// 判断权限
            for (NSNumber *num in self.listItem.listPermissions) {
                
                if ([num isEqualToNumber:@101]) {
                    contain = YES;
                }
            }
            
            if (!contain) {
                
                [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                return;
            }
        }
        
    }else{
        
        BOOL contain = NO;// 判断权限
        for (NSNumber *num in self.listItem.listPermissions) {
            
            if ([num isEqualToNumber:@101]) {
                contain = YES;
            }
        }
        
        if (!contain) {
            
            [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
            return;
        }
    }
    
    switchButton.on = !switchButton.on;

    self.option.isPublic = switchButton.on?@1:@0;
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_updateTaskList) {
        
        self.listItem.listName = self.option.listName;
        self.listItem.isPublic = self.option.isPublic;
        self.listItem.principalId = self.option.principalId;
        self.listItem.principalName = self.option.principalName;
        self.listItem.principalPosition = self.option.principalPosition;
        self.listItem.principalPhotograph = self.option.principalPhotograph;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if (resp.cmdId == HQCMD_delProjTaskList) {
        
        if (self.actionParameter) {
            self.actionParameter(self.listItem);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_updateTaskListPrincipal) {
        
//        self.option.managers = [NSMutableArray arrayWithArray:self.addPeoples];
//        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_getPermission) {
        
        for (TFPermissionModel *model in resp.body) {
            
            if ([model.code isEqualToNumber:@111003]) {
                self.manageOpenPermission = YES;
                break;
            }
        }
        
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    
    if (resp.cmdId == HQCMD_addOrUpdateProjCategory) {
        

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
