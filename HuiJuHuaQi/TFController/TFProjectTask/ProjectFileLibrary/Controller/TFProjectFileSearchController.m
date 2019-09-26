//
//  TFProjectFileSearchController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/31.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFileSearchController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "TFProjectTaskBL.h"
#import "TFProjectFileModel.h"
#import "TFProjectFileListCell.h"
#import "TFProjectFileSubModel.h"
#import "TFFileDetailController.h"

@interface TFProjectFileSearchController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQBLDelegate>


/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *records;


/** UIView *footerView */
@property (nonatomic, strong) UIView *footerView;


/** keyName */
@property (nonatomic, copy) NSString *keyName;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) NSMutableArray *allRecords;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, strong) TFProjectFileSubModel *subModel;

@end

@implementation TFProjectFileSearchController

-(NSMutableArray *)records{
    if (!_records) {
        _records = [NSMutableArray array];
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",CustomerSearchRecord,self.bean]];
        [_records addObjectsFromArray:arr];
    }
    return _records;
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
    
    self.pageNum = 1;
    self.pageSize = 100;
    _allRecords = [NSMutableArray array];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    [self.headerSearch.textField becomeFirstResponder];
    
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
    
    TFProjectFileModel *model = self.allRecords[indexPath.row];
    TFProjectFileListCell *cell = [TFProjectFileListCell projectFileListCellWithTableView:tableView];
    
    [cell refreshProjectFileListCellWithModel:model projectId:self.projectId];
    
    cell.bottomLine.hidden = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFFolderListModel *fileModel = [[TFFolderListModel alloc] init];
    TFProjectFileModel *projectFileModel = self.allRecords[indexPath.row];
    fileModel.employee_name = projectFileModel.employee_name;
    fileModel.create_time = projectFileModel.create_time;
    fileModel.siffix = projectFileModel.suffix;
    fileModel.size = projectFileModel.size;
    fileModel.name = projectFileModel.file_name;
    fileModel.url = projectFileModel.url;
    fileModel.id = projectFileModel.id;
    fileModel.siffix = [fileModel.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
//    fileModel.fileUrl = [NSString stringWithFormat:@"%@%@%@?id=%@&project_id=%@",kServerAddress,ServerAdress,@"/common/file/projectDownload",fileModel.id,self.projectId];
    fileModel.fileUrl = [NSString stringWithFormat:@"%@%@?id=%@&project_id=%@",kServerAddress,@"/common/file/projectDownload",fileModel.id,self.projectId];
    
    if (self.isFileLibraySelect) {
        
        if (self.parameterAction) {
            [self.navigationController popViewControllerAnimated:NO];
            
            self.parameterAction(fileModel);
        }
    }
    
    TFFileDetailController *detailVC = [[TFFileDetailController alloc] init];
    
    if ([fileModel.siffix isEqualToString:@"jpg"] || [fileModel.siffix isEqualToString:@"jpeg"] || [fileModel.siffix isEqualToString:@"png"] || [fileModel.siffix isEqualToString:@"gif"]) {
        
        detailVC.isImg = 1;
    }
    
    detailVC.basics = fileModel;
    detailVC.naviTitle = fileModel.name;
    detailVC.projectId = self.projectId;
    detailVC.whereFrom = 3;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
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
    
    if (self.style == 1) {
        [self.projectTaskBL requestprojectLibrarySearchWithProjectId:self.projectId pageNum:@(self.pageNum) pageSize:@(self.pageSize) keyWord:self.keyWord];
    }else{
        
        [self.projectTaskBL requestprojectLibraryQueryTaskLibraryListWithId:self.dataId type:self.libraryType pageNum:@(self.pageNum) pageSize:@(self.pageSize) keyWord:self.keyWord];
    }
    
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
    
    if (resp.cmdId == HQCMD_projectLibraryQueryTaskLibraryList || resp.cmdId == HQCMD_projectLibraryRootSearch) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view endEditing:YES];
        
        self.subModel = resp.body;
        _allRecords = self.subModel.dataList;
        
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
