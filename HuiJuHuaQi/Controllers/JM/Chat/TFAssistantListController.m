//
//  TFAssistantListController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAssistantListController.h"
#import "FDActionSheet.h"
#import "TFAssistantSettingController.h"
#import "TFAssistantListCell.h"
#import "TFAssistantFrameModel.h"
//#import "TFCustomDetailController.h"
#import "TFNewCustomDetailController.h"
#import "HQTFNoContentView.h"

#import "TFAssistantSiftModel.h"
#import "TFAssistantAuthModel.h"
#import "TFFileDetailController.h"
#import "TFCreateNoteController.h"
#import "TFCustomerCommentController.h"
#import "TFApprovalDetailController.h"
#import "TFAssistantApproModel.h"

#import "TFChatBL.h"
#import "TFCustomBL.h"

#import "TFApprovalListItemModel.h"
#import "TFEmailsDetailController.h"
#import "TFRefresh.h"
#import "TFAssistantMainModel.h"
#import "TFModalListView.h"
#import "TFProjectTaskDetailController.h"
#import "TFKnowledgeDetailController.h"
#import "TFEmailApprovalController.h"
#import "TFAttendanceTabbarController.h"

@interface TFAssistantListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFModalListViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *assistants;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) NSMutableArray *beanArr;
@property (nonatomic, strong) NSMutableArray *nameArr;


@property (nonatomic, strong) TFAssistantAuthModel *authModel;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 点击索引 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) TFCustomBL *customBL;

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, strong) TFAssistantMainModel *mainModel;

//进来的时候有没有数据库
@property (nonatomic, assign) BOOL isDB;

/** 点击的Model */
@property (nonatomic, strong) TFFMDBModel *clickModel;

@property (nonatomic, copy) NSString *moduleName;

@end

@implementation TFAssistantListController

- (NSMutableArray *)assistants{
    
    if (!_assistants) {
        
        _assistants = [NSMutableArray array];
    }
    return _assistants;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setNavi];
    [self getLocalDatabaseData];
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListData:) name:UpdateAssistantListDataNotification object:nil];
    
    /**
     // 查询小助手列表数据最后一条推送时间
    TFFMDBModel *model = [DataBaseHandle queryAssistantDataListLastTime:self.assistantId];
    if (model.create_time) { //有本地数据
        self.isDB = YES;
        // 会话列表最新一条推送跟本地最新一条推送时间不相等，则说明期间有历史推送数据，先清空该小助手本地数据，再拉取接口数据同步
        self.timeSp = @([self.timeSp longLongValue]/1000);
        model.create_time = @([model.create_time longLongValue]/1000);
        if (![self.timeSp isEqualToNumber:model.create_time]) {
            // 请求中间缺失数据
            [self.chatBL requestGetAssistantMessageLimitData:self.assistantId beanName:@"" upTime:self.timeSp downTime:model.create_time dataSize:@(30)];
        }
        else {
            [self getLocalDatabaseData];
        }
    }
    else { //无本地数据
        self.isDB = NO;
        [self requestData];
    }
    */
    [self requestData];
    
    if (self.type == 2) {
        
        //查询该小助手的本地数据
        TFFMDBModel *dbModel = [DataBaseHandle queryAssistantListDataWithChatId:self.assistantId];
        
        //未读数减1
        dbModel.unreadMsgCount = @0;
        
        if ([dbModel.unreadMsgCount integerValue] < 0) {//以防万一...
            
            dbModel.unreadMsgCount = @0;
        }
        
        //更新小助手列表未读数量
        [DataBaseHandle updateAssistantListUnReadWithData:dbModel];
        
        //通知更新列表
        [[NSNotificationCenter defaultCenter] postNotificationName:AssistantUnreadNotification object:nil];
        
        // 小助手进来就全部已读
        [self.chatBL requestMarkAllReadWithData:self.assistantId];
    }
    
}

/** 初始化数据 */
- (void)initData {
    
    self.moduleName = @"";
    self.pageSize = 10;
    self.pageNo = 1;
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
}

- (void)getLocalDatabaseData {
    
   self.assistants = [DataBaseHandle queryAssistantDataListWithAssistantId:self.assistantId beanName:self.moduleName pageNum:@(self.pageNo) pageSize:@(self.pageSize) showType:self.showType];

    [self.tableView.mj_header endRefreshing];
}

