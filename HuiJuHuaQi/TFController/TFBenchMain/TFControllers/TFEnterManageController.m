//
//  TFEnterManageController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/21.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterManageController.h"
#import "UITableView+MoveCell.h"
#import "TFEnterMoveCell.h"
#import "TFApprovalSearchView.h"
#import "TFCustomBL.h"

@interface TFEnterManageController ()<UITableViewDelegate,UITableViewDataSource,TFEnterMoveCellDelegate,UITextFieldDelegate,TFApprovalSearchViewDelegate,HQBLDelegate>

@property (nonatomic, weak)  UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *totals;
@property (nonatomic, strong) NSMutableArray *minus;
@property (nonatomic, strong) NSMutableArray *adds;
@property (nonatomic, strong) NSMutableArray *totalDatas;

@property (nonatomic, strong) TFApprovalSearchView *searchView;


@property (nonatomic, strong) TFCustomBL *customBL;

@end

@implementation TFEnterManageController

-(NSMutableArray *)totalDatas{
    if (!_totalDatas) {
        _totalDatas = [NSMutableArray array];
    }
    return _totalDatas;
}

-(TFApprovalSearchView *)searchView{
    if (!_searchView) {
        
        _searchView = [TFApprovalSearchView approvalSearchView];
        _searchView.frame = (CGRect){0,0,SCREEN_WIDTH,46};
        _searchView.type = 1;
        _searchView.textFiled.returnKeyType = UIReturnKeySearch;
        _searchView.textFiled.delegate = self;
        _searchView.textFiled.placeholder = @"请输入关键字搜索";
        _searchView.delegate = self;
        _searchView.textFiled.backgroundColor = BackGroudColor;
        _searchView.searchBtn.hidden = YES;
        _searchView.backgroundColor = WhiteColor;
    }
    return _searchView;
}
#pragma mark - TFApprovalSearchViewDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.tableView.notMove = YES;
}

- (void)approvalSearchViewTextChange:(UITextField *)textField{

    if (textField.text.length == 0) {
        self.tableView.notMove = NO;
        [self.totals removeAllObjects];
        [self.totals addObjectsFromArray:self.totalDatas];
        [self.tableView reloadData];
        return;
    }

    UITextRange *range = [textField markedTextRange];
    if (range == nil) {
        
        [self.totals removeAllObjects];
        for (NSArray *arr in self.totalDatas) {
            NSMutableArray *sub = [NSMutableArray array];
            for (TFModuleModel *model in arr) {
                if ([model.chinese_name containsString:textField.text]) {
                    [sub addObject:model];
                }
            }
            [self.totals addObject:sub];
        }
        [self.tableView reloadData];
    }
   
}

-(NSMutableArray *)totals{
    if (!_totals) {
        _totals = [NSMutableArray array];
        [_totals addObject:self.minus];
        [_totals addObject:self.adds];
    }
    return _totals;
}

-(NSMutableArray *)minus{
    if (!_minus) {
        _minus = [NSMutableArray array];
    }
    return _minus;
}
-(NSMutableArray *)adds{
    if (!_adds) {
        _adds = [NSMutableArray array];
    }
    return _adds;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.minus addObjectsFromArray:self.shows];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self.customBL requestAllModule];
    self.navigationItem.title = @"添加模块";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    [self setupTableView];
}

-(void)sure{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *arr = [NSMutableArray array];
    for (TFModuleModel *model in self.minus) {
        model.data_type = @1;
        NSDictionary *dict = [model toDictionary];
        if (dict) {
            [arr addObject:dict];
        }
    }
    
    [self.customBL requestSaveOftenModules:arr];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_saveOftenModule) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"保存成功" toView:KeyWindow];
        
        if (self.refreshAction) {
            self.refreshAction(self.minus);
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
    if (resp.cmdId == HQCMD_workEnterAllModule) {
        
        [self.adds removeAllObjects];
        NSArray *arr = resp.body;
        for (TFModuleModel *model in arr) {
            if ([model.english_name isEqualToString:@"workbench"]) {
                continue;
            }
            BOOL have = NO;
            for (TFModuleModel *mo in self.minus) {
                if ([model.english_name isEqualToString:mo.english_name]) {
                    have = YES;
                    break;
                }
            }
            if (!have) {
                [self.adds addObject:model];
            }
        }
        [self.totalDatas removeAllObjects];
        [self.totalDatas addObjectsFromArray:self.totals];
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStyleGrouped];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.tableHeaderView = self.searchView;
    
    __weak typeof(self) weakSelf = self;
    [tableView setDataWithArray:self.totals withBlock:^(NSMutableArray *newArray) {
        weakSelf.totals = newArray;
    }];
    
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.totals.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.totals[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFEnterMoveCell *cell = [TFEnterMoveCell enterMoveCellWithTableView:tableView];
    NSArray *arr = self.totals[indexPath.section];
    [cell refreshEnterMoveCellWithModel:arr[indexPath.row]];
    cell.delegate = self;
    cell.tag = 0x999 * indexPath.section + indexPath.row;
    if (indexPath.section == 0) {
        cell.type = 0;
    }else{
        cell.type = 1;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,8,SCREEN_WIDTH,36}];
    if (section == 0) {
        view.height = 36;
        label.y = 0;
    }else{
        view.height = 44;
        label.y = 8;
    }
    [view addSubview:label];
    label.textColor = ExtraLightBlackTextColor;
    label.backgroundColor = WhiteColor;
    label.font = FONT(12);
    
    if (section == 0) {
        label.text = @"      当前显示的模块";
    }else{
        label.text = @"      可以添加的模块";
    }
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 36;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}
#pragma mark - TFEnterMoveCellDelegate
-(void)enterMoveCellDidClickedAddWithModule:(TFModuleModel *)module index:(NSInteger)index{
    
    NSMutableArray *last = self.totals.lastObject;
    NSMutableArray *first = self.totals.firstObject;
    if (last == self.adds && first == self.minus) {
        [self.adds removeObject:module];
        [self.minus addObject:module];
    }else{
        [self.adds removeObject:module];
        [self.minus addObject:module];
        [last removeObject:module];
        [first addObject:module];
    }
    [self.tableView reloadData];
}
-(void)enterMoveCellDidClickedMinusWithModule:(TFModuleModel *)module index:(NSInteger)index{
    
    NSMutableArray *last = self.totals.lastObject;
    NSMutableArray *first = self.totals.firstObject;
    
    if (last == self.adds && first == self.minus) {
        
        [self.minus removeObject:module];
        [self.adds addObject:module];
    }else{
        
        [self.minus removeObject:module];
        [self.adds addObject:module];
        [first removeObject:module];
        [last addObject:module];
    }
    [self.tableView reloadData];
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
