//
//  HQTFSelectCompanyController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFSelectCompanyController.h"
#import "HQBaseCell.h"
#import "HQTFRelateCell.h"
#import "HQTFChangeCompanyController.h"
#import "HQTFCreatCompanyController.h"
#import "HQCompanyModel.h"
#import "TFLoginBL.h"
#import "HQSelectTimeCell.h"
#import "HQTFTwoLineCell.h"
#import "HQTFNoContentView.h"

@interface HQTFSelectCompanyController ()<HQTFRelateCellDelegate,UITableViewDataSource, UITableViewDelegate,HQBLDelegate>

@property (nonatomic , strong)UITableView *tableView;
/** 公司 */
@property (nonatomic, strong) NSMutableArray *companys;

/** HQRegisterBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

/** 选中的公司 */
@property (nonatomic, strong) HQCompanyModel *selectCompany;


@end

@implementation HQTFSelectCompanyController

-(NSMutableArray *)companys{
    if (!_companys) {
        _companys = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 10; i ++) {
//            
//            [_companys addObject:[NSString stringWithFormat:@"我是公司我是公司%ld",i]];
//        }
    }
    return _companys;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.registerBL requestCompanyList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    [self.loginBL requestGetCompanyList];
}

#pragma mark - Navigation
- (void)setupNavigation{
    
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addClick) text:@"确定" textColor:GreenColor];
    
    self.navigationItem.title = @"选择企业";
}

- (void)addClick{
//    HQTFCreatCompanyController *create = [[HQTFCreatCompanyController alloc] init];
//    [self.navigationController pushViewController:create animated:YES];
    
    if (self.selectCompany) {
        
        // 切换公司
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        [self.registerBL requestLatelyCompanyUpdateWithCompanyId:company.id];
        [self.loginBL requestChangeCompanyWithCompanyId:[self.selectCompany.id description]];
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
    tableView.layer.masksToBounds = NO;
    
//    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
//    //    label.backgroundColor = GreenColor;
//    tableView.tableFooterView = label;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    HQTFNoContentView *noContentView = [HQTFNoContentView noContentView];
    [noContentView setupImageViewRect:(CGRect){30,(tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无可切换公司"];
    tableView.backgroundView = noContentView;
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
    return self.companys.count;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        HQTFRelateCell *cell = [HQTFRelateCell relateCellWithTableView:tableView];
//
//        [cell refreshCellWithCompany:UM.userLoginInfo.company.company_name withType:0];
//        cell.delegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.bottomLine.hidden = YES;
//
//        return cell;
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.titleImageWidth = 0;
        cell.bottomLine.hidden = YES;
        cell.topLabel.text = @"当前企业：";
        cell.bottomLabel.text = UM.userLoginInfo.company.company_name;
        cell.bottomLabel.textColor = GreenColor;
        cell.bottomLabel.font = FONT(17);
        
        return cell;
        
    }else{
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.bottomLine.hidden = YES;
        cell.timeTitle.textColor = BlackTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.requireLabel.hidden = YES;
        HQCompanyModel *company = self.companys[indexPath.row];
        cell.timeTitle.text = company.company_name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (0 == indexPath.row) {
            cell.topLine.hidden = YES;
        }else{
            cell.topLine.hidden = NO;
            if (indexPath.row == 1) {
                HQCompanyModel *company1 = self.companys.firstObject;
                if ([company1.id isEqualToNumber:UM.userLoginInfo.company.id]) {
                    cell.topLine.hidden = YES;
                }
            }
        }
        
        if (self.selectCompany) {
            cell.arrow.hidden = NO;
            if ([self.selectCompany.id isEqualToNumber:company.id]) {
                cell.arrow.image = [UIImage imageNamed:@"完成"];
            }else{
                cell.arrow.image = nil;
            }
            
        }else{
            cell.arrow.hidden = YES;
        }
        
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 88;
    }else{
        
        HQCompanyModel *company = self.companys[indexPath.row];
        if ([company.id isEqualToNumber:UM.userLoginInfo.company.id]) {
            return 0;
        }else{
            
            return 55;
        }
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        HQCompanyModel *company = self.companys[indexPath.row];
        self.selectCompany = company;
        
        [self.tableView reloadData];
    }
}

#pragma mark - HQTFRelateCellDelegate
-(void)clickedEditBtn{
    
    HQTFCreatCompanyController *create = [[HQTFCreatCompanyController alloc] init];
    create.type = 1;
    [self.navigationController pushViewController:create animated:YES];
}

-(void)clickedChangeBtn{
    HQTFChangeCompanyController *change = [[HQTFChangeCompanyController alloc] init];
    [self.navigationController pushViewController:change animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getCompanyList) {
        
//        NSMutableArray *arr = [NSMutableArray array];
//
//        for (HQCompanyModel *company in resp.body) {
//            if ([company.id isEqualToNumber:UM.userLoginInfo.company.id]) {
//                continue;
//            }
//            [arr addObject:company];
//        }
        [self.companys removeAllObjects];
        [self.companys addObjectsFromArray:resp.body];
        
        if (self.companys.count <= 1) {
            self.tableView.backgroundView.hidden = NO;
        }else{
            self.tableView.backgroundView.hidden = YES;
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_changeCompany) {
        
        [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
        
    }
    
    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        [self.loginBL requestEmployeeList];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
        
        [MBProgressHUD showImageSuccess:@"切换成功" toView:KeyWindow];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
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
