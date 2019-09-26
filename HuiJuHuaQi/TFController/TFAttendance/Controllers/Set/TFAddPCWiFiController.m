//
//  TFAddPCWiFiController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPCWiFiController.h"
#import "TFAddressWayCell.h"

#import "TFAttendanceBL.h"
#import "TFAddAtdWayModel.h"
#import "HQTFNoContentView.h"

@interface TFAddPCWiFiController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFNoContentViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) NSInteger select;

@property (nonatomic, strong) TFAttendanceBL *atdBL;

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFAddPCWiFiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.atdBL = [TFAttendanceBL build];
    self.atdBL.delegate = self;
    self.select = 0;
    
    self.dict = [HQHelper getCurrentWiFiInfo];
    [self setNavi];
    [self setupTableView];
}

- (void)setNavi {
    
    self.navigationItem.title = @"添加Wi-Fi";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(saveAction) text:@"保存" textColor:GreenColor];
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2 - 90,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" buttonWord:@"刷新" withTipWord:@"获取失败，请连接WiFi重试"];
        _noContentView.delegate = self;
    }
    return _noContentView;
}

#pragma mark - HQTFNoContentViewDelegate
-(void)noContentViewDidClickedButton{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.dict = [HQHelper getCurrentWiFiInfo];
    [self.tableView reloadData];
    if (self.dict) {
        self.tableView.backgroundView = nil;
    }else{
        self.tableView.backgroundView = self.noContentView;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (self.dict) {
        self.tableView.backgroundView = nil;
    }else{
        self.tableView.backgroundView = self.noContentView;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dict) {
        return 1;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFAddressWayCell *cell = [TFAddressWayCell addressWayCellWithTableView:tableView];
    
    cell.cellType = 1;
    [cell configAddWiFiPCCellWithTableView:self.select];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.select == 1) {
        
        self.select = 0;
    }
    else {
        
        self.select = 1;
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 117;
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

#pragma mark 保存
- (void)saveAction {
    
    if (self.select == 0) {
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    
    NSDictionary *dic = [HQHelper getCurrentWiFiInfo];
    TFAddAtdWayModel *model = [[TFAddAtdWayModel alloc] init];
    
    model.name = [dic valueForKey:@"WiFiName"];
    model.address = [dic valueForKey:@"MacAddress"];
    model.location = [NSArray<TFAtdLocationModel,Optional>  array];
    model.effectiveRange  = @100;
    model.wayType = @"1";
    
    [self.atdBL requestAddAttendanceWayWithModel:model];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceWaySave) {
        
        [MBProgressHUD showError:@"添加成功" toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
