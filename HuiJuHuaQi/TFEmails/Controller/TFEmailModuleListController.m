//
//  TFEmailModuleListController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailModuleListController.h"
#import "HQTFSearchHeader.h"
#import "HQTFTwoLineCell.h"
#import "TFEmailModuleContactsController.h"

#import "TFEmailModuleListModel.h"
#import "TFMailBL.h"

@interface TFEmailModuleListController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@property (nonatomic, strong) TFMailBL *mailBL;

@property (nonatomic, strong) NSMutableArray *modules;


@property (nonatomic, copy) NSString *word;

@end

@implementation TFEmailModuleListController

- (NSMutableArray *)modules {

    if (!_modules) {
        
        _modules = [NSMutableArray array];
    }
    return _modules;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"联系人";
    
    [self setupTableView];
    
    [self setupHeaderSearch];
    
    self.mailBL = [TFMailBL build];
    self.mailBL.delegate = self;
    
    [self.mailBL getModuleEmailsDataWithKeyword:nil];
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
    
    [self.mailBL getModuleEmailsDataWithKeyword:textField.text];
    
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
    return self.modules.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFEmailModuleListModel *model = self.modules[indexPath.row];
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    
    cell.type = TwoLineCellTypeOne;
    cell.topLabel.text = model.chinese_name;
    
    [cell.titleImage setImage:IMG(@"组织架构") forState:UIControlStateNormal];
    cell.titleImageWidth = 40.0;
    cell.titleImage.layer.cornerRadius = 20.0;
    
    cell.enterImage.hidden = NO;
    [cell.enterImage setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    if (indexPath.row == self.modules.count - 1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFEmailModuleListModel *model = self.modules[indexPath.row];
    
    TFEmailModuleContactsController *emailContacts = [[TFEmailModuleContactsController alloc] init];
    
    emailContacts.naviTitle = model.chinese_name;
    emailContacts.moduleBean = model.english_name;
    emailContacts.index = self.index;
    
    [self.navigationController pushViewController:emailContacts animated:YES];
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_moduleEmailGetModuleEmails) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.modules = resp.body;
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
