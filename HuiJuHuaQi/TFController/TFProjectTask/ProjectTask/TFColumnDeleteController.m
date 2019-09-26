//
//  TFColumnDeleteController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFColumnDeleteController.h"
#import "HQBaseCell.h"
#import "TFProjectRowModel.h"
#import "TFProjectColumnModel.h"
#import "TFProjectTaskBL.h"


@interface TFColumnDeleteController ()<UITableViewDelegate,UITableViewDataSource, HQBLDelegate,UIAlertViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** rows */
@property (nonatomic, strong) NSMutableArray *rows;

/** selectRow */
@property (nonatomic, strong) TFProjectRowModel *selectRow ;
/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;


@end

@implementation TFColumnDeleteController


-(NSMutableArray *)rows{
    if (!_rows) {
        _rows = [NSMutableArray array];
    }
    return _rows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    [self setupTableView];
    
    for (TFProjectColumnModel *colu in self.columns) {
        
        TFProjectRowModel *task = [[TFProjectRowModel alloc] init];
        task.name = colu.name;
        task.hidden = @"0";
        task.id = colu.id;
        [self.rows addObject:task];
        
    }
    
    [self setupNavigation];
}

- (void)setupNavigation{
    
    self.navigationItem.title = @"删除";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GrayTextColor];
}

- (void)sure{
    
    if (!self.selectRow) {
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除任务分组" message:[NSString stringWithFormat:@"确定要删除分组【%@】吗？删除后该分组下的所有列表和任务将同时被删除。\n\n请输入要删除的任务分组名称",self.selectRow.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    [alert show];
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *str = textField.text;
        
        if ([str isEqualToString:self.selectRow.name]) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [self.projectTaskBL requestDeleteProjectColumnWithColumnId:self.selectRow.id projectId:self.projectId];
        }else{
            
            [MBProgressHUD showError:@"删除不成功" toView:self.view];
            
        }
        
        
    }
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_deleteProjectColumn) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        [self.rows removeObject:self.selectRow];
        [self.tableView reloadData];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
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
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    HQBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HQBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    TFProjectRowModel *row = self.rows[indexPath.row];
    cell.textLabel.text = row.name;
    
    if ([row.hidden isEqualToString:@"0"]) {
        
        cell.imageView.image = [UIImage imageNamed:@"没选中"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"选中"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    self.selectRow.hidden = @"0";
    
    TFProjectRowModel *row = self.rows[indexPath.row];
    
    row.hidden = @"1";
    
    self.selectRow = row;
    
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
