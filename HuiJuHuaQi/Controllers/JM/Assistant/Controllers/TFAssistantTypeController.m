//
//  TFAssistantTypeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAssistantTypeController.h"
#import "TFAssistantCell.h"
#import "TFAssistantModel.h"
#import "TFAssistantFrameModel.h"
#import "TFIMessageBL.h"
#import "HQTFNoContentView.h"
#import "TFAssistantListModel.h"
#import "MJRefresh.h"


@interface TFAssistantTypeController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFAssistantCellDelegate,JMessageDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** 数组 */
@property (nonatomic, strong) NSMutableArray *assistants;

/** TFIMessageBL */
@property (nonatomic, strong) TFIMessageBL *messageBL;


/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** pageNo */
@property (nonatomic, assign) NSInteger pageNo;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;


@end

@implementation TFAssistantTypeController

-(NSMutableArray *)assistants{
    if (!_assistants) {
        _assistants = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 10; i ++) {
//            TFAssistantFrameModel *frameModel = [[TFAssistantFrameModel alloc] init];
//            TFAssistantModel *model = [[TFAssistantModel alloc] init];
//            model.createDate = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]];
//            model.itemId = @(self.assistantType);
//            switch (self.assistantType) {
//                case AssistantTypeFile:
//                    model.name = @"文件库助手";
//                    break;
//                case AssistantTypeSchedule:
//                    model.name = @"日程助手";
//                    break;
//                case AssistantTypeNote:
//                    model.name = @"随手记助手";
//                    break;
//                case AssistantTypeTask:
//                    model.name = @"任务助手";
//                    break;
//                case AssistantTypeApproval:
//                    model.name = @"审批助手";
//                    break;
//                case AssistantTypeNotice:
//                    model.name = @"公告助手";
//                    break;
//                case AssistantTypeReport:
//                    model.name = @"工作汇报助手";
//                    break;
//                    
//                default:
//                    break;
//            }
//            model.msgDesc = @"我是描述我是描述我是描述";
//            model.sendContent = @"我是内容我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述";
//            model.priority = @0;
//            model.isFlag = @0;
//            model.isRead = @1;
//            if (i % 2 == 0) {
//                model.priority = @1;
//                model.isFlag = @1;
//                model.isRead = @0;
//            }
//            if (i % 3 == 0) {
//                model.priority = @2;
//            }
//            model.startTime = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]];
//            model.endTime = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]];
////            HQEmployModel *employ = [[HQEmployModel alloc] init];
//            model.createrName = @"伊人小亮";
////            model.people = employ;
////            if (i % 2 == 0) {
////                model.comment = @"我是一段你很给你是打发斯蒂芬奥术大师发送法大萨达是当时对方考虑考虑考虑考虑看来看看来看看了";
////            }
//            frameModel.assistantModel = model;
//            [_assistants addObject:frameModel];
//        }
        
    }
    return _assistants;
}

#pragma mark - 无内容View
- (void)setupNoContentView{
    HQTFNoContentView *noContent = [HQTFNoContentView noContentView];
    noContent.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
    
    CGRect rect = (CGRect){(SCREEN_WIDTH-Long(150))/2,(self.tableView.height - Long(150))/2 - 60,Long(150),Long(150)};
    
    [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"暂无数据"];
    
    self.noContentView = noContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
    
}

