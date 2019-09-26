//
//  TFSocketManager.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSocketManager.h"
#import<AudioToolbox/AudioToolbox.h>
#import "TFChatBL.h"
#import "TFSendLoadBalanceData.h"
#import "TFReceiveLoadBalanceData.h"
#import "YBMonitorNetWorkState.h"

#define WeakSelf(ws) __weak __typeof(&*self)weakSelf = self

@interface TFSocketManager ()<SRWebSocketDelegate,HQBLDelegate>
{
    int _index;
    NSTimer *_heartBeat;
    NSTimeInterval _reConnectTime;
}

@property (nonatomic,strong) SRWebSocket *socket;

@property (nonatomic, strong) TFChatBL *chatBL;
//是否是负载均衡 0:不是 1:是
@property (nonatomic, assign) NSInteger isBalance;

@property (nonatomic, copy) NSString *nodeUrl;
/** 网络状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus netWorkStatus;

@end

@implementation TFSocketManager


/** 单例 */
+ (TFSocketManager *)sharedInstance{
    
    static TFSocketManager *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[TFSocketManager alloc] init];
        
//        Instance.socket = [[SRWebSocket alloc] initWithURLRequest:
//                       [NSURLRequest requestWithURL:KIMServerAdress] protocols:nil allowsUntrustedSSLCertificates:YES];// 服务器的地址
        if (TFNodeSwich == 0) {
            
            Instance.socket = [[SRWebSocket alloc] initWithURLRequest:
                               [NSURLRequest requestWithURL:[NSURL URLWithString:@"wss://192.168.1.188:9006"]] protocols:nil allowsUntrustedSSLCertificates:YES];
        }
        else {
            
            Instance.socket = [[SRWebSocket alloc] initWithURLRequest:
                               [NSURLRequest requestWithURL:[NSURL URLWithString:@"wss://192.168.1.168:1131"]] protocols:nil allowsUntrustedSSLCertificates:YES];
        }
        
        Instance.socket.delegate = Instance;   //实现这个 SRWebSocketDelegate 协议
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    });
    
    return Instance;
}


/** 开启连接 */
-(void)socketOpen{
    
    YBMonitorNetWorkState *networkState = [YBMonitorNetWorkState shareMonitorNetWorkState];
    [networkState getCurrentNetWorkType];
    
    
    //如果是同一个url return
    TFSocketManager *ma = [TFSocketManager sharedInstance];
    
    if (ma.socket) {
    
        if (self.socketReadyState == SR_CLOSING || self.socketReadyState == SR_CLOSED || self.socketReadyState == SR_CONNECTING) {
       
            [ma.socket open];     //open 就是直接连接了
        }

        return;
    }
    
    ma.socket = [[SRWebSocket alloc] initWithURLRequest:
                       [NSURLRequest requestWithURL:KIMServerAdress] protocols:nil allowsUntrustedSSLCertificates:YES];// 服务器的地址
    
    ma.socket.delegate = self;   //实现这个 SRWebSocketDelegate 协议
    
    
    if (self.socketReadyState == SR_CLOSING || self.socketReadyState == SR_CLOSED || self.socketReadyState == SR_CONNECTING) {
        
        [ma.socket open];     //open 就是直接连接了
    }
    
    // 连接中
    [[NSNotificationCenter defaultCenter] postNotificationName:SocketStatusConnecting object:nil];
}

/** 连接状态 */
-(SRReadyState)socketReadyState{
    return self.socket.readyState;
}


/** 关闭连接 */
-(void)socketClose{
    
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        //断开连接时销毁心跳
        [self destoryHeartBeat];
        NSLog(@"断开成功！");
    }
}

/** 请求节点 */
- (void)getNodeURLPackets {
    
    TFSendLoadBalanceData *lbData = [[TFSendLoadBalanceData alloc] init];
    lbData.state = 0;
    lbData.Imid = [UM.userLoginInfo.employee.sign_id integerValue];
    
    [self.socket send:[lbData data]];
}

/** 登陆 */
- (void)loginSocket {

    TFIMHeadData *imData = [[TFIMHeadData alloc] init];
    imData.OneselfIMID = [UM.userLoginInfo.employee.sign_id integerValue];
    imData.usCmdID = 1;
    imData.ucVer = 1;
    imData.ucDeviceType = iOSDevice;
    imData.senderID = 0;//登陆的时候可以为0
    imData.receiverID = 0;
    
    //登陆包结构
    TFIMLoginData *login = [[TFIMLoginData alloc] init];
    
    NSString *str = @"";
    for (NSInteger i = 0; i < 50; i ++) {
        str = [str stringByAppendingString:@"0"];
    }
//    login.szUsername = str;
//    
//    login.chStatus = 1;
//    login.chUserType = 1;
    
    
    
    [self sendData:[login loginDataWithHeader:[imData data]]];
}

/** 退出登陆 */
- (void)loginOutSocket {
    
    TFIMHeadData *imData = [[TFIMHeadData alloc] init];
    imData.OneselfIMID = [UM.userLoginInfo.employee.sign_id integerValue];
    imData.usCmdID = 2;
    imData.ucVer = 1;
    imData.ucDeviceType = iOSDevice;
    imData.senderID = 0;//登陆的时候可以为0
    imData.receiverID = 0;
    
    
    //登陆包结构
    TFIMLoginData *login = [[TFIMLoginData alloc] init];
    
    NSString *str = @"";
    for (NSInteger i = 0; i < 50; i ++) {
        str = [str stringByAppendingString:@"0"];
    }
    //    login.szUsername = str;
    //
    //    login.chStatus = 1;
    //    login.chUserType = 1;
    
    
    
    [self sendData:[login loginDataWithHeader:[imData data]]];
}

/** 取消心跳 */
- (void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (_heartBeat) {
            if ([_heartBeat respondsToSelector:@selector(isValid)]){
                if ([_heartBeat isValid]){
                    [_heartBeat invalidate];
                    _heartBeat = nil;
                }
            }
        }
    })
}

