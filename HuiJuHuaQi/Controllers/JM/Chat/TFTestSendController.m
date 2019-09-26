//
//  TFTestSendController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/11/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTestSendController.h"
#import "TFSocketManager.h"
#import "TFIMHeadData.h"
#import "TFIMLoginData.h"
#import "TFIMContentData.h"

@interface TFTestSendController ()<UITextFieldDelegate>

@property (nonatomic, strong) TFSocketManager *socket;

@property (nonatomic, strong) TFIMHeadData *head;

@property (nonatomic, strong) UILabel *content;

@property (nonatomic, copy) NSString *contentStr;

@property (nonatomic, assign) uint16_t commond;

@property (nonatomic, assign) uint8_t device;

@property (nonatomic, assign) int64_t receive;

@end

@implementation TFTestSendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"聊天室";
    [self setupView];
    
    self.socket = [TFSocketManager sharedInstance];
}

- (void)setupView {

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loginButton.backgroundColor = RedColor;
    loginButton.frame = CGRectMake((SCREEN_WIDTH-60)/2, 30, 60, 40);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginServer) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius = 5.0;
    loginButton.layer.masksToBounds = YES;
    
    [self.view addSubview:loginButton];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2, 100, 300, 40)];
    
    field.placeholder = @"请输入";
    field.tag = 103;
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.delegate = self;
    [self.view addSubview:field];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake((SCREEN_WIDTH-60)/2, 150, 60, 40);
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendInfo) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5.0;
    button.layer.masksToBounds = YES;
    
    [self.view addSubview:button];
    
    /** 命令类型 */
    UILabel *commondLab = [UILabel initCustom:CGRectMake(50, 200, 80, 22) title:@"命令类型：" titleColor:GrayTextColor titleFont:14 bgColor:ClearColor];
    
    [self.view addSubview:commondLab];
    
    UITextField *commondTF = [[UITextField alloc] initWithFrame:CGRectMake(135, 200, 100, 22)];
    commondTF.delegate = self;
    commondTF.tag = 100;
    commondTF.keyboardType = UIKeyboardTypeNumberPad;
    commondTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:commondTF];
    
    /** 设备类型 */
    UILabel *deviceLab = [UILabel initCustom:CGRectMake(50, 230, 80, 22) title:@"设备类型：" titleColor:GrayTextColor titleFont:14 bgColor:ClearColor];
    
    [self.view addSubview:deviceLab];
    
    UITextField *deviceTF = [[UITextField alloc] initWithFrame:CGRectMake(135, 230, 100, 22)];
    deviceTF.delegate = self;
    deviceTF.tag = 101;
    deviceTF.keyboardType = UIKeyboardTypeNumberPad;
    deviceTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:deviceTF];
    
    /** 接收者 */
    UILabel *receiverLab = [UILabel initCustom:CGRectMake(50, 260, 80, 22) title:@"接收者：" titleColor:GrayTextColor titleFont:14 bgColor:ClearColor];
    
    [self.view addSubview:receiverLab];
    
    UITextField *receiveTF = [[UITextField alloc] initWithFrame:CGRectMake(135, 260, 100, 22)];
    receiveTF.delegate = self;
    receiveTF.tag = 102;
    receiveTF.borderStyle = UITextBorderStyleRoundedRect;
    receiveTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:receiveTF];
    
    //接收内容
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 300, 200, 100)];
    view.backgroundColor = LightGrayTextColor;
    
    [self.view addSubview:view];
    
    _content = [UILabel initCustom:CGRectMake(10, 10, 180, 40) title:@"" titleColor:BlackTextColor titleFont:14 bgColor:ClearColor];
    
    [view addSubview:_content];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    logoutButton.backgroundColor = [UIColor purpleColor];
    logoutButton.frame = CGRectMake((SCREEN_WIDTH-60)/2, 500, 60, 40);
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutServer) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.layer.cornerRadius = 5.0;
    logoutButton.layer.masksToBounds = YES;
    
    [self.view addSubview:logoutButton];
}

//发送聊天
- (void)sendInfo {

    if (self.socket.socketReadyState == SR_OPEN) {
        
        TFIMHeadData *imData = [[TFIMHeadData alloc] init];
        imData.OneselfIMID = 112;
        imData.usCmdID = self.commond;
        imData.ucVer = 1;
        imData.ucDeviceType = self.device;
        imData.senderID = 112;
        imData.receiverID = self.receive;
        
        TFIMContentData *content = [[TFIMContentData alloc] init];
        
        content.content = self.contentStr;
        //    NSData *data = [self.contentStr dataUsingEncoding:NSUTF8StringEncoding];
        //    //NSData -> NSString
        //    content.content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self.socket sendData:[content sendContentDataWithHeader:[imData data]]];
    }
    else {
    
        NSLog(@"发送失败！");
    }
    
}

