//
//  ViewController.m
//  ChatTest
//
//  Created by Season on 2017/5/15.
//  Copyright © 2017年 Season. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "UIView+EXT.h"
#import "TFChatViewController.h"
#import "DataBaseHandle.h"
#import "TFContactorInfoController.h"
#import "TFSocketManager.h"
#import "TFIMHeadData.h"
#import "TFIMLoginData.h"
#import "TFIMContentData.h"
#import "PubMethods.h"
#import "TFFMDBModel.h"
#import "IQKeyboardManager.h"
#import "KSPhotoBrowser.h"

#import "TFChatBL.h"
#import "TFChatMsgModel.h"
#import "TFSingleChatSetController.h"
#import "TFGroupChatSetController.h"
#import "TFSelectChatPersonController.h"
#import "TFChatInfoListModel.h"
#import "LiuqsEmoticonKeyBoard.h"
#import "ZYQAssetPickerController.h"
#import "TFGroupPeopleController.h"
#import "TFGroupEmployeeModel.h"
#import "TFPersonalMaterialController.h"
#import "TFFileDetailController.h"

#import "TFNoticeReadMainController.h"
#import "HQEmployModel.h"
#import "TFFileModel.h"
#import "FileManager.h"
#import "TFChatTipCell.h"
#import "TFGroupATPeopleController.h"

#import "TFRefresh.h"
#import "TFFileMenuController.h"
#import "AlertView.h"
#import "HuiJuHuaQi-Swift.h"

// 视频URL路径
#define KVideoUrlPath

#define TOOLBAR_HEIGHT 40
#define NAVIBAR_HEIGHT 64
@interface TFChatViewController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,MessageCellDelegate,LiuqsEmotionKeyBoardDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,TFNoReadTipViewDelegate>


@property (nonatomic, strong) TFSocketManager *socket;

@property (nonatomic, strong) TFIMHeadData *head;

@property (nonatomic, strong) TFChatBL *chatBL;

/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imgArr;

/** 消息类型 1:文字 2:图片 3:语音 4:文件 5:视频 6:位置 7:提示 */
@property (nonatomic, strong) NSNumber *msgType;

@property(nonatomic, strong) LiuqsEmoticonKeyBoard *keyboard;

@property (nonatomic, assign) NSInteger isread;
/** @的人员数组 */
@property (nonatomic, strong) NSMutableArray *atArr;

@property (nonatomic, copy) NSString *atName;

@property (nonatomic, strong) NSNumber *voiceTime;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) NSInteger count;

/** 返回的时候输入框内容 */
@property (nonatomic, copy) NSString *draftText;

//区分发的是图片还是视频
@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, copy) NSString *replaceStr;
//@人连跳两次
@property (nonatomic, assign) BOOL isOnce;

@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, strong) TFFMDBModel *reSendModel;
//是否是历史消息
@property (nonatomic, assign) BOOL isHistory;


@property (nonatomic, strong) TFNoReadTipView *noReadTipView;

@end

@implementation TFChatViewController

-(TFNoReadTipView *)noReadTipView{
    if (!_noReadTipView) {
        _noReadTipView = [[TFNoReadTipView alloc] init];
        _noReadTipView.origin = CGPointMake(SCREEN_WIDTH-120, 15);
        _noReadTipView.delegate = self;
    }
    return _noReadTipView;
}
#pragma TFNoReadTipViewDelegate
-(void)noReadTipViewClicked{
    
    if (self.chatRecords.count > [self.unreadMsgCount integerValue]) {
        
//        [_messagesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatRecords.count-[self.unreadMsgCount integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
        CGRect rect = [_messagesTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:_chatRecords.count-[self.unreadMsgCount integerValue] inSection:0]];
        HQLog(@"rect:%@",NSStringFromCGRect(rect));
        [_messagesTable setContentOffset:CGPointMake(0, rect.origin.y-NaviHeight) animated:YES];
    }
}
-(NSMutableArray *)imgArr{
    if (!_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}
- (NSMutableArray *)atArr {

    if (!_atArr) {
        
        _atArr = [NSMutableArray array];
    }
    return _atArr;
}


#pragma mark 控制器生命周期
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.isOnce = NO;
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returenToQX) image:@"返回灰色" text:@"企信" textColor:GreenColor];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    
    if ([self.unreadMsgCount integerValue] >= 10) {
        [self.noReadTipView setNumberWithNum:[self.unreadMsgCount integerValue]];
        [self.view addSubview:self.noReadTipView];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self setupKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (_player.isPlaying) { //语音没播放完的时候返回
        
        [_player stop];
    }
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    self.isread = 0;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self saveDraftToDB];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self registerNotification];
    [self setNavi];
    
    [self setupTableview];
    [self sendReadedCommond];
    
    [self otherFromAction];
    
    [self getDBData];
    
}

#pragma mark /** 初始化数据 */
- (void)initData {
    
    self.isread = 1;
    self.enablePanGesture = YES;
    self.socket = [TFSocketManager sharedInstance];
    _count = 0;
    _chatRecords = [NSMutableArray array];
    _images = [NSMutableArray array];
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    self.pageNum = 1;
    self.pageSize = 20;
}

- (void)setNavi {
    
    self.title = self.naviTitle;
    if (self.cmdType == 2) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(personSetClicked) image:@"个人资料" highlightImage:@"个人资料"];
    }
    else if (self.cmdType == 1) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(groupSetClicked) image:@"群资料" highlightImage:@"群资料"];
    }
    
}

#pragma mark /** 注册通知 */
- (void)registerNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:SocketDidReceiveMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketStatusNOConnent:) name:SocketStatusNOConnent object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshChatRoom:) name:RefreshChatRoomDataWithNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleChatDataIsRead:) name:SingleChatReadNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupChatDataIsRead:) name:GroupChatReadNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleChatSendSuccess:) name:SingleChatSendSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupChatSendSuccess:) name:GroupChatSendSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revocationChat:) name:RevocationChatNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendFailed:) name:@"sendFailedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketReConnecting:) name:@"reConnectingNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketReConnectSuccess:) name:@"reconnectSuccessNotification" object:nil];
    
    //解散群通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitView:) name:ReleaseGroupNotification object:nil];
    
    // app 活跃通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 登录或切换公司socket连接通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanySocketConnect) name:ChangeCompanySocketConnect object:nil];
}