/** pingPong */
- (void)ping{
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

/** 重连机制 */
- (void)reConnect:(id)data
{
    
    [self socketClose];
    
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (_reConnectTime > 64) {
        //您的网络状况不是很好，请检查网络后重试
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SocketStatusNOConnent object:data];
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self socketOpen];
    });
    
    //重连时间2的指数级增长
    if (_reConnectTime == 0) {
        _reConnectTime = 2;
    }else{
        _reConnectTime *= 2;
    }
    
    HQMainQueue(^{
        
        HQLog(@"currentThread===%@",[NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reConnectingNotification" object:nil];
    });
    
    
}

//初始化心跳
- (void)initHeartBeat
{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        //心跳设置为3分钟，NAT超时一般为5分钟
        _heartBeat = [NSTimer timerWithTimeInterval:3 * 60 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop]addTimer:_heartBeat forMode:NSRunLoopCommonModes];
    })
}

-(void)sentheart{
    //发送心跳 和后台可以约定发送什么内容
    [self sendData:@"heart"];
}



/** 发送数据 */
- (void)sendData:(id)data{
   
    WeakSelf(ws);
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    
    dispatch_async(queue, ^{
        if (self.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (self.socket.readyState == SR_OPEN) {
                [self.socket send:data];    // 发送数据
                
            } else if (self.socket.readyState == SR_CONNECTING) {
            
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
                // 代码有点长，我就写个逻辑在这里好了
                
                [self reConnect:data]; 
                
            } else if (self.socket.readyState == SR_CLOSING || self.socket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连
                [self reConnect:data];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:SocketStatusNOConnent object:data];
        }
    });

}
//
//#pragma mark - AFNetworkingReachabilityDidChangeNotification
////网络连接 监听方法
//- (void)reachabilityDidChange:(NSNotification*)notification
//{
//    NSDictionary *netDic = notification.userInfo;
//    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)[netDic[AFNetworkingReachabilityNotificationStatusItem] intValue];
//    _netWorkStatus = status;
//    if (status == AFNetworkReachabilityStatusNotReachable) {
//
//        //网络不可达
////        if (_isNetworkAvailable) {
////            _isNetworkAvailable = NO;
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkStatusNotReachable" object:nil];
////        }
//
//
//    }else{
////        if (!_isNetworkAvailable) {
////            _isNetworkAvailable = YES;
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkStatusReachable" object:nil];
////        }
//    }
//}

#pragma mark - socket delegate （socket代理方法）
/** socket连接成功 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
    HQLog(@"socket连接成功...%@",[NSThread currentThread]);
    HQMainQueue(^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reconnectSuccessNotification" object:nil];
    });
    
    //每次正常连接的时候清零重连时间
    _reConnectTime = 0;
    
    //开启心跳
//    [self initHeartBeat];
    
    if (webSocket == self.socket) {
        
        if (TFNodeSwich == 1) {
            
            if (self.isBalance == 0) {
                
                [self getNodeURLPackets];
            }
            else {
                
                [self loginSocket];
            }
        }
        else {
            
            [self loginSocket];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SocketStatusNormal object:nil];
    }
}

/** socket连接失败 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
    HQLog(@"socket连接失败...");
    if (webSocket == self.socket) {
        _socket = nil;
        // 连接失败就重连
        [self reConnect:nil];
    }
}

/** 关闭socket */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    HQLog(@"socket关闭...");
    if (webSocket == self.socket) {
        
        [self socketClose];
    }
    else {
        
        
        self.socket = [[SRWebSocket alloc] initWithURLRequest:
                       [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"wss://%@",self.nodeUrl]]] protocols:nil allowsUntrustedSSLCertificates:YES];// 服务器的地址
        
        self.socket.delegate = self;
        [self.socket open];
    }
}

/*该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
 我的理解就是建立一个定时器，每隔十秒或者十五秒向服务端发送一个ping消息，这个消息可是是空的
 */
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

