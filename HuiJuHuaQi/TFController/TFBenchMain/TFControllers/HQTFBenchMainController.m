//
//  HQTFBenchMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFBenchMainController.h"
#import "HQAdvertisementView.h"
#import "UINavigationBar+Awesome.h"
#import "HQTFBenchCell.h"
#import "HQRootButton.h"
#import "HQTFDateView.h"
#import "HQTFScheduleView.h"
#import "HQTFTaskHeadView.h"
#import "HQTFTaskCell.h"
#import "HQTFNoticeButton.h"
#import "FDActionSheet.h"
#import "HQTFModelBenchController.h"
#import "HQBaseNavigationController.h"
#import "HQTFNoContentCell.h"
#import "HQTFProjectMainController.h"
#import "Scan_VC.h"
#import "HQBenchTimeCell.h"
#import "HQTFProjectBarcodeController.h"
#import "TFMainTaskModel.h"
#import "TFMainScheduleModel.h"
#import "HQTFTaskMoreController.h"
#import "HQTFSelectCompanyController.h"
#import "HQTFRepeatSelectView.h"
#import "HQTFTimePeriodView.h"
#import "TFSendView.h"


@interface HQTFBenchMainController ()<UITableViewDataSource, UITableViewDelegate,FDActionSheetDelegate>

@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)HQAdvertisementView *advertisementView;  //上方广告视图
/** 模块视图 */
@property (nonatomic, strong) UIView *modelView;
/** 导航视图 */
@property (nonatomic, strong) UIView *naviView;
/** line视图 */
@property (nonatomic, strong) UIView *lineView;
/** date视图 */
@property (nonatomic, strong) HQTFDateView *dateView;
/** scheduleView视图 */
@property (nonatomic, strong) HQTFScheduleView *scheduleView;
/** taskHeadView视图 */
@property (nonatomic, strong) HQTFTaskHeadView *taskHeadView;
/** noticeButton视图 */
@property (nonatomic, strong) HQTFNoticeButton *noticeButton;
/** outsideBtn视图 */
@property (nonatomic, strong) UIButton *outsideBtn;
/** saoBtn视图 */
@property (nonatomic, strong) UIButton *saoBtn;
/** companyBtn视图 */
@property (nonatomic, strong) UIButton *companyBtn;

/** 日程数组 */
@property (nonatomic, strong) NSMutableArray *schedules;
/** 日程数组 */
@property (nonatomic, strong) NSMutableArray *tasks;


@end

@implementation HQTFBenchMainController

-(NSMutableArray *)schedules{
    
    if (!_schedules) {
        _schedules = [NSMutableArray array];
        for (NSInteger i = 0; i < 8; i++) {
            TFMainScheduleModel *model = [[TFMainScheduleModel alloc] init];
            model.scheduleType = i % 6;
            model.scheduleTitle = [NSString stringWithFormat:@"我是一个假的日程我是一个假的日程我是一个假的日程%ld",i];
            model.scheduleContent = @"我是一个假的日程";
            if (i == 3) {
                model.scheduleContent = @"";
            }
            model.scheduleSource = [NSString stringWithFormat:@"我是一个%ld",i];
            [_schedules addObject:model];
        }
    }
    return _schedules;
}

-(NSMutableArray *)tasks{
    
    if (!_tasks) {
        _tasks = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            TFMainTaskModel *model = [[TFMainTaskModel alloc] init];
            model.taskDelay = i % 2;
            model.taskPriority = i % 3;
            model.taskTitle = @"我是一个假的任务我是一个假的任务我是一个假的任务我是一个假的任务";
            model.taskContent = @"我是一个假的任务我是一个假的任务我一个假的任务我是一个假的任务我是一个一个假的任务我是一个假的任务我是一个一个假的任务我是一个假的任务我是一个是一个假的任务我是一个假的任务";
            model.taskSource = [NSString stringWithFormat:@"我是一个任务%ld",i];
            model.taskDate = @([HQHelper getNowTimeSp] - 1000*24*60*60*i);
            [_tasks addObject:model];
        }
    }
    return _tasks;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [_advertisementView activeTime];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [_advertisementView pauseTime];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setFromNavBottomEdgeLayout];
    [self setupTableView];
    [self setupDateView];
    [self setupScheduleView];
    [self setupTaskHeadView];
    [self setupNavigation];
    
}
#pragma mark - Navigation
- (void)setupNavigation{
    
    UIButton *leftBarButtonItem = [HQHelper buttonWithFrame:(CGRect){0,20,44,44} normalImageStr:@"扫码白色" highImageStr:@"扫码白色" target:self action:@selector(leftClicked)];
    self.saoBtn = leftBarButtonItem;
    
    UIButton *rightBarButtonItem = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-44,20,44,44} normalImageStr:@"企业" highImageStr:@"企业" target:self action:@selector(rightClicked)];
    self.companyBtn = rightBarButtonItem;
    

    _outsideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _outsideBtn.frame = CGRectMake(0, 20, SCREEN_WIDTH-100, 44);
    [_outsideBtn setTitle:@"深圳汇聚华企科技有限公司" forState:UIControlStateNormal];
    [_outsideBtn setTitleColor:WhiteColor forState:0];
    _outsideBtn.titleLabel.font = FONT(20);
    
    UIView *naviView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,64}];
    [self.view addSubview:naviView];
    self.naviView =naviView;
    
    _outsideBtn.centerX = SCREEN_WIDTH/2;
    
    [naviView addSubview:leftBarButtonItem];
    [naviView addSubview:rightBarButtonItem];
    [naviView addSubview:_outsideBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0,64-.5,SCREEN_WIDTH,0.5}];
    lineView.backgroundColor = HexColor(0xc8c8c8, 0);
    [self.view addSubview:lineView];
    self.lineView = lineView;
}


