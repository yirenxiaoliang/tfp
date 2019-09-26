//
//  HQConversationListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/24.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQConversationListController.h"
#import "HQChatTableView.h"
#import "JCHATConversationListCell.h"
#import "HQEmployModel.h"
#import "HQConversationController.h"
#import "HQTFSearchHeader.h"
#import "TFSelectChatPersonController.h"
#import <CoreLocation/CoreLocation.h>
#import "Scan_VC.h"

#import "TFChatViewController.h"
#import "TFChatBL.h"
#import "PopoverView.h"
#import "TFCreateGroupController.h"

#import "TFChatInfoListModel.h"
#import "TFChatGroupListController.h"
#import "TFEmployModel.h"
#import "TFAssistantListController.h"
#import "TFSearchChatRecordController.h"
#import "TFSocketManager.h"
#import "TFIMHeadData.h"
#import "TFIMLoginData.h"
#import "TFStatisticsController.h"
#import "TFStatisticsListController.h"
#import "TFScanCodeController.h"
#import "StyleDIY.h"
#import "TFAddressBookController.h"
#import "TFSelectChatContactsController.h"
#import "TFNewCustomDetailController.h"
#import "HQTFNoContentView.h"
#import "HuiJuHuaQi-Swift.h"
#import "TFAssistantMessageController.h"
#import "TFConversationListCell.h"

@interface HQConversationListController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,HQChatTableViewDelegate,HQTFSearchHeaderDelegate,HQBLDelegate,TFNoNetworkViewDelegate,UIViewControllerPreviewingDelegate,TFSliderCellDelegate>
/** titleView */
@property (nonatomic, strong) UILabel *titleLabel;
/** 未读书 */
@property (nonatomic, assign) NSInteger unreadCount;
/** chatTableView */
@property (nonatomic, strong) HQChatTableView *chatTableView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;

/** 搜索状态 */
@property (nonatomic, assign) BOOL searchStatus;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) NSMutableArray *infoArrs;

/** 隐藏的会话列表聊天id */
@property (nonatomic, strong) NSNumber *deleteChatId;

@property (nonatomic, strong) TFSocketManager *socket;

@property (nonatomic, assign) UITabBarItem * itemBadges;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 无网络提示 */
@property (nonatomic, weak) TFNoNetworkView *noNetworkView;

/** 头视图 */
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) NSInteger doubleIndex;

/** 助手会话列表 */
@property (nonatomic, strong) TFAssistantMessageController *assistantVc;
/** 助手会话消息数据列表 */
@property (nonatomic, strong) NSMutableArray *assistantInfos;
/** 滑动索引 */
@property (nonatomic, assign) NSInteger sliderIndex;

@end

@implementation HQConversationListController

-(NSMutableArray *)assistantInfos{
    if (!_assistantInfos) {
        _assistantInfos = [NSMutableArray array];
    }
    return _assistantInfos;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.chatTableView.height-Long(150))/2-NaviHeight,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"加载中..." loadTip:YES];
    }
    return _noContentView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
        
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:@"企信"  color:BlackTextColor imageName:nil withTarget:nil action:nil];
    
//    UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(rightClicked) image:@"企信-添加" highlightImage:@"企信-添加"];
//    UIBarButtonItem *item3 = [self itemWithTarget:self action:@selector(middleClick) image:@"企信-通讯录" highlightImage:@"企信-通讯录"];
//    self.navigationItem.rightBarButtonItems = @[item2,item3];
    
    TFSocketManager *mana = [TFSocketManager sharedInstance];
    if (mana.isLogin) {
//    if (mana.socketReadyState == SR_OPEN && mana.isLogin) {
        self.headerView.height = 44;
        self.noNetworkView.hidden = YES;
        self.chatTableView.tableHeaderView = self.headerView;
//        [self requestData];
    }else if (mana.socketReadyState == SR_CLOSED || !mana.isLogin){
        [self noNetworkViewClicked];
    }
    
//    if (!self.infoArrs || self.infoArrs.count == 0) {
        [self requestData];
//        // 首次安装出现请求历史数据后显示问题（为什么拉取历史数据刷新列表的通知存在问题，最后一条历史数据发送的通知，可能判断条数问题），10秒后查数据库
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (self.infoArrs.count) {
//                [self handleLastestMessageWithAllDatas:self.infoArrs];
//            }else{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (self.infoArrs.count) {
//                    [self handleLastestMessageWithAllDatas:self.infoArrs];
//                }
//            });
//            }
//        });
//    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.navigationController.childViewControllers.count > 1) {
        return YES;
    }else{
        return NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8) size:(CGSize){SCREEN_WIDTH,0.5}]];
        
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (TFAssistantMessageController *)assistantVc{
    if (!_assistantVc) {
        _assistantVc = [[TFAssistantMessageController alloc] init];
    }
    return _assistantVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoArrs = [DataBaseHandle queryAllChatListData];// 先查一下本地
    self.view.backgroundColor = WhiteColor;
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    [self setupNavigation];
    [self setupChatTable];
    [self setupHeaderSearch];

    [self changeCompanySocketConnect];
//    [DataBaseHandle createChatListWithData];
//    [DataBaseHandle createAssistantListTable];
//    [DataBaseHandle createSubAssistantDataListTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListData:) name:ConversationListRefreshWithNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadData:) name:RefreshChatListWithNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAssistantUnread:) name:AssistantUnreadNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupName:) name:ModifyGroupNameNotification object:nil];
    
    // app 活跃通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 登录或切换公司socket连接通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanySocketConnect) name:ChangeCompanySocketConnect object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamfaceLoginSuccessed) name:TeamFaceSocketLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamfaceLoginFailed) name:SocketStatusNOConnent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAssistant:) name:@"DeleteAssistant" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarItemDoubleClick) name:@"ConversationTabBarItemDoubleClick" object:nil];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self initLocalData];
    
//    [self requestData];
    /** 角标未读数 */
    [self calculateBadgeNumbers];
}

