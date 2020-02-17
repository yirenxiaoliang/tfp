//
//  TFModelEnterController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFModelEnterController.h"
#import "TFCustomBL.h"
#import "TFModelsCell.h"
#import "TFBurWindowView.h"
#import "TFCustomListController.h"
#import "TFProjectAndTaskMainController.h"
#import "TFApprovalMainController.h"
#import "TFEmailsMainController.h"
#import "TFFileMenuController.h"
#import "TFNoteMainController.h"
#import "HQTFNoContentView.h"
#import "TFAddCustomController.h"
#import "TFSelectCustomListController.h"
#import "TFSelectMemoListController.h"
#import "TFSelectTaskListController.h"
#import "TFAttendanceTabbarController.h"
#import "TFCreateNoteController.h"
#import "TFAddTaskController.h"
#import "TFNoteDataListModel.h"
#import "TFApprovalListItemModel.h"
#import "TFApprovalListController.h"
#import "TFCustomListItemModel.h"
#import "TFCachePlistManager.h"
#import "TFQuoteTaskItemModel.h"
#import "TFSelectEmailController.h"
#import "TFKnowledgeListController.h"
#import "TFSelectTaskCategoryController.h"
#import "TFLoginBL.h"
#import "TFEndlessView.h"
#import "TFRefresh.h"
#import "TFSalaryController.h"

#define ADHEIGHT 160

@interface TFModelEnterController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFModelsCellDelegate,TFBurWindowViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) TFLoginBL *loginBL;
/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;
/** applications */
@property (nonatomic, strong) NSMutableArray *applications;
/** oftens */
@property (nonatomic, strong) TFApplicationModel *oftenApplication;
/** systems */
@property (nonatomic, strong) TFApplicationModel *systemApplication;
/** selectApplication */
@property (nonatomic, strong) TFApplicationModel *selectApplication;
/** modelsCell */
@property (nonatomic, strong) TFModelsCell *modelsCell;
/** modelView */
@property (nonatomic, strong) TFModelView *modelView;

/** banners */
@property (nonatomic, strong) NSArray *banners;
/** used */
@property (nonatomic, assign) BOOL used;

/** TFBurWindowView */
@property (nonatomic, strong) TFBurWindowView *blurWindowView;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
/** 刷新次数，因为多个接口异步，每接口回来都刷新，在滚动时刷新出现回退感 */
@property (nonatomic, assign) NSInteger refreshCount;
/** endlessScrollView */
@property (nonatomic, strong) TFEndlessView *endlessScrollView;

@end

@implementation TFModelEnterController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据~"];
    }
    return _noContentView;
}
-(NSMutableArray *)applications{
    if (!_applications) {
        _applications = [NSMutableArray array];
    }
    return _applications;
}


-(TFApplicationModel *)systemApplication{
    if (!_systemApplication) {
        _systemApplication = [[TFApplicationModel alloc] init];
        NSArray *sys = nil;
        NSArray *beans = nil;
        NSArray *icon = nil;
//        sys = @[@"审批",@"协作",@"备忘录",@"文件库",@"邮件",@"考勤"];
//        icon = @[@"审批",@"协作",@"备忘录",@"文件库",@"邮件",@"考勤"];
//        beans = @[@"approval",@"project",@"memo",@"library",@"email",@"diligent"];
        sys = @[@"审批",@"备忘录"];
        icon = @[@"审批",@"备忘录"];
        beans = @[@"approval",@"memo"];
        if (self.type == 3 || self.type == 5) {
            sys = @[@"协作",@"备忘录",@"审批"];
            beans = @[@"project",@"memo",@"approval"];
            icon = @[@"协作",@"备忘录",@"审批"];
        }
        else if (self.type == 7){
            sys = @[@"审批"];
            icon = @[@"审批"];
            beans = @[@"approval"];
        }
        NSMutableArray<Optional,TFModuleModel> *mus = [NSMutableArray<Optional,TFModuleModel> array];
        for (NSInteger i = 0; i < sys.count; i ++) {

            TFModuleModel *mu = [[TFModuleModel alloc] init];
            [mus addObject:mu];
            mu.chinese_name = sys[i];
            mu.english_name = beans[i];
            mu.icon = icon[i];
            mu.icon_type = 0;
            mu.icon_color = @"#FFFFFF";
        }
        _systemApplication.modules = mus;
    }
    return _systemApplication;
}