/** 拉取后台最新数据 */
- (void)requestData {

    [self.chatBL requestGetAssistantMessageWithData:self.assistantId beanName:self.moduleName pageSize:@(self.pageSize) pageNo:@(self.pageNo)];
    
}

/** 拉取历史数据 */
- (void)requestHistoryData {
    
    TFFMDBModel *model = [DataBaseHandle queryAssistantDataListFirstTime:self.assistantId];
    
    [self.chatBL requestGetAssistantMessageLimitData:self.assistantId beanName:@"" upTime:nil downTime:model.create_time dataSize:@(self.pageSize)];
}

- (void)setNavi {

    self.navigationItem.title = self.naviTitle;
    
    if (self.type == 1) {
        
        UIBarButtonItem *setBtn = [self itemWithTarget:self action:@selector(setClick) image:@"设置灰色" highlightImage:@"设置灰色"];
        UIBarButtonItem *siftBtn = [self itemWithTarget:self action:@selector(siftClick) image:@"筛选Assistant" highlightImage:@"筛选Assistant"];
        
        NSArray *rightBtns = [NSArray arrayWithObjects:setBtn,siftBtn, nil];
        
        self.navigationItem.rightBarButtonItems = rightBtns;
    }
    else {
    
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(setClick) image:@"设置灰色" highlightImage:@"设置灰色"];
    }
    
}

