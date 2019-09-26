//
//  TFPCRuleController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCRuleController.h"
#import "TFPCRuleListCell.h"
#import "TFAddPCMembersController.h"
#import "TFAddPCRuleController.h"
#import "TFRuleCell.h"
#import "TFAttendanceBL.h"
#import "TFPCRuleListModel.h"
#import "TFModelView.h"
#import "TFAttendanceWayController.h"
#import "TFClassesManagerController.h"
#import "TFRelatedAprrovalController.h"
#import "TFOtherSetController.h"
#import "TFClassesDetailController.h"
#import "TFPluginManageController.h"

@interface TFPCRuleController ()<UITableViewDelegate,UITableViewDataSource,TFPCRuleListCellDelegate,HQBLDelegate,TFRuleCellDelegate,TFModelViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFAttendanceBL *atdBL;

@property (nonatomic, strong) TFPCRuleListModel *listModel;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) NSMutableArray *datas;


@property (nonatomic, strong) TFPCRuleListModel *selectModel;

@end

@implementation TFPCRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    [self setupTableView];
    
    self.pageNum = 1;
    self.pageSize = 200;
    
    self.atdBL = [TFAttendanceBL build];
    self.atdBL.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.atdBL requestGetAttendanceScheduleFindListWithPageNum:@(self.pageNum) pageSize:@(self.pageSize)];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RuleCreateSuccess" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        [self.atdBL requestGetAttendanceScheduleFindListWithPageNum:@(self.pageNum) pageSize:@(self.pageSize)];
    }];
    
}

- (void)setNavi {
    
    self.navigationItem.title = @"设置";
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addAction) text:@"添加" textColor:GreenColor];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIView *header = [UIView new];
    header.backgroundColor = WhiteColor;
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *titles = @[@"考勤方式",@"班次管理",@"排班详情",@"其它设置",@"关联审批",@"插件管理"];
    NSArray *urls = @[@"考勤方式",@"班次管理",@"排班详情",@"其它设置",@"关联审批",@"插件管理"];
    for (NSInteger i = 0; i < titles.count; i ++) {
        TFModuleModel *model = [[TFModuleModel alloc] init];
        model.id = @(i);
        model.icon_type = @"0";
        model.icon_url = urls[i];
        model.icon_color = @"0xffffff";
        model.chinese_name = titles[i];
        [arr addObject:model];
    }
    
    for (NSInteger i = 0; i < arr.count; i++) {
        
        NSInteger row = i /4;
        NSInteger col = i % 4;
        TFModelView *view = [TFModelView modelView];
        [header addSubview:view];
        view.delegate = self;
        view.frame = CGRectMake(col * (SCREEN_WIDTH / 4), row * (SCREEN_WIDTH / 4) + 10, (SCREEN_WIDTH / 4), (SCREEN_WIDTH / 4));
        TFModuleModel *module = arr[i];
        [view refreshViewWithModule:module type:0];
    }
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, (arr.count + 3)/4 * (SCREEN_WIDTH / 4));
    self.tableView.tableHeaderView = header;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFPCRuleListModel *model = self.datas[indexPath.row];
    TFRuleCell *cell = [TFRuleCell ruleCellWithTableView:tableView];
    [cell refreshRuleCellWithModel:model];
    cell.delegate = self;
    cell.headMargin = 0;
    cell.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,54}];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,10}];
    line.backgroundColor = BackGroudColor;
    [view addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,10,100,44}];
    [view addSubview:label];
    label.font = FONT(16);
    label.textColor = GreenColor;
    label.text = @"新增打卡规则";
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRect){SCREEN_WIDTH-44,10,44,44}];
    [view addSubview:image];
    image.contentMode = UIViewContentModeCenter;
    image.image = IMG(@"custom加栏");
    image.userInteractionEnabled = YES;
   
    UIView *view1 = [[UIView alloc] initWithFrame:(CGRect){0,53.5,SCREEN_WIDTH,.5}];
    view1.backgroundColor = CellSeparatorColor;
    [view addSubview:view1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
    [image addGestureRecognizer:tap];
    
    return view;
}

