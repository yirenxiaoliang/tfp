//
//  TFNoteListController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteListController.h"
#import "HQTFSearchHeader.h"
#import "TFNoteListCell.h"
#import "TFNoteMainListCell.h"
#import "TFNoteDataListModel.h"
#import "TFCreateNoteController.h"

#import "TFNoteTwoBtnBottomView.h"
#import "TFNoteListBottomView.h"
#import "HQTFNoContentView.h"

#import "TFNoteMainListModel.h"
#import "AlertView.h"
#import "TFNoteLeftView.h"
#import "TFRefresh.h"

#import "TFNoteBL.h"

@interface TFNoteListController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate,TFNoteListCellDelegate,TFNoteTwoBtnBottomViewDelegate,TFNoteListBottomViewDelegate,TFNoteLeftViewDelegate,HQTFNoContentViewDelegate,TFSliderCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@property (nonatomic, strong) TFNoteBL *noteBL;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) TFNoteMainListModel *mainModel;

/** 底部视图 */
@property (nonatomic, strong) TFNoteTwoBtnBottomView *twoBtnView;

/** 编辑模式下底部视图 */
@property (nonatomic, strong) TFNoteListBottomView *listBottomView;

@property (nonatomic, strong) TFNoteLeftView *noteLeftView;

/** 是否是编辑模式 */
@property (nonatomic, assign) BOOL edit;

/** 选中索引 */
@property (nonatomic, assign) NSInteger index;

/** 备忘菜单 0:全部 1:我创建的 2:共享给我 3:已删除 */
@property (nonatomic, assign) NSInteger noteType;

/** 选中的备忘 */
@property (nonatomic, strong) NSMutableArray *selectArr;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** headerView */
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, assign) BOOL isSureDel;

@property (nonatomic, strong) NSMutableArray *datas;

/** 滑动索引 */
@property (nonatomic, assign) NSInteger sliderIndex;

@end

@implementation TFNoteListController

- (TFNoteTwoBtnBottomView *)twoBtnView {

    if (!_twoBtnView) {
        
        _twoBtnView = [TFNoteTwoBtnBottomView noteTwoBtnBottomView];
        self.twoBtnView.frame = CGRectMake(0, SCREEN_HEIGHT-64-49, SCREEN_WIDTH, 49);
    }
    return _twoBtnView;
}

- (TFNoteListBottomView *)listBottomView {
    
    if (!_listBottomView) {
        
        _listBottomView = [TFNoteListBottomView noteListBottomView];
        
        self.listBottomView.frame = CGRectMake(0, SCREEN_HEIGHT-64-49, SCREEN_WIDTH, 49);
    }
    return _listBottomView;
}

- (TFNoteMainListModel *)mainModel {

    if (!_mainModel) {
        
        _mainModel = [[TFNoteMainListModel alloc] init];
    }
    return _mainModel;
}

- (NSMutableArray *)selectArr {

    if (!_selectArr) {
        
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)datas {
    
    if (!_datas) {
        
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        _noContentView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
//        [_noContentView setupImageViewRect:(CGRect){30,98,SCREEN_WIDTH - 60,Long(150)} imgImage:@"备忘录缺省" withTipWord:@"您还没有添加备忘录"];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"备忘录缺省" buttonImage:@"" buttonWord:@"现在就写备忘" withTipWord:@"您还没有添加备忘录"];
        _noContentView.delegate = self;
    }
    return _noContentView;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnAction) image:@"备忘录返回黑" highlightImage:@"备忘录返回黑"];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    if (self.headerSearch.type == SearchHeaderTypeMove) {
        
        [self.headerSearch removeFromSuperview];
        [self searchHeaderCancelClicked];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enablePanGesture = NO;
    
    [self setNavi];
    
    [self setupTableView];
    
    [self setupHeaderSearch];
    
    [self setupFilterView];
    
    [self createBottomView];
    
    [self initData];
    
    [self requestData];
    
}