- (void)refreshData{
    
    switch (self.type) {
        case AssistantStatusTypeRead:
        {
            [self.messageBL getMessageAssistDetailWithItemId:@(self.assistantType) isRead:@1 isHandle:nil pageNo:@(self.pageNo) pageSize:@(self.pageSize)];
        }
            break;
        case AssistantStatusTypeUnread:
        {
            [self.messageBL getMessageAssistDetailWithItemId:@(self.assistantType) isRead:@0 isHandle:nil pageNo:@(self.pageNo) pageSize:@(self.pageSize)];
        }
            break;
        case AssistantStatusTypeHandle:
        {
            [self.messageBL getMessageAssistDetailWithItemId:@(self.assistantType) isRead:nil isHandle:@1 pageNo:@(self.pageNo) pageSize:@(self.pageSize)];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNoContentView];
    self.pageNo = 1;
    self.pageSize = 10;
    self.messageBL = [TFIMessageBL build];
    self.messageBL.delegate = self;
    
//    switch (self.type) {
//        case AssistantStatusTypeRead:
//        {
//            [self.messageBL getMessageAssistDetailWithItemId:@(self.assistantType) isRead:@1 isHandle:nil];
//        }
//            break;
//        case AssistantStatusTypeUnread:
//        {
//            [self.messageBL getMessageAssistDetailWithItemId:@(self.assistantType) isRead:@0 isHandle:nil];
//        }
//            break;
//        case AssistantStatusTypeHandle:
//        {
//            [self.messageBL getMessageAssistDetailWithItemId:@(self.assistantType) isRead:nil isHandle:@1];
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessage) name:AssistantMessageClearNotifitoin object:nil];
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    if (self.type == AssistantStatusTypeHandle) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessage) name:AssistantMessageClearNotifitoin object:nil];
    }
    
    if (self.type == AssistantStatusTypeUnread) {// 监听推送通知
        [self addDelegate];
    }
    
}

#pragma mark --add Delegate
- (void)addDelegate {
    [JMessage addDelegate:self withConversation:self.conversation];
}

#pragma mark --JMessageDelegate
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    if (message != nil) {
        HQLog(@"收到的message: %@",message);
    }
    if (error != nil) {
        return;
    }
    
    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }
    self.pageNo = 1;
    [self refreshData];
}

/** 清空已处理 */
- (void)clearMessage{
    
    [self.messageBL messageClearHandleWithItemId:@(self.assistantType)];
}

