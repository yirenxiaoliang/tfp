//
//  TFContactsWorkFrameController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFContactsWorkFrameController.h"
#import "TFSelectPeopleElementCell.h"
#import "TFContactHeaderView.h"
#import "HQTFSearchHeader.h"
#import "TFFilePathView.h"
#import "TFPeopleBL.h"
#import "TFAllSelectView.h"
#import "TFFilePathView.h"
#import "TFChangeHelper.h"
#import "TFPersonalMaterialController.h"
#import "TFSearchPeopleController.h"
#import "TFContactorInfoController.h"

@interface TFContactsWorkFrameController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,TFFilePathViewDelegate,HQBLDelegate,TFSelectPeopleElementCellDelegate,TFAllSelectViewDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** 组织架构树 */
@property (nonatomic, strong) NSArray * dataList;

/** allSelectView */
@property (nonatomic, strong) TFAllSelectView *allSelectView ;

@end

@implementation TFContactsWorkFrameController

-(NSMutableArray *)paths{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.isSee) return;
    
    [self departmentStatusInfo];
    
    // 显示选中
    [self showSelectNum];
    
    // 显示全选
    [self showIsAllSelect];
    
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupTableViewHeader];
    [self setupNavi];
    [self setupAllSelectView];
    
    if (!self.department) {
        
        self.peopleBL = [TFPeopleBL build];
        self.peopleBL.delegate = self;
        [self.peopleBL requestCompanyFrameworkWithCompanyId:[UM.userLoginInfo.company.id description] dismiss:self.dismiss];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllSelectView:) name:SelectPeopleRefreshNotification object:nil];

    
    if (self.isSingleSelect || self.isSee) {
        self.allSelectView.hidden = YES;
        self.tableView.height = SCREEN_HEIGHT-NaviHeight;
    }
}


- (void)setupAllSelectView{
    
    TFAllSelectView *allSelectView = [TFAllSelectView allSelectView];
    allSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomHeight, SCREEN_WIDTH, BottomHeight);
    [self.view addSubview:allSelectView];
    allSelectView.delegate = self;
    self.allSelectView = allSelectView;
    
}

#pragma mark - TFAllSelectViewDelegate
-(void)allSelectViewDidClickedAllSelectBtn:(UIButton *)selectBtn{
    
    
    if (self.department) {
        
        
        if (selectBtn.selected) {
            
            self.department.select = @1;
        }else{
            
            self.department.select = @0;
        }
        
        [self selectPeopleWithDepartment:self.department];
        
    }else{
        
        for (TFDepartmentModel *model in self.dataList) {
            
            if ([model.select isEqualToNumber:@2]) {
                continue;
            }
            if (selectBtn.selected) {
                
                model.select = @1;
            }else{
                
                model.select = @0;
                
            }
            
            [self selectPeopleWithDepartment:model];
        }
        
    }
    [self.tableView reloadData];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@0 forKey:@"type"];
    [dict setObject:[self sureAllSelectAndSelectPeopleNum] forKey:@"peoples"];
    [dict setObject:@([self allPeoplesNum]) forKey:@"allCount"];
    
    self.fourSelects[0] = dict;
    
    // 显示选中
    [self showSelectNum];
    
    // 显示全选
    [self showIsAllSelect];
    
    // 发送刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectPeopleRefreshNotification object:dict];
    
}

- (void)refreshAllSelectView:(NSNotification *)note{
    
    // 显示选中
    [self showSelectNum];
    
    // 显示全选
    [self showIsAllSelect];
}


#pragma mark - Navigation
- (void)setupNavi{
    
    self.navigationItem.title = @"组织架构";
    if (self.isSee) return;
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    self.navigationItem.title = @"请选择";
}

- (void)sure{
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.actionParameter) {
        self.actionParameter(self.fourSelects);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectFinishNotification" object:nil];
}

