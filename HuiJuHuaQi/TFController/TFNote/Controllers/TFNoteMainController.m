//
//  TFNoteMainController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteMainController.h"
#import "TFNewNoteMainCell.h"
#import "TFNoteBL.h"
#import "TFNoteMainListModel.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "HQTFSearchHeader.h"
#import "TFCreateNoteController.h"
#import "YYCollectionViewLayout.h"
#import "TFNoteCollectionViewCell.h"
#import "TFNoteListSearchController.h"

static NSString *resuse=@"NoteCollection";

@interface TFNoteMainController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFNoContentViewDelegate,HQTFSearchHeaderDelegate,UIActionSheetDelegate,TFSliderCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YYCollectionViewLayoutDelegate>

@property (nonatomic, weak) UITableView *tableView;
/** 备忘菜单 0:全部 1:我创建的 2:共享给我 3:已删除 */
@property (nonatomic, assign) NSInteger noteType;
/** 页数 */
@property (nonatomic, assign) NSInteger pageNum;
/** 每页数量 */
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) TFNoteBL *noteBL;

@property (nonatomic, strong) TFNoteMainListModel *mainModel;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 无内容视图 */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** headerView */
@property (nonatomic, strong) UIView *headerView;
/** 滑动索引 */
@property (nonatomic, assign) NSInteger sliderIndex;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)YYCollectionViewLayout *layout;
@property(nonatomic,strong)NSMutableArray *itemHeights;

/** 0:列表 1:瀑布流 */
@property (nonatomic, assign) NSInteger cutType;
/** 导航名字 */
@property (nonatomic, copy) NSString *naviTitle;
/** 操作类型 1:删除  2：彻底删除 3：恢复备忘  4：退出共享*/
@property (nonatomic, assign) NSInteger operationType;

/** 加号按钮 */
@property (nonatomic, strong) UIButton *addButton;
/** 最后位置 */
@property (nonatomic, assign) CGFloat lastPosition;


@end

@implementation TFNoteMainController

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
        
        [_noContentView setupImageViewRect:(CGRect){117,106,141,141} imgImage:@"备忘录为空" buttonWord:@"去添加备忘内容" withTipWord:@"您暂时没有添加任何备忘内容。\n养成良好的记录备忘习惯\n有助于工作的顺利展开！"];
        _noContentView.delegate = self;
    }
    return _noContentView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnAction) image:@"备忘录返回黑" highlightImage:@"备忘录返回黑"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setNavi];
    [self setupTableView];
    [self setupHeaderSearch];
    [self setupCollectionView];
    [self setupAddButton];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestData];
}

- (void)initData {
    
    self.pageNum = 1;
    
    self.pageSize = 10;
    
    self.noteType = 0;
    self.naviTitle = @"备忘录（全部）";
    self.cutType = 0;
    
    self.noteBL = [TFNoteBL build];
    self.noteBL.delegate = self;
}

-(void)initCollectionData
{
    _itemHeights=[NSMutableArray arrayWithCapacity:self.datas.count];
    
    
    for (int i=0; i<self.datas.count; i++)
    {
        
        TFNoteDataListModel *model = self.datas[i];
        
        //总高度
        CGFloat totleHeight = 0.0;
        //内容尺寸
        CGSize contentSize = [HQHelper calculateStringWithAndHeight:model.title cgsize:CGSizeMake((SCREEN_WIDTH-55)/2-10, MAXFLOAT) wordFont:FONT(14)];
        //图片高度
        CGFloat imgH = 0.0;
        //没有图片
        if (![model.pic_url isEqualToString:@""] && model.pic_url != nil) {
            
            imgH = 60.0;
            
        }
        
        totleHeight = 5+imgH+10+contentSize.height+10+22+5;
        
        if (totleHeight > 250) {
            
            totleHeight = 250;
        }
        
        [_itemHeights addObject:@(totleHeight)];
        
    }
    
    
}

- (void)requestData {
    
    [self.noteBL requestGetNoteListWithPageNum:self.pageNum pageSize:self.pageSize type:self.noteType keyword:nil];
}

