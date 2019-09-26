//
//  TFGroupATPeopleController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/1.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFGroupATPeopleController.h"
#import "HQTFTwoLineCell.h"
#import "HQEmployModel.h"
#import "TFChatPeopleInfoController.h"
#import "TFPersonalMaterialController.h"

#import "TFGroupEmployeeModel.h"
#import "TFGroupInfoModel.h"

#import "TFChatBL.h"
#import "ChineseString.h"
#import "HQTFSearchHeader.h"

@interface TFGroupATPeopleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFSearchHeaderDelegate,UITextFieldDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFGroupInfoModel *infoModel;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *searchSections;
@property (nonatomic, strong) NSMutableArray *searchTitles;
/** 搜索数据(就是当前显示的) */
@property (nonatomic, strong) NSMutableArray * searchEmoploys;

@property (nonatomic, strong) NSMutableArray * selectPeoples;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** headerView */
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, copy) NSString *word;
@end

@implementation TFGroupATPeopleController
- (NSMutableArray *)searchSections {
    
    if (!_searchSections) {
        _searchSections = [NSMutableArray array];
    }
    return _searchSections;
}
- (NSMutableArray *)selectPeoples {
    
    if (!_selectPeoples) {
        _selectPeoples = [NSMutableArray array];
    }
    return _selectPeoples;
}
- (NSMutableArray *)searchTitles {
    
    if (!_searchTitles) {
        _searchTitles = [NSMutableArray array];
    }
    return _searchTitles;
}
-(NSMutableArray *)searchEmoploys{
    if (!_searchEmoploys) {
        _searchEmoploys = [NSMutableArray array];
    }
    return _searchEmoploys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
    
    [self setupHeaderSearch];
    self.chatBL = [TFChatBL build];
    
    self.chatBL.delegate = self;
    [self.chatBL requestGetGroupInfoWithData:self.groupId];
    
}
- (void)setupNavi{
    
    self.navigationItem.title = @"选择提醒人";
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    
//    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
//    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
//    self.header = header;
//    header.backgroundColor = WhiteColor;
//    header.button.backgroundColor = BackGroudColor;
//    header.delegate = self;
//
//    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44 + 70}];
//
//    [headerView addSubview:header];
//    headerView.backgroundColor = HexAColor(0xe7e7e7, 1);
//    self.headerView = headerView;
//    self.tableView.tableHeaderView = headerView;
//    self.headerView.frame = (CGRect){0,0,SCREEN_WIDTH,44};
//
//
//
//    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
//    self.headerSearch = headerSearch;
//    headerSearch.type = SearchHeaderTypeNormal;
//    headerSearch.backgroundColor = WhiteColor;
//    headerSearch.button.backgroundColor = BackGroudColor;
//    headerSearch.delegate = self;
    
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

#pragma mark ---搜索代理方法
-(void)searchHeaderClicked{

    self.headerSearch.type = SearchHeaderTypeSearch;
    [self.headerSearch.textField becomeFirstResponder];
//    self.headerSearch.frame = CGRectMake(0, 24, SCREEN_WIDTH, 64);
//    [self.navigationController.navigationBar addSubview:self.headerSearch];
//    [UIView animateWithDuration:0.25 animations:^{
//
//        self.headerSearch.y = -20;
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    }completion:^(BOOL finished) {
//
//        self.tableView.tableHeaderView = nil;
//
//        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//        self.tableView.contentOffset = CGPointMake(0, -44);
//    }];
    
}


-(void)searchHeaderCancelClicked{
    
    self.header.type = SearchHeaderTypeNormal;
    self.headerSearch.type = SearchHeaderTypeNormal;
    self.headerSearch.backgroundColor = WhiteColor;
    self.headerSearch.button.backgroundColor = BackGroudColor;
    self.header.backgroundColor = WhiteColor;
    self.header.button.backgroundColor = BackGroudColor;
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
    
    [self textFieldContentChange:nil];
    
}


-(void)searchHeaderTextChange:(UITextField *)textField{
    
    [self textFieldContentChange:textField];
}

#pragma mark - 监听TextFiled输入内容
- (void)textFieldContentChange:(UITextField *)textField
{
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        NSMutableArray *array = [NSMutableArray array];
        HQLog(@"textField.text == %@",textField.text);
        if ([textField.text isEqualToString:@""] || textField.text == nil) {
            
            [self textFieldChangeOfAddContact:textField array:self.memberArr];
        }
        else {
            
            for (TFGroupEmployeeModel *model in self.memberArr) {
                
                if ([model.employee_name containsString:textField.text]) {
                    
                    [array addObject:model];
                }
            }
            
            [self textFieldChangeOfAddContact:textField array:array];
        }
        
    }
}

#pragma mark - UITableViewDelegate - UITableViewDataSource
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return  self.searchSections;
}

