//
//  TFAssistantSettingController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAssistantSettingController.h"
#import "HQTFTwoLineCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFThreeLabelCell.h"
#import "TFAssistantSettingModel.h"

#import "TFChatBL.h"
#import "TFChatInfoListModel.h"

@interface TFAssistantSettingController ()<UITableViewDelegate,UITableViewDataSource,HQSwitchCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** items */
@property (nonatomic, strong) NSMutableArray *items;
/** disturb */
@property (nonatomic, assign) BOOL disturb;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFChatInfoListModel *infoModel;

@end

@implementation TFAssistantSettingController

- (TFChatInfoListModel *)infoModel {

    if (!_infoModel) {
        
        _infoModel = [[TFChatInfoListModel alloc] init];
    }
    return _infoModel;
}

-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"设置";
    [self getUserDisturb];// 获取免打扰
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    [self.chatBL requestGetAssistantInfoWithData:self.assistantId];
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
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 1) {
        return 3;
    }

    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];

        if (self.type == 1) {
            
            if ([self.icon_type isEqualToString:@"0"]) {
                
                [cell.titleImage setBackgroundImage:IMG(self.icon_url) forState:UIControlStateNormal];
                [cell.titleImage setBackgroundColor:[HQHelper colorWithHexString:self.icon_color]];
            }
            else if ([self.icon_type isEqualToString:@"1"]) {
                
                [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:self.icon_url] forState:UIControlStateNormal placeholderImage:IMG(@"任务50")];
                [cell.titleImage setBackgroundColor:GreenColor];
            }
            
            cell.bottomLabel.text = [NSString stringWithFormat:@"汇聚所有的%@信息。",_infoModel.name];
        }
        else if (self.type == 2) {
            
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-企信小助手"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-企信小助手"] forState:UIControlStateHighlighted];
            cell.bottomLabel.text = @"汇聚所有的企信信息。";
        }
        else if (self.type == 3) {
            
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-审批小助手"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-审批小助手"] forState:UIControlStateHighlighted];
            cell.bottomLabel.text = @"汇聚所有的审批信息。";
        }
        else if (self.type == 4) {
            
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-文件库小助手"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-文件库小助手"] forState:UIControlStateHighlighted];
            cell.bottomLabel.text = @"汇聚所有的文件库信息。";
        }
        else if (self.type == 5) {
            
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-备忘录小助手"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-备忘录小助手"] forState:UIControlStateHighlighted];
            cell.bottomLabel.text = @"汇聚所有的备忘录信息。";
        }
        else if (self.type == 6) {
            
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-邮件小助手"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-邮件小助手"] forState:UIControlStateHighlighted];
            cell.bottomLabel.text = @"汇聚所有的邮件信息。";
        }
        else if (self.type == 7) {
            
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-任务小助手"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"企信-任务小助手"] forState:UIControlStateHighlighted];
            cell.bottomLabel.text = @"汇聚所有的任务信息。";
        }else if (self.type == 8){
            
            
        }else if (self.type == 9){
            
            [cell.titleImage setImage:[UIImage imageNamed:@"考勤"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"考勤"] forState:UIControlStateHighlighted];
            cell.bottomLabel.text = @"汇聚所有的考勤提醒信息。";
            
        }
//        [cell.titleImage setImage:[UIImage imageNamed:@"任务50"] forState:UIControlStateNormal];
//        [cell.titleImage setImage:[UIImage imageNamed:@"任务50"] forState:UIControlStateHighlighted];
        cell.topLabel.text = _infoModel.name;

        
        
        cell.titleImage.layer.cornerRadius = cell.titleImage.width/2.0;
        cell.titleImage.layer.masksToBounds = YES;
        
        [cell.enterImage setTitle:@"机器人" forState:UIControlStateNormal];
        [cell.enterImage setTitleColor:kUIColorFromRGB(0xBBBBC3) forState:UIControlStateNormal];
        cell.enterImage.hidden = NO;
        
        cell.bottomLine.hidden = YES;
        
        return cell;
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"只查看未读消息";
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            cell.switchBtn.tag = 0x111 + indexPath.row;
//            cell.switchBtn.on = (!self.typeModel.top || [self.typeModel.top isEqualToNumber:@0]) ? NO : YES;
            cell.switchBtn.on = [_infoModel.show_type isEqualToString:@"1"]?YES:NO;
            return cell;
        }
        else if (indexPath.row == 1) {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"置顶聊天";
            cell.bottomLine.hidden = NO;
            cell.switchBtn.tag = 0x111 + indexPath.row;
            if ([_infoModel.top_status isEqualToString:@"1"]) {
                
                cell.switchBtn.on = YES;
            }
            else {
                
                cell.switchBtn.on = NO;
            }
            cell.topLine.hidden = YES;
            return cell;
        }else {
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            cell.title.text = @"消息免打扰";
            cell.bottomLine.hidden = YES;
            cell.switchBtn.tag = 0x111 + indexPath.row;
            cell.switchBtn.on = [[self.infoModel.no_bother description] isEqualToString:@"1"] ? YES : NO;
            cell.topLine.hidden = YES;
            return cell;
        }
        
    }
    else if (indexPath.section == 2){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"全部标为已读";
        cell.arrowShowState = NO;
        cell.time.text = @"";
        cell.time.textColor = ExtraLightBlackTextColor;
        cell.bottomLine.hidden = YES;
        cell.topLine.hidden = YES;
        return  cell;
    }
    
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 2) {//未读消息全部标记为已读
        
        [self.chatBL requestMarkAllReadWithData:self.assistantId];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75;
    }
    
    if (self.type == 2) { //企信小助手
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            
            return 0;
        }
        
        if (indexPath.section == 2) {
            
            return 0;
        }
    }
    
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
    
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

