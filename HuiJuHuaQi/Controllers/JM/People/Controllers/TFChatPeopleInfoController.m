//
//  TFChatPeopleInfoController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatPeopleInfoController.h"
#import "HQTFMeHearder.h"
#import "HQSelectTimeCell.h"
#import "HQTFMorePeopleCell.h"
#import "TFCompanyCircleAlbumController.h"
#import "TFChatPeopleDetailModel.h"
#import "TFCompanyCircleBL.h"
#import "TFCircleEmployModel.h"
#import "HQConversationController.h"
#import "TFPeopleBL.h"

#import "TFChatBL.h"
#import "TFChatInfoListModel.h"
#import "TFChatViewController.h"

#define OffsetHeight 200
@interface TFChatPeopleInfoController ()<UITableViewDelegate,UITableViewDataSource,HQTFMeHearderDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFCompanyCircleBL */
@property (nonatomic, strong) TFCompanyCircleBL *companyCircleBL;

/**  meHeader */
@property (nonatomic, weak) HQTFMeHearder *meHeader;

/** HQEmployModel */
@property (nonatomic, strong) TFCircleEmployModel *employeeDetail;

/** TFLoginBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

@property (nonatomic, strong) TFChatBL *chatBL;

@end

@implementation TFChatPeopleInfoController

-(TFCircleEmployModel *)employeeDetail{
    if (!_employeeDetail) {
        _employeeDetail = [[TFCircleEmployModel alloc] init];
        _employeeDetail.picture = self.employee.picture;
        _employeeDetail.employeeName = self.employee.employeeName;
        _employeeDetail.companyName = UM.userLoginInfo.company.company_name;
        _employeeDetail.email = self.employee.email;
        _employeeDetail.mobile_phone = self.employee.mobile_phone;
    }
    return _employeeDetail;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"返回白色" highlightImage:@"返回白色"];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    NSNumber *myId = self.employee.id?self.employee.id:self.employee.employeeId;
    if ([myId isKindOfClass:[NSString class]]) {
        myId = [NSNumber numberWithLongLong:[myId longLongValue]];
    }
    
    [self.peopleBL requestEmployeeDetailWithEmployeeId:myId];
    
    if ([myId isEqualToNumber:@([UM.userLoginInfo.employee.id integerValue])]) {
        self.isMyself = YES;
    }
    
    
    if (self.isMyself == NO) {
        [self setupTwoBtn];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    if (resp.cmdId == HQCMD_getEmployeeDetail || resp.cmdId == HQCMD_messageGetEmployee || resp.cmdId == HQCMD_companyCirclePeopleDetail) {
//        
//        self.employeeDetail = resp.body;
//        
//        self.meHeader.name.text = self.employeeDetail.employeeName;
//        [self.meHeader.headImage sd_setImageWithURL:[HQHelper URLWithString:self.employeeDetail.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//        self.meHeader.personSignature = self.employeeDetail.personSignature;
//    }
    
    if (resp.cmdId == HQCMD_employeeDetail) {
        
        NSDictionary *company = [[resp.body valueForKey:@"companyInfo"] nullProcess];
        NSDictionary *employee = [[resp.body valueForKey:@"employeeInfo"] nullProcess];
        NSArray *departments = [[resp.body valueForKey:@"departmentInfo"] nullProcess];
        NSArray *photos = [[resp.body valueForKey:@"photo"] nullProcess];
        
        NSMutableArray<TFFileModel> *ps = [NSMutableArray<TFFileModel> array];
        for (NSDictionary *d in photos) {
            
            TFFileModel *file = [[TFFileModel alloc] initWithDictionary:d error:nil];
            if (file) {
                [ps addObject:file];
            }
        }
        
        self.employeeDetail.id =  [employee valueForKey:@"id"];
        self.employeeDetail.sign_id =  [employee valueForKey:@"sign_id"];
        self.employeeDetail.employeeName =  [employee valueForKey:@"employee_name"];
        self.employeeDetail.companyName =  [company valueForKey:@"company_name"];
        self.employeeDetail.personSignature = [employee valueForKey:@"sign"];
        self.employeeDetail.picture = [employee valueForKey:@"picture"];
        
        NSString *str = @"";
        for (NSDictionary *de in departments) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[de valueForKey:@"department_name"]]];
        }
        if (str.length) {
            
            self.employeeDetail.departmentName = [str substringToIndex:str.length-1];
        }else{
            
            self.employeeDetail.departmentName = str;
        }
        self.employeeDetail.mobile_phone = [employee valueForKey:@"phone"];
        self.employeeDetail.photoes = ps;
        
        
        self.meHeader.name.text = self.employeeDetail.employeeName;
        self.meHeader.companyBtn.hidden = YES;
        [self.meHeader.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:self.employeeDetail.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//        self.meHeader.personSignature = self.employeeDetail.personSignature;
        
    }
    
    if (resp.cmdId == HQCMD_addSingleChat) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        TFChatInfoListModel *model = resp.body;
        TFChatViewController *send = [[TFChatViewController alloc] init];
        
        send.cmdType = [model.chat_type integerValue];
        send.chatId = model.id;
        send.receiveId = [model.receiver_id integerValue];
        
        send.naviTitle = model.employee_name;
        send.picture = model.picture;
        
        
        TFFMDBModel *dd = [model chatListModel];
        dd.mark = @3;
        [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:dd];
        
        [self.navigationController pushViewController:send animated:YES];
    }
    
    [self.tableView reloadData];
    
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


#pragma mark - 两个按钮
- (void)setupTwoBtn{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-60,SCREEN_WIDTH,60}];
    view.backgroundColor = WhiteColor;
    [self.view addSubview:view];
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH/2 * i,0,SCREEN_WIDTH/2,60} target:self action:@selector(btnClicked:)];
        [view addSubview:btn];
        btn.tag = 0x123 + i;
        btn.titleLabel.font = FONT(20);
        
        if (i == 0) {
            [btn setTitle:@" 发消息" forState:UIControlStateNormal];
            [btn setTitle:@" 发消息" forState:UIControlStateHighlighted];
            [btn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
            [btn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"聊天chat"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"聊天chat"] forState:UIControlStateNormal];
        }else{
            [btn setTitle:@" 通话" forState:UIControlStateNormal];
            [btn setTitle:@" 通话" forState:UIControlStateHighlighted];
            [btn setTitleColor:GreenColor forState:UIControlStateHighlighted];
            [btn setTitleColor:GreenColor forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"电话chat"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"电话chat"] forState:UIControlStateNormal];
        }
    }
    
    UIView *sepe = [[UIView alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2,15,0.5,30}];
    [view addSubview:sepe];
    sepe.backgroundColor = CellSeparatorColor;
}

- (void)btnClicked:(UIButton *)button{
    
    if (button.tag - 0x123 == 0) {// 发消息
        
//        [self createSingleConversationWithEmployee:self.employeeDetail];

        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        self.chatBL = [TFChatBL build];
        self.chatBL.delegate = self;
        
        //添加单聊
        [self.chatBL requestAddSingleChatWithData:self.employeeDetail.sign_id];
            
            
        
        
    }else{// 打电话
        [self calledPhone];
    }
}


-(void)createSingleConversationWithEmployee:(HQEmployModel *)employee{
    
    if (!employee.imUserName || employee.imUserName.length == 0) {
        return;
    }
    
    __block HQConversationController *sendMessageCtl =[[HQConversationController alloc] init];//!!
    //    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    __weak typeof(self)weakSelf = self;
    sendMessageCtl.superViewController = self;
    [JMSGConversation createSingleConversationWithUsername:employee.imUserName appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = resultObject;
            JCHATMAINTHREAD(^{
                sendMessageCtl.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            HQLog(@"createSingleConversationWithUsername");
        }
    }];
    
}

/**
 * 拨打电话号码
 */