- (void)setupAddButton {
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:IMG(@"新备忘录新增") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addNoteAction) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = addButton;
    [self.view insertSubview:addButton aboveSubview:self.tableView];
    addButton.frame = CGRectMake(0, 0, 50, 50);
    addButton.x = SCREEN_WIDTH-50-30;
    addButton.y = SCREEN_HEIGHT-NaviHeight-50-6.5-BottomM;
    
//    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.bottom.equalTo(@(-6.5));
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.height.equalTo(@50);
//    }];
}

- (void)setNavi {
    
    self.navigationItem.title = self.naviTitle;
    UIBarButtonItem *add = [self itemWithTarget:self action:@selector(cutViewAction) image:@"新备忘录切换视图" highlightImage:@"新备忘录切换视图"];
    UIBarButtonItem *person = [self itemWithTarget:self action:@selector(moreItemAction) image:@"新备忘录更多" highlightImage:@"新备忘录更多"];
    
    NSArray *rightBtns = [NSArray arrayWithObjects:person,add, nil];
    
    self.navigationItem.rightBarButtonItems = rightBtns;
}

#pragma mark 搜索
#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    self.header = header;
    header.backgroundColor = WhiteColor;
    header.button.backgroundColor = BackGroudColor;
    header.delegate = self;
    [self.view addSubview:header];
    
}

#pragma mark - searchHeader Deleaget
-(void)searchHeaderClicked{
    
    TFNoteListSearchController *search = [[TFNoteListSearchController alloc] init];
    
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 初始化CollectionView
- (void)setupCollectionView {
    
    _layout=[[YYCollectionViewLayout alloc]init];
    
    _layout.delegate=self;
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) collectionViewLayout:_layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -BottomM, 0);
    [self.view insertSubview:self.collectionView belowSubview:self.tableView];
    self.collectionView.backgroundColor=kUIColorFromRGB(0xF2F2F2);
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TFNoteCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:resuse];
    self.collectionView.hidden = YES;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{

        self.pageNum = 1;
        [self requestData];

    }];
    self.collectionView.mj_header = header;


    MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{

        self.pageNum ++;
        [self requestData];

    }];
    self.collectionView.mj_footer = footer;
    
}

//numberOfItemsInSection
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}
//cellForItemAtIndexPath
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFNoteDataListModel *model = self.datas[indexPath.row];
    TFNoteCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:resuse forIndexPath:indexPath];

    if ([model.pic_url isEqualToString:@""] || model.pic_url == nil) {
        
        cell.picHeightCons.constant = 0;
        cell.imgLableCons.constant = 0;
    }
    else {
        
        cell.picHeightCons.constant = 60;
        cell.imgLableCons.constant = 10;
    }
    [cell.picImgView sd_setImageWithURL:[HQHelper URLWithString:model.pic_url]];
    cell.contentLable.text = model.title;
    
    cell.timeLable.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"MM-dd HH:mm"];
    //有共享人，或者创建人不为自己
    if ((![model.share_ids isEqualToString:@""] && model.share_ids != nil) || ![model.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) {
        
        cell.buttonOne.image = IMG(@"备忘录共享蓝");
        
        if ([model.remind_time integerValue] > 0) {
            
            cell.buttonTwo.image = IMG(@"新备忘录提醒");
        }
        else {
            
            cell.buttonTwo.image = IMG(@"");
        }
    }
    else {
        
        if ([model.remind_time integerValue] > 0) {
            
            cell.buttonOne.image = IMG(@"新备忘录提醒");
        }
        else {
            
            cell.buttonOne.image = IMG(@"");
        }
        cell.buttonTwo.image = IMG(@"");
    }

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

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

-(CGSize)YYCollectionViewLayoutForCollectionView:(UICollectionView *)collection withLayout:(YYCollectionViewLayout *)layout atIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ITEM_WIDTH,[_itemHeights[indexPath.row] floatValue]);
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -BottomM, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
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
    TFNewNoteMainCell *cell = [TFNewNoteMainCell NewNoteMainCellWithTableView:tableView];
    cell.bottomLine.hidden = NO;
    cell.delegate = self;
    [cell.noteList refreshNewNoteListCellWithModel:model];
    
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
    
    return 74;
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