-(void)tabBarItemDoubleClick{
    
    NSMutableArray *arr = [NSMutableArray array];
    BOOL have = NO;
    for (NSInteger i = 0;i < self.infoArrs.count;i ++) {
        TFFMDBModel *model = self.infoArrs[i];
        if (![model.isHide isEqualToNumber:@1]) {
            if (model.unreadMsgCount && ![model.unreadMsgCount isEqualToNumber:@0]) {
                if ([[model.chatType description] isEqualToString:@"3"]) {// 小助手时
                    if (have == NO) {
                        [arr insertObject:[NSIndexPath indexPathForRow:0 inSection:0] atIndex:0];
                        have = YES;
                    }
                }else{
                    [arr addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                }
            }
        }
    }
    
    if (arr.count == 0) {
        self.doubleIndex = 0;
        return;
    }
    
    if (self.doubleIndex >= arr.count) {
        self.doubleIndex = 0;
    }
    
    [self.chatTableView scrollToRowAtIndexPath:arr[self.doubleIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.doubleIndex += 1;
}

/** 删除应用 */
- (void)deleteAssistant:(NSNotification *)note{
    
    NSNumber *assistantId = note.object;
    for (TFFMDBModel *model in self.infoArrs) {
        
        if ([model.chatId isEqualToNumber:assistantId]) {
            [self.infoArrs removeObject:model];
            break;
        }
    }
    [self separateAssistantData];
    [self.chatTableView reloadData];
}

/** 激活 */
- (void)applicationDidBecomeActive{
    
    if ([UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
        HQLog(@"token:%@",UM.userLoginInfo.token);
        
        self.socket = [TFSocketManager sharedInstance];
//        [self.socket socketOpenIsReconnect:NO];//打开soket
        
        [self requestData];
    }
}
/** 登录或切换公司socket连接通知 */
- (void)changeCompanySocketConnect{
    
    if ([UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
        HQLog(@"token:%@",UM.userLoginInfo.token);
        
        self.socket = [TFSocketManager sharedInstance];
        [self.socket socketOpenIsReconnect:NO];//打开soket
        
        [self requestData];
        
    }
}

#pragma mark 初始本地数据
- (void)initLocalData {
    [self refreshUnreadData:nil];
}

- (void)requestData {

    HQMainQueue(^{
        [self.chatBL requestGetChatListInfoData];
    });
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - headerSearch
- (void)setupHeaderSearch{

//    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
//    self.header = header;
//    _chatTableView.tableHeaderView = header;
//    header.backgroundColor = WhiteColor;
//    header.button.backgroundColor = BackGroudColor;
//    header.delegate = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    self.headerView = headerView;
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    header.backgroundColor = WhiteColor;
    header.button.backgroundColor = BackGroudColor;
    header.delegate = self;
    header.y = -20;
    [headerView addSubview:header];
    
    TFNoNetworkView *noNetworkView = [[TFNoNetworkView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,44}];
    [headerView addSubview:noNetworkView];
    self.noNetworkView = noNetworkView;
    noNetworkView.hidden = YES;
    noNetworkView.delegate = self;
    self.chatTableView.tableHeaderView = headerView;
}
#pragma mark -TFNoNetworkViewDelegate
-(void)noNetworkViewClicked{
    
    TFSocketManager *manager = [TFSocketManager sharedInstance];
    [manager socketClose];// 关闭（一切置为起点）
    [manager socketOpenIsReconnect:NO];//打开
}


/** 网络变化 */
- (void)netWorkChange:(NSNotification *)notification{

    NSDictionary *netDic = notification.userInfo;
    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)[netDic[AFNetworkingReachabilityNotificationStatusItem] intValue];

    if (status == AFNetworkReachabilityStatusNotReachable) {//网络不可达
        self.headerView.height = 88;
        self.noNetworkView.hidden = NO;
        self.chatTableView.tableHeaderView = self.headerView;
    }
//    else{
//        self.headerView.height = 44;
//        self.noNetworkView.hidden = YES;
//        self.chatTableView.tableHeaderView = self.headerView;
//    }
}

/** teamface登录成功 */
- (void)teamfaceLoginSuccessed{
    HQMainQueue(^{
        [self requestData];
        self.headerView.height = 44;
        self.noNetworkView.hidden = YES;
        self.chatTableView.tableHeaderView = self.headerView;
    });
}
/** teamface登录失败 */
- (void)teamfaceLoginFailed{
    HQMainQueue(^{
        self.headerView.height = 88;
        self.noNetworkView.hidden = NO;
        self.chatTableView.tableHeaderView = self.headerView;
    });
}

#pragma mark - searchHeader Deleaget
-(void)searchHeaderClicked{

    TFSearchChatRecordController *search = [[TFSearchChatRecordController alloc] init];
    
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 初始化聊天tableView
- (void)setupChatTable {
    _chatTableView = [[HQChatTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-TabBarHeight) style:UITableViewStylePlain];
    [_chatTableView setBackgroundColor:WhiteColor];
    _chatTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _chatTableView.dataSource=self;
    _chatTableView.delegate=self;
    _chatTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_chatTableView];
    
    [_chatTableView registerNib:[UINib nibWithNibName:@"JCHATConversationListCell" bundle:nil] forCellReuseIdentifier:@"JCHATConversationListCell"];
    
    if (self.infoArrs.count == 0) {
        self.chatTableView.backgroundView = self.noContentView;
    }else{
        self.chatTableView.backgroundView = [UIView new];
    }
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        HQLog(@"3D Touch  可用!");
        //给cell注册3DTouch的peek（预览）和pop功能
        [self registerForPreviewingWithDelegate:self sourceView:_chatTableView];
    } else {
        HQLog(@"3D Touch 无效");
    }
}

- (void)saveBadge:(NSInteger)badge {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",badge] forKey:kBADGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"";
    
    UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(rightClicked) image:@"企信-添加" highlightImage:@"企信-添加"];
    
    UIBarButtonItem *item3 = [self itemWithTarget:self action:@selector(middleClick) image:@"扫码灰色" highlightImage:@"扫码灰色"];
    
    self.navigationItem.rightBarButtonItems = @[item2,item3];
    
}

- (void)middleClick{
    
//    TFAddressBookController *controller2 = [[TFAddressBookController alloc] init];
//    [self.navigationController pushViewController:controller2 animated:YES];
    
    [self leftClick];
}

- (void)leftClick{
    
    TFScanCodeController *scan = [[TFScanCodeController alloc] init];
    scan.style = [StyleDIY weixinStyle];
    scan.isOpenInterestRect = YES;
    scan.libraryType = SLT_ZXing;
    scan.scanCodeType = SCT_QRCode;
    //镜头拉远拉近功能
    scan.isVideoZoom = YES;
    scan.isNeedScanImage = YES;
    scan.detailAction = ^(NSDictionary *parameter) {
      
        TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
        detail.bean = [parameter valueForKey:@"bean"];
        detail.dataId = [parameter valueForKey:@"id"];
        //        detail.isSeasAdmin = self.typeModel.is_seas_admin;
        //        detail.seaPoolId = self.seaPoolId;
        [self.navigationController pushViewController:detail animated:YES];
        
        
    };
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:scan];
    
    [self presentViewController:navi animated:YES completion:nil];
    
    
//    Scan_VC * vc=[[Scan_VC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)statistics{
    
    TFStatisticsController *statistics = [[TFStatisticsController alloc] init];
    [self.navigationController pushViewController:statistics animated:YES];
    
}

- (void)statistics11{
    
    TFStatisticsListController *statistics = [[TFStatisticsListController alloc] init];
    [self.navigationController pushViewController:statistics animated:YES];
    
}

- (void)rightClicked{
    
    TFSelectChatContactsController *chatContacts = [[TFSelectChatContactsController alloc] init];
    chatContacts.type = 1;
    chatContacts.isSingleSelect = NO;
    chatContacts.actionParameter = ^(id parameter) {
        
    };
    [self.navigationController pushViewController:chatContacts animated:YES];
    return;

//    PopoverView *pop = [[PopoverView alloc] initWithPoint:CGPointMake(SCREEN_WIDTH-10, 64) titles:@[@"发起聊天",@"扫一扫"] images:@[@"企信-发起群聊",@"扫码白色"]];
//    pop.selectRowAtIndex = ^(NSInteger index) {
//
//        if (index == 0) {
//
//            TFSelectChatContactsController *chatContacts = [[TFSelectChatContactsController alloc] init];
//            chatContacts.type = 1;
//            chatContacts.isSingleSelect = NO;
//            chatContacts.actionParameter = ^(id parameter) {
//
//            };
//            [self.navigationController pushViewController:chatContacts animated:YES];
//
//        }
//        else {
//
//            [self leftClick];
//        }
//    };
//
//    [pop show];
//
    
    
}

#pragma mark 计算角标
- (void)calculateBadgeNumbers {
    
    /** 角标未读数 */
    NSInteger numbers = 0;
    for (TFFMDBModel *fm in self.infoArrs) {
        
        numbers = numbers + [fm.unreadMsgCount integerValue];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numbers];
    
    if (numbers > 99) {
        
        numbers = 99;
    }
    
    if (numbers > 0) {
        
        self.itemBadges = [self.tabBarController.tabBar.items objectAtIndex:1];
        self.itemBadges.badgeValue=[NSString stringWithFormat:@"%ld",(long)numbers];
        
    }else{
        self.itemBadges = [self.tabBarController.tabBar.items objectAtIndex:1];
        self.itemBadges.badgeValue=nil;
    }

}

#pragma mark - chatTableView Delegate and DataSource

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if (indexPath.section == 0) {
//        return NO;
//    }
//
//    TFFMDBModel *model = self.infoArrs[indexPath.row];
//
//    //小助手及公司总群不能滑
//    if ([model.chatType isEqualToNumber:@3]||[model.chatType isEqualToNumber:@10]) {
//
//        return NO;
//    }
//
//    return YES;
//}
//
////修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return @"";
//    }
//    return @"删除";
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        return UITableViewCellEditingStyleNone;
//    }
//
//    return UITableViewCellEditingStyleDelete;
//
//}
////先设置Cell可移动
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.section == 0) {
//        return NO;
//    }
//    return YES;
//}
//
////进入编辑模式，按下出现的编辑按钮后
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    // 删除模型
////    [self.infoArrs removeObjectAtIndex:indexPath.row];
//
//    TFFMDBModel *model = self.infoArrs[indexPath.row];
//
//    self.deleteChatId = model.chatId;
//
//    [self.chatBL requestHideSessionWithData:model.chatId chatType:model.chatType];
//
//}

#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.assistantInfos.count > 0 ? 1 : 0;
    }
    return self.infoArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *cellIdentifier = @"JCHATConversationListCell";
        JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (self.assistantInfos == nil || self.assistantInfos.count <= indexPath.row) {
            return cell;
        }
        [cell refreshChatCellWithDatas:self.assistantInfos];
        return cell;
    }
    
//    static NSString *cellIdentifier = @"JCHATConversationListCell";
//    JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    if (self.infoArrs == nil || self.infoArrs.count <= indexPath.row) {
//        return cell;
//    }
//    TFFMDBModel *dbModel = self.infoArrs[indexPath.row];
//    [cell refreshChatCellWithModel:dbModel];
//
//    return cell;
    
    TFConversationListCell *cell = [TFConversationListCell conversationListCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell hiddenItem];
    if (self.infoArrs == nil || self.infoArrs.count <= indexPath.row) {
        return cell;
    }
    TFFMDBModel *dbModel = self.infoArrs[indexPath.row];
    cell.indexPath = indexPath;
    [cell refreshChatCellWithModel:dbModel];
    
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        
        TFFMDBModel *model  = self.infoArrs[indexPath.row];
        if ([model.chatType isEqualToNumber:@3]) {
            return 0;
        }
    }
    return 64;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        
        for (TFConversationListCell *cell in self.chatTableView.visibleCells) {
            
            if ([cell isKindOfClass:[TFConversationListCell class]] && cell.isSlider) {
                
                [cell hiddenItem];
            }
        }
        kWEAKSELF
        self.assistantVc.assistantInfos = self.assistantInfos;
        _assistantVc.refresh = ^{
            [weakSelf.chatTableView reloadData];
        };
        [self.navigationController pushViewController:self.assistantVc animated:YES];
        return;
    }
    
    
    TFFMDBModel *model  = self.infoArrs[indexPath.row];

    if ([model.chatType isEqualToNumber:@3]) {
        
        TFAssistantListController *assistant = [[TFAssistantListController alloc] init];
        
        assistant.assistantId = model.chatId;
        assistant.applicationId = model.application_id;
        assistant.naviTitle = model.receiverName;
        assistant.type = [model.type integerValue];
        assistant.timeSp = model.clientTimes;
        assistant.showType = model.showType;
        assistant.icon_url = model.icon_url;
        assistant.icon_color = model.icon_color;
        assistant.icon_type = model.icon_type;
        [self.navigationController pushViewController:assistant animated:YES];
    }
    else {
    
        TFChatViewController *chat = [[TFChatViewController alloc] init];
        
        if ([model.chatType isEqualToNumber:@1] || [model.chatType isEqualToNumber:@10]) { //群聊
            
            TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
            
            //群成员字符串分割成数组
            NSArray  *array = [fmdb.groupPeoples componentsSeparatedByString:@","];
            
            chat.naviTitle = [NSString stringWithFormat:@"%@(%ld)",model.receiverName,array.count];
            chat.chatId = model.chatId;
            chat.cmdType = 1;
            chat.draft = fmdb.draft;
            chat.receiveId = [fmdb.receiverID integerValue];
            chat.unreadMsgCount = fmdb.unreadMsgCount;
            
        }
        else { //单聊
            
            TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
            chat.chatId = model.chatId;
            chat.naviTitle = model.receiverName;
            chat.cmdType = [model.chatType integerValue];
            chat.receiveId = [fmdb.receiverID integerValue];
            chat.draft = fmdb.draft;
            chat.unreadMsgCount = fmdb.unreadMsgCount;
        }
        
        
        [self.navigationController pushViewController:chat animated:YES];
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 2) {
        self.shadowLine.hidden = YES;
    }else{
        self.shadowLine.hidden = NO;
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (targetContentOffset->y <= 22) {
        targetContentOffset->y = 0;
    }else if (targetContentOffset->y <= 44) {
        targetContentOffset->y = 44;
    }
}