-(TFEndlessView *)endlessScrollView{
    if (!_endlessScrollView) {
        _endlessScrollView = [[TFEndlessView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,ADHEIGHT}];
        _endlessScrollView.isBorder = YES;
    }
    return _endlessScrollView;
}

- (void)setupBurWindowView{
    TFBurWindowView *view = [[TFBurWindowView alloc] initWithFrame:self.view.bounds];
    [KeyWindow addSubview:view];
    view.hidden = YES;
    view.frame = KeyWindow.bounds;
    self.blurWindowView = view;
    view.delegate = self;
}

/** 用于子控制器时的刷新数据 */
-(void)refreshModuleData{
    
    if (self.type == 2) {
        
        [self.customBL requestCustomApplicationListWithApprovalFlag:@"1"];
    }else{
        
        [self.customBL requestAllApplication];
        
        if (self.openOften) {
            [self.customBL requestQuickAdd];
        }
    }
    
    if (self.type == 0 || self.type == 1 || self.type == 6 || self.type == 7) {
        
        [self.customBL requestGetSystemStableModule];
    }
    
    if (self.hasBanner) {
        [self.loginBL requestGetBanner];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.hasBanner) {
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
        
        self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:@"应用中心" color:BlackTextColor imageName:nil withTarget:nil action:nil];
        self.navigationItem.title = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBurWindowView];
    
    [self setupTableView];
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    [self refreshModuleData];// 请求数据
    
    if (self.type == 0) {
        [self handleApplicationData];
        if (self.openOften) {
            [self handleOftenData];
        }
    }
    if (self.type == 0) {
        [self handleSystemData];
    }
    
    self.navigationItem.title = @"选择模块";
    
    
    if (self.type == 4) {
        [self rightClicked];
    }
    
    // 登录或切换公司socket连接通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanySocketConnect) name:ChangeCompanySocketConnect object:nil];
}

-(void)changeCompanySocketConnect{
    
    [self refreshModuleData];
}


/** 处理常用模块数据 */
-(void)handleOftenData{
    NSArray *datas = [TFCachePlistManager getOftenModuleList];
    NSMutableArray<Optional,TFModuleModel> *arr = [NSMutableArray <Optional,TFModuleModel>array];
    for (NSDictionary *dict in datas) {
        TFModuleModel *mo = [[TFModuleModel alloc] initWithDictionary:dict error:nil];
        if (mo) {
            [arr addObject:mo];
        }
    }
    self.oftenApplication = [[TFApplicationModel alloc] init];
    self.oftenApplication.modules = arr;
    [self.tableView reloadData];
}

/** 处理系统模块数据 */
-(void)handleSystemData{
    NSArray *datas = [TFCachePlistManager getSystemModuleList];
    self.systemApplication = nil;
    [self.systemApplication.modules removeAllObjects];
    for (NSDictionary *dict in datas) {
        TFModuleModel *mo = [[TFModuleModel alloc] initWithDictionary:dict error:nil];
        if (mo) {
            [self.systemApplication.modules addObject:mo];
        }
    }
    [self.tableView reloadData];
}