#pragma mark 通知系列方法
- (void)updateListData:(NSNotification *)note {
    
//    TFFMDBModel *model = note.object;
    //查询小助手列表数据
    [self getLocalDatabaseData];
    
    [self.tableView reloadData];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -BottomM+5, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.mj_header = [TFRefresh headerGifRefreshWithBlock:^{

        self.pageNo = 1;
        self.moduleName = @"";
//        [self getLocalDatabaseData];
        
        [self requestData];

    }];

    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNo ++;
//        if (!self.isDB) { //最开始不存在本地数据库，就先从后台接口拉取数据
//
//            [self requestData];
//        }
//        else { //存在本地数据库
//
//            [self requestHistoryData];
//        }
        [self requestData];
        
    }];
    tableView.mj_footer = footer;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assistants.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TFFMDBModel *model = self.assistants[indexPath.row];
    TFAssistantListCell *cell = [TFAssistantListCell AssistantListCellWithTableView:tableView];

    
    [cell refreshAssistantListCellWithModel:model type:self.type name:self.naviTitle];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    _index = indexPath.row;
    
    TFFMDBModel *model = self.assistants[indexPath.row];
    self.clickModel = model;
    /** model.type
     1:群操作(解散群)
     10:群操作(踢人)
     11:群操作(拉人)
     12:群操作(退群)
     13:群操作(修改群信息)
     */
    
    switch ([model.type integerValue]) {

        case 2: //评论@
        {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if ([model.beanName isEqualToString:@"file_library"]) { //文件库

                [self.chatBL requestGetFuncAuthWithCommunalWithData:@"file_library" moduleId:nil style:model.style dataId:model.dataId reqmap:nil];
            }
//            if ([model.beanName isEqualToString:@"file_library"]) {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                TFFileDetailController *fileDetailVC = [[TFFileDetailController alloc] init];
//
//                fileDetailVC.fileId = model.dataId;
//                fileDetailVC.style = [model.style integerValue];
//
//                [self.navigationController pushViewController:fileDetailVC animated:YES];
//            }
            if ([model.beanName isEqualToString:@"memo"]) { //备忘录
                
                [self.chatBL requestGetFuncAuthWithCommunalWithData:@"memo" moduleId:nil style:@100 dataId:model.dataId reqmap:nil];
                
            }
            if ([model.beanName isEqualToString:@"email"]) { //邮件
                
                [self.chatBL requestGetFuncAuthWithCommunalWithData:@"email" moduleId:nil style:model.style dataId:model.dataId reqmap:nil];
            }
            if ([model.beanName isEqualToString:@"approval"]) { //审批
                
                NSDictionary *dic = [HQHelper dictionaryWithJsonString:model.param_fields];
                [self.customBL requestQueryApprovalDataWithDataId:[dic valueForKey:@"dataId"] type:[dic valueForKey:@"fromType"] bean:[dic valueForKey:@"moduleBean"] processInstanceId:[dic valueForKey:@"processInstanceId"] taskKey:[dic valueForKey:@"taskKey"]];
            }
            
            if ([model.beanName isEqualToString:@"repository_libraries"]) { //知识库
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                TFKnowledgeDetailController *knowledge = [[TFKnowledgeDetailController alloc] init];
//                knowledge.dataId = model.dataId;
//                [self.navigationController pushViewController:knowledge animated:YES];
                
                [self.chatBL requestGetFuncAuthWithCommunalWithData:@"repository_libraries" moduleId:nil style:model.style dataId:model.dataId reqmap:nil];
            }
        }
            break;
        case 3: //自定义推送
        {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.chatBL requestGetFuncAuthWithCommunalWithData:model.beanName moduleId:nil style:nil dataId:model.dataId reqmap:nil];

        }
            break;
        case 4: //审批
        {
            //查询审批详情参数
            TFAssistantApproModel *approModel = [[TFAssistantApproModel alloc] initWithDictionary:[HQHelper dictionaryWithJsonString:model.param_fields] error:nil];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestQueryApprovalDataWithDataId:approModel.dataId type:approModel.fromType bean:approModel.moduleBean processInstanceId:approModel.processInstanceId taskKey:approModel.taskKey];
            
        }
            break;
        case 5: //文件库
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.chatBL requestGetFuncAuthWithCommunalWithData:@"file_library" moduleId:nil style:model.style dataId:model.dataId reqmap:nil];

        }
            break;
        case 7: //备忘录
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.chatBL requestGetFuncAuthWithCommunalWithData:@"memo" moduleId:nil style:@100 dataId:model.dataId reqmap:nil];
            
        }
            break;
        case 8: //邮件
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.chatBL requestGetFuncAuthWithCommunalWithData:@"email" moduleId:nil style:nil dataId:model.dataId reqmap:nil];
            
        }
            break;
        case 25:// 个人任务
        {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.chatBL requestGetFuncAuthWithCommunalWithData:model.beanName moduleId:nil style:nil dataId:model.id reqmap:model.param_fields];
            
        }
            break;
        case 26:// 项目任务
        {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.chatBL requestGetFuncAuthWithCommunalWithData:model.beanName moduleId:nil style:nil dataId:model.id reqmap:model.param_fields];
            
        }
            break;
        case 27:// 知识库
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.chatBL requestGetFuncAuthWithCommunalWithData:@"repository_libraries" moduleId:nil style:model.style dataId:model.dataId reqmap:nil];
            
        }
            break;
        case 28:// 考勤
        {
            //更新已读状态
            if ([model.readStatus isEqualToString:@"0"]) { //未读
                [self.chatBL requestReadMessageWithData:model.id assistantId:self.assistantId];
            }
            TFAttendanceTabbarController *attendance = [[TFAttendanceTabbarController alloc] init];
            [self.navigationController pushViewController:attendance animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFAssistantListCell refreshAssistantCellHeightWithModel:self.assistants[indexPath.row]];;
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

#pragma mark click Action
- (void)siftClick {

    if (_nameArr) {
        [self filterModalView:_nameArr];
    }else{
        [self.chatBL requestFindModuleListWithData:self.applicationId];
    }
    
}

- (void)setClick {

    TFAssistantSettingController *setVC = [[TFAssistantSettingController alloc] init];
    
    setVC.assistantId = self.assistantId;
    setVC.type = self.type;
    setVC.icon_url = self.icon_url;
    setVC.icon_color = self.icon_color;
    setVC.icon_type = self.icon_type;
    setVC.refresh = ^{
        
        [self getLocalDatabaseData];
        
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark TFModalListViewDelegate <筛选模块>
- (void)siftModuleListWithData:(NSInteger)index {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    self.moduleName = _beanArr[index];
    self.pageNo = 1;
    [self requestData];
    /**
     
     self.assistants = [DataBaseHandle queryAssistantDataListWithAssistantId:self.assistantId beanName:_beanArr[index] pageNum:@(self.pageNo) pageSize:@(self.pageSize) showType:self.showType];
     
     if (self.assistants.count == 0) {
     self.tableView.backgroundView = self.noContentView;
     }else{
     self.tableView.backgroundView = [UIView new];
     }
     [self.tableView reloadData];
     */
//    [self.chatBL requestGetAssistantMessageWithData:self.assistantId beanName:_beanArr[index] pageSize:@30 pageNo:@1];
}

#pragma mark --FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
        
    [self.chatBL requestGetAssistantMessageWithData:self.assistantId beanName:_beanArr[buttonIndex] pageSize:@30 pageNo:@1];
    
}

//模态视图
- (void)modalView:(TFAssistListModel *)model {

    UIViewController *addVC = [[UIViewController alloc] init];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(40, (SCREEN_HEIGHT-120-NaviHeight)/2, SCREEN_WIDTH-80, 120)];
    
    subView.layer.cornerRadius = 5.0;
    subView.layer.masksToBounds = YES;
    subView.backgroundColor = WhiteColor;
    
    [addVC.view addSubview:subView];
    
    if ([model.type isEqualToNumber:@3]) {
        
        //内容
        UILabel *titleLab = [UILabel initCustom:CGRectZero title:model.push_content titleColor:kUIColorFromRGB(0x17171A) titleFont:16 bgColor:ClearColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [subView addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.width.equalTo(@(subView.width-20));
            
        }];
        
        //负责人
        UILabel *responsibleLab = [UILabel initCustom:CGRectZero title:@"负责人：" titleColor:kUIColorFromRGB(0xA0A0AE) titleFont:14 bgColor:ClearColor];
        responsibleLab.textAlignment = NSTextAlignmentLeft;
        [subView addSubview:responsibleLab];
        
        [responsibleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
            make.top.equalTo(titleLab.mas_bottom).offset(10);
            make.width.equalTo(@(subView.width-20));
            
        }];
        
        //时间
        UILabel *timeLab = [UILabel initCustom:CGRectZero title:[HQHelper nsdateToTime:[model.datetime_create_time longLongValue] formatStr:@"yyyy-MM-dd"] titleColor:kUIColorFromRGB(0xA0A0AE) titleFont:14 bgColor:ClearColor];
        timeLab.textAlignment = NSTextAlignmentLeft;
        [subView addSubview:timeLab];
        
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
            make.top.equalTo(responsibleLab.mas_bottom).offset(10);
            make.width.equalTo(@(subView.width-20));
            
        }];

    }
    else {
    
        //内容
        UILabel *titleLab = [UILabel initCustom:CGRectZero title:model.push_content titleColor:kUIColorFromRGB(0x17171A) titleFont:16 bgColor:ClearColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [subView addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.width.equalTo(@(subView.width-20));
            
        }];
    }
    
    self.definesPresentationContext = YES;
    
    addVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:addVC animated:NO completion:^{
        
        UIColor *color = [UIColor blackColor];
        
        addVC.view.backgroundColor = [color colorWithAlphaComponent:0.5];
        
    }];

}

