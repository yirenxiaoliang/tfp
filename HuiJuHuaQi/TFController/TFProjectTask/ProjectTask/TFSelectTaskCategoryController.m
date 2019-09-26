//
//  TFSelectTaskCategoryController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/10.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectTaskCategoryController.h"
#import "TFProjectTaskBL.h"
#import "TFSelectTaskListController.h"
#import "HQSelectTimeCell.h"
#import "TFProjectModel.h"

@interface TFSelectTaskCategoryController ()<HQBLDelegate,UITableViewDelegate,UITableViewDataSource>
/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, weak) UITableView *tableView;


/** allProjects */
@property (nonatomic, strong) NSMutableArray *allProjects;
@end

@implementation TFSelectTaskCategoryController

-(NSMutableArray *)allProjects{
    if (!_allProjects) {
        _allProjects = [NSMutableArray array];
    }
    return _allProjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    [self.projectTaskBL requsetAllProjectWithKeyword:@"" type:0];// 所有项目
    [self setupTableView];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allProjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    TFProjectModel *model = self.allProjects[indexPath.row];
    cell.timeTitle.text = model.name;
    cell.titltW.constant = SCREEN_WIDTH - 30 - 30;
    cell.arrow.image = IMG(@"下一级浅灰");
    if (self.allProjects.count -1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    cell.topLine.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    TFProjectModel *model = self.allProjects[indexPath.row];
    TFSelectTaskListController *list = [[TFSelectTaskListController alloc] init];
    list.projectId = model.id;
    list.parameterAction = ^(NSArray *parameter){
        [self.navigationController popViewControllerAnimated:NO];
        if (self.parameterAction) {
            self.parameterAction(parameter);
        }
    };
    [self.navigationController pushViewController:list animated:YES];
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getAllProject) {
        
        [self.allProjects removeAllObjects];
        
        TFProjectModel *model = [[TFProjectModel alloc] init];
        model.name = @"个人任务";
        [self.allProjects addObject:model];
        [self.allProjects addObjectsFromArray:resp.body];
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
