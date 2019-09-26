//
//  TFApprovalModuleController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/5.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalModuleController.h"
#import "TFAttendanceBL.h"
#import "TFCustomSelectCell.h"

@interface TFApprovalModuleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;


@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@end

@implementation TFApprovalModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    [self.attendanceBL requestApprovalList];
    
    [self setupTableView];
    
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    if (resp.cmdId == HQCMD_attendanceApprovalModuleList) {
        
        self.datas = resp.body;
        for (TFModuleModel *model in self.datas) {
            if ([self.model.english_name isEqualToString:model.english_name]) {
                model.select = @1;
            }
        }
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    return self.datas.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFModuleModel *model = self.datas[indexPath.row];
    TFCustomSelectCell *cell = [TFCustomSelectCell CustomSelectCellWithTableView:tableView];
    [cell refreshCustomSelectAttendenceWithModel:model];
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (TFModuleModel *model in self.datas) {
        model.select = @0;
    }
    
    TFModuleModel *model = self.datas[indexPath.row];
    model.select = @1;
    [tableView reloadData];
    
    if (self.actionField) {
        self.actionField(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
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
