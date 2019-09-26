//
//  TFWorkFlowPreviewController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkFlowPreviewController.h"
#import "TFBoardView.h"
#import "TFProjectSectionModel.h"
#import "TFProjectTaskBL.h"

@interface TFWorkFlowPreviewController ()<HQBLDelegate>

/** TFBoardView */
@property (nonatomic, strong) TFBoardView *boardView;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** nodes */
@property (nonatomic, strong) NSArray *nodes;

@end

@implementation TFWorkFlowPreviewController

-(TFBoardView *)boardView{
    
    if (!_boardView) {
        _boardView = [[TFBoardView alloc] initWithFrame:CGRectMake(0, 17, SCREEN_WIDTH, 150)];
//        _boardView.delegate = self;
        _boardView.isPreview = YES;
        [self.view insertSubview:_boardView atIndex:0];
    }
    return _boardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requsetProjectWorkflowPreviewWithWorkflowId:self.workflowId];
    
    self.navigationItem.title = @"工作流预览";
    self.view.backgroundColor = WhiteColor;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.sureAction) {
        [self.navigationController popViewControllerAnimated:NO];
        self.sureAction(self.nodes);
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    NSDictionary *dict = resp.body;
    NSArray *nodes = [dict valueForKey:@"nodes"];
    self.nodes = nodes;
    // 初始化
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < nodes.count; i++) {
        NSDictionary *dd = nodes[i];
        
        TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
        model.name = [dd valueForKey:@"text"];
        
        [arr addObject:model];
    }
    
    // 初始化移动View
    [self.boardView refreshMoveViewWithModels:arr withType:2];
    
    NSDictionary *workflow = [dict valueForKey:@"workflow"];
    self.navigationItem.title = [workflow valueForKey:@"name"];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}



- (void)setupViews{
    
    // 初始化假数据
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            TFProjectSectionModel *model = [[TFProjectSectionModel alloc] init];
            model.name = [NSString stringWithFormat:@"研发%ld",i];
    
            [arr addObject:model];
        }
    
     // 初始化移动View
        [self.boardView refreshMoveViewWithModels:arr withType:0];
    
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
