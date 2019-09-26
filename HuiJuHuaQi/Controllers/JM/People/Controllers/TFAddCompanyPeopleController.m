//
//  TFAddCompanyPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddCompanyPeopleController.h"
#import "HQAddContactsCtrl.h"
#import "HQTFInputCell.h"
#import "TFCreateDepartmentController.h"
#import "TFCreatePositionController.h"
#import "TFPositionManageController.h"
#import "TFDepartmentManageController.h"
#import "TFPeopleBL.h"
#import "HQEmployModel.h"
#import "HQDepartmentModel.h"
#import "TFPositionModel.h"
#import "HQContactsModel.h"
#import "TFCompanyFrameworkController.h"
#import "TFDepartmentModel.h"

@interface TFAddCompanyPeopleController ()<UITableViewDataSource,UITableViewDelegate,HQTFInputCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** titles */
@property (nonatomic, strong) NSArray *titles;
/** placeHoders */
@property (nonatomic, strong) NSArray *placeHoders;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** index */
@property (nonatomic, assign) NSInteger index;

/** HQEmployModel */
@property (nonatomic, strong) TFEmployModel *employee;


@end

@implementation TFAddCompanyPeopleController

-(TFEmployModel *)employee{
    
    if (!_employee) {
        _employee = [[TFEmployModel alloc] init];
    }
    return _employee;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"姓名",@"手机号",@"编号",@"部门",@"职务"];
    self.placeHoders = @[@"请输入成员姓名",@"请输入成员手机号",@"请输入成员编号",@"请选择部门",@"请选择职务"];
    
    [self setupTableView];
    [self setupFooter];
    self.navigationItem.title = @"添加成员";
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
}

#pragma mark - footer
- (void)setupFooter{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,180}];
    
    for (NSInteger i = 0; i<2; i++) {
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,30 + (50 + 20)*i,SCREEN_WIDTH-50,50} target:self action:@selector(buttonClick:)];
        [view addSubview:button];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = FONT(20);
        button.tag = 0x2345 + i;
        
        if (i == 0) {
            [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
            [button setTitle:@"完成" forState:UIControlStateNormal];
            [button setTitle:@"完成" forState:UIControlStateHighlighted];
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
          
            
        }else{
            
            [button setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xe7e7e7, 1)] forState:UIControlStateNormal];
            [button setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xe7e7e7, 1)] forState:UIControlStateHighlighted];
            [button setTitle:@"保存并继续添加" forState:UIControlStateNormal];
            [button setTitle:@"保存并继续添加" forState:UIControlStateHighlighted];
            [button setTitleColor:GreenColor forState:UIControlStateNormal];
            [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
            
        }
    }
    
    self.tableView.tableFooterView = view;
}

