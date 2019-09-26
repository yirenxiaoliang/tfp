//
//  TFContactsDynamicParameterController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFContactsDynamicParameterController.h"
#import "TFSelectPeopleElementCell.h"
#import "TFContactHeaderView.h"
#import "HQTFSearchHeader.h"
#import "TFFilePathView.h"
#import "TFPeopleBL.h"
#import "TFAllSelectView.h"
#import "TFFilePathView.h"
#import "TFChangeHelper.h"


@interface TFContactsDynamicParameterController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,TFFilePathViewDelegate,HQBLDelegate,TFSelectPeopleElementCellDelegate,TFAllSelectViewDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** 组织架构树 */
@property (nonatomic, strong) NSArray * dataList;

/** allSelectView */
@property (nonatomic, strong) TFAllSelectView *allSelectView ;



@end

@implementation TFContactsDynamicParameterController

-(NSMutableArray *)paths{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    if (self.type == 1) {
        
        self.peopleBL = [TFPeopleBL build];
        self.peopleBL.delegate = self;
        [self.peopleBL requsetGetSharePersonalFieldsWithBean:self.bean type:2];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allSelect:) name:AllSelectPeopleNotification object:nil];
    }else{
        
        [self setupAllSelectView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllSelectView:) name:SelectPeopleRefreshNotification object:nil];
        
        [self setupNavi];
    }
    
    if (self.isSingleSelect) {
        self.allSelectView.hidden = YES;
        self.tableView.height = self.tableViewHeight>0?self.tableViewHeight:SCREEN_HEIGHT-NaviHeight;
    }
}

/** 全选通知 */
- (void)allSelect:(NSNotification *)note{
    
    NSDictionary *dict = note.object;
    
    if (3 == [[dict valueForKey:@"type"] integerValue]) {
        
        for (TFDynamicParameterModel *model in self.companyFrameWorks) {
            
            if (1 == [[dict valueForKey:@"selected"] integerValue]) {
                
                model.select = @1;
            }else{
                
                model.select = @0;
            }
        }
        
    }else{
        return;
    }
    
    [self.tableView reloadData];
    
    NSMutableDictionary *di = [NSMutableDictionary dictionary];
    
    [di setObject:@3 forKey:@"type"];
    [di setObject:[self sureAllSelectDepartNum] forKey:@"peoples"];
    [di setObject:@([self allDepartmentsNum]) forKey:@"allCount"];
    
    
    BOOL sel = YES;
    for (TFDynamicParameterModel *dd in self.companyFrameWorks) {
        
        if ([dd.select isEqualToNumber:@0]) {
            sel = NO;
            break;
        }
    }
    [di setObject:sel?@1:@0 forKey:@"selected"];
    
    self.fourSelects[3] = di;
    
    // 显示选中
    [self showSelectNum];
    
    // 显示全选
    [self showIsAllSelect];
    
    // 发送刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectPeopleRefreshNotification object:di];
}

- (void)setupAllSelectView{
    
    TFAllSelectView *allSelectView = [TFAllSelectView allSelectView];
    allSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomHeight, SCREEN_WIDTH, TabBarHeight);
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
        
        for (TFDynamicParameterModel *model in self.dataList) {
            
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
    
    [dict setObject:@3 forKey:@"type"];
    [dict setObject:[self sureAllSelectDepartNum] forKey:@"peoples"];
    [dict setObject:@([self allDepartmentsNum]) forKey:@"allCount"];
    
    
    BOOL sel = YES;
    for (TFDynamicParameterModel *dd in self.companyFrameWorks) {
        
        if ([dd.id isEqualToNumber:@0]) {
            sel = NO;
            break;
        }
    }
    [dict setObject:sel?@1:@0 forKey:@"selected"];
    
    self.fourSelects[3] = dict;
    
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

/** 选中或取消某个部门所有成员及子部门 */
- (void)selectPeopleWithDepartment:(TFDynamicParameterModel *)department{
    
    for (TFDynamicParameterModel *model in department.roles) {
        
        model.select = department.select;
        
        [self selectPeopleWithDepartment:model];
        
    }
    
}


#pragma mark - Navigation
- (void)setupNavi{
    
    self.navigationItem.title = @"动态参数";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.actionParameter) {
        self.actionParameter(self.fourSelects);
    }
    
}

