//
//  TFSearchChatItemController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSearchChatItemController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "HQTFTwoLineCell.h"
#import "TFCustomListCell.h"
#import "TFChatViewController.h"
#import "TFAssistantListController.h"

@interface TFSearchChatItemController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQTFTwoLineCellDelegate>


/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
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

@property (nonatomic, strong) NSMutableArray *chatRecords;
@property (nonatomic, strong) NSMutableArray *assistants;

@end

@implementation TFSearchChatItemController

- (NSMutableArray *)chatRecords {
    
    if (!_chatRecords) {
        
        _chatRecords = [NSMutableArray array];
    }
    return _chatRecords;
}

- (NSMutableArray *)assistants {
    
    if (!_assistants) {
        
        _assistants = [NSMutableArray array];
    }
    return _assistants;
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
//    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnPop) image:@"返回" highlightImage:@"返回"];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnPop) image:@"返回灰色" text:@"" textColor:kUIColorFromRGB(0x4A4A4A)];
    [self.navigationController.navigationBar addSubview:self.headerSearch];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //查对应会话id下的
    if (self.type == 0) {
        
        self.chatRecords = [DataBaseHandle queryAllRecodeWithContent:self.keyWord chatId:self.chatId];
    }
    else if (self.type == 1) {
        
        self.assistants = [DataBaseHandle queryAssistantDataListWithKeywordForSearch:self.keyWord assistantId:self.chatId];
    }
    
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
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.type == 0) {
        
       return self.chatRecords.count;
    }
    else if (self.type == 1) {
        
       return self.assistants.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0) { //聊天记录
        
        TFFMDBModel *model = self.chatRecords[indexPath.row];
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.topLabel.text = model.senderName;
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
        
        TFFMDBModel *model =  self.assistants[indexPath.row];
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.topLabel.text = model.beanNameChinese;
        cell.type = TwoLineCellTypeTwo;
        cell.bottomLabel.text = model.pushContent;
        cell.topLine.hidden = NO;
        
        if ([model.type isEqualToString:@"3"]) {
            
            [cell.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.receiverName] forState:UIControlStateNormal];
            [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            
            cell.titleImage.layer.cornerRadius = 45/2.0;
            cell.titleImage.layer.masksToBounds = YES;
        }
        else if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"10"]) {
            
            cell.topLabel.text = @"企信";
            [cell.titleImage setImage:IMG(@"企信-企信小助手") forState:UIControlStateNormal];
        }
        else if ([model.type isEqualToString:@"4"]) {
            
            [cell.titleImage setImage:IMG(@"企信-审批小助手") forState:UIControlStateNormal];
            
        }
        else if ([model.type isEqualToString:@"5"]) {
            
            [cell.titleImage setImage:IMG(@"企信-文件库小助手") forState:UIControlStateNormal];
            
        }
        else if ([model.type isEqualToString:@"7"]) {
            
            [cell.titleImage setImage:IMG(@"企信-备忘录小助手") forState:UIControlStateNormal];
            
        }
        else if ([model.type isEqualToString:@"8"]) {
            
            [cell.titleImage setImage:IMG(@"企信-邮件小助手") forState:UIControlStateNormal];
            
        }
        else if ([model.type isEqualToString:@"25"] || [model.type isEqualToString:@"26"]) {
            
            [cell.titleImage setImage:IMG(@"企信-任务小助手") forState:UIControlStateNormal];
            
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 0) {
        
        TFFMDBModel *model = _chatRecords[indexPath.row];
        
        TFChatViewController *chatVC = [[TFChatViewController alloc] init];
        
        if ([model.chatType isEqualToNumber:@1]) { //群聊
            
            //群成员字符串分割成数组
            //        NSArray  *array = [model.groupPeoples componentsSeparatedByString:@","];
            TFFMDBModel *db = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
            NSArray  *array = [db.groupPeoples componentsSeparatedByString:@","];
            
            
            chatVC.naviTitle = [NSString stringWithFormat:@"%@(%ld)",db.receiverName,array.count];
            chatVC.chatId = model.chatId;
            chatVC.cmdType = [model.chatType integerValue];
            
        }
        else { //单聊
            
            chatVC.chatId = model.chatId;
            chatVC.naviTitle = model.senderName;
            chatVC.cmdType = [model.chatType integerValue];
            chatVC.receiveId = [model.receiverID integerValue];
        }
        
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else if (self.type == 1) {
        
        TFFMDBModel *model = self.assistants[indexPath.row];
        TFAssistantListController *assistant = [[TFAssistantListController alloc] init];
        
        assistant.assistantId = model.assistantId;
        assistant.applicationId = model.application_id;
        assistant.naviTitle = model.receiverName;
        assistant.type = [model.type integerValue];
        assistant.timeSp = model.create_time;
        assistant.showType = model.showType;
        [self.navigationController pushViewController:assistant animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
    
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
    
    [self.records removeAllObjects];
    self.keyWord = textField.text;
    
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
    
    //查对应会话id下的
    _chatRecords = [DataBaseHandle queryAllRecodeWithContent:self.keyWord chatId:self.chatId];

    [self.tableView reloadData];
    
    return YES;
}


-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"没有找到相关信息~"];
    }
    return _noContentView;
}



#pragma mark - searchHeader Deleaget

-(void)searchHeaderCancelClicked{
    
    [self.view endEditing:YES];
    [self.headerSearch removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