-(void)tapClicked{
    [self addAction];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - TFModelViewDelegate
-(void)didClickedmodelView:(TFModelView *)modelView application:(TFApplicationModel *)application module:(TFModuleModel *)module{
    
    if ([module.id integerValue] == 0) { //考勤方式
        
        TFAttendanceWayController *wayVC = [[TFAttendanceWayController alloc] init];
        
        [self.navigationController pushViewController:wayVC animated:YES];
        
    }
    else if ([module.id integerValue] == 1) { //班次管理
        
        TFClassesManagerController *classManager = [[TFClassesManagerController alloc] init];
        
        [self.navigationController pushViewController:classManager animated:YES];
        
    }
    else if ([module.id integerValue] == 2) { //排班详情
        
        TFClassesDetailController *classesDetailVC = [[TFClassesDetailController alloc] init];
        
        [self.navigationController pushViewController:classesDetailVC animated:YES];
        
    }
    else if ([module.id integerValue] == 3) { //其他设置
        
        TFOtherSetController *otherSetVC = [[TFOtherSetController alloc] init];
        
        [self.navigationController pushViewController:otherSetVC animated:YES];
        
    }
    else if ([module.id integerValue] == 4) { //关联审批单
        
        TFRelatedAprrovalController *relatedVC = [[TFRelatedAprrovalController alloc] init];
        
        [self.navigationController pushViewController:relatedVC animated:YES];
        
    }
    else if ([module.id integerValue] == 5) { //插件管理
        
        TFPluginManageController *plugin = [[TFPluginManageController alloc] init];
        [self.navigationController pushViewController:plugin animated:YES];
        
    }
}

#pragma mark 添加规则事件
- (void)addAction {
    
    TFAddPCMembersController *addMembersVC = [[TFAddPCMembersController alloc] init];
    
    [self.navigationController pushViewController:addMembersVC animated:YES];
    
}

#pragma mark - TFRuleCellDelegate

-(void)ruleCellDidClickedRule:(TFRuleCell *)cell{
    
    TFPCRuleListModel *model = self.datas[cell.tag];
    self.selectModel = model;
    TFAddPCRuleController *addRuleVC = [[TFAddPCRuleController alloc] init];
    addRuleVC.type = [model.attendance_type integerValue];
    addRuleVC.vcType = 1;
    addRuleVC.atdName = model.name;
    addRuleVC.atdPersons = model.attendance_users;
    addRuleVC.noAtdPersons = model.excluded_users;
    addRuleVC.dict = model.dict;
    addRuleVC.id = model.id;
    
    [self.navigationController pushViewController:addRuleVC animated:YES];
}
-(void)ruleCellDidClickedPeople:(TFRuleCell *)cell{
    
    TFPCRuleListModel *model = self.datas[cell.tag];
    self.selectModel = model;
    TFAddPCMembersController *addMembersVC = [[TFAddPCMembersController alloc] init];
    addMembersVC.vcType = 1;
    addMembersVC.atdName = model.name;
    addMembersVC.atdPersons = model.attendance_users;
    addMembersVC.noAtdPersons = model.excluded_users;
    addMembersVC.dict = model.dict;
    addMembersVC.id = model.id;
    [self.navigationController pushViewController:addMembersVC animated:YES];
}
-(void)ruleCellDidClickedDelete:(TFRuleCell *)cell{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除后，该考勤组成员的考勤将不会被系统智能标记迟到、早退等行为统计。是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TFPCRuleListModel *model = self.datas[cell.tag];
        self.selectModel = model;
        [self.atdBL requestDelAttendanceScheduleWithId:model.id];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceScheduleFindList) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.datas = resp.body;
        
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_attendanceScheduleDel) {
        [MBProgressHUD showImageSuccess:@"删除成功" toView:self.view];
        [self.datas removeObject:self.selectModel];
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