- (void)dealloc{
    
    if (self.type == AssistantStatusTypeHandle) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageNo = 1;
        
        
        [self refreshData];
        
    }];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNo ++;
        
        [self refreshData];
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assistants.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFAssistantCell *cell = [TFAssistantCell assistantCellWithTableView:tableView];
    [cell refreshAssistantCellWithAssistantFrameModel:self.assistants[indexPath.row]];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFAssistantFrameModel *frameModel = self.assistants[indexPath.row];
    if (self.type == AssistantStatusTypeUnread) {
        
        frameModel.assistantModel.isRead = @1;
        [self.messageBL modifyMessageAssistReadWithItemId:frameModel.assistantModel.id isRead:@1];
        [self.assistants removeObjectAtIndex:indexPath.row];
    }
    
    if ([frameModel.assistantModel.itemId isEqualToNumber:@110]){// 任务
        
//        HQTFTaskMainController *taskMain = [[HQTFTaskMainController alloc] init];
//        TFProjTaskModel *model = [[TFProjTaskModel alloc] init];
//        model.id = frameModel.assistantModel.associateModuleId;
//        taskMain.projectTask = model;
//        
//        [self.navigationController pushViewController:taskMain animated:YES];
        
    }else if ([frameModel.assistantModel.itemId isEqualToNumber:@111]){// 日程
        
//        HQDetailAndDynamiocBarVC *detailAndDynamicVC = [[HQDetailAndDynamiocBarVC alloc] init];
//        detailAndDynamicVC.scheId = frameModel.assistantModel.associateModuleId;
//        [self.navigationController pushViewController:detailAndDynamicVC animated:YES];
        
    }else if ([frameModel.assistantModel.itemId isEqualToNumber:@112]){// 随手记
        
//        TFNoteDetailController *noteDetail = [[TFNoteDetailController alloc] init];
//        TFNoteItemModel *model = [[TFNoteItemModel alloc] init];
//        model.id = frameModel.assistantModel.associateModuleId;
//        noteDetail.noteItem = model;
//        [self.navigationController pushViewController:noteDetail animated:YES];
        
    }else if ([frameModel.assistantModel.itemId isEqualToNumber:@113]){// 文件库
//        
//        DetailMainBarController *DMBC = [[DetailMainBarController alloc] init];
//        DMBC.fileId = frameModel.assistantModel.associateModuleId;
//        DMBC.fileSrc = frameModel.assistantModel.fileSrc;
//        [self.navigationController pushViewController:DMBC animated:YES];
        
    }else if ([frameModel.assistantModel.itemId isEqualToNumber:@114]){// 审批
        
//        TFApprovalDetailMainController *approval = [[TFApprovalDetailMainController alloc] init];
////        TFApprovalItemModel *model = [[TFApprovalItemModel alloc] init];
//        approval.approvalId = frameModel.assistantModel.associateModuleId;
////        approval.approvalType = (FunctionModelType)(FunctionModelTypeAll + [model.type integerValue]);
//        [self.navigationController pushViewController:approval animated:YES];
        
    }else if ([frameModel.assistantModel.itemId isEqualToNumber:@115]) {// 公告
        
//        TFNoticeDetailController *noticeDetail = [[TFNoticeDetailController alloc] init];
//        TFNoticeItemModel *model = [[TFNoticeItemModel alloc] init];
//        model.id = frameModel.assistantModel.associateModuleId;
//        noticeDetail.noticeItem = model;
//        [self.navigationController pushViewController:noticeDetail animated:YES];
        
    }else if ([frameModel.assistantModel.itemId isEqualToNumber:@116]){// 投诉建议
        
        
        
    }else if ([frameModel.assistantModel.itemId isEqualToNumber:@117]){// 工作汇报
        
//        YPDayAndWeekBarController *DWBar = [[YPDayAndWeekBarController alloc] init];
//        
//        DWBar.dailyMainId = [NSString stringWithFormat:@"%lld",[frameModel.assistantModel.associateModuleId longLongValue]];
//        
//        //抄送给我
//        if ([frameModel.assistantModel.itemType integerValue]==5) {
//            
//            DWBar.type = 2;
//        }
//        //我提交的
//        else if ([frameModel.assistantModel.itemType integerValue]==4) {
//            
//            DWBar.type = 0;
//        }
//        //待我审批的
//        else{
//            
//            DWBar.type = 1;
//            
//            //推送给我评审的 isAprroved 状态都为0
////            DWBar.isAprroved = @0;
//        }
//        // type == 1 为计划
//        DWBar.isPlan = [frameModel.assistantModel.type integerValue]==1?@0:@1;
//        
//        [self.navigationController pushViewController:DWBar animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFAssistantFrameModel *frameModel = self.assistants[indexPath.row];
    
    return frameModel.cellHeight;
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

#pragma mark - TFAssistantCellDelegate
-(void)assistantCell:(TFAssistantCell *)assistantCell didClikedFlagWithModel:(TFAssistantModel *)model{
    
    NSNumber *handle = (!model.isHandle || [model.isHandle isEqualToNumber:@0]) ? @1 : @0;
    model.isHandle = handle;
    [self.messageBL modifyMessageAssistHandleWithItemId:model.id isHandle:handle];
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_messageGetAssistDetail) {
        
//        [self.assistants removeAllObjects];
//        
//        NSArray *arr = resp.body;
//        for (TFAssistantModel *model in arr) {
//            TFAssistantFrameModel *frameModel = [[TFAssistantFrameModel alloc] init];
//            frameModel.assistantModel = model;
//            [self.assistants addObject:frameModel];
//        }
//        if (self.assistants.count == 0) {
//            
//            self.tableView.backgroundView = self.noContentView;
//        }else{
//            self.tableView.backgroundView = [UIView new];
//        }
//        
//        [self.tableView reloadData];
        
        TFAssistantListModel *model = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.assistants removeAllObjects];
        }
        
        for (TFAssistantModel *ass in model.list) {
            TFAssistantFrameModel *frameModel = [[TFAssistantFrameModel alloc] init];
            frameModel.assistantModel = ass;
            [self.assistants addObject:frameModel];
        }
        
        if (model.totalRows == self.assistants.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.assistants.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        
        [self.tableView reloadData];
        
        
    }
    
    if (resp.cmdId == HQCMD_messageModifyHandle) {
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_messageModifyRead) {
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_messageClearHandle) {
        [self.assistants removeAllObjects];
        
        
        if (self.assistants.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //    [self.tableView.mj_footer endRefreshing];
    //    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
