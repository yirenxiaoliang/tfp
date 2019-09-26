//
//  TFEmailsMainController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsMainController.h"
#import "TFEmailsListCell.h"
#import "TFLeftMenuView.h"
#import "TFEmailsHeadView.h"
#import "TFEmailsNewController.h"
#import "TFEmailsDetailController.h"
#import "TFEmailsNewController.h"

#import "TFRefresh.h"
#import "HQTFNoContentView.h"

#import "TFEmailsListModel.h"
#import "TFMailBL.h"
#import "TFEmailsEditView.h"
#import "TFCachePlistManager.h"
#import "HQTFSearchHeader.h"

@interface TFEmailsMainController ()<UITableViewDelegate,UITableViewDataSource,TFLeftMenuViewDelegate,HQBLDelegate,TFEmailsHeadViewDelegate,HQTFSearchHeaderDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFLeftMenuView *leftMenuView;

@property (nonatomic, strong) TFEmailsHeadView *headView;

@property (nonatomic, strong) TFMailBL *mailBL;

@property (nonatomic, strong) TFEmailsListModel *listModel;

/** 不同邮箱未读数 */
@property (nonatomic, strong) NSMutableArray *unreadArr;

//当前页
@property (nonatomic, assign) NSInteger pageNum;

//每页条数
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, strong) NSNumber *boxId;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@property (nonatomic, strong) NSMutableArray *emailDatas;
@property (nonatomic, strong) NSMutableArray *totalDatas;

/** 加号按钮 */
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@property (nonatomic, copy) NSString *word;

 @end

//1 收件箱 2 已发送 3 草稿箱 4 已删除 5 垃圾箱 6未读
#define receiveBox  @1
#define sendBox     @2
#define draftBox    @3
#define deleteBox   @4
#define rubbishBox  @5
#define unreadBox   @6

@implementation TFEmailsMainController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

- (TFEmailsListModel *)listModel {

    if (!_listModel) {
        
        _listModel = [[TFEmailsListModel alloc] init];
    }
    return _listModel;
}

- (NSMutableArray *)unreadArr {

    if (!_unreadArr) {
        
        _unreadArr = [NSMutableArray array];
    }
    return _unreadArr;
}

- (NSMutableArray *)emailDatas {
    
    if (!_emailDatas) {
        
        _emailDatas = [NSMutableArray array];
    }
    return _emailDatas;
}
- (NSMutableArray *)totalDatas {
    
    if (!_totalDatas) {
        
        _totalDatas = [NSMutableArray array];
    }
    return _totalDatas;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
//    UIBarButtonItem *returnEmail = [self itemWithTarget:self action:@selector(returnPresent) image:@"返回灰色" text:@"返回" textColor:GreenColor];
//
//    UIBarButtonItem *menu = [self itemWithTarget:self action:@selector(leftmenuAction) image:@"邮件菜单" highlightImage:@"邮件菜单"];
//
//    NSArray *leftBtns = [NSArray arrayWithObjects:returnEmail,menu, nil];
//
//    self.navigationItem.leftBarButtonItems = leftBtns;
    
    
//    TFEmailsEditView *view = [[TFEmailsEditView alloc] initWithFrame:(CGRect){20,100,300,550}];
//    
//    [self.view addSubview:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    self.pageNum = 1;
    self.pageSize = 10;
    
    if (self.outBoxId) {
        self.boxId = self.outBoxId;
        //1 收件箱 2 已发送 3 草稿箱 4 已删除 5 垃圾箱 6未读
        if ([self.boxId isEqualToNumber:@1]) {
            self.titleStr = @"收件箱";
        }else if ([self.boxId isEqualToNumber:@2]) {
            self.titleStr = @"已发送";
        }else if ([self.boxId isEqualToNumber:@3]) {
            self.titleStr = @"草稿箱";
        }
    }else{
        self.boxId = receiveBox;
    }
    
    self.mailBL = [TFMailBL build];
    self.mailBL.delegate = self;
    
    [self requestData];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self createHeadView];
    [self setupAddButton];
    
    // 取出缓存数据,刷新某列
    [self getDatasAndRefresh];
}

- (void)getDatasAndRefresh{
    
    [self.emailDatas removeAllObjects];
    NSArray *datas = [TFCachePlistManager getEmailDataWithType:[self.boxId integerValue]];
    for (NSString *str in datas) {
        NSDictionary *dict = [HQHelper dictionaryWithJsonString:str];
        TFEmailReceiveListModel *model = [[TFEmailReceiveListModel alloc] initWithDictionary:dict error:nil];
        if (model) {
            [self.emailDatas addObject:model];
        }
    }
    [self.tableView reloadData];
    
    [self.headView refreshEmailsHeadViewWithData:self.titleStr number:self.emailDatas.count type:[self.boxId integerValue]];
}

- (void)requestData {

    [self.mailBL getMailOperationQueryList:@(self.pageNum) pageSize:@(self.pageSize) accountId:nil boxId:self.boxId keyWord:nil];
    
    [self.mailBL getMailOperationQueryUnreadNumsByBoxData];
}