#pragma mark 读聊天室信息并发送已读未读命令
- (void)sendReadedCommondWithModel:(TFFMDBModel *)dbmodel {
    
    
    if ([dbmodel.chatType isEqualToNumber:@1] || [dbmodel.chatType isEqualToNumber:@10]) { //群聊
        
        HQGlobalQueue((^{
            NSMutableArray *unreadArr = [DataBaseHandle queryRecodeWithChatId:dbmodel.chatId];
            
            if (unreadArr.count>0) {
                
                for (TFFMDBModel *model in unreadArr) {
                    
                    //自己发的不回已读命令
                    if (![model.senderID isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                        
                        if ([model.isRead isEqualToNumber:@0]) {
                            
                            TFIMHeadData *imData = [[TFIMHeadData alloc] init];
                            imData.OneselfIMID = [UM.userLoginInfo.employee.sign_id integerValue];
                            imData.usCmdID = 19;
                            imData.ucVer = 1;
                            imData.ucDeviceType = iOSDevice;
                            imData.senderID = [model.senderID integerValue];
                            imData.receiverID = [model.receiverID integerValue];
                            imData.clientTimes = [model.clientTimes integerValue];
                            imData.RAND = [model.RAND intValue];
                            
                            [self.socket sendData:[imData data]];
                            
                            //读完之后置为已读
                            
                            TFFMDBModel *fmdb = [[TFFMDBModel alloc] init];
                            
                            fmdb.isRead = @1;
                            fmdb.msgId = [NSString stringWithFormat:@"%lld%u",imData.clientTimes,imData.RAND];
                            
                            [DataBaseHandle updateChatRoomReadStateWithData:fmdb];
                        }
                        
                    }
                    
                }
                
                /** 未读数重置为0 */
                TFFMDBModel *model = [[TFFMDBModel alloc] init];
                
                model.chatId = dbmodel.chatId;
                model.unreadMsgCount = @0;
                
                [DataBaseHandle updateChatListUnReadMsgNumberWithData:model];
                
            }
        }));
        
        
    }
    else {
        
        HQGlobalQueue(^{
            
            TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:dbmodel.chatId];
            
            if ([fmdb.unreadMsgCount integerValue] > 0) {
                
                /** 已读未读命令 */
                
                TFIMHeadData *imData = [[TFIMHeadData alloc] init];
                imData.OneselfIMID = [UM.userLoginInfo.employee.sign_id integerValue];
                imData.usCmdID = 18;
                imData.ucVer = 1;
                imData.ucDeviceType = iOSDevice;
                imData.senderID = [fmdb.receiverID integerValue];
                imData.receiverID = [fmdb.senderID integerValue];
                imData.clientTimes = [fmdb.clientTimes integerValue];
                imData.RAND = [fmdb.RAND intValue];
                
                [self.socket sendData:[imData data]];
                
                /** 未读数重置为0 */
                TFFMDBModel *model = [[TFFMDBModel alloc] init];
                
                model.chatId = dbmodel.chatId;
                model.unreadMsgCount = @0;
                
                [DataBaseHandle updateChatListUnReadMsgNumberWithData:model];
                
                HQMainQueue(^{
                    
                    dbmodel.unreadMsgCount = @0;
                    
                });
            }
        });
    }
    
}


