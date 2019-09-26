//
//  TFSelectMemoListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/1.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectMemoListController.h"
#import "TFNoteDataListModel.h"
#import "TFCustomListCell.h"
#import "TFNoteBL.h"
#import "TFRefresh.h"
#import "TFNoteMainListModel.h"
#import "HQTFNoContentView.h"
#import "TFApprovalSearchView.h"
#import "TFSelectMemoCell.h"
#import "TFCreateNoteController.h"

@interface TFSelectMemoListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,UITextFieldDelegate,TFApprovalSearchViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** customBL */
@property (nonatomic, strong) TFNoteBL *noteBL;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** searchView */
@property (nonatomic, strong) TFApprovalSearchView *searchView;

/** noteWord */
@property (nonatomic, copy) NSString *noteWord;

@end

@implementation TFSelectMemoListController


-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)lists{
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
    self.pageNo = @1;
    self.pageSize = @30;
    self.noteBL = [TFNoteBL build];
    self.noteBL.delegate = self;
    
    
    self.navigationItem.title = @"备忘录";
     UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(selectSure) text:@"确定" textColor:GrayTextColor];
    UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(add) text:@"新增" textColor:GrayTextColor];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    [self.noteBL requestGetNoteListWithPageNum:[self.pageNo integerValue] pageSize:[self.pageSize integerValue] type:0 keyword:self.noteWord];
    
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
        _searchView.textFiled.backgroundColor = CellSeparatorColor;
        _searchView.searchBtn.hidden = YES;
        _searchView.backgroundColor = WhiteColor;
    }
    return _searchView;
}
#pragma mark - TFApprovalSearchViewDelegate
-(void)approvalSearchViewDidClickedStatusBtn{
    
    
}

-(void)approvalSearchViewTextChange:(UITextField *)textField{
    
    self.noteWord = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.noteBL requestGetNoteListWithPageNum:[self.pageNo integerValue] pageSize:[self.pageSize integerValue] type:0 keyword:self.noteWord];
    
    return YES;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getNoteList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        TFNoteMainListModel *model = resp.body;
        
        TFPageInfoModel *listModel = model.pageInfo;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.lists removeAllObjects];
        }
        
        [self.lists addObjectsFromArray:model.dataList];
        
        
        if ([listModel.totalRows integerValue] <= self.lists.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.lists.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

-(void)add{
    
    TFCreateNoteController *create = [[TFCreateNoteController alloc] init];
    create.type = 0;
    create.dataAction = ^(NSDictionary *parameter) {
        
        //            if (self.memoAction) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@1 forKey:@"beanType"];
        [dict setObject:@"memo" forKey:@"bean"];
        [dict setObject:[[parameter valueForKey:@"dataId"] description] forKey:@"data"];
        
        [self.navigationController popViewControllerAnimated:NO];
        //                self.memoAction(dict);
        //            }
    };
    [self.navigationController pushViewController:create animated:YES];
}

- (void)selectSure{
    
    NSMutableArray *selects = [NSMutableArray array];
    
    for (TFNoteDataListModel *model in self.lists) {
        
        if ([model.isSelect isEqualToNumber:@1]) {
            [selects addObject:model];
        }
    }
    
    if (selects.count <= 0) {
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    
    if (self.parameterAction) {
        [self.navigationController popViewControllerAnimated:NO];
        self.parameterAction(selects);
    }
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
    
    tableView.tableHeaderView = self.searchView;
    
    tableView.mj_header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNo = @1;
        
        [self.noteBL requestGetNoteListWithPageNum:[self.pageNo integerValue] pageSize:[self.pageSize integerValue] type:0 keyword:self.noteWord];
    }];
    
    
    tableView.mj_footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNo = @([self.pageNo integerValue]+1);
        [self.noteBL requestGetNoteListWithPageNum:[self.pageNo integerValue] pageSize:[self.pageSize integerValue] type:0 keyword:self.noteWord];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFNoteDataListModel *model = self.lists[indexPath.row];
    TFSelectMemoCell *cell = [TFSelectMemoCell selectMemoCellWithTableView:tableView];
    [cell refreshselectMemoCellWithModel:model];
    if (self.lists.count - 1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    TFNoteDataListModel *model = self.lists[indexPath.row];
    
    model.isSelect = [model.isSelect isEqualToNumber:@1] ? @0 : @1;
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
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
