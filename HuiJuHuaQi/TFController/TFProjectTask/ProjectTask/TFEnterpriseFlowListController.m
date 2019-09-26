
//
//  TFEnterpriseFlowListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterpriseFlowListController.h"
#import "HQSelectTimeCell.h"
#import "TFProjectTaskBL.h"
#import "TFProjectSectionModel.h"

@interface TFEnterpriseFlowListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** flows */
@property (nonatomic, strong) NSMutableArray *flows;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;


@end

@implementation TFEnterpriseFlowListController

-(NSMutableArray *)flows{
    if (!_flows) {
        _flows = [NSMutableArray array];
    }
    return _flows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestEnterpriseWorkBenchFlow];
    self.navigationItem.title = @"选择企业工作流";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
    [self setupTableView];
}

- (void)sure{
    
    NSDictionary *selDict = nil;
    for (NSDictionary *dict in self.flows) {
        if ([dict valueForKey:@"select"]) {
            selDict = dict;
            break;
        }
    }
    
    if (selDict == nil) {
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    
    if (self.parameter) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in [selDict valueForKey:@"nodes"]) {
            TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
            model.name = [dict valueForKey:@"text"];
            model.key = [dict valueForKey:@"key"];
            [arr addObject:model];
        }
        self.parameter(arr);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_enterpriseWorkBenchFlow) {
        
        NSArray *arr = resp.body;
        [self.flows  removeAllObjects];
        for (NSDictionary *dict in arr) {
            NSMutableDictionary *dd = [NSMutableDictionary dictionary];
            [dd setObject:[dict valueForKey:@"id"] forKey:@"id"];
            [dd setObject:[dict valueForKey:@"name"] forKey:@"name"];
            
            NSMutableArray *nodes = [NSMutableArray array];
            if ([[dict valueForKey:@"node_data_array"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *di in [dict valueForKey:@"node_data_array"]) {
                    
                    NSMutableDictionary *ccc = [NSMutableDictionary dictionary];
                    [ccc setObject:[di valueForKey:@"text"] forKey:@"text"];
                    [ccc setObject:[di valueForKey:@"key"] forKey:@"key"];
                    [nodes addObject:ccc];
                }
            }
            
            [dd setObject:nodes forKey:@"nodes"];
            [self.flows addObject:dd];
        }
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.flows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.timeTitle.textColor = BlackTextColor;
    cell.timeTitle.font = FONT(16);
    cell.titltW.constant = SCREEN_WIDTH-30;
    cell.requireLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dict = self.flows[indexPath.row];
    cell.timeTitle.text = [dict valueForKey:@"name"];
    if ([dict valueForKey:@"select"]) {
        cell.arrow.image = [UIImage imageNamed:@"选中"];
    }else{
        cell.arrow.image = [UIImage imageNamed:@"没选中"];
    }
    if (self.flows.count-1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    for (NSMutableDictionary *dict in self.flows) {
        if ([dict valueForKey:@"select"]) {
            [dict removeObjectForKey:@"select"];
        }
    }
    
    NSMutableDictionary *dict = self.flows[indexPath.row];
    [dict setObject:@1 forKey:@"select"];
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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
