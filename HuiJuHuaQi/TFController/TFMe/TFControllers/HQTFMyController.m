//
//  HQTFMyController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/7/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFMyController.h"
#import "HQTFMeHearder.h"
#import "HQTFMeCell.h"
#import "HQSetViewController.h"

#import "HQTFSelectCompanyController.h"
#import "HQPersonInfoVC.h"
#import "TFTestH5Controller.h"
#import "HQEmployModel.h"
#import "TFCellImgBtnView.h"

#define OffsetHeight 284

@interface HQTFMyController ()<UITableViewDelegate,UITableViewDataSource,HQTFMeHearderDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;
/** cellPictures */
@property (nonatomic, strong) NSMutableArray *cellPictures;


@property (nonatomic, copy) NSString *signStr;

/** HQTFMeHearder *meHeader */
@property (nonatomic, strong) HQTFMeHearder *meHeader;


@end

@implementation HQTFMyController

- (NSMutableArray *)cellPictures{
    if (!_cellPictures) {
        _cellPictures = [NSMutableArray array];
        
        NSArray *names = @[@"当前公司",@"我的看板",@"关于Teamface",@"推荐Teamface"];
        NSArray *images = @[@"公司",@"我的看板",@"关于Me",@"推荐"];
        
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
    self.navigationController.navigationBar.hidden = YES;
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
    self.meHeader.name.text = UM.userLoginInfo.employee.employee_name;
//    self.meHeader.descri.text = _signStr;
    [self.meHeader.headImage sd_setImageWithURL:[HQHelper URLWithString:UM.userLoginInfo.employee.picture] forState:UIControlStateNormal];
    
//    [self.setPersonInfoBL requestGetSignatureData];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    [self setupTableView];
    
//    self.setPersonInfoBL = [TFSetPersonInfoBL build];
//    self.setPersonInfoBL.delegate = self;
    
}
- (void)setupMeHeader{
    
}

#pragma mark - Navigation
- (void)setupNavigation{
    
    self.navigationItem.title = @"";
    
}
- (void)leftClicked{
    
}

- (void)rightClicked{
    
    HQSetViewController *setVC = [[HQSetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -NavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT+ NavigationBarHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(OffsetHeight+44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;

    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -OffsetHeight, SCREEN_WIDTH, OffsetHeight)];
    imageView.image = [UIImage imageNamed:@"个人中心底图"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 101;
    [self.tableView addSubview:imageView];
    
    HQTFMeHearder *meHeader = [HQTFMeHearder meHearder];
    meHeader.delegate = self;
    meHeader.frame = CGRectMake(0, -OffsetHeight, SCREEN_WIDTH, OffsetHeight);
    [self.tableView addSubview:meHeader];
    self.meHeader = meHeader;
    
//    NSMutableArray *labArr = [NSMutableArray array];
//    [labArr arrayByAddingObjectsFromArray:@[@"日程",@"随手记",@"文件库",@"邮件"]];
//    
//    NSMutableArray *imageArr = [NSMutableArray array];
//    [imageArr arrayByAddingObjectsFromArray:@[@"日程",@"日程",@"日程",@"日程"]];
//    
//    TFCellImgBtnView *cellBtn = [TFCellImgBtnView initWithimgBtnViewFrame:CGRectMake(0, 240, SCREEN_WIDTH, 50) labels:labArr image:imageArr];
//    
//    [self.tableView addSubview:cellBtn];
    
    
}
#pragma mark - HQTFMeHearderDelegate
- (void)meHeaderClickedPhoto {
    
    
    HQPersonInfoVC *personInfoVC = [[HQPersonInfoVC alloc] init];
    [self.navigationController pushViewController:personInfoVC animated:YES];
}


-(void)meHeaderClickedCallCard{
    
    HQPersonInfoVC *personInfoVC = [[HQPersonInfoVC alloc] init];
    [self.navigationController pushViewController:personInfoVC animated:YES];
    
}

-(void)meHeaderClickedSetting{
    
    HQSetViewController *setVC = [[HQSetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)meHeaderClickedUpgrade{
    
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
    // 设置导航栏背景透明度
    
    
    //    CGFloat offset = scrollView.contentOffset.y;
    //
    //    CGFloat alpha = (OffsetHeight + NavigationBarHeight + offset) / (OffsetHeight - NavigationBarHeight);
    //
    //    [self setNavBarColorWithAlpha:alpha];
    //
    //
    //    HQLog(@"%f=======%f", alpha, offset);
}

- (void)setNavBarColorWithAlpha:(CGFloat)alpha
{
    
    //    [self.navigationController.navigationBar lt_setBackgroundColor:HexColor(0xfafbfc, alpha)];
    
    [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xffffff, alpha)] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, alpha) size:(CGSize){SCREEN_WIDTH,0.5}]];
    
    
    CGFloat titleAlpha;
    if (alpha >= 0.95) {
        
        titleAlpha = 0;
        
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(leftClicked) image:@"升级灰色" text:@" 升级" textColor:LightBlackTextColor];
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) image:@"设置灰色" highlightImage:@"设置白色"];
    }else {
        
        titleAlpha = 1 - alpha;
        
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(leftClicked) image:@"升级白色" text:@" 升级" textColor:WhiteColor];
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) image:@"设置白色" highlightImage:@"设置白色"];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    return 3;
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 2;
    //    }else if (section == 1){
    //        return 3;
    //    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger now = 0;
    
    HQTFMeCell *cell = [HQTFMeCell meCellWithTableView:tableView];
    cell.topLine.hidden = YES;
    cell.headMargin = 15;
    if (indexPath.section == 0) {
        
        for (NSInteger i = 0; i < indexPath.section; i ++) {
            
            now += [self tableView:tableView numberOfRowsInSection:i];
        }
        
        if (indexPath.row + 1 == [self tableView:tableView numberOfRowsInSection:indexPath.section]) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        
        cell.item = self.cellPictures[indexPath.row + now];
    }
    //    else if (indexPath.section == 1){
    //
    //        for (NSInteger i = 0; i < indexPath.section; i ++) {
    //
    //            now += [self tableView:tableView numberOfRowsInSection:i];
    //        }
    //
    //        if (indexPath.row + 1 == [self tableView:tableView numberOfRowsInSection:indexPath.section]) {
    //            cell.bottomLine.hidden = YES;
    //        }else{
    //            cell.bottomLine.hidden = NO;
    //        }
    //
    //        cell.item = self.cellPictures[indexPath.row + now];
    //    }
    else{
        for (NSInteger i = 0; i < indexPath.section; i ++) {
            
            now += [self tableView:tableView numberOfRowsInSection:i];
        }
        
        if (indexPath.row + 1 == [self tableView:tableView numberOfRowsInSection:indexPath.section]) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        
        cell.item = self.cellPictures[indexPath.row + now];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    //    HQTFSportController *sport = [[HQTFSportController alloc] init];
    //    [self.navigationController pushViewController:sport animated:YES];
    //    return;
    //
    //    if (indexPath.row == 0) {
    //
    //        //    NSString *html = [[NSBundle mainBundle] pathForResource:@"function" ofType:@"html"];
    //        TFTestH5Controller *edit = [[TFTestH5Controller alloc] init];
    //        edit.htmlUrl = @"http://192.168.1.49:8080/web_develop_2/teamface/NewFile.html";
    //        //    edit.htmlUrl = html;
    //        [self.navigationController pushViewController:edit animated:YES];
    //
    //        edit.action = ^(NSString *str){
    //
    //            TFTestH5Controller *edit = [[TFTestH5Controller alloc] init];
    //            edit.htmlUrl = @"http://192.168.1.49:8080/web_develop_2/teamface/NewFile1.html";
    //            //    edit.htmlUrl = html;
    //            edit.type = 1;
    //            edit.obj = str;
    //            [self.navigationController pushViewController:edit animated:YES];
    //
    //        };
    //
    //    }else{
    //
    //        TFTestH5Controller *edit = [[TFTestH5Controller alloc] init];
    //        edit.htmlUrl = @"http://192.168.1.49:8080/web_develop_2/teamface/NewFile1.html";
    //        //    edit.htmlUrl = html;
    //        edit.type = 1;
    //        [self.navigationController pushViewController:edit animated:YES];
    //    }
    //
    //    return;
    
    if (indexPath.section == 0) {// 第一组
        
        if (indexPath.row == 0) {//当前公司
            //          [HQJPushHelper jMessageSetTags:nil alias:@"112233" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            //
            //              HQLog(@"%@",iAlias);
            //          }];
            
            //            [HQJPushHelper jMessageLogout:^(id resultObject, NSError *error) {
            //
            //                  HQLog(@"%@",resultObject);
            //            }];
            
            //            [HQJPushHelper jMessageUserLoginWithUserName:@"15818548636" password:@"123456" completionHandler:^(id resultObject, NSError *error) {
            //                 HQLog(@"%@",resultObject);
            //            }];
            
            //            [HQJPushHelper jMessageUserLoginWithUserName:@"mingliang" password:@"123456" completionHandler:^(id resultObject, NSError *error) {
            //
            //                HQLog(@"%@",resultObject);
            //            }];
            
            HQTFSelectCompanyController *select = [[HQTFSelectCompanyController alloc] init];
            [self.navigationController pushViewController:select animated:YES];
            
        }
        
        if (indexPath.row == 1) {//我的看板
            
//            HQTFCooperationController *barcode = [[HQTFCooperationController alloc] init];
//            [self.navigationController pushViewController:barcode animated:YES];
//            
            
        }
    }
    if (indexPath.section == 1) {// 第二组
        if (indexPath.row == 0) {
            
        }
        if (indexPath.row == 1) {
            
        }
        if (indexPath.row == 2) {
            
        }
    }
    if (indexPath.section == 2) {// 第三组
        if (indexPath.row == 0) {
            
        }
        if (indexPath.row == 1) {
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 11;
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

//#pragma mark - 网络请求代理
//-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
////    if (resp.cmdId == HQCMD_getSignature) {
////        
////        NSDictionary *dic = resp.body;
////        
////        _signStr = [dic valueForKey:@"personSignature"];
////        self.meHeader.personSignature = _signStr;
////        
////        //        [self setupTableView];
////    }
//    
//}
//
//-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    //    [self setupTableView];
//    
//    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
//}

@end
