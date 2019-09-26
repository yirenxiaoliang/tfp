//
//  TFGroupChatSetController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFGroupChatSetController.h"
#import "TFChatDetailPeopleCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFThreeLabelCell.h"
#import "TFGroupPeopleController.h"
#import "TFPersonalMaterialController.h"
#import "TFGroupPeopleController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "HQTFProjectDescController.h"
#import "TFChatFileController.h"

#import "TFChatBL.h"
#import "TFChatInfoListModel.h"
#import "TFGroupInfoModel.h"
#import "TFSocketManager.h"
#import "HQConversationListController.h"
#import "AlertView.h"
#import "TFOneLableCell.h"
#import "TFContactorInfoController.h"

@interface TFGroupChatSetController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,HQSwitchCellDelegate,TFChatDetailPeopleCellDelegate,HQSwitchCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/**  */
@property (nonatomic, strong) JMSGGroup *jmsGroup;

/** 免打扰 */
@property (nonatomic, assign) BOOL isNoDisturb;

/** 是否为创建者 */
@property (nonatomic, assign) BOOL isCreator;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFChatInfoListModel *infoModel;

@property (nonatomic, strong) TFGroupInfoModel *groupModel;

@property (nonatomic, copy) NSString *users;

@property (nonatomic, strong) TFSocketManager *socket;

@property (nonatomic, copy) NSString *adds;

@end

@implementation TFGroupChatSetController

- (TFChatInfoListModel *)infoModel {

    if (!_infoModel) {
        
        _infoModel = [[TFChatInfoListModel alloc] init];
    }
    
    return _infoModel;
}

- (TFGroupInfoModel *)groupModel {
    
    if (!_groupModel) {
        
        _groupModel = [[TFGroupInfoModel alloc] init];
    }
    
    return _groupModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitView:) name:ReleaseGroupNotification object:nil];
    
    self.chatBL = [TFChatBL build];
    
    self.chatBL.delegate = self;
    
    [self requestData];
    
}

- (void)requestData {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.chatBL requestGetGroupInfoWithData:self.groupId];
}

- (void)setupNavigation {
    self.navigationItem.title = @"聊天详情";
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    self.tableView = tableView;
    
    
}

//退出／解散按钮
- (void)createBottomBtn {

    UIView *footer = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,110}];
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,30,SCREEN_WIDTH-50,50} target:self action:@selector(outClicked)];
    button.titleLabel.font = FONT(20);
    [footer addSubview:button];
    button.backgroundColor = HexColor(0xff6260);
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    
    if ([self.groupModel.groupInfo.type isEqualToString:@"0"]) { //公司总群
        
        button.hidden = YES;
    }
    else {
    
        if ([UM.userLoginInfo.employee.sign_id isEqualToNumber:self.groupModel.groupInfo.principal]) {
            
            [button setTitle:@"解散群聊" forState:UIControlStateNormal];
        }
        else {
            
            [button setTitle:@"退出群聊" forState:UIControlStateNormal];
        }

        self.tableView.tableFooterView = footer;
    }

}