#pragma mark 获取数据库数据
- (void)getDBData {
    
//    HQGlobalQueue(^{
    
        // 从数据库拉取本地缓存
//        _chatRecords = [DataBaseHandle queryRecodeWithChatId:self.chatId];
        _chatRecords = [DataBaseHandle queryChatRoomRecordPageWithChatId:self.chatId pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
        [self showTimeHandle];
        HQMainQueue(^{
    
            [self.messagesTable reloadData];
            [self scrollToBottom];
        });
    
        if (_chatRecords.count == 0) { //没有数据，先触发拉取历史记录
            
            if (self.cmdType == 1) { //群历史消息
                
                [self.socket getHistoryRecordData:@2 chatId:self.chatId timeSp:0 Count:20];
            }
            else { //私聊历史消息
                
                [self.socket getHistoryRecordData:@1 chatId:@(self.receiveId) timeSp:0 Count:20];
            }
            self.isHistory = YES;
            
        }else if (_chatRecords.count < self.pageSize){// 少于一页
            
            TFFMDBModel *fmdb = _chatRecords[0];
            
            if (self.cmdType == 1) { //群历史消息
                
                [self.socket getHistoryRecordData:@2 chatId:self.chatId timeSp:fmdb.clientTimes Count:self.pageSize];
            }
            else { //私聊历史消息
                
                [self.socket getHistoryRecordData:@1 chatId:@(self.receiveId) timeSp:fmdb.clientTimes Count:self.pageSize];
            }
            self.isHistory = YES;
        }
        
        
//    });
    
}


#pragma mark 外部进入
- (void)otherFromAction {
    
    //创建群之后在群里发送提示消息
    if (self.isCreateGroup == 1) {
        
        [self sendGroupTip];
    }
    if (self.isSendFromFileLib) { //来自文件库
        
        [self sendFileToChat];
    }
    if (self.isTransitive) { //来自转发
        
        if ([self.dbModel.chatFileType isEqualToNumber:@1]) { //转发文本
            
            [self.socket sendMsgData:self.cmdType receiverId:@(self.receiveId) chatId:self.chatId text:self.dbModel.content msgType:self.dbModel.chatFileType datas:@[] atList:self.atArr voiceTime:self.dbModel.voiceDuration];
        }
        else {
            
            NSMutableArray *imgArr = [NSMutableArray array];
            TFFileModel *fileModel = [[TFFileModel alloc] init];
            
            if ([self.dbModel.chatFileType isEqualToNumber:@5]) {
                
                fileModel.file_url = self.dbModel.videoUrl;
                fileModel.video_thumbnail_url = self.dbModel.fileUrl;
            }
            else {
                
                fileModel.file_url = self.dbModel.content;
            }
            
            fileModel.file_type = self.dbModel.fileSuffix;
            fileModel.file_name = self.dbModel.fileName;
            fileModel.file_size = self.dbModel.fileSize;
            //            fileModel.fileId = fileModel.id;
            
            
            [imgArr addObject:fileModel];
            
            
            
            [self.socket sendMsgData:self.cmdType receiverId:@(self.receiveId) chatId:self.chatId text:nil msgType:self.dbModel.chatFileType datas:imgArr atList:@[] voiceTime:self.voiceTime];
        }
        
    }
}

/** 群操作提示 */
- (void)sendGroupTip {

    [self.socket sendMsgData:self.cmdType receiverId:self.chatId chatId:self.chatId text:self.tipContent msgType:@7 datas:@[] atList:self.atArr voiceTime:self.voiceTime];
}

/** 其他模块文件直接发送到聊天 */
- (void)sendFileToChat {

    NSMutableArray *imgArr = [NSMutableArray array];
    
    if (self.fileModel) {
        
        [imgArr addObject:self.fileModel];
        [self.socket sendMsgData:self.cmdType receiverId:@(self.receiveId) chatId:self.chatId text:nil msgType:@4 datas:imgArr atList:@[] voiceTime:nil];
    }

}

#pragma mark /** 激活、登录或切换公司socket连接通知 */
- (void)applicationDidBecomeActive{
    
    if ([UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
        HQLog(@"%@",UM.userLoginInfo.token);
        
        self.socket = [TFSocketManager sharedInstance];
//        [self.socket socketOpenIsReconnect:NO];//打开soket
        
    }
}

- (void)changeCompanySocketConnect{
    
    if ([UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
        HQLog(@"%@",UM.userLoginInfo.token);
        
        self.socket = [TFSocketManager sharedInstance];
        [self.socket socketOpenIsReconnect:NO];//打开soket
        
    }
}

#pragma mark 读聊天室信息并发送已读未读命令
- (void)sendReadedCommond {

    if (self.cmdType == 2) {

        HQGlobalQueue(^{
            
            TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:self.chatId];
            
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
                
                model.chatId = self.chatId;
                model.unreadMsgCount = @0;
                
                [DataBaseHandle updateChatListUnReadMsgNumberWithData:model];
                
                HQMainQueue(^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:model];
                    
                });
            }
        });

    }
    else {

        HQGlobalQueue((^{
            NSMutableArray *unreadArr = [DataBaseHandle queryRecodeWithChatId:self.chatId];
            
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
                
                model.chatId = self.chatId;
                model.unreadMsgCount = @0;
                
                [DataBaseHandle updateChatListUnReadMsgNumberWithData:model];
                
                HQMainQueue(^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:model];
                    
                });
            }
        }));

    }

}

#pragma mark 收到聊天消息
//接收服务器返回信息
- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    TFFMDBModel *model = note.object;
    
    if (!model) {
        
        return;
    }

    if (self.isread == 1) {
        
        [self sendReadedCommond];
    }
    
    if (model.chatId == nil) {
        return;
    }

    // 添加本条数据至数组
    if ([[model.chatId description] isEqualToString:[self.chatId description]]) {

        [_chatRecords addObject:model];
        [self showTimeHandle];
        
        // 刷新列表，滚动至底部
//        NSMutableArray *indexPaths = [NSMutableArray array];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_chatRecords.count-1 inSection:0];
//        [indexPaths addObject:indexPath];
//        [_messagesTable beginUpdates];
//        [_messagesTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//        [_messagesTable endUpdates];
        [_messagesTable reloadData];
        [self scrollToBottom];
    }
    
}

- (void)socketStatusNOConnent:(NSNotification *)note {

//    NSString * message = note.object;
//
//    TFIMContentData *content = [TFIMContentData recieveContentDataWithData:message];
    self.title = @"未连接";
    
}



- (void)socketReConnecting:(NSNotification *)note {
    
    self.title = @"连接中...";
}

- (void)socketReConnectSuccess:(NSNotification *)note {
    
    self.title = self.naviTitle;
}