#pragma mark - 头部
- (void)setupTableViewHeader{
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,84}];
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.delegate = self;
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    header.backgroundColor = WhiteColor;
    header.button.backgroundColor = BackGroudColor;
    
    TFFilePathView *pathView = [[TFFilePathView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,40} models:self.paths];
    [headerView addSubview:pathView];
    pathView.delegate = self;
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - HQTFSearchHeaderDelegate
- (void)searchHeaderClicked{
    
    TFSearchPeopleController *search = [[TFSearchPeopleController alloc] init];
    search.isSee = self.isSee;
    search.isSingleSelect = self.isSingleSelect;
    search.departmentId = self.department.id;
    search.actionParameter = ^(NSArray *parameter) {
      
        NSDictionary *dict = self.fourSelects[0];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[dict valueForKey:@"peoples"]];
        [arr addObjectsFromArray:parameter];
        
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setObject:@0 forKey:@"type"];
        [dict1 setObject:arr forKey:@"peoples"];
        self.fourSelects[0] = dict1;
        
        
        for (TFEmployModel *model in [dict1 valueForKey:@"peoples"]) {
            
            for (TFDepartmentModel *depart in self.dataList) {
                
                [self employeeSelected:model inDepartment:depart select:@1];
                
            }
        }
        
        for (HQEmployModel *model in self.noSelectPoeples) {
            
            for (TFDepartmentModel *depart in self.dataList) {
                
                [self employeeSelected:[TFChangeHelper hqEmployeeToTfEmployee:model] inDepartment:depart select:@2];
                
            }
        }
        
        [self departmentStatusInfo];
        
        // 显示选中
        [self showSelectNum];
        
        // 显示全选
        [self showIsAllSelect];
        
        
        [self.tableView reloadData];

        
        
    };
    [self.navigationController pushViewController:search animated:YES];
    
}

#pragma mark - TFFilePathViewDelegate
- (void)selectFilePathWithModel:(TFFilePathModel *)mdoel{
    
    
    NSArray *arr = self.navigationController.childViewControllers;
    
    for (HQBaseViewController *vc  in arr) {
        
        if ([vc isKindOfClass:mdoel.className]) {
            
            if (vc.vcTag == mdoel.vcTag) {
                
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
        
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-TabBarHeight-BottomM) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.department) {
        return 2;
    }else{
        
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.department) {
        
        if (section == 0) {
            
            return self.department.childList.count;
        }else{
            
            return self.department.users.count;
        }
    }else{
        
        return self.dataList.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.department) {
        
        if (indexPath.section == 0) {
            
            TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.row];
            cell.delegate = self;
            TFDepartmentModel *model = self.department.childList[indexPath.row];
            [cell refreshCellWithDepartmentModel:model isSingle:self.isSee?YES:self.isSingleSelect];
            cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
            return cell;
            
        }else{
            
            TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.section * 999 + indexPath.row];
            cell.delegate = self;
            TFEmployModel *model = self.department.users[indexPath.row];
            [cell refreshCellWithEmployeeModel:model isSingle:self.isSee?YES:NO];
            cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
            if (indexPath.row == 0) {
                cell.topLine.hidden = YES;
            }else{
                cell.topLine.hidden = NO;
            }
            return cell;
            
        }
        
    }else{
        
        TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.row];
        cell.delegate = self;
        TFDepartmentModel *model = self.dataList[indexPath.row];
        [cell refreshCellWithDepartmentModel:model isSingle:self.isSee?YES:self.isSingleSelect];
        cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
        return cell;
        
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.department) {
        
        if (indexPath.section == 0) {
            
            
            TFDepartmentModel *model = self.department.childList[indexPath.row];
            
            if (model.users.count == 0 && model.childList.count == 0) {
                return;
            }
            TFContactsWorkFrameController *frameWork = [[TFContactsWorkFrameController alloc] init];
            frameWork.isSee = self.isSee;
            [frameWork.paths addObjectsFromArray:self.paths];
            
            
            TFFilePathModel *path = [[TFFilePathModel alloc] init];
            path.name = model.name;
            if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
                path.className = [TFContactsWorkFrameController class];
                HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
                path.vcTag = vc.vcTag + 1;
            }else{
                
                path.className = [TFContactsWorkFrameController class];
                path.vcTag = self.vcTag + 1;
            }
            [frameWork.paths addObject:path];
            
            frameWork.department = model;
            frameWork.vcTag = self.vcTag + 1;
            frameWork.companyFrameWorks = self.companyFrameWorks;
            
            frameWork.fourSelects = self.fourSelects;
            frameWork.actionParameter = ^(id parameter) {
                
                if (self.actionParameter) {
                    self.actionParameter(self.fourSelects);
                }
            };
            frameWork.isSingleSelect = self.isSingleSelect;
            [self.navigationController pushViewController:frameWork animated:YES];
            
            
        }else{
            
            if (self.isSee) {
                
                TFEmployModel *model = self.department.users[indexPath.row];
                
//                TFPersonalMaterialController *personMaterial = [[TFPersonalMaterialController alloc] init];
//                personMaterial.signId = model.sign_id;
//                [self.navigationController pushViewController:personMaterial animated:YES];
                
                TFContactorInfoController *personMaterial = [[TFContactorInfoController alloc] init];
                
                personMaterial.signId = model.sign_id;
                
                [self.navigationController pushViewController:personMaterial animated:YES];
                
                
                
            }else{
                
                TFSelectPeopleElementCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                [self selectPeopleElementCellDidClickedSelectBtn:cell.selectBtn];
                
            }
        }
        
        
    }else{
        
        TFDepartmentModel *model = self.dataList[indexPath.row];
        
        if (model.users.count == 0 && model.childList.count == 0) {
            return;
        }
        TFContactsWorkFrameController *frameWork = [[TFContactsWorkFrameController alloc] init];
        
        frameWork.isSee = self.isSee;
        [frameWork.paths addObjectsFromArray:self.paths];
        
        TFFilePathModel *path = [[TFFilePathModel alloc] init];
        path.name = model.name;
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
            path.className = [TFContactsWorkFrameController class];
            HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
            path.vcTag = vc.vcTag + 1;
        }else{
            
            path.className = [TFContactsWorkFrameController class];
            path.vcTag = self.vcTag + 1;
        }
        [frameWork.paths addObject:path];
        
        frameWork.department = model;
        frameWork.vcTag = self.vcTag + 1;
        frameWork.companyFrameWorks = self.companyFrameWorks;
        frameWork.fourSelects = self.fourSelects;
        frameWork.actionParameter = ^(id parameter) {
            
            if (self.actionParameter) {
                self.actionParameter(self.fourSelects);
            }
        };
        frameWork.isSingleSelect = self.isSingleSelect;
        [self.navigationController pushViewController:frameWork animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 55;
    }
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        if (self.department.childList.count) {
            
            return 8;
        }
    }
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


