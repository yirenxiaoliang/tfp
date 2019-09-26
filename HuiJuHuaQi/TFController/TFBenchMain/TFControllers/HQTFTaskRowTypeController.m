//
//  HQTFTaskRowTypeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskRowTypeController.h"
#import "HQTFTaskTableViewCell.h"
#import "HQTFNoContentCell.h"

@interface HQTFTaskRowTypeController ()<UITableViewDelegate,UITableViewDataSource,HQTFTaskTableViewCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** taskList */
@property (nonatomic, strong) NSMutableArray *taskList;

@end

@implementation HQTFTaskRowTypeController

-(NSMutableArray *)taskList{
    if (!_taskList) {
        _taskList = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 3; i ++) {
            
            
//            TFProjTaskModel *model = [[TFProjTaskModel alloc] init];
//            model.creatorId = @(1111+i);
//            model.content = [NSString stringWithFormat:@"%@--%ld",@"我是项目任务是项目任务的是项目任务的是项目任务的的标题",i];
//            model.priority = @(i % 3);
//            model.deadline = @([HQHelper getNowTimeSp] + 1000 * 3 * 24 * 60 * 60);
//            model.desc = [NSString stringWithFormat:@"我是项目任务的描述类容呀，请多多关注。"];
//            model.isPublic = @(i % 2);
//            model.isFinish = @(i % 2);
//            model.numberType = @(i % 2);
//            model.numberSum = @"10000000000";
//            model.numberUnit = @"元";
//            model.relatedItemCount = @12;
//            model.isPublic = @(i % 2);
            
//            NSMutableArray *parts = [NSMutableArray array];
//            for (NSInteger j = 4-i; j <= 4; j ++) {
//                TFProjParticipantModel *part = [[TFProjParticipantModel alloc] init];
//                [parts addObject:part];
//            }
//            model.managers = parts;
            
//            NSMutableArray *labels = [NSMutableArray array];
//            for (NSInteger j = i; j < 3; j ++) {
//                TFProjLabelModel *mo = [[TFProjLabelModel alloc] init];
//                if (i == 0) {
//                    mo.labelName = @"我是个镖旗";
//                }else if (i == 1) {
//                    
//                    mo.labelName = @"我是个";
//                }else{
//                    mo.labelName = @"我";
//                }
//                mo.labelColor = [NSString stringWithFormat:@"#ff0000"];
//                [labels addObject:mo];
//            }
//            model.labels = labels;
//            [_taskList addObject:model];
//        }

    }
    return _taskList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
    [self setupTableView];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-83) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = HexColor(0xEBEDF0, 1);
    tableView.layer.masksToBounds = NO;
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
    return self.taskList.count;
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
    
    if (self.taskList.count) {
        
        HQTFTaskTableViewCell *cell = [HQTFTaskTableViewCell taskTableViewCellWithTableView:tableView];
        [cell refreshTaskTableViewCellWithModel:self.taskList[indexPath.row] type:1];
        cell.delegate = self;
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
    
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.taskList.count) {
        return [HQTFTaskTableViewCell refreshTaskTableViewCellHeightWithModel:self.taskList[indexPath.row] type:1];
    }else{
        return SCREEN_HEIGHT-64-83-49;
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
