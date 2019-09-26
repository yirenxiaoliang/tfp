//
//  TFMoveTaskController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMoveTaskController.h"
#import "HQSelectTimeCell.h"
#import "TFProjectTaskBL.h"
#import "TFProjectRowModel.h"
#import "TFProjectTaskDetailController.h"

@interface TFMoveTaskController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** sections */
@property (nonatomic, strong) NSMutableArray *sections;
/** rows */
@property (nonatomic, strong) NSMutableArray *rows;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** selectRow */
@property (nonatomic, strong) TFProjectRowModel *selectRow;


@end

@implementation TFMoveTaskController

-(NSMutableArray *)sections{
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

-(NSMutableArray *)rows{
    if (!_rows) {
        _rows = [NSMutableArray array];
    }
    return _rows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    if (self.type == 1) {// 任务分组
        [self.projectTaskBL requestGetProjectColumnWithProjectId:self.projectId];
    }
    if (self.type == 2) {// 任务列
        [self.projectTaskBL requestGetProjectSectionWithColumnId:self.sectionId];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectColumn) {
        
        self.sections = resp.body;
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_getProjectSection) {
        
        self.rows = resp.body;
        
        for (TFProjectRowModel *model in self.rows) {
            
            model.sectionId = model.main_id;
            if ([model.id isEqualToNumber:self.rowId]) {
                model.hidden = @"1";
                self.selectRow = model;
            }else{
                model.hidden = @"0";
            }
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_taskMoveToOther || resp.cmdId == HQCMD_taskCopyToOther) {// 移动 or 复制
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.isCopy == 1) {
            [MBProgressHUD showImageSuccess:@"复制成功" toView:KeyWindow];
        }else{
            [MBProgressHUD showImageSuccess:@"移动成功" toView:KeyWindow];
        }
        if (self.refreshAction) {
            self.refreshAction();
        }
        
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[TFProjectTaskDetailController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        // 移动起点
        [dict setObject:self.startSectionId forKey:@"startSectionId"];
        
        // 移动终点
        [dict setObject:self.selectRow.sectionId forKey:@"endSectionId"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ProjectTaskMoveNotification object:dict];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}



- (void)setupNavi{
    if (self.type == 0) {
        if (self.isCopy == 1) {
            self.navigationItem.title = @"复制任务";
        }else{
            self.navigationItem.title = @"移动任务";
        }
    }else if (self.type == 1){
        self.navigationItem.title = @"选择分组";
    }else{
        self.navigationItem.title = @"选择列";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    }
}

- (void)sure{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.isCopy == 1) {// 复制任务
        
//        [self.projectTaskBL requestCopyTaskToTaskRowId:self.selectRow.id sectionId:self.selectRow.sectionId taskId:self.taskId];
    }else{// 移动任务
//        [self.projectTaskBL requestMoveTaskToTaskRowId:self.selectRow.id originalNodeId:self.rowId taskId:self.taskId];
    }
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 0) {
        return 2;
    }else if (self.type == 1){
        return self.sections.count;
    }else{
        return self.rows.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0) {
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.textColor = BlackTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.isCopy == 1) {
            if (indexPath.row == 0) {
                cell.timeTitle.text = @"复制到分组";
            }else{
                cell.timeTitle.text = @"复制到列";
            }
        }else{
            if (indexPath.row == 0) {
                cell.timeTitle.text = @"移动到分组";
            }else{
                cell.timeTitle.text = @"移动到列";
            }
        }
        cell.bottomLine.hidden = NO;
        return cell;
        
    }else if (self.type == 1){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.textColor = BlackTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TFProjectRowModel *model = self.sections[indexPath.row];
//        if ([model.id isEqualToNumber:self.sectionId]) {
//            cell.arrow.image = [UIImage imageNamed:@"完成"];
//        }else{
            cell.arrow.image = [UIImage imageNamed:@"下一级浅灰"];
//        }
        cell.timeTitle.text = model.name;
        cell.bottomLine.hidden = NO;
        return cell;
    }else{
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.textColor = BlackTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TFProjectRowModel *model = self.rows[indexPath.row];
        cell.timeTitle.text = model.name;
        cell.bottomLine.hidden = NO;
        if ([model.hidden isEqualToString:@"1"]) {
            cell.arrow.hidden = NO;
            cell.arrow.image = [UIImage imageNamed:@"完成"];
        }else{
            cell.arrow.hidden = YES;
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 0) {// 主界面
        if (indexPath.row == 0) {
            TFMoveTaskController *move = [[TFMoveTaskController alloc] init];
            move.isCopy = self.isCopy;
            move.type = 1;
            move.projectId = self.projectId;
            move.sectionId = self.sectionId;
            move.startSectionId = self.startSectionId;
            move.rowId = self.rowId;
            move.taskId = self.taskId;
            move.refreshAction = ^{
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:move animated:YES];
        }else{
            TFMoveTaskController *move = [[TFMoveTaskController alloc] init];
            move.isCopy = self.isCopy;
            move.type = 2;
            move.projectId = self.projectId;
            move.sectionId = self.sectionId;
            move.startSectionId = self.startSectionId;
            move.rowId = self.rowId;
            move.taskId = self.taskId;
            move.refreshAction = ^{
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:move animated:YES];
        }
    }else if (self.type == 1){// 分组
        
        TFMoveTaskController *move = [[TFMoveTaskController alloc] init];
        move.isCopy = self.isCopy;
        move.type = 2;
        move.projectId = self.projectId;
        TFProjectRowModel *model = self.sections[indexPath.row];
        move.sectionId = model.id;
        move.startSectionId = self.startSectionId;
        move.rowId = self.rowId;
        move.taskId = self.taskId;
        move.refreshAction = ^{
            if (self.refreshAction) {
                self.refreshAction();
            }
        };
        [self.navigationController pushViewController:move animated:YES];
        
    }else{// 列
        
        self.selectRow.hidden = @"0";
        
        TFProjectRowModel *model = self.rows[indexPath.row];
        model.hidden = @"1";
        
        self.selectRow = model;
        
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
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