- (void)textFieldChangeOfAddContact:(UITextField *)textField array:(NSMutableArray *)array;
{
    
    NSMutableArray * nameMutArr  = [[NSMutableArray alloc] init];     //用于存加入标识（下标）后的名字
    
    NSMutableArray *beginEmployArr = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        for (TFGroupEmployeeModel *contactsModel in array) {
            
            //只要搜索框里的字被包含，或搜索框里无字时，保存
            if ([TEXT(contactsModel.employee_name) rangeOfString:TEXT(textField.text)].length > 0  ||  textField.text.length == 0) {
                
                NSString *nameIdStr = [NSString stringWithFormat:@"%@HJHQID%d", TEXT(contactsModel.employee_name), i];
                
                [nameMutArr addObject:nameIdStr];
                
                [beginEmployArr addObject:contactsModel];
                
                i++;
            }
        }
        
        self.searchSections = [ChineseString IndexArray:nameMutArr];
        self.searchTitles = [ChineseString LetterSortArray:nameMutArr];
        
        if (self.searchSections.count) {
            
            if ([self.searchSections[0] isEqualToString:@"#"]) {// 将#放到最后
                
                id obj1 = self.searchSections[0];
                id obj2 = self.searchTitles[0];
                
                [self.searchSections removeObjectAtIndex:0];
                [self.searchTitles removeObjectAtIndex:0];
                [self.searchSections insertObject:obj1 atIndex:self.searchSections.count];
                [self.searchTitles insertObject:obj2 atIndex:self.searchTitles.count];
            }
        }
        
        NSMutableArray *modelMutArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<self.searchTitles.count; i++) {
            
            NSArray *arr = self.searchTitles[i];
            
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
        
        self.searchEmoploys = modelMutArr;
 
        self.word = textField.text;
        [self.tableView reloadData];
    }
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //索引栏颜色
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //索引栏文字颜色
    tableView.sectionIndexColor = ExtraLightBlackTextColor;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.searchEmoploys.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    else {
        NSArray *arr = self.searchEmoploys[section-1];
        
        return  arr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        
        cell.topLabel.text = [NSString stringWithFormat:@"所有人（%ld）  ",self.memberArr.count];
        cell.bottomLine.hidden = NO;
        cell.enterImage.userInteractionEnabled = NO;
        [cell.titleImage setImage:IMG(@"群组45") forState:UIControlStateNormal];
        [cell.titleImage setTitleColor:nil forState:UIControlStateNormal];
        [cell.titleImage setBackgroundColor:nil];
        [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
        
        cell.titleImage.layer.cornerRadius = cell.titleImage.width/2.0;
        cell.titleImage.layer.masksToBounds = YES;
        cell.bottomLine.hidden = YES;
        cell.type = TwoLineCellTypeOne;
    }
    else {
        
        cell.bottomLine.hidden = NO;
        cell.enterImage.userInteractionEnabled = NO;
        
        NSArray *sections = self.searchEmoploys[indexPath.section-1];
        TFGroupEmployeeModel *model = sections[indexPath.row];
        if (![model.picture isEqualToString:@""]) {
            
            [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
            [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
            [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [cell.titleImage setBackgroundColor:HeadBackground];
            [cell.titleImage setImage:nil forState:UIControlStateNormal];
        }
        else {
            
            [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
            [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [cell.titleImage setBackgroundColor:HeadBackground];
            [cell.titleImage setImage:nil forState:UIControlStateNormal];
        }
        
        
        cell.titleImage.layer.cornerRadius = cell.titleImage.width/2.0;
        cell.titleImage.layer.masksToBounds = YES;
        
        cell.topLabel.text = model.employee_name;

        cell.type = TwoLineCellTypeOne;
        
        if (sections.count -1 == indexPath.row) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    if (indexPath.section == 0) {
        
        TFGroupEmployeeModel *em = [[TFGroupEmployeeModel alloc] init];
        em.employee_name = @"所有人  ";
        em.picture = @"";
        em.sign_id = @0;
        
        [self.selectPeoples addObject:em];
        if (self.actionParameter) {
            self.actionParameter(self.selectPeoples);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        
        NSArray *sections = self.searchEmoploys[indexPath.section-1];
        TFGroupEmployeeModel *model = sections[indexPath.row];
        
        [self.selectPeoples addObject:model];
        if (self.actionParameter) {
            self.actionParameter(self.selectPeoples);
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    [self.tableView reloadData];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        
        return 0;
    }
    return 30;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section>0) {
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = BackGroudColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
        label.backgroundColor = HexAColor(0xf2f2f2, 1);
        label.font = [UIFont systemFontOfSize:14.0];
        NSString *sectionStr = [self.searchSections objectAtIndex:section-1];
        [label setText:sectionStr];
        [contentView addSubview:label];
        return contentView;
    }
    return nil;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getGroupInfo) {
        
        self.infoModel = resp.body;
        
        self.memberArr = [NSMutableArray array];
        
//        TFGroupEmployeeModel *em = [[TFGroupEmployeeModel alloc] init];
//        em.employee_name = @"所有人  ";
//        em.picture = @"";
//        em.sign_id = @0;
//        [self.memberArr addObject:em];
        
        for (NSInteger i = 0; i < self.infoModel.employeeInfo.count; i ++) {
            
            TFGroupEmployeeModel *employeeModel = self.infoModel.employeeInfo[i];
            
            //过滤自己
            if (![employeeModel.sign_id isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                
                [self.memberArr addObject:employeeModel];
            }
            
        }
        [self textFieldChangeOfAddContact:self.headerSearch.textField array:self.memberArr];
        
        [self.tableView reloadData];
    }
    
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
