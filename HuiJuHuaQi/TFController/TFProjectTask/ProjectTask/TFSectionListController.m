//
//  TFSectionListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSectionListController.h"
#import "TFMoveView.h"
#import "TFProjectSectionModel.h"
#import "TFTaskColumnAddController.h"
#import "TFSectionDeleteController.h"
#import "TFProjectTaskBL.h"

@interface TFSectionListController ()<TFMoveViewDelegate,HQBLDelegate>
/** moveView */
@property (nonatomic, weak) TFMoveView *moveView;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@end

@implementation TFSectionListController



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
        
        for (TFProjectSectionModel *colu in self.projectColumnModel.subnodeArr) {
            
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
    
    [self.projectTaskBL requestSortProjectSectionWithList:arr columnId:self.projectColumnModel.id projectId:self.projectId activeNodeId:self.projectColumnModel.id originalNodeId:(NSNumber *)self.projectColumnModel.id];
    
}

-(void)moveView:(TFMoveView *)moveView didClickedItem:(TFProjectRowModel *)model{
    
    TFTaskColumnAddController *add = [[TFTaskColumnAddController alloc] init];
    add.projectRow = model;
    add.index = 1;
    add.type = 1;
    add.refresh = ^(id parameter) {
        [self.moveView refreshData];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    };
    [self.navigationController pushViewController:add animated:YES];
}


- (void)setupNavigation{
    
    self.navigationItem.title = @"任务分组";
    UINavigationItem *item1 = [self itemWithTarget:self action:@selector(deleteClicked) text:@"删除" textColor:HexColor(0x3689e9)];
    UINavigationItem *item2 = [self itemWithTarget:self action:@selector(addClicked) text:@"新增" textColor:HexColor(0x3689e9)];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
}

- (void)deleteClicked{
    TFSectionDeleteController *dele = [[TFSectionDeleteController alloc] init];
    dele.projectId = self.projectId;
    dele.projectColumnModel = self.projectColumnModel;
    dele.refreshAction = ^{
        
        [self.projectTaskBL requestGetProjectSectionWithColumnId:self.projectColumnModel.id];
    };
    [self.navigationController pushViewController:dele animated:YES];
}

- (void)addClicked{
    TFTaskColumnAddController *add = [[TFTaskColumnAddController alloc] init];
    add.index = 1;
    add.projectId = self.projectId;
    add.sectionId = self.projectColumnModel.id;
    add.refresh = ^(id parameter) {
        [self.projectTaskBL requestGetProjectSectionWithColumnId:self.projectColumnModel.id];
    };
    [self.navigationController pushViewController:add animated:YES];
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectSection) {
        
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
    
    if (resp.cmdId == HQCMD_sortProjectSection) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