#pragma mark 接收服务器返回数据
/** 服务器返回数据 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    
    if (webSocket == self.socket) {
        
        if (!message) {
            return;
        }
        
        if (TFNodeSwich == 1) {
            
            if (self.isBalance == 0) { //连接节点
                
                TFReceiveLoadBalanceData *loadBanlance = [TFReceiveLoadBalanceData receiveLoadBalanceWithData:message];
                if (loadBanlance.state == 0) {
                    
                    self.isBalance = 1;
                    self.nodeUrl = [TFReceiveLoadBalanceData loadBalanceResponseWithData:message];
                    
                    [self socketClose];
                    
                    
                }
                
                return;
            }
        }
        
        
        TFIMHeadData *head = [TFIMHeadData headerWithData:message];
        
        NSString *messageId = [NSString stringWithFormat:@"%lld%u",head.clientTimes,head.RAND];
        
        if (head.usCmdID == 1) { //登陆
            
            [self qixinLoginStatus:message];
        }

#pragma mark 收到单聊群聊
        else if (head.usCmdID == 5 || head.usCmdID == 6) {

            /**返回一个ACK数据包给服务器 **/
            [self returnAckPackage:head];
            
            NSNumber *chatType = @0;
            if (head.usCmdID == 5) {
                chatType = @2;
            }
            else {
                chatType = @1;
            }
            
            TFIMContentData *IMContent = [TFIMContentData recieveContentDataWithData:message];
            
            HQLog(@"收到聊天消息:%@",IMContent.content);
            
            TFChatMsgModel *chatMsgModel = IMContent.content;
            
            if (chatMsgModel.atList.count>0) { //有@他人
                
                NSString *atIds = @"";
                for (NSDictionary *dic in chatMsgModel.atList) { //遍历被@的人
                    
                    NSNumber *signId = [dic valueForKey:@"id"];
                    
                    atIds = [atIds stringByAppendingString:[NSString stringWithFormat:@",%@",signId]];
//                    atIds = [atIds substringFromIndex:1];
                    chatMsgModel.atIds = atIds;

                }
            }
            
            /************ 本地数据库消息存储 ***********/
            TFFMDBModel *model = [[TFFMDBModel alloc] init];
            model.chatFileType = chatMsgModel.type;
            model.content = chatMsgModel.msg?:chatMsgModel.fileUrl;
            model.chatId = chatMsgModel.chatId;
            model.voiceDuration = chatMsgModel.duration;
            model.senderName = chatMsgModel.senderName;
            model.receiverName = chatMsgModel.senderName;
            model.senderAvatarUrl = chatMsgModel.senderAvatar;
            model.avatarUrl = chatMsgModel.senderAvatar;
            model.fileName = chatMsgModel.fileName;
            model.fileSize = chatMsgModel.fileSize;
            model.fileSuffix = chatMsgModel.fileType;
            model.fileUrl = chatMsgModel.fileUrl;
            model.videoUrl = chatMsgModel.videoUrl;
            model.fileId = chatMsgModel.fileId;
            model.clientTimes = @(IMContent.clientTimes);
            model.senderID = @(IMContent.senderID);
            model.receiverID = @(IMContent.receiverID);
            model.RAND = @(IMContent.RAND);
            model.companyId = UM.userLoginInfo.company.id;
            model.chatType = chatType;
            model.draft = @"";
            model.msgId = messageId;
            model.isHide = @0;
            model.atIds = chatMsgModel.atIds;
            
            /** 收到消息未读数+1 */
            if (![model.senderID isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                
                TFFMDBModel *fmdb = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
                model.unreadMsgCount = @([fmdb.unreadMsgCount integerValue] + 1);
            }
            
            //是否显示时间
            [self timeIsShow:model];
            
            //避免收到重复消息
            //[self avoidRepetitionMessage:model];
            //插入本地聊天室数据库
            [DataBaseHandle addRecordWithContent:model];
            
            //会话列表接收者ID都存对方的 ps:前一个为保存到chat，这一个保存到chatList
            model.receiverID = @(IMContent.senderID);
            
            //查询会话列表有没有该会话
            TFFMDBModel *model2 = [DataBaseHandle queryChatListDataWithChatId:model.chatId];
            
            if (model2) {
                
                if ([model2.chatId isEqualToNumber:model.chatId]) {
                    
                    /*将数据存入会话列表数据库（只存最新一条）*/
                    [DataBaseHandle updateChatListWithData:model];
                }

            }

            model.RAND = @(head.RAND);
            
            /******          离线消息          ******/
            if (head.ucFlag == 3) { //离线消息
                
                
            }
            else if (head.ucFlag == 4) { //离线消息最后一条
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:model];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SocketDidReceiveMessage object:model];
            }
            else { //在线消息
                
//                UIApplication *app = [UIApplication sharedApplication];
//
//                if (app.applicationState != UIApplicationStateActive) { //非活跃状态
                
                    if ([model2.noBother isEqualToNumber:@0]) { //非免打扰
                        
                        SystemSoundID soundID =1007;
                        
                        AudioServicesPlaySystemSound(soundID);
                    }
//                }

                //通知会话列表
                [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:model];
                //通知聊天室
                [[NSNotificationCenter defaultCenter] postNotificationName:SocketDidReceiveMessage object:model];
            }

        }

