//
//  HQTFPeopleInfoController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFPeopleInfoController.h"
#import "HQTFPeopleHeadInfoCell.h"
#import "HQSelectTimeCell.h"
#import "AlertView.h"
#import "TFProjectBL.h"
#import "TFProjectPricipalModel.h"

@interface HQTFPeopleInfoController ()<UITableViewDataSource,UITableViewDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** btn */
@property (nonatomic, weak) UIButton *chatBtn;
/** btn */
@property (nonatomic, weak) UIButton *deleteBtn;
/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** TFProjectPricipalModel */
@property (nonatomic, strong) TFProjectPricipalModel *pricipal;


@end

@implementation HQTFPeopleInfoController

-(TFProjectPricipalModel *)pricipal{
    if (!_pricipal) {
        _pricipal.employeeId = self.participant.employeeId;
        _pricipal.employeeName = self.participant.employeeName;
        _pricipal.photograph = self.participant.photograph;
        _pricipal.email = self.participant.email;
        _pricipal.telephone = self.participant.telephone;
        _pricipal.departmentName =self.participant.departmentName;
        
    }
    return _pricipal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTableView];
    [self setupFooter];
    [self refreshFooterWithType:1];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    [self.projectBL requestProjectPrincipalInfoWithProjectId:self.projectItem.id employeeId:self.participant.employeeId];
}

#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.title = self.projectItem.projectName;
}

- (void)refreshFooterWithType:(NSInteger)type{
    
    switch (type) {
        case 0:
        {
            self.chatBtn.frame = (CGRect){25,30 + (50 + 20)*0,SCREEN_WIDTH-50,50};
            self.deleteBtn.frame = (CGRect){25,30 + (50 + 20)*1,SCREEN_WIDTH-50,50};
        }
            break;
        case 1:
        {
            
            self.chatBtn.frame = (CGRect){25 + ((SCREEN_WIDTH-75)/2 + 25) * 0,30 + (50 + 20)*0,(SCREEN_WIDTH-75)/2,50};
            self.deleteBtn.frame = (CGRect){25 + ((SCREEN_WIDTH-75)/2 + 25) * 1,30 + (50 + 20)*0,(SCREEN_WIDTH-75)/2,50};
        }
            break;
            
        default:
            break;
    }
    
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
            /*[button setTitle:@"@张晓天" forState:UIControlStateNormal];
            [button setTitle:@"@张晓天" forState:UIControlStateHighlighted];
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];*/
            [button setImage:[UIImage imageNamed:@"聊天24"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"聊天24"] forState:UIControlStateHighlighted];
            self.chatBtn = button;
            
        }else{
            
            [button setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xe7e7e7, 1)] forState:UIControlStateNormal];
            [button setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xe7e7e7, 1)] forState:UIControlStateHighlighted];
            /*[button setTitle:@"删除" forState:UIControlStateNormal];
            [button setTitle:@"删除" forState:UIControlStateHighlighted];
            [button setTitleColor:GreenColor forState:UIControlStateNormal];
             [button setTitleColor:GreenColor forState:UIControlStateHighlighted];*/
            [button setImage:[UIImage imageNamed:@"删除24"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"删除24"] forState:UIControlStateHighlighted];
            self.deleteBtn =  button;
        }
    }
    
    self.tableView.tableFooterView = view;
    
}

- (void)buttonClick:(UIButton *)button{
    
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if (button.tag-0x2345 == 0) {// @谁
        
        [AlertView showAlertView:@"激活提醒" msg:@"发送激活提醒短信给成员" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
            
        } onRightTouched:^{
            
        }];
        
    }else{// 删除
        
        [AlertView showAlertView:@"删除" msg:@"成员将无法接受或发出项目信息内容" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
            
        } onRightTouched:^{
            
            [self.projectBL requestDelProjParticipantWithProjectId:self.projectItem.id employeeId:self.participant.employeeId];
        }];
    }
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
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"项目成员共5个" textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        
        HQTFPeopleHeadInfoCell *cell = [HQTFPeopleHeadInfoCell peopleHeadInfoCellWithTableView:tableView];
        [cell refreshPeopleHeadInfoCellWithModel:self.pricipal];
        cell.headMargin = 0;
        return cell;
    }else if (indexPath.row == 1){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"公司";
        cell.arrowShowState = NO;
        cell.time.text = self.pricipal.companyName;
        cell.time.textColor = LightBlackTextColor;
        cell.bottomLine.hidden = NO;
        return  cell;
    }else if (indexPath.row == 2){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"部门";
        cell.arrowShowState = NO;
        cell.time.text = self.pricipal.departmentName;
        cell.time.textColor = LightBlackTextColor;
        cell.bottomLine.hidden = NO;
        return  cell;
    }else if (indexPath.row == 3){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"职务";
        cell.arrowShowState = NO;
        cell.time.text = self.pricipal.position;
        cell.time.textColor = LightBlackTextColor;
        
        cell.bottomLine.hidden = NO;
        return  cell;
    }else if (indexPath.row == 4){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"手机";
        cell.arrowShowState = YES;
        cell.arrow.image = [UIImage imageNamed:@"电话"];
        cell.time.text = self.pricipal.telephone;
        cell.time.textColor = LightBlackTextColor;
        
        cell.bottomLine.hidden = NO;
        return  cell;
    }else{
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"邮箱";
        cell.arrowShowState = NO;
        cell.time.text = self.pricipal.email;
        cell.time.textColor = LightBlackTextColor;
        
        cell.bottomLine.hidden = YES;
        return  cell;
    }
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 4) {
        
        [self calledPhone];
    }
    
}

/**
 * 拨打电话号码
 */

-(void)calledPhone{
    
    //弹出电话号码的第1种方式
    NSString *tel = self.pricipal.telephone;
    
    NSString * str=[[NSString alloc] initWithFormat:@"tel:%@",tel];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 100;
    }
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
    
    if (resp.cmdId == HQCMD_projectEmployeeDetail) {
        
        self.pricipal = resp.body;
        
        if ([self.pricipal.isCreator isEqualToNumber:@1]) {
            
            [self refreshFooterWithType:0];
            self.deleteBtn.hidden = YES;
        }
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_delProjParticipant) {
        
        if (self.actionParameter) {
            self.actionParameter(self.participant);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    if (resp.cmdId == HQCMD_delProjParticipant) {
        
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