- (void)initData {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.pageNum = 1;
    
    self.pageSize = 10;
    
    self.edit = NO;
    
    self.noteType = 0;
    
    self.noteBL = [TFNoteBL build];
    self.noteBL.delegate = self;
}

- (void)requestData {

    [self.noteBL requestGetNoteListWithPageNum:self.pageNum pageSize:self.pageSize type:self.noteType keyword:self.noteTitle];
}

- (void)setNavi {

    self.navigationItem.title = @"备忘录（全部）";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(editNoteAction) text:@"编辑" textColor:kUIColorFromRGB(0x909090)];
    
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{

    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    self.header = header;
    header.delegate = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44 + 70}];
    
    [headerView addSubview:header];
    headerView.backgroundColor = HexAColor(0xe7e7e7, 1);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    self.headerView.frame = (CGRect){0,0,SCREEN_WIDTH,44};
    
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeNormal;
    headerSearch.delegate = self;
    
}

#pragma mark ---搜索代理方法
-(void)searchHeaderClicked{
    
    for (TFNoteMainListCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
    }
    
    self.listBottomView.hidden = YES;
    self.twoBtnView.hidden = YES;
    
    self.isSearch = YES;
    
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
    
    self.listBottomView.hidden = NO;
    self.twoBtnView.hidden = NO;
    
    self.isSearch = NO;
    
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
        
        self.pageNum = 1;
        self.noteTitle = textField.text;
        [self requestData];
        
    }
}

#pragma mark ---左侧导航
- (void)setupFilterView{
    
    self.noteLeftView = [[TFNoteLeftView alloc] initWithFrame:(CGRect){-SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT} unreads:nil];
    self.noteLeftView.tag = 0x1234554321;
    self.noteLeftView.delegate = self;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-49-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
        self.pageNum = 1;
        [self requestData];
        
    }];
    tableView.mj_header = header;
    
    
    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
        
        self.pageNum ++;
        [self requestData];
        
    }];
    tableView.mj_footer = footer;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFNoteDataListModel *model = self.datas[indexPath.row];
    
//    TFNoteListCell *cell = [TFNoteListCell noteListCellWithTableView:tableView];
    
    TFNoteMainListCell *cell = [TFNoteMainListCell noteMainListCellWithTableView:tableView];
    
    cell.delegate = self;
    cell.listView.delegate = self;
    if (self.edit) {
        
        cell.listView.isEdit = YES;
        cell.scrollView.scrollEnabled = NO;
        if ([model.isSelect isEqualToNumber:@1]) {
            
            [cell.listView.selectBtn setImage:IMG(@"备忘录选择") forState:UIControlStateNormal];
        }
        else {
        
            [cell.listView.selectBtn setImage:IMG(@"备忘录未选中") forState:UIControlStateNormal];
        }
        
    }
    else {
        
        cell.scrollView.scrollEnabled = YES;
        cell.listView.isEdit = NO;
    }
    
    model.index = @(indexPath.row);
    
    [cell.listView refreshNoteListCellWithModel:model];
    
    cell.bottomLine.hidden = NO;
    
    
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if (self.noteType == 0) {
        
        if ([model.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) {

            TFSliderItem *item = [[TFSliderItem alloc] init];
                
            item.bgColor = kUIColorFromRGB(0xFE3B31);
            item.name = @"删除";
            item.confirm = 0;
            
            [arr addObject:item];
            
        }
        else {
            
            TFSliderItem *item = [[TFSliderItem alloc] init];
            
            item.bgColor = kUIColorFromRGB(0xCCCCCF);
            item.name = @"退出共享";
            item.confirm = 0;
            
            [arr addObject:item];
        }
        
    }
    else if (self.noteType == 1) {
        
        TFSliderItem *item = [[TFSliderItem alloc] init];
        
        item.bgColor = kUIColorFromRGB(0xFE3B31);
        item.name = @"删除";
        item.confirm = 0;
        
        [arr addObject:item];
    }
    else if (self.noteType == 2) {
        
        TFSliderItem *item = [[TFSliderItem alloc] init];
        
        item.bgColor = kUIColorFromRGB(0xCCCCCF);
        item.name = @"退出共享";
        item.confirm = 0;
        
        [arr addObject:item];
    }
    else {
        
        for (NSInteger i = 0; i < 2; i ++) {
            TFSliderItem *item = [[TFSliderItem alloc] init];
            if (1 == i) {
                
                item.bgColor = kUIColorFromRGB(0xFE3B31);
                item.name = @"删除";
                item.confirm = 1;
            }else {
                
                item.bgColor = kUIColorFromRGB(0x3689E9);
                item.name = @"恢复备忘";
                item.confirm = 0;
            }
            [arr addObject:item];
        }
    
    
    }
    
    
    cell.indexPath = indexPath;
    [cell refreshSliderCellItemsWithItems:arr];
    
    [cell hiddenItem];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (TFNoteMainListCell *cell in self.tableView.visibleCells) {
        [cell hiddenItem];
    }
}