#pragma mark - TFSelectPeopleElementCellDelegate
-(void)selectPeopleElementCellDidClickedSelectBtn:(UIButton *)selectBtn{
    
    NSInteger section = selectBtn.tag / 0x999;
    NSInteger row = selectBtn.tag % 0x999;
    
    if (self.isSingleSelect) {
        
        TFEmployModel *employee = self.department.users[row];
        if ([employee.select isEqualToNumber:@2]) {
            
            return;
        }
        
        // 取消所选择的
        // 1.拿到所有人
        NSMutableArray *peoples = [NSMutableArray array];
        
        for (TFDepartmentModel *depart in self.companyFrameWorks) {
            
            [peoples addObjectsFromArray:[self getDepartmentPeopleWithDepartment:depart]];
            
        }
        
        // 2.取消选择
        for (TFEmployModel *e in peoples) {
            
            if ([e.select isEqualToNumber:@2]) {
                continue;
            }else{
                e.select = @0;
            }
        }
        
        // 选中当前的（只能是人员）
        employee.select = @1;
        
        
        [self.tableView reloadData];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:@0 forKey:@"type"];
        [dict setObject:[self sureAllSelectAndSelectPeopleNum] forKey:@"peoples"];
        [dict setObject:@([self allPeoplesNum]) forKey:@"allCount"];
        
        self.fourSelects[0] = dict;
        
        // 显示选中
        [self showSelectNum];
        
        // 显示全选
        [self showIsAllSelect];
        
        // 发送刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:SelectPeopleRefreshNotification object:dict];
        
        return;
    }
    
    
    
    if (self.department) {// 子级
        
        if (section == 0) {// 部门
            
            TFDepartmentModel *department = self.department.childList[row];
            
            if ([department.select isEqualToNumber:@2]) {
                
                return;
            }else{
                
                department.select = [department.select isEqualToNumber:@1] ? @0 : @1;
            }
            
            [self selectPeopleWithDepartment:department];
            
        }else{// 人员
            TFEmployModel *employee = self.department.users[row];
            if ([employee.select isEqualToNumber:@2]) {
                
                return;
            }else{
                
                employee.select = [employee.select isEqualToNumber:@1] ? @0 : @1;
            }
            
        }
        
        BOOL all = [self selectToOverallAffectWithDepartment:self.department];
        
        self.allSelectView.allSelectBtn.selected = all;
        
        [self departmentStatusInfo];
        
    }else{// 主级
        
        TFDepartmentModel *department = self.dataList[row];
        if ([department.select isEqualToNumber:@2]) {
            
            return;
        }else{
            
            department.select = [department.select isEqualToNumber:@1] ? @0 : @1;
        }
        [self selectPeopleWithDepartment:department];
        
        BOOL all = YES;
        
        for (TFDepartmentModel *de in self.dataList) {
            
            if ([de.select isEqualToNumber:@0]) {
                all = NO;
                break;
            }
        }
        
        self.allSelectView.allSelectBtn.selected = all;
        
    }
    
    
    [self.tableView reloadData];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@0 forKey:@"type"];
    [dict setObject:[self sureAllSelectAndSelectPeopleNum] forKey:@"peoples"];
    [dict setObject:@([self allPeoplesNum]) forKey:@"allCount"];
    
    self.fourSelects[0] = dict;
    
    // 显示选中
    [self showSelectNum];
    
    // 显示全选
    [self showIsAllSelect];
    
    // 发送刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectPeopleRefreshNotification object:dict];
}