- (void)outClicked{// 退群
    
    if ([UM.userLoginInfo.employee.sign_id isEqualToNumber:self.groupModel.groupInfo.principal]) { //解散群
    
        [AlertView showAlertView:@"您确定要解散群聊吗？" onLeftTouched:^{
            
        } onRightTouched:^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.chatBL requestReleaseGroupWithData:self.groupId];
        }];
        
    }
    else { //退群
    
        [AlertView showAlertView:@"您确定要退出群聊吗？" onLeftTouched:^{
            
        } onRightTouched:^{
            [self.chatBL requestQuiteGroupWithData:self.groupId];
        }];
        
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }else if (section == 1){
        
        if ([self.groupModel.groupInfo.principal isEqualToNumber:UM.userLoginInfo.employee.sign_id] && ![self.groupModel.groupInfo.type isEqualToString:@"0"]) {
            
            return 4;
        }
        else {
            
            return 3;
        }
        
    }
    else if (section == 2) {
    
        return 1;
    }
    else if (section == 3){
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == 0) {
            
            TFChatDetailPeopleCell *cell = [TFChatDetailPeopleCell chatDetailPeopleCellWithTableView:tableView];
            
            NSInteger type;
            if ([UM.userLoginInfo.employee.sign_id isEqualToNumber:self.groupModel.groupInfo.principal]) {
                
                if ([self.groupModel.groupInfo.type isEqualToString:@"0"]) {
                    
                    type = 0;
                }
                else {
                
                    type = 2;
                }
                
            }
            else {
            
                type = 0;
            }
            
            [cell refreshCellWithItems:self.groupModel.employeeInfo withType:type withColumn:5];

            cell.delegate = self;
            cell.bottomLine.hidden = NO;
            return cell;
        }else{
            
            TFOneLableCell *cell = [TFOneLableCell OneLableCellWithTableView:tableView];

            
            cell.titleLable.text = [NSString stringWithFormat:@"查看更多群成员（%ld）",self.groupModel.employeeInfo.count];
            [cell.enterBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
            
            return cell;
            
//            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
//            cell.timeTitle.text = [NSString stringWithFormat:@"查看更多群成员（%ld）",self.groupModel.employeeInfo.count];
//            cell.arrowShowState = YES;
//            cell.bottomLine.hidden = YES;
//            cell.time.text = @"";
//            cell.time.numberOfLines = 1;
//            return  cell;
        }
        
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"群聊名称";
            cell.bottomLine.hidden = NO;
            cell.time.text = self.groupModel.groupInfo.name;
            cell.time.numberOfLines = 1;
            
            if ([self.groupModel.groupInfo.principal isEqualToNumber:UM.userLoginInfo.employee.sign_id] && ![self.groupModel.groupInfo.type isEqualToString:@"0"]) {
                
                cell.arrowShowState = YES;
            }
            else {
            
                cell.arrowShowState = NO;
            }
            cell.topLine.hidden = YES;
            return  cell;
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"群聊公告";
            cell.bottomLine.hidden = NO;
            cell.time.text = self.groupModel.groupInfo.notice;
            cell.time.numberOfLines = 0;
            
            if ([self.groupModel.groupInfo.principal isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                
                cell.arrowShowState = YES;
            }
            else {
                
                cell.arrowShowState = NO;
            }
            
            cell.topLine.hidden = YES;
            return  cell;
        }
        else if (indexPath.row == 2) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"群管理员";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = NO;
            cell.time.text = self.groupModel.groupInfo.principal_name;
            cell.time.numberOfLines = 1;
            cell.topLine.hidden = YES;
            
            if ([self.groupModel.groupInfo.principal isEqualToNumber:UM.userLoginInfo.employee.sign_id] && ![self.groupModel.groupInfo.type isEqualToString:@"0"]) {
                cell.bottomLine.hidden = NO;
            }else{
                cell.bottomLine.hidden = YES;
            }
            return  cell;
        }
        else {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"转让群组";
            cell.bottomLine.hidden = YES;
            cell.time.text = @"";
            cell.time.numberOfLines = 0;
            cell.topLine.hidden = YES;
            cell.arrowShowState = YES;
            return  cell;
        }
        
    }
    else if (indexPath.section == 2) {
    
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"查看聊天文件";
        cell.arrowShowState = YES;
        cell.bottomLine.hidden = YES;
        cell.time.text = @"";
        cell.topLine.hidden = YES;
        return  cell;
    }
    else if (indexPath.section == 3){
        
        if (indexPath.row == 0) {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"置顶聊天";
            cell.bottomLine.hidden = NO;
            cell.switchBtn.tag = 0x123;
            
            if ([self.groupModel.groupInfo.top_status isEqualToString:@"1"]) {
                
                cell.switchBtn.on = YES;
            }
            else {
            
                cell.switchBtn.on = NO;
            }
            cell.topLine.hidden = YES;
            return cell;
        }else if (indexPath.row == 1){
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"消息免打扰";
            cell.bottomLine.hidden = YES;
//            cell.switchBtn.on = self.isNoDisturb;
            cell.switchBtn.tag = 0x456;
            
            if ([self.groupModel.groupInfo.no_bother isEqualToString:@"1"]) {
                
                cell.switchBtn.on = YES;
            }
            else {
                
                cell.switchBtn.on = NO;
            }
            cell.topLine.hidden = YES;
            return cell;
        }

    }
    

    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            TFGroupPeopleController *group = [[TFGroupPeopleController alloc] init];
            group.type = 0;
            group.memberArr = self.groupModel.employeeInfo;
            [self.navigationController pushViewController:group animated:YES];
        }
    }
    else if (indexPath.section == 1) {
    
        if (indexPath.row == 0) {
            
            if ([self.groupModel.groupInfo.principal isEqualToNumber:UM.userLoginInfo.employee.sign_id] && ![self.groupModel.groupInfo.type isEqualToString:@"0"]) { //群主才能修改
                
                HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
                desc.descString = self.groupModel.groupInfo.name;
                desc.naviTitle = @"修改群名称";
                desc.sectionTitle = @"群名称";
                desc.placehoder = @"群名称12个字以内（必填）";
                desc.wordNum = 12;
                desc.descAction = ^(NSString *text){
                    
                    self.groupModel.groupInfo.name = text;
                    
                    [self.chatBL requestModifyGroupInfoWithData:self.groupId groupName:self.groupModel.groupInfo.name notice:self.groupModel.groupInfo.notice];
                    
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    
                    if (self.refreshAction) {
                        
                        self.refreshAction(self.groupModel.groupInfo.name);
                    }
                    
                };
                [self.navigationController pushViewController:desc animated:YES];
            }
            
            
        }
        else if (indexPath.row == 1) {
        
            if ([self.groupModel.groupInfo.principal isEqualToNumber:UM.userLoginInfo.employee.sign_id]) { //群主才能修改
                
                HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
                desc.descString = self.groupModel.groupInfo.notice;
                desc.isNoNecessary = YES;
                desc.naviTitle = @"修改群公告";
                desc.sectionTitle = @"群公告";
                desc.placehoder = @"请输入100字以内（选填）";
                desc.wordNum = 100;
                desc.descAction = ^(NSString *text){
                    
                    self.groupModel.groupInfo.notice = text;
                    
                    [self.chatBL requestModifyGroupInfoWithData:self.groupId groupName:self.groupModel.groupInfo.name notice:self.groupModel.groupInfo.notice];
                    
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:desc animated:YES];
            }
            
        }
        else if (indexPath.row == 3) { //转让群主
            
            NSMutableArray *employees = [NSMutableArray array];
            for (TFGroupEmployeeModel *model in self.groupModel.employeeInfo) {
                
                if (![model.id isEqualToNumber:UM.userLoginInfo.employee.id]) {
                    
                    [employees addObject:model];
                }
            }
            TFGroupPeopleController *group = [[TFGroupPeopleController alloc] init];
            group.type = 3;
            group.memberArr = employees;
            group.groupId = self.groupId;
            group.actionHandler = ^{
              
                [self requestData];
            };
            [self.navigationController pushViewController:group animated:YES];
            
        }
    }
    
    else if (indexPath.section == 2) {
        
        TFChatFileController *chatFileVC = [[TFChatFileController alloc] init];
        
        chatFileVC.chatId = self.groupId;
        
        [self.navigationController pushViewController:chatFileVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {

            NSInteger type;
            
            if (self.groupModel.groupInfo != nil) {
                
                if ([UM.userLoginInfo.employee.sign_id isEqualToNumber:self.groupModel.groupInfo.principal]) {
                    
                    if ([self.groupModel.groupInfo.type isEqualToString:@"0"]) {
                        
                        type = 0;
                    }
                    else {
                        
                        type = 2;
                    }
                    
                }
                else {
                    
                    type = 0;
                }
                
                
                return [TFChatDetailPeopleCell refreshCellHeightWithItems:self.groupModel.employeeInfo withType:type withColumn:5];

            }
            
            
        }
        return 55;
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            
            CGFloat height = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH - 140,MAXFLOAT} titleStr:self.groupModel.groupInfo.notice].height+ 34;
            return height <= 55 ? 55 : height;
        }
    }
    else if (indexPath.section == 2){
//        if (indexPath.row == 0) {// 置顶
//            return 0;
//        }
    }
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else if (section == 4){
        return 20;
    }
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

