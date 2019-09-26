//
//  TFCreateGroupController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateGroupController.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFSelectColorController.h"
#import "TFProjLabelModel.h"
#import "TFChatPeopleCell.h"
#import "HQTFProjectDescController.h"
#import "TFGroupModel.h"
#import "HQEmployModel.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFIMessageBL.h"
#import "TFGroupDetailModel.h"
#import "IQKeyboardManager.h"

#import "TFChatBL.h"
#import "TFChatViewController.h"
#import "TFChatInfoListModel.h"
#import "TFGroupInfoModel.h"

@interface TFCreateGroupController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFGroupModel */
@property (nonatomic, strong) TFGroupModel *groupModel;

/** TFIMessageBL */
@property (nonatomic, strong) TFIMessageBL *messageBL;

@property (nonatomic, strong) TFChatBL *chatBL;

@end

@implementation TFCreateGroupController

-(TFGroupModel *)groupModel{
    
    if (!_groupModel) {
        _groupModel = [[TFGroupModel alloc] init];
    }
    return _groupModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    

    HQEmployModel *eModel = [[HQEmployModel alloc] init];
    eModel.photograph = UM.userLoginInfo.employee.picture;
    eModel.sign_id = UM.userLoginInfo.employee.sign_id;
    eModel.employee_name = UM.userLoginInfo.employee.employee_name;
    
    self.groupModel.groupEmployees = [NSMutableArray array];
    
    [self.groupModel.groupEmployees addObject:eModel];
}

#pragma mark - navi
- (void)setupNavigation {
    self.navigationItem.title = @"创建群组";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(createClicked) text:@"创建" textColor:GreenColor];
    
}
- (void)createClicked{
    
    
    
    if (!self.groupModel.groupName || [self.groupModel.groupName isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入群名称！" toView:self.view];
        return;
    }
//    if (self.groupModel.groupName.length > 12) {
//
//        [MBProgressHUD showError:@"群名称不能超过12字！" toView:self.view];
//        return;
//    }
    [self.view endEditing:YES];
    
    if (self.groupModel.groupEmployeeIds == 0) {
        [MBProgressHUD showError:@"请添加群成员" toView:self.view];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.chatBL requestAddGroupChatWithData:self.groupModel.groupName groupNotice:self.groupModel.groupDesc peoples:self.groupModel.groupEmployeeIds];
    

}


- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = BackGroudColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"群名称12个字以内(必填)";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(20);
        cell.textVeiw.text = self.groupModel.groupName;
        cell.textVeiw.tag = 0x12345;
        cell.bottomLine.hidden = YES;
        cell.textVeiw.userInteractionEnabled = YES;
        
        return cell;
    }else if (indexPath.section == 1){
        
        TFChatPeopleCell *cell = [TFChatPeopleCell chatPeopleCellWithTableView:tableView];
        [cell refreshCellWithItems:self.groupModel.groupEmployees withType:1 withColumn:7];
        cell.bottomLine.hidden = YES;
        return cell;
        
    }else{
        
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"请输入群聊公告100字以内（选填）";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(20);
        cell.textVeiw.text = self.groupModel.groupDesc;
        cell.textVeiw.tag = 0x67890;
        cell.bottomLine.hidden = YES;
        cell.textVeiw.textColor = LightBlackTextColor;
        cell.textVeiw.userInteractionEnabled = YES;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            
            TFMutilStyleSelectPeopleController *selectChat = [[TFMutilStyleSelectPeopleController alloc] init];
            selectChat.selectType = 1;
            selectChat.isSingleSelect = NO;
            selectChat.defaultPoeples = self.groupModel.groupEmployees;//默认选的人
            
            NSMutableArray *arr = [NSMutableArray array];
            HQEmployModel *em = [[HQEmployModel alloc] init];
            
            em.id = UM.userLoginInfo.employee.id;
            [arr addObject:em];
            
            selectChat.noSelectPoeples = arr;
            
            selectChat.actionParameter = ^(NSMutableArray *employees){
            
                NSMutableArray *peoples = [NSMutableArray array];
                
//                for (HQEmployModel *empModel in employees) { //过滤自己
//                    
//                    if (![empModel.sign_id isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
//                        
//                        [peoples addObject:empModel];
//                    }
//                }
                
//                if (self.groupModel.groupEmployees.count > 1) { //过滤重复选择的人
                
                    for (HQEmployModel *empModel in employees) {
                        
                        BOOL have = NO;
                        for (HQEmployModel *employ in self.groupModel.groupEmployees) {
                            
                            if ([empModel.sign_id isEqualToNumber:employ.sign_id]||[empModel.sign_id isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                                
                                have = YES;
                                break;
                            }
                        }
                        
                        if (!have) {
                            
//                            [self.groupModel.groupEmployees addObjectsFromArray:peoples];
                            [peoples addObject:empModel];
                        }
                    }
//                }
//                else {
//                
                   [self.groupModel.groupEmployees addObjectsFromArray:peoples];
//                }
                
                
                
                
                self.groupModel.groupEmployeeIds = @"";
                
                for (HQEmployModel *model in peoples) {
                    
                    self.groupModel.groupEmployeeIds = [self.groupModel.groupEmployeeIds stringByAppendingString:[NSString stringWithFormat:@",%@",[model.sign_id stringValue]]];
                }
                
                self.groupModel.groupEmployeeIds = [self.groupModel.groupEmployeeIds substringFromIndex:1];
                
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:selectChat animated:YES];
            
        }
        
    }
    
