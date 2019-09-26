//
//  HQTFModelBenchController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFModelBenchController.h"
#import "HQTFModelView.h"
#import "HQTFModelCell.h"
//#import "HQTFProjectMainController.h"
//#import "TFMainApprovalController.h"
#import "TFCompanyContactsController.h"
#import "TFCompanyCircleController.h"
#import "TFCustomBL.h"
#import "TFCustomListController.h"
#import "TFAddCustomController.h"
#import "HQTFNoContentView.h"
#import "TFBurWindowView.h"

@interface HQTFModelBenchController ()<UITableViewDelegate,UITableViewDataSource,HQTFModelCellDelegate,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 用于minusButton按钮类型， 0：添加，1：删除，2：没有（隐藏） ，3：有边框及可拖拽图标*/
/** 操控cellType */
@property (nonatomic, assign) NSInteger cellType;

/** UIView *statusView */
@property (nonatomic, strong) UIView *statusView;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;
/** applications */
@property (nonatomic, strong) NSMutableArray *applications;

/** used */
@property (nonatomic, assign) BOOL used;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** TFBurWindowView */
@property (nonatomic, strong) TFBurWindowView *blurWindowView;


@end

@implementation HQTFModelBenchController

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(leftClicked) image:@"返回" text:@" 工作台"];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
}

//- (void)leftClicked{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellType = 2;
    [self setFromNavBottomEdgeLayout];
    [self setupNavigation];
    [self setupTableView];
    [self setupBurWindowView];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.customBL requestCustomApplicationListWithApprovalFlag:self.type==1?@"1":nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteClicked:) name:deleteCell object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addClicked:) name:addCell object:nil];
}


- (void)deleteClicked:(NSNotification *)note{
    
    NSDictionary *dict = note.userInfo;
    
    TFModuleModel *model = [dict valueForKey:@"MODULE"];
    
    if (self.applications.count) {
        
        TFApplicationModel *app = self.applications[0];
        
        for (TFModuleModel *mo in app.modules) {
            
            if ([model.id isEqualToNumber:mo.id]) {
                
                [app.modules removeObject:mo];
                break;
            }
        }
        [self.tableView reloadData];
    }
    
}
- (void)addClicked:(NSNotification *)note{
    
        
    NSDictionary *dict = note.userInfo;
    
    TFModuleModel *model = [dict valueForKey:@"MODULE"];
    
    if (self.applications.count) {
        
        TFApplicationModel *app = self.applications[0];
        
        if (!app.modules) {
            app.modules = [NSMutableArray<Optional,TFModuleModel> array];
        }
        
        for (TFModuleModel *mo in app.modules) {
            
            if ([mo.id isEqualToNumber:model.id]) {
                
                [app.modules removeObject:mo];
                break;
            }
        }
        
        if (app.modules.count >= 5) {
            
            [MBProgressHUD showError:@"最多设置5个常用模块" toView:self.view];
            return;
        }
        
        [app.modules insertObject:[model mutableCopy] atIndex:0];
        
        [self.tableView reloadData];
    }
    
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (resp.cmdId == HQCMD_customApplicationList) {
        
        [self.applications addObjectsFromArray:resp.body];
        
        if (self.applications.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customApplicationOften) {
        
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


#pragma mark - Navigation
- (void)setupNavigation{
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(leftClicked) image:@"返回" text:@" 工作台"];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) text:@"管理"];
    self.navigationItem.title = @"我的应用";
}

- (void)leftClicked{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        if (!self.applications.count) {
            return;
        }
        
        TFApplicationModel *app = self.applications[0];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFModuleModel *mo in app.modules) {
            
            if (mo.id) {
                [arr addObject:mo.id];
            }
            
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestCustomOftenApplicationListWithModules:arr];
    }
}

- (void)setupBurWindowView{
    TFBurWindowView *view = [[TFBurWindowView alloc] initWithFrame:self.view.bounds];
    [KeyWindow addSubview:view];
    view.hidden = YES;
    view.frame = KeyWindow.bounds;
    self.blurWindowView = view;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.applications.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        
//        HQTFModelCell *cell = [HQTFModelCell modelCellWithTableView:tableView];
//        cell.cellType = self.cellType;
//        cell.modelType = 0;
//        cell.delegate = self;
//        return cell;
//    }else if (indexPath.section == 1) {
//        
//        HQTFModelCell *cell = [HQTFModelCell modelCellWithTableView:tableView];
////        cell.cellType = 2;
//        
//        cell.cellType = self.cellType;
//        cell.modelType = 4;
//        cell.delegate = self;
//        return cell;
//    }else if (indexPath.section == 2) {
//        
//        HQTFModelCell *cell = [HQTFModelCell modelCellWithTableView:tableView];
////        cell.cellType = 2;
//        
//        cell.cellType = self.cellType;
//        cell.modelType = 5;
//        cell.delegate = self;
//        return cell;
//    }else{
//        
//        HQTFModelCell *cell = [HQTFModelCell modelCellWithTableView:tableView];
//        cell.cellType = 2;
//        cell.modelType = 1;
//        return cell;
//    }
    
    if (self.used) {
        
        if (indexPath.section == 0) {
            
            HQTFModelCell *cell = [HQTFModelCell modelCellWithTableView:tableView];
            cell.cellType = 1;
            cell.delegate = self;
            [cell refreshModelCellWithModel:self.applications[indexPath.section]];
            return cell;
            
        }else{
            
            HQTFModelCell *cell = [HQTFModelCell modelCellWithTableView:tableView];
            cell.cellType = 0;
            cell.delegate = self;
            [cell refreshModelCellWithModel:self.applications[indexPath.section]];
            return cell;
            
        }
    }else{
        
        HQTFModelCell *cell = [HQTFModelCell modelCellWithTableView:tableView];
        cell.cellType = 2;
        cell.delegate = self;
        [cell refreshModelCellWithModel:self.applications[indexPath.section]];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return [HQTFModelCell refreshModelCellHeightWithModel:self.applications[indexPath.section]];
}


/** ******************自定义****************** */
-(void)modelCell:(HQTFModelCell *)modelCell didSelectModule:(TFModuleModel *)model{
    
    if (self.used) {
        return;
    }
    
    if (self.type == 0) {
        
        TFCustomListController *list = [[TFCustomListController alloc] init];
        list.module = model;
        [self.navigationController pushViewController:list animated:YES];
    }else{
        TFAddCustomController *add = [[TFAddCustomController alloc] init];
        add.bean = model.english_name;
        add.tableViewHeight = SCREEN_HEIGHT - 64;
        [self.navigationController pushViewController:add animated:YES];
        
    }
    
}

-(void)modelCell:(HQTFModelCell *)modelCell didSelectModule:(TFModuleModel *)model contentView:(UIView *)view{
    
//    self.blurWindowView.hidden = NO;
//    [KeyWindow addSubview:self.blurWindowView];
//    CGRect rect = [view convertRect:view.frame toView:self.blurWindowView];
//    
//    [self.blurWindowView refreshItemWithModels:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""] rect:rect];
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
