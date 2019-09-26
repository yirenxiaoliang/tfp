//
//  TFMoveFileController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMoveFileController.h"

#import "TFSelectFolderCell.h"
#import "TFFilePathView.h"
#import "HQTFNoContentView.h"

#import "TFFolderListModel.h"
#import "TFMainListModel.h"

#import "TFFileBL.h"

@interface TFMoveFileController ()<UITableViewDelegate,UITableViewDataSource,TFFilePathViewDelegate,HQBLDelegate,TFSelectFolderCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@property (nonatomic, strong) NSArray *nameArr;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, assign) BOOL select;

/** 点击索引 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) TFMainListModel *mainModel;

@property (nonatomic, assign) BOOL enable;

@end

@implementation TFMoveFileController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameArr = [NSArray array];
    
    _select = NO;
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    self.enable = YES;
    
    if (self.folderSeries == 0) {
        
        [self.fileBL requestQueryCompanyListWithData:@(self.style) pageNum:@1 pageSize:@20 sign:@0];
    }
    else {
    
        [self.fileBL requestQueryCompanyPartListWithData:@(self.style) parentId:self.parentId pageNum:@1 pageSize:@20 sign:@0];
    }
    
    [self setNavi];
    
    [self setupTableView];
}

- (void)setNavi {

    if (self.type == 0) {
        
        self.navigationItem.title = @"移动到";
    }
    else if (self.type == 1) {
    
        self.navigationItem.title = @"复制到";
    }
    else if (self.type == 2) {
    
        self.navigationItem.title = @"转为公司文件";
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:GreenColor];
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
    return _nameArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFolderListModel *model = _nameArr[indexPath.row];
    
    TFSelectFolderCell *cell = [TFSelectFolderCell SelectFolderCellWithTableView:tableView];
    
    cell.index = indexPath.row;
    cell.delegate = self;
    
    if (indexPath.row == self.index) {
        
        if (_select) {
            
            [cell.selectBtn setImage:IMG(@"选中文件夹") forState:UIControlStateNormal];
        }
        else {
            
            [cell.selectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
        }
    }
    else {
    
        [cell.selectBtn setImage:IMG(@"没选中") forState:UIControlStateNormal];
    }
    
    if ([model.type isEqualToString:@"1"]) {
        
        cell.folderImg.image = IMG(@"新建文件夹");
    }
    else {
    
        cell.folderImg.image = IMG(@"文件夹");
    }
    cell.folderImg.backgroundColor = [HQHelper colorWithHexString:model.color];
    
    cell.folderNameLab.text = model.name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    _select = NO; //跳页选中状态置为NO
    
    TFFolderListModel *model = _nameArr[indexPath.row];
    
    TFMoveFileController *moveFile = [[TFMoveFileController alloc] init];
    
    moveFile.folderSeries = self.folderSeries + 1;
    moveFile.parentId = model.id;
    moveFile.style = self.style;
    moveFile.folderId = self.folderId;
    moveFile.type = self.type;
    
    moveFile.pathArr = [NSMutableArray arrayWithArray:self.pathArr];
    [moveFile.pathArr addObject:model.name];
    
    [self.navigationController pushViewController:moveFile animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TFFilePathView *pathView = [[TFFilePathView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,35 ) titleArr:self.pathArr];
    
    pathView.delegate = self;
    
    return pathView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark 确定
- (void)sureAction {
    
    if (!_select) {
        
        [MBProgressHUD showError:@"请选择文件夹！" toView:self.view];
        return;
    }
    if (self.enable) {
        
        TFFolderListModel *model = _nameArr[self.index];
        
        if ([self.folderId isEqualToNumber:model.id]) {
            
            [MBProgressHUD showError:@"不能移动到原文件夹！" toView:self.view];
            return;
        }
        if (self.type == 0|| self.type == 2) { //移动
            
            [self.fileBL requestShiftFileLibraryWithData:self.folderId targetId:model.id style:@(self.style)];
        }
        else if (self.type == 1) { //复制
            
            [self.fileBL requestCopyFileLibraryWithData:self.folderId targetId:model.id style:@(self.style)];
        }
        self.enable = NO;
    }
    
    
}

#pragma mark TFSelectFolderCellDelegate
- (void)selectFolder:(NSInteger)index {

    if (self.index != index) {
        
        _select = NO;
        self.index = index;
    }
    
    if (_select) {
        
        _select = NO;
    }
    else {
    
        _select = YES;
    }
    
    [self.tableView reloadData];
}

#pragma mark TFFilePathViewDelegate
- (void)selectFilePath:(NSInteger)index {
        
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[TFMoveFileController class]] ) {
            TFMoveFileController *move =(TFMoveFileController *)controller;
            
            if (move.folderSeries == index) {
                
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
            
        }
    }
    
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
 
    if (resp.cmdId == HQCMD_queryCompanyList || resp.cmdId == HQCMD_queryCompanyPartList) {
        
        self.mainModel = resp.body;
        _nameArr = self.mainModel.dataList;
        
        if (_nameArr.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_shiftFileLibrary) {
        
        if (self.type == 0) {
            
            [MBProgressHUD showError:@"移动成功" toView:self.view];
        }
        
        
        if (self.type == 2) {
            
            [MBProgressHUD showError:@"转移成功" toView:self.view];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MoveFileSuccessNotification object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_copyFileLibrary) {
        
        if (self.type == 1) {
            
            [MBProgressHUD showError:@"复制成功" toView:self.view];
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