/** 选中或取消某个部门所有成员及子部门 */
- (void)selectPeopleWithDepartment:(TFDepartmentModel *)department{
    
    for (TFDepartmentModel *model in department.childList) {
        
        model.select = department.select;
        
        [self selectPeopleWithDepartment:model];
        
    }
    
    for (TFEmployModel *employ in department.users) {
        
        if ([employ.select isEqualToNumber:@2]) {
            continue;
        }
        
        employ.select = department.select;
    }
    
}

/** 选择对整个部门的影响 返回是否全选 */
-(BOOL)selectToOverallAffectWithDepartment:(TFDepartmentModel *)department{
    
    BOOL allSelect = YES;
    for (TFDepartmentModel *obj in department.childList) {
        
        if ([obj.select isEqualToNumber:@0]) {
            
            allSelect = NO;
            break;
        }
        
    }
    if (allSelect) {
        
        for (TFEmployModel *obj in department.users) {
            
            
            if ([obj.select isEqualToNumber:@0]) {
                
                allSelect = NO;
                break;
            }
            
        }
    }
    
    if (allSelect) {
        
        department.select = @1;
        return YES;
    }else{
        department.select = @0;
        return NO;
    }
    
}




/** 判断某个部门是否全部选中（包括子部门） */
- (BOOL)selectStatusWithDepartment:(TFDepartmentModel *)department{
    
#warning 修改再次进入全选未选中bug注释的代码（仅修改此处），不知对其他有何影响
    if (department.childList.count == 0 && department.users.count == 0) {// 没有子部门和员工时，它的选中取决于自身（最后一级部门可能的状态）

        return YES;
    }
//    if (department.childList.count == 0 && department.users.count == 0) {// 没有子部门和员工时，它的选中取决于自身（最后一级部门可能的状态）
//
//        return [department.select isEqualToNumber:@1] ? YES : NO;
//    }
    
    BOOL select = YES;
    
    for (TFEmployModel *employ in department.users) {
        
        if (!employ.select || [employ.select isEqualToNumber:@0]) {
            return select = NO;
        }
    }
    
    for (TFDepartmentModel *model in department.childList) {
        
        select = [self selectStatusWithDepartment:model];
        if (!select) {
            return select;
        }
    }
    
    if (select) {
        department.select = @1;
    }else{
        department.select = @0;
    }
    
    return select;
}

