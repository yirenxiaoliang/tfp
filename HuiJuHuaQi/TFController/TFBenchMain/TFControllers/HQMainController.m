//
//  HQMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQMainController.h"
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
#import "HQMainSliderView.h"
#import "HQTFMyWorkBenchCell.h"
#import "TFProjTaskModel.h"
#import "HQTFTaskRowController.h"

@interface HQMainController ()<UITableViewDataSource, UITableViewDelegate,FDActionSheetDelegate,HQTFMyWorkBenchCellDelegate,YPTabBarDelegate>

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

/** HQMainSliderView *view */
@property (nonatomic, strong) HQMainSliderView *sliderView;

/** 滑动 */
@property (nonatomic, assign) BOOL isScroll;

/** 二维数组，任务列表 */
@property (nonatomic, strong) NSMutableArray *taskList;

/** HQTFTaskRowController */
@property (nonatomic, strong) HQTFTaskRowController *taskRow;

@end

@implementation HQMainController


-(NSMutableArray *)taskList{
    if (!_taskList) {
        _taskList = [NSMutableArray array];
        
//        for (NSInteger q = 0; q < 4; q ++) {
//            NSMutableArray *arr = [NSMutableArray array];
//            for (NSInteger i = q; i < 3; i ++) {
                
                
//                TFProjTaskModel *model = [[TFProjTaskModel alloc] init];
//                model.creatorId = @(1111+i);
//                model.isOverdue = @(i % 2);
//                model.activeCount = @(i);
//                model.content = [NSString stringWithFormat:@"%@--%ld",@"我是项目任务是项目任务的是项目任务的是项目任务的的标题",i];
//                model.priority = @(i % 3);
//                model.deadline = @([HQHelper getNowTimeSp] + 1000 * 3 * 24 * 60 * 60);
//                model.desc = [NSString stringWithFormat:@"我是项目任务的描述类容呀，请多多关注。"];
//                model.isPublic = @(i % 2);
//                model.isFinish = @(i % 2);
//                model.numberType = @(i % 2);
//                model.numberSum = @"10000000000";
//                model.numberUnit = @"元";
//                model.relatedItemCount = @12;
//                model.childTaskCount = @99;
//                model.childTaskFinished = @88;
//                model.fileCount = @2;
//                model.isPublic = @(i % 2);
                
//                NSMutableArray *parts = [NSMutableArray array];
//                for (NSInteger j = 4-i; j <= 4; j ++) {
//                    TFProjParticipantModel *part = [[TFProjParticipantModel alloc] init];
//                    [parts addObject:part];
//                }
//                model.managers = parts;
                
//                NSMutableArray *labels = [NSMutableArray array];
//                for (NSInteger j = i; j < 3; j ++) {
//                    TFProjLabelModel *mo = [[TFProjLabelModel alloc] init];
//                    if (i == 0) {
//                        mo.labelName = @"我是个镖旗";
//                    }else if (i == 1) {
//                        
//                        mo.labelName = @"我是个";
//                    }else{
//                        mo.labelName = @"我";
//                    }
//                    mo.labelColor = [NSString stringWithFormat:@"#ff0000"];
//                    [labels addObject:mo];
//                }
//                model.labels = labels;
//                [arr addObject:model];
//            }
//            [_taskList addObject:arr];
//        }
        
    }
    return _taskList;
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
//    [self setupMainSliderView];
    //    [self setupScheduleView];
    //    [self setupTaskHeadView];
    [self setupNavigation];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(childTableViewScroll:) name:WorkBenchChildTableViewScrollNotifition object:nil];
    
    self.taskRow = [[HQTFTaskRowController alloc] init];
    [self addChildViewController:self.taskRow];
    
}

- (void)childTableViewScroll:(NSNotification *)note{
    
    BOOL isScroll = [note.object boolValue];
    
    self.tableView.scrollEnabled = !isScroll;
    
    if (self.tableView.scrollEnabled) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tableView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
}

