//
//  TFAgainMoveTaskController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAgainMoveTaskController.h"
#import "TFProjectTaskBL.h"
#import "TFMoveSelectCell.h"

@interface TFAgainMoveTaskController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFMoveSelectCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, strong) TFProjectNodeModel *selectModel;
@end

@implementation TFAgainMoveTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    if (!self.projectNode) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestAllNodeWithProjectId:self.projectId limitNodeType:@1 filterParam:nil];
    }else{
        self.navigationItem.title = self.projectNode.node_name;
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNode:) name:@"TFMoveSelectCellSelectNotification" object:nil];
}
-(void)selectNode:(NSNotification *)note{
    self.selectModel.select = @0;
    
    self.selectModel = note.object;
    self.selectModel.select = @1;
    [self.tableView reloadData];
}

- (void)sure{
    BOOL have = NO;
    for (TFProjectNodeModel *model in self.projectNode.child) {
        if ([model.select isEqualToNumber:@1]) {
            have = YES;
            break;
        }
    }
    if (have) {
        if (self.refreshAction) {
            [self.navigationController popViewControllerAnimated:NO];
            self.refreshAction(self.selectModel);
        }
    }else{
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectAllNode) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = [resp.body valueForKey:@"rootNode"];
        self.projectNode = [[TFProjectNodeModel alloc] initWithDictionary:dict error:nil];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.navigationItem.title = self.projectNode.node_name;
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projectNode.child.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFMoveSelectCell *cell = [TFMoveSelectCell moveSelectCellWithTableView:tableView];
    cell.delegate = self;
    TFProjectNodeModel *model = self.projectNode.child[indexPath.row];
    [cell refreshMoveSelectCellWithModel:model];
    if (indexPath.row == self.projectNode.child.count - 1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectNodeModel *model = self.projectNode.child[indexPath.row];
    if (model.child.count) {
        
        TFAgainMoveTaskController *again = [[TFAgainMoveTaskController alloc] init];
        again.projectId = self.projectId;
        again.projectNode = self.projectNode.child[indexPath.row];
        again.refreshAction = ^(id parameter) {
            
            [self.navigationController popViewControllerAnimated:NO];
            if (self.refreshAction) {
                self.refreshAction(parameter);
            }
        };
        [self.navigationController pushViewController:again animated:YES];
        
    }else{
        [MBProgressHUD showError:@"没有下一级了" toView:self.view];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
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

#pragma mark - TFMoveSelectCellDelegate
-(void)moveSelectCellDidClickedSelectWithModel:(TFProjectNodeModel *)model{
    
    self.selectModel = model;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TFMoveSelectCellSelectNotification" object:model];
    
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
