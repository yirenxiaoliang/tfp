//
//  HQTFCreatCompanyController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCreatCompanyController.h"
#import "HQAddressView.h"
#import "HQIndustryView.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFInputCell.h"
#import "TFCompanyModel.h"
#import "HQHelpDetailCtrl.h"
#import "HQAreaManager.h"
#import "HQIndustryManager.h"
#import "HQCompanyModel.h"
#import "TFCompanyModel.h"

#define MARGIN 12.0
@interface HQTFCreatCompanyController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQTFInputCellDelegate>
@property (nonatomic , strong)UITableView *tableView;
/** addressView */
@property (nonatomic, strong) HQAddressView *addressView;
/** industryView */
@property (nonatomic, strong) HQIndustryView *industryView;
/** 创建公司Model */
@property (nonatomic, strong) TFCompanyModel *company;


@end

@implementation HQTFCreatCompanyController

-(TFCompanyModel *)company{
    if (!_company) {
        _company = [[TFCompanyModel alloc] init];
//        _company.telephone = UM.userLoginInfo.user.telephone;
//        _company.creater = UM.userLoginInfo.employee.employeeName;
    }
    return _company;
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
    [self setupNavigation];
    [self setupAddressAndIndustry];
    
    
}


#pragma mark - Navigation
- (void)setupNavigation{
    
    
    //    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(searchClick) image:@"加号" highlightImage:@"加号"];
    //    self.navigationItem.rightBarButtonItems = @[item2];
    if (self.type == 0) {
        
        self.navigationItem.title = @"注册企业";
    }else{
        
        self.navigationItem.title = @"编辑企业";
    }
}

- (void)setupAddressAndIndustry{
    __weak HQTFCreatCompanyController *this = self;
    self.addressView = [[HQAddressView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_HEIGHT-64)];
    self.addressView.sureAddressBlock = ^(id result) {
        [this setAddressWithDic:result];
    };
    [self.view addSubview:self.addressView];
    
    
    
    
    self.industryView = [[HQIndustryView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT-64)];
    self.industryView.sureIndustryBlock = ^(id result) {
        NSDictionary *dic = (NSDictionary *)result;
        [this setIndustryWithDic:dic];
    };
    [self.view addSubview:self.industryView];
}
- (void)setAddressWithDic:(id)addressDic
{
    self.company.companyAddress = addressDic[@"name"];
    self.company.addressId  = addressDic[@"id"];
    [self.addressView cancelView];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                           withRowAnimation:UITableViewRowAnimationNone];
}


- (void)setIndustryWithDic:(NSDictionary *)industyDic
{
    self.company.companyIndustry = industyDic[@"value"];
    self.company.industryId = industyDic[@"id"];
    [self.industryView cancelView];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]]
                           withRowAnimation:UITableViewRowAnimationNone];
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
    tableView.layer.masksToBounds = YES;
    
    tableView.tableFooterView = [self createTableViewFooterView];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}