#pragma mark 推送
        else if (head.usCmdID == 7) { //推送消息
        
            /* 返回一个ACK数据包给服务器 */
            [self returnAckPackage:head];
            
            TFIMContentData *content = [TFIMContentData recievePushDataWithData:message];
            HQLog(@"收到推送消息:%@",content.pushMessage);
            //推送内容
            TFAssistantPushModel *pushModel = content.pushMessage;
            //查询列表是否存在该小助手
            TFFMDBModel *dbModel = [DataBaseHandle queryAssistantListDataWithChatId:pushModel.assistant_id];
            
            TFFMDBModel *assisDB = [DataBaseHandle queryAssistantDataListLastTime:pushModel.assistant_id];
            if (!assisDB.create_time) {
                
                return;
            }

            if ([pushModel.type isEqualToNumber:@1] || [pushModel.type isEqualToNumber:@10]) { //群操作 (解散群或被踢出群)
                
                //删除该群本地数据
                [DataBaseHandle deleteChatListDataWithChatId:pushModel.group_id];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReleaseGroupNotification object:pushModel];
                    
                });
                
            }
            //2.评论@他人 3.自定义推送 4.审批推送 5.文件库推送 6.同事圈提醒人 7.备忘录 8.邮件 25.个人任务 26.项目任务
            else if ([pushModel.type isEqualToNumber:@2] || [pushModel.type isEqualToNumber:@3] || [pushModel.type isEqualToNumber:@4] || [pushModel.type isEqualToNumber:@5] || [pushModel.type isEqualToNumber:@6] || [pushModel.type isEqualToNumber:@7] || [pushModel.type isEqualToNumber:@8] ||[pushModel.type isEqualToNumber:@25] || [pushModel.type isEqualToNumber:@26]) {
            
                [self updateAssistantDataWithModel:pushModel];
                
                //保存小助手列表数据到本地
                pushModel.read_status = @"0"; //后台居然没返回值，只能手动填充为未读了
                [self saveAssistantDataToDB:pushModel];
            }

            else if ([pushModel.type isEqualToNumber:@11]) { //群拉人
            
                TFFMDBModel *dbModel = [[TFFMDBModel alloc] init];
                dbModel.chatId = pushModel.group_id;
                
                [self updateAssistantDataWithModel:pushModel];
                dbModel.groupPeoples  = [dbModel.groupPeoples stringByAppendingString:[NSString stringWithFormat:@",%@",UM.userLoginInfo.employee.sign_id]];
                [DataBaseHandle updateChatListGroupPeoplesWithData:dbModel];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:nil];
                
            }
            else if ([pushModel.type isEqualToNumber:@13]) { //修改群名称
            
                [self updateAssistantDataWithModel:pushModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:ModifyGroupNameNotification object:nil];
                
            }
            else if ([pushModel.type isEqualToNumber:@15]) { //小助手置顶/取消置顶
                
                dbModel.isTop = @([pushModel.push_content integerValue]);
                
                [DataBaseHandle updateAssistantListIsTopWithData:dbModel];
                
            }
            else if ([pushModel.type isEqualToNumber:@16]) { //读单条消息
                
                dbModel.readStatus = pushModel.push_content;
                
                /* 1.会话列表对应小助手未读数-1 **/
                //查询该小助手的本地数据
//                TFFMDBModel *dbModel = [DataBaseHandle queryAssistantListDataWithChatId:pushModel.assistant_id];
                
                //未读数减1
                dbModel.unreadMsgCount = @([dbModel.unreadMsgCount integerValue]-1);
                if ([dbModel.unreadMsgCount integerValue] < 0) {
                    
                    dbModel.unreadMsgCount = @0;
                }
                //更新小助手列表未读数量
                [DataBaseHandle updateAssistantListUnReadWithData:dbModel];
                
                dbModel.id = pushModel.data_id;
                /** 2.小助手列表读取状态改为已读 */
                [DataBaseHandle updateAssistantListDataIsReadWithData:dbModel];
                
                //通知更新列表
                [[NSNotificationCenter defaultCenter] postNotificationName:AssistantUnreadNotification object:nil];
                
            }
            else if ([pushModel.type isEqualToNumber:@17]) { //读全部消息
                
                dbModel.readStatus = pushModel.push_content;
                /* 1.会话列表对应小助手未读数为0 **/
//                TFFMDBModel *dbModel = [DataBaseHandle queryAssistantListDataWithChatId:pushModel.assistant_id];
                
                //未读数减1
                dbModel.unreadMsgCount = @0;
                //更新小助手列表未读数量
                [DataBaseHandle updateAssistantListUnReadWithData:dbModel];
                
                /** 2.小助手列表读取状态改为已读 */
                [DataBaseHandle updateAssistantListDataAllReadWithData:dbModel];
                
                //通知更新列表
                [[NSNotificationCenter defaultCenter] postNotificationName:AssistantUnreadNotification object:nil];
                
            }
            else if ([pushModel.type isEqualToNumber:@18]) { //消息免打扰
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ModifyGroupNameNotification object:nil];
                
            }
            else if ([pushModel.type isEqualToNumber:@19]) { //只查看未读消息
                
                dbModel.showType = pushModel.push_content;
                [DataBaseHandle updateAssistantListShowTypeWithData:dbModel];
                
            }
            
            else if ([pushModel.type isEqualToNumber:@25]) { //个人任务
                
                
            }
            else if ([pushModel.type isEqualToNumber:@26]) { //项目任务
                
                
            }
            
            else if ([pushModel.type isEqualToNumber:@1000]) { //组织架构修改
            
                
            }
            else if ([pushModel.type isEqualToNumber:@1001]) {
                
                [[TFSocketManager sharedInstance] loginOutSocket];//发退出企信登陆包
                [UM loginOutAction];
                
            }
            else if ([pushModel.type isEqualToNumber:@1100]) {
                
                [[TFSocketManager sharedInstance] loginOutSocket];//发退出企信登陆包
                [UM loginOutAction];
                
            }
            
            /******          离线消息          ******/
            if (head.ucFlag == 3) { //离线消息
                
                
            }
            else if (head.ucFlag == 4) { //离线消息最后一条
                
//                SystemSoundID soundID =1008;
//                
//                AudioServicesPlaySystemSound(soundID);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:dbModel];
            }
            else { //在线消息
                
                if (![pushModel.type isEqualToNumber:@10]) { //踢人
                    
                    SystemSoundID soundID =1007;
                    
                    AudioServicesPlaySystemSound(soundID);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:dbModel];
                }
                
            }

        }
        
        else if (head.usCmdID == 11) { //单聊ack数据包
            
            NSMutableArray *recordArr = [DataBaseHandle queryAllChatRoomRecodeData];
            
            if (recordArr.count > 0) {
                
                
                for (TFFMDBModel *model in recordArr) {
                    
                    if ([model.msgId isEqualToString:messageId]) {
                        
                        TFFMDBModel *model2 = [[TFFMDBModel alloc] init];
                        model2.isRead = @0;
                        model2.msgId = messageId;
                        [DataBaseHandle updateChatRoomReadStateWithData:model2];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
                    }
                }
            }
            
            
            
        }
        else if (head.usCmdID == 12) { //群发成功ack数据包
            
            NSMutableArray *recordArr = [DataBaseHandle queryAllChatRoomRecodeData];
            
            if (recordArr.count > 0) {
                
                for (TFFMDBModel *model in recordArr) {
                    
                    if ([model.msgId isEqualToString:messageId]) {
                        
                        TFFMDBModel *model2 = [[TFFMDBModel alloc] init];
                        model2.isRead = @0;
                        model2.msgId = messageId;
                        [DataBaseHandle updateChatRoomReadStateWithData:model2];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
                    }
                }
            }

            
        }
        else if (head.usCmdID == 17) { //服务器返回给客户端的错误
            
            HQLog(@"服务器返回给客户端错误!");
            
            int32_t re = [TFIMLoginData loginResponseWithData:message];
            
            if (re == 106) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前帐号已在其他手机登录，如不是本人操作，请修改密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.delegate = self;
                [alert show];
                
                
            }
            
        }
        
