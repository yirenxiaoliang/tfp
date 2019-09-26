//
//  HQTFMeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFMeController.h"
#import "HQTFMeHearder.h"
#import "HQTFMeCell.h"
#import "HQSetViewController.h"
#import "HQTFSelectCompanyController.h"
#import "HQPersonInfoVC.h"
#import "TFTestH5Controller.h"
#import "HQEmployModel.h"
#import "TFCellImgBtnView.h"
#import "HQTFChatCell.h"
#import "TFSendCompanyCircleController.h"
#import "TFCompanyCircleController.h"
#import "HQMyCardViewController.h"
#import "TFFileMenuController.h"
#import "TFApprovalMainController.h"
#import "TFMutilStyleSelectPeopleController.h"

#import "TFEmailsMainController.h"
#import "TFWaveView.h"
#import "TFNoteMainController.h"
#import "TFMyBusinessCardController.h"
//#import "TFProjectBenchController.h"
#import "TFTTTViewController.h"
#import "TFProjectBoardController.h"
#import "TFPersonalMaterialController.h"
#import "TFProjectAndTaskMainController.h"

#import "TFAttendanceTabbarController.h"
#import "TFProjectTaskDetailController.h"

#define FourItemHeight 60
#define OffsetHeight 260

@interface HQTFMeController ()<UITableViewDelegate,UITableViewDataSource,HQTFMeHearderDelegate,HQTFChatCellDelegate,TFCellImgBtnViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;
/** cellPictures */
@property (nonatomic, strong) NSMutableArray *cellPictures;


@property (nonatomic, copy) NSString *signStr;

/** HQTFMeHearder *meHeader */
@property (nonatomic, strong) HQTFMeHearder *meHeader;

@property (nonatomic, strong) UIButton *companyBtn;

/** TFWaveView *waveView */
@property (nonatomic, strong) TFWaveView *waveView;


@end

@implementation HQTFMeController

- (NSMutableArray *)cellPictures{
    if (!_cellPictures) {
        _cellPictures = [NSMutableArray array];
    
        NSArray *names = @[@"考勤",@"我的收藏",@"关于Teamface",@"在线帮助"];
        NSArray *images = @[@"attendance",@"我的收藏",@"关于Me",@"在线帮助"];
        
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
    
    self.navigationController.navigationBar.translucent = YES;
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
//    NSString *company = UM.userLoginInfo.company.company_name;
//    NSString *employee = UM.userLoginInfo.employee.employee_name;
//    NSString *picture = UM.userLoginInfo.employee.picture;
    
    [self.meHeader.companyBtn setTitle:[NSString stringWithFormat:@"%@ >",UM.userLoginInfo.company.company_name] forState:UIControlStateNormal];
    
    self.meHeader.name.text = UM.userLoginInfo.employee.employee_name;
    [self.meHeader.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:UM.userLoginInfo.employee.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            
            [self.meHeader.headImage setTitle:@"" forState:UIControlStateNormal];
            [self.meHeader.headImage setTitle:@"" forState:UIControlStateHighlighted];

        }else{
            [self.meHeader.headImage setTitle:[HQHelper nameWithTotalName:UM.userLoginInfo.employee.employee_name] forState:UIControlStateNormal];
            [self.meHeader.headImage setTitle:[HQHelper nameWithTotalName:UM.userLoginInfo.employee.employee_name] forState:UIControlStateHighlighted];
            self.meHeader.headImage.titleLabel.font = FONT(17);
            [self.meHeader.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.meHeader.headImage setTitleColor:WhiteColor forState:UIControlStateHighlighted];
            [self.meHeader.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [self.meHeader.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
        }
    }];
    
//    HQLog(@"测试分支的一句代码");
//    HQLog(@"测试分支的一句代码");
    
//    NSString *str = [NSString stringWithFormat:@"ghthhh"];
//    BOOL res = [str haveNumberAndAlphabet];
//    BOOL res1 = [str haveNumberAndUpperLowerAlphabet];
//    BOOL res2 = [str haveNumberAndAlphabetAndSepecialChar];
//    BOOL res3 = [str haveNumberAndUpperLowerAlphabetAndSepecialChar];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWaveView];

    [self setupTableView];
    
    [self setupNavigation];
    
}

- (void)setupWaveView{
    
    TFWaveView *waveView = [[TFWaveView alloc] initWithFrame:(CGRect){0,100,SCREEN_WIDTH,80}];
    self.waveView = waveView;
    
}

- (void)setupMeHeader{
    
}

#pragma mark - Navigation
- (void)setupNavigation{
    
    self.navigationItem.title = @"";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) image:@"设置白色" highlightImage:@"设置白色"];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(leftClicked) image:@"白二维码" highlightImage:@"白二维码"];

}
- (void)leftClicked{
    
    TFMyBusinessCardController *myCardVC = [[TFMyBusinessCardController alloc] init];
    [self.navigationController pushViewController:myCardVC animated:YES];
//    HQMyCardViewController *myCardVC = [[HQMyCardViewController alloc] init];
//    [self.navigationController pushViewController:myCardVC animated:YES];
}

