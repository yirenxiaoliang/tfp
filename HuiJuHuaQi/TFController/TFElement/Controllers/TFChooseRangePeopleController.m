//
//  TFChooseRangePeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChooseRangePeopleController.h"
#import "TFSelectPeopleElementCell.h"
#import "TFContactHeaderView.h"
#import "HQTFSearchHeader.h"
#import "TFFilePathView.h"
#import "TFPeopleBL.h"
#import "TFAllSelectView.h"
#import "TFFilePathView.h"
#import "TFChangeHelper.h"
#import "TFPersonalMaterialController.h"

@interface TFChooseRangePeopleController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,TFFilePathViewDelegate,HQBLDelegate,TFSelectPeopleElementCellDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** 组织架构树 */
@property (nonatomic, strong) NSArray * dataList;

/** selectPeoples */
@property (nonatomic, strong) NSMutableArray *selectPeoples;


@end

@implementation TFChooseRangePeopleController


-(NSMutableArray *)selectPeoples{
    if (!_selectPeoples) {
        _selectPeoples = [NSMutableArray array];
    }
    return _selectPeoples;
}

-(NSMutableArray *)paths{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupTableViewHeader];
    [self setupNavi];
    
    if (self.type == 0) {
        self.peopleBL = [TFPeopleBL build];
        self.peopleBL.delegate = self;
        [self.peopleBL requestCompanyFrameworkWithCompanyId:[UM.userLoginInfo.company.id description] dismiss:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sure) name:@"IClickedSureButton" object:nil];
        self.tableView.height = SCREEN_HEIGHT-NaviHeight;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"RefreshSelect" object:nil];
        
    }else{
        
        [self.selectPeoples addObjectsFromArray:self.peoples];
        for (TFEmployModel *model in self.selectPeoples) {
            
            for (TFDepartmentModel *depart in self.companyFrameWorks) {
                
                [self employeeSelected:model inDepartment:depart select:@1];
                
            }
        }
    }
    
    
    
}

- (void)refresh:(NSNotification *)note{
    
    self.selectPeoples = note.object;
    
    for (TFEmployModel *model in self.selectPeoples) {
        
        for (TFDepartmentModel *depart in self.companyFrameWorks) {
            
            [self employeeSelected:model inDepartment:depart select:@1];
            
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - Navigation
- (void)setupNavi{
    
    self.navigationItem.title = @"组织架构";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.type == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IClickedSureButton" object:nil];
    }else{
        
        NSArray *array = [self sureAllSelectAndSelectPeopleNum];
        
        NSMutableArray *pol = [NSMutableArray array];
        
        for (TFEmployModel *kk in array) {
            
            HQEmployModel *ddjj = [TFChangeHelper tfEmployeeToHqEmployee:kk];
            
            if (ddjj) {
                [pol addObject:ddjj];
            }
        }
        
        if (self.actionParameter) {
            self.actionParameter(pol);
        }

        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 头部
- (void)setupTableViewHeader{
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,84}];
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.delegate = self;
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    
    TFFilePathView *pathView = [[TFFilePathView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,40} models:self.paths];
    [headerView addSubview:pathView];
    pathView.delegate = self;
    
    if (self.paths.count == 0) {
        [pathView removeFromSuperview];
        headerView.height = 44;
    }
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - HQTFSearchHeaderDelegate
- (void)searchHeaderClicked{
    
    
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStylePlain];
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
            
            TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:1];
            cell.delegate = self;
            TFDepartmentModel *model = self.department.childList[indexPath.row];
            [cell refreshCellWithDepartmentModel:model isSingle:self.isSingleSelect];
            cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
            return cell;
            
        }else{
            
            TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:1];
            cell.delegate = self;
            TFEmployModel *model = self.department.users[indexPath.row];
            [cell refreshCellWithEmployeeModel:model isSingle:NO];
            cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
            return cell;
            
        }
        
    }else{
        
        TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.row];
        cell.delegate = self;
        TFDepartmentModel *model = self.dataList[indexPath.row];
        [cell refreshCellWithDepartmentModel:model isSingle:self.isSingleSelect];
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
            TFChooseRangePeopleController *frameWork = [[TFChooseRangePeopleController alloc] init];
            frameWork.type = 1;
            [frameWork.paths addObjectsFromArray:self.paths];
            
            
            TFFilePathModel *path = [[TFFilePathModel alloc] init];
            path.name = model.name;
            if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
                path.className = [TFChooseRangePeopleController class];
                HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
                path.vcTag = vc.vcTag + 1;
            }else{
                
                path.className = [TFChooseRangePeopleController class];
                path.vcTag = self.vcTag + 1;
            }
            [frameWork.paths addObject:path];
            
            frameWork.department = model;
            frameWork.vcTag = self.vcTag + 1;
            frameWork.companyFrameWorks = self.companyFrameWorks;
            
            frameWork.peoples = self.selectPeoples;
            frameWork.actionParameter = ^(id parameter) {
                
                if (self.actionParameter) {
                    self.actionParameter(self.selectPeoples);
                }
            };
            frameWork.isSingleSelect = self.isSingleSelect;
            [self.navigationController pushViewController:frameWork animated:YES];
            
            
        }else{
            
                
            TFSelectPeopleElementCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            [self selectPeopleElementCellDidClickedSelectBtn:cell.selectBtn];
                
            
        }
        
        
    }else{
        
        TFDepartmentModel *model = self.dataList[indexPath.row];
        
        if (model.users.count == 0 && model.childList.count == 0) {
            return;
        }
        TFChooseRangePeopleController *frameWork = [[TFChooseRangePeopleController alloc] init];
        
        frameWork.type = 1;
        [frameWork.paths addObjectsFromArray:self.paths];
        
        TFFilePathModel *path = [[TFFilePathModel alloc] init];
        path.name = model.name;
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
            path.className = [TFChooseRangePeopleController class];
            HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
            path.vcTag = vc.vcTag + 1;
        }else{
            
            path.className = [TFChooseRangePeopleController class];
            path.vcTag = self.vcTag + 1;
        }
        [frameWork.paths addObject:path];
        
        frameWork.department = model;
        frameWork.vcTag = self.vcTag + 1;
        frameWork.companyFrameWorks = self.companyFrameWorks;
        frameWork.peoples = self.selectPeoples;
        frameWork.actionParameter = ^(id parameter) {
            
            if (self.actionParameter) {
                self.actionParameter(self.selectPeoples);
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
        
        [self departmentStatusInfoWithDepartments:self.companyFrameWorks];
        
        self.selectPeoples = [self sureAllSelectAndSelectPeopleNum];
        
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSelect" object:self.selectPeoples];
        
        
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
        
        
    }else{// 主级
        
        TFDepartmentModel *department = self.dataList[row];
        if ([department.select isEqualToNumber:@2]) {
            
            return;
        }else{
            
            department.select = [department.select isEqualToNumber:@1] ? @0 : @1;
        }
        [self selectPeopleWithDepartment:department];
        
    }
    
    [self departmentStatusInfoWithDepartments:self.companyFrameWorks];
    
    self.selectPeoples = [self sureAllSelectAndSelectPeopleNum];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSelect" object:self.selectPeoples];
    
    
    [self.tableView reloadData];
    
    
}


