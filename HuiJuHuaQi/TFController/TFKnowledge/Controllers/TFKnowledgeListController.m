//
//  TFKnowledgeListController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeListController.h"
#import "HQTFNoContentView.h"
#import "YYCollectionViewLayout.h"
#import "HQTFSearchHeader.h"
#import "YYCollectionViewLayout.h"
#import "TFRefresh.h"
#import "TFCreateKnowledgeController.h"
#import "TFKnowledgeListCell.h"
#import "TFKnowledgeListCollectionCell.h"
#import "TFKnowledgeSearchController.h"
#import "TFKnowledgeDetailController.h"
#import "TFKnowledgeBL.h"
#import "TFKnowledgeListModel.h"
#import "TFKnowledgeFilterView.h"
#import "TFCreatePopView.h"

static NSString *knowledgeResuse=@"TFKnowledgeListCollectionCell";

@interface TFKnowledgeListController ()<UITableViewDelegate,UITableViewDataSource,HQTFNoContentViewDelegate,UIActionSheetDelegate,HQTFSearchHeaderDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YYCollectionViewLayoutDelegate,HQBLDelegate,TFKnowledgeFilterViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 无内容视图 */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** 知识菜单 0 全部 1 我创建的 2 我部门的 3 我收藏的 4 邀请我回答 */
@property (nonatomic, assign) NSInteger noteType;
/** 页数 */
@property (nonatomic, assign) NSInteger pageNum;
/** 每页数量 */
@property (nonatomic, assign) NSInteger pageSize;
/** 0:列表 1:瀑布流 */
@property (nonatomic, assign) NSInteger cutType;
/** 导航名字 */
@property (nonatomic, copy) NSString *naviTitle;
/** 加号按钮 */
@property (nonatomic, strong) UIButton *addButton;
/** 加号按钮 */
@property (nonatomic, strong) UIButton *addButton1;
/** 加号按钮 */
@property (nonatomic, strong) UIButton *addButton2;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)YYCollectionViewLayout *layout;
@property (nonatomic, strong) TFKnowledgeFilterView *filterVeiw;

@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;

@property (nonatomic, strong) UIButton *filter;

/** popView */
@property (nonatomic, strong) TFCreatePopView *popView;

@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, copy) NSString *keyWord;

@end

@implementation TFKnowledgeListController
- (NSMutableArray *)datas {
    
    if (!_datas) {
        
        _datas = [NSMutableArray array];
        }
    return _datas;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        [_noContentView setupImageViewRect:(CGRect){30,(SCREEN_HEIGHT- NaviHeight - BottomM -Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.popView dissmiss];
    self.addButton.selected = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.pageSize = 10;
    self.noteType = 0;
    self.naviTitle = @"知识库（全部）";
    self.knowledgeBL = [TFKnowledgeBL build];
    self.knowledgeBL.delegate = self;
    [self setNavi];
    [self setupHeaderSearch];
    [self setupTableView];
    [self setupCollectionView];
    [self setupAddButton];
    [self setupFilterView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestData];
    self.addButton.selected = YES;
}

- (void)setupAddButton {
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:IMG(@"添加") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addNote) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = addButton;
    [self.view insertSubview:addButton aboveSubview:self.tableView];
    addButton.frame = CGRectMake(0, 0, 50, 50);
    addButton.x = SCREEN_WIDTH-50-30;
    addButton.y = SCREEN_HEIGHT-NaviHeight-70-6.5-BottomM;
    
    
//    UIButton *addButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addButton1 setBackgroundImage:IMG(@"企信-备忘录小助手") forState:UIControlStateNormal];
//    [addButton1 addTarget:self action:@selector(addNoteAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.addButton1 = addButton1;
//    [self.view insertSubview:addButton1 aboveSubview:self.tableView];
//    addButton1.frame = CGRectMake(0, 0, 50, 50);
//    addButton1.x = SCREEN_WIDTH-50-30;
//    addButton1.y = SCREEN_HEIGHT-NaviHeight-50-6.5-BottomM;
//    addButton1.tag = 0;
//    [addButton1 setTitle:@"写" forState:UIControlStateNormal];
//    [addButton1 setTitle:@"写" forState:UIControlStateHighlighted];
//    [addButton1 setTitleColor:GreenColor forState:UIControlStateNormal];
//    [addButton1 setTitleColor:GreenColor forState:UIControlStateHighlighted];
//
//    UIButton *addButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addButton2 setBackgroundImage:IMG(@"企信-任务小助手") forState:UIControlStateNormal];
//    [addButton2 addTarget:self action:@selector(addNoteAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.addButton2 = addButton2;
//    [self.view insertSubview:addButton2 aboveSubview:self.tableView];
//    addButton2.frame = CGRectMake(0, 0, 50, 50);
//    addButton2.x = SCREEN_WIDTH-50-30;
//    addButton2.y = SCREEN_HEIGHT-NaviHeight-50-6.5-BottomM;
//    addButton2.tag = 1;
//    [addButton2 setTitle:@"问" forState:UIControlStateNormal];
//    [addButton2 setTitle:@"问" forState:UIControlStateHighlighted];
//    [addButton2 setTitleColor:GreenColor forState:UIControlStateNormal];
//    [addButton2 setTitleColor:GreenColor forState:UIControlStateHighlighted];
}

#pragma mark 添加知识库
- (void)addNoteAction:(NSInteger)index {
    TFCreateKnowledgeController *create = [[TFCreateKnowledgeController alloc] init];
    create.type = index;
    create.refresh = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:create animated:YES];
}

