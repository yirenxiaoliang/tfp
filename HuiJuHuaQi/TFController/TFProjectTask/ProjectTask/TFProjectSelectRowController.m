//
//  TFProjectSelectRowController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectSelectRowController.h"
#import "HQSelectTimeCell.h"
#import "TFProjectTaskBL.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "TFProjectListModel.h"

@interface TFProjectSelectRowController ()<UITableViewDataSource,UITableViewDelegate,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** datas */
@property (nonatomic, strong) NSMutableArray *datas;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
/** selectRow */
@property (nonatomic, strong) TFProjectRowModel *selectRow;

@end

@implementation TFProjectSelectRowController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.pageSize = 30;
    self.pageNum = 1;
    
    if (self.type == 0) {
        [self.projectTaskBL requestGetProjectListWithType:self.type PageNo:@(self.pageNum) pageSize:@(self.pageSize) keyword:nil];
        self.navigationItem.title = @"选择项目";
        
    }else if (self.type == 1){
        [self.projectTaskBL requestGetProjectColumnWithProjectId:self.projectId];
        self.navigationItem.title = @"选择任务分组";
    }else{
        [self.projectTaskBL requestGetProjectSectionWithColumnId:self.sectionId];
        self.navigationItem.title = @"选择任务列";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    }
    
    [self setupTableView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)sure{
    
    if (self.selectRow == nil) {
        [MBProgressHUD showError:@"请选择任务列" toView:self.view];
        return;
    }
    
    if (self.parameterAction) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.selectRow.id forKey:@"rowId"];
        [dict setObject:self.selectRow.name forKey:@"rowName"];
        
        [self.navigationController popViewControllerAnimated:NO];
        self.parameterAction(dict);
    }
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_getProjectList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFProjectListModel *model = resp.body;
        
        TFCustomPageModel *listModel = model.pageInfo;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.datas removeAllObjects];
        }
        
        [self.datas addObjectsFromArray:model.dataList];
        
        
        if ([listModel.totalRows integerValue] <= self.datas.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.datas.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_getProjectColumn) {
        
        self.datas = resp.body;
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getProjectSection) {
        
        self.datas = resp.body;
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
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
    
    if (self.type == 0) {
        
        tableView.mj_header = [TFRefresh headerGifRefreshWithBlock:^{
            
            self.pageNum = 1;
            [self.projectTaskBL requestGetProjectListWithType:self.type PageNo:@(self.pageNum) pageSize:@(self.pageSize) keyword:nil];
            
        }];
        tableView.mj_footer = [TFRefresh footerBackRefreshWithBlock:^{
            
            self.pageNum ++;
            [self.projectTaskBL requestGetProjectListWithType:self.type PageNo:@(self.pageNum) pageSize:@(self.pageSize) keyword:nil];
            
        }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0) {
        
        TFProjectModel *model = self.datas[indexPath.row];
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.timeTitle.text = model.name;
//        cell.arrowShowState = YES;
        if ([model.selectState isEqualToNumber:@1]) {
            cell.arrow.hidden = NO;
            cell.arrow.image = [UIImage imageNamed:@"完成"];
        }else{
            cell.arrow.hidden = YES;
        }
        return cell;
    }else if (self.type == 1){
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.textColor = BlackTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TFProjectRowModel *model = self.datas[indexPath.row];
        cell.arrow.image = [UIImage imageNamed:@"下一级浅灰"];
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
        TFProjectRowModel *model = self.datas[indexPath.row];
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
    
    if (self.type == 0) {
        
        TFProjectModel *model = self.datas[indexPath.row];
        
        if (self.parameterAction) {
            [self.navigationController popViewControllerAnimated:NO];
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            [parameter setObject:model.id forKey:@"projectId"];
            [parameter setObject:model.name forKey:@"projectName"];

            self.parameterAction(parameter);
        }
        
//        TFProjectSelectRowController *pro = [[TFProjectSelectRowController alloc] init];
//        pro.projectId = model.id;
//        pro.type = 1;
//        pro.parameterAction = ^(NSMutableDictionary *parameter) {
//
//            if (self.parameterAction) {
//                [self.navigationController popViewControllerAnimated:NO];
//
//                [parameter setObject:model.id forKey:@"projectId"];
//                [parameter setObject:model.name forKey:@"projectName"];
//
//                self.parameterAction(parameter);
//            }
//
//        };
//
//        [self.navigationController pushViewController:pro animated:YES];
        
    }else if (self.type == 1){
        
        TFProjectRowModel *model = self.datas[indexPath.row];

        TFProjectSelectRowController *pro = [[TFProjectSelectRowController alloc] init];
        pro.sectionId = model.id;
        pro.type = 2;
        pro.parameterAction = ^(NSMutableDictionary *parameter) {
        
            if (self.parameterAction) {
                [self.navigationController popViewControllerAnimated:NO];
                
                [parameter setObject:model.id forKey:@"sectionId"];
                [parameter setObject:model.name forKey:@"sectionName"];
                
                self.parameterAction(parameter);
            }
            
        };
        
        [self.navigationController pushViewController:pro animated:YES];
        
    }else{
        
        self.selectRow.hidden = @"0";
        
        TFProjectRowModel *model = self.datas[indexPath.row];
        model.hidden = @"1";
        
        self.selectRow = model;
        
        [self.tableView reloadData];
        
    }
    
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