- (void)setupAddButton {
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:IMG(@"新备忘录新增") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addEmailAction) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = addButton;
    [self.view insertSubview:addButton aboveSubview:self.tableView];
    addButton.frame = CGRectMake(0, 0, 50, 50);
    addButton.x = SCREEN_WIDTH-30-50;
    addButton.y = SCREEN_HEIGHT-NaviHeight-50-6.5-BottomM;
    
    //    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.bottom.equalTo(@(-6.5));
    //        make.centerX.equalTo(self.view.mas_centerX);
    //        make.width.height.equalTo(@50);
    //    }];
}


- (void)setNavi {

    self.navigationItem.title = @"邮件";
    
    self.titleStr = @"收件箱";
    
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addEmailAction) image:@"添加项目" highlightImage:@"添加项目"];
    
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(leftmenuAction) image:@"邮件菜单" highlightImage:@"邮件菜单"];
    
}

- (void)setupFilterView{
    
    self.leftMenuView = [[TFLeftMenuView alloc] initWithFrame:(CGRect){-SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT} unreads:self.unreadArr];
    self.leftMenuView.tag = 0x1234554321;
    self.leftMenuView.delegate = self;
}

- (void)createHeadView {

    TFPageInfoModel *pageModel = self.listModel.pageInfo;
    
    self.headView = [[TFEmailsHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    self.headView.delegate = self;
    
    [self.headView refreshEmailsHeadViewWithData:self.titleStr number:[pageModel.totalRows integerValue] type:[self.boxId integerValue]];
    
    [self.view addSubview:self.headView];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -BottomM, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    [view addSubview:headerSearch];
    view.layer.masksToBounds = YES;
    self.headerSearch = headerSearch;
    self.headerSearch.type = SearchHeaderTypeSearch;
    tableView.tableHeaderView = view;
    headerSearch.backgroundColor = WhiteColor;
    headerSearch.textField.backgroundColor = BackGroudColor;
    headerSearch.image.backgroundColor = BackGroudColor;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.pageNum = 1;
        
        if ([self.boxId isEqualToNumber:@1] || [self.boxId isEqualToNumber:@5]) { //收件箱或垃圾箱先收信
            
            [self.mailBL getMailOperationReceive]; //收信
        }
        else {
            
            [self requestData];
        }
        
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum ++;
        [self requestData];
        
    }];
    tableView.mj_footer = footer;
    
}

#pragma mark - HQTFSearchHeaderDelegate
//-(void)searchHeaderTextChange:(UITextField *)textField{
//
//    UITextRange *range = [textField markedTextRange];
//    //获取高亮部分
//    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
//
//    if (!position) {
//
//        NSMutableArray *arr = [NSMutableArray array];
//        for (TFEmailReceiveListModel *model in self.totalDatas) {
//            if ([model.from_recipient containsString:textField.text]) {
//                [arr addObject:model];
//                continue;
//            }
//            if ([model.subject containsString:textField.text]) {
//                [arr addObject:model];
//                continue;
//            }
//            if ([model.mail_content containsString:textField.text]) {
//                [arr addObject:model];
//                continue;
//            }
//        }
//        self.emailDatas = arr;
//        [self.tableView reloadData];
//        self.word = textField.text;
//    }
//    if (textField.text.length == 0) {
//        [self.emailDatas removeAllObjects];
//        [self.emailDatas addObjectsFromArray:self.totalDatas];
//
//        [self.tableView reloadData];
//        self.word = textField.text;
//    }
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.mailBL getMailOperationQueryList:@(self.pageNum) pageSize:@(self.pageSize) accountId:nil boxId:self.boxId keyWord:textField.text];
    self.word = textField.text;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = self.word;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = self.word;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.emailDatas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFEmailReceiveListModel *model = self.emailDatas[indexPath.section];
    
    TFEmailsListCell *cell = [TFEmailsListCell EmailsListCellWithTableView:tableView];
    
