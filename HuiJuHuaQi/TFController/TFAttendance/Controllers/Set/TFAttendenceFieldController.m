//
//  TFAttendenceFieldController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendenceFieldController.h"
#import "TFCustomSelectCell.h"

@interface TFAttendenceFieldController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation TFAttendenceFieldController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择字段";
    for (TFAttendenceFieldModel *model in self.datas) {
        model.select = @0;
        if ([model.field_name isEqualToString:self.field.field_name]) {
            model.select = @1;
        }
    }
    [self setupTableView];
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
    
    TFAttendenceFieldModel *model = self.datas[indexPath.row];
    TFCustomSelectCell *cell = [TFCustomSelectCell CustomSelectCellWithTableView:tableView];
    [cell refreshCustomSelectFieldWithModel:model];
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
    
    for (TFAttendenceFieldModel *model in self.datas) {
        model.select = @0;
    }
    TFAttendenceFieldModel *model = self.datas[indexPath.row];
    model.select = @1;
    [self.tableView reloadData];
    
    if (self.action) {
        self.action(model);
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
