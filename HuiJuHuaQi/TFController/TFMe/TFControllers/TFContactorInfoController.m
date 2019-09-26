//
//  TFContactorInfoController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFContactorInfoController.h"
#import "HQSelectTimeCell.h"
#import "TFMyCardView.h"
#import "TFFileBL.h"
#import "TFEmpInfoModel.h"
#import "HQAreaManager.h"
#import "TFChatBL.h"
#import "TFChatViewController.h"
#import "TFChatInfoListModel.h"
#import "TFEmailsNewController.h"

@interface TFContactorInfoController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFFileBL */
@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, strong) TFEmpInfoModel *empModel;

/** HQAreaManager */
@property (nonatomic, strong) HQAreaManager *areaManager;

@property (nonatomic, strong) TFChatBL *chatBL;
@end

@implementation TFContactorInfoController

-(HQAreaManager *)areaManager{
    if (!_areaManager) {
        _areaManager = [HQAreaManager defaultAreaManager];
    }
    return _areaManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    [self.fileBL requestQueryEmployeeInfoWithData:self.signId];
    
    self.navigationItem.title = @"个人信息";
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
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TFMyCardView *cardView = [TFMyCardView myCardView];
    cardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    cardView.type = 1;
    [cardView refreshMyCardViewWithEmployee:self.empModel.employeeInfo];
    tableView.tableHeaderView = cardView;
    
    [self footerView];
    
}

-(void)footerView{
    
    if (![self.signId isEqualToNumber:@([UM.userLoginInfo.employee.sign_id integerValue])]) {
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,85}];
        self.tableView.tableFooterView = view;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 35, SCREEN_WIDTH/2,50);
        [view addSubview:button];
        button.backgroundColor = WhiteColor;
        [button setTitle:@" 发起聊天" forState:UIControlStateNormal];
        [button setTitle:@" 发起聊天" forState:UIControlStateHighlighted];
        [button setImage:IMG(@"企信选中") forState:UIControlStateNormal];
        [button setImage:IMG(@"企信选中") forState:UIControlStateHighlighted];
        [button setTitleColor:GreenColor forState:UIControlStateNormal];
        [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
        
        if (!IsStrEmpty(self.empModel.employeeInfo.email)) {
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = CGRectMake(SCREEN_WIDTH/2, 35, SCREEN_WIDTH/2,50);
            [view addSubview:button2];
            button2.backgroundColor = WhiteColor;
            [button2 setTitle:@" 发邮件" forState:UIControlStateNormal];
            [button2 setTitle:@" 发邮件" forState:UIControlStateHighlighted];
            [button2 setImage:IMG(@"邮件1") forState:UIControlStateNormal];
            [button2 setImage:IMG(@"邮件1") forState:UIControlStateHighlighted];
            [button2 setTitleColor:GreenColor forState:UIControlStateNormal];
            [button2 setTitleColor:GreenColor forState:UIControlStateHighlighted];
            [button2 addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *line = [[UIView alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2,35,0.5,50}];
            [view addSubview:line];
            line.backgroundColor = CellSeparatorColor;
        }else{
            button.width = SCREEN_WIDTH;
        }
        
    }
}

- (void)chat{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    //添加单聊
    [self.chatBL requestAddSingleChatWithData:self.signId];
    
}