- (void)getUserDisturb{
    
    if (_conversation) {// 聊天进来的
        
        JMSGUser * user = _conversation.target;
        self.disturb = user.isNoDisturb;
        HQMainQueue(^{
            
            [self.tableView reloadData];
        });
    }else{
        
        if (!self.typeModel.imUserName) {// 可能没有imUserName
            return;
        }
        [JMSGUser userInfoArrayWithUsernameArray:@[self.typeModel.imUserName]
                               completionHandler:^(id resultObject, NSError *error) {
                                   
                                   if (error == nil) {
                                       
                                       NSArray *arr = (NSArray *)resultObject;
                                       
                                       if (arr.count) {
                                           
                                           JMSGUser * typeUser = arr[0];
                                           self.disturb = typeUser.isNoDisturb;
                                           HQMainQueue(^{
                                               
                                               [self.tableView reloadData];
                                           });
                                       }
                                   }
                               }];
        
    }
    
}


#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if (switchButton.tag - 0x111 == 0) {// 只看未读
        
        _infoModel.show_type = [_infoModel.show_type isEqualToString:@"1"] ? @"0" : @"1";
        [self.chatBL requestMarkReadOptionWithData:self.assistantId];
        
    }
    else if (switchButton.tag - 0x111 == 1) {// 置顶
    
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        
        model.chatId = self.assistantId;
        if (switchButton.on) {

            model.isTop = @1;
        }
        else {
        
            model.isTop = @0;
        }
        
        [DataBaseHandle updateAssistantListIsTopWithData:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AssistantUnreadNotification object:nil];
        
        if ([_infoModel.top_status isEqualToString:@"0"]) {
            
            _infoModel.top_status = @"1";
        }
        else {
            
            _infoModel.top_status = @"0";
        }
        
        
        [self.chatBL requestSetTopChatWithData:_infoModel.id chatType:_infoModel.chat_type];
    }
    else if (switchButton.tag - 0x111 == 2) {// 免打扰
        
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        
        model.chatId = self.assistantId;
        if (switchButton.on) {
            
            model.noBother = @1;
        }
        else {
            
            model.noBother = @0;
        }
        
        [DataBaseHandle updateAssistantNoBotherWithData:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AssistantUnreadNotification object:nil];
        
        if ([_infoModel.no_bother isEqualToString:@"0"]) {
            
            _infoModel.no_bother = @"1";
        }
        else {
            
            _infoModel.no_bother = @"0";
        }
        
        [self.chatBL requestSetNoBotherWithData:_infoModel.id  chatType:_infoModel.chat_type];
        
    }

}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getAssistantInfo) {
        
        _infoModel = resp.body;
        
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_setTopChat) { //置顶
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        
        model.chatId = _infoModel.id;
        if ([_infoModel.top_status isEqualToString:@"1"]) {
            
            model.isTop = @1;
        }
        else {
            
            model.isTop = @0;
        }
        
        [DataBaseHandle updateChatListIsTopWithData:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:model];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCompanySocketConnect object:nil];
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_markAllRead) { //全部标为已读
        
        //查询该小助手的本地数据
        TFFMDBModel *dbModel = [DataBaseHandle queryAssistantListDataWithChatId:self.assistantId];
        
        //未读数为0
        dbModel.unreadMsgCount = @(0);
        
        //更新小助手列表未读数量
        [DataBaseHandle updateAssistantListUnReadWithData:dbModel];
        
        dbModel.readStatus = @"1";
        dbModel.assistantId = self.assistantId;
        [DataBaseHandle updateAssistantListDataAllReadWithData:dbModel];
        
        //通知更新列表
        [[NSNotificationCenter defaultCenter] postNotificationName:AssistantUnreadNotification object:nil];
        
        [MBProgressHUD showError:@"操作成功" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
    }
    
    if (resp.cmdId == HQCMD_markReadOption) {
        
        if (self.refresh) {
            
            self.refresh();
        }
    }

    if (resp.cmdId == HQCMD_setNoBother) {
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