//模态视图
- (void)filterModalView:(NSMutableArray *)datas {
    
    UIViewController *addVC = [[UIViewController alloc] init];
    
    CGFloat modalHeight;
    CGFloat currentMH = 65+datas.count*44;
    CGFloat maxMH = SCREEN_HEIGHT-40-NaviHeight;
    if (currentMH > maxMH) {
        
        modalHeight = maxMH;
    }
    else {
        
        modalHeight = currentMH;
    }
    
    TFModalListView *subview = [[TFModalListView alloc] initWithFrame:CGRectMake(53, (SCREEN_HEIGHT-NaviHeight-modalHeight)/2, SCREEN_WIDTH-106, modalHeight) items:datas];
    subview.layer.cornerRadius = 14.0;
    subview.layer.masksToBounds = YES;
    subview.backgroundColor = WhiteColor;
    subview.delegate = self;
    
    [addVC.view addSubview:subview];
    
    self.definesPresentationContext = YES;
    
    addVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:addVC animated:NO completion:^{
        
        UIColor *color = [UIColor blackColor];
        
        addVC.view.backgroundColor = [color colorWithAlphaComponent:0.5];
        
    }];
    
}

//回收模态
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 转换
-(TFFMDBModel *)getFMDBModelChangeAssistListModel:(TFAssistListModel *)listModel{
    
    TFFMDBModel *fm = [[TFFMDBModel alloc] init];
    fm.id = listModel.id;
    fm.companyId = UM.userLoginInfo.company.id;
    fm.assistantId = listModel.assistant_id;
    fm.myId = UM.userLoginInfo.employee.id;
    fm.dataId = listModel.data_id;
    fm.type = [listModel.type stringValue];
    fm.pushContent = listModel.push_content;
    fm.beanName = listModel.bean_name;
    fm.beanNameChinese = listModel.bean_name_chinese;
    fm.create_time = listModel.datetime_create_time;
    fm.readStatus = listModel.read_status;
    fm.style = listModel.style;
    fm.param_fields = listModel.param_fields;
    
    fm.icon_url = listModel.icon_url;
    fm.icon_color = listModel.icon_color;
    fm.icon_type = listModel.icon_type;
    
    //自定义字段取值
    if (self.type == 1 || self.type == 3 || self.type ==7) {
        
        if (listModel.field_info.count > 0) {
            
            for (int i=0; i<listModel.field_info.count; i++) {
                
                TFAssistantFieldInfoModel *filedModel = listModel.field_info[i];
                
                if (i == 0) {
                    
                    fm.oneRowValue = [HQHelper stringWithAssistantFieldInfoModel:filedModel];
                }
                else if (i == 1) {
                    
                    fm.twoRowValue = [HQHelper stringWithAssistantFieldInfoModel:filedModel];;
                }
                else if (i == 2) {
                    
                    fm.threeRowValue = [HQHelper stringWithAssistantFieldInfoModel:filedModel];;
                }
            }
        }
    }
    
    return fm;
}

