//
//  TFCustomDetailController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomDetailController.h"
#import "TFCustomDetaiHeaderView.h"
#import "TFCustomDetailScrollView.h"
#import "TFAddCustomController.h"
#import "FDActionSheet.h"
#import "TFCustomChangeView.h"
#import "TFCustomTransferController.h"
#import "TFCustomShareController.h"
#import "TFCustomerCommentController.h"
#import "TFCustomerDynamicController.h"
#import "TFCustomBL.h"
#import "TFCustomDetailRefrenceModel.h"
#import "TFCustomAuthModel.h"
#import "TFReferenceListController.h"
#import "TFCustomFlowController.h"
#import "TFHighseaMoveController.h"
#import "TFHighseaAllocateController.h"
#import "TFHighseaModel.h"
#import "TFCustomEmailListController.h"
#import "TFRelevanceFieldModel.h"

@interface TFCustomDetailController ()<FDActionSheetDelegate,UIAlertViewDelegate,UITabBarDelegate,HQBLDelegate,TFCustomDetailScrollViewDelegate>
/** headerView */
@property (nonatomic, weak) TFCustomDetaiHeaderView *headerView;

/** customDetailScrollView */
@property (nonatomic, weak) TFCustomDetailScrollView *customDetailScrollView;

/** HQBLDelegate */
@property (nonatomic, strong) TFCustomBL *customBL;

/** 子控制器 */
@property (nonatomic, strong) TFAddCustomController *childVc;

/** auths */
@property (nonatomic, strong) NSMutableArray *auths;

/** changes */
@property (nonatomic, strong) NSMutableArray <TFCustomChangeModel>*changes;


/** refrenceModel */
@property (nonatomic, strong)  TFCustomDetailRefrenceModel *refrenceModel;

/** commentAndDynamicDict */
@property (nonatomic, strong) NSDictionary *commentAndDynamicDict;

/** bottomBtns */
@property (nonatomic, strong) NSArray *bottomBtns;

/** highseas */
@property (nonatomic, strong) NSMutableArray *highseas;

/** emails */
@property (nonatomic, strong) NSArray *emails;

/** detailDict */
@property (nonatomic, strong) NSDictionary *detailDict;


@end

@implementation TFCustomDetailController

-(NSMutableArray *)highseas{
    if (!_highseas) {
        _highseas = [NSMutableArray array];
    }
    return _highseas;
}

-(NSMutableArray *)auths{
    if (!_auths) {
        _auths = [NSMutableArray array];
    }
    return _auths;
}

-(NSMutableArray *)changes{
    if (!_changes) {
        _changes = [NSMutableArray<TFCustomChangeModel> array];
    }
    return _changes;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(leftClick) image:@"返回白色" highlightImage:@"返回白色"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:FONT(20)}];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:FONT(20)}];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFromNavBottomEdgeLayout];
    self.view.backgroundColor = WhiteColor;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self.customBL requsetCustomReferenceListWithBean:self.bean dataId:self.dataId];
    [self.customBL requestCustomModuleAuthWithBean:self.bean];
    [self.customBL requestCustomModuleChangeListWithBean:self.bean];
    [self.customBL requestHighseaListWithBean:self.bean];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentAddDynamic:) name:@"NotificationCommentAndDynamic" object:nil];
    
    [self setupNavi];
    [self setupDetailHeader];
    [self setupCustomDetailScrollView];
    [self setupChildVC];
//    [self setupBottomTabBar];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commentAddDynamic:(NSNotification *)note{
    
    if (!note.object) return;
    
    NSNumber *num = nil;
    if ([note.object isKindOfClass:[NSNumber class]]) {
        num = note.object;
    }
    if ([note.object isKindOfClass:[NSString class]]) {
        num = @([note.object integerValue]);
    }
    
    if ([self.dataId isEqualToNumber:num]) {
        
        self.commentAndDynamicDict = note.userInfo;
    }
    
    [self setupBottomTabBar];
}


