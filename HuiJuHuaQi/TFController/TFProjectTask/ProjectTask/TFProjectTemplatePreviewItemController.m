//
//  TFProjectTemplatePreviewItemController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectTemplatePreviewItemController.h"
#import "TFBoardView.h"

@interface TFProjectTemplatePreviewItemController ()
/** TFBoardView */
@property (nonatomic, strong) TFBoardView *boardView;

@end

@implementation TFProjectTemplatePreviewItemController

-(TFBoardView *)boardView{
    
    if (!_boardView) {
        _boardView = [[TFBoardView alloc] initWithFrame:CGRectMake(0, 17, SCREEN_WIDTH, 150)];
        [self.view insertSubview:_boardView atIndex:0];
    }
    return _boardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    // 初始化移动View
    self.boardView.isPreview = YES;
    self.view.layer.masksToBounds = YES;
    [self.boardView refreshMoveViewWithModels:self.projectColumnModel.subnodeArr withType:2];
//    if (self.projectColumnModel.subnodeArr.count) {
//        TFProjectSectionModel *model = self.projectColumnModel.subnodeArr[0];
//
//        TFProjectSectionModel *mo = [[TFProjectSectionModel alloc] init];
//        mo.id = model.id;
//        mo.name = model.name;
//        NSMutableArray<TFProjectSectionModel> *arr = [NSMutableArray<TFProjectSectionModel> arrayWithObject:model];
//        mo.subnodeArr = arr;
//        [self.boardView refreshMoveViewWithModels:[NSMutableArray arrayWithObject:mo] withType:2];
//
//    }
    
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