#pragma mark - TFSliderCellDelegate
-(void)sliderCellDidClickedIndex:(NSInteger)index{
    
    HQLog(@"点击了%ldItem",index);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    TFNoteDataListModel *model = self.datas[self.sliderIndex];
    
    if (self.noteType == 0) {
        
        if ([model.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) {
            
            self.operationType = 1;
            
            
        }
        else {
            
            self.operationType = 4;
        }
        
    }
    else if (self.noteType == 1) {
        
        self.operationType = 1;
    }
    else if (self.noteType == 2) {
        
        self.operationType = 4;
    }
    else {
        
        if (index==1) {
            
            self.operationType = 2;
        }else {
            
            self.operationType = 3;
        }
        
        
        
    }
    
    for (TFNewNoteMainCell *cell in self.tableView.visibleCells) {
        
        [cell hiddenItem];
    }
    
    [self.noteBL requestDeleteNoteWithDict:[NSString stringWithFormat:@"%@",model.id] type:self.operationType];
    
}

-(void)sliderCellSelectedIndexPath:(NSIndexPath *)indexPath{
    
    for (TFNewNoteMainCell *cell in self.tableView.visibleCells) {
        
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
    for (TFNewNoteMainCell *cell in self.tableView.visibleCells) {
        
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        
        if (!(indexPath.section == index.section && indexPath.row == index.row)) {
            
            [cell hiddenItem];
        }
    }
}


#pragma mark 返回
- (void)returnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加备忘录
- (void)addNoteAction {
    
    for (TFNewNoteMainCell *cell in self.tableView.visibleCells) {
        
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

#pragma mark ---HQTFNoContentViewDelegate(无内容时快捷添加)
- (void)noContentViewDidClickedButton {
    
    TFCreateNoteController *createVC = [[TFCreateNoteController alloc] init];

    createVC.type = 0;

    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma mark 右侧导航按钮事件
//切换视图
- (void)cutViewAction {
    
    if (self.cutType == 0) {
        
        self.cutType = 1;
        
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
    }
    else {
        
        self.cutType = 0;
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
    }
    
    
}

//更多选项
- (void)moreItemAction {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全部备忘",@"我创建的",@"共享给我",@"已删除", nil];

    [sheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate (选项类型)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex < 4) {
        self.pageNum = 1;
        
        self.noteType = buttonIndex;
        
        if (self.noteType == 0) {
            
            self.naviTitle = @"备忘录（全部）";
        }
        if (self.noteType == 1) {
            
            self.naviTitle = @"备忘录（我的）";
        }
        if (self.noteType == 2) {
            
            self.naviTitle = @"备忘录（共享）";
        }
        if (self.noteType == 3) {
            
            self.naviTitle = @"备忘录（删除）";
        }
        
        self.navigationItem.title = self.naviTitle;
        [self requestData];
    }
    
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp {
    
    if (resp.cmdId == HQCMD_getNoteList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.mainModel = resp.body;
        
        if (self.cutType == 1) {
            
            if ([self.collectionView.mj_footer isRefreshing]) {
                
                [self.collectionView.mj_footer endRefreshing];
                
            }else {
                
                [self.collectionView.mj_header endRefreshing];
                
                [self.datas removeAllObjects];
                
            }
            
            [self.datas addObjectsFromArray:self.mainModel.dataList];
            
            
            if ([self.mainModel.pageInfo.totalRows integerValue] == self.datas.count) {
                
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                
            }else {
                
                
                [self.collectionView.mj_footer resetNoMoreData];
            }
            
            if (self.datas.count == 0) {
                
                self.collectionView.backgroundView = self.noContentView;
                
            }else{
                
                self.collectionView.backgroundView = [UIView new];
            }
        }
        else {
            
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
                
                self.tableView.backgroundView = self.noContentView;
                
            }else{
                
                self.tableView.backgroundView = [UIView new];
            }
        }
        
        
        [self initCollectionData];
        
        [self.tableView reloadData];
        [self.collectionView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_memoDel) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.operationType == 3) {
            
            [MBProgressHUD showError:@"恢复成功！" toView:self.view];
        }
        else if (self.operationType == 4) {
            
            [MBProgressHUD showError:@"退出成功！" toView:self.view];
        }
        else {
            
            [MBProgressHUD showError:@"删除成功！" toView:self.view];
        }
        
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
