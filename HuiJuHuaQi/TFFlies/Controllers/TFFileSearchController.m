//
//  TFFileSearchController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileSearchController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "HQTFTwoLineCell.h"
#import "TFCustomListCell.h"
#import "TFSearchChatItemController.h"
#import "TFHistoryVersionCell.h"
#import "TFOneLevelFolderController.h"
#import "TFFileDetailController.h"

#import "TFFolderListModel.h"

#import "TFFileBL.h"

@interface TFFileSearchController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQTFTwoLineCellDelegate,HQBLDelegate>


/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray *customers;
/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray *totalCustomers;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *records;


/** UIView *footerView */
@property (nonatomic, strong) UIView *footerView;


/** keyName */
@property (nonatomic, copy) NSString *keyName;

/** pageNo */
@property (nonatomic, strong) NSNumber *pageNo;
/** pageSize */
@property (nonatomic, strong) NSNumber *pageSize;

@property (nonatomic, strong) NSMutableArray *chatRecords;

@property (nonatomic, strong) NSMutableArray *allRecords;

@property (nonatomic, strong) TFFileBL *fileBL;

@end

@implementation TFFileSearchController

- (NSMutableArray *)chatRecords {
    
    if (!_chatRecords) {
        
        _chatRecords = [NSMutableArray array];
    }
    return _chatRecords;
}


-(NSMutableArray *)records{
    if (!_records) {
        _records = [NSMutableArray array];
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
        [_records addObjectsFromArray:arr];
    }
    return _records;
}

-(NSMutableArray *)customers{
    if (!_customers) {
        _customers = [NSMutableArray array];
        
    }
    return _customers;
}

-(NSMutableArray *)totalCustomers{
    if (!_totalCustomers) {
        _totalCustomers = [NSMutableArray array];
        
    }
    return _totalCustomers;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:nil action:nil text:@""];
    [self.navigationController.navigationBar addSubview:self.headerSearch];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
    
    _allRecords = [NSMutableArray array];
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    self.keyName = [NSString stringWithFormat:@"%@",self.searchMatch];
    
    [self.headerSearch.textField becomeFirstResponder];
    
    if (self.keyWord && ![self.keyWord isEqualToString:@""]) {
        self.headerSearch.textField.text = self.keyWord;
    }
    
    [self setupSearchPlacehoder];
}

/** 设置搜索框提示文字 */
- (void)setupSearchPlacehoder{
    
    
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
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _allRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TFFolderListModel *model = _allRecords[indexPath.row];
    
    if ([model.sign isEqualToString:@"0"]) {
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.topLabel.text = model.name;
        cell.type = TwoLineCellTypeOne;
        cell.titleImageWidth = 40.0;
        
        if ([model.type isEqualToString:@"0"]) { //公开
            
            [cell.titleImage setImage:IMG(@"文件夹") forState:UIControlStateNormal];
        }
        else { //私有
        
            [cell.titleImage setImage:IMG(@"新建文件夹") forState:UIControlStateNormal];
        }
        
        [cell.titleImage setBackgroundColor:[HQHelper colorWithHexString:model.color]];
        
        cell.bottomLine.hidden = NO;
        
        return cell;
    }
    else {
    
        TFHistoryVersionCell *cell = [TFHistoryVersionCell HistoryVersionCellWithTableView:tableView];
        
        cell.versionLab.hidden = YES;

        
        [cell refreshFileListDataWithModel:model];
        
        cell.moreImgV.hidden = YES;
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFFolderListModel *model = _allRecords[indexPath.row];
    
    
    
//    if ([[model.parent_id stringValue] isEqualToString:@""] || [model.parent_id stringValue] == nil) {
//        
//        
//    }
    
    if ([model.sign isEqualToString:@"0"]) { //文件夹
        
        TFOneLevelFolderController *oneLevel = [[TFOneLevelFolderController alloc] init];
        oneLevel.fileSeries = 1;
        oneLevel.naviTitle = model.name;
        oneLevel.parentId = model.id;
        oneLevel.style = self.style;
        oneLevel.parentUrl = model.url;
        oneLevel.isSearch = YES;
        oneLevel.presentId = model.id;
        
        [self.navigationController pushViewController:oneLevel animated:YES];
    }
    else { //文件
    
        TFFileDetailController *fileDetail = [[TFFileDetailController alloc] init];
        
        fileDetail.fileId = model.id;
        fileDetail.style = self.style;
        fileDetail.naviTitle = model.name;
        [fileDetail.pathArr addObject:model.name];
        
        if ([model.siffix isEqualToString:@".jpg"] ||[model.siffix isEqualToString:@".jpeg"] ||[model.siffix isEqualToString:@".png"] ||[model.siffix isEqualToString:@".gif"] ) {
            
            fileDetail.isImg = 1;
        }
        
        [self.navigationController pushViewController:fileDetail animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 35;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.view.backgroundColor;
    
    UILabel *lab1 = [UILabel initCustom:CGRectZero title:@"相关文件" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
    lab1.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@15);
        make.top.equalTo(@0);
        make.height.equalTo(@35);
        
    }];
    
    NSString *str = [NSString stringWithFormat:@"%ld条",_allRecords.count];
    UILabel *lab2 = [UILabel initCustom:CGRectZero title:str titleColor:kUIColorFromRGB(0xFFFFFF) titleFont:10 bgColor:kUIColorFromRGB(0xFF6260)];
    
    lab2.layer.cornerRadius = 7.0;
    lab2.layer.masksToBounds = YES;
    [view addSubview:lab2];
    
    CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:CGSizeMake(SCREEN_WIDTH-80, 15) titleStr:str];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(lab1.mas_right).offset(10);
        make.centerY.equalTo(lab1.mas_centerY);
        make.width.equalTo(@(size.width+6));
        make.height.equalTo(@15);
        
    }];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)setupNavi{
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = self.keyWord;
}


- (void)searchHeaderTextChange:(UITextField *)textField{
    
    if (textField.text.length <= 0) {
        
        self.tableView.tableFooterView = self.footerView;
        self.tableView.backgroundView = [UIView new];
        
        [self.tableView reloadData];
    }
    self.keyWord = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        return YES;
    }
    
    [self.records removeAllObjects];
    self.keyWord = textField.text;
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [self.records addObjectsFromArray:arr];
    
    for (NSString *str in self.records) {
        
        if ([self.keyWord isEqualToString:str]) {
            
            [self.records removeObject:str];
            break;
        }
        
    }
    
    [self.records insertObject:textField.text atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.records forKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [textField resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.fileBL requestBlurSearchFileWithData:@(self.style) content:self.keyWord fileId:self.fileId];

    
    return YES;
}


-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"没有找到相关信息"];
    }
    return _noContentView;
}



#pragma mark - searchHeader Deleaget

-(void)searchHeaderCancelClicked{
    
    [self.view endEditing:YES];
    [self.headerSearch removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_blurSearchFile) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view endEditing:YES];
        
        _allRecords = resp.body;
        
        if (_allRecords.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