#pragma mark - 头部
- (void)setupTableViewHeader{
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,84}];
    
    if (self.type == 1) {
        headerView.height = 44;
    }
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.delegate = self;
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    
    if (self.type == 0) {
        
        TFFilePathView *pathView = [[TFFilePathView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,40} models:self.paths];
        [headerView addSubview:pathView];
        pathView.delegate = self;
    }
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - HQTFSearchHeaderDelegate
- (void)searchHeaderClicked{
    
    
}

#pragma mark - TFFilePathViewDelegate
- (void)selectFilePathWithModel:(TFFilePathModel *)model{
    
    NSArray *arr = self.navigationController.childViewControllers;
    
    for (HQBaseViewController *vc  in arr) {
        
        if ([vc isKindOfClass:model.className]) {
            
            if (vc.vcTag == model.vcTag) {
                
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
        
    }
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeight>0?self.tableViewHeight-BottomHeight:SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.department) {
        
        return self.department.roles.count;
    }else{
        
        return self.dataList.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.department) {
        
        TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView   index:indexPath.row];
        cell.delegate = self;
        TFDynamicParameterModel *model = self.department.roles[indexPath.row];
        [cell refreshCellWithParameterModel:model isSingle:NO];
        cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
        if (indexPath.row == 0) {
            cell.topLine.hidden = YES;
        }else{
            cell.topLine.hidden = NO;
        }
        return cell;
        
    }else{
        
        TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.row];
        cell.delegate = self;
        TFDynamicParameterModel *model = self.dataList[indexPath.row];
        [cell refreshCellWithParameterModel:model isSingle:self.isSingleSelect];
        cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
        if (indexPath.row == 0) {
            cell.topLine.hidden = YES;
        }else{
            cell.topLine.hidden = NO;
        }
        return cell;
        
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.department) {
        
        
        TFDynamicParameterModel *model = self.department.roles[indexPath.row];
        
        if (model.roles.count == 0) {
            return;
        }
        
        TFContactsDynamicParameterController *frameWork = [[TFContactsDynamicParameterController alloc] init];
        
        [frameWork.paths addObjectsFromArray:self.paths];
        
        
        TFFilePathModel *path = [[TFFilePathModel alloc] init];
        path.name = model.name;
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
            path.className = [TFContactsDynamicParameterController class];
            HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
            path.vcTag = vc.vcTag + 1;
        }else{
            
            path.className = [TFContactsDynamicParameterController class];
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
        
        TFDynamicParameterModel *model = self.dataList[indexPath.row];
        
        if (model.roles.count == 0) {
            return;
        }
        
        TFContactsDynamicParameterController *frameWork = [[TFContactsDynamicParameterController alloc] init];
        
        [frameWork.paths addObjectsFromArray:self.paths];
        
        TFFilePathModel *path = [[TFFilePathModel alloc] init];
        path.name = model.name;
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
            path.className = [TFContactsDynamicParameterController class];
            HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
            path.vcTag = vc.vcTag + 1;
        }else{
            
            path.className = [TFContactsDynamicParameterController class];
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
    
    return 55;
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


#pragma mark - TFSelectPeopleElementCellDelegate
-(void)selectPeopleElementCellDidClickedSelectBtn:(UIButton *)selectBtn{
    
    NSInteger section = selectBtn.tag / 0x999;
    NSInteger row = selectBtn.tag % 0x999;
    
    
    if (self.isSingleSelect) {
        
        if (self.department) {
            
            TFDynamicParameterModel *department = self.department.roles[row];
            
            if ([department.select isEqualToNumber:@2]) {
                return;
            }
            
        }else{
            
            TFDynamicParameterModel *department = self.companyFrameWorks[row];
            if ([department.select isEqualToNumber:@2]) {
                return;
            }
            
        }
        // 取消选择
        // 1.获取全部部门
        NSMutableArray *peoples = [NSMutableArray array];
        
        for (TFDynamicParameterModel *depart in self.companyFrameWorks) {
            
            [peoples addObjectsFromArray:[self getDepartmentWithDepartment:depart]];
            
        }
        // 2.取消选择
        for (TFDynamicParameterModel *d in peoples) {
            
            d.select = @0;
            
        }
        
        // 选择当前
        if (self.department) {
            
            TFDynamicParameterModel *department = self.department.roles[row];
            
            department.select = @1;
            
        }else{
            
            TFDynamicParameterModel *department = self.companyFrameWorks[row];
            
            department.select = @1;
            
        }
        
        
        [self.tableView reloadData];
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:@3 forKey:@"type"];
        [dict setObject:[self sureAllSelectDepartNum] forKey:@"peoples"];
        [dict setObject:@([self allDepartmentsNum]) forKey:@"allCount"];
        
        
        BOOL sel = YES;
        for (TFDynamicParameterModel *dd in self.companyFrameWorks) {
            
            if ([dd.select isEqualToNumber:@0]) {
                sel = NO;
                break;
            }
        }
        [dict setObject:sel?@1:@0 forKey:@"selected"];
        
        
        self.fourSelects[3] = dict;
        
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
            
            TFDynamicParameterModel *department = self.department.roles[row];
            
            if ([department.select isEqualToNumber:@2]) {
                
                return;
            }else{
                
                department.select = [department.select isEqualToNumber:@1] ? @0 : @1;
            }
            
            [self selectPeopleWithDepartment:department];
            
        }
        
        BOOL all = [self selectToOverallAffectWithDepartment:self.department];
        
        self.allSelectView.allSelectBtn.selected = all;
        
        
        
    }else{// 主级
        
        TFDynamicParameterModel *department = self.companyFrameWorks[row];
        if ([department.select isEqualToNumber:@2]) {
            
            return;
        }else{
            
            department.select = [department.select isEqualToNumber:@1] ? @0 : @1;
        }
        
        [self selectPeopleWithDepartment:department];
        
        BOOL all = YES;
        
        for (TFDynamicParameterModel *de in self.companyFrameWorks) {
            
            if ([de.select isEqualToNumber:@0]) {
                all = NO;
                break;
            }
        }
        
        self.allSelectView.allSelectBtn.selected = all;
        
    }
    
    
    [self.tableView reloadData];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@3 forKey:@"type"];
    [dict setObject:[self sureAllSelectDepartNum] forKey:@"peoples"];
    [dict setObject:@([self allDepartmentsNum]) forKey:@"allCount"];
    
    
    BOOL sel = YES;
    for (TFDynamicParameterModel *dd in self.companyFrameWorks) {
        
        if ([dd.select isEqualToNumber:@0]) {
            sel = NO;
            break;
        }
    }
    [dict setObject:sel?@1:@0 forKey:@"selected"];
    
    
    self.fourSelects[3] = dict;
    
    // 显示选中
    [self showSelectNum];
    
    // 显示全选
    [self showIsAllSelect];
    
    // 发送刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectPeopleRefreshNotification object:dict];
}



