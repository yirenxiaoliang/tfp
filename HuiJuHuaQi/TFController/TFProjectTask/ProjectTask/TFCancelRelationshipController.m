//
//  TFCancelRelationshipController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCancelRelationshipController.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFNewProjectCustomCell.h"
#import "TFTProjectCustomCell.h"
#import "TFProjectApprovalCell.h"
#import "TFProjectTaskBL.h"

@interface TFCancelRelationshipController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@end

@implementation TFCancelRelationshipController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.navigationItem.title = @"取消关联";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

-(void)sure{
    
    NSString *str = @"";
    for (TFProjectRowFrameModel *model in self.frames) {
        if ([model.projectRow.select isEqualToNumber:@1]) {
//            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[model.projectRow.taskInfoId description]]];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[model.projectRow.bean_id description]]];
        }
    }
    if (str.length > 0) {
        str = [str substringToIndex:str.length - 1];
    }
    if (str.length > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestBoardDataCancelRelationshipWithIds:str];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_boardCancelQuote) {
        
        if (self.refreshAction) {
            self.refreshAction();
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"取消成功" toView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.frames.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFProjectRowFrameModel *model = self.frames[indexPath.row];
    TFProjectRowModel *row = model.projectRow;
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据) */
    if ([row.dataType isEqualToNumber:@2]) {// 任务
        
        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
        cell.frameModel = model;
        cell.selectImage.hidden = ![row.select isEqualToNumber:@1];
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
//        cell.delegate = self;
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@1]){// 备忘录
        
        TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
        cell.frameModel = model;
        cell.selectImage.hidden = ![row.select isEqualToNumber:@1];
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@3]){// 自定义
        
        if (row.rows) {
            
            TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
            cell.frameModel = model;
            cell.selectImage.hidden = ![row.select isEqualToNumber:@1];
            
            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            return cell;
        }
        TFTProjectCustomCell *cell = [TFTProjectCustomCell projectCustomCellWithTableView:tableView];
        cell.frameModel = model;
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else{// 审批
        TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
        cell.frameModel = model;
        cell.selectImage.hidden = ![row.select isEqualToNumber:@1];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFProjectRowFrameModel *frame = self.frames[indexPath.row];
    TFProjectRowModel *row = frame.projectRow;
    row.select = [row.select isEqualToNumber:@1]?@0:@1;
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectRowFrameModel *frame = self.frames[indexPath.row];
    return frame.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
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
