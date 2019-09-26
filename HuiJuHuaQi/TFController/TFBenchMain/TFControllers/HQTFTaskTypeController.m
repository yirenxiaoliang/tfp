//
//  HQTFTaskTypeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskTypeController.h"
#import "HQTFTaskCell.h"
#import "TFMainTaskModel.h"
#import "HQTFNoContentCell.h"

@interface HQTFTaskTypeController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong)UITableView *tableView;

/** 任务数组 */
@property (nonatomic, strong) NSMutableArray *tasks;

@end

@implementation HQTFTaskTypeController

-(NSMutableArray *)tasks{
    
    if (!_tasks) {
        _tasks = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            TFMainTaskModel *model = [[TFMainTaskModel alloc] init];
            model.taskDelay = i % 2;
            model.taskPriority = i % 3;
            model.taskFinished = (i +arc4random_uniform(2))% 2;
            model.taskTitle = @"我是一个假的任务我是一个假的任务我是一个假的任务我是一个假的任务";
            model.taskContent = @"我是一个假的任务我是一个假的任务我一个假的任务我是一个假的任务我是一个一个假的任务我是一个假的任务我是一个一个假的任务我是一个假的任务我是一个是一个假的任务我是一个假的任务";
            model.taskSource = [NSString stringWithFormat:@"我是一个任务%ld",i];
            model.taskDate = @([HQHelper getNowTimeSp] - 1000*24*60*60*i);
            [_tasks addObject:model];
        }
    }
    return _tasks;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.layer.masksToBounds = NO;
    
    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    //    label.backgroundColor = GreenColor;
    tableView.tableFooterView = label;
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
    return self.tasks.count;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tasks.count) {
        
        HQTFTaskCell *cell = [HQTFTaskCell taskCellWithTableView:tableView];
        //            [cell refreshTaskCellWithModel:self.tasks[indexPath.row]];
        [cell refreshSolidTaskCellWithModel:self.tasks[indexPath.row]];
        cell.bottomLine.hidden = YES;
        return cell;
    }else{
        
        HQTFNoContentCell *cell = [HQTFNoContentCell noContentCellWithTableView:tableView withImage:@"图123" withText:@"今天任务完成，喝杯咖啡思考人生"];
        cell.bottomLine.hidden = YES;
        cell.backgroundColor = ClearColor;
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Long(0);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tasks.count == 0) {
        return Long(0);
    }else{
        
        //            return [HQTFTaskCell refreshTaskCellHeightWithModel:self.tasks[indexPath.row]];
        return [HQTFTaskCell refreshSolidTaskCellHeightWithModel:self.tasks[indexPath.row]];
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
