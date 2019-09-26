//
//  TFEmailsContactsController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsContactsController.h"
#import "HQTFSearchHeader.h"
#import "TFPersonalMaterialController.h"
#import "TFChatGroupListController.h"
#import "TFContactsWorkFrameController.h"
#import "HQTFTwoLineCell.h"
#import "TFFilePathView.h"
#import "TFSelectPeopleElementCell.h"

#import "TFEmailsAddressBookController.h"
#import "TFEmailRecentContactsModel.h"
#import "TFEmailModuleListController.h"

#import "TFMailBL.h"

@interface TFEmailsContactsController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQTFTwoLineCellDelegate,HQBLDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

/** 常用联系人 */
@property (nonatomic, strong) NSMutableArray *conmmonlyContacts;

@property (nonatomic, strong) TFMailBL *mailBL;

@property (nonatomic, strong) NSMutableArray *selectPersons;

@property (nonatomic, copy) NSString *word;
@end

@implementation TFEmailsContactsController

- (NSMutableArray *)conmmonlyContacts {
    
    if (!_conmmonlyContacts) {
        
        _conmmonlyContacts = [NSMutableArray array];
    }
    return _conmmonlyContacts;
}

- (NSMutableArray *)selectPersons {
    
    if (!_selectPersons) {
        
        _selectPersons = [NSMutableArray array];
    }
    return _selectPersons;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    [self setupHeaderSearch];
    
    self.mailBL = [TFMailBL build];
    self.mailBL.delegate  =self;
    //获取最近联系人
    [self.mailBL getMailContactQueryListWithKeyword:nil];
}

- (void)setNavi {

    self.navigationItem.title = @"联系人";
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
    
    [self.mailBL getMailContactQueryListWithKeyword:textField.text];
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
    tableView.showsVerticalScrollIndicator = NO;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.headerSearch.textField resignFirstResponder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 2;
    }
    
    return self.conmmonlyContacts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeOne;
        
        
        if (indexPath.row == 0) {
            
            cell.topLabel.text = @"从模块中选择";
            [cell.titleImage setImage:[UIImage imageNamed:@"邮件模块"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"邮件模块"] forState:UIControlStateHighlighted];
        }else if (indexPath.row == 1){
            
            cell.topLabel.text = @"从通讯录中选择";
            
            [cell.titleImage setImage:[UIImage imageNamed:@"邮件通讯录"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"邮件通讯录"] forState:UIControlStateHighlighted];
        }
        
        [cell.enterImage setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
        
        cell.bottomLine.hidden = NO;
        
        return cell;
        
    }
    
    else {
        
        TFEmailRecentContactsModel *model = self.conmmonlyContacts[indexPath.row];
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        
        cell.delegate = self;
        if (model.employee_name && ![model.employee_name isEqualToString:@""] && model.mail_account && ![model.mail_account isEqualToString:@""]) {
            
            cell.type = TwoLineCellTypeTwo;
            cell.topLabel.text = model.employee_name;
            cell.bottomLabel.text = model.mail_account;
            cell.topLabel.textColor = BlackTextColor;
            cell.bottomLabel.textColor = GrayTextColor;
            cell.topLabel.font = FONT(14);
            
        }else if (model.employee_name && ![model.employee_name isEqualToString:@""]){
            
            cell.type = TwoLineCellTypeOne;
            cell.topLabel.text = model.employee_name;
            cell.topLabel.textColor = BlackTextColor;
            cell.bottomLabel.textColor = GrayTextColor;
            cell.topLabel.font = FONT(14);
            
        }else if (model.mail_account && ![model.mail_account isEqualToString:@""]){
            cell.type = TwoLineCellTypeOne;
            cell.topLabel.text = model.mail_account;
            cell.topLabel.textColor = GrayTextColor;
            cell.bottomLabel.textColor = GrayTextColor;
            cell.topLabel.font = FONT(12);
        }
        
        if (!model.select || [model.select isEqualToNumber:@0]) {
            
            [cell.titleImage setImage:IMG(@"没选中") forState:UIControlStateNormal];
            [cell.titleImage setImage:IMG(@"没选中") forState:UIControlStateHighlighted];
            
        }else{
            
            [cell.titleImage setImage:IMG(@"选中了") forState:UIControlStateNormal];
            [cell.titleImage setImage:IMG(@"选中了") forState:UIControlStateHighlighted];
        }
        
        
        cell.titleImage.tag = indexPath.row;
        cell.titleImageWidth = 30.0;
        
        cell.bottomLine.hidden = NO;
        
        return cell;
    }
    
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TFEmailModuleListController *moduleList = [[TFEmailModuleListController alloc] init];
            
            moduleList.index = self.index;
            
            [self.navigationController pushViewController:moduleList animated:YES];
            
        }
        else if (indexPath.row == 1) {
            
            
            TFEmailsAddressBookController *addressBookVC = [[TFEmailsAddressBookController alloc] init];
            
            addressBookVC.index = self.index;
            
            [self.navigationController pushViewController:addressBookVC animated:YES];
            
            
        }

    }else{
        
        TFEmailRecentContactsModel *model = self.conmmonlyContacts[indexPath.row];
        
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 35;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *lab = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 35) title:@"   最近联系人" titleColor:ExtraLightBlackTextColor titleFont:14 bgColor:ClearColor];
    lab.textAlignment = NSTextAlignmentLeft;
    
    return lab;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark sureAction
- (void)sureAction {

    if (self.selectPersons.count > 0) {
        
        if (self.actionParameter) {
            
            self.actionParameter(self.selectPersons);
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

#pragma mark ---

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return @"删除";
    }
    else {
        
        return @"";;
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        
        return UITableViewCellEditingStyleDelete;
    }
    else {
        
        return UITableViewCellEditingStyleNone;
    }
    
    
}
//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLog(@"Action - tableView");
    
    if (indexPath.section == 1) {
        
    }
    
    
}

#pragma mark HQTFTwoLineCellDelegate
- (void)twoLineCell:(HQTFTwoLineCell *)cell titleImage:(UIButton *)photoBtn {
    
    
    TFEmailRecentContactsModel *model = self.conmmonlyContacts[photoBtn.tag];
    
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
    
    if (resp.cmdId == HQCMD_mailContactQueryList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.conmmonlyContacts = resp.body;
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
