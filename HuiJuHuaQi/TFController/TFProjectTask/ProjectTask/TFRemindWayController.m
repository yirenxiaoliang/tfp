//
//  TFRemindWayController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/15.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRemindWayController.h"
#import "HQSelectTimeCell.h"

@interface TFRemindWayController ()<UITableViewDelegate,UITableViewDataSource>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** ways */
@property (nonatomic, strong) NSMutableArray *ways;


@end

@implementation TFRemindWayController

-(NSMutableArray *)ways{
    if (!_ways) {
        _ways = [NSMutableArray array];
        NSArray *arr = @[@"企信",@"企业微信",@"钉钉",@"邮件"];
        NSInteger i = 0;
        for (NSString *str in arr) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:str forKey:@"name"];
            [dict setObject:@0 forKey:@"select"];
            [dict setObject:@(i) forKey:@"way"];
            [_ways addObject:dict];
            i ++;
        }
        for (NSMutableDictionary *dd in _ways) {
            for (NSDictionary *ddd in self.selectWays) {
                if ([[dd valueForKey:@"way"] isEqualToNumber:[ddd valueForKey:@"way"]]) {
                    [dd setObject:@1 forKey:@"select"];
                    break;
                }
            }
        }
    }
    return _ways;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    self.navigationItem.title = @"提醒方式";
}

- (void)sure{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in self.ways) {
        if ([[dict valueForKey:@"select"] isEqualToNumber:@1]) {
            [arr addObject:dict];
        }
    }
    
    if (arr.count == 0) {
        [MBProgressHUD showError:@"请选择提醒方式" toView:self.view];
        return;
    }
    if (self.parameter) {
        self.parameter(arr);
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
    return self.ways.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    NSDictionary *row = self.ways[indexPath.row];
    cell.timeTitle.text = [row valueForKey:@"name"];
    cell.titltW.constant = SCREEN_WIDTH - 60;
    cell.timeTitle.textColor = CellTitleNameColor;
    if ([[row valueForKey:@"select"] isEqualToNumber:@1]) {
        cell.arrow.image = IMG(@"完成");
    }else{
        cell.arrow.image = nil;
    }
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    NSMutableDictionary *row = self.ways[indexPath.row];
    
    if ([[row valueForKey:@"select"] isEqualToNumber:@0]) {
        [row setObject:@1 forKey:@"select"];
    }else{
        [row setObject:@0 forKey:@"select"];
    }
    [tableView reloadData];
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
