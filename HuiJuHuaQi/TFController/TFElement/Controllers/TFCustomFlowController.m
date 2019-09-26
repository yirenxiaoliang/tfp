//
//  TFCustomFlowController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomFlowController.h"
#import "TFApprovalFlowProgramCell.h"
#import "TFCustomBL.h"
#import "TFApprovalFlowModel.h"

@interface TFCustomFlowController ()<UITableViewDelegate, UITableViewDataSource,HQBLDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** 流程 */
@property (nonatomic, strong) NSArray *approvals;


@end

@implementation TFCustomFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    [self.customBL requsetApprovalWholeFlowWithProcessDefinitionId:[self.processInstanceId description] bean:self.bean dataId:[self.dataId description]];
    
    [self setupTableView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationItem.title = @"流程";
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customApprovalWholeFlow) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.approvals = resp.body;
        
        for (NSInteger i = 1; i < self.approvals.count; i++) {
            TFApprovalFlowModel *flow = self.approvals[i-1];
            
            TFApprovalFlowModel *nextflow = self.approvals[i];
            
            nextflow.previousColor = flow.selfColor;
            
            if ([nextflow.process_type isEqualToNumber:@0]) {// 固定流程
                
                if ([flow.task_key isEqualToString:nextflow.task_key]) {
                    
                    if ([nextflow.task_status_id isEqualToString:@"4"] || [nextflow.task_status_id isEqualToString:@"5"]) {
                        
                        nextflow.dot = @0;
                    }else{
                        nextflow.dot = @1;
                    }
                }else{
                    nextflow.dot = @0;
                }
            }else{// 自由流程
                flow.dot = @0;
                nextflow.dot = @0;
                
            }
            
        }

    }
    
    [self.tableView reloadData];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFApprovalFlowProgramCell *cell = [TFApprovalFlowProgramCell approvalFlowProgramCellWithTableView:tableView];
    
    [cell refreshApprovalFlowProgramCellWithModels:self.approvals];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFApprovalFlowProgramCell refreshApprovalFlowProgramCellHeightWithModels:self.approvals];
    
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
