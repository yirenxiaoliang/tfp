//
//  TFColumnListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFColumnListController.h"
#import "TFMoveView.h"
#import "TFProjectSectionModel.h"
#import "TFTaskColumnAddController.h"
#import "TFColumnDeleteController.h"
#import "TFProjectTaskBL.h"

@interface TFColumnListController ()<TFMoveViewDelegate,HQBLDelegate,UIAlertViewDelegate>
/** moveView */
@property (nonatomic, weak) TFMoveView *moveView;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** selectRow */
@property (nonatomic, strong) TFProjectRowModel *selectRow ;

@end

@implementation TFColumnListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    self.enablePanGesture = YES;
    TFMoveView *moveView = [[TFMoveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight)];
    moveView.delegate = self;
    self.moveView = moveView;
    [self.view addSubview:moveView];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 1; i++) {
        TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
        NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
        
        for (TFProjectColumnModel *colu in self.columns) {
            
            TFProjectRowModel *task = [[TFProjectRowModel alloc] init];
            task.name = colu.name;
            task.hidden = @"0";
            task.id = colu.id;
            [tasks addObject:task];
            
        }
        
        model.tasks = tasks;
        [arr addObject:model];
    }
    
    [moveView refreshMoveViewWithModels:arr withType:1];
    
    // 导航
    [self setupNavigation];
}

-(void)moveView:(TFMoveView *)moveView dataChanged:(NSArray *)models destinationIndex:(NSInteger)destinationIndex{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSAssert(models.count > destinationIndex, @"========越界======");
    TFProjectSectionModel *model = models[destinationIndex];
    NSMutableArray *arr = [NSMutableArray array];
    for (TFProjectRowModel *row in model.tasks) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:row.id forKey:@"id"];
        [dict setObject:row.name forKey:@"name"];
        [arr addObject:dict];
    }
    
    [self.projectTaskBL requestSortProjectColumnWithList:arr projectId:self.projectId];
}

-(void)moveView:(TFMoveView *)moveView didClickedItem:(TFProjectRowModel *)model{
    
    TFTaskColumnAddController *add = [[TFTaskColumnAddController alloc] init];
    add.projectId = self.projectId;
    add.projectRow = model;
    add.type = 1;
    add.refresh = ^(id parameter) {
        [self.moveView refreshData];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    };
    [self.navigationController pushViewController:add animated:YES];
}

-(void)moveView:(TFMoveView *)moveView didMinusBtn:(UIButton *)button models:(NSMutableArray *)models{
    
    TFProjectSectionModel *model = models[0];

    self.selectRow = model.tasks[button.tag];

    
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

- (void)setupNavigation{
    
    self.navigationItem.title = @"任务分组";
//    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(deleteClicked) text:@"删除" textColor:HexColor(0x3689e9)];
//    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(addClicked) text:@"新增" textColor:HexColor(0x3689e9)];
//    self.navigationItem.rightBarButtonItems = @[item2,item1];
}

- (void)deleteClicked{
    TFColumnDeleteController *dele = [[TFColumnDeleteController alloc] init];
    dele.projectId = self.projectId;
    dele.columns = self.columns;
    dele.refreshAction = ^{
        [self.projectTaskBL requestGetProjectColumnWithProjectId:self.projectId];
        
    };
    [self.navigationController pushViewController:dele animated:YES];
}

- (void)addClicked{
    TFTaskColumnAddController *add = [[TFTaskColumnAddController alloc] init];
    add.projectId = self.projectId;
    add.refresh = ^(id parameter) {
      
        [self.projectTaskBL requestGetProjectColumnWithProjectId:self.projectId];
    };
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectColumn) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 1; i++) {
            TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
           
            for (TFProjectRowModel *colu in resp.body) {
                colu.hidden = @"0";
            }
            
            model.tasks = resp.body;
            [arr addObject:model];
        }

        [self.moveView refreshMoveViewWithModels:arr withType:1];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    
    if (resp.cmdId == HQCMD_sortProjectColumn) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    
    
    if (resp.cmdId == HQCMD_deleteProjectColumn) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 1; i++) {
            TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
            NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
            
            for (TFProjectColumnModel *colu in self.columns) {
                
                if ([colu.hidden isEqualToString:@"1"]) {
                    continue;
                }
                if ([colu.id isEqualToNumber:self.selectRow.id]) {
                    colu.hidden = @"1";
                    continue;
                }
                TFProjectRowModel *task = [[TFProjectRowModel alloc] init];
                task.name = colu.name;
                task.hidden = @"0";
                task.id = colu.id;
                [tasks addObject:task];
                
            }
            
            model.tasks = tasks;
            [arr addObject:model];
        }
        
        [self.moveView refreshMoveViewWithModels:arr withType:1];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