#pragma mark - TFSliderCellDelegate
-(void)sliderCellDidClickedIndex:(NSInteger)index{
    
    HQLog(@"点击了%ldItem",index);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    TFNoteDataListModel *model = self.datas[self.sliderIndex];
    
    NSInteger type;
    if (self.noteType == 0) {
        
        if ([model.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) {
            
            type = 1;
            
            
        }
        else {
            
            type = 4;
        }
        
    }
    else if (self.noteType == 1) {
        
        type = 1;
    }
    else if (self.noteType == 2) {
        
        type = 4;
    }
    else {
        
        if (index==1) {
            
            type = 2;
        }else {
            
            type = 3;
        }
        
        
        
    }

    for (TFNoteMainListCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
    }
    
    [self.noteBL requestDeleteNoteWithDict:[NSString stringWithFormat:@"%@",model.id] type:type];
    
}

-(void)sliderCellSelectedIndexPath:(NSIndexPath *)indexPath{
    
    for (TFNoteMainListCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
    }
    
    TFNoteDataListModel *model = self.datas[indexPath.row];
    
    TFCreateNoteController *createVC = [[TFCreateNoteController alloc] init];
    
    createVC.type = 1;
    createVC.noteId = model.id;
    
    createVC.refreshAction = ^{
        
        self.pageNum = 1;
        [self requestData];
    };
    
    [self.navigationController pushViewController:createVC animated:YES];
    
    HQLog(@"点击了%@IndexPath",indexPath);
}

-(void)sliderCellWillScrollIndexPath:(NSIndexPath *)indexPath{
    
    self.sliderIndex = indexPath.row;
    HQLog(@"滑动了%ldIndexPath",indexPath.row);
    for (TFNoteMainListCell *cell in self.tableView.visibleCells) {
        
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        
        if (!(indexPath.section == index.section && indexPath.row == index.row)) {
            
            [cell hiddenItem];
        }
    }
}


#pragma mark -- 创建底部视图
//底部视图
- (void)createBottomView {

    if (self.edit) { //编辑模式
        
        self.listBottomView.delegate = self;
            
        [self.listBottomView refreshNoteListBottomViewWithType:self.noteType count:0];
        
        [self.view addSubview:self.listBottomView];
    }
    else {
    
        self.twoBtnView.delegate = self;
        
        [self.twoBtnView refreshNoteTwoBtnBottomViewWithType:[self.mainModel.pageInfo.totalRows integerValue]];
        
        [self.view addSubview:self.twoBtnView];
    }
    
}

#pragma mark 编辑
- (void)editNoteAction {

    BOOL slider = NO;
    for (TFNoteMainListCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
        if (cell.isSlider) {
            slider = YES;
            break;
        }
    }
    if (slider) {
        return;
    }
    
    //全部的不能编辑
    if (self.noteType != 0) {
        
        if (self.edit) {
            
            self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
            
            self.edit = NO;
            
            for (TFNoteDataListModel *model in self.datas) {
                
                model.isSelect = 0;
            }
            
            [self.selectArr removeAllObjects];
            
            self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnAction) image:@"备忘录返回黑" highlightImage:@"备忘录返回黑"];
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(editNoteAction) text:@"编辑" textColor:kUIColorFromRGB(0x3689E9)];
        }
        else {
            
            [self.selectArr removeAllObjects];
            
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.headerSearch.hidden = NO;
            
            self.edit = YES;
            self.navigationItem.leftBarButtonItem = [self itemWithTarget:nil action:nil image:@"" highlightImage:@""];
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(editNoteAction) text:@"取消" textColor:kUIColorFromRGB(0x323232)];
        }
        
        [self.tableView reloadData];
        
        [self createBottomView];
    }
    
}

