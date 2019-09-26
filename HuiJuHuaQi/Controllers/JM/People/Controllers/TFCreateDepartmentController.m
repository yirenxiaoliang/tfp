//
//  TFCreateDepartmentController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateDepartmentController.h"
#import "HQTFInputCell.h"
#import "HQSelectTimeCell.h"
#import "TFDepartmentManageController.h"
#import "TFDepartmentModel.h"
#import "HQDepartmentModel.h"
#import "TFPeopleBL.h"
#import "TFCompanyFrameworkController.h"

@interface TFCreateDepartmentController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFInputCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** HQDepartmentModel */
@property (nonatomic, strong) TFDepartmentModel *parentDepartment;
/** HQDepartmentModel */
@property (nonatomic, strong) TFDepartmentModel *department;

/** peopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

@end

@implementation TFCreateDepartmentController
/** 父部门 */
-(TFDepartmentModel *)parentDepartment{
    if (!_parentDepartment ) {
        _parentDepartment = [[TFDepartmentModel alloc] init];
    }
    return _parentDepartment;
}
/** 新建用的部门Model */
-(TFDepartmentModel *)department{
    if (!_department ) {
        _department = [[TFDepartmentModel alloc] init];
    }
    return _department;
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
    self.navigationItem.title = @"新建部门";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(departmentManage) text:@"部门管理" textColor:GreenColor];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
}

- (void)departmentManage{
    
//    TFDepartmentManageController *department = [[TFDepartmentManageController alloc] init];
//    department.type = 1;
//    [self.navigationController pushViewController:department animated:YES];
    
    TFCompanyFrameworkController *companyGroup = [[TFCompanyFrameworkController alloc] init];
    companyGroup.type = 1;
    [self.navigationController pushViewController:companyGroup animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,90}];
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,30,SCREEN_WIDTH-50,50} target:self action:@selector(buttonClick)];
    [view addSubview:button];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FONT(20);
    [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateHighlighted];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
    tableView.tableFooterView = view;
    
}

- (void)buttonClick{
    
    if (!self.department.name || [self.department.name isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入部门名称" toView:self.view];
        return;
    }
    
//    [self.peopleBL requestAddOrUpdateDepartmentWithDepartmentName:self.department.departmentName departmentId:nil parentDepartmentId:self.parentDepartment.id];
    
//    [self.peopleBL requestAddDepartmentWithDepartmentName:self.department.text parentDepartmentId:self.parentDepartment.id];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"上级部门";
        
        if (self.parentDepartment.id == nil) {
            
            cell.time.text = @"请选择部门";
            cell.time.textColor = PlacehoderColor;
        }else{
            
            cell.time.text = self.parentDepartment.name;
            cell.time.textColor = LightBlackTextColor;
        }
        return cell;
    }else{
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = @"部门名称";
        cell.textField.placeholder = @"请输入部门名称";
        cell.textField.text = self.department.name;
        cell.delegate = self;
        cell.enterBtn.tag = 0x123 + indexPath.row;
        [cell refreshInputCellWithType:0];
        cell.bottomLine.hidden = YES;
        return cell;
    }
    
}

#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    self.department.name = textField.text;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 0) {
        
//        TFDepartmentManageController *department = [[TFDepartmentManageController alloc] init];
//        department.actionParameter = ^(NSArray *arr){
//        
//            self.parentDepartment = arr[0];
//            [self.tableView reloadData];
//        };
//        [self.navigationController pushViewController:department animated:YES];
        
        TFCompanyFrameworkController *companyGroup = [[TFCompanyFrameworkController alloc] init];
        companyGroup.type = 2;
        companyGroup.action = ^(id parameter) {
            
            self.parentDepartment = parameter;
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:companyGroup animated:YES];
        
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
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