/** 处理自定义应用 */
-(void)handleApplicationData{
    
    NSArray *datas = [TFCachePlistManager getApplicationModuleList];
    
    [self.applications removeAllObjects];
    for (NSDictionary *di in datas) {
        TFApplicationModel  *model = [[TFApplicationModel alloc] initWithDictionary:di error:nil];
        if (model) {
            [self.applications addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (void)rightClicked{
    
    if (!self.used) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) text:@"完成" textColor:GreenColor];
        self.used = YES;
        [self.tableView reloadData];
        
    }else{
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) text:@"管理"];
        self.used = NO;
        [self.tableView reloadData];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableArray *arr = [NSMutableArray array];
        for (TFModuleModel *model in self.oftenApplication.modules) {
            NSDictionary *di = [model toDictionary];
            if (di) {
                [arr addObject:di];
            }
        }
        [self.customBL requestSaveOftenModules:arr];
    }
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    
    if (resp.cmdId == HQCMD_getBanner) {
        
        [self.tableView.mj_header endRefreshing];
        self.banners = resp.body;
        if (self.banners.count) {
            self.tableView.tableHeaderView = self.endlessScrollView;
            [self.endlessScrollView refreshEndlessViewWithImages:self.banners];
        }else{
            self.tableView.tableHeaderView = nil;
            //            [self.endlessScrollView refreshEndlessViewWithImages:self.banners];
        }
    }
    
    if (resp.cmdId == HQCMD_customApplicationList) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFApplicationModel *model in resp.body) {
            if (model.modules.count != 0) {
                [arr addObject:model];
            }
        }
        [self.applications addObjectsFromArray:arr];
        
        if (self.applications.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
        
    }
    if (resp.cmdId == HQCMD_quickAdd) {
        
        self.oftenApplication = [[TFApplicationModel alloc] init];
        self.oftenApplication.modules = resp.body;
        
        if (self.type == 0) {
            self.refreshCount ++;
            if (self.refreshCount % 3 == 0) {
                [self.tableView reloadData];// 333333
            }
        }else{
            [self.tableView reloadData];
        }
        NSMutableArray *arr = [NSMutableArray array];
        for (TFModuleModel *mo in resp.body) {
            if ([mo toJSONString]) {
                [arr addObject:[mo toJSONString]];
            }
        }
        [TFCachePlistManager saveOftenModuleListWithDatas:arr];
        
    }
    if (resp.cmdId == HQCMD_allApplications) {
        
        NSDictionary *dict = resp.body[kData];
        
        NSArray *myApplication = [dict valueForKey:@"myApplication"];
        [self.applications removeAllObjects];
        for (NSDictionary *di in myApplication) {
            TFApplicationModel  *model = [[TFApplicationModel alloc] initWithDictionary:di error:nil];
            if (model) {
                [self.applications addObject:model];
            }
        }
        if (self.type == 0) {
            self.refreshCount ++;
            if (self.refreshCount % 3 == 0) {
                [self.tableView reloadData];// 333333
            }
        }else{
            [self.tableView reloadData];
        }
        
        NSMutableArray *models = [NSMutableArray array];
        for (TFApplicationModel *mo in self.applications) {
            if ([mo toJSONString]) {
                [models addObject:[mo toJSONString]];
            }
        }
        [TFCachePlistManager saveApplicationModuleListWithDatas:models];
    }
    
    if (resp.cmdId == HQCMD_getSystemStableModule) {
        
        NSArray *arr = resp.body;
        // 处理系统模块
        self.systemApplication = nil;
        for (NSInteger i = 0; i < arr.count; i ++) {
            NSDictionary *dict = arr[i];
            if (repositoryLibrariesHidden) {
                if ([[dict valueForKey:@"bean"] isEqualToString:@"repository_libraries"]) {
                    continue;
                }
            }
            if ([[[dict valueForKey:@"onoff_status"] description] isEqualToString:@"1"]) {

                if (!([[dict valueForKey:@"bean"] isEqualToString:@"approval"] || [[dict valueForKey:@"bean"] isEqualToString:@"workbench"] || [[dict valueForKey:@"bean"] isEqualToString:@"memo"])) {
                    
                    if (self.type == 6 || self.type == 7) {// 知识库引用的时候不需要文件库,知识库,考勤
                        if ([[dict valueForKey:@"bean"] isEqualToString:@"library"] ||
                            [[dict valueForKey:@"bean"] isEqualToString:@"repository_libraries"] ||
                            [[dict valueForKey:@"bean"] isEqualToString:@"attendance"] ||
                            [[dict valueForKey:@"bean"] isEqualToString:@"salary"]) {
                            continue;
                        }
                    }
                    if (self.type == 7) {// 去掉邮件
                        if ([[dict valueForKey:@"bean"] isEqualToString:@"email"]) {
                            continue;
                        }
                    }
                    
                    TFModuleModel *mu = [[TFModuleModel alloc] init];
                    [self.systemApplication.modules addObject:mu];
                    mu.chinese_name = [dict valueForKey:@"name"];
                    mu.english_name = [dict valueForKey:@"bean"];
                    mu.icon = [dict valueForKey:@"name"];
                    mu.icon_type = 0;
                    mu.icon_color = @"#FFFFFF";
                }
                // 将备忘录引用添加备忘录
                if ([[dict valueForKey:@"bean"] isEqualToString:@"memo"] && self.type == 7) {
                    
                    TFModuleModel *mu = [[TFModuleModel alloc] init];
                    [self.systemApplication.modules addObject:mu];
                    mu.chinese_name = [dict valueForKey:@"name"];
                    mu.english_name = [dict valueForKey:@"bean"];
                    mu.icon = [dict valueForKey:@"name"];
                    mu.icon_type = 0;
                    mu.icon_color = @"#FFFFFF";
                }
            }
        }
        
        if (self.type == 0 || self.type == 1) {
            
            
            NSMutableArray *models = [NSMutableArray array];
            for (TFModuleModel *mo in self.systemApplication.modules) {
                if ([mo toJSONString]) {
                    [models addObject:[mo toJSONString]];
                }
            }
            [TFCachePlistManager saveSystemModuleListWithDatas:models];
        }
        
        if (self.type == 0) {
            self.refreshCount ++;
            if (self.refreshCount % 3 == 0) {
                [self.tableView reloadData];// 333333
            }
        }else{
            [self.tableView reloadData];
        }
        
    }
    
    if (resp.cmdId == HQCMD_allModules) {
        
        NSArray *arr = resp.body[kData];
        
        NSMutableArray <Optional,TFModuleModel>*oftens = [NSMutableArray<Optional,TFModuleModel> array];
        for (NSDictionary *di in arr) {
            TFModuleModel  *model = [[TFModuleModel alloc] initWithDictionary:di error:nil];
            if (model) {
                [oftens addObject:model];
            }
        }
        self.selectApplication.modules = oftens;
        
        self.blurWindowView.hidden = NO;
        [KeyWindow addSubview:self.blurWindowView];
        CGRect rect = [self.blurWindowView convertRect:self.modelView.frame fromView:self.modelsCell];
        
        [self.blurWindowView refreshItemWithApplication:self.selectApplication rect:rect type:self.used?1:0 oftenApplication:self.oftenApplication];
    }
    
    
    if (resp.cmdId == HQCMD_saveOftenModule) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveOftenModule" object:nil];
        if (self.type == 4) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
    
    if (resp.cmdId == HQCMD_saveOftenModule) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.scrollEnabled = !self.openOften;
    
    
    if (self.openOften) {
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.tableView.scrollEnabled = NO;
    }
    if (self.hasBanner) {
        self.tableView.scrollEnabled = YES;
        
        tableView.mj_header = [TFRefresh headerNormalRefreshWithBlock:^{
            
            [self refreshModuleData];// 刷新数据
            
        }];
        if (self.openOften) {
            [self.tableView removeObserver:self forKeyPath:@"contentSize"];
        }
    }
}
/** 观察者 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    CGSize size = [[change valueForKey:@"new"] CGSizeValue];
    CGSize size1 = [[change valueForKey:@"old"] CGSizeValue];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:CustomDetailHeightNotification object:@(size.height)];
    if (self.heightBlock && size.height != size1.height) {
        self.heightBlock(@(size.height));
    }
}

/** 移除观察者 */
-(void)dealloc{
    if (self.openOften) {
        [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type == 2) {
        return self.applications.count;
    }else{
        
        return 3;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type != 2) {
        
        if (indexPath.section == 0) {
            
            TFModelsCell *cell = [TFModelsCell modelsCellWithTableView:tableView];
            [cell refreshModelsCellWithOftenApplication:self.oftenApplication];
            cell.nameLabel.text = @"常用模块";
            cell.delegate = self;
            return cell;
            
        }else if (indexPath.section == 1){
            
            TFModelsCell *cell = [TFModelsCell modelsCellWithTableView:tableView];
            [cell refreshModelsCellWithApplication:self.systemApplication type:self.used?1:0 oftenApplication:nil];
            cell.nameLabel.text = @"系统模块";
            cell.delegate = self;
            return cell;
            
        }else{
            
            TFModelsCell *cell = [TFModelsCell modelsCellWithTableView:tableView];
            [cell refreshModelsCellWithApplications:self.applications type:0];
            cell.nameLabel.text = @"公司应用";
            cell.delegate = self;
            return cell;
        }
    }else{
        
        TFApplicationModel *model = self.applications[indexPath.section];
        TFModelsCell *cell = [TFModelsCell modelsCellWithTableView:tableView];
        [cell refreshModelsCellWithApplication:model type:0 oftenApplication:nil];
        cell.nameLabel.text = model.chinese_name?:model.name;
        cell.delegate = self;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type != 2) {
        
        if (indexPath.section == 0) {
            // 不需常用
            if (self.openOften) {
                return [TFModelsCell modelsCellWithApplication:self.oftenApplication showTitle:NO];
            }else{
                return 0;
            }
        }else if (indexPath.section == 1){
            
            return [TFModelsCell modelsCellWithApplication:self.systemApplication showTitle:YES];
        }else{
            
            return [TFModelsCell modelsCellWithApplications:self.applications];
        }
    }else{
        
        TFApplicationModel *model = self.applications[indexPath.section];
        return [TFModelsCell modelsCellWithApplication:model showTitle:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.openOften) {
        if (section == 0) {
            if (self.oftenApplication.modules.count) {
                return 30;
            }
        }
        if (section == 1 ) {
            return 30;
        }
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.openOften) {
        if (section == 0) {
            if (self.oftenApplication.modules.count) {
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = BackGroudColor;
                UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,200,30}];
                [view addSubview:label];
                label.text = @"常用应用";
                label.font = FONT(12);
                label.textColor = ExtraLightBlackTextColor;
                return view;
            }
        }
        if (section == 1) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = BackGroudColor;
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:IMG(@"主页-工作台-更多模块")];
//            imageView.contentMode = UIViewContentModeCenter;
//            imageView.frame = CGRectMake(12, 7, 30, 30);
//            [view addSubview:imageView];
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,200,30}];
            [view addSubview:label];
            label.text = @"全部应用";
            label.font = FONT(12);
            label.textColor = ExtraLightBlackTextColor;