- (void)sendEmail{
    
    TFEmailsNewController *newEmail = [[TFEmailsNewController alloc] init];
    TFEmailReceiveListModel *model = [[TFEmailReceiveListModel alloc] init];
    model.from_recipient = UM.userLoginInfo.employee.email;
    TFEmailPersonModel *em = [[TFEmailPersonModel alloc] init];
    em.employee_name = self.empModel.employeeInfo.employee_name;
    em.mail_account = self.empModel.employeeInfo.email;
    model.to_recipients = [NSMutableArray <TFEmailPersonModel,Optional>arrayWithObject:em];
    newEmail.detailModel = model;
    [self.navigationController pushViewController:newEmail animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"部门";
            cell.time.text = @"未设置";
            if (self.empModel.departmentInfo.count) {
                TFEmpDepartmentInfoModel *de = self.empModel.departmentInfo[0];
                cell.time.text = de.department_name;
            }
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            return cell;
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"上级";
            cell.time.text = @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"职务";
            if (self.empModel.employeeInfo.employee_name && ![self.empModel.employeeInfo.employee_name isEqualToString:@""]) {
                cell.time.text = self.empModel.employeeInfo.post_name;
            }else{
                cell.time.text = @"未设置";
            }
            
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = YES;
            cell.topLine.hidden = YES;
            return cell;
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"性别";
            cell.time.text = !IsStrEmpty(self.empModel.employeeInfo.sex)?([self.empModel.employeeInfo.sex integerValue]==0?@"男":@"女"):@"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            return cell;
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"生日";
            cell.time.text = (self.empModel.employeeInfo.birth && ![self.empModel.employeeInfo.birth isEqualToString:@""]) ? [HQHelper nsdateToTime:[self.empModel.employeeInfo.birth longLongValue] formatStr:@"yyyy-MM-dd"] : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"地区";
            BOOL condition = (self.empModel.employeeInfo.region && ![self.empModel.employeeInfo.region isEqualToString:@""]);
            cell.time.text = condition ? [self.areaManager regionWithRegionData:TEXT(self.empModel.employeeInfo.region)] : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = YES;
            cell.topLine.hidden = YES;
            return cell;
        }
        
    }else{
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"手机";
            cell.time.text = (self.empModel.employeeInfo.phone && ![self.empModel.employeeInfo.phone isEqualToString:@""]) ? self.empModel.employeeInfo.phone : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
                cell.arrowShowState = NO;
            }else{
                cell.time.textColor = GreenColor;
                cell.arrowShowState = YES;
                cell.arrow.image = IMG(@"列表拨号");
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            return cell;
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"座机";
            cell.time.text = (self.empModel.employeeInfo.mobile_phone && ![self.empModel.employeeInfo.mobile_phone isEqualToString:@""]) ? self.empModel.employeeInfo.mobile_phone : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
                cell.arrowShowState = NO;
            }else{
                cell.time.textColor = GreenColor;
                cell.arrowShowState = YES;
                cell.arrow.image = IMG(@"座机");
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"邮箱";
            cell.time.text = (self.empModel.employeeInfo.email && ![self.empModel.employeeInfo.email isEqualToString:@""]) ? self.empModel.employeeInfo.email : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = YES;
            cell.topLine.hidden = YES;
            return cell;
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            if (!self.empModel.employeeInfo.phone || [self.empModel.employeeInfo.phone isEqualToString:@""]) {
                return;
            }
            
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.empModel.employeeInfo.phone];
            
            UIWebView *callWebview = [[UIWebView alloc]init];
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            
            [self.view addSubview:callWebview];
            
        }else if (indexPath.row == 1){
            
            if (!self.empModel.employeeInfo.mobile_phone || [self.empModel.employeeInfo.mobile_phone isEqualToString:@""]) {
                return;
            }
            
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.empModel.employeeInfo.mobile_phone];
            
            UIWebView *callWebview = [[UIWebView alloc]init];
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            
            [self.view addSubview:callWebview];
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 0;
        }
    }else if (indexPath.section == 1){
        return 0;
    }
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        return 0;
    }
    return 10;
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
    
    if (resp.cmdId == HQCMD_queryEmployeeInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.empModel = resp.body;
        
        [self setupTableView];
    }
    if (resp.cmdId == HQCMD_addSingleChat) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        TFChatInfoListModel *model = resp.body;
        TFChatViewController *send = [[TFChatViewController alloc] init];
        
        send.cmdType = [model.chat_type integerValue];
        send.chatId = model.id;
        send.receiveId = [model.receiver_id integerValue];
        
        send.naviTitle = model.employee_name;
        send.picture = model.picture;
        
        
        TFFMDBModel *dd = [model chatListModel];
        dd.mark = @3;
        [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:dd];
        
        [self.navigationController pushViewController:send animated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
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