#pragma mark 通知方法
- (void)RefreshChatRoom:(NSNotification *)note {
    
    TFFMDBModel *model = note.object;
    if (model) {// 收到历史消息最后一条
        
        self.isHistory = YES;
        _messagesTable.hidden = NO;
        
        if (self.pageNum == 1) {
            
            HQGlobalQueue(^{
                
                // 从数据库拉取本地缓存
                //        _chatRecords = [DataBaseHandle queryRecodeWithChatId:self.chatId];
                _chatRecords = [DataBaseHandle queryChatRoomRecordPageWithChatId:self.chatId pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
                
                [self showTimeHandle];
                HQMainQueue(^{
                    
                    [_messagesTable.mj_header endRefreshing];
                    [self.messagesTable reloadData];
                    if ([self.unreadMsgCount integerValue] > 0) {
                        [self scrollToBottom];
                    }
                });
                
            });
        }else{
            
            HQGlobalQueue(^{
            
                // 从数据库拉取本地缓存
                //        _chatRecords = [DataBaseHandle queryRecodeWithChatId:self.chatId];
                NSMutableArray *arr = [DataBaseHandle queryChatRoomRecordPageWithChatId:self.chatId pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
                
//                [arr addObjectsFromArray:_chatRecords];
//
//                _chatRecords = arr;
                _chatRecords = [self pageLoadAlterRepeat:arr];
                
                [self showTimeHandle];
                HQMainQueue(^{
                    
                    [self.messagesTable reloadData];
                    [_messagesTable.mj_header endRefreshing];
                    if ([self.unreadMsgCount integerValue] > 0) {
                        [self scrollToBottom];
                    }
                });
                
            });
            
        }
        
    }
    else{// 没有历史消息了
        
        [_messagesTable.mj_header endRefreshing];
        
    }
    
}


/** 单聊已读 */
-(void)singleChatDataIsRead:(NSNotification *)note{
    
    TFFMDBModel *model = note.object;
    
    if ([[self.chatId description] isEqualToString:[model.chatId description]]) {
        
        for (TFFMDBModel *mo in _chatRecords) {
            
            if ([[mo.isRead description] isEqualToString:@"0"]) {
                mo.isRead = @1;
            }
        }
        [self.messagesTable reloadData];
    }
}
/** 群聊已读 */
-(void)groupChatDataIsRead:(NSNotification *)note{
    
    NSArray *arr = note.object;
    if (arr.count == 0) {
        return;
    }
    TFFMDBModel *model = arr.firstObject;
    if (![[self.chatId description] isEqualToString:[model.chatId description]]) {
        return;
    }
    
    for (TFFMDBModel *mo1 in _chatRecords) {
        for (TFFMDBModel *mo2 in arr) {
           
            if ([mo2.msgId isEqualToString:mo1.msgId]) {
                mo1.readNumbers = mo2.readNumbers;
                mo1.readPeoples = mo2.readPeoples;
                break;
            }
        }
    }
    [self.messagesTable reloadData];
    
}


/** 发送单聊成功 */
-(void)singleChatSendSuccess:(NSNotification *)note{
    
    TFFMDBModel *model = note.object;
    
    if ([[self.chatId description] isEqualToString:[model.chatId description]]) {
        
        for (NSInteger i = 0; i < _chatRecords.count; i ++) {
            TFFMDBModel *mo = _chatRecords[i];
            if ([model.msgId isEqualToString:mo.msgId]) {
                mo.isRead = @0;
                [self.messagesTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
    
}

/** 发送群聊成功 */
-(void)groupChatSendSuccess:(NSNotification *)note{
    
    TFFMDBModel *model = note.object;
    
    if ([[self.chatId description] isEqualToString:[model.chatId description]]) {
        
        for (NSInteger i = 0; i < _chatRecords.count; i ++) {
            TFFMDBModel *mo = _chatRecords[i];
            if ([model.msgId isEqualToString:mo.msgId]) {
                mo.isRead = @0;
                [self.messagesTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }
}


/** 发送失败通知 */
-(void)sendFailed:(NSNotification *)note{
    
    TFFMDBModel *model = note.object;
    for (NSInteger i = 0; i < _chatRecords.count; i ++) {
        TFFMDBModel *mo = _chatRecords[i];
        if ([model.msgId isEqualToString:mo.msgId]) {
            [self.messagesTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}


/** 撤销消息通知 */
-(void)revocationChat:(NSNotification *)note{
    
    TFFMDBModel *model = note.object;
    
    for (NSInteger i = 0; i < _chatRecords.count; i ++) {
        TFFMDBModel *mo = _chatRecords[i];
        if ([model.msgId isEqualToString:mo.msgId]) {
            mo.content = model.content;
            mo.chatType = model.chatType;
            mo.chatFileType = model.chatFileType;
            [self.messagesTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}


//退出当前聊天室（被踢或解散）
- (void)quitView:(NSNotification *)note {
    
    TFAssistantPushModel *model = note.object;
    
    if ([[model.group_id description] isEqualToString:[self.chatId description]]) {
        
        if ([[model.type description] isEqualToString:@"1"] || [[model.type description] isEqualToString:@"10"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}

#pragma mark /** 初始化tableview */
- (void)setupTableview {
    
    self.view.backgroundColor = BGCOLOR;
    
    // 消息列表
    _messagesTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-46.5-NaviHeight-BottomM)];
    _messagesTable.backgroundColor = self.view.backgroundColor;
    _messagesTable.tableFooterView = [[UIView alloc]init];
    _messagesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messagesTable.delegate = self;
    _messagesTable.dataSource = self;
    [_messagesTable registerClass:[MessageCell class] forCellReuseIdentifier:@"MessageCell"];
    _messagesTable.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [_messagesTable addGestureRecognizer:tap];
    _messagesTable.hidden = YES;
    [self.view addSubview:_messagesTable];

    _messagesTable.mj_header = [TFRefresh headerGifRefreshWithBlock:^{

//        if (_chatRecords.count >= 20) {// 少于一页说明该聊天室消息总的条数少于20，就没有历史消息可以拉取了
        
            self.pageNum = _chatRecords.count / self.pageSize;// 在不断聊天的过程中，数据不断累加，当想拉取分页时，已经不是刚刚进入聊天室的pageSize条数据了。
            self.pageNum ++;
            
            if (self.isHistory) {// 拉取历史消息
                
                TFFMDBModel *fmdb = _chatRecords[0];
                
                if (self.cmdType == 1) { //群历史消息
                    
                    [self.socket getHistoryRecordData:@2 chatId:self.chatId timeSp:fmdb.clientTimes Count:self.pageSize];
                }
                else { //私聊历史消息
                    
                    [self.socket getHistoryRecordData:@1 chatId:@(self.receiveId) timeSp:fmdb.clientTimes Count:self.pageSize];
                }
                
            }else{// 拉取本地消息
                
                HQGlobalQueue(^{
                
                    NSMutableArray *records = [DataBaseHandle queryChatRoomRecordPageWithChatId:self.chatId pageNum:@(self.pageNum) pageSize:@(self.pageSize)];
                    
                    _chatRecords = [self pageLoadAlterRepeat:records];
                    [self showTimeHandle];
                    
                    HQMainQueue(^{
                        [_messagesTable.mj_header endRefreshing];
                        
                        [self.messagesTable reloadData];
                        
                    });
                    
                    if (records.count < self.pageSize) {
                        
                        TFFMDBModel *fmdb = _chatRecords[0];
                        
                        if (self.cmdType == 1) { //群历史消息
                            
                            [self.socket getHistoryRecordData:@2 chatId:self.chatId timeSp:fmdb.clientTimes Count:self.pageSize];
                        }
                        else { //私聊历史消息
                            
                            [self.socket getHistoryRecordData:@1 chatId:@(self.receiveId) timeSp:fmdb.clientTimes Count:self.pageSize];
                        }
                        self.isHistory = YES;
                    }
                    
                });
                
            }
//        }else{
//
//            [_messagesTable.mj_header endRefreshing];
//        }
        
    }];
    
    
}
/** 将查询出来的数据与已有数据合并，合并时避免重复的数据 */
- (NSMutableArray *)pageLoadAlterRepeat:(NSMutableArray *)chats{
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:chats];// 查询出来的数据
    for (TFFMDBModel *model in _chatRecords) {
        BOOL have = NO;
        for (TFFMDBModel *model1 in chats) {
            
            if ([model1.msgId isEqualToString:model.msgId]) {
                have = YES;
                break;
            }
        }
        if (have) {
            continue;
        }
        [arr addObject:model];// 将已有数据加入查询出来的数据里面
    }
    return arr;
}

/** 考虑显示时间：与上一条消息的时间差为3分钟就显示 */
-(void)showTimeHandle{
    
    NSArray *arr = [NSArray arrayWithArray:_chatRecords];
    if (arr.count == 0) {
        return;
    }else if (arr.count == 1) {
        TFFMDBModel *current = arr[0];
        current.showTime = @1;
        // 权宜之计
        if (self.cmdType == 2 && [[current.senderID description] isEqualToString:[UM.userLoginInfo.employee.sign_id description]]) {
            current.isRead = @1;
        }
    }else{
        for (NSInteger i = 0; i < arr.count-1; i++) {
            TFFMDBModel *current = arr[i];
            TFFMDBModel *next = arr[i + 1];
            if ([next.clientTimes longLongValue] > [current.clientTimes longLongValue]+3*60*1000) {
                next.showTime = @1;
            }else{
                next.showTime = @0;
            }
            // 权宜之计
            if (self.cmdType == 2 && [[next.senderID description] isEqualToString:[UM.userLoginInfo.employee.sign_id description]]) {
                next.isRead = @1;
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _chatRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    
    model = _chatRecords[indexPath.row];
    
    if ([model.chatFileType isEqualToNumber:@7]) { //提示消息
        
        TFChatTipCell *cell = [TFChatTipCell ChatTipCellWithTableView:tableView];
        
        cell.timeLab.text = [NSString stringWithFormat:@"   %@   ",[JCHATStringUtils getFriendlyDateString:[model.clientTimes longLongValue] forConversation:YES]];
        cell.contentLab.text = model.content;
        return cell;
        
    }
    else {
        
//        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
        
        MessageCell *cell = [MessageCell messageCellWithTableView:tableView];
        
        cell.delegate = self;
        
        [cell refreshCell:model];
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TFFMDBModel *model = _chatRecords[indexPath.row];
    
    return [MessageCell refreshHeightCellWithModel:model];
    
//    if ([model.chatFileType isEqualToNumber:@1]) {
//
//        // 根据文字内容计算宽高
//        //        height = [HQHelper calculateStringWithAndHeight:model.content cgsize:CGSizeMake(SCREEN_WIDTH-95-63-23, MAXFLOAT) wordFont:FONT(16)].height;
//        height = [self caculateTextSizeWithText:model.content maxWidth:SCREEN_WIDTH-95-63-23].height;
//
//        if (height < 30) {
//            if ([model.showTime isEqualToNumber:@1]) {
//
//                return  60+50;
//            }else{
//
//                return  60+20;
//            }
//        }else{
//            if ([model.showTime isEqualToNumber:@1]) {
//                return height + 35 + 50;
//            }else{
//
//                return height + 35 + 20;
//            }
//        }
//    }
//    else if ([model.chatFileType isEqualToNumber:@2] || [model.chatFileType isEqualToNumber:@5]) {
//
//        return 100+35+50+20 + 10;
//    }
//    else if ([model.chatFileType isEqualToNumber:@3]) {
//
//        return 38 + 35 + 50 + 10;
//    }
//    else if ([model.chatFileType isEqualToNumber:@4]) {
//
//        return 62+50+20 + 10;
//    }
//    else if ([model.chatFileType isEqualToNumber:@7]) {
//
//        // 根据文字内容计算宽高
//        height = [HQHelper calculateStringWithAndHeight:model.content cgsize:CGSizeMake(SCREEN_WIDTH-66, MAXFLOAT) wordFont:FONT(12)].height;
//
//        if (height < 20) {
//
//            return 100;
//        }
//
//        return height+90;
//    }
//
//    return 0;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    [self.noReadTipView noReadTipHide];
}

#pragma mark ==== LiuqsEmotionKeyBoardDelegate ====
#pragma mark 初始化键盘
- (LiuqsEmoticonKeyBoard *)setupKeyboard {
    
    if (!_keyboard) {
        if (self.cmdType == 1) {
            _keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:3];
        }
        if (self.cmdType == 2) {
            _keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:0];
        }
        self.keyboard.delegate = self;
        self.keyboard.textView.text = self.draft;
        _keyboard.topBar.y = SCREEN_HEIGHT-NaviHeight-topBarH-BottomM;
    }
    return _keyboard;
    
}

-(void)recordStarting{
    self.enablePanGesture = NO;
    
    if (_player.isPlaying) { //语音正在播放就先暂停
        
        [_player stop];
        
        [self.imgView stopAnimating];
    }
}

- (void)cancelStarting {

    self.enablePanGesture = YES;
}

//发送按钮的事件
- (void)sendButtonEventsWithPlainString:(NSString *)PlainStr {
    
    if (!PlainStr.length) {
        
        [MBProgressHUD showError:@"不能发送空白消息" toView:self.view];
        return;
    }
    //点击发送，发出一条消息
    [self prepareTextMessage:PlainStr];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self ScrollTableViewToBottom];
    }];
    self.keyboard.textView.text = @"";
    [self.keyboard.topBar resetSubsives];
    
}

/** 发送语音 */
-(void)sendVoiceWithVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration{
    
    self.enablePanGesture = YES;
    
    NSURL *mp3Url = [HQHelper recordCafToMp3WithCafUrl:voicePath toMp3Url:[self getMp3Path]];
    
    [self SendMessageWithVoice:[mp3Url absoluteString]
                 voiceDuration:voiceDuration];
}


/** 发送其他 */
-(void)sendAddItemContentWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            [self openCamera];
        }
            break;
        case 1:
        {
            [self openAlbum:index];
        }
            break;
        case 2:
        {
            [self openAlbum:index];
        }
            break;
        case 3:
        {
            [self pushFileLibray];
        }
            break;
        case 4:
        {
            [self hanleAtPeople];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ---文件库选
- (void)pushFileLibray {
    
    TFFileMenuController *fileVC = [[TFFileMenuController alloc] init];
    
    fileVC.isFileLibraySelect = YES;
    
    fileVC.refreshAction = ^(id parameter) {
        
        TFFolderListModel *model = parameter;
        
        [self.imgArr removeAllObjects];
        model.siffix = [model.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        TFFileModel *file = [[TFFileModel alloc] init];
        file.file_url = model.fileUrl;
        file.file_name = model.name;
        file.file_size = @([model.size integerValue]);
        file.file_type = model.siffix;
        file.original_file_name = model.name;
        file.upload_by = UM.userLoginInfo.employee.employee_name;
        file.upload_time = @([HQHelper getNowTimeSp]);
        [self.imgArr addObject:file];
        self.msgType = @4;
        if (self.cmdType == 1) { //群聊
            
            [self.socket sendMsgData:self.cmdType receiverId:self.chatId chatId:self.chatId text:nil msgType:self.msgType datas:self.imgArr atList:@[] voiceTime:@0];
        }
        else if (self.cmdType == 2) { //单聊
            
            [self.socket sendMsgData:self.cmdType receiverId:@(self.receiveId) chatId:self.chatId text:nil msgType:self.msgType datas:self.imgArr atList:@[] voiceTime:@0];
            
        }
        
    };
    
    [self.navigationController pushViewController:fileVC animated:YES];
}

- (void)keyBoardChanged {
    
    [UIView animateWithDuration:keyBoardTipTime animations:^{
        
        [self updateChatList];
    }];
}

//重设tabbleview的frame并根据是否在底部来执行滚动到底部的动画（不在底部就不执行，在底部才执行）
- (void)updateChatList {
    
    CGFloat offSetY = self.messagesTable.contentSize.height - self.messagesTable.Ex_height;
    //判断是否需要滚动到底部，给一个误差值
    if (self.messagesTable.contentOffset.y > offSetY - 5 || self.messagesTable.contentOffset.y > offSetY + 5) {
        
        self.messagesTable.bottom = self.keyboard.topBar.Ex_y;
        [self ScrollTableViewToBottom];
    }else {
        
        self.messagesTable.bottom = self.keyboard.topBar.Ex_y;
    }
}

//滚动到底部
- (void)ScrollTableViewToBottom {
    
    if (!self.chatRecords.count) {return;}
    if (self.chatRecords.count - 1 >= 1) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatRecords.count - 1 inSection:0];
        [self.messagesTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
//        CGFloat tableViewHeight = self.messagesTable.height;
//        CGFloat contentHeight = self.messagesTable.contentSize.height;
//        CGFloat off = contentHeight - tableViewHeight;
//        HQLog(@"==%f==",off);
//        [self.messagesTable setContentOffset:CGPointMake(0, contentHeight-tableViewHeight+self.messagesTable.contentInset.top+self.messagesTable.contentInset.bottom) animated:YES];

    }
}

/**
 消息列表滚动到底部
 */
- (void)scrollToBottom {
    
    if (_chatRecords.count) {

        [_messagesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatRecords.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        _messagesTable.hidden = NO;
    }

//    CGFloat tableViewHeight = self.messagesTable.height;
//    CGFloat contentHeight = self.messagesTable.contentSize.height;
//    CGFloat off = contentHeight - tableViewHeight;
//    HQLog(@"==%f==",off);
//    [self.messagesTable setContentOffset:CGPointMake(0, contentHeight-tableViewHeight+self.messagesTable.contentInset.top+self.messagesTable.contentInset.bottom) animated:YES];

}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    HQLog(@"==%@==",NSStringFromCGPoint(self.messagesTable.contentOffset));
//
//}

/**
 消息列表滚动到顶部
 */
- (void)scrollToTop{
    
    if (_chatRecords.count) {

        [_messagesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        _messagesTable.hidden = NO;
    }

//    [self.messagesTable setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - RecorderPath Helper Method
- (NSString *)getMp3Path {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MyMp3Sound.mp3", [dateFormatter stringFromDate:now]];
    return recorderPath;
}


#pragma mark - 发送文本
/** 发送文本消息 */
- (void)prepareTextMessage:(NSString *)text {

    if (text.length) {
        
        self.msgType = @1;
        
        if (self.cmdType == 1) {
            
            [self.socket sendMsgData:self.cmdType receiverId:self.chatId chatId:self.chatId text:text msgType:@1 datas:@[] atList:self.atArr voiceTime:self.voiceTime];
        }
        
        else {
            
            [self.socket sendMsgData:self.cmdType receiverId:@(self.receiveId) chatId:self.chatId text:text msgType:@1 datas:@[] atList:self.atArr voiceTime:self.voiceTime];
        }

    }
    
    [self.atArr removeAllObjects];
}

- (void)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.cmdType == 1) { //群聊
        
        if ([text isEqualToString:@"@"]) {
            //        [self.keyboard hideKeyBoard];
            if (!self.isOnce) {
                
                TFGroupATPeopleController *group = [[TFGroupATPeopleController alloc] init];
                self.isOnce = YES;
                group.groupId = self.chatId;
                __block NSString *str = self.keyboard.textView.text;
                group.actionParameter = ^(id parameter) {
                    
                    self.isOnce = NO;
                    [self.keyboard.textView becomeFirstResponder];
                    
                    TFGroupEmployeeModel *model = parameter[0];
                    
                    if (self.atArr.count > 0) {
                        
                        NSArray *arr = self.atArr;
                        
                        BOOL have = NO;
                        for (NSDictionary *dict in arr) {
                            
                            if (![model.sign_id isEqualToNumber:[dict valueForKey:@"id"]]) {
                                
                                have = YES;
                            }
                            else {
                                
                                have = NO;
                            }
                        }
                        
                        if (have) {
                            
                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                            
                            [dic setObject:model.sign_id forKey:@"id"];
                            [dic setObject:model.employee_name forKey:@"name"];
                            
                            [self.atArr addObject:dic];
                        }
                        
                    }
                    else {
                        
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        
                        [dic setObject:model.sign_id forKey:@"id"];
                        [dic setObject:model.employee_name forKey:@"name"];
                        
                        [self.atArr addObject:dic];
                    }
                    
                    self.keyboard.textView.text = [str stringByAppendingString:[NSString stringWithFormat:@"@%@  ",model.employee_name]];
                    self.replaceStr = self.keyboard.textView.text;
                };
                
                //        self.index = 0;
                [self.navigationController pushViewController:group animated:YES];
            }
            
        }
    }
}

- (void)hanleAtPeople{
    
    TFGroupATPeopleController *group = [[TFGroupATPeopleController alloc] init];
    self.isOnce = YES;
    group.groupId = self.chatId;
    __block NSString *str = self.keyboard.textView.text;
    group.actionParameter = ^(id parameter) {
        
        self.isOnce = NO;
        [self.keyboard.textView becomeFirstResponder];
        
        TFGroupEmployeeModel *model = parameter[0];
        
        if (self.atArr.count > 0) {
            
            NSArray *arr = self.atArr;
            
            BOOL have = NO;
            for (NSDictionary *dict in arr) {
                
                if (![model.sign_id isEqualToNumber:[dict valueForKey:@"id"]]) {
                    
                    have = YES;
                }
                else {
                    
                    have = NO;
                }
            }
            
            if (have) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                [dic setObject:model.sign_id forKey:@"id"];
                [dic setObject:model.employee_name forKey:@"name"];
                
                [self.atArr addObject:dic];
            }
            
        }
        else {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:model.sign_id forKey:@"id"];
            [dic setObject:model.employee_name forKey:@"name"];
            
            [self.atArr addObject:dic];
        }
        
        self.keyboard.textView.text = [str stringByAppendingString:[NSString stringWithFormat:@"@%@  ",model.employee_name]];
        self.replaceStr = self.keyboard.textView.text;
    };
    
    //        self.index = 0;
    [self.navigationController pushViewController:group animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {

//    _draftText = textView.text;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

//    _draftText = textView.text;
    return YES;
}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
    HQLog(@"Action - SendMessageWithVoice");
    
    if ([voiceDuration integerValue]<0.5) {
        if ([voiceDuration integerValue]<0.5) {
            HQLog(@"录音时长小于 0.5s");
        }
        return;
    }
    
    
    self.voiceTime = @([voiceDuration integerValue]);
    
    self.msgType = @3;
    [self.chatBL chatFileWithImages:@[] withVioces:@[voicePath] bean:@"chat111"];
}

/** 选择照片处理 */
-(void)handleImages:(NSArray *)arr{
    
    if (arr.count == 0) {
        return;
    }
    if (self.isVideo) { //相册视频
        
        for (NSInteger i = 0; i < arr.count; i++) {
            UIImage *asset = arr[i];
            // 我想在这里拿到视频文件
            NSData *fileData = UIImagePNGRepresentation(asset);
            
            //File URL
            NSString *savePath = [NSString stringWithFormat:@"%@%@", [NSHomeDirectory() stringByAppendingString:@"/tmp/"], [NSString stringWithFormat:@"video%ld",i]];
            [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];

            BOOL resu = [fileData writeToFile:savePath atomically:NO];
            
                if (resu) {
                    
                    NSLog(@"写入成功！");
                    self.msgType = @5;
                    [self.chatBL uploadFileWithImages:nil withAudios:nil withVideo:@[savePath] bean:@"chat111"];
                }
                else {
                    
                    NSLog(@"写入失败！");
                }
            
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
    }
    else { //相册图片
        
        for (int i=0; i<arr.count; i++) {
            UIImage *image = arr[i];
            
            // 选择照片上传
            self.msgType = @2;
            [self.chatBL chatFileWithImages:@[image] withVioces:nil bean:@"chat111"];
            
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
}

#pragma mark - 打开相册
- (void)openAlbum:(NSInteger)index {

    kWEAKSELF
    ZLPhotoActionSheet *sheet =[HQHelper takeHPhotoWithBlock:^(NSArray<UIImage *> *images) {
        [weakSelf handleImages:images];
    }];
    //图片数量
    if (index == 1) {

        sheet.configuration.maxSelectCount = 9;
        sheet.configuration.allowSelectImage = YES;
        sheet.configuration.allowSelectVideo = NO;
//        sheet.configuration.maxVideoSelectCountInMix = 9;
//        sheet.configuration.minVideoSelectCountInMix = 1;
        self.isVideo = NO;
    }
    else if (index == 2) {

//        sheet.configuration.maxSelectCount = 9;
        sheet.configuration.allowSelectImage = NO;
        sheet.configuration.allowSelectVideo = YES;
        sheet.configuration.maxVideoSelectCountInMix = 9;
        sheet.configuration.minVideoSelectCountInMix = 1;
        self.isVideo = YES;
    }
    //如果调用的方法没有传sender，则该属性必须提前赋值
    sheet.sender = self;
    [sheet showPhotoLibrary];
    return;
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1 ; // 选择图片最大数量
    
    if (index == 1) {

        picker.assetsFilter = [ALAssetsFilter allPhotos]; // 可选择所有相册图片
        self.isVideo = NO;
    }
    else if (index == 2) {

        picker.assetsFilter = [ALAssetsFilter allVideos]; // 可选择所有相册视频
        self.isVideo = YES;
    }
    
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    if (assets.count <= 0) return;
    
    if (self.isVideo) { //相册视频
        
        for (ALAsset *asset in assets) {
            NSLog(@"HERE\n asset.defaultRepresentation.url = %@\n asset.defaultRepresentation.filename = %@",asset.defaultRepresentation.url, asset.defaultRepresentation.filename);
            
            // 我想在这里拿到视频文件
            ALAssetRepresentation *representation = asset.defaultRepresentation;
            long long size = representation.size;
            NSMutableData* data = [[NSMutableData alloc] initWithCapacity:size];
            void* buffer = [data mutableBytes];
            [representation getBytes:buffer fromOffset:0 length:size error:nil];
            NSData *fileData = [[NSData alloc] initWithBytes:buffer length:size];
            
            //File URL
            NSString *savePath = [NSString stringWithFormat:@"%@%@", [NSHomeDirectory() stringByAppendingString:@"/tmp/"], representation.filename];
            [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];

            BOOL resu = [fileData writeToFile:savePath atomically:NO];
            
                if (resu) {
                    
                    NSLog(@"写入成功！");
                    self.msgType = @5;
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.chatBL uploadFileWithImages:nil withAudios:nil withVideo:@[savePath] bean:@"chat111"];
                }
                else {
                    
                    NSLog(@"写入失败！");
                }
            
        }
        
        
    }
    else { //相册图片
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            NSLog(@"HERE\n asset.defaultRepresentation.url = %@\n asset.defaultRepresentation.filename = %@",asset.defaultRepresentation.url, asset.defaultRepresentation.filename);
            
            UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            // 添加图片
            
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            NSString *fileName = [representation filename];
            HQLog(@"fileName : %@",fileName);
            
            // 选择照片上传
            self.msgType = @2;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.chatBL chatFileWithImages:@[image] withVioces:nil bean:@"chat111"];
            
        }
    }
    
}


#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 拍照上传
    self.msgType = @2;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.chatBL chatFileWithImages:@[image] withVioces:nil bean:@"chat111"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存草稿
- (void)saveDraftToDB {
    
    if (self.draft && [[self.keyboard.textView.attributedText getPlainString] isEqualToString:@""]) { //进来的时候是草稿
        
        HQGlobalQueue(^{
            
            NSArray *arr = [DataBaseHandle queryRecodeWithChatId:self.chatId];
            
            TFFMDBModel *model = arr.lastObject;
            
            TFFMDBModel *db = [DataBaseHandle queryChatListDataWithChatId:self.chatId];
            
            db.content = model.content;
            db.draft = @"";
            
            [DataBaseHandle updateChatListWithData:db];
            
            HQMainQueue(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:db];
                
            });
            
        });
    }
    else {
        
        if (![[self.keyboard.textView.attributedText getPlainString] isEqualToString:@""]
            ) { //存草稿
            
            HQGlobalQueue(^{
                
                /** 消息存储 */
                TFFMDBModel *model = [[TFFMDBModel alloc] init];
                model.chatFileType = @1;
                model.clientTimes = @([HQHelper getNowTimeSp]); //当前时间戳
                model.chatId = self.chatId;
                model.companyId = UM.userLoginInfo.company.id;
                model.chatType = @(self.cmdType);
                model.draft = [self.keyboard.textView.attributedText getPlainString];
                
                model.isHide = @0;
                
                model.senderID = UM.userLoginInfo.employee.sign_id;
                model.receiverID = @(self.receiveId);
                
                
                TFFMDBModel *model2 = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
                
                if (model2) { //会话列表存在会话
                    
                    model.receiverName = model2.receiverName;
                    model.avatarUrl = model2.avatarUrl;
                    
                    [DataBaseHandle updateChatListWithData:model];
                    
                }
                else { //新建的聊天
                    
                    model.receiverName = self.naviTitle;
                    model.avatarUrl = self.picture;
                    
                    [DataBaseHandle addChatListWithData:model];
                }
                
                HQMainQueue(^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:model];
                });
                
            });
            
            
        }
        
    }
    
}


- (void)personSetClicked {

    TFSingleChatSetController *single = [[TFSingleChatSetController alloc] init];
    
    single.chatId = self.chatId;
    single.chatType = @2;
    
    [self.navigationController pushViewController:single animated:YES];
}

- (void)groupSetClicked {

    TFGroupChatSetController *group = [[TFGroupChatSetController alloc] init];
    
    group.groupId = self.chatId;
    group.chatType = @1;
    group.refreshAction = ^(NSString *time) {
        
        self.title = time;
    };
    
    [self.navigationController pushViewController:group animated:YES];
    
}



#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        if ([self.reSendModel.chatFileType isEqualToNumber:@1]) { //文字
            
#warning at不能重发
            [self.socket sendMsgData:[self.reSendModel.chatType integerValue] receiverId:self.reSendModel.receiverID chatId:self.reSendModel.chatId text:self.reSendModel.content msgType:self.reSendModel.chatFileType datas:@[] atList:@[] voiceTime:self.reSendModel.voiceDuration];
        }
        else if ([self.reSendModel.chatFileType isEqualToNumber:@2] || [self.reSendModel.chatFileType isEqualToNumber:@3] || [self.reSendModel.chatFileType isEqualToNumber:@4]) {//图片/语音/文件
            
            NSMutableArray *arr = [NSMutableArray array];
            
            TFFileModel *fModel = [[TFFileModel alloc] init];
            
            fModel.file_url = self.reSendModel.fileUrl;
            fModel.file_name = self.reSendModel.fileName;
            fModel.file_size = self.reSendModel.fileSize;
            fModel.file_type = self.reSendModel.fileSuffix;
            fModel.fileId = self.reSendModel.fileId;
            
            [arr addObject:fModel];
            
            [self.socket sendMsgData:[self.reSendModel.chatType integerValue] receiverId:self.reSendModel.receiverID chatId:self.reSendModel.chatId text:nil msgType:self.reSendModel.chatFileType datas:arr atList:@[] voiceTime:self.reSendModel.voiceDuration];
            
            
        }
        
        for (TFFMDBModel *mm in _chatRecords) {
            if ([mm.msgId isEqualToString:self.reSendModel.msgId]) {
                [_chatRecords removeObject:mm];
                [self.messagesTable reloadData];
                break;
            }
        }
        
        HQGlobalQueue(^{
            [DataBaseHandle deleteChatRoomDataWithMsgId:self.reSendModel.msgId];
        });
        
    }
    
}


#pragma mark MessageCellDelegate代理方法
- (void)playVoice:(TFFMDBModel *)model imageView:(UIImageView *)imageView{

    NSString *fileName = [NSString stringWithFormat:@"%@.mp3",[HQHelper stringForMD5WithString:model.content]];
    [HQHelper cacheFileWithUrl:model.content fileName:fileName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        self.imgView = imageView;
        
        if (_player.isPlaying) {
            
            [_player stop];
            
            [imageView stopAnimating];
        }
        else {
            
            [imageView startAnimating];
            
            NSError *error;
            // 通过网络data数据创建播放器
            _player = [[AVAudioPlayer alloc] initWithData:data error:&error];
            if (error) {
                
                [imageView stopAnimating];
                HQLog(@" 播放器初始化失败%@",error);
                return ;
            }
            [HQHelper saveCacheFileWithFileName:fileName data:data];
            
            _player.volume = 1;
            // 设置属性
            _player.numberOfLoops = 0; //不循环
            _player.delegate = self;
            //        [_player prepareToPlay];
            
            //            UInt32 doChangeDefaultRoute = 1;
            //        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute),&doChangeDefaultRoute);
            NSError *audioError = nil;
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&audioError];
            if(!success)
            {
                NSLog(@"error doing outputaudioportoverride - %@", [audioError localizedDescription]);
            }
            
            [_player play];
            
        }
  
    }fileHandler:^(NSString *path) {
        
        
        self.imgView = imageView;
        
        if (_player.isPlaying) {
            
            [_player stop];
            
            [imageView stopAnimating];
        }
        else {
            
            [imageView startAnimating];
            
            NSError *error;
            // 通过网络data数据创建播放器
            _player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:&error];
            if (error) {
                
                [imageView stopAnimating];
                HQLog(@" 播放器初始化失败%@",error);
                return ;
            }
            
            _player.volume = 1;
            // 设置属性
            _player.numberOfLoops = 0; //不循环
            _player.delegate = self;
            //        [_player prepareToPlay];
//            UInt32 doChangeDefaultRoute = 1;
//        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute),&doChangeDefaultRoute);
            NSError *audioError = nil;
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&audioError];
            if(!success)
            {
                NSLog(@"error doing outputaudioportoverride - %@", [audioError localizedDescription]);
            }
            [_player play];
            
        }
    }];

    
    
}

//播放完成代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [self.imgView stopAnimating];
}

//图片点击
- (void)previewImg:(UIImageView *)imageView model:(TFFMDBModel *)model {

    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView thumbImage:imageView.image imageUrl:[HQHelper URLWithString:model.fileUrl]];
    [items addObject:item];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
//    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
//    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
    browser.showType = KSPhotoBrowserTypeNone;
    browser.fileTitle = model.fileName;
//    browser.delegate = self;
    browser.bounces = NO;
    [browser showFromViewController:self];
}

- (void)readedPeoples:(TFFMDBModel *)model {

    TFNoticeReadMainController *read = [[TFNoticeReadMainController alloc] init];
    
    read.groupId = self.chatId;
    read.readpeoples = model.readPeoples;
    
    [self.navigationController pushViewController:read animated:YES];
}

//复制
- (void)copyMessage:(UILabel *)lab {

    //当没有文字的时候调用这个方法会崩溃
    if (!lab.text) return;
    //复制文字到剪切板
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = lab.text;
}

//撤回
- (void)revokeMessage:(TFFMDBModel *)model {
    
    //[self.socket sendMsgData:3 receiverId:model.receiverID chatId:model.chatId text:@"你撤回了一条消息" msgType:@7 datas:@[] atList:@[] voiceTime:model.voiceDuration];
    
    TFIMHeadData *imData = [[TFIMHeadData alloc] init];
    
    if ([model.chatType isEqualToNumber:@1]) {
        
        imData.usCmdID = 26;
    }
    else {
    
        imData.usCmdID = 24;
    }
    
    
    imData.OneselfIMID = [UM.userLoginInfo.employee.sign_id integerValue];
    imData.ucVer = 1;
    imData.ucDeviceType = iOSDevice;
    imData.senderID = [model.senderID integerValue];
    imData.receiverID = [model.receiverID integerValue];
    imData.clientTimes = [model.clientTimes integerValue];
    imData.RAND = [model.RAND intValue];
    
    [self.socket sendData:[imData data]];
}

//转发
- (void)transitiveMessage:(TFFMDBModel *)model {
    
    TFSelectChatPersonController *select = [[TFSelectChatPersonController alloc] init];
    
    select.type = 0;
    select.isTrans = YES;
    select.haveGroup = YES;
    select.dbModel = model;
    select.isSendFromFileLib = NO;
    
    [self.navigationController pushViewController:select animated:YES];
}

- (void)longPressAT:(TFFMDBModel *)model {

//    self.keyboard.textView.text = [NSString stringWithFormat:@"@%@",model.receiverName];
    if (self.atArr.count >0) {
        
        
        NSArray * array = [NSArray arrayWithArray: self.atArr];
        
        BOOL have = NO;
        for (NSMutableDictionary *dict in array) {

            
            if (![model.senderID isEqualToNumber:[dict valueForKey:@"id"]]) {

                
                have = YES;
            }
            else {
            
                have = NO;
                break;
            }
            
            
        }
        
        if (have) {
            
            self.keyboard.textView.text = [self.keyboard.textView.text stringByAppendingString:[NSString stringWithFormat:@"@%@",model.senderName]];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:model.senderID forKey:@"id"];
            [dic setObject:model.senderName forKey:@"name"];
            
            [self.atArr addObject:dic];
        }
    }
    else {
    
        self.keyboard.textView.text = [self.keyboard.textView.text stringByAppendingString:[NSString stringWithFormat:@"@%@",model.senderName]];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:model.senderID forKey:@"id"];
        [dic setObject:model.senderName forKey:@"name"];
        
        [self.atArr addObject:dic];
    }
    
    
}