-(void)dealloc{
//    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    //    [TFSendView showAlertView:@"发送给："
    //                       people:nil
    //                      content:@"我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个网络地址哦我是一个络地址哦"
    //                     password:@"3456"
    //                      endTime:@"2017-09-08"
    //                   placehoder:@"我想说点东西"
    //                onLeftTouched:^{
    //
    //                }
    //               onRightTouched:^(id parameter){
    //
    //               }];
    
    //    [HQTFRepeatSelectView selectTimeViewWithStartWithType:0 start:@"5" end:@"" timeArray:^(NSArray *array) {
    //
    //        HQLog(@"%@",array);
    //    }];
    //    [HQTFTimePeriodView selectTimeViewWithStartTimeSp:33333333 endTimeSp:66666666666 timeSpArray:^(NSArray *array) {
    //
    //    }];
    
    //        Scan_VC * vc=[[Scan_VC alloc]init];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:vc animated:YES];
    HQTFTaskRowController *taskRow = [[HQTFTaskRowController alloc] init];
    [self.navigationController pushViewController:taskRow animated:YES];
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
    
    //    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    //    label.backgroundColor = GreenColor;
    //    tableView.tableFooterView = label;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
//    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - HQMainSliderView
- (void)setupMainSliderView{
    
    //    HQTFDateView *dateView = [HQTFDateView dateView];
    //    dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    //    dateView.lineB.hidden = YES;
    //    self.dateView = dateView;
    //    dateView.backgroundColor = RedColor;
    
    HQMainSliderView *view = [[HQMainSliderView alloc] initWithFrame:(CGRect){0,120,SCREEN_WIDTH,83}];
    view.tabBar.delegate = self;
    self.sliderView = view;
}
//#pragma mark - scheduleView
//- (void)setupScheduleView{
//    HQTFScheduleView *scheduleView = [HQTFScheduleView scheduleView];
//    self.scheduleView = scheduleView;
//}
//
//#pragma mark - TaskHeadView
//- (void)setupTaskHeadView{
//
//    HQTFTaskHeadView *taskHeadView = [[HQTFTaskHeadView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
//    self.taskHeadView = taskHeadView;
//
//}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.taskRow.view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"ewcfds";
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SCREEN_HEIGHT-64-49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - HQTFMyWorkBenchCellDelegate
-(void)myWorkBenchCellWithScrollView:(UIScrollView *)scrollView{
    
    [self.sliderView.tabBar updateSubViewsWhenParentScrollViewScroll:scrollView];
    
    //    HQTFMyWorkBenchCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    cell.open = NO;
    
}
-(void)myWorkBenchCellWithSelectIndex:(NSInteger)selectIndex{
    
    self.sliderView.tabBar.selectedItemIndex = selectIndex;
}

-(void)myWorkBenchCellDidDownBtnWithSelectIndex:(NSInteger)selectIndex withModel:(TFProjTaskModel *)model{
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"移动任务至" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"超期任务",@"今天要做",@"明天要做",@"以后要做",nil];
    
    [sheet show];
    
}


-(void)myWorkBenchCellDidFinishBtnWithModel:(TFProjTaskModel *)model{
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    
}


#pragma mark - SliderViewDelegate
-(void)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index{
    
    HQTFMyWorkBenchCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.selectIndex = index;
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
    
    //    if (alpha >= 1.0 && !self.isScroll) {
    //        self.tableView.scrollEnabled = NO;
    //        self.isScroll = YES;
    //        [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchMainTableViewScrollNotifition object:@0];
    //    }
    //    if (alpha < 1.0 && self.isScroll){
    //        self.isScroll = NO;
    //        self.tableView.scrollEnabled = YES;
    //        [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchMainTableViewScrollNotifition object:@1];
    //    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    UITableView *tableView = object;
    
    HQLog(@"++++++++%f",tableView.contentOffset.y);
    
    if (tableView.contentOffset.y >= Long(105) && !self.isScroll) {
        self.tableView.scrollEnabled = NO;
        self.isScroll = YES;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchMainTableViewScrollNotifition object:@0];
    }
    if (tableView.contentOffset.y < Long(105) && self.isScroll){
        self.isScroll = NO;
        self.tableView.scrollEnabled = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchMainTableViewScrollNotifition object:@1];
    }
    
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