-(void)addNote{
    self.addButton.selected = !self.addButton.selected;
    if (self.addButton.selected) {
        
        [self.popView dissmiss];
    }else{
        CGPoint point = [self.view convertPoint:self.addButton.center toView:self.view];
        
        self.popView = [TFCreatePopView popViewWithPoint:CGPointMake(point.x-self.addButton.width/2, point.y+self.addButton.height/2) knowledge:^{
            [self addNoteAction:0];
        } question:^{
            [self addNoteAction:1];
        }];
    }
    
//    if (self.addButton.selected) {
//
//        [UIView animateWithDuration:0.25 animations:^{
//
//            self.addButton.transform = CGAffineTransformIdentity;
//            self.addButton1.bottom += 60;
//            self.addButton2.bottom += 120;
//
//
//        } completion:^(BOOL finished) {
//            self.addButton.selected = NO;
//        }];
//
//    }else{
//
//        [UIView animateWithDuration:0.25 animations:^{
//
//            self.addButton.transform = CGAffineTransformRotate(self.addButton.transform, M_PI_4 * 3);
//            self.addButton1.bottom -= 60;
//            self.addButton2.bottom -= 120;
//
//        } completion:^(BOOL finished) {
//            self.addButton.selected = YES;
//        }];
//    }
}

- (void)setNavi {
    
    self.navigationItem.title = self.naviTitle;
    UIBarButtonItem *add = [self itemWithTarget:self action:@selector(cutViewAction) image:@"新备忘录切换视图" highlightImage:@"新备忘录切换视图"];
    UIBarButtonItem *person = [self itemWithTarget:self action:@selector(filterClicked:) image:@"状态" highlightImage:@"状态"];
    
    NSArray *rightBtns = [NSArray arrayWithObjects:person,add, nil];
    
    self.navigationItem.rightBarButtonItems = rightBtns;
}

#pragma mark 右侧导航按钮事件
- (void)cutViewAction {
    
    [self.popView dissmiss];
    self.addButton.selected = YES;
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
//- (void)moreItemAction {
//
//    [self.popView dissmiss];
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全部知识",@"我创建的",@"我部门的",@"我收藏的",@"邀我回答", nil];
//
//    [sheet showInView:self.view];
//}

#pragma mark UIActionSheetDelegate (选项类型)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex < 5) {
        
        self.noteType = buttonIndex;
        
        if (self.noteType == 0) {
            
            self.naviTitle = @"知识库（全部）";
        }
        if (self.noteType == 1) {
            
            self.naviTitle = @"知识库（我的）";
        }
        if (self.noteType == 2) {
            
            self.naviTitle = @"知识库（部门）";
        }
        if (self.noteType == 3) {
            
            self.naviTitle = @"知识库（收藏）";
        }
        if (self.noteType == 4) {
            
            self.naviTitle = @"知识库（回答）";
        }
        
        self.navigationItem.title = self.naviTitle;
        
        [self requestData];
    }
    
}

- (void)requestData {

    NSString *categoryId = [self.dataDict valueForKey:@"categoryId"];
    NSString *labelId = [self.dataDict valueForKey:@"labelId"];
    NSNumber *range = [self.dataDict valueForKey:@"range"]?:@0;
    
    [self.knowledgeBL requestGetKnowledgeListWithCategoryId:categoryId labelId:labelId range:range keyWord:self.keyWord pageNum:self.pageNum pageSize:self.pageSize];
}

#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFKnowledgeFilterView *filterVeiw = [[TFKnowledgeFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT+BottomM}];
    filterVeiw.tag = 0x1234554321;
    self.filterVeiw = filterVeiw;
    filterVeiw.delegate = self;
}

#pragma mark - TFFilterViewDelegate
-(void)filterViewDidClicked:(BOOL)show{
    self.filter.selected = !self.filter.selected;
    UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
    btn.selected = !btn.selected;
    [self filterShow:show];
}

