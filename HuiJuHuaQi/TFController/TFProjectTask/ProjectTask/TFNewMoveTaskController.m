//
//  TFNewMoveTaskController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNewMoveTaskController.h"
#import "TFProjectColumnModel.h"
#import "TFProjectSectionModel.h"
#import "TFProjectTaskBL.h"
#import "HQSelectTimeCell.h"
#import "TFSelectTaskRowController.h"

@interface TFNewMoveTaskController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 分组 */
@property (nonatomic, strong) TFProjectSectionModel *sectionModel;
/** 列 */
@property (nonatomic, strong) TFProjectSectionModel *rowModel;
/** 子列 */
@property (nonatomic, strong) TFProjectSectionModel *childRowModel;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** alls */
@property (nonatomic, strong) NSArray *alls;

@end

@implementation TFNewMoveTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.projectTaskBL requestGetProjectAllDotWithProjectId:self.projectId];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    if (self.type == 0) {
        self.navigationItem.title = @"移动任务";
    }else{
        self.navigationItem.title = @"复制任务";
    }
}

- (void)sure{
    
    if (self.sectionModel == nil) {
        [MBProgressHUD showError:@"请选择分组" toView:self.view];
        return;
    }
    if (self.rowModel == nil) {
        [MBProgressHUD showError:@"请选择列" toView:self.view];
        return;
    }
//    if (self.rowModel.subnodeArr.count) {// 有子列
    if ([self.rowModel.children_data_type isEqualToString:@"1"]) {// 有子列
        if (self.childRowModel == nil) {
            [MBProgressHUD showError:@"请选择子列" toView:self.view];
            return;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {// 移动
        
//        [self.projectTaskBL requestMoveTaskToTaskRowId:self.childRowModel.id?self.childRowModel.id:self.rowModel.id originalNodeId:self.childRowId?self.childRowId:self.rowId taskId:self.taskId];
        
    }else{// 复制
        
//        [self.projectTaskBL requestCopyTaskToTaskRowId:self.childRowModel.id?self.childRowModel.id:self.rowModel.id sectionId:self.sectionModel.id taskId:self.taskId];

    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectAllDot) {
        
        NSMutableArray *arrs = [NSMutableArray array];
        for (TFProjectColumnModel *model in resp.body) {
            TFProjectSectionModel *se = [[TFProjectSectionModel alloc] init];
            se.id  = model.id;
            se.name = model.name;
            se.subnodeArr = model.subnodeArr;
            [arrs addObject:se];
        }
        
        self.alls = arrs;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self setupTableView];
        
    }
    
    if (resp.cmdId == HQCMD_taskMoveToOther || resp.cmdId == HQCMD_taskCopyToOther) {// 移动 or 复制
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.type == 1) {
            [MBProgressHUD showImageSuccess:@"复制成功" toView:KeyWindow];
        }else{
            [MBProgressHUD showImageSuccess:@"移动成功" toView:KeyWindow];
        }
        if (self.refreshAction) {
            self.refreshAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        // 移动起点
        [dict setObject:self.childRowId?:self.rowId forKey:@"startSectionId"];
        
        // 移动终点
        [dict setObject:self.childRowModel.id?:self.rowModel.id forKey:@"endSectionId"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ProjectTaskMoveNotification object:dict];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.timeTitle.font = FONT(16);
    cell.titltW.constant = SCREEN_WIDTH-30;
    cell.requireLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bottomLine.hidden = NO;
    cell.arrow.hidden = NO;
    cell.arrow.image = [UIImage imageNamed:@"下一级浅灰"];

    if (indexPath.section == 0) {
        cell.timeTitle.text = self.sectionModel.name?:@"请选择";
        if (self.sectionModel.name) {
            cell.timeTitle.textColor = BlackTextColor;
        }else{
            cell.timeTitle.textColor = LightGrayTextColor;
        }
    }else if (indexPath.section == 1){
        cell.timeTitle.text = self.rowModel.name?:@"请选择";
        if (self.rowModel.name) {
            cell.timeTitle.textColor = BlackTextColor;
        }else{
            cell.timeTitle.textColor = LightGrayTextColor;
        }
    }else{
        cell.timeTitle.text = self.childRowModel.name?:@"请选择";
        if (self.childRowModel.name) {
            cell.timeTitle.textColor = BlackTextColor;
        }else{
            cell.timeTitle.textColor = LightGrayTextColor;
        }
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    TFSelectTaskRowController *task = [[TFSelectTaskRowController alloc] init];
    task.type = indexPath.section;
    if (indexPath.section == 0) {
        task.datas = self.alls;
        task.selectModel = self.sectionModel;
        task.parameter = ^(TFProjectSectionModel *parameter) {
            self.sectionModel = parameter;
            self.rowModel = nil;
            self.childRowModel = nil;
            [self.tableView reloadData];
        };
    }else if (indexPath.section == 1){
        task.datas = self.sectionModel.subnodeArr;
        task.selectModel = self.rowModel;
        task.parameter = ^(TFProjectSectionModel *parameter) {
            self.rowModel = parameter;
            self.childRowModel = nil;
            [self.tableView reloadData];
        };
    }else{
        task.datas = self.rowModel.subnodeArr;
        task.selectModel = self.childRowModel;
        task.parameter = ^(TFProjectSectionModel *parameter) {
            self.childRowModel = parameter;
            [self.tableView reloadData];
        };
    }
    [self.navigationController pushViewController:task animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 50;
    }else if (indexPath.section == 1){
        if (self.sectionModel) {
            return 50;
        }else{
            return 0;
        }
    }else{
//        if (self.rowModel && self.rowModel.subnodeArr.count) {
        if (self.rowModel && [self.rowModel.children_data_type isEqualToString:@"1"]) {
            return 50;
        }else{
            return 0;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 40;
    }else if (section == 1){
        if (self.sectionModel) {
            return 40;
        }else{
            return 0;
        }
    }else{
        //        if (self.rowModel && self.rowModel.subnodeArr.count) {
        if (self.rowModel && [self.rowModel.children_data_type isEqualToString:@"1"]) {
            return 40;
        }else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,40}];
    [view addSubview:label];
    label.textColor = ExtraLightBlackTextColor;
    if (section == 0) {
        label.text = @"选择分组";
    }else if (section == 1){
        label.text = @"选择列";
    }else{
        label.text = @"选择子列";
    }
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
