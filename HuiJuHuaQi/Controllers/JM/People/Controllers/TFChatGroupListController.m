//
//  TFChatGroupListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatGroupListController.h"
#import "HQTFTwoLineCell.h"
#import "TFCreateGroupController.h"
#import "TFIMessageBL.h"
#import "TFGroupDetailModel.h"
#import "HQConversationController.h"

#import "TFChatBL.h"
#import "TFChatInfoListModel.h"
#import "TFChatViewController.h"

#import "HQTFSearchHeader.h"
#import "TFSearchGroupController.h"

@interface TFChatGroupListController ()<UITableViewDataSource,UITableViewDelegate,HQBLDelegate,HQTFSearchHeaderDelegate>
/** tableView */
@property (nonatomic, weak)  UITableView *tableView;

/** groups */
@property (nonatomic, strong) NSMutableArray *groups;

/** TFIMessageBL */
@property (nonatomic, strong) TFIMessageBL *messageBL;

@property (nonatomic, assign) BOOL isPermission;

@property (nonatomic, strong) TFChatBL *chatBL;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@end

@implementation TFChatGroupListController

-(NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择一个群";
    [self setupTableView];
    
    [self setupHeaderSearch];
    
    self.messageBL = [TFIMessageBL build];
    self.messageBL.delegate = self;
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.chatBL requestGetAllGroupsInfoData];
    
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    self.tableView.tableHeaderView = header;
    header.delegate = self;
    header.button.backgroundColor = BackGroudColor;
    header.backgroundColor = WhiteColor;
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

#pragma mark - searchHeader Deleaget
-(void)searchHeaderClicked{
    
    TFSearchGroupController *search = [[TFSearchGroupController alloc] init];
    
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.groups.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.type = TwoLineCellTypeOne;

    TFChatInfoListModel *model = self.groups[indexPath.row];
    
    if ([model.type isEqualToString:@"0"]) { //公司总群
        
        [cell.titleImage setImage:[UIImage imageNamed:@"公司总群"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"公司总群"] forState:UIControlStateHighlighted];
    }
    else {
    
        [cell.titleImage setImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateHighlighted];
    }

    cell.titleImage.imageView.layer.cornerRadius = cell.titleImage.imageView.width/2.0;
    cell.titleImage.imageView.layer.masksToBounds = YES;
    
    //群成员字符串分割成数组
    NSArray  *array = [model.peoples componentsSeparatedByString:@","];
    
    cell.topLabel.text = [NSString stringWithFormat:@"%@(%ld)",model.name,array.count];
    cell.bottomLine.hidden = NO;

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFChatViewController *chat = [[TFChatViewController alloc] init];
    
    TFChatInfoListModel *model = self.groups[indexPath.row];
    //群成员字符串分割成数组
    NSArray *array = [model.peoples componentsSeparatedByString:@","];
    
    chat.isSendFromFileLib = self.isSendFromFileLib;
    chat.isTransitive = self.isTransitive;
    chat.dbModel = self.dbModel;
    if (self.fileModel) {
        
        chat.fileModel = self.fileModel;
    }
    
    chat.naviTitle = [NSString stringWithFormat:@"%@(%ld)",model.name,array.count];
    chat.chatId = model.id;
    chat.receiveId = [model.id integerValue];
    chat.cmdType = [model.chat_type integerValue];
    
    
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.isPermission) {
            return 8;
        }else{
            return 0;
        }
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{

    if (resp.cmdId == HQCMD_getAllGroupsInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.groups = resp.body;
        
        [self.tableView reloadData];
    }

    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



@end