/** 确定部门和员工的选中情况 */
- (void)departmentStatusInfo{
    
    for (id obj in self.companyFrameWorks) {
        
        if ([obj isKindOfClass:[TFDepartmentModel class]]) {
            TFDepartmentModel *depart = obj;
            
            if ([self selectStatusWithDepartment:depart]) {
                
                depart.select = @1;
                [self selectPeopleWithDepartment:depart];
            }else{
                depart.select = @0;
            }
        }
    }
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
       
    if (resp.cmdId == HQCMD_companyFramework) {
        
        [self handleLevelWithDepartments:resp.body level:@0];
        self.dataList = [self handleDataListWithDepartments:resp.body];
        
        NSDictionary *dict = self.fourSelects[0];
        
        for (TFEmployModel *model in [dict valueForKey:@"peoples"]) {
            
            for (TFDepartmentModel *depart in self.dataList) {
                
                [self employeeSelected:model inDepartment:depart select:@1];
                
            }
        }
        
        for (HQEmployModel *model in self.noSelectPoeples) {
            
            for (TFDepartmentModel *depart in self.dataList) {
                
                [self employeeSelected:[TFChangeHelper hqEmployeeToTfEmployee:model] inDepartment:depart select:@2];
                
            }
        }
       
        if (self.dismiss == nil) {
            self.department = self.dataList.firstObject; // 此处20190624添加此句代码
        }
        
        self.companyFrameWorks = self.dataList;
        [self departmentStatusInfo];
        
        // 显示选中
        [self showSelectNum];
        
        // 显示全选
        [self showIsAllSelect];
        
        if (self.isMianDepartment) {
            
            if ([self seekMainDepartmentId]) {// 找到主部门
                
                // 换成主部门的数据
                TFDepartmentModel *deaprt = [self findDepartmentWithDepartmentId:[self seekMainDepartmentId] departments:self.dataList];
                if (deaprt) {
                    self.department = deaprt;
                }else{
                    if (deaprt) {
                        self.dataList = [NSMutableArray arrayWithObject:deaprt];
                    }
                }
                
            }
        }
        
        [self.tableView reloadData];
    }
    
}

- (NSNumber *)seekMainDepartmentId{
    
    
    NSArray *arr = [UM.userLoginInfo.departments allObjects];
    // 主部门id
    NSNumber *departmentId = nil;
    for (TFDepartmentCModel *model in arr) {
        
        if ([model.is_main isEqualToString:@"1"]) {// 找到主部门
            
            departmentId = model.id;
            break;
        }
    }
    return departmentId;
    
}

/** 找到某部门
 *
 *  @prama departmentId 某部门id
 *  @prama departmentId 部门范围
 *
 */
- (TFDepartmentModel *)findDepartmentWithDepartmentId:(NSNumber *)departmentId departments:(NSArray *)departments{
    
    TFDepartmentModel *department = nil;
    for (TFDepartmentModel *depart in departments) {
        
        if ([departmentId integerValue] == [depart.id integerValue]) {
            
            department = depart;
            break;
        }
        
        if (depart.childList.count) {
            
            department = [self findDepartmentWithDepartmentId:departmentId departments:depart.childList];
            
            if (department) {
                break;
            }
        }
    }
    
    return department;
}



/** 显示是否全选 */
- (void)showIsAllSelect{
    
    if (self.department) {
        
        self.department.select = [self selectStatusWithDepartment:self.department]?@1:@0;
        
        
        if ([self.department.select isEqualToNumber:@1]) {
            self.allSelectView.allSelectBtn.selected = YES;
        }else{
            self.allSelectView.allSelectBtn.selected = NO;
        }
    }else{
        
        BOOL all = YES;
        for (TFDepartmentModel *model in self.dataList) {
            
            all = [self selectStatusWithDepartment:model];
            if (!all) {
                break;
            }
        }
        
        self.allSelectView.allSelectBtn.selected = all;
        
    }
    
}


/** 显示已选择：多少 */
- (void)showSelectNum{
    
    NSInteger num = 0;
    // 组织架构中的
    num += [self sureAllSelectAndSelectPeopleNum].count;
    
    // 部门中的
    NSDictionary *dict1 = self.fourSelects[1];
    NSArray *arr1 = [dict1 valueForKey:@"peoples"];
    num += arr1.count;
    
    // 角色中的
    NSDictionary *dict2 = self.fourSelects[2];
    NSArray *arr2 = [dict2 valueForKey:@"peoples"];
    num += arr2.count;
    
    
    // 动态参数中的
    NSDictionary *dict3 = self.fourSelects[3];
    NSArray *arr3 = [dict3 valueForKey:@"peoples"];
    num += arr3.count;
    
    
    self.allSelectView.numLabel.text = [NSString stringWithFormat:@"已选择：%ld",num];
}