- (UIView *)createTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    footerView.backgroundColor = BackGroudColor;
    
    
    UIView *contentView = [[UIView alloc] init];
    
    
    UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceButton.frame = CGRectMake(0, 0, 70, 65);
    [serviceButton setTitle:@"服务条款" forState:UIControlStateNormal];
    [serviceButton setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    serviceButton.titleLabel.font = FONT(14);
    [serviceButton addTarget:self action:@selector(servicePage:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:serviceButton];
    
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(serviceButton.right, 25, 1, 14)];
    lineView.backgroundColor = FinishedTextColor;
    [contentView addSubview:lineView];
    
    
    
    UIButton *secrecyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secrecyButton.frame = CGRectMake(lineView.right, 0, serviceButton.width, serviceButton.height);
    [secrecyButton setTitle:@"保密协议" forState:UIControlStateNormal];
    [secrecyButton setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    secrecyButton.titleLabel.font = FONT(14);
    [secrecyButton addTarget:self action:@selector(secretProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:secrecyButton];
    
    
    
    contentView.frame = CGRectMake((SCREEN_WIDTH-secrecyButton.width*2)/2, 0,secrecyButton.right,65);
    [footerView addSubview:contentView];
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(MARGIN, contentView.bottom, SCREEN_WIDTH-50 - MARGIN, 50);
    sureBtn.centerX = SCREEN_WIDTH * 0.5;
    
    if (self.type == 0) {
        [sureBtn setTitle:@"同意并注册" forState:UIControlStateNormal];
    }else{
        [sureBtn setTitle:@"同意并修改" forState:UIControlStateNormal];
    }
    sureBtn.backgroundColor = GreenColor;
    sureBtn.layer.cornerRadius = 5.0;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(agreementButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:sureBtn];
    return footerView;
}

- (void)agreementButton:(UIButton *)button{
    
    if (!self.company.companyName || [self.company.companyName isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入公司名称" toView:self.view];
        return;
    }
    if (!self.company.code || [self.company.code isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    if (!self.company.passWord || [self.company.passWord isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入账户密码" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {// 创建公司
        
//        [self.registerBL addOrFinishCompanyInfoWithCompanyName:self.company.companyName companyTel:self.company.telephone region:self.company.addressId industryCode:self.company.industryId isDefault:@0 code:self.company.code passWord:self.company.passWord];
    }else{
        
//        [self.registerBL requestCompanyEditWithCompanyModel:self.company];
    }
}


#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }
    return 4;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.type == 0) {
            
            NSString *string = @"你将以管理员身份成立企业，可建立员工帐号开始协作";
            
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:string];
            
            UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,size.height+20}];
            
            UILabel *label = [HQHelper labelWithFrame:(CGRect){15,10,SCREEN_WIDTH-30,size.height} text:string textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
            label.numberOfLines = 0;
            //        label.backgroundColor =RedColor;
            [view addSubview:label];
            return view;
        }
    }
    return [UIView new];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"企业名称20个字以内(必填)";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(20);
        cell.textVeiw.text = self.company.companyName;
        cell.textVeiw.tag = 0x12345;
        cell.bottomLine.hidden = YES;
        cell.textVeiw.userInteractionEnabled = YES;
        return cell;

    }else if (indexPath.section == 1){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        if (indexPath.row == 0) {
            
            cell.timeTitle.text = @"所在地";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = NO;
            if (!self.company.companyAddress || [self.company.companyAddress isEqualToString:@""]) {
                
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
            }else{
                
                cell.time.text = self.company.companyAddress;
                cell.time.textColor = LightBlackTextColor;
            }
            return  cell;
        }else{
            
            cell.timeTitle.text = @"所在行业";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = YES;
            if (!self.company.companyIndustry || [self.company.companyIndustry isEqualToString:@""]) {
                
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
            }else{
                
                cell.time.text = self.company.companyIndustry;
                cell.time.textColor = LightBlackTextColor;
            }
            return  cell;
        }
        
    }else{
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        cell.delegate = self;
        cell.textField.tag = 0x123 + indexPath.row;
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"真实姓名";
            cell.textField.placeholder = @"请输入真实姓名";
            cell.bottomLine.hidden = NO;
            cell.textField.text = self.company.creater;
            [cell refreshInputCellWithType:0];
//            if (self.type == 0) {
//                cell.textField.userInteractionEnabled = YES;
//            }else{
                cell.textField.userInteractionEnabled = NO;
//            }
            return cell;
        }else if (indexPath.row == 1){
            
            cell.titleLabel.text = @"手机号码";
            cell.textField.placeholder = @"请输入手机号";
            cell.bottomLine.hidden = NO;
            cell.textField.text = self.company.telephone;
            [cell refreshInputCellWithType:0];
            cell.textField.userInteractionEnabled = NO;
            return cell;
        }else if (indexPath.row == 2){
            
            cell.titleLabel.text = @"验证码";
            cell.textField.placeholder = @"请输入验证码";
            cell.bottomLine.hidden = NO;
            cell.textField.text = self.company.code;
            [cell refreshInputCellWithType:2];
            cell.textField.userInteractionEnabled = YES;
            return cell;
        }else{
            cell.textField.placeholder = @"请输入账户密码";
            cell.titleLabel.text = @"账户密码";
            cell.bottomLine.hidden = YES;
            [cell refreshInputCellWithType:1];
            cell.textField.text = self.company.passWord;
            cell.textField.userInteractionEnabled = YES;
            return cell;
        }
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    return 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.type == 0) {
            
            NSString *string = @"你将以管理员身份成立企业，可建立员工帐号开始协作";
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:string];
            
            return size.height + 20;
        }else{
            return 8;
        }
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
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.industryView cancelView];
            [self.addressView showView];
        }else if (indexPath.row == 1) {
            [self.addressView cancelView];
            [self.industryView showView];
            
        }
    }else{
        [self.addressView cancelView];
        [self.industryView cancelView];
        
    }
}


#pragma mark - 跳转到服务条款页面
-(void)servicePage:(UIButton * )sender{
    
    NSString *htmlUrl = [[NSBundle mainBundle] pathForResource:@"terms_of_service" ofType:@"html"];
    
    HQHelpDetailCtrl *helpDetailCtrl = [[HQHelpDetailCtrl alloc] init];
    helpDetailCtrl.title = @"服务条款";
    helpDetailCtrl.htmlUrl = htmlUrl;
    [self.navigationController pushViewController:helpDetailCtrl animated:YES];
}


#pragma mark - 跳转到保密协议页面

-(void)secretProtocol:(UIButton *)sender{
    
    
    NSString *htmlUrl = [[NSBundle mainBundle] pathForResource:@"Confidentilty_agreement" ofType:@"html"];
    
    HQHelpDetailCtrl *helpDetailCtrl = [[HQHelpDetailCtrl alloc] init];
    helpDetailCtrl.title = @"保密协议";
    helpDetailCtrl.htmlUrl = htmlUrl;
    [self.navigationController pushViewController:helpDetailCtrl animated:YES];
}

#pragma mark - HQTFInputCellDelegate
-(void)inputCellDidClickedEnterBtn:(UIButton *)button{
    
    [HQHelper timeBtn:button];
//    [self.registerBL sendVerifyCodeWithTelephone:self.company.telephone type:@0 deviceType:@0];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 0x12345) {
        self.company.companyName = textView.text;
    }
}

-(void)inputCellWithTextField:(UITextField *)textField{
    
    switch (textField.tag - 0x123) {
        case 0:
        {
            self.company.creater = textField.text;
        }
            break;
        case 1:
        {
            self.company.telephone = textField.text;
        }
            break;
        case 2:
        {
            self.company.code = textField.text;
        }
            break;
        case 3:
        {
            self.company.passWord = textField.text;
        }
            break;
            
        default:
            break;
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
