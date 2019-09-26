//
//  TFCustomEmailListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomEmailListController.h"
#import "TFEmailReceiveListModel.h"
#import "TFEmailsListCell.h"
#import "TFEmailsDetailController.h"
#import "TFMailBL.h"
#import "TFCustomBL.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "TFEmailsListModel.h"
#import "TFChatBL.h"

@interface TFCustomEmailListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** list */
@property (nonatomic, strong) NSMutableArray *list;

/** TFMailBL */
@property (nonatomic, strong) TFMailBL *emailBL;
/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;
/** TFChatBL */
@property (nonatomic, strong) TFChatBL *chatBL;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;

/** accountName */
@property (nonatomic, copy) NSString *accountName;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
/** model */
@property (nonatomic, strong) TFEmailReceiveListModel *model;

@end

@implementation TFCustomEmailListController

-(NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.pageSize = 20;
    self.emailBL = [TFMailBL build];
    self.emailBL.delegate = self;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    [self setupTableView];
    self.navigationItem.title = @"邮件";
    
    NSString *str = @"";
    for (NSString *sss in self.emails) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",sss]];
    }
    if (str.length) {
        str = [str substringToIndex:str.length-1];
    }
    self.accountName = str;
    if (self.accountName.length) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self.emailBL getCustomEmailListWithPageNum:self.pageNum pageSize:self.pageSize accountName:self.accountName];
        
        [self.customBL requestTabDataWithTabId:self.relevance.id dataAuth:self.dataAuth dataId:self.dataId ruleId:@0 moduleId:self.relevance.module_id dataType:self.relevance.condition_type pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
    }else{
        self.tableView.backgroundView = self.noContentView;
    }
    
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_customEmailList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFEmailsListModel *model = resp.body;
        
        TFPageInfoModel *listModel = model.pageInfo;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.list removeAllObjects];
        }
        
        [self.list addObjectsFromArray:model.dataList];
        
        
        if ([listModel.totalRows integerValue] <= self.list.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.list.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getFuncAuthWithCommunal) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = resp.body;
        NSString *readAuth = [[dict valueForKey:@"readAuth"] description];
        
        if ([readAuth isEqualToString:@"1"]) {
            
            TFEmailsDetailController *emailsDetaiVC = [[TFEmailsDetailController alloc] init];
            emailsDetaiVC.emailId = self.model.id;
            emailsDetaiVC.boxId = self.model.mail_box_id;
            [self.navigationController pushViewController:emailsDetaiVC animated:YES];
        }else{
            [MBProgressHUD showError:@"无权查看或数据已删除！" toView:self.view];
        }
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
    
    tableView.mj_header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNum = 1;
        
//        [self.emailBL getCustomEmailListWithPageNum:self.pageNum pageSize:self.pageSize accountName:self.accountName];
        
        [self.customBL requestTabDataWithTabId:self.relevance.id dataAuth:self.dataAuth dataId:self.dataId ruleId:@0 moduleId:self.relevance.module_id dataType:self.relevance.condition_type pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
    }];
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        self.pageNum += 1;
//        [self.emailBL getCustomEmailListWithPageNum:self.pageNum pageSize:self.pageSize accountName:self.accountName];
        
        [self.customBL requestTabDataWithTabId:self.relevance.id dataAuth:self.dataAuth dataId:self.dataId ruleId:@0 moduleId:self.relevance.module_id dataType:self.relevance.condition_type pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
    }];
    tableView.mj_footer = footer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFEmailReceiveListModel *model = self.list[indexPath.row];
    
    TFEmailsListCell *cell = [TFEmailsListCell EmailsListCellWithTableView:tableView];
    
    cell.leftStatusBtn.hidden = YES;
    
    
    [cell refreshEmailListCellWithModel:model];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFEmailReceiveListModel *list = self.list[indexPath.row];
    self.model = list;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 判断权限
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.relevance.sorce_bean) {
        [dict setObject:self.relevance.sorce_bean forKey:@"sorceBean"];
    }
    [self.chatBL requestGetFuncAuthWithCommunalWithData:@"tab_email" moduleId:nil style:nil dataId:list.id reqmap:[HQHelper dictionaryToJson:dict]];
    
//    return;
//
//    TFEmailsDetailController *emailsDetaiVC = [[TFEmailsDetailController alloc] init];
//    emailsDetaiVC.emailId = list.id;
//    emailsDetaiVC.boxId = list.mail_box_id;
//    [self.navigationController pushViewController:emailsDetaiVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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
