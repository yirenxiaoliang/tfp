//
//  TFStatisticsTitleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsTitleController.h"
#import "TFBeanTypeModel.h"
#import "HQSelectTimeCell.h"

@interface TFStatisticsTitleController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;


@end

@implementation TFStatisticsTitleController

-(NSMutableArray *)lists{
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray<TFBeanTypeModel> *arr = [NSMutableArray<TFBeanTypeModel> array];
    NSArray *titles = @[@"最近报表",@"全部报表",@"共享给我的报表",@"我创建的报表"];
    for (NSInteger i = 0; i < titles.count; i ++) {
        TFBeanTypeModel *model = [[TFBeanTypeModel alloc] init];
        model.name = [NSString stringWithFormat:@"%@",titles[i]];
        model.menu_code = @(i);
        [arr addObject:model];
    }
    self.lists = arr;
    
    [self setupTableView];
    self.navigationItem.title = @"选择报表";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
}
- (void)sure{
    
    if (self.refresh) {
        self.refresh(self.model);
        [self.navigationController popViewControllerAnimated:YES];
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
    return self.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFBeanTypeModel *model = self.lists[indexPath.row];
    HQSelectTimeCell  *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.requireLabel.hidden = YES;
    cell.timeTitle.text = model.name;
    cell.titltW.constant = SCREEN_WIDTH-30;
    if ([model.menu_code isEqualToNumber:self.model.menu_code]) {
        cell.arrow.image = [UIImage imageNamed:@"完成30"];
        cell.arrow.hidden = NO;
    }else{
        cell.arrow.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    self.model = self.lists[indexPath.row];
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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