#pragma mark 返回
- (void)returnAction {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---TFNoteListBottomViewDelegate
/** 删除全部、彻底删除、退出共享 */
- (void)oneButtonClicked {
    
    NSMutableArray *selectArr = [NSMutableArray array];
    NSString *ids = @"";
    //遍历所选中的备忘录
    for (TFNoteDataListModel *model in self.datas) {
        
        if ([model.isSelect isEqualToNumber:@1]) { //选中的
            
            [selectArr addObject:model];
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
        }
    }
    
    
    
    if (selectArr.count == 0) {
        
        [MBProgressHUD showError:@"请选择备忘录！" toView:self.view];
        
        return;
    }
    
    ids = [ids substringFromIndex:1];
    
    if (self.noteType == 3) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确认彻底删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else {
    
        
        
        if (self.noteType == 1) { //我创建的（删除选中）
            
             [self.noteBL requestDeleteNoteWithDict:ids type:1];
        }
        else if (self.noteType == 2) { //共享给我（退出共享）
            
            [self.noteBL requestDeleteNoteWithDict:ids type:4];
            
        }
        
        
    }
    
    
}

/** 恢复备忘 */
- (void)twoButtonClicked {

    NSMutableArray *selectArr = [NSMutableArray array];
    
    NSString *ids = @"";
    //遍历所选中的备忘录
    for (TFNoteDataListModel *model in self.datas) {
        
        if ([model.isSelect isEqualToNumber:@1]) { //选中的
            
            [selectArr addObject:model];
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
        }
    }
    
    
    
    if (selectArr.count == 0) {
        
        [MBProgressHUD showError:@"请选择备忘录！" toView:self.view];
        
        return;
    }
    
    ids = [ids substringFromIndex:1];
    
    [self.noteBL requestDeleteNoteWithDict:ids type:3];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) { //确定
        
        NSString *ids = @"";
        //遍历所选中的备忘录
        for (TFNoteDataListModel *model in self.datas) {
            
            if ([model.isSelect isEqualToNumber:@1]) { //选中的
                
                ids = [ids stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
            }
        }
        
        ids = [ids substringFromIndex:1];
        
        //彻底删除
        [self.noteBL requestDeleteNoteWithDict:ids type:2];
    }
    
}

#pragma mark ---TFNoteTwoBtnBottomViewDelegate
//左侧菜单
- (void)bottomViewForLeftMenu {

    for (TFNoteMainListCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
    }
    
    [KeyWindow addSubview:self.noteLeftView];
    
    self.noteLeftView.right = 0;
    [UIView animateWithDuration:0 animations:^{
        
//        self.noteLeftView.backgroundColor = RGBAColor(0, 0, 0, .5);
        
        self.noteLeftView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        self.noteLeftView.layer.shadowOffset = CGSizeMake(3,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.noteLeftView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        self.noteLeftView.right = SCREEN_WIDTH;
    }];
}

//新增备忘录
- (void)newNote {

    for (TFNoteMainListCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
    }
    
    TFCreateNoteController *createVC = [[TFCreateNoteController alloc] init];
    createVC.type = 0;
    createVC.refreshAction = ^{
        
        self.pageNum = 1;
        [self requestData];
    };
    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma mark ---TFNoteListCellDelegate
- (void)selectNoteItemWithIndex:(TFNoteDataListModel *)model1 {

    TFNoteDataListModel *model = self.datas[[model1.index integerValue]];
    
    if ([model.isSelect isEqualToNumber:@1]) {
        
        model.isSelect = @0;
        
        [self.selectArr removeObject:model];
    }
    else {
    
        model.isSelect = @1;
        
        [self.selectArr addObject:model];
    }
    
    [self.listBottomView refreshNoteListBottomViewWithType:self.noteType count:self.selectArr.count];
    
    [self.tableView reloadData];
}

#pragma mark ---TFNoteLeftViewDelegate
-(void)filterViewDidClicked:(BOOL)show{
    
    
    
    [UIView animateWithDuration:0 animations:^{
        
        self.noteLeftView.right = 0;
//        self.noteLeftView.backgroundColor = RGBAColor(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
        [self.noteLeftView removeFromSuperview];
    }];
}

- (void)fileterViewCellDid:(NSInteger)index{
    
    self.pageNum = 1;
    self.pageSize = 10;
    
    NSString *title = @"";
    switch (index) {
        case 0:
        {
            title = @"备忘录（全部）";
            self.noteType = 0;
        }
            break;
            
        case 1:
        {
            title = @"备忘录（创建）";
            self.noteType = 1;
            
        }
            break;
            
        case 2:
        {
            title = @"备忘录（共享）";
            self.noteType = 2;
            
        }
            break;
            
        case 3:
        {
            title = @"备忘录（删除）";
            self.noteType = 3;
            
        }
            break;
            
        default:
            break;
    }
    self.navigationItem.title = title;
    
    if (self.noteType == 0) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(editNoteAction) text:@"编辑" textColor:kUIColorFromRGB(0x909090)];
    }
    else {
    
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(editNoteAction) text:@"编辑" textColor:kUIColorFromRGB(0x3689E9)];
    }
    
    
    [self.noteBL requestGetNoteListWithPageNum:self.pageNum pageSize:self.pageSize type:self.noteType keyword:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark ---HQTFNoContentViewDelegate
- (void)noContentViewDidClickedButton {

    TFCreateNoteController *createVC = [[TFCreateNoteController alloc] init];
    
    createVC.type = 0;
    
    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp {
    
    if (resp.cmdId == HQCMD_getNoteList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.mainModel = resp.body;
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            
            [self.datas removeAllObjects];
            
        }
        
        [self.datas addObjectsFromArray:self.mainModel.dataList];
        
        
        if ([self.mainModel.pageInfo.totalRows integerValue] == self.datas.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        if (self.datas.count == 0) {
            
            
            if (self.isSearch) {
                
                [self.noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"备忘录缺省" withTipWord:@""];
            }
            else {
                
                self.navigationItem.rightBarButtonItem = [self itemWithTarget:nil action:nil text:@"编辑" textColor:kUIColorFromRGB(0x909090)];
            
                if (self.noteType == 2 || self.noteType == 3) {
                    
                    [self.noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"备忘录缺省" withTipWord:@""];
                }
                else {

                        
                    [self.noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"备忘录缺省" buttonImage:@"" buttonWord:@"现在就写备忘" withTipWord:@"您还没有添加备忘录"];
                    
                    
                }

            }
            self.tableView.backgroundView = self.noContentView;
            
            self.headerView.hidden = NO;
            
        }else{
            
            self.headerView.hidden = NO;
            self.tableView.backgroundView = [UIView new];
        }

        
        [self.twoBtnView refreshNoteTwoBtnBottomViewWithType:[self.mainModel.pageInfo.totalRows integerValue]];
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_memoDel) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        
        
        self.edit = NO;
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnAction) image:@"备忘录返回黑" highlightImage:@"备忘录返回黑"];
        
        if (self.noteType != 0) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(editNoteAction) text:@"编辑" textColor:kUIColorFromRGB(0x3689E9)];
        }
        else {
        
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(editNoteAction) text:@"编辑" textColor:kUIColorFromRGB(0x909090)];
        }
        
        [self createBottomView];
        
        [MBProgressHUD showError:@"操作成功！" toView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.pageNum = 1;
            [self requestData];
        });
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
