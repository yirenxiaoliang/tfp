//
//  TFCompanyFrameworkController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyFrameworkController.h"
#import "TFDepartmentModel.h"
#import "HQTFTwoLineCell.h"
#import "TFPeopleBL.h"

@interface TFCompanyFrameworkController ()<UITableViewDelegate,UITableViewDataSource,HQTFTwoLineCellDelegate,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** frameworks */
@property (nonatomic, strong) NSMutableArray *frameworks;

/** frameworks */
@property (nonatomic, strong) NSArray *dataList;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** 选择的部门 */
@property (nonatomic, strong) TFDepartmentModel *selectDepartment;


@end

@implementation TFCompanyFrameworkController

-(NSArray *)dataList{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

-(NSMutableArray *)frameworks{
    if (!_frameworks) {
        _frameworks = [NSMutableArray array];
        
        
//        for (NSInteger i = 0; i < 2; i++) {
//            
//            TFDepartmentModel *department = [[TFDepartmentModel alloc] init];
//            department.text = [NSString stringWithFormat:@"我是部门%ld",i];
//            department.count = @3;
//            department.id = @(i + i * 33);
//            
//            NSMutableArray<TFEmployModel,Optional> *peos = [NSMutableArray<TFEmployModel,Optional> array];
//            for (NSInteger j = 0; j < [department.count integerValue]; j ++) {
//                
//                TFEmployModel *employ = [[TFEmployModel alloc] init];
//                
//                employ.employee_name = [NSString stringWithFormat:@"我是部门%ld中的员工%ld",i,j];
//                employ.departmentId = department.id;
//                
//                [peos addObject:employ];
//            }
//            department.users = peos;
//            
//            NSMutableArray<TFDepartmentModel,Optional> *childList = [NSMutableArray<TFDepartmentModel,Optional> array];
//            
//            for (NSInteger k = 0; k < 2; k ++) {
//                
//                TFDepartmentModel *department = [[TFDepartmentModel alloc] init];
//                department.text = [NSString stringWithFormat:@"我是部门%ld的子部门%ld",i,k];
//                department.count = @3;
//                department.id = @(i + k + i * 33 + 77 * k + 55);
//                
//                NSMutableArray<TFEmployModel,Optional> *peos = [NSMutableArray<TFEmployModel,Optional> array];
//                for (NSInteger p = 0; p < [department.count integerValue]; p ++) {
//                    
//                    TFEmployModel *employ = [[TFEmployModel alloc] init];
//                    
//                    employ.employee_name = [NSString stringWithFormat:@"我是部门%ld子部门%ld的员工%ld",i,k,p];
//                    employ.departmentId = department.id;
//                    
//                    [peos addObject:employ];
//                }
//                department.users = peos;
//                
//                [childList addObject:department];
//            }
//            department.childList = childList;
//            
//            [_frameworks addObject:department];
//        }
        
        
    }
    return _frameworks;
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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    if (self.type == 0 || self.type == 1) {
        
        [self.peopleBL requestCompanyFrameworkWithCompanyId:[UM.userLoginInfo.company.id description] dismiss:nil];
    }
    
    if (self.type == 2) {
//        [self.peopleBL requestCompanyDepartmentListWithCompanyId:@"1"];
    }
    
//    [self handleLevelWithDepartments:self.frameworks level:@0];
//    self.dataList = [self handleDataListWithDepartments:self.frameworks];
    
    [self setupTableView];
    [self setupNavigation];
}

#pragma mark - 导航栏
- (void)setupNavigation{
    
    if (self.type != 2) {
        self.navigationItem.title = @"组织架构";
    }else{
        self.navigationItem.title = @"部门结构";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    }
}
- (void)sure{
    
    if (self.selectDepartment) {
        if (self.action) {
            self.action(self.selectDepartment);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.type = TwoLineCellTypeOne;
    cell.topLabel.textColor = BlackTextColor;
    cell.bottomLine.hidden = NO;
    cell.titleDescImg.hidden = YES;
    if (self.type == 0) {
        cell.enterImage.hidden = YES;
    }else{
        cell.enterImage.hidden = NO;
    }
    cell.titleImage.hidden = NO;
    cell.titleImage.userInteractionEnabled = NO;
    [cell.enterImage setBackgroundImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){40,40}] forState:UIControlStateNormal];
    [cell.enterImage setBackgroundImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){40,40}] forState:UIControlStateHighlighted];
    if (indexPath.row == self.dataList.count-1) {
        cell.bottomLine.hidden = YES;
    }
    cell.enterImage.tag = 0x555 + indexPath.row;
    cell.delegate = self;
    
    id model = self.dataList[indexPath.row];
    if ([model isKindOfClass:[TFDepartmentModel class]]) {// 部门
        TFDepartmentModel *depart = model;
        cell.topLabel.text = depart.name;
        cell.titleImageWidth = 20;
        cell.titleImageLeftW.constant = 8 + 40 *[depart.level integerValue];
        cell.headMargin = 15 + 40 *[depart.level integerValue];
        
        if (depart.open == nil || [depart.open isEqualToNumber:@0]) {
            
            [cell.titleImage setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateHighlighted];
        }else{
            
            [cell.titleImage setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateHighlighted];
        }
        
        if ([depart.select isEqualToNumber:@0] || depart.select == nil) {
            
            [cell.enterImage setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
            [cell.enterImage setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateHighlighted];
        }else{
            [cell.enterImage setImage:[UIImage imageNamed:@"signSelect"] forState:UIControlStateNormal];
            [cell.enterImage setImage:[UIImage imageNamed:@"signSelect"] forState:UIControlStateHighlighted];
        }
    }else{// 员工
        
        TFEmployModel *employ = model;
        cell.topLabel.text = employ.employee_name;
        cell.titleImageWidth = 30;
        cell.titleImageLeftW.constant = 8 + 40 *[employ.level integerValue];
        cell.headMargin = 15 + 40 *[employ.level integerValue];
        
        [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:employ.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:employ.picture] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
        
        if ([employ.select isEqualToNumber:@0] || employ.select == nil) {
            
            [cell.enterImage setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
            [cell.enterImage setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateHighlighted];
        }else{
            [cell.enterImage setImage:[UIImage imageNamed:@"signSelect"] forState:UIControlStateNormal];
            [cell.enterImage setImage:[UIImage imageNamed:@"signSelect"] forState:UIControlStateHighlighted];
        }
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    id model = self.dataList[indexPath.row];
    
    if ([model isKindOfClass:[TFDepartmentModel class]]) {// 部门
        
        TFDepartmentModel *depart = model;
        depart.open = [depart.open isEqualToNumber:@1]?@0:@1;
        self.dataList = [self handleDataListWithDepartments:self.frameworks];
        [self.tableView reloadData];
        
        
    }else{// 员工
        TFEmployModel *employ = model;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

#pragma mark - HQTFTwoLineCellDelegate
-(void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    id model = self.dataList[enterBtn.tag - 0x555];
    
    
    if (self.type == 1) {// 选员工
        
        if ([model isKindOfClass:[TFDepartmentModel class]]) {// 部门
            
            TFDepartmentModel *depart = model;
            depart.select = [depart.select isEqualToNumber:@1]?@0:@1;
            [self selectPeopleWithDepartment:depart];// 选中或取消某个部门的选中
            [self departmentStatusInfo];// 取消或选中影响父部门
            
            [self.tableView reloadData];
            
            
            
        }else{// 员工
            TFEmployModel *employ = model;
            employ.select = [employ.select isEqualToNumber:@1]?@0:@1;
            [self selectPeopleWithEmployee:employ];// 选中或取消某个部门的选中
            
            [self.tableView reloadData];
        }
        
    }
    
    if (self.type == 2) {// 部门
        
        if ([model isKindOfClass:[TFDepartmentModel class]]) {// 部门
            
            
            TFDepartmentModel *depart = model;
            if ([depart.select isEqualToNumber:@1]) {
                
                self.selectDepartment.select = @0;
                [self.tableView reloadData];
                self.selectDepartment = nil;
                
            }else{
                
                self.selectDepartment.select = @0;
                
                depart.select = @1;
                self.selectDepartment = depart;
                [self.tableView reloadData];
            }
            
            
        }
    }
    
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

/** 选择某员工影响部门的选中状态 */
-(void)selectPeopleWithEmployee:(TFEmployModel *)employee{
    
    NSNumber *departId = employee.departmentId;
    
    for (id obj in self.dataList) {
        
        if ([obj isKindOfClass:[TFDepartmentModel class]]) {
            TFDepartmentModel *depart = obj;
            if ([depart.id isEqualToNumber:departId]) {
                
                    [self departmentStatusInfo];// 影响部门的选中
                
            }
        }
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
- (void)departmentStatusInfo{
    
    for (id obj in self.dataList) {
        
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
        
        self.frameworks = resp.body;
        [self handleLevelWithDepartments:self.frameworks level:@0];
        self.dataList = [self handleDataListWithDepartments:self.frameworks];
        [self.tableView reloadData];
    }
    
//    if (resp.cmdId == HQCMD_findCompanyDepartment) {
//        
//        self.frameworks = resp.body;
//        [self handleLevelWithDepartments:self.frameworks level:@0];
//        self.dataList = [self handleDataListWithDepartments:self.frameworks];
//        [self.tableView reloadData];
//    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
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
