
//
//  TFContactsDepartmentController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFContactsDepartmentController.h"
#import "TFSelectPeopleElementCell.h"
#import "TFContactHeaderView.h"
#import "HQTFSearchHeader.h"
#import "TFFilePathView.h"
#import "TFPeopleBL.h"
#import "TFAllSelectView.h"
#import "TFFilePathView.h"
#import "TFChangeHelper.h"

@interface TFContactsDepartmentController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,TFFilePathViewDelegate,HQBLDelegate,TFSelectPeopleElementCellDelegate,TFAllSelectViewDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** 组织架构树 */
@property (nonatomic, strong) NSArray * dataList;

/** allSelectView */
@property (nonatomic, strong) TFAllSelectView *allSelectView ;

@property (nonatomic, assign) BOOL containSub;
@property (nonatomic, weak) HQTFSearchHeader *header;
@property (nonatomic, copy) NSString *headerStr;
@property (nonatomic, strong) NSMutableArray *allDatas;
@end

@implementation TFContactsDepartmentController
-(NSMutableArray *)allDatas{
    if (!_allDatas) {
        _allDatas = [NSMutableArray array];
    }
    return _allDatas;
}

-(NSMutableArray *)fourSelects{
    if (!_fourSelects) {
        _fourSelects = [NSMutableArray array];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFDepartmentModel *model in self.defaultDepartments) {
            
            [arr addObject:model];
            
        }
        
        [_fourSelects addObject:@{@"type":@0}];
        [_fourSelects addObject:@{@"type":@1,@"peoples":arr?:@[]}];
        [_fourSelects addObject:@{@"type":@2}];
        [_fourSelects addObject:@{@"type":@3}];
        
    }
    return _fourSelects;
}

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
-(void)didBack:(UIButton *)sender{
    [super didBack:sender];
    if (self.cancelAction) {
        self.cancelAction();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containSub = !self.isSingleSelect;
    [self setupTableView];
    [self setupTableViewHeader];
    
    if (self.type == 1) {
        
        self.peopleBL = [TFPeopleBL build];
        self.peopleBL.delegate = self;
        [self.peopleBL requestCompanyFrameworkWithCompanyId:[UM.userLoginInfo.company.id description] dismiss:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allSelect:) name:AllSelectPeopleNotification object:nil];
        
        [self setupAllSelectView];
        if (self.isSingleUse) {
        
            self.navigationItem.title = @"选择部门";
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
        }
        
    }else{
        
        [self setupAllSelectView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllSelectView:) name:SelectPeopleRefreshNotification object:nil];
        
        [self setupNavi];
    }
    
    if (self.isSingleSelect) {
        self.allSelectView.hidden = YES;
        self.tableView.height = self.tableViewHeight>0?self.tableViewHeight:SCREEN_HEIGHT-NaviHeight;
    }
    if (self.department) {
        [self.allDatas removeAllObjects];
        [self.allDatas addObjectsFromArray:self.department.childList];
    }
}



