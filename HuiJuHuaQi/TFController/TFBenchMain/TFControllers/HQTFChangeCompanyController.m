//
//  HQTFChangeCompanyController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFChangeCompanyController.h"
#import "HQTFRelateCell.h"
#import "HQTFMorePeopleCell.h"
#import "HQTFPeopleCell.h"
#import "HQTFInputCell.h"
#import "HQEmployModel.h"
#import "TFCompanyGroupController.h"

@interface HQTFChangeCompanyController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate>
@property (nonatomic , strong)UITableView *tableView;

/** 成员 */
@property (nonatomic, strong) HQEmployModel *employ;
@property (nonatomic, copy) NSString *password;

@end

@implementation HQTFChangeCompanyController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    
}

#pragma mark - Navigation
- (void)setupNavigation{
    
    
//    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(searchClick) image:@"加号" highlightImage:@"加号"];
//    self.navigationItem.rightBarButtonItems = @[item2];
    
    self.navigationItem.title = @"转让企业";
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
    tableView.layer.masksToBounds = NO;
    
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,80}];
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,15,SCREEN_WIDTH-50,50} target:self action:@selector(sureClicked:)];
    [button setTitle:@"确定转让" forState:UIControlStateNormal];
    [view addSubview:button];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.backgroundColor = GreenColor;
    tableView.tableFooterView = view;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
- (void)sureClicked:(UIButton *)button{
    
    if (!self.employ) {
        [MBProgressHUD showError:@"请选择被转让人" toView:self.view];
        return;
    }
    if (!self.password || [self.password isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入账户密码" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self.registerBL requestCompanyAssigmentWithAssignmenterId:self.employ.id?self.employ.id:self.employ.employeeId password:self.password];
}

#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,60}];
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){26,0,SCREEN_WIDTH-52,50} text:@"提示：转让企业后，你将无法在管理当前企业，并且该操作无法撤销。" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        label.numberOfLines = 0;
        
        [view addSubview:label];
        return view;
    }
    return [UIView new];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HQTFRelateCell *cell = [HQTFRelateCell relateCellWithTableView:tableView];
        [cell refreshCellWithCompany:UM.userLoginInfo.company.company_name withType:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bottomLine.hidden = YES;
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            if (!self.employ) {
                HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
                cell.titleLabel.text = @"选择成员";
                cell.contentLabel.text = @"请添加";
                cell.contentLabel.textColor = PlacehoderColor;
                cell.bottomLine.hidden = NO;
                [cell refreshMorePeopleCellWithPeoples:@[]];
                return cell;
            }else{
                HQTFPeopleCell *cell = [HQTFPeopleCell peopleCellWithTableView:tableView];
                cell.peoples = @[self.employ];// self.creatTask.appoints
                cell.titleLabel.text = @"选择成员";
                cell.contentLabel.text = @"";
                cell.contentLabel.textColor = LightBlackTextColor;
                cell.bottomLine.hidden = NO;
                return cell;
            }
        }else{
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            cell.titleLabel.text = @"密码";
            cell.textField.placeholder = @"请输入当前账号密码";
            cell.delegate = self;
            cell.bottomLine.hidden = YES;
            cell.textField.text = self.password;
            [cell refreshInputCellWithType:1];
            return cell;
            
        }
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        return 60;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 88;
    }
    return 55;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1 && indexPath.row == 0) {
        
        TFCompanyGroupController *depart = [[TFCompanyGroupController alloc] init];
        depart.type = 2;
        depart.isSingle = YES;
        depart.actionParameter = ^(NSArray *peoples){
            
            self.employ = peoples[0];
            
            [tableView reloadData];
            
        };
        [self.navigationController pushViewController:depart animated:YES];
    }
}

#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    self.password = textField.text;
}

#pragma mark - 网络请求代理
//-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
//    if (resp.cmdId == HQCMD_companyAssignment) {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//
//-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
////    [self.tableView.mj_footer endRefreshing];
////    [self.tableView.mj_header endRefreshing];
//    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
//}



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
