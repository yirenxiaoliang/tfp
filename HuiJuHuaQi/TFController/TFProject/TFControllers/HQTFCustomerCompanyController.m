//
//  HQTFCustomerCompanyController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCustomerCompanyController.h"
#import "HQTFSearchHeader.h"
#import "ChineseString.h"
#import "HQCustomerModel.h"
#import "HQTFRelateCell.h"

@interface HQTFCustomerCompanyController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate>


/**  tableView */
@property (nonatomic, weak) UITableView *tableView;
/**  headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/**  header */
@property (nonatomic, strong) HQTFSearchHeader *header;
/**  headerView */
@property (nonatomic, strong) UIView *headerView;

/** 分组数据（section标题） */
@property (nonatomic, strong)NSMutableArray * searchSectionArray ;

/** 分组标题（添加特殊标记的） */
@property (nonatomic, strong)NSMutableArray * searchTitleArray;


/** 全部数据（未分组） */
@property (nonatomic, strong) NSMutableArray *allDatas;

/** 二维数组,显示数据 */
@property (nonatomic, strong) NSMutableArray * searchEmoloyArray ;

@end

@implementation HQTFCustomerCompanyController


-(NSMutableArray *)allDatas{
    
    if (!_allDatas) {
        _allDatas = [NSMutableArray array];
        
        NSArray *arr = @[@"啊",@"吧",@"传",@"在",@"到",@"额",@"个",@"人",@"有",@"洗"];
        for (NSInteger i = 0; i < 20; i ++) {
            
            HQCustomerModel *model = [[HQCustomerModel alloc] init];
            model.customerTitle = [NSString stringWithFormat:@"%@我是%ld个家公司",arr[i%10],i];
            model.time = @"2017-01-01";
            [_allDatas addObject:model];
        }
        
    }
    return _allDatas;
}

-(NSMutableArray *)searchSectionArray{
    
    if (!_searchSectionArray) {
        
        _searchSectionArray = [NSMutableArray array];
        
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
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupTableView];
    [self setupHeaderSearch];
    [self textFieldChange:nil];
    [self setupNavigation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GreenColor];
    
    self.navigationItem.title = @"客户";
}

- (void)back{
    
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
        
        for (HQCustomerModel *contactsModel in self.allDatas) {
            
            
            //只要搜索框里的字被包含，或搜索框里无字时，保存
            if ([TEXT(contactsModel.customerTitle) rangeOfString:TEXT(textField.text)].length > 0  ||  textField.text.length == 0) {
                
                NSString *nameIdStr = [NSString stringWithFormat:@"%@HJHQID%d", TEXT(contactsModel.customerTitle), i];
                
                [nameMutArr addObject:nameIdStr];
                
                [beginEmployArr addObject:contactsModel];
                
                i++;
            }
        }
        
        
        
        self.searchSectionArray = [ChineseString IndexArray:nameMutArr];
        
        self.searchTitleArray = [ChineseString LetterSortArray:nameMutArr];
        
        
        
        NSMutableArray *modelMutArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<self.searchTitleArray.count; i++) {
            
            NSArray *arr = self.searchTitleArray[i];
            
            NSMutableArray *subLevelArr = [[NSMutableArray alloc] init];
            
            for (int i=0; i<arr.count; i++) {
                
                //
                NSString *contentStr = arr[i];
                
                NSArray  *contentArr = [contentStr componentsSeparatedByString:@"HJHQID"];
                
                NSInteger subscriptNum = [[contentArr lastObject] integerValue];
                
                //根据名字的排序，再根据下标，得到MODEL排序
                [subLevelArr addObject:beginEmployArr[subscriptNum]];
            }
            
            [modelMutArr addObject:subLevelArr];
            
        }
        
        
        self.searchEmoloyArray = modelMutArr;
        
        
        [self.tableView reloadData];
    }
}



#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    //索引栏颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //索引栏文字颜色
    self.tableView.sectionIndexColor = ExtraLightBlackTextColor;
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return  self.searchSectionArray;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = BackGroudColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.backgroundColor = HexColor(0xf2f2f2, 1);
    label.font = [UIFont systemFontOfSize:14.0];
    NSString *sectionStr=[self.searchSectionArray objectAtIndex:(section)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.searchEmoloyArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.searchEmoloyArray[section];
    
    return  arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQTFRelateCell *cell = [HQTFRelateCell relateCellWithTableView:tableView];
    HQCustomerModel *model = self.searchEmoloyArray[indexPath.section][indexPath.row];
    [cell refreshCellWithModel:model withType:0];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    HQContactsModel *model = self.searchEmoloyArray[indexPath.section][indexPath.row];
//    
//    model.selected = !model.selected;
//    
//    [self.searchList replaceObjectAtIndex:indexPath.row withObject:model];
//    
//    
//    [_contactsTableView reloadData];
//    
//    
//    [HQTFContactChoiceView showContactChoiceView:[NSString stringWithFormat:@"邀请%@", model.phones[0]] onLeftTouched:^{
//        
//    } onRightTouched:^(id parameter) {
//        NSNumber *num = (NSNumber *)parameter;
//        HQLog(@"%ld", num.integerValue);
//        
//    }];
//}
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