-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict{
    self.dataDict = dict;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestData];
    self.filter.selected = !self.filter.selected;
    UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
    btn.selected = !btn.selected;
    [self filterShow:NO];
}

#pragma mark 搜索
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [[HQTFSearchHeader alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 64)];
    self.header = header;
    header.backgroundColor = WhiteColor;
    header.button.backgroundColor = BackGroudColor;
    header.delegate = self;
    [self.view addSubview:header];
    
//    UIButton *filter = [UIButton buttonWithType:UIButtonTypeCustom];
//    [filter setImage:IMG(@"状态") forState:UIControlStateNormal];
//    filter.frame = CGRectMake(SCREEN_WIDTH-44, 0, 44, 44);
//    [self.view addSubview:filter];
//    filter.backgroundColor = WhiteColor;
//    [filter addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.filter = filter;
}
-(void)filterClicked:(UIButton *)button{
    button.selected = !button.selected;
    [self filterShow:button.selected];
}

-(void)filterShow:(BOOL)show{
    [self.popView dissmiss];
    self.addButton.selected = YES;
    if (show) {
        
        [KeyWindow addSubview:self.filterVeiw];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, .5);
            self.filterVeiw.left = 0;
        }];
        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.left = SCREEN_WIDTH;
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            
            [self.filterVeiw removeFromSuperview];
        }];
        
    }
}

#pragma mark - searchHeader Deleaget
-(void)searchHeaderClicked{
    
    [self.popView dissmiss];
    self.addButton.selected = YES;
    TFKnowledgeSearchController *search = [[TFKnowledgeSearchController alloc] init];
    
    [self.navigationController pushViewController:search animated:YES];
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
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFKnowledgeListCell *cell = [TFKnowledgeListCell knowledgeListCellWithTableView:tableView];
    [cell refreshKnowledgeListCellWithModel:self.datas[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.popView dissmiss];
    self.addButton.selected = YES;
    TFKnowledgeItemModel *model = self.datas[indexPath.section];
    
    TFKnowledgeDetailController *detail = [[TFKnowledgeDetailController alloc] init];
    detail.dataId = model.id;
    detail.deleteAction = ^{
        [self.datas removeObjectAtIndex:indexPath.section];
        [self.tableView reloadData];
    };
    detail.refreshAction = ^(TFKnowledgeItemModel *parameter) {
//        parameter.contentSimple = [HQHelper filterHTML:parameter.content];
//        [self.datas replaceObjectAtIndex:indexPath.section withObject:parameter];
//        [self.tableView reloadData];
    };
    detail.reloadAction = ^(id parameter) {
        self.pageNum = 1;
        [self requestData];
    };
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 154;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
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
    self.collectionView.backgroundColor = BackGroudColor;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TFKnowledgeListCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:knowledgeResuse];
    self.collectionView.hidden = YES;
    
    MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
        
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
    TFKnowledgeItemModel *model = self.datas[indexPath.row];
    TFKnowledgeListCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:knowledgeResuse forIndexPath:indexPath];
    [cell refreshKnowledgeListCollectionCellWithModel:model];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFKnowledgeItemModel *model = self.datas[indexPath.row];
    TFKnowledgeDetailController *detail = [[TFKnowledgeDetailController alloc] init];
    detail.dataId = model.id;
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(CGSize)YYCollectionViewLayoutForCollectionView:(UICollectionView *)collection withLayout:(YYCollectionViewLayout *)layout atIndexPath:(NSIndexPath *)indexPath
{
    TFKnowledgeItemModel *model = self.datas[indexPath.row];
    
    return [TFKnowledgeListCollectionCell refreshKnowledgeListCollectionCellSizeWithModel:model];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.popView dissmiss];
    self.addButton.selected = YES;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getKnowledgeList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        TFKnowledgeListModel *model = resp.body;
        
        for (TFKnowledgeItemModel *item in model.dataList) {
            item.contentSimple = [HQHelper filterHTML:item.content];
            if ( item.contentSimple.length > 200){
                item.contentSimple = [item.contentSimple substringToIndex:200];
            }
        }
        
        TFPageInfoModel *listModel = model.pageInfo;
        
        if ([self.tableView.mj_footer isRefreshing] || [self.collectionView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
        }else {
            
            [self.tableView.mj_header endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            
            [self.datas removeAllObjects];
        }
        
        [self.datas addObjectsFromArray:model.dataList];
        
        
        if ([listModel.totalRows integerValue] <= self.datas.count) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            
            [self.tableView.mj_footer resetNoMoreData];
            [self.collectionView.mj_footer resetNoMoreData];
        }
        
        if (self.datas.count == 0) {

            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