/** 全选通知 */
- (void)allSelect:(NSNotification *)note{
    
    NSDictionary *dict = note.object;
    
    if (1 == [[dict valueForKey:@"type"] integerValue]) {
        
        for (TFDepartmentModel *model in self.companyFrameWorks) {
            
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
    
    [di setObject:@1 forKey:@"type"];
    [di setObject:[self sureAllSelectDepartNum] forKey:@"peoples"];
    [di setObject:@([self allDepartmentsNum]) forKey:@"allCount"];
    
    
    BOOL sel = YES;
    for (TFDepartmentModel *dd in self.companyFrameWorks) {
        
        if ([dd.select isEqualToNumber:@0]) {
            sel = NO;
            break;
        }
    }
    [di setObject:sel?@1:@0 forKey:@"selected"];
    
    self.fourSelects[1] = di;
    
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
    allSelectView.selectSub.hidden = self.isSingleSelect;
    allSelectView.selectSub.selected = self.containSub;
    if (self.type == 1) {
        allSelectView.y -= 44;
    }
}

#pragma mark - TFAllSelectViewDelegate
-(void)allSelectViewDidClickedSelectSubBtn:(UIButton *)selectBtn{
    
    self.containSub = selectBtn.selected;
    
}

-(void)allSelectViewDidClickedAllSelectBtn:(UIButton *)selectBtn{
    
    
    if (self.department) {
        
        for (TFDepartmentModel *model in self.department.childList) {
            
            
            if (selectBtn.selected) {
                
                model.select = @1;
            }else{
                
                model.select = @0;
            }
        }
        
        
        
    }else{
        
        for (TFDepartmentModel *model in self.companyFrameWorks) {
            
            if (selectBtn.selected) {
                
                model.select = @1;
            }else{
                
                model.select = @0;
                
            }
            
        }
        
    }
    [self.tableView reloadData];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@1 forKey:@"type"];
    [dict setObject:[self sureAllSelectDepartNum] forKey:@"peoples"];
    [dict setObject:@([self allDepartmentsNum]) forKey:@"allCount"];
    
    
    BOOL sel = YES;
    for (TFDepartmentModel *dd in self.companyFrameWorks) {
        
        if ([dd.id isEqualToNumber:@0]) {
            sel = NO;
            break;
        }
    }
    [dict setObject:sel?@1:@0 forKey:@"selected"];
    
    self.fourSelects[1] = dict;
    
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
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.isSingleUse) {
        
        if (self.actionParameter) {
            if (self.vcTag == 0) {
                [self.navigationController popViewControllerAnimated:YES];
                NSDictionary *dict = self.fourSelects[1];
                self.actionParameter([dict valueForKey:@"peoples"]);
            }else{
                [self.navigationController popViewControllerAnimated:NO];
                self.actionParameter(self.fourSelects);
            }
        }
    }else{
        
        if (self.actionParameter) {
            self.actionParameter(self.fourSelects);
        }
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
    header.backgroundColor = WhiteColor;
    header.button.backgroundColor = BackGroudColor;
    
    if (self.type == 0) {
        
        TFFilePathView *pathView = [[TFFilePathView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,40} models:self.paths];
        [headerView addSubview:pathView];
        pathView.delegate = self;
    }
    
    self.tableView.tableHeaderView = headerView;
    self.header = header;
}

#pragma mark - HQTFSearchHeaderDelegate
- (void)searchHeaderClicked{
    self.header.type = SearchHeaderTypeSearch;
    [self.header.textField becomeFirstResponder];
    self.header.textField.text = self.headerStr;
}
- (void)searchHeaderTextChange:(UITextField *)textField{
    
    self.headerStr = textField.text;
    
    if (textField.text.length == 0) {
        if (self.department) {
            self.department.childList = [NSMutableArray<TFDepartmentModel,Optional> arrayWithArray:self.allDatas];
        }else{
            self.dataList = [NSMutableArray arrayWithArray:self.allDatas];
        }
        [self.tableView reloadData];
        return;
    }
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    NSString *highStr = [textField textInRange:textRange];
    if (highStr.length <= 0) {
        NSMutableArray<TFDepartmentModel,Optional> *arr = [NSMutableArray<TFDepartmentModel,Optional> array];
        for (TFDepartmentModel *model in self.allDatas) {
            if ([model.name containsString:textField.text]) {
                [arr addObject:model];
            }
        }
        
        if (self.department) {
            self.department.childList = arr;
        }else{
            self.dataList = [NSMutableArray arrayWithArray:arr];
        }
        [self.tableView reloadData];
    }
}
- (void)searchHeaderTextEditEnd:(UITextField *)textField{
    
    self.header.backgroundColor = WhiteColor;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.header.textField resignFirstResponder];
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
        
        return self.department.childList.count;
    }else{
        
        return self.dataList.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.department) {
        
        TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.row];
        cell.delegate = self;
        TFDepartmentModel *model = self.department.childList[indexPath.row];
        [cell refreshCellWithDepartmentModel:model isSingle:NO];
        cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
        return cell;
        
    }else{
        
        TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.row];
        cell.delegate = self;
        TFDepartmentModel *model = self.dataList[indexPath.row];
        [cell refreshCellWithDepartmentModel:model isSingle:NO];
        cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
        return cell;
        
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.department) {
        
            
        TFDepartmentModel *model = self.department.childList[indexPath.row];
        
        if (model.users.count == 0 && model.childList.count == 0) {
            [MBProgressHUD showError:@"该层级已到底部" toView:self.view];
            return;
        }
        TFContactsDepartmentController *frameWork = [[TFContactsDepartmentController alloc] init];
        frameWork.isSingleUse = self.isSingleUse;
        [frameWork.paths addObjectsFromArray:self.paths];
        
        
        TFFilePathModel *path = [[TFFilePathModel alloc] init];
        path.name = model.name;
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
            path.className = [TFContactsDepartmentController class];
            HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
            path.vcTag = vc.vcTag + 1;
        }else{
            
            path.className = [TFContactsDepartmentController class];
            path.vcTag = self.vcTag + 1;
        }
        [frameWork.paths addObject:path];
        
        frameWork.department = model;
        frameWork.vcTag = self.vcTag + 1;
        frameWork.companyFrameWorks = self.companyFrameWorks;
        
        frameWork.fourSelects = self.fourSelects;
        frameWork.actionParameter = ^(id parameter) {
            
            if (self.isSingleUse) {
                [self sure];
            }else{
                
                if (self.actionParameter) {
                    self.actionParameter(self.fourSelects);
                }
            }
        };
        frameWork.isSingleSelect = self.isSingleSelect;
        [self.navigationController pushViewController:frameWork animated:YES];
            
            
        
    }else{
        
        TFDepartmentModel *model = self.dataList[indexPath.row];
        
        if (model.users.count == 0 && model.childList.count == 0) {
            [MBProgressHUD showError:@"该层级已到底部" toView:self.view];
            return;
        }
        TFContactsDepartmentController *frameWork = [[TFContactsDepartmentController alloc] init];
        frameWork.isSingleUse = self.isSingleUse;
        
        [frameWork.paths addObjectsFromArray:self.paths];
        
        TFFilePathModel *path = [[TFFilePathModel alloc] init];
        path.name = model.name;
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
            path.className = [TFContactsDepartmentController class];
            HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
            path.vcTag = vc.vcTag + 1;
        }else{
            
            path.className = [TFContactsDepartmentController class];
            path.vcTag = self.vcTag + 1;
        }
        [frameWork.paths addObject:path];
        
        frameWork.department = model;
        frameWork.vcTag = self.vcTag + 1;
        frameWork.companyFrameWorks = self.companyFrameWorks;
        
        frameWork.fourSelects = self.fourSelects;
        frameWork.actionParameter = ^(NSArray *parameter) {
            
            if (self.isSingleUse) {
                [self sure];
            }else{
                if (self.actionParameter) {
                    self.actionParameter(self.fourSelects);
                }
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

/** 选中下级部门 */
-(void)selectSubLevelWithDepartment:(TFDepartmentModel *)department{
    for (TFDepartmentModel *model in department.childList) {
        model.select = department.select;
        if (model.childList) {
            [self selectSubLevelWithDepartment:model];
        }
    }
}

#pragma mark - TFSelectPeopleElementCellDelegate
-(void)selectPeopleElementCellDidClickedSelectBtn:(UIButton *)selectBtn{
    
    NSInteger section = selectBtn.tag / 0x999;
    NSInteger row = selectBtn.tag % 0x999;
    
    if (self.isSingleSelect) {
        
        if (self.department) {
            
            TFDepartmentModel *department = self.department.childList[row];
            
            if ([department.select isEqualToNumber:@2]) {
                return;
            }
            
        }else{
            
            TFDepartmentModel *department = self.companyFrameWorks[row];
            if ([department.select isEqualToNumber:@2]) {
                return;
            }
            
        }
        // 取消选择
        // 1.获取全部部门
        NSMutableArray *peoples = [NSMutableArray array];
        
        for (TFDepartmentModel *depart in self.companyFrameWorks) {
            
            [peoples addObjectsFromArray:[self getDepartmentWithDepartment:depart]];
            
        }
        // 2.取消选择
        for (TFDepartmentModel *d in peoples) {
            
            d.select = @0;
            
        }
        
        // 选择当前
        if (self.department) {
            
            TFDepartmentModel *department = self.department.childList[row];
            
            department.select = @1;
            
        }else{
            
            TFDepartmentModel *department = self.companyFrameWorks[row];
            
            department.select = @1;
            
        }
        
        
        [self.tableView reloadData];
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:@1 forKey:@"type"];
        [dict setObject:[self sureAllSelectDepartNum] forKey:@"peoples"];
        [dict setObject:@([self allDepartmentsNum]) forKey:@"allCount"];
        
        
        BOOL sel = YES;
        for (TFDepartmentModel *dd in self.companyFrameWorks) {
            
            if ([dd.id isEqualToNumber:@0]) {
                sel = NO;
                break;
            }
        }
        [dict setObject:sel?@1:@0 forKey:@"selected"];
        
        
        
        self.fourSelects[1] = dict;
        
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
                
                // 选中下级部门
                if (self.containSub) {
                    [self selectSubLevelWithDepartment:department];
                }
                
            }
            
            
        }
        
        BOOL all = YES;
        
        for (TFDepartmentModel *de in self.department.childList) {
            
            if ([de.select isEqualToNumber:@0]) {
                all = NO;
                break;
            }
        }
        
        self.allSelectView.allSelectBtn.selected = all;
        
        
        
    }else{// 主级
        
        TFDepartmentModel *department = self.companyFrameWorks[row];
        if ([department.select isEqualToNumber:@2]) {
            
            return;
        }else{
            
            department.select = [department.select isEqualToNumber:@1] ? @0 : @1;
            
            // 选中下级部门
            if (self.containSub) {
                [self selectSubLevelWithDepartment:department];
            }
        }
        
        
        BOOL all = YES;
        
        for (TFDepartmentModel *de in self.companyFrameWorks) {
            
            if ([de.select isEqualToNumber:@0]) {
                all = NO;
                break;
            }
        }
        
        self.allSelectView.allSelectBtn.selected = all;
        
    }
    
    
    [self.tableView reloadData];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@1 forKey:@"type"];
    [dict setObject:[self sureAllSelectDepartNum] forKey:@"peoples"];
    [dict setObject:@([self allDepartmentsNum]) forKey:@"allCount"];
    
    
    BOOL sel = YES;
    for (TFDepartmentModel *dd in self.companyFrameWorks) {
        
        if ([dd.select isEqualToNumber:@0]) {
            sel = NO;
            break;
        }
    }
    [dict setObject:sel?@1:@0 forKey:@"selected"];
    
    
    
    self.fourSelects[1] = dict;
    
    // 显示选中
    [self showSelectNum];
    
    // 显示全选
    [self showIsAllSelect];
    
    // 发送刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectPeopleRefreshNotification object:dict];
}