#pragma mark 已读命令
//#define		IM_ALREADY_READ_PERSONAL_CHAT_CMD  18    //个人聊天消息已读
//#define		IM_ALREADY_READ_TEAM_CHAT_CMD     19    //群聊天消息已读

        else if (head.usCmdID == 18) { //
            
            /** 更新消息未已读状态 */
            TFFMDBModel *dbModel = [DataBaseHandle queryChatRecordDataWithMsgId:messageId];
            
            NSMutableArray *recordArr = [DataBaseHandle queryRecodeWithChatId:dbModel.chatId];
            
            for (TFFMDBModel *model in recordArr) {
                
                if ([model.isRead isEqualToNumber:@0]) {
                    
                    model.isRead = @1;
                    
                    [DataBaseHandle updateChatRoomReadStateWithData:model];
                    
                    
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
            
            
        }
        else if (head.usCmdID == 19) { //
            
            TFFMDBModel *dbModel = [DataBaseHandle queryChatRecordDataWithMsgId:messageId];
                
                NSMutableArray *arr = [DataBaseHandle queryRecodeWithChatId:dbModel.chatId];
                
                for (TFFMDBModel *model in arr) {
                    
                    //收到对应消息的已读命令
                    if ([model.msgId isEqualToString:messageId]) {
                        
                        if (![model.readPeoples isEqualToString:@""]) {
                            
                            NSArray  *array = [model.readPeoples componentsSeparatedByString:@","];
                            
                            //去重
                            BOOL have = NO;
                            for (NSString *peopleStr in array) {
                                
                                if (head.OneselfIMID == [peopleStr integerValue]) {
                                    
                                    have = YES;
                                    break;
                                }
                            }
                            
                            if (!have) {
                                
                                //保存已读人员
                                model.readPeoples = [model.readPeoples stringByAppendingString:[NSString stringWithFormat:@"%lld,",head.OneselfIMID]];
                                
                                [DataBaseHandle updateChatRoomReadPeoplesWithData:model];
                                
                                
                                //已读人数+1 并更新到数据库
                                model.readNumbers = @([model.readNumbers integerValue]+1);
                                
                                [DataBaseHandle updateChatRoomReadNumbersWithData:model];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
                            }

                        }
                        else {
                        
                            //保存已读人员
                            model.readPeoples = [model.readPeoples stringByAppendingString:[NSString stringWithFormat:@"%lld,",head.OneselfIMID]];
                            
                            [DataBaseHandle updateChatRoomReadPeoplesWithData:model];
                            
                            
                            //已读人数+1 并更新到数据库
                            model.readNumbers = @([model.readNumbers integerValue]+1);
                            
                            [DataBaseHandle updateChatRoomReadNumbersWithData:model];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
                        }
                        
                        
                    }
                }

        }
#pragma mark 获取历史消息
//#define		IM_PULL_HISTORY_MSG_CMD           20 //拉取历史消息,客户端发送过来
//#define		IM_PULL_HISTORY_PERSONAL_MSG_CMD  21   //返回个人历史消息
//#define		IM_PULL_HISTORY_TEAM_MSG_CMD      22   //返回群历史消息
//#define		IM_PULL_HISTORY_MSG_END_CMD       23  //返回拉取历史消息全部完成

        else if (head.usCmdID == 20) {
            
            TFIMHIstoryContentData *IMHistory = [TFIMHIstoryContentData receiveHistoryData:message];
            
            HQLog(@"收到历史消息:%@",IMHistory.historyData);
            if (IMHistory.historyData == nil) {
                
                return;
            }
            
            
            uint8_t msgType = [TFIMHIstoryContentData historyInfoTypeData:message];
            uint16_t sumCount = [TFIMHIstoryContentData historyInfoSumcountData:message];
            uint16_t nowCount = [TFIMHIstoryContentData historyInfoNowcountData:message];
            
            TFChatMsgModel *chatMsgModel = IMHistory.historyData;
            /************ 本地数据库消息存储 ***********/
            
            TFFMDBModel *model = [[TFFMDBModel alloc] init];
            model.chatFileType = chatMsgModel.type;
            model.content = chatMsgModel.fileUrl?chatMsgModel.fileUrl:chatMsgModel.msg;
            model.chatId = chatMsgModel.chatId;
            model.voiceDuration = chatMsgModel.duration;
            model.senderName = chatMsgModel.senderName;
            model.receiverName = chatMsgModel.senderName;
            model.senderAvatarUrl = chatMsgModel.senderAvatar;
            model.avatarUrl = chatMsgModel.senderAvatar;
            
            model.fileName = chatMsgModel.fileName;
            model.fileSize = chatMsgModel.fileSize;
            model.fileSuffix = chatMsgModel.fileType;
            model.fileUrl = chatMsgModel.fileUrl;
            model.videoUrl = chatMsgModel.fileUrl;
            model.fileId = chatMsgModel.fileId;
            
            model.clientTimes = @(head.clientTimes);
            model.senderID = @(head.senderID);
            model.RAND = @(head.RAND);
            model.receiverID = @(head.receiverID);
            model.companyId = UM.userLoginInfo.company.id;
            
            model.draft = @"";
            model.msgId = messageId;
            model.isHide = @0;
            
            if (msgType == 1) {
                
                model.chatType = @(2);
            }
            else if (msgType == 2) {
            
                model.chatType = @(1);
            }
            
            [DataBaseHandle addRecordWithContent:model];
            [DataBaseHandle updateChatListWithData:model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:nil];
        }
        else if (head.usCmdID == 21) {
            
            
        }
        else if (head.usCmdID == 22) {
            
            
        }
        else if (head.usCmdID == 23) {
            
            
        }
#pragma mark 撤销命令
//        命令id:     24  //撤销个人聊天
//        命令id:        25  //撤销个人聊天成功 <-----------------------服务器返回的成功命令
//        命令id:     26  //撤销群聊天
//        命令id:        27  //撤销群聊天成功  <------------------------服务器返回的成功命令

        else if (head.usCmdID == 24) {

            TFFMDBModel *model = [[TFFMDBModel alloc] init];
            
            model.msgId = messageId;
            model.content = @"对方撤回了一条消息";
            model.chatType = @2;
            model.chatFileType = ChatTypeWithTip;
            
            [DataBaseHandle UPDATEChatRoomDataWithMsgId:model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:nil];
        }
        else if (head.usCmdID == 25) {
            
            NSLog(@"撤销成功！");
            
            TFFMDBModel *model = [[TFFMDBModel alloc] init];
            
            model.msgId = messageId;
            model.content = @"你撤回了一条消息";
            model.chatType = @2;
            model.chatFileType = ChatTypeWithTip;
            
            [DataBaseHandle UPDATEChatRoomDataWithMsgId:model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatListWithNotification object:nil];
            
        }
        else if (head.usCmdID == 26) {
            
            TFFMDBModel *dbModel = [DataBaseHandle queryChatRecordDataWithMsgId:messageId];
            
            TFFMDBModel *model = [[TFFMDBModel alloc] init];
            
            model.msgId = messageId;
            model.content = [NSString stringWithFormat:@"%@撤回了一条消息",dbModel.senderName];
            model.chatType = @1;
            model.chatFileType = ChatTypeWithTip;
            
            [DataBaseHandle UPDATEChatRoomDataWithMsgId:model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
        }
        else if (head.usCmdID == 27) {
            
            NSLog(@"撤销成功！");
            
            TFFMDBModel *model = [[TFFMDBModel alloc] init];
            
            model.msgId = messageId;
            model.content = @"你撤回了一条消息";
            model.chatType = @1;
            model.chatFileType = ChatTypeWithTip;
            
            [DataBaseHandle UPDATEChatRoomDataWithMsgId:model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshChatRoomDataWithNotification object:nil];
        }
    }
}

#pragma mark 发送聊天数据
/**  发送聊天消息方法
 *
 * @param cmdType 命令类型 1:群聊 2:单聊
 * @param receiverId 聊天对象 （群聊时为群id，单聊时为接收者id）
 * @param chatId 会话id
 * @param text 文本聊天内容
 * @param msgType 消息类型 1:文本 2:图片 3:语音 4:文件 5:小视频 6:位置 7:提示
 * @param datas 后台返回图片、小视频数据
 * @param atList @的人
 */
- (void)sendMsgData:(NSInteger)cmdType receiverId:(NSNumber *)receiverId chatId:(NSNumber *)chatId text:(NSString *)text msgType:(NSNumber *)msgType datas:(NSArray *)datas atList:(NSArray *)atList voiceTime:(NSNumber *)voiceTime {

    HQLog(@"self.socketReadyState=======%ld",(long)self.socketReadyState);
    NSInteger singleOrGroup;
    
    if (cmdType == 1) { //单聊还是群聊
        
        singleOrGroup = groupChat;
    }
    else {
    
        singleOrGroup = singleChat;
    }
        
    TFIMHeadData *imData = [[TFIMHeadData alloc] init];

    imData.OneselfIMID = [UM.userLoginInfo.employee.sign_id  integerValue];
    imData.usCmdID = singleOrGroup;
    imData.ucVer = 1;
    imData.ucDeviceType = iOSDevice;
    imData.senderID = [UM.userLoginInfo.employee.sign_id  integerValue];
    imData.receiverID = [receiverId integerValue];

    TFIMContentData *content = [TFIMContentData recieveContentDataWithData:[imData data]];
    
    //消息发送模型
    TFChatMsgModel *msgModel = [[TFChatMsgModel alloc] init];
    
    /** 文本消息或者提示消息 */
    if ([msgType isEqualToNumber:ChatTypeWithText] || [msgType isEqualToNumber:ChatTypeWithTip]) {

        msgModel.msg = text;
        
        //@他人
        if (atList.count != 0) {
            
            msgModel.atList = atList;
        }
    }
    /** 图片、语音、文件、视频 */
    else if ([msgType isEqualToNumber:ChatTypeWithImage] || [msgType isEqualToNumber:ChatTypeWithVoice]|| [msgType isEqualToNumber:ChatTypeWithDocuments]) {
        
        for (TFFileModel *fileModel in datas) {
            
            msgModel.fileUrl = fileModel.file_url;
            msgModel.fileName = fileModel.file_name;
            msgModel.fileSize = fileModel.file_size;
            msgModel.fileType = fileModel.file_type;
            msgModel.fileId = fileModel.fileId;
            

        }

    }
    else if ([msgType isEqualToNumber:ChatTypeWithVideo]) { //视频
    
        for (TFFileModel *fileModel in datas) {
            
            msgModel.videoUrl = fileModel.file_url;
            msgModel.fileUrl = fileModel.video_thumbnail_url;
            msgModel.fileName = fileModel.file_name;
            msgModel.fileSize = fileModel.file_size;
            msgModel.fileType = fileModel.file_type;
            msgModel.fileId = fileModel.id;
            
            
        }
    }
    
    msgModel.type = msgType;
    msgModel.chatId = chatId;
    
    //录音
    if ([voiceTime integerValue]>0) {
        
        msgModel.duration = voiceTime;
    }

    
    msgModel.senderName = UM.userLoginInfo.employee.employee_name;
    msgModel.senderAvatar = UM.userLoginInfo.employee.picture;
    
    content.content = msgModel;
    
    //发送
    [self sendData:[content sendContentDataWithHeader:[imData data]]];
    
    
    TFChatMsgModel *fileModel = content.content;
    
    //消息存储模型
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    model.chatFileType = msgType;
    model.content = fileModel.fileUrl?fileModel.fileUrl:fileModel.msg;
    
    model.clientTimes = @(content.clientTimes);
    if (content.clientTimes <= 0) {
        
        model.clientTimes = @([HQHelper getNowTimeSp]);
    }
    
    model.chatId = chatId;
//    model.videoUrl = fileModel.videoUrl;
    model.companyId = UM.userLoginInfo.company.id;
    model.chatType = @(cmdType);
    model.draft = @"";
    model.fileSuffix = msgModel.fileType;
    model.RAND = @(content.RAND);
//    if (self.socketReadyState == 1) {
    
        model.isRead = @2;
//    }
//    else {
//        model.isRead = @3;
//    }
    model.msgId = [NSString stringWithFormat:@"%@%@",model.clientTimes,model.RAND];
    model.readNumbers = @0;
    model.voiceDuration = msgModel.duration;
    model.unreadMsgCount = @0;
    
    model.fileName = fileModel.fileName;
    model.fileSize = fileModel.fileSize;
    model.fileUrl = msgModel.fileUrl;
    model.fileId = fileModel.fileId;
    model.videoUrl = msgModel.videoUrl;
    
    model.senderID = @(content.senderID);
    model.receiverID = receiverId;
    model.senderName = fileModel.senderName;
    model.senderAvatarUrl = UM.userLoginInfo.employee.picture;
    
    model.isHide = @0;

    
    /**        判断显不显示时间        */
    TFFMDBModel *timeModel = [DataBaseHandle queryRecodeLastTime:model.chatId]; //查数据库最后一条数据的时间戳
    if (timeModel) {
        
        if ([model.clientTimes longLongValue]>[timeModel.clientTimes longLongValue]+3*60*1000) {
            
            model.showTime = @1;
        }
        else {
            model.showTime = @0;
        }
    }
    else {
    
        model.showTime = @1;
    }
    
    //将数据存入聊天室数据库
    [DataBaseHandle addRecordWithContent:model];
    
    //根据会话id查会话列表数据
    TFFMDBModel *model2 = [DataBaseHandle queryChatListDataWithChatId:chatId];
    
    if (model2) {
        
        if ([model2.chatId isEqualToNumber:chatId]) {
            
            [DataBaseHandle updateChatListWithData:model];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:SocketDidReceiveMessage object:model];

}

#pragma mark 发送退群消息
/** 退群专用 */
- (void)sendQuitGroupData:(NSNumber *)receiverId chatId:(NSNumber *)chatId text:(NSString *)text msgType:(NSNumber *)msgType {
    
    TFIMHeadData *imData = [[TFIMHeadData alloc] init];
    
    imData.OneselfIMID = [UM.userLoginInfo.employee.sign_id  integerValue];
    imData.usCmdID = 6;
    imData.ucVer = 1;
    imData.ucDeviceType = iOSDevice;
    imData.senderID = [UM.userLoginInfo.employee.sign_id  integerValue];
    imData.receiverID = [receiverId integerValue];
    imData.ucFlag = 5;
    
    //
    TFIMContentData *content = [TFIMContentData recieveContentDataWithData:[imData data]];
    
    //消息发送模型
    TFChatMsgModel *msgModel = [[TFChatMsgModel alloc] init];

    msgModel.type = msgType;
    msgModel.chatId = chatId;
    msgModel.msg = text;
    msgModel.senderName = UM.userLoginInfo.employee.employee_name;
    msgModel.senderAvatar = UM.userLoginInfo.employee.picture;
    
    content.content = msgModel;
    
    //发送
    [self sendData:[content sendContentDataWithHeader:[imData data]]];
    
    TFChatMsgModel *fileModel = content.content;
    
    //消息存储模型
    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    model.chatFileType = msgType;
    model.content = fileModel.fileUrl?fileModel.fileUrl:fileModel.msg;
    model.clientTimes = @(content.clientTimes);
    model.chatId = chatId;
    model.companyId = UM.userLoginInfo.company.id;
    model.chatType = @(1);
    model.RAND = @(content.RAND);
    model.isRead = @2;
    model.msgId = [NSString stringWithFormat:@"%@%@",model.clientTimes,model.RAND];
    model.readNumbers = @0;
    model.voiceDuration = msgModel.duration;
    
    model.senderID = @(content.senderID);
    model.receiverID = receiverId;
    model.senderName = fileModel.senderName;
    model.senderAvatarUrl = UM.userLoginInfo.employee.picture;
    
    TFFMDBModel *timeModel = [DataBaseHandle queryRecodeLastTime:model.chatId]; //查数据库最后一条数据的时间戳
    
    if (timeModel) {
        
        if ([model.clientTimes longLongValue]>[timeModel.clientTimes longLongValue]+3*60*1000) {
            
            model.showTime = @1;
        }
        else {
            
            model.showTime = @0;
        }

    }
    else {
        
        model.showTime = @1;

        
    }
    
    
    //将数据存入聊天室数据库
    [DataBaseHandle addRecordWithContent:model];
    
    
    //根据会话id查会话列表数据
    TFFMDBModel *model2 = [DataBaseHandle queryChatListDataWithChatId:chatId];
    
    if (model2) {
        
        if ([model2.chatId isEqualToNumber:chatId]) {
            
            [DataBaseHandle updateChatListWithData:model];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:model];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SocketDidReceiveMessage object:model];
    
}

#pragma mark 拉取历史记录
- (void)getHistoryRecordData:(NSNumber *)msgType chatId:(NSNumber *)chatId timeSp:(NSNumber *)timeSp Count:(NSInteger)Count {
    
    TFIMHistoryData *imHistoryData = [[TFIMHistoryData alloc] init];
    
    imHistoryData.OneselfIMID = [UM.userLoginInfo.employee.sign_id  integerValue];
    imHistoryData.usCmdID = 20;
    imHistoryData.ucVer = 1;
    imHistoryData.ucDeviceType = iOSDevice;
    imHistoryData.senderID = [UM.userLoginInfo.employee.sign_id  integerValue];
    imHistoryData.receiverID = [UM.userLoginInfo.employee.sign_id  integerValue];
    
    imHistoryData.MsgType = [msgType integerValue];
    imHistoryData.Id = [chatId integerValue];
    imHistoryData.Timestamp = [timeSp integerValue];
    imHistoryData.Count = Count;
    
    //发送
    [self sendData:[imHistoryData data]];
    
    
}

#pragma mark --------------------------本地方法----------------------------

#pragma mark 企信登录状态
- (void)qixinLoginStatus:(id)message {
    
    int32_t re = [TFIMLoginData loginResponseWithData:message];
    //登录成功
    if (re==0) {
        HQLog(@"登陆成功！");
    }
    //登录错误
    else if (re == -101) {//发送的登录数据包长度不够
        HQLog(@"发送的登录数据包长度不够！");
    }
    else if (re == -102) {//用户名和imid都没填充
        HQLog(@"用户名和imid都没填充！");
    }
    else if (re == -103) {//用户名查询不存在
        HQLog(@"用户名查询不存在！");
    }
    else if (re == -104) {//imid查询不存在
        HQLog(@"imid查询不存在！");
    }
    else if (re == -105) {//设备类型不识别
        HQLog(@"设备类型不识别！");
    }
}

#pragma mark 接收在线／离线消息成功，返回一个ACK数据包给服务器
- (void)returnAckPackage:(TFIMHeadData *)head {
    
    NSInteger usCmdID = 0;
    if (head.usCmdID == 5) { //单聊ack
        usCmdID = 11;
    }
    else if (head.usCmdID == 6) { //群聊ack
        usCmdID = 12;
    }
    else if (head.usCmdID == 7) { //推送ack
        usCmdID = 9;
    }
    
    TFIMHeadData *imData = [[TFIMHeadData alloc] init];
    imData.OneselfIMID = [UM.userLoginInfo.employee.sign_id integerValue];
    imData.usCmdID = usCmdID;
    imData.ucVer = 1;
    imData.ucDeviceType = iOSDevice;
    imData.senderID = head.senderID;
    imData.receiverID = head.receiverID;
    imData.clientTimes = head.clientTimes;
    imData.RAND = head.RAND;
    
    [self sendData:[imData data]];
}

#pragma mark 避免收到重复消息
- (void)avoidRepetitionMessage:(TFFMDBModel *)model {
    
    //查询聊天室所有数据
    NSArray *records = [DataBaseHandle queryRecodeWithChatId:model.chatId];
    
    BOOL have = NO;
    for (TFFMDBModel *dbModel in records) {
        
        if ([model.msgId isEqualToString:dbModel.msgId]) {
            
            have = YES;
            break;
        }
        
    }
    
    if (!have) {
        //将接收到的消息存入聊天时数据库
        [DataBaseHandle addRecordWithContent:model];
    }
}

#pragma mark 用户被挤下线
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    [self socketClose];//关闭连接
    [UM loginOutAction];
}


#pragma mark 收到推送更新小助手数据
/** 收到推送更新小助手数据 */
- (void)updateAssistantDataWithModel:(TFAssistantPushModel *)pushModel {
    
    //查询列表是否存在该小助手
    TFFMDBModel *dbModel = [DataBaseHandle queryAssistantListDataWithChatId:pushModel.assistant_id];
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    //修改会话列表小助手隐藏状态为不隐藏
    [self.chatBL requestHideSessionWithStatus:pushModel.assistant_id chatType:@3 status:@0];
    dbModel.isHide = @0;
    
    dbModel.latest_push_time = pushModel.create_time;
    dbModel.unreadMsgCount = @([dbModel.unreadMsgCount integerValue]+1);
    dbModel.latest_push_content = pushModel.push_content;
    
    //更新会话列表小助手数据
    [DataBaseHandle updateAssistantListDataWithModel:dbModel];
    
    //通知更新小助手列表
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateAssistantListDataNotification object:nil];
}