/** 底部tabBar */
- (void)setupBottomTabBar{
    
    if (!self.refrenceModel)  return;
    if (!self.commentAndDynamicDict) return;
    
    NSMutableArray *strs = [NSMutableArray array];
    if ([[self.commentAndDynamicDict valueForKey:@"commentControl"] isEqualToString:@"1"]) {
        
        [strs addObject:@"评论"];
    }
    
    if (self.refrenceModel.isOpenProcess && ![self.refrenceModel.isOpenProcess isEqualToNumber:@0]) {
        
        [strs addObject:@"审批"];
    }
    
    if ([[self.commentAndDynamicDict valueForKey:@"dynamicControl"] isEqualToString:@"1"]) {
        
        [strs addObject:@"动态"];
    }
    
    if ([[self.commentAndDynamicDict valueForKey:@"emailControl"] isEqualToString:@"1"]) {
        
        [strs addObject:@"邮件"];
    }
    
    self.bottomBtns = strs;
    
    if (strs.count) {
        
        self.childVc.tableViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.customDetailScrollView.frame)-NaviHeight-BottomHeight;
    }else{
        
        self.childVc.tableViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.customDetailScrollView.frame)-NaviHeight;
    }
    
    
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-BottomHeight,SCREEN_WIDTH,TabBarHeight}];
    tabBar.delegate = self;
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0; i < strs.count; i ++) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:strs[i] image:[[UIImage imageNamed:[NSString stringWithFormat:@"%@customDetail",strs[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@customDetail",strs[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [items addObject:item];
        item.tag = 0x123 + i;
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = ExtraLightBlackTextColor;
        textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
        [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        [item setTitleTextAttributes:textAttrs forState:UIControlStateSelected];
    }
    [tabBar setItems:items];
    
    [self.view addSubview:tabBar];
    
}

#pragma mark - UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSInteger tag = item.tag - 0x123;
    NSString *str = self.bottomBtns[tag];
    
    if ([str isEqualToString:@"评论"]) {
        
        TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
        comment.bean = self.bean;
        comment.id = self.dataId;
        [self.navigationController pushViewController:comment animated:YES];
    }
    if ([str isEqualToString:@"动态"]) {
        
        TFCustomerDynamicController *dynamic = [[TFCustomerDynamicController alloc] init];
        dynamic.bean = self.bean;
        dynamic.id = self.dataId;
        [self.navigationController pushViewController:dynamic animated:YES];
    }
    if ([str isEqualToString:@"审批"]) {
        TFCustomFlowController *flow = [[TFCustomFlowController alloc] init];
        flow.bean = self.bean;
        flow.dataId = self.dataId;
        
        [self.navigationController pushViewController:flow animated:YES];
    }
    if ([str isEqualToString:@"邮件"]) {
        TFCustomEmailListController *email = [[TFCustomEmailListController alloc] init];
        email.emails = self.emails;
        [self.navigationController pushViewController:email animated:YES];
    }
    
}

/** 导航栏 */
- (void)setupNavi{
    self.navigationItem.title = @"详情";

    if (self.isSeasAdmin) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(highseaClick) image:@"菜单白色" highlightImage:@"菜单白色"];
        
    }else{
        
        if (self.auths.count) {
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClick) image:@"菜单白色" highlightImage:@"菜单白色"];
        }
    }
}

- (void)highseaClick{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([self.isSeasAdmin isEqualToString:@"1"]) {
        
        if (self.highseas.count) {
            [arr addObjectsFromArray:@[@"领取",@"编辑",@"分配",@"删除",@"移动"]];
        }else{
            
            [arr addObjectsFromArray:@[@"领取",@"编辑",@"分配",@"删除"]];
        }
        
    }else{
        
        [arr addObject:@"领取"];
    }
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" titles:arr];
    sheet.tag = 0x111;
    sheet.delegate = self;
    [sheet show];
    
}

- (void)rightClick{
    
    if (!self.auths.count)return;
    
    NSMutableArray *strs = [NSMutableArray array];
    
    for (TFCustomAuthModel *model in self.auths) {
        
        
        [strs addObject:model.func_name];
    }
    
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"设置" delegate:self cancelButtonTitle:@"取消" titles:strs];
    sheet.delegate = self;
    [sheet show];
}

