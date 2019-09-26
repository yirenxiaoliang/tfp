//
//  TFHighseaAllocateController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFHighseaAllocateController.h"
#import "TFSelectPeopleCell.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFCustomBL.h"

@interface TFHighseaAllocateController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;


@end

@implementation TFHighseaAllocateController

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self setupTableView];
    [self setupNavi];
}

- (void)setupNavi{
    
    self.navigationItem.title = @"分配给";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
    
}

- (void)sure{
    
    if (!self.peoples.count) {
        
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HQEmployModel *model = self.peoples[0];
    [self.customBL requestHighseaAllocateWithDataId:self.dataId bean:self.bean employeeId:model.id];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_highseaAllocate) {
        
        [MBProgressHUD showSuccess:@"分配成功" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:NO];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
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
    
    TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
    cell.titleLabel.text = @"分配给";
    cell.fieldControl = @"2";
    [cell refreshSelectPeopleCellWithPeoples:self.peoples structure:@"1" chooseType:@"0" showAdd:YES clear:NO];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = YES;
    scheduleVC.actionParameter = ^(id parameter) {
        
        [self.peoples addObjectsFromArray:parameter];
        
        [self.tableView reloadData];
        
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFSelectPeopleCell refreshSelectPeopleCellHeightWithStructure:@"1"];
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