#pragma mark 判断时间是否显示
- (void)timeIsShow:(TFFMDBModel *)model {
    /** 查数据库最后一条数据的时间戳(判断时间是否显示) */
    TFFMDBModel *timeModel = [DataBaseHandle queryRecodeLastTime:model.chatId];
    
    if (timeModel) { //有聊天数据
        
        //消息间隔大于3分钟
        if ([model.clientTimes longLongValue]>[timeModel.clientTimes longLongValue]+3*60*1000) {
            
            //显示
            model.showTime = @1;
        }
        else {
            
            //不显示
            model.showTime = @0;
        }
        
    }
    else { //没有聊过天
        
        model.showTime = @1;
    }
}

#pragma mark 保存单聊群聊数据到本地数据库
- (void)saveChatMessageDataToDB {
    
    
}

#pragma mark 保存小助手数据到本地数据库
- (void)saveAssistantDataToDB:(TFAssistantPushModel *)pushModel {
    
    TFFMDBModel *fm = [[TFFMDBModel alloc] init];
    fm.id = pushModel.id;
    fm.companyId = UM.userLoginInfo.company.id;
    fm.assistantId = pushModel.assistant_id;
    fm.myId = UM.userLoginInfo.employee.id;
    fm.dataId = pushModel.data_id;
    fm.type = [pushModel.type stringValue];
    fm.pushContent = pushModel.push_content;
    fm.beanName = pushModel.bean_name;
    fm.beanNameChinese = pushModel.bean_name_chinese;
    fm.create_time = pushModel.create_time;
    fm.readStatus = pushModel.read_status;
    fm.style = pushModel.style;
    fm.param_fields = [pushModel.param_fields toJSONString];
    
    fm.icon_url = pushModel.icon_url;
    fm.icon_color = pushModel.icon_color;
    fm.icon_type = pushModel.icon_type;
    
    if ([pushModel.type isEqualToNumber:@4]) {
        
        fm.dataId = pushModel.param_fields.dataId;
    }
    
    //自定义字段
    if ([pushModel.type isEqualToNumber:@3]) {
        
        if (pushModel.field_info.count > 0) {
            
            for (int i=0; i<pushModel.field_info.count; i++) {
                
                TFAssistantFieldInfoModel *filedModel = pushModel.field_info[i];
                
                if (i == 0) {
                    
                    fm.oneRowValue = [HQHelper stringWithAssistantFieldInfoModel:filedModel];
                }
                else if (i == 1) {
                    
                    fm.twoRowValue = [HQHelper stringWithAssistantFieldInfoModel:filedModel];
                }
                else if (i == 2) {
                    
                    fm.threeRowValue = [HQHelper stringWithAssistantFieldInfoModel:filedModel];;
                }
            }
        }
    }
    
    [DataBaseHandle insertIntoAssistantDataListTable:fm];
    
}