//            UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,44-0.5,SCREEN_WIDTH,0.5}];
//            [view addSubview:line];
//            line.backgroundColor = CellSeparatorColor;
            return view;
        }
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - TFModelsCellDelegate
-(void)modelsCell:(TFModelsCell *)modelsCell didClickedAddModule:(TFModuleModel *)module{
    
    BOOL have = NO;
    for (TFModuleModel *mo in self.oftenApplication.modules) {
        if ([module.english_name isEqualToString:mo.english_name]) {
            [self.oftenApplication.modules removeObject:mo];
            have = YES;
            break;
        }
    }
    
    if (self.oftenApplication.modules.count >= 10) {
        [MBProgressHUD showError:@"最多设置10个常用模块" toView:KeyWindow];
        return;
    }
    if (!have) {
        [self.oftenApplication.modules insertObject:module atIndex:0];
    }
    [self.tableView reloadData];
}

-(void)modelsCell:(TFModelsCell *)modelsCell didClickedMinusModule:(TFModuleModel *)module{
    
    [self.oftenApplication.modules removeObject:module];
    [self.tableView reloadData];
}

-(void)modelsCell:(TFModelsCell *)modelsCell didClickedModelView:(TFModelView *)modelView application:(TFApplicationModel *)application module:(TFModuleModel *)module{
    
    if (application) {
        
        if (application.modules) {
            
            self.blurWindowView.hidden = NO;
            [KeyWindow addSubview:self.blurWindowView];
            CGRect rect = [self.blurWindowView convertRect:modelView.frame fromView:modelsCell];
            
            [self.blurWindowView refreshItemWithApplication:application rect:rect type:self.used?1:0 oftenApplication:self.oftenApplication];
            
        }else{
            
            self.selectApplication = application;
            self.modelView = modelView;
            self.modelsCell = modelsCell;
            [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
            [self.customBL requestModuleWithApplicationId:application.id];
        }
        
    }
    
    if (module && !self.used) {
        
        
        [self jumpWithModule:module];
    }
}

/** 跳转 */
- (void)jumpWithModule:(TFModuleModel *)module{
    
    if ([module.english_name isEqualToString:@"project"]) {
    
        if (self.type == 3 || self.type == 6 || self.type == 7) {
            
            TFSelectTaskCategoryController *task = [[TFSelectTaskCategoryController alloc] init];
//            TFSelectTaskListController *task = [[TFSelectTaskListController alloc] init];
            task.projectId = self.projectId;
            task.parameterAction = ^(NSArray *parameter) {
                
                
                NSString *str = @"";
                for (TFQuoteTaskItemModel *model in parameter) {
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.id]];
                    
                }
                
                if (str.length) {
                    str = [str substringToIndex:str.length-1];
                }
                
                if (self.parameterAction) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    TFQuoteTaskItemModel *first = parameter.firstObject;
                    
//                    if (first.project_id && ![first.project_id isEqualToNumber:@0]) {
                    if ([first.bean_name containsString:@"project_custom_"]) {// 项目任务
                        [dict setObject:@2 forKey:@"beanType"];
                        [dict setObject:[first.bean_name stringByReplacingOccurrencesOfString:@"project_custom_" withString:@""] forKey:@"projectId"];
                    }else{
                        [dict setObject:@5 forKey:@"beanType"];
                    }
                    if ([self.projectId isEqualToNumber:@0] || !self.projectId) {
                        [dict setObject: [NSString stringWithFormat:@"project_custom"] forKey:@"bean"];
                    }else{
                        [dict setObject:first.bean_name forKey:@"bean"];
                    }
                    [dict setObject:str forKey:@"data"];
                    [dict setObject:parameter forKey:@"list"];
                    self.parameterAction(dict);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [self.navigationController pushViewController:task animated:YES];
            
        }
        else if (self.type == 5) {// 新建
            
            TFAddTaskController *add = [[TFAddTaskController alloc] init];
            add.bean = [NSString stringWithFormat:@"project_custom_%@",[self.projectId description]];
            add.type = 8;
            add.tableViewHeight = SCREEN_HEIGHT-64;
            add.projectId = self.projectId;
            add.rowId = self.rowId;
            add.taskId = self.taskId;
            add.parameterAction = ^(id parameter) {
                if (self.parameterAction) {
                    self.parameterAction(parameter);
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }
        else{
            
            TFProjectAndTaskMainController *sta = [[TFProjectAndTaskMainController alloc] init];
            [self.navigationController pushViewController:sta animated:YES];
        }
        
    }
    else if ([module.english_name isEqualToString:@"memo"]){
        
        if (self.type == 3 || self.type == 6 || self.type == 7) {
            TFSelectMemoListController *memo = [[TFSelectMemoListController alloc] init];
            memo.parameterAction = ^(NSArray *parameter) {
                
                if (self.parameterAction) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:@1 forKey:@"beanType"];
                    [dict setObject:@"memo" forKey:@"bean"];
                    NSString *ids = @"";
                    NSMutableArray *arr = [NSMutableArray array];
                    for (TFNoteDataListModel *mo in parameter) {
                        ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%@,",[mo.id description]]];
                        [arr addObject:mo];
                    }
                    if (ids.length) {
                        ids = [ids substringToIndex:ids.length-1];
                    }
                    [dict setObject:ids forKey:@"data"];
                    [dict setObject:arr forKey:@"list"];
                    self.parameterAction(dict);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [self.navigationController pushViewController:memo animated:YES];
        }
        else if (self.type == 5) {// 新建
            TFCreateNoteController *create = [[TFCreateNoteController alloc] init];
            create.type = 0;
            create.dataAction = ^(NSDictionary *parameter) {
                
                if (self.memoAction) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:@1 forKey:@"beanType"];
                    [dict setObject:@"memo" forKey:@"bean"];
                    [dict setObject:[[parameter valueForKey:@"dataId"] description] forKey:@"data"];
                    
                    [self.navigationController popViewControllerAnimated:NO];
                    self.memoAction(dict);
                }
            };
            [self.navigationController pushViewController:create animated:YES];
        }
        else{
            
            TFNoteMainController *noteVC = [[TFNoteMainController alloc] init];
            [self.navigationController pushViewController:noteVC animated:YES];
        }
        
    }
    else if ([module.english_name isEqualToString:@"library"]){
        
        TFFileMenuController *menu = [[TFFileMenuController alloc] init];
        [self.navigationController pushViewController:menu animated:YES];
        
    }
    else if ([module.english_name isEqualToString:@"attendance"]){
        
        TFAttendanceTabbarController *attendance = [[TFAttendanceTabbarController alloc] init];
        [self.navigationController pushViewController:attendance animated:YES];
        
    }
    else if ([module.english_name isEqualToString:@"approval"]){
        
        if (self.type == 3 || self.type == 6 || self.type == 7) {// 引用
            
            TFModelEnterController *model = [[TFModelEnterController alloc] init];
            model.type = 2;
            model.selectApp = 1;
            model.parameterAction = ^(id parameter) {
                
                [self.navigationController popViewControllerAnimated:YES];
                if (self.parameterAction) {
                    self.parameterAction(parameter);
                }
            };
            [self.navigationController pushViewController:model animated:YES];
            
        }
        else if (self.type == 5){// 新建
            
            TFModelEnterController *model = [[TFModelEnterController alloc] init];
            model.type = 2;
            model.selectApp = 2;
            model.parameterAction = ^(id parameter) {
                
                [self.navigationController popViewControllerAnimated:NO];
                if (self.memoAction) {
                    self.memoAction(parameter);
                }
            };
            [self.navigationController pushViewController:model animated:YES];
            
        }
        else{
            
            TFApprovalMainController *Approve = [[TFApprovalMainController alloc] init];
            [self.navigationController pushViewController:Approve animated:YES];
            
        }
        
        
    }
    else if ([module.english_name isEqualToString:@"email"]) { //邮件
        if (self.type == 6) {
            TFSelectEmailController *email = [[TFSelectEmailController alloc] init];
            email.selectParameter = ^(NSArray *parameter) {
                
                if (self.parameterAction) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:@1 forKey:@"beanType"];
                    [dict setObject:@"email" forKey:@"bean"];
                    NSString *ids = @"";
                    NSMutableArray *arr = [NSMutableArray array];
                    for (TFNoteDataListModel *mo in parameter) {
                        ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%@,",[mo.id description]]];
                        [arr addObject:mo];
                    }
                    if (ids.length) {
                        ids = [ids substringToIndex:ids.length-1];
                    }
                    [dict setObject:ids forKey:@"data"];
                    [dict setObject:arr forKey:@"list"];
                    self.parameterAction(dict);
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [self.navigationController pushViewController:email animated:YES];
        }
        else{
            
            TFEmailsMainController *emailsVC = [[TFEmailsMainController alloc] init];
            [self.navigationController pushViewController:emailsVC animated:YES];
        }
        
    }
    else if ([module.english_name isEqualToString:@"repository_libraries"]) { // 知识库
        
        TFKnowledgeListController *att = [[TFKnowledgeListController alloc] init];
        [self.navigationController pushViewController:att animated:YES];
    }
    else if ([module.english_name isEqualToString:@"salary"]) { // 薪酬
        
        TFSalaryController *att = [[TFSalaryController alloc] init];
        [self.navigationController pushViewController:att animated:YES];
    }
    else{
        
        [self.blurWindowView hide];
        
        if (self.type == 2) {// 新增
            
            if (self.selectApp == 1) { // 任务引用选审批
                    
                TFApprovalListController *vc = [[TFApprovalListController alloc] init];
                vc.quote = YES;
                vc.type = @4;
                vc.module = module;
                vc.refreshAction = ^(NSMutableDictionary *dict) {
                  
                    [self.navigationController popViewControllerAnimated:NO];
                    
                    if (self.parameterAction) {
                        [dict setObject:@4 forKey:@"beanType"];
                        [dict setObject:module.english_name forKey:@"bean"];
                        [dict setObject:module.chinese_name forKey:@"moduleName"];
                        [dict setObject:module.id forKey:@"moduleId"];
                        [dict setObject:@"approval" forKey:@"approval"];
                        self.parameterAction(dict);
                    }
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
                    
            }else if (self.selectApp == 2) { // 任务新建审批
                
                TFAddCustomController *add = [[TFAddCustomController alloc] init];
                add.bean = module.english_name;
                add.moduleId = module.id;
                add.tableViewHeight = SCREEN_HEIGHT - 64;
                add.taskBlock = ^(NSMutableDictionary *dict) {
                    
                    [self.navigationController popViewControllerAnimated:NO];
                    
                    if (self.parameterAction) {
                        [dict setObject:@4 forKey:@"beanType"];
                        [dict setObject:module.english_name forKey:@"bean"];
                        [dict setObject:module.chinese_name forKey:@"moduleName"];
                        [dict setObject:module.id forKey:@"moduleId"];
                        self.parameterAction(dict);
                    }
                    
                };
                [self.navigationController pushViewController:add animated:YES];
                
            }else{
                
                TFAddCustomController *add = [[TFAddCustomController alloc] init];
                add.bean = module.english_name;
                add.moduleId = module.id;
                add.tableViewHeight = SCREEN_HEIGHT - 64;
                add.refreshAction = ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:NO];
                    });
                };
                [self.navigationController pushViewController:add animated:YES];
                
            }
        }
        else if (self.type == 3  || self.type == 6  || self.type == 7){// 引用
            TFSelectCustomListController *custom = [[TFSelectCustomListController alloc] init];
            custom.module = module;
            custom.parameterAction = ^(id parameter) {
                
                if (self.parameterAction) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:@3 forKey:@"beanType"];
                    [dict setObject:module.english_name forKey:@"bean"];
                    [dict setObject:module.id forKey:@"moduleId"];
                    [dict setObject:module.chinese_name forKey:@"moduleName"];
                    
                    NSString *str = @"";
                    for (TFCustomListItemModel *item in parameter) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.id value]]];
                        item.moduleName = module.chinese_name;
                        item.icon_color = module.icon_color;
                        item.icon_type = module.icon_type;
                        item.icon_url = module.icon_url;
                    }
                    if (str.length) {
                        str = [str substringToIndex:str.length-1];
                    }
                    [dict setObject:str forKey:@"data"];
                    [dict setObject:parameter forKey:@"list"];
                    
                    self.parameterAction(dict);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [self.navigationController pushViewController:custom animated:YES];
            
        }
        else if (self.type == 5){// 新建自定义
            
            
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.bean = module.english_name;
            add.moduleId = module.id;
            add.tableViewHeight = SCREEN_HEIGHT - 64;
            add.customBlock = ^(NSMutableDictionary *dict) {
                
                if (self.memoAction) {
                    [dict setObject:@3 forKey:@"beanType"];
                    
                    self.memoAction(dict);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }
        else{
            
            TFCustomListController *list = [[TFCustomListController alloc] init];
            list.module = module;
            [self.navigationController pushViewController:list animated:YES];
        }
    }
}


#pragma mark - TFBurWindowViewDelegate
-(void)burWindowViewDidClickedModelView:(TFModelView *)modelView module:(TFModuleModel *)module{
    
    if (module && !self.used) {
        
        [self jumpWithModule:module];
    }
    
}

-(void)burWindowViewDidClickedAddModule:(TFModuleModel *)module{
    
    BOOL have = NO;
    for (TFModuleModel *mo in self.oftenApplication.modules) {
        if ([module.english_name isEqualToString:mo.english_name]) {
            [self.oftenApplication.modules removeObject:mo];
            
            have = YES;
            break;
        }
    }
    
    if (self.oftenApplication.modules.count >= 10) {
        [MBProgressHUD showError:@"最多设置10个常用模块" toView:KeyWindow];
        return;
    }
    if (!have) {
        [self.oftenApplication.modules insertObject:module atIndex:0];
    }
    [self.tableView reloadData];
    
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