/** 清空部门中的人 */
-(void)clearDepartmentPeopleWith:(TFDepartmentModel *)model{
    
    model.users = nil;
    
    for (TFDepartmentModel *de in model.childList) {
        
        [self clearDepartmentPeopleWith:de];
    }
    
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_companyFramework) {
        
        [self handleLevelWithDepartments:resp.body level:@0];
        self.dataList = [self handleDataListWithDepartments:resp.body];
        
        for (TFDepartmentModel *model in self.dataList) {
            
            [self clearDepartmentPeopleWith:model];
        }
        
        
        NSDictionary *dict = self.fourSelects[1];
        
        for (TFDepartmentModel *model in [dict valueForKey:@"peoples"]) {
            
            for (TFDepartmentModel *depart in self.dataList) {
                
                [self departmentSelected:model inDepartment:depart];
                
            }
        }
        
        
        self.companyFrameWorks = self.dataList;
        
        
        // 显示选中
        [self showSelectNum];
        
        // 显示全选
        [self showIsAllSelect];
        
        [self.tableView reloadData];
        
        [self.allDatas removeAllObjects];
        [self.allDatas addObjectsFromArray:self.dataList];
    }
    
}

/** 显示是否全选 */
- (void)showIsAllSelect{
    
    if (self.department) {
        
        
        BOOL all = YES;
        for (TFDepartmentModel *model in self.department.childList) {
            
            if ([model.select isEqualToNumber:@0]) {
                all = NO;
                break;
            }
        }
        
        self.allSelectView.allSelectBtn.selected = all;
        
    }else{
        
        BOOL all = YES;
        for (TFDepartmentModel *model in self.companyFrameWorks) {
            
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
    // 部门中的
    num += [self sureAllSelectDepartNum].count;
    
    // 组织架构中的
    NSDictionary *dict1 = self.fourSelects[0];
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



/** 组织架构中选中的部门 */
- (NSMutableArray *)sureAllSelectDepartNum{
    
    NSMutableArray *peoples = [NSMutableArray array];
    
    for (TFDepartmentModel *depart in self.companyFrameWorks) {
        
        [peoples addObjectsFromArray:[self getDepartmentWithDepartment:depart]];
        
    }
    
    NSMutableArray *selects = [NSMutableArray array];
    for (TFDepartmentModel *depart in peoples) {
        if ([depart.select isEqualToNumber:@1]) {// 已选择
            
            [selects addObject:depart];
            
        }
    }
    
    return selects;
    
}

/** 拿到某部门(包括子部门) */
- (NSMutableArray *)getDepartmentWithDepartment:(TFDepartmentModel *)department{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObject:department];
    
    for (TFDepartmentModel *de in department.childList) {
        
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


/** 某部门（depart）是否为某部门（department）拥有 */
-(void)departmentSelected:(TFDepartmentModel *)depart inDepartment:(TFDepartmentModel *)department{
    
    // 本身
    if ([[department.id description] isEqualToString:[depart.id description]]) {
        
        department.select = @1;
        
    }
    
    // 子部门有没有
    for (TFDepartmentModel *model in department.childList) {
        
        [self departmentSelected:depart inDepartment:model];
        
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
