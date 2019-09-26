//
//  TFNoteSearchController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteSearchController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "HQTFTwoLineCell.h"
#import "TFCustomListCell.h"
#import "TFSearchChatItemController.h"
#import "TFSingleTextCell.h"
#import "HQTFLabelCell.h"

#import "TFNoteBL.h"
#import "TFCustomBL.h"

@interface TFNoteSearchController ()<HQTFSearchHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQTFTwoLineCellDelegate,HQBLDelegate>


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

@property (nonatomic, strong) NSMutableArray *allRecords;

@property (nonatomic, strong) TFNoteBL *noteBL;

@property (nonatomic, strong) TFCustomBL *customBL;

@end

@implementation TFNoteSearchController


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
    
    self.noteBL = [TFNoteBL build];
    self.noteBL.delegate = self;
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    _allRecords = [NSMutableArray array];
    
    self.keyName = [NSString stringWithFormat:@"%@",self.searchMatch];
    
    [self.headerSearch.textField becomeFirstResponder];
    
    if (self.keyWord && ![self.keyWord isEqualToString:@""]) {
        self.headerSearch.textField.text = self.keyWord;
    }
    
    [self.noteBL requestGetFirstFieldFromModuleWithDict:nil bean:self.bean];
//    [self.customBL requsetCustomListWithBean:self.bean queryWhere:@{} menuId:nil pageNo:@1 pageSize:@10 seasPoolId:nil fuzzyMatching:@""];
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
    
    
    static NSString *identify=@"MySetCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    else
    {
        for(UIView *vv in cell.subviews)
        {
            [vv removeFromSuperview];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    NSMutableDictionary *dic = self.allRecords[indexPath.row];
    
    NSString *title = @"";
    NSArray *rows = [dic valueForKey:@"row"];
    
    if (rows.count > 0) {
        
        NSDictionary *dic2 =rows[0];
        
        TFFieldNameModel *model = [[TFFieldNameModel alloc] init];
        model.label = [dic2 valueForKey:@"label"];
        model.name = [dic2 valueForKey:@"name"];
        model.value = [dic2 valueForKey:@"value"];
        NSString *valueStr = [HQHelper stringWithFieldNameModel:model];
        
        if ([valueStr isEqualToString:@""]) {
            
            title = @"未知名称的数据";
        }
        else {
            
            title = valueStr;
        }

    }
    
    
    UILabel *lable = [UILabel initCustom:CGRectMake(20, 20, SCREEN_WIDTH-20-128, 20) title:title titleColor:kUIColorFromRGB(0x909090) titleFont:14 bgColor:ClearColor];
    lable.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:lable];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH-20-20, 20, 20, 20);
    [button setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    [cell addSubview:button];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=kUIColorFromRGB(0xFFFFFF);
    
    UILabel *line = [UILabel initCustom:CGRectMake(15, 60, SCREEN_WIDTH, 0.5) title:@"" titleColor:kUIColorFromRGB(0xFFFFFF) titleFont:10 bgColor:ClearColor];
    line.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    [cell addSubview:line];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    NSMutableDictionary *dic = self.allRecords[indexPath.row];
    
    NSArray *rows = [dic valueForKey:@"row"];
    NSDictionary *personDic = [NSDictionary dictionary];
    for (NSDictionary *di in rows) {
        
        if ([[di valueForKey:@"name"] isEqualToString:@"personnel_principal"]) {
            
            NSArray *values = [HQHelper dictionaryWithJsonString:[di valueForKey:@"value"]];
            
            if (values.count > 0) {
                
                personDic = values[0];

            }
            
        }
    }
    
    if (self.refresh) {
        
        [self.navigationController popViewControllerAnimated:NO];
        
        NSDictionary *dict = [NSDictionary dictionary];
        
        NSString *str = @"";
        
        NSArray *rows = [dic valueForKey:@"row"];
        
        if (rows.count > 0) {
            
            NSDictionary *dic2 =rows[0];
            
            TFFieldNameModel *model = [[TFFieldNameModel alloc] init];
            model.label = [dic2 valueForKey:@"label"];
            model.name = [dic2 valueForKey:@"name"];
            model.value = [dic2 valueForKey:@"value"];
            NSString *valueStr = [HQHelper stringWithFieldNameModel:model];
            
            if ([valueStr isEqualToString:@""]) {
                
                str = @"未知名称的数据";
            }
            else {
                
                str = valueStr;
            }
            
        }
        
        NSDictionary *dic3 = [dic valueForKey:@"id"];
//        NSString *rel = [NSString stringWithFormat:@"%@-%@",self.name,str];
        NSMutableArray *mArr = [NSMutableArray array];
        [mArr addObject:personDic];
        dict = @{
                 @"ids":[dic3 valueForKey:@"value"],
                 @"module_name":self.name,
                 @"title":str,
                 @"bean":self.bean,
                 @"icon_url":self.icon_url?:@"",
                 @"icon_color":self.icon_color?:@"",
                 @"icon_type":self.icon_type?:@"",
                 @"row":mArr
                 };
        
        
        
        self.refresh(dict);
    }

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
        [self.noteBL requestGetFirstFieldFromModuleWithDict:nil bean:self.bean];
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
    
    
    [self.noteBL requestGetFirstFieldFromModuleWithDict:self.keyWord bean:self.bean];
    
    
    return YES;
}


-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"没有找到相关信息~"];
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
    
    if (resp.cmdId == HQCMD_getFirstFieldFromModule) {
        
        _allRecords = resp.body;
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
