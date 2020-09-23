//
//  TFMeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMeController.h"
#import "HQTFChatCell.h"
#import "HQTFMeCell.h"
#import "TFCompanyCircleController.h"
#import "TFSendCompanyCircleController.h"
#import "HQSetViewController.h"
#import "TFMyCardView.h"
#import "TFMyBusinessCardController.h"
#import "HQPersonInfoVC.h"
#import "TFEditSignController.h"
#import "HQTFSelectCompanyController.h"
#import "TFTTTViewController.h"
#import "TFAttendanceTabbarController.h"
#import "TFKnowledgeListController.h"
#import "TFPCMapController.h"
#import "TFVersionViewController.h"

@interface TFMeController ()<UITableViewDelegate,UITableViewDataSource,HQTFChatCellDelegate,TFMyCardViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;
/** cellPictures */
@property (nonatomic, strong) NSMutableArray *cellPictures;

/** cardView */
@property (nonatomic, weak) TFMyCardView *cardView;

/** bg */
@property (nonatomic, weak) UIView *bg;

@property (nonatomic, weak) UILabel *evironment;
@end

@implementation TFMeController

- (NSMutableArray *)cellPictures{
    if (!_cellPictures) {
        _cellPictures = [NSMutableArray array];
        
        NSArray *names = @[@"我的收藏",@"在线帮助",@"关于Teamface",@"设置"];
        NSArray *images = @[@"我的收藏",@"在线帮助",@"关于Me",@"设置Me"];
        
        for (int i = 0; i < names.count; i ++) {
            HQTFCoopItemModel *item = [[HQTFCoopItemModel alloc] init];
            item.image = images[i];
            item.name = names[i];
            [_cellPictures addObject:item];
        }
    }
    return _cellPictures;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    [self.navigationController.navigationBar setTranslucent:YES];

}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        id _statusBar = nil;
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *_localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([_localStatusBar respondsToSelector:@selector(statusBar)]) {
                _statusBar = [_localStatusBar performSelector:@selector(statusBar)];
            }
        }
    } else {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = color;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self setStatusBarBackgroundColor:ClearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.view.backgroundColor = WhiteColor;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.backgroundView = [UIView new];
    UIView *bg = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,220}];
    bg.backgroundColor = WhiteColor;
    [tableView.backgroundView addSubview:bg];
    self.bg = bg;
    
    TFMyCardView *cardView = [TFMyCardView myCardView];
    cardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
    cardView.delegate = self;
    tableView.tableHeaderView = cardView;
    [cardView refreshMyCardView];
    cardView.companyLabel.hidden = YES;
    self.cardView = cardView;
    