#pragma mark - TFSliderCellDelegate
-(void)sliderCellDidClickedIndex:(NSInteger)index{
    
    HQLog(@"点击了%ldItem",index);
    TFFMDBModel *model  = self.infoArrs[self.sliderIndex];
    if ([model.unreadMsgCount integerValue] > 0 && index == 0) {// 标为已读
        
        model.unreadMsgCount = @0;
        [self.chatTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.sliderIndex inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
        for (TFConversationListCell *cell in self.chatTableView.visibleCells) {
            
            if ([cell isKindOfClass:[TFConversationListCell class]] && cell.isSlider) {
                
                [cell hiddenItem];
            }
        }
        
        [self sendReadedCommondWithModel:model];
        
        
    }else if (index == 0) {// 删除
    
        for (TFConversationListCell *cell in self.chatTableView.visibleCells) {
            
            if ([cell isKindOfClass:[TFConversationListCell class]] && cell.isSlider) {
                
                [cell hiddenItem];
            }
        }
        self.deleteChatId = model.chatId;
    
        [self.chatBL requestHideSessionWithData:model.chatId chatType:model.chatType];
        
    }
    
}

-(void)sliderCellSelectedIndexPath:(NSIndexPath *)indexPath{
    
    for (TFConversationListCell *cell in self.chatTableView.visibleCells) {
        
        if ([cell isKindOfClass:[TFConversationListCell class]] && cell.isSlider) {
            
            [cell hiddenItem];
        }
    }
    
    TFFMDBModel *model  = self.infoArrs[indexPath.row];
    
    if ([model.chatType isEqualToNumber:@3]) {
        
        TFAssistantListController *assistant = [[TFAssistantListController alloc] init];
        
        assistant.assistantId = model.chatId;
        assistant.applicationId = model.application_id;
        assistant.naviTitle = model.receiverName;
        assistant.type = [model.type integerValue];
        assistant.timeSp = model.clientTimes;
        assistant.showType = model.showType;
        assistant.icon_url = model.icon_url;
        assistant.icon_color = model.icon_color;
        assistant.icon_type = model.icon_type;
        [self.navigationController pushViewController:assistant animated:YES];
    }
    else {
        
        TFChatViewController *chat = [[TFChatViewController alloc] init];
        
        if ([model.chatType isEqualToNumber:@1] || [model.chatType isEqualToNumber:@10]) { //群聊
            
            TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
            
            //群成员字符串分割成数组
            NSArray  *array = [fmdb.groupPeoples componentsSeparatedByString:@","];
            
            chat.naviTitle = [NSString stringWithFormat:@"%@(%ld)",model.receiverName,array.count];
            chat.chatId = model.chatId;
            chat.cmdType = 1;
            chat.draft = fmdb.draft;
            chat.receiveId = [fmdb.receiverID integerValue];
            chat.unreadMsgCount = fmdb.unreadMsgCount;
            
        }
        else { //单聊
            
            TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
            chat.chatId = model.chatId;
            chat.naviTitle = model.receiverName;
            chat.cmdType = [model.chatType integerValue];
            chat.receiveId = [fmdb.receiverID integerValue];
            chat.draft = fmdb.draft;
            chat.unreadMsgCount = fmdb.unreadMsgCount;
        }
        
        
        [self.navigationController pushViewController:chat animated:YES];
    }
    
    
}

-(void)sliderCellWillScrollIndexPath:(NSIndexPath *)indexPath{
    
    self.sliderIndex = indexPath.row;
    HQLog(@"滑动了%ldIndexPath",indexPath.row);
    for (TFConversationListCell *cell in self.chatTableView.visibleCells) {
        
        NSIndexPath *index = [self.chatTableView indexPathForCell:cell];
        
        if (!(indexPath.section == index.section && indexPath.row == index.row) && [cell isKindOfClass:[TFConversationListCell class]]) {
            
            [cell hiddenItem];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    for (TFConversationListCell *cell in self.chatTableView.visibleCells) {
        
        if ([cell isKindOfClass:[TFConversationListCell class]] && cell.isSlider) {
            
            [cell hiddenItem];
        }
    }
    
}

#pragma mark 通知方法
- (void)refreshListData:(NSNotification *)note {
    
//    TFFMDBModel *model = note.object;
//
//    if (model && [[model.mark description] isEqualToString:@"3"]) {// 增加会话
//        [self.infoArrs addObject:model];
//    }
//    if (model && [[model.mark description] isEqualToString:@"4"]) {// 改变内容
//        for (TFFMDBModel *dd in self.infoArrs) {
//            if ([[dd.chatId description] isEqualToString:[model.chatId description]]) {
//                dd.content = model.content;
//                dd.clientTimes = model.clientTimes;
//                dd.showTime = model.showTime;
//                dd.chatType = model.chatType;
//                dd.chatFileType = model.chatFileType;
//                dd.unreadMsgCount = model.unreadMsgCount;
//                break;
//            }
//        }
//    }
//
//    if (model && [[model.mark description] isEqualToString:@"5"]) {// 删除应用
//        for (TFFMDBModel *dd in self.infoArrs) {
//            if ([[dd.assistantId description] isEqualToString:[model.assistantId description]]) {
//                [self.infoArrs removeObject:dd];
//                break;
//            }
//        }
//    }
//
//    if (model && [[model.mark description] isEqualToString:@"6"]) {// 小助手推送
//        BOOL have = NO;
//        for (TFFMDBModel *fb in self.infoArrs) {
//            if ([[fb.assistantId description] isEqualToString:[model.assistantId description]]) {// 有的话，更新内容和时间
//                have = YES;
//                fb.content = model.content;
//                fb.clientTimes = model.clientTimes;
//                break;
//            }
//        }
//        if (!have) {
//            [self.infoArrs addObject:model];
//        }
//    }
//
//    [self separateAssistantData];
//    [self.chatTableView reloadData];
//
//    if (self.infoArrs.count == 0) {
//        self.chatTableView.backgroundView = self.noContentView;
//    }else{
//        self.chatTableView.backgroundView = [UIView new];
//    }
//    /** 角标未读数 */
//    [self calculateBadgeNumbers];
//
//
//    if (self.infoArrs.count != 0) { //会话列表不为空
//
//        BOOL find = NO;
//        for (TFFMDBModel *dbModel in self.infoArrs) {
//
//            if ([model.chatId isEqualToNumber:dbModel.chatId]) {
//
//                find = YES;
//                break;
//            }
//        }
//
//        if (!find) { //列表没有该会话
//
//            [DataBaseHandle addChatListWithData:model];
//
//            [self requestData];
//        }
//
//    }
//    else { //一开始没有会话
//
//        //收发消息之后查询本地所有会话
//        [DataBaseHandle addChatListWithData:model];
//
//        [self requestData];
//
//    }

    
    
    TFFMDBModel *model = note.object;
    
    HQGlobalQueue(^{

        //拉取本地数据库数据
        NSMutableArray *allDatas = [DataBaseHandle queryAllChatListData];

        HQMainQueue(^{
            self.infoArrs = allDatas;
            [self separateAssistantData];
            [self.chatTableView reloadData];

            if (self.infoArrs.count == 0) {
                self.chatTableView.backgroundView = self.noContentView;
            }else{
                self.chatTableView.backgroundView = [UIView new];
            }
            /** 角标未读数 */
            [self calculateBadgeNumbers];

        });

        if (self.infoArrs.count != 0) { //会话列表不为空

            BOOL find = NO;
            for (TFFMDBModel *dbModel in self.infoArrs) {

                if ([model.chatId isEqualToNumber:dbModel.chatId]) {

                    find = YES;
                    break;
                }
            }

            if (!find) { //列表没有该会话

                if (model) {
                    [DataBaseHandle addChatListWithData:model];
                    
                    [self requestData];
                }
            }

        }
        else { //一开始没有会话

            //收发消息之后查询本地所有会话
            if (model) {
                [DataBaseHandle addChatListWithData:model];
                
                [self requestData];
            }

        }

    });
    
}

//刷新列表数据和未读数
- (void)refreshUnreadData:(NSNotification *)note {

//    if (note.object) {
//
//        TFFMDBModel *model = note.object;
//        for (TFFMDBModel *dd in self.infoArrs) {
//            if (model.msgId && [dd.msgId isEqualToString:model.msgId]) {
//                dd.content = model.content;
//                dd.chatType = model.chatType;
//                dd.chatFileType = model.chatFileType;
//                break;
//            }
//            if ([[dd.chatId description] isEqualToString:[model.chatId description]]) {
//                if (model.isTop) {
//                    dd.isTop = model.isTop;
//                }
//                if (model.draft) {
//                    dd.draft = model.draft;
//                }
//                if (model.unreadMsgCount) {
//                    dd.unreadMsgCount = model.unreadMsgCount;
//                }
//                if ([[model.mark description] isEqualToString:@"1"]) {// 群解散
//                    [self.infoArrs removeObject:dd];
//                }
//                if ([[model.mark description] isEqualToString:@"2"]) {// 退群
//                    [self.infoArrs removeObject:dd];
//                }
//                if (model.groupPeoples) {
//                    dd.groupPeoples = model.groupPeoples;
//                }
//                break;
//            }
//        }
//        [self.chatTableView reloadData];
//    }
    
    
    HQGlobalQueue(^{
        NSMutableArray *allDatas = [DataBaseHandle queryAllChatListData];

        HQMainQueue(^{

            self.infoArrs = allDatas;
            [self separateAssistantData];
            [self calculateBadgeNumbers];
            [self.chatTableView reloadData];

            if (self.infoArrs.count == 0) {
                self.chatTableView.backgroundView = self.noContentView;
            }else{
                self.chatTableView.backgroundView = [UIView new];
            }
        });
    });
    
}

- (void)updateAssistantUnread:(NSNotification *)note {

    [self refreshUnreadData:note];
}

- (void)updateGroupName:(NSNotification *)note {

    [self requestData];
    
}

/** 处理最新一条消息 */
-(void)handleLastestMessageWithAllDatas:(NSArray *)allDatas{
    
    HQGlobalQueue(^{
        //chatType聊天类型 1群聊:2:单聊
        for (TFFMDBModel *mm in allDatas) {
            if (([mm.chatType integerValue] == 1 || [mm.chatType integerValue] == 2 || [mm.chatType integerValue] == 10) && (IsStrEmpty(mm.content) || [mm.content isEqualToString:@"[无消息]"])) {
                // 去查最新一条记录
                TFFMDBModel *record = [DataBaseHandle queryRecodeLastTime:mm.chatId];
                if (record.chatId == nil) {// 没找到记录，说明本地没有数据，拉取一条历史数据
                    
                    if ([mm.chatType integerValue] == 1 || [mm.chatType integerValue] == 10) { //群历史消息
                        [self.socket getHistoryRecordData:@2 chatId:mm.chatId timeSp:0 Count:1];
                    }
                    else { //私聊历史消息
                        
                        [self.socket getHistoryRecordData:@1 chatId:mm.receiverID timeSp:0 Count:1];
                    }
                    mm.content = @"[无消息]";
                }else{
                    /** 查到的放入会话列表（按理不会出现聊天室有数据，而列表没记录的情况） */
                    //                            [DataBaseHandle updateChatListWithData:record];
                    /** chatFileType消息类型 1文本,2图片,3语音,4文件,5小视频,6位置,7提醒 */
                    if ([record.chatFileType integerValue] == 1) {
                        mm.content = record.content;
                    }else if ([record.chatFileType integerValue] == 2){
                        mm.content = @"[图片]";
                    }else if ([record.chatFileType integerValue] == 3){
                        mm.content = @"[语音]";
                    }else if ([record.chatFileType integerValue] == 4){
                        mm.content = @"[文件]";
                    }else if ([record.chatFileType integerValue] == 5){
                        mm.content = @"[视频]";
                    }else if ([record.chatFileType integerValue] == 6){
                        mm.content = @"[位置]";
                    }else if ([record.chatFileType integerValue] == 7){
                        mm.content = record.content?:@"[无消息]";
                    }
                    mm.clientTimes = record.clientTimes;
                    [DataBaseHandle updateChatListWithData:mm];// 将最后一条消息存到会话列表
                }
            }
        }
        HQMainQueue(^{
            [self.chatTableView reloadData];
        });
    });
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getChatListInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        HQGlobalQueue(^{
        
            NSMutableArray *datas = resp.body;
            
            for (TFChatInfoListModel *model in datas) {
                
                TFFMDBModel *dbModel = [[TFFMDBModel alloc] init];
                dbModel = [model chatListModel];
                
                dbModel.companyId = UM.userLoginInfo.company.id;
                
                if ([model.chat_type isEqualToNumber:@3]) { //小助手
                    
                    //插入小助手数据库
                    
                    NSMutableArray *assistants = [DataBaseHandle queryAllAssistantListData];
                    
                    BOOL have = NO;
                    for (TFFMDBModel *fmdb in assistants) {
                        
                        //如果小助手存在
                        if ([dbModel.chatId isEqualToNumber:fmdb.chatId]) {
                            
                            have = YES;
                            break;
                            
                        }
                    }
                    
                    if (!have) { // 没有该小助手
                        
                        [DataBaseHandle insertDataIntoAssistantTable:dbModel];
                        
                    }
                    else { // 列表有该小助手
                        
                        // 更新小助手内容及未读数
                        [DataBaseHandle updateAssistantListDataWithModel:dbModel];
                    }
                    
                    
                }
                else { //单聊群聊
                    
                    if ([model.type isEqualToString:@"0"]) { //总群
                        
                        NSMutableArray *arr = [DataBaseHandle queryAllChatListExceptAssistant];
                        
                        dbModel.chatType = @10;
                        
                        BOOL have = NO;
                        for (TFFMDBModel *fm in arr) {
                            
                            if ([fm.chatId isEqualToNumber:dbModel.chatId]) {
                                
                                have = YES;
                                
                                //更新会话的头像及名字
                                [DataBaseHandle updateChatPictureAndReceiverNameWithData:dbModel];
                                
                                //更新群成员名称
                                [DataBaseHandle updateChatListGroupPeoplesWithData:dbModel];
                                
                                break;
                            }
                        }
                        if (!have) {
                            
                            dbModel.isHide = @0; //防止后台返回isHide=1
                            [DataBaseHandle addChatListWithData:dbModel];
                        }
                        
                    }
                    else {
                        
                        NSArray *arr = [DataBaseHandle queryAllChatListExceptAssistant];
                        
                        BOOL exit = NO;
                        for (TFFMDBModel *fm in arr) {
                            
                            if ([fm.chatId isEqualToNumber:dbModel.chatId]) {
                                
                                exit = YES;
                                break;
                            }
                        }
                        
                        if (!exit) {
                            
                            [DataBaseHandle addChatListWithData:dbModel];
                        }
                        else {
                            
                            //更新会话的头像及名字
                            [DataBaseHandle updateChatPictureAndReceiverNameWithData:dbModel];
                            
                            //更新群成员名称
                            [DataBaseHandle updateChatListGroupPeoplesWithData:dbModel];
                        }
                    }
                }
                
            }
            
            
//            NSMutableArray *allDatas = [DataBaseHandle queryAllChatListData];
            // 第一次安装初始化该页面的时候数据库是没有数据的，上面请求后才插入所以要重新查询一次
            NSMutableArray *allDatas = nil;
//            if (self.infoArrs.count == 0) {
                allDatas = [DataBaseHandle queryAllChatListData];
//            }else{
//                allDatas = self.infoArrs;
//            }
            [self handleLastestMessageWithAllDatas:allDatas];
            self.infoArrs = allDatas;
            [self separateAssistantData];
          
            HQMainQueue(^{
        
                [self.chatTableView reloadData];
                
                /** 角标未读数 */
                [self calculateBadgeNumbers];
                
                if (self.infoArrs.count == 0) {
                    self.chatTableView.backgroundView = self.noContentView;
                }else{
                    self.chatTableView.backgroundView = [UIView new];
                }
            });
        });

    }
    
    if (resp.cmdId == HQCMD_hideSession) {
        
        HQGlobalQueue(^{
            
            TFFMDBModel *model = [[TFFMDBModel alloc] init];
            
            model.isHide = @1;
            model.chatId = self.deleteChatId;
            
            [DataBaseHandle updateChatListIshideWithData:model];
            
            // 此处逻辑更改，不查数据库，直接从列表里删
            for (TFFMDBModel *de in self.infoArrs) {
                if ([[de.chatId description] isEqualToString:[self.deleteChatId description]]) {
                    [self.infoArrs removeObject:de];
                    break;
                }
            }
//            NSMutableArray *allDatas = [DataBaseHandle queryAllChatListData];
            
            HQMainQueue(^{
//                self.infoArrs = allDatas;
                [self separateAssistantData];
                [self.chatTableView reloadData];
                
                if (self.infoArrs.count == 0) {
                    self.chatTableView.backgroundView = self.noContentView;
                }else{
                    self.chatTableView.backgroundView = [UIView new];
                }
                
            });
            
        });
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.noContentView setupImageViewRect:(CGRect){30,(self.chatTableView.height-Long(150))/2-NaviHeight,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据" loadTip:NO];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


#pragma mark - 分离小助手的数据
-(void)separateAssistantData{
    
    // 对数据源再进行一次排序（未读的消息放在前面（置顶与非置顶都是如此））
    NSMutableArray *unreadTops = [NSMutableArray array];// 置顶中的未读
    NSMutableArray *readTops = [NSMutableArray array];// 置顶中的已读
    NSMutableArray *unreadNormals = [NSMutableArray array];// 非置顶的未读
    NSMutableArray *readNormals = [NSMutableArray array];// 非置顶的已读
    for (TFFMDBModel *model in self.infoArrs) {
        if ([model.isTop isEqualToNumber:@1]) {
            if ([model.unreadMsgCount integerValue] > 0) {
                [unreadTops addObject:model];
            }else{
                [readTops addObject:model];
            }
        }else{
            if ([model.unreadMsgCount integerValue] > 0) {
                [unreadNormals addObject:model];
            }else{
                [readNormals addObject:model];
            }
        }
    }
    [unreadTops addObjectsFromArray:readTops];
    [unreadTops addObjectsFromArray:unreadNormals];
    [unreadTops addObjectsFromArray:readNormals];
    self.infoArrs = unreadTops;
    
    // 取出小助手
    [self.assistantInfos removeAllObjects];
    
    for (TFFMDBModel *model in self.infoArrs) {
        if ([[model.chatType description] isEqualToString:@"3"]) {// 小助手类型
            [self.assistantInfos addObject:model];
        }
    }
    HQMainQueue(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AssistantConversationData" object:self.assistantInfos];
    });
}


#pragma mark - UIViewControllerPreviewingDelegate
//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
//    获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
//    NSIndexPath *indexPath = [self.chatTableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    NSIndexPath *indexPath = [self.chatTableView indexPathForRowAtPoint:location];
    
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = [self.chatTableView rectForRowAtIndexPath:indexPath];
    previewingContext.sourceRect = rect;
    
    //设定预览的界面
    if (indexPath.section == 0) {
        
        self.assistantVc.assistantInfos = self.assistantInfos;
        self.assistantVc.preferredContentSize = CGSizeMake(0.0f,500.0f);
        return self.assistantVc;
    }
    
    
    TFFMDBModel *model  = self.infoArrs[indexPath.row];
    
    if ([model.chatType isEqualToNumber:@3]) {
        
        TFAssistantListController *assistant = [[TFAssistantListController alloc] init];
        
        assistant.assistantId = model.chatId;
        assistant.applicationId = model.application_id;
        assistant.naviTitle = model.receiverName;
        assistant.type = [model.type integerValue];
        assistant.timeSp = model.clientTimes;
        assistant.showType = model.showType;
        
        assistant.icon_url = model.icon_url;
        assistant.icon_color = model.icon_color;
        assistant.icon_type = model.icon_type;
        assistant.preferredContentSize = CGSizeMake(0.0f,500.0f);
        return assistant;
    }
    else {
        
        TFChatViewController *chat = [[TFChatViewController alloc] init];
        
        if ([model.chatType isEqualToNumber:@1] || [model.chatType isEqualToNumber:@10]) { //群聊
            
            TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
            
            //群成员字符串分割成数组
            NSArray  *array = [fmdb.groupPeoples componentsSeparatedByString:@","];
            chat.dbModel = fmdb;
            chat.naviTitle = [NSString stringWithFormat:@"%@(%ld)",model.receiverName,array.count];
            chat.chatId = model.chatId;
            chat.cmdType = 1;
            chat.draft = fmdb.draft;
            chat.receiveId = [fmdb.receiverID integerValue];
            chat.unreadMsgCount = fmdb.unreadMsgCount;
            
        }
        else { //单聊
            
            TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
            chat.dbModel = fmdb;
            chat.chatId = model.chatId;
            chat.naviTitle = model.receiverName;
            chat.cmdType = [model.chatType integerValue];
            chat.receiveId = [fmdb.receiverID integerValue];
            chat.draft = fmdb.draft;
            chat.unreadMsgCount = fmdb.unreadMsgCount;
        }
        
        chat.preferredContentSize = CGSizeMake(0.0f,500.0f);
        return chat;
    }
    
    
}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}



@end