/** 组织架构中选中的人 */
- (NSMutableArray *)sureAllSelectAndSelectPeopleNum{
    
    NSMutableArray *peoples = [NSMutableArray array];
    
    for (TFDepartmentModel *depart in self.companyFrameWorks) {
        
        [peoples addObjectsFromArray:[self getDepartmentPeopleWithDepartment:depart]];
       
    }
    
    NSMutableArray *selects = [NSMutableArray array];
    for (TFEmployModel *employee in peoples) {
        if ([employee.select isEqualToNumber:@1]) {// 已选择
            
            BOOL have = NO;
            for (TFEmployModel *em in selects) {// 去重
                
                if ([em.id isEqualToNumber:employee.id]) {
                    have = YES;
                    break;
                }
            }
            
            if (!have) {
                [selects addObject:employee];
            }
            
        }
    }
    
    return selects;
    
}

/** 拿到某部门的全部人员(包括子部门) */
- (NSMutableArray *)getDepartmentPeopleWithDepartment:(TFDepartmentModel *)department{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObjectsFromArray:department.users];
    
    for (TFDepartmentModel *de in department.childList) {
        
        [arr addObjectsFromArray:[self getDepartmentPeopleWithDepartment:de]];
    }
    
    return arr;
}

/** 组织架构中的人数 */
- (NSInteger)allPeoplesNum{
    
    
    NSMutableArray *peoples = [NSMutableArray array];
    
    for (TFDepartmentModel *depart in self.companyFrameWorks) {
        
        [peoples addObjectsFromArray:[self getDepartmentPeopleWithDepartment:depart]];
        
    }
    
    NSMutableArray *selects = [NSMutableArray array];
    for (TFEmployModel *employee in peoples) {
            
        BOOL have = NO;
        for (TFEmployModel *em in selects) {// 去重
            
            if ([em.id isEqualToNumber:employee.id]) {
                have = YES;
                break;
            }
        }
        
        if (!have) {
            [selects addObject:employee];
        }
        
    }
    
    return selects.count;
}


-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


/** 选择在某部门被选中 */
-(void)employeeSelected:(TFEmployModel *)employ inDepartment:(TFDepartmentModel *)department select:(NSNumber *)select{
    
    for (TFEmployModel *em in department.users) {
        
        if ([employ.id isEqualToNumber:em.id]) {
            
            em.select = select;
            break;
        }
        
    }
    
    for (TFDepartmentModel *depart in department.childList) {
        
        [self employeeSelected:employ inDepartment:depart select:select];
    }
    
}



/** 初始化层级、选中及展开 */
-(void)handleLevelWithDepartments:(NSArray *)departments level:(NSNumber *)level{
    
    for (TFDepartmentModel *depart in departments) {
        
        depart.level = level;
        depart.open = @0;
        depart.select = @0;
        
        for (TFEmployModel *employ in depart.users) {
            
            employ.level = @([depart.level integerValue] + 1);
            employ.select = @0;
            employ.departmentId = depart.id;
        }
        
        if (depart.childList.count) {
            
            [self handleLevelWithDepartments:depart.childList level:@([depart.level integerValue] + 1)];
        }
    }
    
}

-(NSArray *)handleDataListWithDepartments:(NSArray *)departments{
    
    NSMutableArray *list = [NSMutableArray array];
    for (TFDepartmentModel *depart in departments) {
        
        [list addObject:depart];
        
        if ([depart.open isEqualToNumber:@1]) {// 展开
            
            if (depart.childList.count) {
                
                NSArray *arr = [self handleDataListWithDepartments:depart.childList];
                [list addObjectsFromArray:arr];
            }
            
            for (TFEmployModel *employ in depart.users) {
                
                [list addObject:employ];
            }
        }
    }
    
    return list;
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