#pragma mark - TFChatDetailPeopleCellDelegate
-(void)chatDetailPeopleCellDidClickedPeopleWithModel:(NSInteger)index{
    
//    TFPersonalMaterialController *personalVC = [[TFPersonalMaterialController alloc] init];
//
//    TFEmployeeCModel *employee = self.groupModel.employeeInfo[index];
//    personalVC.signId = employee.sign_id;
//    [self.navigationController pushViewController:personalVC animated:YES];
    
//    TFChatPeopleInfoController *chatPeople = [[TFChatPeopleInfoController alloc] init];
//    chatPeople.employee = self.groupModel.employeeInfo[index];
//    [self.navigationController pushViewController:chatPeople animated:YES];
    
    TFContactorInfoController *info = [[TFContactorInfoController alloc] init];
    TFEmployeeCModel *employee = self.groupModel.employeeInfo[index];
    info.signId = employee.sign_id;
    [self.navigationController pushViewController:info animated:YES];
    
}
-(void)chatDetailPeopleCellDidClickedAddButton{
    
    /*
    TFSelectChatPersonController *select = [[TFSelectChatPersonController alloc] init];
    select.type = 1;
    
    select.haveGroup = NO;
//    select.peoples = self.groupModel.employeeInfo;
    
    select.actionParameter = ^(NSArray *people){
        
        // 添加群组成员
        _users = @"";
        _adds = @"";
        
        for (HQEmployModel *model  in people) {
            
            _users = [_users stringByAppendingString:[NSString stringWithFormat:@",%@",[model.sign_id stringValue]]];
            _adds = [_adds stringByAppendingString:[NSString stringWithFormat:@",%@",model.employee_name]];
        }
    
        _users = [_users substringFromIndex:1];
        _adds = [_adds substringFromIndex:1];
        
        [self.chatBL requestPullPeopleWithData:self.groupId personId:_users];
    };
    
    [self.navigationController pushViewController:select animated:YES];
    */
     
    TFMutilStyleSelectPeopleController *selectChat = [[TFMutilStyleSelectPeopleController alloc] init];
    selectChat.selectType = 1;
    selectChat.isSingleSelect = NO;
//    selectChat.defaultPoeples = self.groupModel.groupInfo;//不可选的人
    
    NSMutableArray *noSelects = [NSMutableArray array];
    for (TFGroupEmployeeModel *em in self.groupModel.employeeInfo) {
        
        HQEmployModel *emp = [[HQEmployModel alloc] init];
        
        emp.id = em.id;
        emp.employeeId = em.id;
        
        [noSelects addObject:emp];
    }
    
    selectChat.noSelectPoeples = noSelects;
    
    selectChat.actionParameter = ^(NSMutableArray *employees){
        
        NSMutableArray *selects = [NSMutableArray array];
        for (HQEmployModel *em in employees) {
            
            BOOL have = NO;
            for (TFGroupEmployeeModel *emp in self.groupModel.employeeInfo) {
                
                if ([emp.id isEqualToNumber:em.employeeId]) {
                    
                    have = YES;
                    break;
                    
                }
            }
            if (!have) {
                
                [selects addObject:em];
                
            }
            
        }
        // 添加群组成员
        _users = @"";
        _adds = @"";
        
        if (selects.count > 0) {
            
            for (HQEmployModel *model  in selects) {
                
                _users = [_users stringByAppendingString:[NSString stringWithFormat:@",%@",[model.sign_id stringValue]]];
                _adds = [_adds stringByAppendingString:[NSString stringWithFormat:@",%@",model.employee_name]];
            }
            
            _users = [_users substringFromIndex:1];
            _adds = [_adds substringFromIndex:1];
            
            [self.chatBL requestPullPeopleWithData:self.groupId personId:_users];
        }
        

        
    };
    [self.navigationController pushViewController:selectChat animated:YES];
    
}
-(void)chatDetailPeopleCellDidClickedMinusBuuton{
    
    TFGroupPeopleController *group = [[TFGroupPeopleController alloc] init];
    group.type = 1;
    group.memberArr = self.groupModel.employeeInfo;
    
    group.actionParameter = ^(NSArray *peoples){
        
        _users = @"";
        
        for (HQEmployModel *model in peoples) {
            
            _users = [_users stringByAppendingString:[NSString stringWithFormat:@",%@",[model.sign_id  stringValue]]];
            
        }
        
        _users = [_users substringFromIndex:1];

        [self.chatBL requestKickPeopleWithData:self.groupId personId:_users];
        
        
    };
    [self.navigationController pushViewController:group animated:YES];
}

