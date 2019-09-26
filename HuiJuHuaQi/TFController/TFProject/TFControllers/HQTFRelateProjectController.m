//
//  HQTFRelateProjectController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRelateProjectController.h"
#import "HQTFSearchHeader.h"
#import "HQCustomerModel.h"
#import "HQTFRelateCell.h"

@interface HQTFRelateProjectController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate>


/**  tableView */
@property (nonatomic, weak) UITableView *tableView;
/**  headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/**  header */
@property (nonatomic, strong) HQTFSearchHeader *header;
/**  headerView */
@property (nonatomic, strong) UIView *headerView;

/** 全部数据（未分组） */
@property (nonatomic, strong) NSMutableArray *allDatas;


@end

@implementation HQTFRelateProjectController
-(NSMutableArray *)allDatas{
    
    if (!_allDatas) {
        _allDatas = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 20; i ++) {
            
            HQCustomerModel *model = [[HQCustomerModel alloc] init];
            model.customerTitle = [NSString stringWithFormat:@"我是第%ld个项目",i];
            model.time = @"2017-01-01";
            [_allDatas addObject:model];
        }
        
    }
    return _allDatas;
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
    
    self.navigationItem.title = @"关联项目";
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
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        for (HQCustomerModel *contact in self.allDatas) {
            
            
        }
        
        [self.tableView reloadData];
    }
}



#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.allDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQTFRelateCell *cell = [HQTFRelateCell relateCellWithTableView:tableView];
    HQCustomerModel *model = self.allDatas[indexPath.row];
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