//    if (indexPath.section == 2) {
//        HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
//        desc.descString = self.groupModel.groupDesc;
//
//        desc.naviTitle = @"群聊公告";
//        desc.sectionTitle = @"群聊公告";
//        desc.placehoder = @"请输入100字以内（选填）";
//
//        desc.descAction = ^(NSString *text){
//
//            self.groupModel.groupDesc = text;
//
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
//        };
//        [self.navigationController pushViewController:desc animated:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 60;
    }else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            return 55;
//        }else{
            return [TFChatPeopleCell refreshCellHeightWithItems:self.groupModel.groupEmployees withType:1 withColumn:7];
//        }
    }else{
//        CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-120,MAXFLOAT} titleStr:self.groupModel.groupDesc];
//
//        return size.height >= 80 ? size.height + 30 : 80;
        return SCREEN_HEIGHT-NaviHeight-60-44-8-[TFChatPeopleCell refreshCellHeightWithItems:self.groupModel.groupEmployees withType:1 withColumn:7];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return 8;
    }else if (section == 2){
        return 44;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    if (section == 2) {
        
        UILabel *lab = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-10,35} text:@"    群聊公告" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        lab.backgroundColor = kUIColorFromRGB(0xf2f2f2);
        return lab;
        
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kUIColorFromRGB(0xf2f2f2);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)textViewDidChange:(UITextView *)textView{

    UITextRange *range = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:range.start offset:0];
    //获取文本框内容的字节数
    int bytes = [HQHelper stringConvertToInt:textView.text];
    
    if (textView.tag == 0x12345) {
        
        if (!position) {
            
            //一位等于两个字节
            if (bytes > 12) {
                
                //根据字节截取字符串
                textView.text = [HQHelper subStringByByteWithIndex:24 string:textView.text];
                /** 07.13 改：截取24个字节，超过直接截取，不弹提示
                textView.text = [textView.text substringToIndex:12];
                [MBProgressHUD showError:@"12个字以内" toView:self.view];
                 */
            }
        }
        
        self.groupModel.groupName = textView.text;
    }
    else if (textView.tag == 0x67890) {
        
        if (!position) {
            
            if (textView.text.length > 100) {
                
                //根据字节截取字符串
                textView.text = [HQHelper subStringByByteWithIndex:200 string:textView.text];
                /** 07.13 改：截取200个字节，超过直接截取，不弹提示
                 textView.text = [textView.text substringToIndex:12];
                 [MBProgressHUD showError:@"100个字以内" toView:self.view];
                 */
            }
        }
        
        self.groupModel.groupDesc = textView.text;
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //    if (resp.cmdId == HQCMD_messageAddGroup) {
    //
    //        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    //        [self.navigationController popToRootViewControllerAnimated:NO];
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kCreatGroupStateServer object:resp.body];
    //
    //    }
    
    if (resp.cmdId == HQCMD_addGroupChat) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFGroupInfoModel *groupModel = resp.body;
        
        TFChatInfoListModel *model = groupModel.groupInfo;
        
        TFChatViewController *chat = [[TFChatViewController alloc] init];
        
        //群成员字符串分割成数组
        NSArray  *array = [model.peoples componentsSeparatedByString:@","];
        
        chat.naviTitle = [NSString stringWithFormat:@"%@(%ld)",self.groupModel.groupName,array.count];
        chat.cmdType = 1;
        chat.chatId = model.id;
        chat.receiveId = [model.id integerValue];
        chat.picture = model.picture;
        
        chat.isCreateGroup = 1;
        NSString *tipContent = @"";
        for (TFGroupEmployeeModel *empModel in groupModel.employeeInfo) {
            
            if (![empModel.sign_id isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                
                tipContent = [tipContent stringByAppendingFormat:@"、%@", empModel.employee_name];
            }
            
        }
        if (tipContent.length>0) {
            
            tipContent = [tipContent substringFromIndex:1];
        }
        
        chat.tipContent = [NSString stringWithFormat:@"欢迎%@加入群聊",tipContent];
//        tipContent = [NSString stringWithFormat:@"你邀请了%@加入群聊",empModel.employee_name];
        TFFMDBModel *dd = [model chatListModel];
        dd.mark = @3;
        [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:dd];
        
        [self.navigationController pushViewController:chat animated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //    [self.tableView.mj_footer endRefreshing];
    //    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


@end