//头像点击
- (void)headImgClicked:(TFFMDBModel *)model {

//    TFPersonalMaterialController *personalVC = [[TFPersonalMaterialController alloc] init];
//
//    personalVC.signId = model.senderID;
//
//    [self.navigationController pushViewController:personalVC animated:YES];
    
    
    TFContactorInfoController *info = [[TFContactorInfoController alloc] init];
    info.signId = model.senderID;
    [self.navigationController pushViewController:info animated:YES];
}

//重发
- (void)reSendMessage:(TFFMDBModel *)model {

    self.reSendModel = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定重发该消息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    
}

//打开文件
- (void)chatFileClicked:(TFFMDBModel *)model {

    TFFileDetailController *detailVC = [[TFFileDetailController alloc] init];
    detailVC.fileId = model.fileId;
    detailVC.naviTitle = model.fileName;
    detailVC.whereFrom = 1;
    
    TFFolderListModel *basicModel = [[TFFolderListModel alloc] init];
    
    basicModel.size = model.fileSize;
    basicModel.siffix = model.fileSuffix;
    basicModel.name = model.fileName;
    basicModel.file_id = model.fileId;
    
    basicModel.employee_name = model.senderName;
    basicModel.create_time = model.clientTimes;
    
    detailVC.fileUrl = model.fileUrl;
    detailVC.fileId = model.fileId;
    detailVC.basics = basicModel;
    
    model.fileSuffix = [model.fileSuffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([model.fileSuffix isEqualToString:@"jpg"] ||[model.fileSuffix isEqualToString:@"jpeg"] ||[model.fileSuffix isEqualToString:@"png"] ||[model.fileSuffix isEqualToString:@"gif"] ) {
        
        detailVC.isImg = 1;
    }
    else if ([model.fileSuffix isEqualToString:@"mp3"]) {
    
        detailVC.isImg = 2;
    }


    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark 计算方法
/** 计算文本size，当文本小于最大宽度时返回本身的宽度 */
- (CGSize)caculateTextSizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth{
    
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = maxSize;
    container.maximumNumberOfRows = 0;
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:[self attributedStringWithText:text font:16]];
    
    CGFloat textW = layout.textBoundingSize.width > maxSize.width ? maxSize.width : layout.textBoundingSize.width;
    
    
    return CGSizeMake(textW, layout.textBoundingSize.height);
    
}

/** 普通文本转成带表情的属性文本 */
- (NSAttributedString *)attributedStringWithText:(NSString *)text font:(CGFloat)font{
    
    return [LiuqsDecoder decodeWithPlainStr:text font:[UIFont systemFontOfSize:font]];
}

#pragma mark 其他方法
- (void)returenToQX {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 点击消息列表收起键盘
- (void)endEditing {
    
    [self.keyboard hideKeyBoard];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_ChatFile) { 
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.imgArr = resp.body;
        
        if (self.cmdType == 1) { //群聊
            
            [self.socket sendMsgData:self.cmdType receiverId:self.chatId chatId:self.chatId text:nil msgType:self.msgType datas:self.imgArr atList:@[] voiceTime:self.voiceTime];
        }
        else if (self.cmdType == 2) { //单聊
        
            [self.socket sendMsgData:self.cmdType receiverId:@(self.receiveId) chatId:self.chatId text:nil msgType:self.msgType datas:self.imgArr atList:@[] voiceTime:self.voiceTime];
        }
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_ChatFile) {
        
        [MBProgressHUD showError:@"发送失败" toView:self.view];
        
    }
    
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:[[self.dbModel.isTop description] isEqualToString:@"1"] ?@"取消置顶":@"置顶" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"置顶");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:[[self.dbModel.noBother description] isEqualToString:@"1"] ?@"取消免打扰":@"免打扰" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"免打扰");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"删除");
    }];
    
    NSArray *actions = @[action1,action2,action3];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
}

@end
