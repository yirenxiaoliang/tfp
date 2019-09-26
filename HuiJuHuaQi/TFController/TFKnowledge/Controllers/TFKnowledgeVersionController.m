//
//  TFKnowledgeVersionController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeVersionController.h"
#import "TFKnowledgeVersionCell.h"
#import "TFKnowledgeBL.h"

@interface TFKnowledgeVersionController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;


@property (nonatomic, strong) NSMutableArray *versions;


@property (nonatomic, strong) TFKnowledgeVersionModel *selectModel;

@end

@implementation TFKnowledgeVersionController

-(NSMutableArray *)versions{
    if (!_versions) {
        _versions = [NSMutableArray array];
    }
    return _versions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.knowledgeBL = [TFKnowledgeBL build];
    self.knowledgeBL.delegate = self;
    [self.knowledgeBL requestKnowledgeVersionWithKnowledgeId:self.dataId];
    
    [self setupTableView];
    self.navigationItem.title = @"版本管理";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

-(void)sure{
    if (!self.selectModel) {
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    if (self.parameter) {
        self.parameter(self.selectModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_knowledgeVersion) {
        
        self.versions = resp.body;
        
        for (TFKnowledgeVersionModel *mo in self.versions) {
            if ([[self.model.id description] isEqualToString:[mo.id description]]) {
                mo.select = @1;
                self.selectModel = mo;
                break;
            }
        }
        if (!self.selectModel) {
            self.selectModel = self.versions.firstObject;
            self.selectModel.select = @1;
        }
        
        [self.tableView reloadData];
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.versions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFKnowledgeVersionCell *cell = [TFKnowledgeVersionCell knowledgeVersionCellWithTableView:tableView];
    cell.bottomLine.hidden = NO;
    [cell refreshCellWithModel:self.versions[indexPath.row]];
    if (self.versions.count-1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    self.selectModel.select = @0;
    TFKnowledgeVersionModel *model = self.versions[indexPath.row];
    model.select = @1;
    self.selectModel = model;
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