#pragma mark 通知方法
- (void)quitView:(NSNotification *)note {
    
    TFAssistantPushModel *model = note.object;
    
    if ([model.group_id isEqualToNumber:self.groupId]) {
        
        if ([model.type isEqualToNumber:@1]) {
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                
                if ([controller isKindOfClass:[HQConversationListController class]]) {
                    
                    [self.navigationController popToViewController:controller animated:YES];

                }
            }
            
        }
    }
    
}

#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if (switchButton.tag == 0x123) {
        
        if ([self.groupModel.groupInfo.top_status isEqualToString:@"0"]) {
            
            self.groupModel.groupInfo.top_status = @"1";
        }
        else {
            
            self.groupModel.groupInfo.top_status = @"0";
        }
        
        [self.chatBL requestSetTopChatWithData:self.groupId chatType:self.chatType];
        
        
    }
    
    if (switchButton.tag == 0x456) {
        
        if ([self.groupModel.groupInfo.no_bother isEqualToString:@"0"]) {
            
            self.groupModel.groupInfo.no_bother = @"1";
        }
        else {
            
            self.groupModel.groupInfo.no_bother = @"0";
            
        }
        
        [self.chatBL requestSetNoBotherWithData:self.groupId chatType:self.chatType];

    }

    
}
#pragma mark --释放内存
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
 
    if (resp.cmdId == HQCMD_getGroupInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.groupModel = resp.body;
        
        [self.view addSubview:self.tableView];
        
        [self createBottomBtn];
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        
        model.chatId = self.groupModel.groupInfo.id;
        model.groupPeoples = self.groupModel.groupInfo.peoples;
        //更新群成员
        [DataBaseHandle updateChatListGroupPeoplesWithData:model];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_releaseGroup) { //解散群
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"解散成功！" toView:self.view];
        
        [DataBaseHandle deleteChatListDataWithChatId:self.groupId];
        
        TFFMDBModel *dd = [[TFFMDBModel alloc] init];
        dd.chatId = self.groupId;
        dd.mark = @1;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:dd];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_quitChatGroup) { //退群
        
        [MBProgressHUD showError:@"退出成功！" toView:self.view];
        
        //数据库删除
        [DataBaseHandle deleteChatListDataWithChatId:self.groupId];
        
        self.socket = [TFSocketManager sharedInstance];
        //
        HQEmployModel *empModel = [HQHelper getEmployeeWithSignId:UM.userLoginInfo.employee.sign_id];
//        [self.socket sendMsgData:1 receiverId:self.groupId chatId:self.groupId text:[NSString stringWithFormat:@"%@退出了群",empModel.employee_name] msgType:@7 datas:@[] atList:@[] voiceTime:@0];
        [self.socket sendQuitGroupData:self.groupId chatId:self.groupId text:[NSString stringWithFormat:@"%@退出了群",empModel.employee_name] msgType:ChatTypeWithTip];
        
        TFFMDBModel *dd = [[TFFMDBModel alloc] init];
        dd.chatId = self.groupId;
        dd.mark = @2;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:dd];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_pullPeople) { //添加成员/移除成员
        
        [self requestData];
        
        [MBProgressHUD showError:@"设置成功" toView:self.view];
        
        self.socket = [TFSocketManager sharedInstance];
        //
//        HQEmployModel *empModel = [HQHelper getEmployeeWithSignId:UM.userLoginInfo.employee.sign_id];

    
        [self.socket sendMsgData:1 receiverId:self.groupId chatId:self.groupId text:[NSString stringWithFormat:@"欢迎%@加入群聊",_adds] msgType:ChatTypeWithTip datas:@[] atList:@[] voiceTime:0];
        // 会受到信息，不用刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:nil];

        
    }
    if (resp.cmdId == HQCMD_kickPeople) {
        
        [self requestData];
        
        [MBProgressHUD showError:@"设置成功" toView:self.view];
    }
    if (resp.cmdId == HQCMD_setTopChat) { //置顶
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        
        model.chatId = self.groupId;
        if ([self.groupModel.groupInfo.top_status isEqualToString:@"1"]) {
            
            model.isTop = @1;
        }
        else {
        
            model.isTop = @0;
        }
        
        [DataBaseHandle updateChatListIsTopWithData:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:model];
        
//        [self.tableView reloadData];
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    }
    if (resp.cmdId == HQCMD_setNoBother) { //免打扰
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        
        model.chatId = self.groupId;
        if ([self.groupModel.groupInfo.no_bother isEqualToString:@"1"]) {
            
            model.noBother = @1;
        }
        else {
            
            model.noBother = @0;
        }
        
        [DataBaseHandle updateChatListNoBotherWithData:model];
        

        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_modifyGroupInfo) { //修改群名称
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ModifyGroupNameNotification object:nil];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
