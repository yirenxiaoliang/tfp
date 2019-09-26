//
//  TFPersonalMaterialController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPersonalMaterialController.h"
#import "TFEditMaterialController.h"
#import "TFMyMaterialCardView.h"
#import "TFEditSignController.h"
#import "TFChatViewController.h"
#import "HQPersonInfoVC.h"
#import "HQSelectTimeCell.h"

#import "TFEmpInfoModel.h"
#import "TFChatInfoListModel.h"

#import "TFFileBL.h"
#import "TFChatBL.h"


@interface TFPersonalMaterialController ()<UITableViewDelegate,UITableViewDataSource,TFMyMaterialCardViewDelegate,HQBLDelegate,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** cardView */
@property (nonatomic, strong) TFMyMaterialCardView *cardView;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFEmpInfoModel *empModel;

@end

@implementation TFPersonalMaterialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCardView];
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    [self.fileBL requestQueryEmployeeInfoWithData:self.signId];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)setupCardView {
    
    self.cardView = [[TFMyMaterialCardView alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 155)];

    self.cardView.delegate = self;

}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,185}];
    [view addSubview:self.cardView];
    view.backgroundColor = WhiteColor;
    
    tableView.tableHeaderView = view;
    
    [self createBottomView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *titleArr = @[@"手机",@"座机",@"邮箱"];
    NSArray *contentArr = @[[NSString stringWithFormat:@"%@",self.empModel.employeeInfo.phone],[NSString stringWithFormat:@"%@",self.empModel.employeeInfo.mobile_phone],[NSString stringWithFormat:@"%@",self.empModel.employeeInfo.email]];
    
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    
    cell.arrowShowState = NO;
    cell.requireLabel.hidden = YES;
    cell.timeTitle.text = titleArr[indexPath.row];
    cell.time.text = contentArr[indexPath.row];
    
    
    if (indexPath.row < 2) {
        cell.time.textColor = HexColor(0x4A90E2);
    }else{
        cell.time.textColor = BlackTextColor;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
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
        
    }else{
        
        
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

- (void)createBottomView {

    if (![UM.userLoginInfo.employee.sign_id isEqualToNumber:self.signId]) {
        
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.frame = CGRectMake(0, 50, SCREEN_WIDTH, 49);
        
        [bottomBtn setImage:IMG(@"发起聊天") forState:UIControlStateNormal];
        [bottomBtn setTitle:@" 发起聊天" forState:UIControlStateNormal];
        [bottomBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        [bottomBtn setBackgroundColor:WhiteColor];
        
        [bottomBtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
    //    bottomBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
//        [self.view addSubview:bottomBtn];
//
        self.tableView.height = SCREEN_HEIGHT-NaviHeight;

        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,150}];
        [view addSubview:bottomBtn];
        self.tableView.tableFooterView = view;
        
    }else{
        self.tableView.tableFooterView = [UIView new];
        self.tableView.height = SCREEN_HEIGHT-NaviHeight;
    }
}

- (void)goChat {

    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    //添加单聊
    [self.chatBL requestAddSingleChatWithData:self.empModel.employeeInfo.sign_id];

    
}

#pragma mark TFMyMaterialCardViewDelegate
- (void)editPersonalMaterial {

    if ([UM.userLoginInfo.employee.sign_id isEqualToNumber:self.signId]) {
        
//        TFEditMaterialController *edit = [[TFEditMaterialController alloc] init];
//
//        [self.navigationController pushViewController:edit animated:YES];
        
        
        HQPersonInfoVC *personInfoVC = [[HQPersonInfoVC alloc] init];
        personInfoVC.refresh = ^(id parameter) {
            
            [self.fileBL requestQueryEmployeeInfoWithData:self.signId];
        };
        [self.navigationController pushViewController:personInfoVC animated:YES];

    }
    
}

- (void)editPersonalSign {

    if ([UM.userLoginInfo.employee.sign_id isEqualToNumber:self.signId]) {
        
        TFEditSignController *sign = [[TFEditSignController alloc] init];

        sign.sign = self.empModel.employeeInfo.sign;
        sign.emoStr = self.empModel.employeeInfo.mood;
        
        sign.refreshAction = ^(id parameter) {
          
            self.empModel.employeeInfo.sign = [parameter valueForKey:@"sign"];
            
            self.empModel.employeeInfo.mood = [parameter valueForKey:@"emotion"];
            [self.fileBL requestQueryEmployeeInfoWithData:self.signId];
        };

        
        [self.navigationController pushViewController:sign animated:YES];
    }
    
}

- (void)zanClicked {

    if ([self.empModel.fabulous_status isEqualToNumber:@0]) {
        
        [self.fileBL requestEmpWhetherFabulousWithData:self.empModel.employeeInfo.id status:@1];
    }
    else {
    
        [self.fileBL requestEmpWhetherFabulousWithData:self.empModel.employeeInfo.id status:@0];
    }
    
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryEmployeeInfo) {
        
        self.empModel = resp.body;
        
        //刷新
        [self.cardView refreshCardViewWithData:self.empModel];
        
        [self setupTableView];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.navigationItem.title = self.empModel.employeeInfo.employee_name;
        
    }
    if (resp.cmdId == HQCMD_empWhetherFabulous) {
        
        if ([self.empModel.fabulous_status isEqualToNumber:@0]) {
            
            self.empModel.fabulous_status = @1;
            self.empModel.fabulous_count = @([self.empModel.fabulous_count integerValue] + 1);
        }
        else {
            
            self.empModel.fabulous_status = @0;
            self.empModel.fabulous_count = @([self.empModel.fabulous_count integerValue] - 1);
        }
        //刷新
        [self.cardView refreshCardViewWithData:self.empModel];
    }
    
    if (resp.cmdId == HQCMD_addSingleChat) { //发起聊天
        
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
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
