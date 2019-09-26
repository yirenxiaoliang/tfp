//
//  TFEmailsAddressBookController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsAddressBookController.h"
#import "HQTFSearchHeader.h"

#import "TFSelectPeopleElementCell.h"
#import "TFEmailAddessBookModel.h"
#import "TFEmailsNewController.h"

#import "TFMailBL.h"

@interface TFEmailsAddressBookController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,TFSelectPeopleElementCellDelegate,HQBLDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@property (nonatomic, strong) TFMailBL *mailBL;

@property (nonatomic, strong) TFEmailAddessBookModel *emailAddressBookModel;

/** 搜索状态 */
@property (nonatomic, assign) BOOL searchStatus;

/** 选中联系人数组 */
@property (nonatomic, strong) NSMutableArray *selectPersons;

@property (nonatomic, copy) NSString *word;

@end

@implementation TFEmailsAddressBookController

- (NSMutableArray *)selectPersons {

    if (!_selectPersons) {
        
        _selectPersons = [NSMutableArray array];
    }
    return _selectPersons;
}

- (TFEmailAddessBookModel *)emailAddressBookModel {

    if (!_emailAddressBookModel) {
        
        _emailAddressBookModel = [[TFEmailAddessBookModel alloc] init];
    }
    return _emailAddressBookModel;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [self.headerSearch removeFromSuperview];
    [self searchHeaderCancelClicked];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    [self setupHeaderSearch];
    
    self.mailBL = [TFMailBL build];
    self.mailBL.delegate = self;
    [self.mailBL getMailCatalogQueryList:@1 pageSize:@20 keyWord:nil];
}

- (void)setNavi {

    self.navigationItem.title = @"通讯录";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:GreenColor];
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{

    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    [view addSubview:headerSearch];
    view.layer.masksToBounds = YES;
    self.headerSearch = headerSearch;
    self.headerSearch.type = SearchHeaderTypeSearch;
    self.tableView.tableHeaderView = view;
    headerSearch.backgroundColor = WhiteColor;
    headerSearch.textField.backgroundColor = BackGroudColor;
    headerSearch.image.backgroundColor = BackGroudColor;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.mailBL getMailCatalogQueryList:@1 pageSize:@20 keyWord:textField.text];
    
    self.word = textField.text;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = self.word;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = self.word;
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
    return self.emailAddressBookModel.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.row];
    
    cell.delegate = self;
    TFEmailAddessBookItemModel *model = self.emailAddressBookModel.dataList[indexPath.row];
    [cell refreshEmailsAddressBookWithModel:model];
    cell.selectBtn.tag = indexPath.row;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFSelectPeopleElementCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectPeopleElementCellDidClickedSelectBtn:cell.selectBtn];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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

#pragma mark - searchHeader Deleaget
-(void)searchHeaderCancelClicked{
    
    self.header.type = SearchHeaderTypeNormal;
    self.headerSearch.type = SearchHeaderTypeNormal;
    [self.headerSearch.textField resignFirstResponder];
    
    if (self.searchStatus) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.headerSearch.y = 24;
            self.tableView.contentInset = UIEdgeInsetsMake(108, 0, 49, 0);
            self.tableView.contentOffset = CGPointMake(0, -108);
        }completion:^(BOOL finished) {
            
            self.tableView.tableHeaderView = self.header;
            self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 49, 0);
            [self.headerSearch removeFromSuperview];
        }];
    }else{
        
        self.tableView.tableHeaderView = self.header;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 49, 0);
        [self.headerSearch removeFromSuperview];
    }
    self.searchStatus = NO;
}

-(void)searchHeaderClicked{
    
    
//    TFSearchChatRecordController *search = [[TFSearchChatRecordController alloc] init];
//    
//    [self.navigationController pushViewController:search animated:YES];
}

- (void)touched{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
    self.tableView.frame = CGRectMake(0,-128, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.headerSearch.type = SearchHeaderTypeNormal;
    
    [UIView animateWithDuration:0.25 animations:^{
        UIView *lineView = [self.navigationController.navigationBar viewWithTag:0x1314];
        lineView.y = 64;
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        
        self.tableView.frame = CGRectMake(0,-64, SCREEN_WIDTH, SCREEN_HEIGHT);
    }completion:^(BOOL finished) {
        self.headerSearch.height = 64;
        self.tableView.tableHeaderView = self.headerSearch;
    }];
    
}

#pragma mark
- (void)sureAction {

    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[TFEmailsNewController class]]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectEmialModuleAccountNotification" object:self.selectPersons];
            
            [self.navigationController popToViewController:controller animated:YES];
            
            
        }
        
    }
    
}

#pragma mark TFSelectPeopleElementCellDelegate 
-(void)selectPeopleElementCellDidClickedSelectBtn:(UIButton *)selectBtn {

    TFEmailAddessBookItemModel *model = self.emailAddressBookModel.dataList[selectBtn.tag];
    
    model.index = @(self.index);
    
    if ([model.select isEqualToNumber:@1]) {
        
        model.select = @0;
        
        [self.selectPersons removeObject:model];
    }
    else {
    
        model.select = @1;
        
        [self.selectPersons addObject:model];
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_mailCatalogQueryList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.emailAddressBookModel = resp.body;
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
