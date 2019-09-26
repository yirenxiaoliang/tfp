//
//  TFSearchChatRecordController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSearchChatRecordController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "HQTFTwoLineCell.h"
#import "TFCustomListCell.h"
#import "TFSearchChatItemController.h"
#import "TFPeopleBL.h"

#import "TFChatBL.h"
#import "TFChatViewController.h"
#import "TFChatInfoListModel.h"
#import "TFLookMoreCell.h"
#import "TFLookMoreController.h"

@interface TFSearchChatRecordController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQTFTwoLineCellDelegate,HQBLDelegate>


/** UITableView *tableView */
@property (nonatomic, strong) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray *customers;
/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray *totalCustomers;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *records;


/** UIView *footerView */
@property (nonatomic, strong) UIView *footerView;


/** keyName */
@property (nonatomic, copy) NSString *keyName;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

@property (nonatomic, strong) NSMutableArray *allRecords;

@property (nonatomic, strong) TFPeopleBL *peopleBL;
/** 搜索联系人 */
@property (nonatomic, strong) NSMutableArray *peoples;
/** 搜索小助手 */
@property (nonatomic, strong) NSMutableArray *assisContents;

@property (nonatomic, strong) TFChatBL *chatBL;

@end

@implementation TFSearchChatRecordController
- (NSMutableArray *)peoples {
    
    if (!_peoples) {
        
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}
- (NSMutableArray *)assisContents {
    
    if (!_assisContents) {
        
        _assisContents = [NSMutableArray array];
    }
    return _assisContents;
}
- (NSMutableArray *)allRecords {

    if (!_allRecords) {
        
        _allRecords = [NSMutableArray array];
    }
    return _allRecords;
}


-(NSMutableArray *)records{
    if (!_records) {
        _records = [NSMutableArray array];
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
        [_records addObjectsFromArray:arr];
    }
    return _records;
}

-(NSMutableArray *)customers{
    if (!_customers) {
        _customers = [NSMutableArray array];
        
    }
    return _customers;
}

-(NSMutableArray *)totalCustomers{
    if (!_totalCustomers) {
        _totalCustomers = [NSMutableArray array];
        
    }
    return _totalCustomers;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:nil action:nil text:@""];
    [self.navigationController.navigationBar addSubview:self.headerSearch];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    self.keyName = [NSString stringWithFormat:@"%@",self.searchMatch];
    
    [self.headerSearch.textField becomeFirstResponder];
    
    if (self.keyWord && ![self.keyWord isEqualToString:@""]) {
        self.headerSearch.textField.text = self.keyWord;
    }
    
    [self setupSearchPlacehoder];
}