#ifdef DEBUG // 调试状态, 打开LOG功能
#if ShowNameOfController
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,140}];
    UILabel *version = [[UILabel alloc] initWithFrame:(CGRect){0,10,SCREEN_WIDTH,40}];
    version.text = [NSString stringWithFormat:@"版本号：%@",[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    version.textAlignment = NSTextAlignmentCenter;
    [view addSubview:version];
    UILabel *evironment = [[UILabel alloc] initWithFrame:(CGRect){0,50,SCREEN_WIDTH,40}];
    evironment.text = [NSString stringWithFormat:@"服务器：%@",[AppDelegate shareAppDelegate].baseUrl];
    evironment.textAlignment = NSTextAlignmentCenter;
    [view addSubview:evironment];
    self.evironment = evironment;
    UILabel *time = [[UILabel alloc] initWithFrame:(CGRect){0,90,SCREEN_WIDTH,40}];
    time.text = [NSString stringWithFormat:@"时间：%@",CurrentTime];
    time.textAlignment = NSTextAlignmentCenter;
    [view addSubview:time];
    tableView.tableFooterView = view;
#endif
#endif
    
}

#pragma mark - TFMyCardViewDelegate
-(void)clickedCompanyBtn{
    
    HQTFSelectCompanyController *select = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
}
-(void)clickedHeadBtn{
    
    HQPersonInfoVC *personInfoVC = [[HQPersonInfoVC alloc] init];
    
    personInfoVC.refresh = ^(id parameter) {
        
        [self.cardView refreshMyCardView];
    };
    [self.navigationController pushViewController:personInfoVC animated:YES];

}
-(void)clickedDescriptBtn{
    
    TFEditSignController *sign = [[TFEditSignController alloc] init];
    
    sign.sign = UM.userLoginInfo.employee.sign;
    sign.emoStr = UM.userLoginInfo.employee.mood;
    sign.refreshAction = ^(NSDictionary *parameter) {
        
        [CDM saveEmployeeMood:[parameter valueForKey:@"emotion"] sign:[parameter valueForKey:@"sign"]];
        
        [self.cardView refreshMyCardView];
    };
    [self.navigationController pushViewController:sign animated:YES];
    
    
//    self.emotion.attributedText = [self attributedStringWithText:model.employeeInfo.mood font:14];
}

/** 普通文本转成带表情的属性文本 */
- (NSAttributedString *)attributedStringWithText:(NSString *)text font:(CGFloat)font{
    
    return [LiuqsDecoder decodeWithPlainStr:text font:[UIFont systemFontOfSize:font]];
}
-(void)clickedEnterBtn{
    
    TFMyBusinessCardController *myCardVC = [[TFMyBusinessCardController alloc] init];
    [self.navigationController pushViewController:myCardVC animated:YES];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQTFChatCell *cell = [HQTFChatCell chatCellWithTableView:tableView];
        cell.chatCellType = ChatCellTypeCricle;
        cell.titleImage.image = IMG(@"新朋友圈");
        cell.titleName.text = @"同事圈";
        cell.titleName.textColor = BlackTextColor;
        cell.titleName.font = FONT(16);
        cell.titleImage.contentMode = UIViewContentModeCenter;
        cell.imgHW = 24;
        cell.delegate = self;
        cell.bottomLine.hidden = YES;
        return cell;
    }
    else {
        
        HQTFMeCell *cell = [HQTFMeCell meCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.bottomLine.hidden = YES;
        if (indexPath.section == 1 || indexPath.section == 2) {
            cell.bottomLine.hidden = NO;
            cell.headMargin = 50;
        }
        cell.item = self.cellPictures[indexPath.section - 1];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {// 企业圈
        
//        TFCompanyCircleController *companyCircle = [[TFCompanyCircleController alloc] init];
        
        [self.navigationController pushViewController:[AppDelegate shareAppDelegate].circleCtrl animated:YES];
        
    }
    if (indexPath.section == 1) {// 我的收藏
        [MBProgressHUD showError:@"敬请期待" toView:self.view];
  
//        TFPCMapController *attendanceTabbar = [[TFPCMapController alloc] init];
//        [self.navigationController pushViewController:attendanceTabbar animated:YES];
    }
    if (indexPath.section == 2) {//  在线帮助
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hc.teamface.cn/#/"]];
        
    }
    if (indexPath.section == 3) {// 关于Teamface
//        [MBProgressHUD showError:@"敬请期待" toView:self.view];
        TFVersionViewController *version = [[TFVersionViewController alloc] init];
        [self.navigationController pushViewController:version animated:YES];
    }
    if (indexPath.section == 4) {// 设置
        
        HQSetViewController *setVC = [[HQSetViewController alloc] init];
        [self.navigationController pushViewController:setVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 0;
    }
    return 52;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1 || section == 4) {
        return 8;
    }
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

#pragma mark HQTFChatCellDelegate
- (void)chatCellDidClickedCameraWithType:(ChatCellType)type {
    
    TFSendCompanyCircleController *sendCompany = [[TFSendCompanyCircleController alloc] init];
    [self.navigationController pushViewController:sendCompany animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point = scrollView.contentOffset;
    HQLog(@"%@",NSStringFromCGPoint(point));
    self.bg.height = 220 - point.y <= 0 ? 0 : 220 - point.y;
    
    HQLog(@"%f",self.bg.height);
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