#pragma mark 后台返回数据存入本地数据库表
- (void)saveDataToAssistantListTable:(TFAssistListModel *)listModel {
    TFFMDBModel *fm = [self getFMDBModelChangeAssistListModel:listModel];
    HQGlobalQueue(^{
        [DataBaseHandle insertIntoAssistantDataListTable:fm];
    });
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{

    if (resp.cmdId == HQCMD_getAssistantMessage) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.mainModel = resp.body;
        
//        [self getLocalDatabaseData];
        
        for (TFAssistListModel *listModel in self.mainModel.dataList) {
            
            BOOL have = NO;
            if (self.assistants.count > 0) {
                
                for (TFFMDBModel *db in self.assistants) {
                    
                    if ([[listModel.id description] isEqualToString:[db.id description]]) {
                        
                        have = YES;
                        break;
                    }
                }
            }
            else {
                
                have = NO;
            }
            
            if (!have) {
                //存入本地数据库
                [self saveDataToAssistantListTable:listModel];
                
                self.isDB = YES;
            }
            
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {

            [self.tableView.mj_footer endRefreshing];

        }else {

            [self.tableView.mj_header endRefreshing];

            [self.assistants removeAllObjects];
        }
        NSMutableArray *arrData = [NSMutableArray array];
        for (TFAssistListModel *listModel in self.mainModel.dataList) {
            TFFMDBModel *fm = [self getFMDBModelChangeAssistListModel:listModel];
            [arrData addObject:fm];
        }
        
        [self.assistants addObjectsFromArray:arrData];
//        [self getLocalDatabaseData];

        if ([self.mainModel.pageInfo.totalRows integerValue] == self.assistants.count) {

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
    
    if (resp.cmdId == HQCMD_findModuleList) {
        
        
        NSArray *arr = resp.body;

        _beanArr = [NSMutableArray array];
        _nameArr = [NSMutableArray array];

        for (TFAssistantSiftModel *model in arr) {

            [_nameArr addObject:model.chinese_name];

            [_beanArr addObject:model.english_name];
        }
        [_nameArr insertObject:@"全部" atIndex:0];
        [_beanArr insertObject:@"" atIndex:0];
        [self filterModalView:_nameArr];
        
    }
    if (resp.cmdId == HQCMD_readMessage) { //已读
        
//        HQMainQueue(^{
        
            TFFMDBModel *model = self.assistants[self.index];
            TFAssistantPushModel *push = [[TFAssistantPushModel alloc] init];
            push.push_content = @"1";
            push.data_id = model.id;
            [DataBaseHandle updateAssistantListDataIsReadWithData:push];
            
//            [self getLocalDatabaseData];
        self.clickModel.readStatus = @"1";
            
            [self.tableView reloadData];
//        });
        if (self.refresh) {
            self.refresh();
        }
        
    }

    if (resp.cmdId == HQCMD_markAllRead) { //全部标为已读
        
        //查询该小助手的本地数据
//        TFFMDBModel *dbModel = [DataBaseHandle queryAssistantListDataWithChatId:self.assistantId];
//
//        //未读数为0
//        dbModel.unreadMsgCount = @(0);
//
//        //更新小助手列表未读数量
//        [DataBaseHandle updateAssistantListUnReadWithData:dbModel];
//
//        //通知更新列表
//        [[NSNotificationCenter defaultCenter] postNotificationName:AssistantUnreadNotification object:nil];
    }
    
    if (resp.cmdId == HQCMD_getFuncAuthWithCommunal) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        TFFMDBModel *model = self.assistants[self.index];
        TFFMDBModel *model = self.clickModel;
        //更新已读状态
        if ([model.readStatus isEqualToString:@"0"]) { //未读
            
//            HQGlobalQueue(^{
            
                [self.chatBL requestReadMessageWithData:model.id assistantId:self.assistantId];
//            });
            
        }
        
        NSDictionary *dict = [NSDictionary dictionary];
        dict = resp.body;
        
        NSNumber *authStr = [dict valueForKey:@"readAuth"];

        if (!([[authStr description] isEqualToString:@"0"] || [[authStr description] isEqualToString:@"2"])) {
            
            TFFMDBModel *model = self.assistants[_index];
            
            if ([model.beanName isEqualToString:@"memo"]) {
                
                TFCreateNoteController *note = [[TFCreateNoteController alloc] init];
                
                note.noteId = model.dataId;
                note.type = 1;
                
                [self.navigationController pushViewController:note animated:YES];
            }
            else if ([model.beanName isEqualToString:@"email"]) {
                
                TFEmailsDetailController *emailDetailVC = [[TFEmailsDetailController alloc] init];
                
                emailDetailVC.emailId = model.dataId;
                emailDetailVC.boxId = @10;
                
                [self.navigationController pushViewController:emailDetailVC animated:YES];
            }
            else if ([model.beanName isEqualToString:@"file_library"]) {
                
                TFFileDetailController *fileDetailVC = [[TFFileDetailController alloc] init];
                fileDetailVC.noAuth = NO;
                fileDetailVC.fileId = model.dataId;
                fileDetailVC.style = [model.style integerValue];
                
                [self.navigationController pushViewController:fileDetailVC animated:YES];
            }
            else if ([model.beanName containsString:@"bean"]) {// 自定义
            
//                TFCustomDetailController *detai = [[TFCustomDetailController alloc] init];
                TFNewCustomDetailController *detai = [[TFNewCustomDetailController alloc] init];
                
                detai.dataId = model.dataId;
                detai.bean = model.beanName;
                
                [self.navigationController pushViewController:detai animated:YES];
            }
            else if ([model.beanName containsString:@"project_custom"]) {// 任务
                
                
                NSDictionary *dic = [HQHelper dictionaryWithJsonString:model.param_fields];
                
                TFProjectTaskDetailController *taskVC = [[TFProjectTaskDetailController alloc] init];
                
//                taskVC.dataId = model.dataId;
                
                NSString *taskType = [[dic valueForKey:@"from"] description];// 个人任务 还是 项目任务
                
                if (taskType && [taskType isEqualToString:@"1"]) {// 个人任务
                    
                    taskVC.dataId = [dic valueForKey:@"id"];
                    
                    NSString *childType = [[dic valueForKey:@"fromType"] description];// 主任务 还是 子任务
                    
                    if ([childType isEqualToString:@"0"]) { // 主任务
                        
                        taskVC.taskType = 2;
                    }
                    else { // 子任务
                        
                        taskVC.taskType = 3;
                    }
                    
                }else{// 项目任务
                    
                    
                    taskVC.projectId = [dic valueForKey:@"projectId"];
                    NSString *task_id = [[dic valueForKey:@"task_id"] description];
                    
                    if ([task_id isEqualToString:@""] || task_id == nil) { // 主任务
                        
                        taskVC.dataId = [dic valueForKey:@"taskInfoId"];
                        taskVC.taskType = 0;
                    }
                    else {
                        
                        taskVC.dataId = [dic valueForKey:@"id"];
                        taskVC.taskType = 1;
                    }
                }
                
                
                [self.navigationController pushViewController:taskVC animated:YES];
                
            }
            else if ([model.beanName isEqualToString:@"repository_libraries"]){
                
                TFKnowledgeDetailController *knowledge = [[TFKnowledgeDetailController alloc] init];
                knowledge.dataId = model.dataId;
                [self.navigationController pushViewController:knowledge animated:YES];
                
            }
        }
        else {
            
            if ([model.beanName isEqualToString:@"file_library"]) {
                
                TFFileDetailController *fileDetailVC = [[TFFileDetailController alloc] init];
                fileDetailVC.noAuth = YES;
                fileDetailVC.fileId = model.dataId;
                fileDetailVC.style = [model.style integerValue];
                
                [self.navigationController pushViewController:fileDetailVC animated:YES];
            }else{
                
                [MBProgressHUD showError:@"无权查看或数据已删除！" toView:self.view];
                return;
            }
        }

    }
    if (resp.cmdId == HQCMD_CustomQueryApprovalData) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        TFFMDBModel *listModel = self.assistants[self.index];
        //更新已读状态
        if ([listModel.readStatus isEqualToString:@"0"]) { //未读
            
//            HQGlobalQueue(^{
            listModel.readStatus = @"1";
            [self.tableView reloadData];
            [self.chatBL requestReadMessageWithData:listModel.id assistantId:self.assistantId];
//            });
        }
        
        TFApprovalListItemModel *model = resp.body;
       
        if ([model.module_bean isEqualToString:@"mail_box_scope"]) {
            
            TFEmailApprovalController *email = [[TFEmailApprovalController alloc] init];
            email.approvalItem = model;
            email.listType = [model.fromType integerValue];
            
            [self.navigationController pushViewController:email animated:YES];
            return;
        }
        
        TFApprovalDetailController *approval = [[TFApprovalDetailController alloc] init];
        approval.isReadRequest = YES;
        approval.approvalItem = model;
        approval.listType = [model.fromType integerValue];
        
        [self.navigationController pushViewController:approval animated:YES];
    }
    
    if (resp.cmdId == HQCMD_getAssistantMessageLimit) {
        
#warning 接口数据大于20，则清空本地数据
        
        self.mainModel = resp.body;
//        TFPageInfoModel *pageModel = self.mainModel.pageInfo;
        
//        NSMutableArray *arrData = [NSMutableArray array];
//        if ([pageModel.totalRows integerValue] > 20) {
//
//            /** 清空该小助手数据 */
//            [DataBaseHandle deleteAssistantListDataWithAssistantId:self.assistantId];
//
//            /** 请求之前数据 */
//            [self.chatBL requestGetAssistantMessageLimitData:self.assistantId beanName:@"" upTime:self.timeSp downTime:nil dataSize:@(self.pageSize)];
//
//            return;
//        }else {
        
            for (TFAssistListModel *listModel in self.mainModel.dataList) {
                
                [self saveDataToAssistantListTable:listModel];
                
            }
//        }
        
//        arrData = [DataBaseHandle queryAssistantDataListWithAssistantId:self.assistantId beanName:nil pageNum:@(self.pageNo) pageSize:@(self.pageSize)];
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.assistants removeAllObjects];
        }
        
//        [self.assistants addObjectsFromArray:arrData];
        [self getLocalDatabaseData];
        
        if ([self.mainModel.pageInfo.totalRows integerValue] == self.assistants.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
    
    if (resp.cmdId == HQCMD_getAssistantMessage) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
    
    if (resp.cmdId == HQCMD_CustomQueryApprovalData || resp.cmdId == HQCMD_getFuncAuthWithCommunal) {// 无权限也要修改状态
        
        TFFMDBModel *listModel = self.assistants[self.index];
        //更新已读状态
        if ([listModel.readStatus isEqualToString:@"0"]) { //未读
            
            //            HQGlobalQueue(^{
            listModel.readStatus = @"1";
            [self.tableView reloadData];
            [self.chatBL requestReadMessageWithData:listModel.id assistantId:self.assistantId];
            //            });
        }
        
    }
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Aciton1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton1");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Aciton2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton2");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Aciton3" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton3");
    }];
    
    NSArray *actions = @[action1,action2,action3];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
}
@end
