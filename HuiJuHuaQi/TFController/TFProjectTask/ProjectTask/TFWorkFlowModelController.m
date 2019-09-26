//
//  TFWorkFlowModelController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkFlowModelController.h"
#import "HQSelectTimeCell.h"
#import "TFWorkFlowPreviewController.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"

@interface TFWorkFlowModelController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** flows */
@property (nonatomic, strong) NSMutableArray *flows;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFWorkFlowModelController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)flows{
    if (!_flows) {
        _flows = [NSMutableArray array];
    }
    return _flows;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requsetGetProjectWorkflow];
    
    [self setupTableView];
    self.navigationItem.title = @"工作流模板";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.flows removeAllObjects];
    [self.flows addObjectsFromArray:resp.body];
    [self.tableView reloadData];
    
    if (self.flows.count) {
        self.tableView.backgroundView = [UIView new];
    }else{
        self.tableView.backgroundView = self.noContentView;
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
    cell.titltW.constant = SCREEN_WIDTH - 30;
    cell.time.hidden = YES;
    NSDictionary *dict = self.flows[indexPath.row];
    cell.timeTitle.text = [dict valueForKey:@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    NSDictionary *dict = self.flows[indexPath.row];
    TFWorkFlowPreviewController *preview = [[TFWorkFlowPreviewController alloc] init];
    preview.workflowId = [dict valueForKey:@"id"];
    preview.sureAction = ^(NSArray *nodes){
        
        if (self.parameter) {
            NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:dict];
            if (nodes) {
                [dd setObject:nodes forKey:@"nodes"];
            }
            self.parameter(dd);
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [self.navigationController pushViewController:preview animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
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