#pragma mark - FDActionSheetDelegate
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    
    if (sheet.tag == 0x111) {// 公海池
        
        if ([self.isSeasAdmin isEqualToString:@"1"]) {
            
            // @"领取",@"编辑",@"分配",@"移动",@"删除"
            if (buttonIndex == 0) {
                
                // 领取
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.customBL requestHighseaTakeWithDataId:self.dataId bean:self.bean seasPoolId:self.seaPoolId];
                
            }else if (buttonIndex == 1){
                // 编辑
                TFAddCustomController *add = [[TFAddCustomController alloc] init];
                add.type = 2;
                add.taskKey = self.taskKey;
                add.tableViewHeight = SCREEN_HEIGHT - 64;
                add.bean = self.bean;
                add.dataId = self.dataId;
                add.isSeasPool = @"1";
                add.seaPoolId = self.seaPoolId;
                add.refreshAction = ^{
                    
                    if (self.childVc.refreshAction) {
                        self.childVc.refreshAction();
                    }
                    if (self.refreshAction) {
                        self.refreshAction();
                    }
                };
                [self.navigationController pushViewController:add animated:YES];
                
            }else if (buttonIndex == 2){
                // 分配
                TFHighseaAllocateController *allocate = [[TFHighseaAllocateController alloc] init];
                
                allocate.dataId = self.dataId;
                allocate.bean = self.bean;
                allocate.seaPoolId = self.seaPoolId;
                allocate.refreshAction = ^{
                    if (self.deleteAction) {
                        self.deleteAction();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                };
                
                [self.navigationController pushViewController:allocate animated:YES];
                
            }else if (buttonIndex == 3){
                
                // 删除
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不可恢复，确认要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 0x555;
                alertView.delegate = self;
                [alertView show];
                
            }else{
                
                // 移动
                TFHighseaMoveController *move = [[TFHighseaMoveController alloc] init];
                move.type = 0;
                move.dataId = self.dataId;
                move.bean = self.bean;
                move.seaPoolId = self.seaPoolId;
                move.dataSource = self.highseas;
                move.refreshAction = ^{
                    
                    if (self.deleteAction) {
                        
                        self.deleteAction();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                };
                
                [self.navigationController pushViewController:move animated:YES];
                
            }
            
        }else{
            
            // 领取
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestHighseaTakeWithDataId:self.dataId bean:self.bean seasPoolId:self.seaPoolId];
            
        }
        
        return;
    }

    
    // 权限
    TFCustomAuthModel *model = self.auths[buttonIndex];
    
    switch ([model.auth_code integerValue]) {
        case 1:// 新增
        {
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 0;
            add.tableViewHeight = SCREEN_HEIGHT - 64;
            add.bean = self.bean;
            [self.navigationController pushViewController:add animated:YES];
            
        }
            break;
        case 2: // 导出
        {
            [MBProgressHUD showError:@"移动端无法导出" toView:self.view];
            
        }
            break;
        case 3:// 编辑
        {
            
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 2;
            add.tableViewHeight = SCREEN_HEIGHT - 64;
            add.bean = self.bean;
            add.dataId = self.dataId;
            add.refreshAction = ^{
                
                if (self.childVc.refreshAction) {
                    self.childVc.refreshAction();
                }
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        case 4:// 共享
        {
            
            TFCustomShareController *share = [[TFCustomShareController alloc] init];
            share.type = 0;
            share.dataId = self.dataId;
            share.bean = self.bean;
            [self.navigationController pushViewController:share animated:YES];
        }
            break;
        case 5:// 删除
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不可恢复，确认要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0x555;
            alertView.delegate = self;
            [alertView show];
            
        }
            break;
        case 6:// 转换
        {
            if (self.changes.count == 0) {
                [MBProgressHUD showError:@"无转换模块" toView:self.view];
                return;
            }
            
            [TFCustomChangeView showCustomChangeView:@"可转换目标模块" items:self.changes onRightTouched:^(id parameter){
                
                NSMutableArray *ids = [NSMutableArray array];
                for (TFCustomChangeModel *model in parameter) {
                    
                    [ids addObject:model.id];
                }
                
                [self.customBL requestCustomModuleChangeWithBean:self.bean dataId:self.dataId ids:ids];
                
            }];
            

        }
            break;
        case 7:// 转移负责人
        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定将当前数据的负责人转移给其他负责人？" message:@"转移成功后，该操作将无法恢复。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alertView.tag = 0x777;
//            alertView.delegate = self;
//            [alertView show];
            
            TFCustomTransferController *transfer = [[TFCustomTransferController alloc] init];
            transfer.bean = self.bean;
            transfer.dataId = self.dataId;
            transfer.refreshAction = ^{
                
                if (self.childVc.refreshAction) {
                    self.childVc.refreshAction();
                }
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:transfer animated:YES];
        }
            break;
        case 8:// 打印
        {
            [MBProgressHUD showError:@"移动端无法打印" toView:self.view];
            
        }
            break;
        case 9:// 复制
        {
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 3;
            add.tableViewHeight = SCREEN_HEIGHT - 64;
            add.bean = self.bean;
            add.dataId = self.dataId;
            add.refreshAction = ^{
                
                if (self.refreshAction) {
                    self.refreshAction();
                }
            };
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        case 10:// 退回
        {
            TFHighseaMoveController *move = [[TFHighseaMoveController alloc] init];
            move.type = 1;
            move.dataId = self.dataId;
            move.bean = self.bean;
            move.dataSource = self.highseas;
            move.refreshAction = ^{
              
                if (self.deleteAction) {
                    self.deleteAction();
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:move animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 0x555) {// 删除
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requsetCustomDeleteWithBean:self.bean dataId:self.dataId subformFields:nil];
        }
    }
    
//    if (alertView.tag == 0x777) {// 转换
//
//        if (buttonIndex == 1) {
//            TFCustomTransferController *transfer = [[TFCustomTransferController alloc] init];
//            transfer.bean = self.bean;
//            transfer.dataId = self.dataId;
//            transfer.refreshAction = ^{
//
//                if (self.childVc.refreshAction) {
//                    self.childVc.refreshAction();
//                }
//                if (self.refreshAction) {
//                    self.refreshAction();
//                }
//            };
//            [self.navigationController pushViewController:transfer animated:YES];
//        }
//    }
}


/** 头部控件 */
- (void)setupDetailHeader{
    TFCustomDetaiHeaderView *headerView = [TFCustomDetaiHeaderView customDetaiHeaderView];
    self.headerView = headerView;
    headerView.titleLabel.text = @"";
    [self.view addSubview:headerView];
    
}

/** 模块滚动控件 */
- (void)setupCustomDetailScrollView{
    TFCustomDetailScrollView *customDetailScrollView = [[TFCustomDetailScrollView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(self.headerView.frame),SCREEN_WIDTH,0}];
    [customDetailScrollView refreshScrollViewWithItems:@[] type:0];
    [self.view addSubview:customDetailScrollView];
    self.customDetailScrollView = customDetailScrollView;
    customDetailScrollView.delegate1 = self;
}

#pragma mark - TFCustomDetailScrollViewDelegate
-(void)customDetailScrollViewDidClickedWithModel:(TFRelevanceTradeModel *)model{
    
    TFReferenceListController *list = [[TFReferenceListController alloc] init];
    list.dataId = self.dataId;
    list.bean = model.moduleName;
    list.naviTitle = model.moduleLabel;
    list.fieldName = model.fieldName;
    list.lastDetailDict = self.detailDict;
    [self.navigationController pushViewController:list animated:YES];
    
}

/** 子控制器 */
- (void)setupChildVC{
    
    TFAddCustomController *add = [[TFAddCustomController alloc] init];
    add.vcTag = [self.dataId integerValue];
    add.fatherRefresh = ^{
      
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };
    add.type = 1;
    add.translucent = YES;
    add.tableViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.customDetailScrollView.frame)-NaviHeight;
    add.bean = self.bean;
    add.dataId = self.dataId;
    add.seaPoolId = self.seaPoolId;
    if (self.seaPoolId) {
        add.isSeasPool = @"1";
    }
    add.emailBlock = ^(NSArray *parameter) {
        
        self.emails = parameter;
    };
    add.detailBlock = ^(NSDictionary *parameter) {
        self.detailDict = parameter;
    };
    
    [self addChildViewController:add];
    add.view.top = CGRectGetMaxY(self.customDetailScrollView.frame);
    [self.view addSubview:add.view];
    self.childVc = add;
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customRefernceModule) {// 模块
        
        TFCustomDetailRefrenceModel *model = resp.body;
        self.refrenceModel = model;
        NSMutableArray *arr = [NSMutableArray array];
        
        for (TFRelevanceTradeModel *ddd in model.refModules) {
            
            if ([ddd.show isEqualToString:@"1"]) {
                [arr addObject:ddd];
            }
        }
        
        if (arr.count) {
            
            self.customDetailScrollView.height = 55;
            self.childVc.view.top = CGRectGetMaxY(self.customDetailScrollView.frame);
        
            self.childVc.tableViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.customDetailScrollView.frame)-NaviHeight-TabBarHeight;
        }else{
            self.customDetailScrollView.height = 0;
            self.childVc.view.top = CGRectGetMaxY(self.customDetailScrollView.frame);
            self.childVc.tableViewHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.customDetailScrollView.frame)-NaviHeight-BottomHeight;
        }
        
        [self.customDetailScrollView refreshScrollViewWithItems:arr type:0];
        self.headerView.titleLabel.text = [HQHelper stringWithFieldNameModel:model.operationInfo];
        
        [self setupBottomTabBar];
    }
    
    if (resp.cmdId == HQCMD_customModuleAuth) {// 权限
    
        NSMutableArray *arr = [NSMutableArray array];
        
        for (TFCustomAuthModel *model in resp.body) {
            
            if ([model.auth_code isEqualToNumber:@1] || [model.auth_code isEqualToNumber:@2] || [model.auth_code isEqualToNumber:@8]) {
                continue;
            }
            
            [arr addObject:model];
        }
        
        
        BOOL have = NO;
        for (TFCustomAuthModel *model in resp.body) {
            
            if ([model.auth_code isEqualToNumber:@1]) {
                have = YES;
                break;
            }
        }
        
        [arr addObjectsFromArray:self.auths];
        
        if (have) {
            TFCustomAuthModel *model = [[TFCustomAuthModel alloc] init];
            model.auth_code = @9;
            model.func_name = @"复制";
            [arr insertObject:model atIndex:0];
        }

        self.auths = arr;
        
        
        [self setupNavi];
    }
    
    if (resp.cmdId == HQCMD_customDelete) {// 删除
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.deleteAction) {
            self.deleteAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_customModuleChangeList) {
        
        self.changes = resp.body;
        
    }
    
    if (resp.cmdId == HQCMD_customModuleChange) {
        
        [MBProgressHUD showImageSuccess:@"转换成功" toView:self.view];
    }
    
    if (resp.cmdId == HQCMD_highseaTake) {
        
        if (self.deleteAction) {
            self.deleteAction();
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"领取成功" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_highseaList) {
        
        if (self.seaPoolId) {
            
            NSArray *arr = resp.body;
            
            for (TFHighseaModel *model in arr) {
                
                if ([model.id isEqualToNumber:self.seaPoolId]) {
                    continue;
                }
                
                [self.highseas addObject:model];
            }
        }else{
            [self.highseas addObjectsFromArray:resp.body];
        }
        
        if (self.highseas.count) {
            
            TFCustomAuthModel *model = [[TFCustomAuthModel alloc] init];
            model.auth_code = @10;
            model.func_name = @"退回公海池";
            [self.auths insertObject:model atIndex:self.auths.count];
            
            [self setupNavi];
        }
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
