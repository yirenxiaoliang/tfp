//
//  HQTFDepartPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFDepartPeopleController.h"
#import "HQTFSearchHeader.h"
#import "HQTFTwoLineCell.h"
#import "TFPeopleBL.h"

@interface HQTFDepartPeopleController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** header */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** headerView */
@property (nonatomic, strong) UIView *headerView;

/** 分组数据 */
@property (nonatomic, strong)NSMutableArray * searchSectionArray ;

/** 分组标题 */
@property (nonatomic, strong)NSMutableArray * searchTitleArray;


/** 全部数据（未分组） */
@property (nonatomic, strong) NSMutableArray *allDatas;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;


@end

@implementation HQTFDepartPeopleController

-(NSMutableArray *)allDatas{
    if (!_allDatas) {
        _allDatas = [NSMutableArray array];
    }
    return _allDatas;
}

-(NSMutableArray *)searchSectionArray{
    
    if (!_searchSectionArray) {
        
        _searchSectionArray = [NSMutableArray array];
        
//        for (NSInteger i = 1; i < 6; i ++) {
//            
//            NSMutableArray *arr = [NSMutableArray array];
//            NSString *str = [NSString stringWithFormat:@"深圳公司%ld",i];
//            
//            for (NSInteger j = 6-i; j < 6; j ++) {
//                
//                NSString *str = [NSString stringWithFormat:@"%ld",j];
//                
//                [arr addObject:str];
//            }
//            
//            [self.searchTitleArray addObject:str];
//            
//            [_searchSectionArray addObject:arr];
//        }
    }
    return _searchSectionArray;
}

-(NSMutableArray *)searchTitleArray{
    
    if (!_searchTitleArray) {
        _searchTitleArray = [NSMutableArray array];
    }
    return _searchTitleArray;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消" textColor:ExtraLightBlackTextColor];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
    [self searchHeaderCancelClicked];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupTableView];
    [self setupHeaderSearch];
    [self textFieldChange:nil];
    [self setupNavigation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    [self.peopleBL requestGetEmployeeByParamWithPageNo:1 pageSize:10000 departmentId:nil isNo:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    if (self.type == ControllerTypeDepartment) {
        
        self.navigationItem.title = @"部门成员";
    }else{
        
        self.navigationItem.title = @"客户成员";
    }
}

- (void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
}


#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    headerView.backgroundColor = HexColor(0xe7e7e7, 1);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    header.delegate = self;
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

-(void)searchHeaderClicked{
    
    self.headerSearch.type = SearchHeaderTypeMove;
    [self.headerSearch.textField becomeFirstResponder];
    self.headerSearch.frame = CGRectMake(0, 24, SCREEN_WIDTH, 64);
    [self.navigationController.navigationBar addSubview:self.headerSearch];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.headerSearch.y = -20;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        
        self.tableView.tableHeaderView = nil;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -44);
    }];
    
}


-(void)searchHeaderCancelClicked{
    
    self.header.type = SearchHeaderTypeNormal;
    self.headerSearch.type = SearchHeaderTypeNormal;
    [self.headerSearch.textField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.headerSearch.y = 24;
        self.tableView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -88);
    }completion:^(BOOL finished) {
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        [self.headerSearch removeFromSuperview];
    }];
    
}

- (void)keyboardHide{
    
    
}

-(void)searchHeaderTextChange:(UITextField *)textField{
    
    [self textFieldChange:textField];
}

- (void)textFieldChange:(UITextField *)textField
{
    
    NSMutableArray * nameMutArr  = [[NSMutableArray alloc] init];     //用于存加入标识（下标）后的名字
    
    NSMutableArray *beginEmployArr = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        for (HQEmployModel *contactsModel in self.allDatas) {
            
            //只要搜索框里的字被包含，或搜索框里无字时，保存
            if ([TEXT(contactsModel.employeeName) rangeOfString:TEXT(textField.text)].length > 0  ||  textField.text.length == 0) {
                
                NSString *nameIdStr = [NSString stringWithFormat:@"%@HJHQID%d", TEXT(contactsModel.employeeName), i];
                
                [nameMutArr addObject:nameIdStr];
                
                [beginEmployArr addObject:contactsModel];
                
                i++;
            }
        }
        
        
        [self.tableView reloadData];
    }

}



#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.searchSectionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = self.searchSectionArray[section];
    
    return rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    [cell.titleImage setImage:[UIImage imageNamed:@"部门"] forState:UIControlStateNormal];
    [cell.titleImage setImage:[UIImage imageNamed:@"部门"] forState:UIControlStateHighlighted];
    cell.topLabel.text = @"张杰";
    cell.bottomLabel.text = @"首席体验师";
    cell.bottomLine.hidden = NO;
    [cell.enterImage setImage:[UIImage imageNamed:@"关闭30"] forState:UIControlStateNormal];
    
    NSArray *rows = self.searchSectionArray[indexPath.section];
    if (rows.count == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = BackGroudColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.backgroundColor = HexColor(0xf2f2f2, 1);
    label.font = [UIFont systemFontOfSize:14.0];
    NSString *sectionStr=[self.searchTitleArray objectAtIndex:(section)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getEmployeeByParam) {
        
        [self.allDatas removeAllObjects];
        [self.allDatas addObjectsFromArray:resp.body];
        [self textFieldChange:nil];
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