- (void)rightClicked{
    
    HQSetViewController *setVC = [[HQSetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    
}

- (void)cutCompany {

    HQTFSelectCompanyController *select = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
}

-(NSAttributedString *)attributeStringWithFinishTask:(NSString *)finish withTotalTask:(NSString *)total{
    
    NSString *totalString = [NSString stringWithFormat:@"%@/%@",finish,total];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:totalString];
    [string addAttribute:NSForegroundColorAttributeName value:GreenColor range:[totalString rangeOfString:[NSString stringWithFormat:@"%@",finish]]];
    [string addAttribute:NSForegroundColorAttributeName value:LightGrayTextColor range:[totalString rangeOfString:[NSString stringWithFormat:@"/%@",total]]];
    [string addAttribute:NSFontAttributeName value:FONT(12) range:(NSRange){0,totalString.length}];
    
    return string;
}

#pragma mark 按钮代理方法
- (void)cellImgBtnView:(TFCellImgBtnView *)cellImgBtnView btnClicked :(NSInteger)index {

    
    if (cellImgBtnView.tag == 0x123) {
        
        
    }
    else{
        
        if (index == 0) { //备忘录
            
//            TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
//            scheduleVC.selectType = 0;
//            scheduleVC.isSingleSelect = YES;
//            [self.navigationController pushViewController:scheduleVC animated:YES];
//            [MBProgressHUD showError:@"正在开发中" toView:self.view];
            
            TFNoteMainController *noteVC = [[TFNoteMainController alloc] init];
            
            [self.navigationController pushViewController:noteVC animated:YES];
        }
        else if (index == 1) { //随手记
            
//            TFNoteMainController *noteVC = [[TFNoteMainController alloc] init];
//            [self.navigationController pushViewController:noteVC animated:YES];
            [MBProgressHUD showError:@"敬请期待" toView:self.view];
            
        }
        else if (index == 2) { //文件库

            TFFileMenuController *menu = [[TFFileMenuController alloc] init];
            
            [self.navigationController pushViewController:menu animated:YES];
        }
        else if (index == 3) { //邮件
            
            TFEmailsMainController *emailsVC = [[TFEmailsMainController alloc] init];
            [self.navigationController pushViewController:emailsVC animated:YES];
        }

    }
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -NavigationBarHeight-44, SCREEN_WIDTH, SCREEN_HEIGHT+ NavigationBarHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(OffsetHeight+44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;

    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -OffsetHeight, SCREEN_WIDTH, OffsetHeight-60)];
//    imageView.image = [UIImage imageNamed:@"我的主页底图"];
    
    UIView *vi = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,100}];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);  // 设置显示的frame
    gradientLayer.colors = @[(id)HexColor(0x3cbbed).CGColor,(id)HexColor(0x1a8afa).CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [vi.layer addSublayer:gradientLayer];
    
    [HQHelper imageFromView:vi];
    
//    imageView.image = [HQHelper createImageWithColor:HexColor(0x1a8afa)];
    imageView.image = [HQHelper imageFromView:vi];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 101;
    imageView.layer.masksToBounds = YES;
    [self.tableView addSubview:imageView];

    UIView *view = [UIView new];
    view.frame = CGRectMake(0, -OffsetHeight, SCREEN_WIDTH, OffsetHeight);
    
    HQTFMeHearder *meHeader = [HQTFMeHearder meHearder];
    meHeader.delegate = self;
    meHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, OffsetHeight);
    self.meHeader = meHeader;
    [self.meHeader.companyBtn setTitle:[NSString stringWithFormat:@"%@ >",UM.userLoginInfo.company.company_name] forState:UIControlStateNormal];
    
    [view addSubview:meHeader];
    
    self.waveView.frame = CGRectMake(0, view.height - 80, SCREEN_WIDTH, 80);
    [view addSubview:self.waveView];
    
    NSArray *labArr = @[@"备忘录",@"知识库",@"文件库",@"邮件"];
    
    NSArray *imageArr = @[@"新随手记",@"知识库",@"文件库me",@"绿邮件"];
    
    TFCellImgBtnView *cellBtn = [[TFCellImgBtnView alloc] initWithimgBtnViewFrame:CGRectMake(0, view.height - 55, SCREEN_WIDTH, 55) labs:labArr image:imageArr textFont:FONT(12) textColor:kUIColorFromRGB(0x8C96AB)];
    cellBtn.tag = 0x456;
    cellBtn.delegate = self;
    cellBtn.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    
    [view addSubview:cellBtn];
    
    [self.tableView addSubview:view];

}