-(void)calledPhone{
    
    //弹出电话号码的第1种方式
    if (self.employeeDetail.mobile_phone && [HQHelper checkTel:self.employeeDetail.mobile_phone]) {
        
        NSString *tel = self.employeeDetail.mobile_phone;
        
        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",tel];
        
        UIWebView *callWebview = [[UIWebView alloc]init];
        
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        
        [self.view addSubview:callWebview];
    }
    
    
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT+ 64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(OffsetHeight, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -OffsetHeight, SCREEN_WIDTH, OffsetHeight)];
    imageView.image = [UIImage imageNamed:@"个人中心底图"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 101;
    [self.tableView addSubview:imageView];
    
    HQTFMeHearder *meHeader = [HQTFMeHearder meHearder];
//    meHeader.type = 1;
    meHeader.delegate = self;
    meHeader.frame = CGRectMake(0, -OffsetHeight, SCREEN_WIDTH, OffsetHeight);
    [self.tableView addSubview:meHeader];
    self.meHeader = meHeader;
    
    
    self.meHeader.name.text = self.employee.employeeName?:self.employee.employee_name;
    self.meHeader.companyBtn.hidden = YES;
    [self.meHeader.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:self.employee.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//    self.meHeader.personSignature = self.employee.personSignature;
}


#pragma mark - HQTFMeHearderDelegate
- (void)meHeaderClickedPhoto {
    
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 背景图下拉放大
    CGPoint point = scrollView.contentOffset;
    if (point.y < -OffsetHeight) {
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < 4) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.arrowShowState = NO;
        cell.bottomLine.hidden = NO;
        cell.topLine.hidden = YES;
        
        if (indexPath.row == 0) {
            
            cell.timeTitle.text = @"公司";
            cell.time.text = self.employeeDetail.companyName;
        }else if (indexPath.row == 1){
            
            cell.timeTitle.text = @"部门";
            cell.time.text = self.employeeDetail.departmentName;
        }else if (indexPath.row == 2){
            
            cell.timeTitle.text = @"手机";
            cell.time.text = self.employeeDetail.mobile_phone;
        }else{
            
            cell.timeTitle.text = @"邮箱";
            cell.time.text = self.employeeDetail.email;
        }
        return  cell;
    }else{
        
        HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
        
        for (UIView *view in cell.contentView.subviews) {
            
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
        
        cell.bottomLine.hidden = YES;
        cell.titleLabel.text = @"个人相册";
        
        for (NSInteger i = 0; i < self.employeeDetail.photoes.count; i ++) {
            TFFileModel *file = self.employeeDetail.photoes[i];
            UIButton *button = [HQHelper buttonWithFrame:(CGRect){101 + Long(62)* i,0,Long(50),Long(50)} target:nil action:nil];
            [cell.contentView addSubview:button];
            button.userInteractionEnabled = NO;
            button.centerY = Long(80)/2;
            [button sd_setImageWithURL:[HQHelper URLWithString:file.file_url] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 4) {
        
        TFCompanyCircleAlbumController *companyCircle = [[TFCompanyCircleAlbumController alloc] init];
        companyCircle.employeeId = self.employeeDetail.id ? self.employeeDetail.id : self.employeeDetail.employeeId;
        [self.navigationController pushViewController:companyCircle animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return Long(80);
    }
    return 55;
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