/** 选择对整个部门的影响 返回是否全选 */
-(BOOL)selectToOverallAffectWithDepartment:(TFDynamicParameterModel *)department{
    
    BOOL allSelect = YES;
    for (TFDynamicParameterModel *obj in department.roles) {
        
        if ([obj.select isEqualToNumber:@0]) {
            
            allSelect = NO;
            break;
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




#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getSharePersonalFields) {
        
        [self handleLevelWithDepartments:resp.body level:@0];
        
        self.dataList = resp.body;
        
        NSDictionary *dict = self.fourSelects[3];
        
        for (TFDynamicParameterModel *model in [dict valueForKey:@"peoples"]) {
            
            for (TFDynamicParameterModel *depart in self.dataList) {
                
                [self roleSelected:model inRole:depart];
                
            }
        }
        
        self.companyFrameWorks = self.dataList;
        
        [self departmentStatusInfo];
        
        // 显示选中
        [self showSelectNum];
        
        // 显示全选
        [self showIsAllSelect];
        
        [self.tableView reloadData];
        
        
    }
    
}

/** 确定部门和员工的选中情况 */
- (void)departmentStatusInfo{
    
    for (TFDynamicParameterModel *obj in self.companyFrameWorks) {
        
        
        [self selectPeopleWithDepartment:obj];
    }
}

/** 初始化层级、选中及展开 */
-(void)handleLevelWithDepartments:(NSArray *)departments level:(NSNumber *)level{
    
    for (TFDynamicParameterModel *depart in departments) {
        
        depart.level = level;
        depart.select = @0;
        
        if (depart.roles.count) {
            
            [self handleLevelWithDepartments:depart.roles level:@([depart.level integerValue] + 1)];
        }
    }
}


/** 显示是否全选 */
- (void)showIsAllSelect{
    
    if (self.department) {
        
        
        BOOL all = YES;
        for (TFDynamicParameterModel *model in self.department.roles) {
            
            if ([model.select isEqualToNumber:@0]) {
                all = NO;
                break;
            }
        }
        
        self.allSelectView.allSelectBtn.selected = all;
        
    }else{
        
        BOOL all = YES;
        for (TFDynamicParameterModel *model in self.companyFrameWorks) {
            
            if ([model.select isEqualToNumber:@0]) {
                all = NO;
                break;
            }
        }
        
        self.allSelectView.allSelectBtn.selected = all;
        
    }
    
}


/** 显示已选择：多少 */
- (void)showSelectNum{
    
    NSInteger num = 0;
    // 动态参数中的
    num += [self sureAllSelectDepartNum].count;
    
    // 组织架构中的
    NSDictionary *dict1 = self.fourSelects[0];
    NSArray *arr1 = [dict1 valueForKey:@"peoples"];
    num += arr1.count;
    
    // 部门中的
    NSDictionary *dict2 = self.fourSelects[1];
    NSArray *arr2 = [dict2 valueForKey:@"peoples"];
    num += arr2.count;
    
    
    // 角色参数中的
    NSDictionary *dict3 = self.fourSelects[2];
    NSArray *arr3 = [dict3 valueForKey:@"peoples"];
    num += arr3.count;
    
    
    self.allSelectView.numLabel.text = [NSString stringWithFormat:@"已选择：%ld",num];
}



/** 组织架构中选中的参数 */
- (NSMutableArray *)sureAllSelectDepartNum{
    
//    NSMutableArray *peoples = [NSMutableArray array];
//    
//    for (TFDynamicParameterModel *depart in self.companyFrameWorks) {
//        
//        [peoples addObjectsFromArray:[self getDepartmentWithDepartment:depart]];
//        
//    }
    
    NSMutableArray *selects = [NSMutableArray array];
    for (TFDynamicParameterModel *depart in self.companyFrameWorks) {
        if ([depart.select isEqualToNumber:@1]) {// 已选择
            
            [selects addObject:depart];
            
        }
    }
    
    return selects;
    
}

/** 拿到某部门(包括子部门) */
- (NSMutableArray *)getDepartmentWithDepartment:(TFDynamicParameterModel *)department{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObjectsFromArray:department.roles];
    
    for (TFDynamicParameterModel *de in department.roles) {
        
        [arr addObjectsFromArray:[self getDepartmentWithDepartment:de]];
    }
    
    return arr;
}

/** 组织架构中的当前部门数 */
- (NSInteger)allDepartmentsNum{
    
    return self.companyFrameWorks.count;
    
    
}


-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


/** 某角色（depart）是否为某角色（department）拥有 */
-(void)roleSelected:(TFDynamicParameterModel *)depart inRole:(TFDynamicParameterModel *)department{
    
    // 本身
    if ([department.value isEqualToString:depart.value]) {
        
        department.select = @1;
        
    }
    
    // 子级有没有
    for (TFDynamicParameterModel *model in department.roles) {
        
        [self roleSelected:depart inRole:model];
        
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