#pragma mark - HQTFMeHearderDelegate
- (void)meHeaderClickedPhoto {

    
//    HQPersonInfoVC *personInfoVC = [[HQPersonInfoVC alloc] init];
//    [self.navigationController pushViewController:personInfoVC animated:YES];
    
    TFPersonalMaterialController *personMaterial = [[TFPersonalMaterialController alloc] init];
    personMaterial.signId = UM.userLoginInfo.employee.sign_id;
    [self.navigationController pushViewController:personMaterial animated:YES];
    
}


-(void)meHeaderClickedCompany{
    
    [self cutCompany];
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint point = scrollView.contentOffset;
    CGRect rect = [self.tableView viewWithTag:101].frame;
    //     背景图下拉放大
    if (point.y < -OffsetHeight) {
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        
        [self.tableView viewWithTag:101].frame = CGRectMake(0, point.y, SCREEN_WIDTH, rect.size.height);
    }
    HQLog(@"===%@===",NSStringFromCGRect(rect));
    
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
        cell.headMargin = 15;
        
        cell.item = self.cellPictures[indexPath.section - 1];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {// 第一组
        
//        TFCompanyCircleController *companyCircle = [[TFCompanyCircleController alloc] init];
        [self.navigationController pushViewController:[AppDelegate shareAppDelegate].circleCtrl animated:YES];

    }
    if (indexPath.section == 1) {// 第二组
        [MBProgressHUD showError:@"敬请期待" toView:self.view];
        
//        TFAttendanceTabbarController *attendanceTabbar = [[TFAttendanceTabbarController alloc] init];
//
//        [self.navigationController pushViewController:attendanceTabbar animated:YES];
//        TFProjectAndTaskMainController *project = [[TFProjectAndTaskMainController alloc] init];
//        [self.navigationController pushViewController:project animated:YES];
    }
    if (indexPath.section == 2) {// 第三组
        [MBProgressHUD showError:@"敬请期待" toView:self.view];
//        TFTTTViewController *tt = [[TFTTTViewController alloc] init];
//        [self.navigationController pushViewController:tt animated:YES];
    }
    if (indexPath.section == 3) {// 第三组
        
        [MBProgressHUD showError:@"敬请期待" toView:self.view];
    }
    
    if (indexPath.section == 4) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.teamface.cn/index.html"]];
        
        TFProjectTaskDetailController *detail = [[TFProjectTaskDetailController alloc] init];
        [self.navigationController pushViewController:detail  animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 52;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section < 3) {
        return 8;
    }
    return 0.5;
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

@end