//    cell.leftStatusBtn.hidden = YES;
    
    
    [cell refreshEmailListCellWithModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFEmailReceiveListModel *list = self.emailDatas[indexPath.section];
    
    if ([list.mail_box_id isEqualToNumber:@3]) { //草稿箱
        
        
        if ([list.approval_status isEqualToString:@"2"] || [list.approval_status isEqualToString:@"3"]) { //审批通过或者驳回
            
            TFEmailsDetailController *emailsDetaiVC = [[TFEmailsDetailController alloc] init];
            emailsDetaiVC.model = list;
            emailsDetaiVC.emailId = list.id;
            emailsDetaiVC.boxId = list.mail_box_id;
            emailsDetaiVC.refresh = ^{
              
                [self requestData];
            };
            
            [self.navigationController pushViewController:emailsDetaiVC animated:YES];
        }
        else { //保存的草稿或审批撤销的邮件
        
            if ([list.timer_status isEqualToString:@"1"]) {
                
                TFEmailsDetailController *emailsDetaiVC = [[TFEmailsDetailController alloc] init];
                emailsDetaiVC.model = list;
                emailsDetaiVC.emailId = list.id;
                emailsDetaiVC.boxId = list.mail_box_id;
                emailsDetaiVC.refresh = ^{
                  
                    [self requestData];
                };
                
                [self.navigationController pushViewController:emailsDetaiVC animated:YES];
            }
            else {
            
                TFEmailsNewController *controller = [[TFEmailsNewController alloc] init];
                
                controller.detailModel = list;
                controller.type = 3;
                
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        }
        
    }
    
    else { //
    
        TFEmailsDetailController *emailsDetaiVC = [[TFEmailsDetailController alloc] init];
        emailsDetaiVC.model = list;
        emailsDetaiVC.emailId = list.id;
        emailsDetaiVC.boxId = list.mail_box_id;
        emailsDetaiVC.refresh = ^{
          
            [self requestData];
        };
        
        [self.navigationController pushViewController:emailsDetaiVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 86;
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [self.headerSearch.textField resignFirstResponder];
}

#pragma mark TFEmailsHeadViewDelegate 
- (void)markAllEmailsReaded {

    [self.mailBL requestMarkAllMailRead:@1];

}

#pragma mark - TFFilterViewDelegate
- (void)fileterViewCellDid:(NSInteger)index title:(NSString *)title{

    switch (index) {
        case 0:
        {
            self.boxId = receiveBox;
        }
            break;
        case 1:
        {
            self.boxId = unreadBox;
        }
            break;
        case 2:
        {
            self.boxId = sendBox;
        }
            break;
        case 3:
        {
            self.boxId = draftBox;
        }
            break;
        case 4:
        {
            self.boxId = deleteBox;
        }
            break;
        case 5:
        {
            self.boxId = rubbishBox;
        }
            break;
        case 6:
        {
            self.boxId = receiveBox;
            
        }
            break;
            
        default:
            break;
    }
    
    if (index == 6) {
        
        self.titleStr = @"收件箱";
    }
    else {
    
        self.titleStr = title;
    }
    
    // 取出缓存数据,刷新某列
    [self getDatasAndRefresh];
    self.pageNum = 1;
    [self.mailBL getMailOperationQueryList:@(self.pageNum) pageSize:@(self.pageSize) accountId:nil boxId:self.boxId keyWord:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)filterViewDidClicked:(BOOL)show{
    

    [UIView animateWithDuration:0.25 animations:^{
        
        self.leftMenuView.left = SCREEN_WIDTH;
        self.leftMenuView.backgroundColor = RGBAColor(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
        [self.leftMenuView removeFromSuperview];
    }];
}

- (void)leftmenuAction {


    [KeyWindow addSubview:self.leftMenuView];
    
    self.leftMenuView.left = SCREEN_WIDTH;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.leftMenuView.backgroundColor = RGBAColor(0, 0, 0, .5);
        self.leftMenuView.left = 0;
    }];

    [self.leftMenuView refreshLeftmenuViewWithBoxId:self.boxId];

}

- (void)returnPresent {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addEmailAction {

    TFEmailsNewController *newEmail = [[TFEmailsNewController alloc] init];
    
    [self.navigationController pushViewController:newEmail animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_mailOperationReceive) { //收信
        
        [self requestData];
    }
    //列表
    if (resp.cmdId == HQCMD_mailOperationQueryList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.listModel = resp.body;
        
        for (TFEmailReceiveListModel *item in self.listModel.dataList) {
            item.contentSimple = [HQHelper filterHTML:item.mail_content];
            if ( item.contentSimple.length > 200){
                item.contentSimple = [item.contentSimple substringToIndex:200];
            }
        }
//        [self createHeadView];
//        TFPageInfoModel *pageModel = self.listModel.pageInfo;
        [self.headView refreshEmailsHeadViewWithData:self.titleStr number:[self.listModel.pageInfo.totalRows integerValue] type:[self.boxId integerValue]];
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.emailDatas removeAllObjects];
        }
        
        [self.emailDatas addObjectsFromArray:self.listModel.dataList];
        
        if ([self.listModel.pageInfo.totalRows integerValue] == self.emailDatas.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.emailDatas.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }

        [self.totalDatas removeAllObjects];
        [self.totalDatas addObjectsFromArray:self.emailDatas];
    
        [self.tableView reloadData];
        
            
        if (self.emailDatas.count < 100) {
            
            NSMutableArray *datas = [NSMutableArray array];
            for (TFEmailReceiveListModel *model in self.emailDatas) {
                NSString *str = [model toJSONString];
                if (str) {
                    [datas addObject:str];
                }
            }
            [TFCachePlistManager saveEmailDataWithDatas:datas type:[self.boxId integerValue]];
            
        }
    }
    
    //全部标为已读
    if (resp.cmdId == HQCMD_markAllMailRead) {
        
        [MBProgressHUD showError:@"操作成功！" toView:self.view];
        
        [self.tableView reloadData];
    }
    
    //未读数
    if (resp.cmdId == HQCMD_mailOperationQueryUnreadNumsByBox) {
        
        self.unreadArr = resp.body;
        
        [self setupFilterView];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