//连接服务器
- (void)loginServer {

    
    [self.socket socketOpenIsReconnect:NO];//打开soket
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:SocketStatusNormal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:SocketDidReceiveMessage object:nil];
}

//退出登陆
- (void)logoutServer {

    [self.socket socketClose];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SocketStatusNormal object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SocketDidReceiveMessage object:nil];
}

//连接成功登陆
- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
    
    TFIMHeadData *imData = [[TFIMHeadData alloc] init];
    imData.OneselfIMID = 112;
    imData.usCmdID = 1;
    imData.ucVer = 1;
    imData.ucDeviceType = 2;
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
    
    [self.socket sendData:[login loginDataWithHeader:[imData data]]];
    
}

//接收服务器返回信息
- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    
    if (!message) {
        
        return;
    }
    
    NSLog(@"====message====%@====class===%@",message,[message.class description]);
    
    TFIMHeadData *head = [TFIMHeadData headerWithData:note.object];
    
    if (head.usCmdID == 1) { //登陆
        
        int32_t re = [TFIMLoginData loginResponseWithData:note.object];
        
        //登录错误
//        const int32_t IM_LOGIN_ERR_PACKET_LEN = -101;//发送的登录数据包长度不够
//        const int32_t IM_LOGIN_ERR_NO_IMID_AND_USERNAME = -102;	//用户名和imid都没填充
//        const int32_t IM_LOGIN_ERR_USER_QUERY_FAIL = -103;	//用户名查询不存在
//        const int32_t IM_LOGIN_ERR_IMID_QUERY_FAIL = -104;	//imid查询不存在
//        const int32_t IM_LOGIN_ERR_DEVICE_TYPE = -105;	//设备类型不识别
        if (re==0) {
            
            NSLog(@"登陆成功！");
        }
        else if (re == -101) {
        
            
        }
        else if (re == -102) {
            
            
        }
        else if (re == -103) {
            
            
        }
        else if (re == -104) {
            
            
        }
        else if (re == -105) {
            
            
        }
    }
    else if (head.usCmdID == 3) { //离线消息请求命令

    }
    else if (head.usCmdID == 5) { //单聊或离线消息
    
        TFIMContentData *content = [TFIMContentData recieveContentDataWithData:note.object];
        
        NSLog(@"收到消息content.content:%@",content.content);
        
        self.content.text = content.content;
        
        /** 接收在线／离线消息成功，返回一个ACK数据包给服务器 */
        TFIMHeadData *imData = [[TFIMHeadData alloc] init];
        imData.OneselfIMID = 112;
        imData.usCmdID = 11;
        imData.ucVer = 1;
        imData.ucDeviceType = 2;
        imData.senderID = head.senderID;
        imData.receiverID = head.receiverID;
        imData.clientTimes = head.clientTimes;
        imData.RAND = head.RAND;
        
        [self.socket sendData:[imData data]];
        
    }
    else if (head.usCmdID == 6) { //群聊或离线消息
        
        TFIMContentData *content = [TFIMContentData recieveContentDataWithData:note.object];
        
        NSLog(@"收到群聊消息content.content:%@",content.content);
        
        self.content.text = content.content;
        
        /** 接收群在线／离线消息成功，返回一个ack数据包给服务器 */
        TFIMHeadData *imData = [[TFIMHeadData alloc] init];
        imData.OneselfIMID = 112;
        imData.usCmdID = 12;
        imData.ucVer = 1;
        imData.ucDeviceType = 2;
        imData.senderID = head.senderID;
        imData.receiverID = head.receiverID;
        imData.clientTimes = head.clientTimes;
        imData.RAND = head.RAND;
        
        [self.socket sendData:[imData data]];
        
    }
    else if (head.usCmdID == 11) { //单聊ack数据包

//        NSLog(@"发送成功!");

    }
    else if (head.usCmdID == 12) { //群发成功ack数据包
        
        NSLog(@"群发成功!");
        
    }
    
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    
    if (textField.tag == 100) {
        
        self.commond = [textField.text intValue];
    }
    if (textField.tag == 101) {
        
        self.device = [textField.text intValue];
    }
    if (textField.tag == 102) {
        
        self.receive = [textField.text intValue];
    }
    if (textField.tag == 103) {
        
        self.contentStr = textField.text;
    }
    
    
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    //这对于想要加入撤销选项的应用程序特别有用
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    //要防止文字被改变可以返回NO
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    
    
    return YES;
}


@end
