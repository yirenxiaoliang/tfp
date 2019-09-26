//
//  TFLookMoreController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLookMoreController.h"
#import "HQTFSearchHeader.h"
#import "HQTFTwoLineCell.h"
#import "TFCustomListCell.h"
#import "TFChatViewController.h"
#import "TFAssistantListController.h"

#import "TFSearchChatItemController.h"
#import "TFChatBL.h"
#import "TFChatInfoListModel.h"

@interface TFLookMoreController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQTFTwoLineCellDelegate,HQBLDelegate>


/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray *customers;
/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray *totalCustomers;


/** UIView *footerView */
@property (nonatomic, strong) UIView *footerView;


/** keyName */
@property (nonatomic, copy) NSString *keyName;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

@property (nonatomic, strong) TFChatBL *chatBL;

@end

@implementation TFLookMoreController

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

    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnPop) image:@"返回灰色" text:@"" textColor:kUIColorFromRGB(0x4A4A4A)];
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
    
    self.keyName = [NSString stringWithFormat:@"%@",self.searchMatch];
    
    if (self.keyWord && ![self.keyWord isEqualToString:@""]) {
        self.headerSearch.textField.text = self.keyWord;
    }
    
    [self setupSearchPlacehoder];
}

/** 设置搜索框提示文字 */
- (void)setupSearchPlacehoder{
    
    
}

- (void)returnPop {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0) { //聊天记录
        
        TFFMDBModel *model = self.dataSources[indexPath.row];
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.topLabel.text = model.receiverName;
        cell.type = TwoLineCellTypeTwo;
        cell.bottomLabel.text = model.content;
        cell.topLine.hidden = NO;
        cell.titleImage.layer.cornerRadius = 45/2.0;
        cell.titleImage.layer.masksToBounds = YES;
        if ([model.chatType isEqualToNumber:@1]) {
            
            [cell.titleImage setImage:IMG(@"群组45") forState:UIControlStateNormal];
        }
        else if ([model.chatType isEqualToNumber:@10]) {
            
            [cell.titleImage setImage:IMG(@"公司总群") forState:UIControlStateNormal];
        }
        else if ([model.chatType isEqualToNumber:@2]){
            
            if (![model.avatarUrl isEqualToString:@""] && model.avatarUrl != nil) {
                
                [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal];
                [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                
                [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
                [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.receiverName] forState:UIControlStateNormal];
                [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
                [cell.titleImage setBackgroundColor:GreenColor];
            }
            
        }
        
        return cell;
    }
    else if (self.type == 1) { //小助手
        
        TFFMDBModel *model =  self.dataSources[indexPath.row];
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.topLabel.text = model.receiverName;
        cell.type = TwoLineCellTypeTwo;
        cell.bottomLabel.text = model.content;
        cell.topLine.hidden = NO;
        
        if ([model.type isEqualToString:@"1"]) {
            
            [cell.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.receiverName] forState:UIControlStateNormal];
            [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            
            cell.titleImage.layer.cornerRadius = 45/2.0;
            cell.titleImage.layer.masksToBounds = YES;
        }
        else if ([model.type isEqualToString:@"2"]) {
            
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
        
        return cell;
    }
    
    else if (self.type == 2) {
        
        TFEmployModel *model = self.dataSources[indexPath.row];
        
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
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    if (self.type == 0) {
    if (self.type == 2) {
        
        self.chatBL = [TFChatBL build];
        self.chatBL.delegate = self;
        NSArray *conversations = [DataBaseHandle queryAllChatListExceptAssistant];
        HQEmployModel *emp = self.dataSources[indexPath.row];
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
    else {
        
        TFFMDBModel *model = self.dataSources[indexPath.row];
        
        TFSearchChatItemController *item = [[TFSearchChatItemController alloc] init];
        
        item.type = self.type;
        item.chatId = model.chatId;
        item.keyWord = self.keyWord;
        
        [self.navigationController pushViewController:item animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 44;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *titleStr;
    
    if (self.type == 0) {
        
        titleStr = @"     聊天记录";
    }
    if (self.type == 1) {
        
        titleStr = @"     小助手";
    }
    if (self.type == 2) {
        
        titleStr = @"     联系人";
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
    headerSearch.frame = CGRectMake(54, -20, SCREEN_WIDTH-54, 64);
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = self.keyWord;
}

- (void)searchHeaderTextChange:(UITextField *)textField{
    
    if (textField.text.length <= 0) {
        
        self.tableView.tableFooterView = self.footerView;
        self.tableView.backgroundView = [UIView new];
        
        [self.tableView reloadData];
    }
    self.keyWord = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        return YES;
    }
    
//    [self.records removeAllObjects];
    self.keyWord = textField.text;
    
//    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
//    [self.records addObjectsFromArray:arr];
    
//    for (NSString *str in self.records) {
//
//        if ([self.keyWord isEqualToString:str]) {
//
//            [self.records removeObject:str];
//            break;
//        }
//
//    }
//
//    [self.records insertObject:textField.text atIndex:0];
//
//    [[NSUserDefaults standardUserDefaults] setObject:self.records forKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //查对应会话id下的
//    _chatRecords = [DataBaseHandle queryAllRecodeWithContent:self.keyWord chatId:self.chatId];
    if (self.type == 0) {
        
        [DataBaseHandle queryAllRecodeWithContent:self.keyWord chatId:self.chatId];
    }
    
    [self.tableView reloadData];
    
    return YES;
}

#pragma mark - searchHeader Deleaget

-(void)searchHeaderCancelClicked{
    
    [self.view endEditing:YES];
    [self.headerSearch removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
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
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


@end