/** 选中或取消某个部门所有成员及子部门 */
- (void)selectPeopleWithDepartment:(TFDepartmentModel *)department{
    
    for (TFDepartmentModel *model in department.childList) {
        
        model.select = department.select;
        
        [self selectPeopleWithDepartment:model];
        
    }
    
    for (TFEmployModel *employ in department.users) {
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
    
    
    if (department.childList.count == 0 && department.users.count == 0) {// 没有子部门和员工时，它的选中取决于自身（最后一级部门可能的状态）
        
        return [department.select isEqualToNumber:@1] ? YES : NO;
    }
    
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
    
    return select;
}

/** 确定部门和员工的选中情况 */
- (void)departmentStatusInfoWithDepartments:(NSArray *)departments{
    
    for (id obj in departments) {
        
        if ([obj isKindOfClass:[TFDepartmentModel class]]) {
            TFDepartmentModel *depart = obj;
            
            if ([self selectStatusWithDepartment:depart]) {
                
                depart.select = @1;
                [self selectPeopleWithDepartment:depart];
            }else{
                depart.select = @0;
            }
            
            [self departmentStatusInfoWithDepartments:depart.childList];
        }
    }
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_companyFramework) {
        
        [self handleLevelWithDepartments:resp.body level:@0];
        self.dataList = [self handleDataListWithDepartments:resp.body];
        
        
        self.selectPeoples = self.peoples;
        
        self.department = [self dealDataSource];
        
        self.companyFrameWorks = [NSMutableArray arrayWithObject:self.department];
        
        for (TFEmployModel *model in self.peoples) {
            
            for (TFDepartmentModel *depart in self.companyFrameWorks) {
                
                [self employeeSelected:model inDepartment:depart select:@1];
                
            }
        }
        
        for (HQEmployModel *model in self.noSelectPoeples) {
            
            for (TFDepartmentModel *depart in self.companyFrameWorks) {
                
                [self employeeSelected:[TFChangeHelper hqEmployeeToTfEmployee:model] inDepartment:depart select:@2];
                
            }
        }
        
        // 处理数据源
        [self departmentStatusInfoWithDepartments:self.companyFrameWorks];
    
        
        [self.tableView reloadData];
    }
    
}

/** 处理数据源 */
- (TFDepartmentModel *)dealDataSource{
    
    NSMutableArray<TFDepartmentModel,Optional> *departments = [NSMutableArray<TFDepartmentModel,Optional> array];
    NSMutableArray *peoples = [NSMutableArray array];
    
    for (TFNormalPeopleModel *model in self.dataSource) {
        
        if ([model.type isEqualToNumber:@0]) {
            
           TFDepartmentModel *de = [self findDepartmentWithDepartmentId:model.id departments:self.dataList];
            
            if (de) {
                [departments addObject:de];
            }
        }
        
        if ([model.type isEqualToNumber:@1]) {
            
            HQEmployModel *em = [TFChangeHelper employeeForNormalPeople:model];
            
            TFEmployModel *ee = [TFChangeHelper hqEmployeeToTfEmployee:em];
            
            [peoples addObject:ee];
        }
    }
    
    // 部门和成员
    for (TFDepartmentModel *depart in departments) {
        
        [peoples addObjectsFromArray:[self getDepartmentPeopleWithDepartment:depart]];
    }
    
    // 去重
    NSMutableArray<TFEmployModel,Optional> *nPeoples = [NSMutableArray<TFEmployModel,Optional> array];
    
    for (TFEmployModel *eeee in peoples) {
        
        BOOL have = NO;
        for (TFEmployModel *llll in nPeoples) {
            
            if ([eeee.id isEqualToNumber:llll.id]) {
                
                have = YES;
                break;
            }
        }
        
        if (!have) {
            [nPeoples addObject:eeee];
        }
    }
    
    TFDepartmentModel *myDe = [[TFDepartmentModel alloc] init];
    
    myDe.childList = departments;
    
    myDe.users = nPeoples;
    
    return myDe;
    
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