/** 设置搜索框提示文字 */
- (void)setupSearchPlacehoder{
    
    
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
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView = tableView;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.peoples.count>2) {
            
            return 3;
        }
        else {
            return self.peoples.count;
        }
        
    }
    else if (section == 1) {
        
        if (self.allRecords.count>2) {
            
            return 3;
        }
        else {
            return self.allRecords.count;
        }

    }
    else if (section == 2) {
        
        if (self.assisContents.count>2) {
            
            return 3;
        }
        else {
            return self.assisContents.count;
        }

    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) { //联系人
        
        if (indexPath.row>1) {
            
            TFLookMoreCell *cell = [TFLookMoreCell lookMoreCellWithTableView:tableView];
            
            return cell;
        }
        else {
            
            TFEmployModel *model = self.peoples[indexPath.row];
            
            HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
            cell.topLabel.text = model.employee_name;
            cell.type = TwoLineCellTypeTwo;
            cell.bottomLabel.text = model.post_name;
            cell.topLine.hidden = NO;
            
            if (![model.picture isEqualToString:@""]) {
                
                [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
                [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                
                [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
                [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
                [cell.titleImage setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
                [cell.titleImage setBackgroundColor:GreenColor];
            }
            
            [cell.titleImage setImage:nil forState:UIControlStateNormal];
            
            cell.titleImage.layer.cornerRadius = 45/2.0;
            cell.titleImage.layer.masksToBounds = YES;
            return cell;
        }

    }
    else if (indexPath.section == 1) { //聊天记录

        if (indexPath.row>1) {
            
            TFLookMoreCell *cell = [TFLookMoreCell lookMoreCellWithTableView:tableView];
            
            return cell;
        }
        else {
            
            TFFMDBModel *model = _allRecords[indexPath.row];
            
            HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
            cell.topLabel.text = model.receiverName;
            cell.type = TwoLineCellTypeTwo;
            cell.bottomLabel.text = model.content;
            cell.topLine.hidden = NO;
            
            cell.titleImage.layer.cornerRadius = 45/2.0;
            cell.titleImage.layer.masksToBounds = YES;
            [cell setBackgroundColor:WhiteColor];
            if ([model.chatType isEqualToNumber:@1]) {
                [cell.titleImage setImage:IMG(@"群组45") forState:UIControlStateNormal];
                [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
                [cell.titleImage setTitle:nil forState:UIControlStateNormal];
                [cell.titleImage setTitleColor:nil forState:UIControlStateNormal];
                [cell.titleImage setBackgroundColor:nil];
            }
            else if ([model.chatType isEqualToNumber:@10]) {
                [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:nil] forState:UIControlStateNormal];
                [cell.titleImage setImage:IMG(@"公司总群") forState:UIControlStateNormal];
                [cell.titleImage setTitle:nil forState:UIControlStateNormal];
                [cell.titleImage setTitleColor:nil forState:UIControlStateNormal];
                [cell.titleImage setBackgroundColor:nil];
            }
            else if ([model.chatType isEqualToNumber:@2]){
                
                if (![model.avatarUrl isEqualToString:@""]) {
                    
                    [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal];
                    [cell.titleImage setImage:nil forState:UIControlStateNormal];
                    [cell.titleImage setTitle:nil forState:UIControlStateNormal];
                    [cell.titleImage setTitleColor:nil forState:UIControlStateNormal];
                    [cell.titleImage setBackgroundColor:nil];
                }
                else {
                    
                    [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
                    [cell.titleImage setImage:nil forState:UIControlStateNormal];
                    [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.receiverName] forState:UIControlStateNormal];
                    [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
                    [cell.titleImage setBackgroundColor:GreenColor];
                }
                
            }
            
            return cell;
        }
        
    }
    else if (indexPath.section == 2) { //小助手

        if (indexPath.row>1) {
            
            TFLookMoreCell *cell = [TFLookMoreCell lookMoreCellWithTableView:tableView];
            
            return cell;
        }
        else {
            
            TFFMDBModel *model =  self.assisContents[indexPath.row];
            
            HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
            cell.topLabel.text = model.receiverName;
            cell.type = TwoLineCellTypeTwo;
            cell.bottomLabel.text = model.content;
            cell.topLine.hidden = NO;
            [cell setBackgroundColor:WhiteColor];
            if ([model.type isEqualToString:@"1"]) {
                
                [cell.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.receiverName] forState:UIControlStateNormal];
                [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
                
                cell.titleImage.layer.cornerRadius = 45/2.0;
                cell.titleImage.layer.masksToBounds = YES;
            }
            else {
                
                if ([model.type isEqualToString:@"2"]) {
                    
                    
                    [cell.titleImage setImage:IMG(@"企信-企信小助手") forState:UIControlStateNormal];
                }
                else if ([model.type isEqualToString:@"3"]) {
                    
                    [cell.titleImage setImage:IMG(@"企信-审批小助手") forState:UIControlStateNormal];
                    
                }
                else if ([model.type isEqualToString:@"4"]) {
                    
                    [cell.titleImage setImage:IMG(@"企信-文件库小助手") forState:UIControlStateNormal];
                    
                }
                else if ([model.type isEqualToString:@"5"]) {
                    
                    [cell.titleImage setImage:IMG(@"企信-备忘录小助手") forState:UIControlStateNormal];
                    
                }
                else if ([model.type isEqualToString:@"6"]) {
                    
                    [cell.titleImage setImage:IMG(@"企信-邮件小助手") forState:UIControlStateNormal];
                    
                }
                else if ([model.type isEqualToString:@"7"]) {
                    
                    
                    [cell.titleImage setImage:IMG(@"企信-任务小助手") forState:UIControlStateNormal];
                    
                }
                [cell.titleImage setBackgroundImage:nil forState:UIControlStateNormal];
                [cell.titleImage setTitle:nil forState:UIControlStateNormal];
                [cell.titleImage setTitleColor:nil forState:UIControlStateNormal];
                [cell.titleImage setBackgroundColor:nil];
            }
            
            
            return cell;
        }
        
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    if (indexPath.section == 0) {
        
        if (indexPath.row == 2 ) {

            TFLookMoreController *moreVC = [[TFLookMoreController alloc] init];
            moreVC.type = 2;
            moreVC.dataSources = self.peoples;
            moreVC.keyWord = self.keyWord;
            [self.navigationController pushViewController:moreVC animated:YES];
            
        }
        else {
            
            self.chatBL = [TFChatBL build];
            self.chatBL.delegate = self;
            NSArray *conversations = [DataBaseHandle queryAllChatListExceptAssistant];
            HQEmployModel *emp = self.peoples[indexPath.row];
            BOOL exist = NO;
            
            TFFMDBModel *model = [[TFFMDBModel alloc] init];
            for (model in conversations) {
                
                //会话已存在
                if ([model.receiverID isEqualToNumber:emp.sign_id]) {
                    
                    exist = YES;
                    break;
                }
            }
            
            if (!exist) { //没有该聊天
                
                //添加单聊
                [self.chatBL requestAddSingleChatWithData:emp.sign_id];
            }
            else { //有该聊天
                
                TFChatViewController *chatVC = [[TFChatViewController alloc] init];
                
                //            chatVC.fileModel = self.fileModel;
                //            chatVC.dbModel = self.dbModel;
                chatVC.isTransitive = NO;
                chatVC.isSendFromFileLib = NO;
                
                chatVC.chatId = model.chatId;
                chatVC.naviTitle = model.receiverName;
                chatVC.cmdType = [model.chatType integerValue];
                chatVC.receiveId = [model.receiverID integerValue];
                [self.navigationController pushViewController:chatVC animated:YES];
                
            }
        }
        
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 2) {
            
            TFLookMoreController *moreVC = [[TFLookMoreController alloc] init];
            moreVC.type = 0;
            moreVC.dataSources = self.allRecords;
            moreVC.keyWord = self.keyWord;
            [self.navigationController pushViewController:moreVC animated:YES];
        }
        else {
            
            TFFMDBModel *model = self.allRecords[indexPath.row];
            
            TFSearchChatItemController *item = [[TFSearchChatItemController alloc] init];
            
            item.type = 0;
            item.chatId = model.chatId;
            item.keyWord = self.keyWord;
            
            [self.navigationController pushViewController:item animated:YES];
        }
        
    }
    else if (indexPath.section == 2) {
        
        if (indexPath.row == 2) {
            
            TFLookMoreController *moreVC = [[TFLookMoreController alloc] init];
            moreVC.type = 1;
            moreVC.dataSources = self.assisContents;
            moreVC.keyWord = self.keyWord;
            [self.navigationController pushViewController:moreVC animated:YES];
        }
        else {
            
            TFFMDBModel *model = self.assisContents[indexPath.row];
            
            TFSearchChatItemController *item = [[TFSearchChatItemController alloc] init];
            item.type = 1;
            item.chatId = model.chatId;
            item.keyWord = self.keyWord;
            
            [self.navigationController pushViewController:item animated:YES];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > 1) {
        
        return 44;
    }
    return 64;

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 && self.peoples.count != 0) {
        
        return 44;
    }
    if (section == 1 && self.allRecords.count != 0) {
        
        return 44;
    }
    if (section == 2 && self.assisContents.count != 0) {
        
        return 44;
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *titleStr;
    if (section == 0) {
        
        titleStr = @"     联系人";
    }

    if (section == 1) {
        
        titleStr = @"     聊天记录";
    }
    if (section == 2) {
        
        titleStr = @"     小助手";
    }
    UILabel *lab = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 44) title:titleStr titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:WhiteColor];
    lab.textAlignment = NSTextAlignmentLeft;
    return lab;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)setupNavi{
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = self.keyWord;
}

//- (void)searchHeaderTextChange:(UITextField *)textField{
//
//    if (textField.text.length <= 0) {
//
//        self.tableView.tableFooterView = self.footerView;
//        self.tableView.backgroundView = [UIView new];
//
//        [self.tableView reloadData];
//    }
//    self.keyWord = textField.text;
//
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        return YES;
    }
    
    [self.records removeAllObjects];
    
    [self.allRecords removeAllObjects];
    [self.assisContents removeAllObjects];
    self.keyWord = textField.text;
    
    //搜索联系人
    [self.peopleBL requsetFindByUserNameWithDepartmentId:nil employeeName:self.keyWord dismiss:nil];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [self.records addObjectsFromArray:arr];
    
    for (NSString *str in self.records) {
        
        if ([self.keyWord isEqualToString:str]) {
            
            [self.records removeObject:str];
            break;
        }
        
    }
    
    [self.records insertObject:textField.text atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.records forKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /** ------------------- 搜索小助手 ------------------- */
    NSMutableArray *assistants = [DataBaseHandle queryIsNotHidenAssistantListData];
    for (TFFMDBModel *model in assistants) {
        
        TFFMDBModel *listModel = [[TFFMDBModel alloc] init];
        NSMutableArray *lists = [DataBaseHandle queryAssistantDataListWithKeywordForSearch:self.keyWord assistantId:model.chatId];
        
        if (lists.count>0) {
            
            listModel.receiverName = model.receiverName;
            listModel.type = model.type;
            listModel.chatId = model.chatId;
            listModel.chatType = model.chatType;
            
            if (lists.count == 1) {
                
                TFFMDBModel *recordsModel = lists[0];
                listModel.content = recordsModel.pushContent;
            }
            else if (lists.count > 1){
                
                listModel.content = [NSString stringWithFormat:@"%ld条相关聊天记录",lists.count];
            }
            
            [self.assisContents addObject:listModel];
        }
    }
    
    
    /** ------------------- 搜索聊天记录 ------------------- */
    NSMutableArray *allConversations = [DataBaseHandle queryAllChatListExceptAssistant];

    for (TFFMDBModel *model in allConversations) {
        
        TFFMDBModel *listModel = [[TFFMDBModel alloc] init];
        //查对应会话id下的
        NSMutableArray *chatRecords = [DataBaseHandle queryAllRecodeWithContent:self.keyWord chatId:model.chatId];
        
        
        if (chatRecords.count>0) {
            
            listModel.receiverName = model.receiverName;
            listModel.avatarUrl = model.avatarUrl;
            listModel.chatId = model.chatId;
            listModel.chatType = model.chatType;
            
            if (chatRecords.count == 1) {
                
                TFFMDBModel *recordsModel = chatRecords[0];
                listModel.content = recordsModel.content;
            }
            else if (chatRecords.count > 1){
                
                listModel.content = [NSString stringWithFormat:@"%ld条相关聊天记录",chatRecords.count];
            }
            
            [self.allRecords addObject:listModel];
        }
        
    }
    
    if (self.allRecords.count == 0 && self.peoples.count == 0 && self.assisContents.count == 0) {
        
        self.tableView.backgroundView = self.noContentView;
        
    }else{
        self.tableView.backgroundView = [UIView new];
    }

    [self.tableView reloadData];
    
    return YES;
}


-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(400))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"没有找到相关信息~"];
    }
    return _noContentView;
}



#pragma mark - searchHeader Deleaget

-(void)searchHeaderCancelClicked{
    
    [self.view endEditing:YES];
    [self.headerSearch removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_findByUserName) {
        
        [self.view addSubview:self.tableView];
        [self.peoples removeAllObjects];
        
        [self.peoples addObjectsFromArray:resp.body];
        
        if (self.allRecords.count == 0 && self.peoples.count == 0 && self.assisContents.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_addSingleChat) {
        
            
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
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