- (void)leftClicked{
    
    [TFSendView showAlertView:@"发送给："
                       people:nil
                      content:@"我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个络地址哦"
                     password:@"3456"
                      endTime:@"2017-09-08"
                   placehoder:@"我想说点东西"
                onLeftTouched:^{
                    
                }
               onRightTouched:^(id parameter){
                
               }];
    
//    [HQTFRepeatSelectView selectTimeViewWithStartWithType:0 start:@"5" end:@"" timeArray:^(NSArray *array) {
//        
//        HQLog(@"%@",array);
//    }];
//    [HQTFTimePeriodView selectTimeViewWithStartTimeSp:33333333 endTimeSp:66666666666 timeSpArray:^(NSArray *array) {
//        
//    }];
    
//    Scan_VC * vc=[[Scan_VC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightClicked{
    HQTFSelectCompanyController *company = [[HQTFSelectCompanyController alloc] init];
    [self.navigationController pushViewController:company animated:YES];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    tableView.backgroundColor = BackGroudColor;
    [self setupAdvertisementView];
    tableView.tableHeaderView = _advertisementView;
    tableView.layer.masksToBounds = NO;
    
    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
//    label.backgroundColor = GreenColor;
    tableView.tableFooterView = label;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma mark - HQTFDateView
- (void)setupDateView{
    
    HQTFDateView *dateView = [HQTFDateView dateView];
    dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    dateView.lineB.hidden = YES;
    self.dateView = dateView;
//    dateView.backgroundColor = RedColor;
    
}
#pragma mark - scheduleView
- (void)setupScheduleView{
    HQTFScheduleView *scheduleView = [HQTFScheduleView scheduleView];
    self.scheduleView = scheduleView;
}

#pragma mark - TaskHeadView
- (void)setupTaskHeadView{
    
    HQTFTaskHeadView *taskHeadView = [[HQTFTaskHeadView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    self.taskHeadView = taskHeadView;
    
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tasks.count) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.schedules.count==0?1:self.schedules.count;
    }else{
        return self.tasks.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dateView;
    }else{
        if (self.tasks.count) {
            return [self moreView];
        }
        return [UIView new];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}
-(UIView *)moreView{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    
    UILabel *label = [HQHelper labelWithFrame:(CGRect){15,0,70,44} text:@"超期任务" textColor:BlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(16)];
    [view addSubview:label];
    
    UILabel *labelNum = [HQHelper labelWithFrame:(CGRect){CGRectGetMaxX(label.frame),0,70,44} text:@"(45)" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(16)];
    [view addSubview:labelNum];
    
    
    UILabel *labelJump = [HQHelper labelWithFrame:(CGRect){SCREEN_WIDTH-100,0,85,44} text:@"更多  >" textColor:LightGrayTextColor textAlignment:NSTextAlignmentRight font:FONT(16)];
    [view addSubview:labelJump];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [view addGestureRecognizer:tap];
    
    view.backgroundColor = BackGroudColor;
    
    return view;
    
}

- (void)viewTap{
    HQTFTaskMoreController *moreTask = [[HQTFTaskMoreController alloc] init];
    [self.navigationController pushViewController:moreTask animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.schedules.count) {
        
            HQTFBenchCell *cell = [HQTFBenchCell benchCellWithTableView:tableView];
//            [cell refreshBenchCellWithModel:self.schedules[indexPath.row]];
            [cell refreshSolidBenchCellWithModel:self.schedules[indexPath.row]];
            cell.bottomLine.hidden = YES;
            return cell;
        }else{
            HQTFNoContentCell *cell = [HQTFNoContentCell noContentCellWithTableView:tableView withImage:@"图123" withText:@"今天任务完成，喝杯咖啡思考人生"];
            cell.bottomLine.hidden = YES;
            cell.backgroundColor = ClearColor;
            return cell;
        }
    }else{
        
        if (self.tasks.count) {
        
            HQTFTaskCell *cell = [HQTFTaskCell taskCellWithTableView:tableView];
//            [cell refreshTaskCellWithModel:self.tasks[indexPath.row]];
            [cell refreshSolidTaskCellWithModel:self.tasks[indexPath.row]];
            cell.bottomLine.hidden = YES;
            return cell;
        }else{
            
            HQTFNoContentCell *cell = [HQTFNoContentCell noContentCellWithTableView:tableView withImage:@"图123" withText:@"今天任务完成，喝杯咖啡思考人生"];
            cell.bottomLine.hidden = YES;
            cell.backgroundColor = ClearColor;
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 120;
    }else{
        if (self.tasks.count) {
            return 44;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 8;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.schedules.count == 0) {
            return Long(288);
        }else{
            
//            return [HQTFBenchCell refreshBenchCellHeightWithModel:self.schedules[indexPath.row]];
            return [HQTFBenchCell refreshSolidBenchCellHeightWithModel:self.schedules[indexPath.row]];
        }
    }else{
        if (self.tasks.count == 0) {
            return Long(0);
        }else{
            
//            return [HQTFTaskCell refreshTaskCellHeightWithModel:self.tasks[indexPath.row]];
            return [HQTFTaskCell refreshSolidTaskCellHeightWithModel:self.tasks[indexPath.row]];
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




#pragma mark - 初始化广告视图
- (void)setupAdvertisementView
{
    
    _advertisementView = [[HQAdvertisementView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Long(105))];
    _advertisementView.tableView.frame = CGRectMake(0, -64, SCREEN_WIDTH, Long(105)+64);
    _advertisementView.rowHeight = Long(105)+64;
    _advertisementView.pageColor = HexColor(0xffffff, 0.4);
    _advertisementView.pageCurrentColor = HexColor(0xffffff, 1);
    _advertisementView.datas = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"滚屏图1"],[UIImage imageNamed:@"滚屏图2"],[UIImage imageNamed:@"滚屏图3"]]];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat minAlphaOffset = 0;
    
    CGFloat maxAlphaOffset = Long(105);
    
    CGFloat offset = scrollView.contentOffset.y;
    
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
//    if (offset >= Long(105) + 64) {
//        if (_tableView.contentSize.height <= _tableView.height) {
//            return;
//        }
//        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64);
//        
//    }else if (offset >= Long(105)) {
//        if (_tableView.contentSize.height <= _tableView.height) {
//            return;
//        }
//        _tableView.frame = CGRectMake(0, offset-Long(105)-64, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - offset + Long(105));
//        
//    }else {
//        _tableView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//        
//    }
    
    [self setNavBarColorWithAlpha:alpha];
}

- (void)setNavBarColorWithAlpha:(CGFloat)alpha
{
    HQLog(@"%f", alpha);
    
//    [self.navigationController.navigationBar lt_setBackgroundColor:HexColor(0xfafbfc, alpha)];
    
//    UIView *lineView = [self.navigationController.navigationBar viewWithTag:0x1314];
//    lineView.alpha = alpha;
    
    self.naviView.backgroundColor = HexColor(0xffffff, alpha);
    self.lineView.backgroundColor = HexColor(0xc8c8c8, alpha);
    CGFloat titleAlpha;
    if (alpha >= 0.95) {
        
        self.naviView.backgroundColor = HexColor(0xffffff, 1);
        self.lineView.backgroundColor = HexColor(0xc8c8c8, 1);
        
        titleAlpha = 0;
        
        [self.saoBtn setImage:[UIImage imageNamed:@"扫码灰色"] forState:UIControlStateNormal];
        [self.saoBtn setImage:[UIImage imageNamed:@"扫码灰色"] forState:UIControlStateHighlighted];
        [self.companyBtn setImage:[UIImage imageNamed:@"企业12"] forState:UIControlStateHighlighted];
        [self.companyBtn setImage:[UIImage imageNamed:@"企业12"] forState:UIControlStateNormal];
        self.dateView.lineB.hidden = NO;
    }else {
        
        titleAlpha = 1 - alpha;
        
        [self.saoBtn setImage:[UIImage imageNamed:@"扫码白色"] forState:UIControlStateNormal];
        [self.saoBtn setImage:[UIImage imageNamed:@"扫码白色"] forState:UIControlStateHighlighted];
        
        [self.companyBtn setImage:[UIImage imageNamed:@"企业"] forState:UIControlStateHighlighted];
        [self.companyBtn setImage:[UIImage imageNamed:@"企业"] forState:UIControlStateNormal];
        self.dateView.lineB.hidden = YES;
    }
    
//    HQLog(@"____________%f_________",255*titleAlpha);
    UIColor *titleColor = RGBAColor(255*titleAlpha, 255*titleAlpha, 255*titleAlpha, 1);
    [self.outsideBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.outsideBtn setTitleColor:titleColor forState:UIControlStateHighlighted];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:
//                                                                          titleColor,
//                                                                      NSFontAttributeName:FONT(19)}];
    
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