/*
 - (void)localNotification:(NSString *)content {
 
 // 1.创建本地通知
 UILocalNotification *localNote = [[UILocalNotification alloc] init];
 
 // 2.设置本地通知的内容
 // 2.1.设置通知发出的时间
 localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
 // 2.2.设置通知的内容
 localNote.alertBody = content;
 // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
 //localNote.alertAction = @"解锁";
 // 2.4.决定alertAction是否生效
 //localNote.hasAction = NO;
 // 2.5.设置点击通知的启动图片
 //localNote.alertLaunchImage = @"123Abc";
 // 2.6.设置alertTitle
 localNote.alertTitle = @"你有一条新通知";
 // 2.7.设置有通知时的音效
 localNote.soundName = UILocalNotificationDefaultSoundName;
 // 2.8.设置应用程序图标右上角的数字
 localNote.applicationIconBadgeNumber = 1;
 
 // 2.9.设置额外信息
 localNote.userInfo = @{@"type" : @1};
 
 // ios8后，需要添加这个注册，才能得到授权
 if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
 UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
 UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
 categories:nil];
 [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
 // 通知重复提示的单位，可以是天、周、月
 }
 
 // 3.调用通知
 [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
 //            [[UIApplication sharedApplication] presentLocalNotificationNow:localNote];
 }
 */

@end