- (void)buttonClick:(UIButton *)button{
    
    self.index = button.tag-0x2345;
    
    if (!self.employee.employee_name || [self.employee.employee_name isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入成员姓名" toView:self.view];
        return;
    }
    
    if (!self.employee.phone || [self.employee.phone isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入成员手机号" toView:self.view];
        return;
    }
    
    if (![HQHelper checkTel:self.employee.phone]) {
        
        [MBProgressHUD showError:@"您输入的手机号有误" toView:self.view];
        return;
    }
    
    if (!self.employee.departmentId) {
        
        [MBProgressHUD showError:@"请输入部门" toView:self.view];
        return;
    }
    
//    [self.peopleBL requestAddOrUpdateEmployeeWithEmployee:self.employee];
//    [self.peopleBL requestAddEmployeeWithEmployee:self.employee];
        
    
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

- (void)headerClick{
    HQAddContactsCtrl *tele = [[HQAddContactsCtrl alloc] init];
    tele.actionParameter = ^(HQContactsModel *parameter) {
        self.employee.employee_name = [NSString stringWithFormat:@"%@%@", TEXT(parameter.lastName) , TEXT(parameter.firstName)];;
        self.employee.phone = [[parameter.phones firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:tele animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *indentifier = @"HQBaseCell";
        HQBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        if (!cell) {
            cell = [[HQBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.topLine.hidden = YES;
        
        UIButton *header = [HQHelper buttonWithFrame:(CGRect){0,0,SCREEN_WIDTH,85} normalImageStr:@"手机" highImageStr:@"手机" target:self action:@selector(headerClick)];
        header.backgroundColor = WhiteColor;
        [header setTitle:@"    添加手机联系人" forState:UIControlStateNormal];
        [header setTitle:@"    添加手机联系人" forState:UIControlStateHighlighted];
        [header setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [header setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
        
        [cell.contentView addSubview:header];
        
        return cell;
    }else{
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = self.titles[indexPath.row];
        cell.textField.placeholder = self.placeHoders[indexPath.row];
        cell.delegate = self;
        cell.textField.tag = 0x456 + indexPath.row;
        cell.enterBtn.tag = 0x123 + indexPath.row;
        if (indexPath.row < 3) {
            [cell refreshInputCellWithType:0];
            cell.textField.userInteractionEnabled = YES;
        }else{
            [cell refreshInputCellWithType:3];
            cell.textField.userInteractionEnabled = NO;
        }
        if (indexPath.row == 0) {
            cell.textField.text = self.employee.employee_name;
        }else if (indexPath.row == 1){
            cell.textField.text = self.employee.phone;
        }else if (indexPath.row == 2){
            cell.textField.text = self.employee.account;
        }else if (indexPath.row == 3){
            cell.textField.text = self.employee.departmentName;
        }else{
            cell.textField.text = self.employee.post_name;
        }
        
        return cell;
    }
    
}

- (void)inputCellDidClickedEnterBtn:(UIButton *)button{
    
    if (button.tag - 0x123 == 3) {
        TFCreateDepartmentController *department = [[TFCreateDepartmentController alloc] init];
        [self.navigationController pushViewController:department animated:YES];
    }
    
    if (button.tag - 0x123 == 4) {
        
        TFCreatePositionController *position = [[TFCreatePositionController alloc] init];
        [self.navigationController pushViewController:position animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 3) {
        
//        TFDepartmentManageController *department = [[TFDepartmentManageController alloc] init];
//        department.isMutiSelect = YES;
//        department.actionParameter = ^(NSArray *arr){
//            NSMutableArray *ids = [NSMutableArray array];
//            NSString *str = @"";
//            for (HQDepartmentModel *model in arr) {
//                
//                [ids addObject:model.id];
//                
//                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.departmentName]];
//            }
//            str = [str substringToIndex:str.length-1];
//            self.employee.departmentIds = ids;
//            self.employee.department = str;
//            [self.tableView reloadData];
//        };
//        [self.navigationController pushViewController:department animated:YES];
        
        
        
        TFCompanyFrameworkController *companyGroup = [[TFCompanyFrameworkController alloc] init];
        companyGroup.type = 2;
        companyGroup.action = ^(TFDepartmentModel *parameter) {
          
            
            self.employee.departmentId = parameter.id;
            self.employee.departmentName = parameter.name;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:companyGroup animated:YES];
        
    }
    
    if (indexPath.row == 4) {
        TFPositionManageController *positionManage = [[TFPositionManageController alloc] init];
        positionManage.actionParameter = ^(TFPositionModel *model){
            
            self.employee.post_name = model.name;
            self.employee.post_id = model.id;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:positionManage animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 85;
    }
    return 55;
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

#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    switch (textField.tag - 0x456) {
        case 0:
        {
            self.employee.employee_name = textField.text;
        }
            break;
        case 1:
        {
            self.employee.phone = textField.text;
        }
            break;
        case 2:
        {
            self.employee.account = textField.text;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    if (resp.cmdId == HQCMD_addEmployee) {
//        
//        if (self.index == 0) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            
//            self.employee = [[TFEmployModel alloc] init];
//            [self.tableView reloadData];
//        }
//    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
