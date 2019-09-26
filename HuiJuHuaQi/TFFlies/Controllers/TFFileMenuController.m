//
//  TFFileMenuController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileMenuController.h"
#import "TFOneLevelFolderController.h"
#import "HQTFTwoLineCell.h"
#import "TFFolderMenuModel.h"
#import "TFFileBL.h"
#import "TFFileProjectListController.h"
#import "TFCachePlistManager.h"

@interface TFFileMenuController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, strong) TFFolderMenuModel *menuModel;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation TFFileMenuController

- (TFFolderMenuModel *)menuModel {

    if (!_menuModel) {
        
        _menuModel = [[TFFolderMenuModel alloc] init];
    }
    return _menuModel;
}

- (NSMutableArray *)datas {

    if (!_datas) {
        
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"文件库";
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    [self.fileBL requestQueryfileCatalogWithData];

    
    self.series = 1;
    
    [self setupTableView];
    
    // 获取缓存数据
    NSArray *datas = [TFCachePlistManager getFileMenuDatas];
    if (datas.count) {
        [self.datas addObjectsFromArray:[self handleDatas:datas]];
        [self.tableView reloadData];
    }
}

/** 将字段转化为frameModel */
- (NSArray *)handleDatas:(NSArray *)datas{
    
    NSMutableArray *frames = [NSMutableArray array];
    for (NSDictionary *dict in datas) {
        TFFolderMenuModel *cate = [[TFFolderMenuModel alloc] initWithDictionary:dict error:nil];
        
        if (cate) {
            [frames addObject:cate];
        }
    }
    return frames;
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
    
    return self.datas.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFolderMenuModel *model = self.datas[indexPath.row];
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    cell.topLabel.text = model.name;
    
    if ([model.id isEqualToNumber:@1]) {
     
        [cell.titleImage setImage:IMG(@"公司文件库") forState:UIControlStateNormal];
    }
    else if ([model.id isEqualToNumber:@2]) {
    
        [cell.titleImage setImage:IMG(@"颜值文库") forState:UIControlStateNormal];
    }
    else if ([model.id isEqualToNumber:@3]) {
        
        [cell.titleImage setImage:IMG(@"个人文件库") forState:UIControlStateNormal];
    }
    else if ([model.id isEqualToNumber:@4]) {
        
        [cell.titleImage setImage:IMG(@"我共享的文件库") forState:UIControlStateNormal];
    }
    else if ([model.id isEqualToNumber:@5]) {
        
        [cell.titleImage setImage:IMG(@"与我共享") forState:UIControlStateNormal];
    }
    else if ([model.id isEqualToNumber:@6]) {
        
        [cell.titleImage setImage:IMG(@"项目文件") forState:UIControlStateNormal];
    }
    cell.topLabel.textColor = kUIColorFromRGB(0x4A4A4A);
    cell.enterImage.hidden = YES;
    cell.type = TwoLineCellTypeOne;
    
    if (indexPath.row<self.datas.count-1) {
        
       cell.bottomLine.hidden = NO;
    }
    else {
    
        cell.bottomLine.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFFolderMenuModel *model = self.datas[indexPath.row];
    
    if (indexPath.row == 5) { //项目文件
        
        TFFileProjectListController *proListVC = [[TFFileProjectListController alloc] init];
        proListVC.naviTitle = model.name;
        proListVC.pathArr = [NSMutableArray array];
        [proListVC.pathArr addObject:model.name];
        proListVC.isFileLibraySelect = self.isFileLibraySelect;
        proListVC.parameterAction = ^(id parameter) {
          
            if (self.refreshAction) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                self.refreshAction(parameter);
                
            }
        };
        [self.navigationController pushViewController:proListVC animated:YES];
    }
    else {
        
        TFOneLevelFolderController *oneLevel = [[TFOneLevelFolderController alloc] init];
        
        oneLevel.naviTitle = model.name;
        oneLevel.pathArr = [NSMutableArray array];
        [oneLevel.pathArr addObject:model.name];
        
        oneLevel.isFileLibraySelect = self.isFileLibraySelect;
        
        oneLevel.style = [model.id integerValue];
        
        oneLevel.refreshAction = ^(id parameter) {
            
            if (self.refreshAction) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                self.refreshAction(parameter);
                
            }
        };
        
        [self.navigationController pushViewController:oneLevel animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isFileLibraySelect) {
        
        TFFolderMenuModel *model = self.datas[indexPath.row];
        
        if ([model.id isEqualToNumber:@4] || [model.id isEqualToNumber:@5]) {
            
            return 0;
        }
    }
    
    return 70;
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
    
    if (resp.cmdId == HQCMD_queryfileCatalog) {
        
        self.datas = resp.body;
        
        [self.tableView reloadData];
        
        // 缓存目录列表
            
        NSMutableArray *arr = [NSMutableArray array];
        for (TFFolderMenuModel *model in self.datas) {
            NSString *str = [model toJSONString];
            [arr addObject:str];
        }
        [TFCachePlistManager saveFileMenuDataWithDatas:arr];
            
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
