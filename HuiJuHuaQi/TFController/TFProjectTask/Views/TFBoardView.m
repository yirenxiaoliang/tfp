//
//  TFBoardView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBoardView.h"
#import "TFProjectSectionModel.h"
#import "TFTaskListCell.h"
#import "HQBaseCell.h"
#import "HQPageControl.h"
#import "HQTFTaskTableViewCell.h"
#import "TFRefresh.h"
#import "TFProjectTaskBL.h"
#import "TFProjectRowFrameModel.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectApprovalCell.h"
#import "TFProjectNoteCell.h"
#import "TFTProjectCustomCell.h"
#import "TFNewProjectCustomCell.h"

#define Padding 10
#define EdgeMargin 50

#define PageHeight 30

@interface TFBoardView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HQTFTaskTableViewCellDelegate,HQBLDelegate,TFProjectTaskItemCellDelegate>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *models;


/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** tableViews */
@property (nonatomic, strong) NSMutableArray *tableViews;

@property (nonatomic, strong, nullable) UILongPressGestureRecognizer *longGesture; ///< 长按手势

@property (nonatomic, strong) CADisplayLink *edgeTimer;                  ///< 定时器

@property (nonatomic, strong) UIView *snapedView;                        ///< 截图快照

@property (nonatomic, strong) UITableView *oldTableView;// 上一个tableView

@property (nonatomic, strong) UITableView *currentTableView;// 当前页的tableView
@property (nonatomic, strong) UIView *currentAllView;// 当前页的currentAllView
@property (nonatomic, strong) UIView *oldAllView;// 上一个oldAllView

@property (nonatomic, strong, nullable) NSIndexPath *oldIndexPath;                 ///< 旧的IndexPath
@property (nonatomic, strong, nullable) NSIndexPath *currentIndexPath;             ///< 当前路径

@property (nonatomic, assign) CGPoint oldPoint;                                    ///< 旧的位置
@property (nonatomic, assign) CGPoint lastPoint;

/** 用于控制在执行边缘切换页时不执行手势改变操作 */
@property (nonatomic, assign) BOOL edgeAct;
/** 用于控制在执行手势改变不执行边缘改变操作 */
@property (nonatomic, assign) BOOL gestureAct;
/** 移动中 */
@property (nonatomic, assign) BOOL moving;


/** 移动任务还是所有 */
@property (nonatomic, assign) BOOL moveTask;

/** allViews */
@property (nonatomic, strong) NSMutableArray *allViews;

/** pageControl */
@property (nonatomic, strong) HQPageControl *pageControl;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** addLabel */
@property (nonatomic, weak) UIButton *addLabel;

/** privilege */
@property (nonatomic, copy) NSString *privilege;

/** adds */
@property (nonatomic, strong) NSMutableArray *adds;

/** menus */
@property (nonatomic, strong) NSMutableArray *menus;

/** 不能移动任务列 */
@property (nonatomic, assign) BOOL isNotMoveTaskRow;

/** startIndex 用于记录任务移动开始列 */
@property (nonatomic, assign) NSInteger startIndex;
/** endIndex 用于记录任务移动结束列 */
@property (nonatomic, assign) NSInteger endIndex;

/** 筛选条件 */
@property (nonatomic, strong) NSDictionary *filterParam;


@end


@implementation TFBoardView

-(NSMutableArray *)adds{
    if (!_adds) {
        _adds = [NSMutableArray array];
    }
    return _adds;
}
-(NSMutableArray *)menus{
    if (!_menus) {
        _menus = [NSMutableArray array];
    }
    return _menus;
}

-(NSMutableArray *)tableViews{
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

-(NSMutableArray *)allViews{
    if (!_allViews) {
        _allViews = [NSMutableArray array];
    }
    return _allViews;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(3*Padding/2, 0, self.width-3*Padding, self.height-PageHeight)];
        [self addSubview:scrollView];
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES ;
        scrollView.bounces = YES;
        scrollView.delegate = self;
        scrollView.tag = 0x7788;
        scrollView.backgroundColor = WhiteColor;
        self.scrollView = scrollView;
        scrollView.layer.masksToBounds = NO;
        
        HQPageControl *pageControl = [[HQPageControl alloc] initWithFrame:(CGRect){0,self.height-22,self.width-3*Padding,22}];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        [self addGestureRecognizer:self.longGesture];
        
        self.projectTaskBL = [TFProjectTaskBL build];
        self.projectTaskBL.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveTaskNotification:) name:ProjectTaskMoveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterTaskNotification:) name:ProjectTaskFilterNotification object:nil];
        
    }
    return self;
}

- (void)filterTaskNotification:(NSNotification *)noti{
    
    self.filterParam = noti.object;
    
    // 搜索
    for (NSInteger index = 0; index < self.models.count; index ++) {
        TFProjectSectionModel *section = self.models[index];
        UITableView *tableView = self.tableViews[index];
        [MBProgressHUD showHUDAddedTo:tableView animated:YES];
        [self.projectTaskBL requsetGetTaskWithSectionId:section.id pageNo:@1 pageSize:@100 rowIndex:index filterParam:self.filterParam];
        
    }
    
}


/** 接到通知 */
- (void)moveTaskNotification:(NSNotification *)noti{
    
    NSDictionary *dict = noti.object;
    NSNumber *startSectionId = [dict valueForKey:@"startSectionId"];
    NSNumber *endSectionId = [dict valueForKey:@"endSectionId"];
    
    for (NSInteger index = 0; index < self.models.count; index ++) {
        
        TFProjectSectionModel *section = self.models[index];
        
        if ([startSectionId isEqualToNumber:section.id]) {
            
            [self.projectTaskBL requsetGetTaskWithSectionId:section.id pageNo:@1 pageSize:@100 rowIndex:index filterParam:nil];
        }
        if ([endSectionId isEqualToNumber:section.id]) {
            
            [self.projectTaskBL requsetGetTaskWithSectionId:section.id pageNo:@1 pageSize:@100 rowIndex:index filterParam:nil];
        }
        
    }
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (scrollView.tag == 0x7788) {
    
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 0x7788) {
        // 当前页
        NSInteger page = self.scrollView.contentOffset.x / (self.width-3*Padding);
        
        if ([self.delegate respondsToSelector:@selector(boardView:changePage:)]) {
            [self.delegate boardView:self changePage:page];
        }
        self.pageControl.currentPage = page;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag != 0x7788) {
        
        
        if ([self.delegate respondsToSelector:@selector(boardView:scrollView:)]) {
            [self.delegate boardView:self scrollView:scrollView];
        }
    }
    
}


/** 刷新 */
- (void)refreshData{
    
    for (UITableView *tableView in self.tableViews) {
        
        [tableView reloadData];
    }
    
}

/** 0:可移动可添加列 1:可移动不可添加列 2:不可移动不可添加列 */
-(void)setType:(NSInteger)type{
    
    if ([self.temp_id integerValue] > 0) {
        type = 1;
    }
    _type = type;
    
    if (self.type == 0) {
        
        self.longGesture.enabled = YES;
        
        self.scrollView.contentSize = CGSizeMake((self.width-3*Padding)*(self.models.count+1), self.height-PageHeight);
        self.pageControl.numberOfPages = self.models.count + 1;
        self.pageControl.type = 0;
        self.addLabel.hidden = NO;
        
    }else if (self.type == 1){
        
        self.longGesture.enabled = YES;
        
        self.scrollView.contentSize = CGSizeMake((self.width-3*Padding)*(self.models.count), self.height-PageHeight);
        self.pageControl.numberOfPages = self.models.count;
        self.pageControl.type = 1;
        self.addLabel.hidden = YES;
        
    }else if (self.type == 2){
        
        self.longGesture.enabled = NO;
        
        self.scrollView.contentSize = CGSizeMake((self.width-3*Padding)*(self.models.count), self.height-PageHeight);
        self.pageControl.numberOfPages = self.models.count;
        self.pageControl.type = 1;
        self.addLabel.hidden = YES;
    }
}

-(void)setViewHeight:(CGFloat)viewHeight{
    _viewHeight = viewHeight;
    
    self.height = viewHeight;
    
    for (UIView *view in self.allViews) {
        view.height = self.height-PageHeight;
    }
    for (UIView *view in self.tableViews) {
        view.height = self.height-44-44-PageHeight;
    }
    for (UIView *view in self.adds) {
        view.y = self.height-44-PageHeight;
    }
    self.pageControl.y = self.height-22;
}


/** 初始化 type 0:可移动可添加列 1:可移动不可添加列 2:不可移动不可添加列 */
-(void)refreshMoveViewWithModels:(NSMutableArray *)models withType:(NSInteger)type{
    
    self.models = models;
    
    self.scrollView.contentSize = CGSizeMake((self.width-3*Padding)*(models.count+1), self.height-PageHeight);
    self.pageControl.numberOfPages = models.count + 1;
    self.pageControl.currentPage = 0;
    
    for (UIView *tableView in self.scrollView.subviews) {
        [tableView removeFromSuperview];
    }
    [self.tableViews removeAllObjects];
    [self.allViews removeAllObjects];
    [self.adds removeAllObjects];
    [self.menus removeAllObjects];
    
    for (NSInteger i = 0; i < models.count+1; i ++) {
        
        CGFloat X = (self.width - 3 * Padding) * i + Padding/2;
        CGFloat W = (self.width - 4 * Padding);
        
        if (i == models.count) {
            
            UIButton *addLabel = [UIButton buttonWithType:UIButtonTypeCustom];
            addLabel.frame = (CGRect){X,0,W,46};
            [addLabel setTitle:[NSString stringWithFormat:@"+  新建任务列表"] forState:UIControlStateNormal];
            [addLabel setTitle:[NSString stringWithFormat:@"+  新建任务列表"] forState:UIControlStateHighlighted];
            addLabel.backgroundColor = HexColor(0xf7f9fa);
            [addLabel setBackgroundImage:[UIImage imageNamed:@"新增框"] forState:UIControlStateNormal];
            [addLabel setBackgroundImage:[UIImage imageNamed:@"新增框"] forState:UIControlStateHighlighted];
            [self.scrollView addSubview:addLabel];
            [addLabel setTitleColor:HexColor(0x797979) forState:UIControlStateNormal];
            addLabel.layer.cornerRadius = 4;
            addLabel.layer.masksToBounds = YES;
            addLabel.userInteractionEnabled = YES;
            
            [addLabel addTarget:self action:@selector(addTaskRow) forControlEvents:UIControlEventTouchUpInside];
            self.addLabel = addLabel;
            continue;
        }
        
        UIView *allView = [[UIView alloc] initWithFrame:(CGRect){X,0,W,self.height-PageHeight}];
        allView.backgroundColor = HexColor(0xe8eef0);
        allView.tag = i;
        allView.layer.cornerRadius = 4;
        allView.layer.masksToBounds = YES;
        [self.scrollView addSubview:allView];
        [self.allViews addObject:allView];
        
        TFProjectSectionModel *section = models[i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){8,0,W-52,44}];
        label.text = section.name;
        label.backgroundColor = HexColor(0xe8eef0);
        [allView addSubview:label];
        label.tag = i;
        
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.frame = CGRectMake(W-52, 0, 44, 44);
        [menuBtn setImage:[UIImage imageNamed:@"projectMenu"] forState:UIControlStateNormal];
        [menuBtn setImage:[UIImage imageNamed:@"projectMenu"] forState:UIControlStateHighlighted];
        [allView addSubview:menuBtn];
        menuBtn.tag = i;
        [menuBtn addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.menus addObject:menuBtn];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, W, self.height-44-44-PageHeight) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        tableView.backgroundColor = HexColor(0xe8eef0);
        [allView addSubview:tableView];
        [self.tableViews addObject:tableView];
        tableView.tag = i;
        [tableView reloadData];
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:(CGRect){0,self.height-44-PageHeight,W,44}];
        label1.font = FONT(17);
        label1.text = @"  十 添加...";
        label1.backgroundColor = HexColor(0xe8eef0);
        label1.textColor = HexColor(0x797979);
        [allView addSubview:label1];
        label1.tag = i;
        [self.adds addObject:label1];
        
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTapClicked)];
        label1.userInteractionEnabled = YES;
        [label1 addGestureRecognizer:addTap];
        
//        [self loadDataWithSectionModel:section index:i];// 初始化时加载数据会将所有分组的任务列全部加载数据，比较消耗资源。最好是先加载第一分组的数据，待切换分组时再加载该分组数据。
        
    }
    [self insertSubview:self.pageControl atIndex:self.subviews.count-1];
    
    if (type>=0) {
        self.type = type;
    }
    
    if (!self.isPreview) {
        [self loadTableViewRefresh];
    }else{
        for (UIView *view in self.menus) {
            view.hidden = YES;
        }
    }
    
    
}
/** 加载某列数据 */
- (void)loadDataWithSectionModel:(TFProjectSectionModel *)section index:(NSInteger)index{
    
    if (section.id) {// 预览时无id，不加载数据
        [self.projectTaskBL requsetGetTaskWithSectionId:section.id pageNo:@1 pageSize:@100 rowIndex:index filterParam:nil];
    }
}

/** 加载全部数据 */
- (void)loadAllData{
    
    if (self.privilege == nil) {
        
        [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];// 权限
    }
    
    for (NSInteger index = 0; index < self.models.count; index ++) {
        TFProjectSectionModel *section = self.models[index];
        if (section.tasks == nil) {
            
            [MBProgressHUD showHUDAddedTo:self.tableViews[index] animated:YES];
            [self.projectTaskBL requsetGetTaskWithSectionId:section.id pageNo:@1 pageSize:@100 rowIndex:index filterParam:nil];
        }
    }
}




- (void)addTapClicked{// 新增任务
    
    // 当前页
    NSInteger page = self.scrollView.contentOffset.x / (self.width-3*Padding);
    if ([self.delegate respondsToSelector:@selector(boardView:addTaskWithModel:)]) {
        [self.delegate boardView:self addTaskWithModel:self.models[page]];
    }
}

- (void)addTaskRow{// 新增任务列
    
    if ([self.delegate respondsToSelector:@selector(boardViewDidTaskRow)]) {
        [self.delegate boardViewDidTaskRow];
    }
}

- (void)menuClicked:(UIButton *)button{
    
    TFProjectSectionModel *section = self.models[button.tag];
    
    NSMutableArray *arr = [NSMutableArray array];
    if (!self.temp_id || [self.temp_id integerValue] == 0) {
        if (IsStrEmpty([section.flow_id description])) {// 工作流
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"21"]) {
                [arr addObject:@"编辑任务列名称"];
            }
        }
        
    }
    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"24"]) {
        [arr addObject:@"取消关联"];
    }
    
    if (!self.temp_id || [self.temp_id integerValue] == 0) {
        
        if (IsStrEmpty([section.flow_id description])) {// 工作流
            if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"23"]) {
                [arr addObject:@"删除"];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(boardView:didMenuWithModel:menus:)]) {
        [self.delegate boardView:self didMenuWithModel:section menus:arr];
    }
}

#pragma mark - TFProjectTaskItemCellDelegate
-(void)projectTaskItemCell:(TFProjectTaskItemCell *)cell didClickedFinishBtnWithModel:(id)model{
    
    if ([self.delegate respondsToSelector:@selector(boardView:didClickedFinishItem:)]) {
        [self.delegate boardView:self didClickedFinishItem:model];
    }
}


-(void)setSelectPage:(NSInteger)selectPage{
    
    _selectPage = selectPage;
    
    self.scrollView.contentOffset = CGPointMake(selectPage * (self.width-3*Padding), 0);
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        _longGesture.minimumPressDuration = .5;
    }
    return _longGesture;
}

-(void)dealloc{
    [self _stopEdgeTimer];
}

//#warning 猜想：在移动cell时，tableView会出现不停指令般的乱闪动，可能的原因是tableView可以滚动所致，当移动时禁止所有的tableView滚动
- (void)forbidAllTabViewScroll{
    
    for (UITableView *tableView in self.tableViews) {
        tableView.scrollEnabled = NO;
    }
}
- (void)AllowAllTabViewScroll{
    
    for (UITableView *tableView in self.tableViews) {
        tableView.scrollEnabled = YES;
    }
}


#pragma mark - 事件响应
-(void)moveItemWithPoint:(CGPoint)point longGesture:(UILongPressGestureRecognizer *)longGesture{
    
    // 当前页
    NSInteger page = self.scrollView.contentOffset.x / (self.width-3*Padding);
    // 当前tableView
    UITableView *tableView = [self.tableViews objectAtIndex:page];
    // tableView上对应的点
    CGPoint tablePoint = [self convertPoint:point toView:tableView];
    
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            // 该点在tableView上对应的indexPath
            NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:tablePoint];
            
            if (indexPath == nil) {
                return;
            }
            self.moving = YES;
            
            self.userInteractionEnabled = NO;
            
            [self forbidAllTabViewScroll];// 禁止滚动
            self.pageControl.hidden = YES;
            
            // 记录当前的tableView,开始时老的和新的一样
            self.oldTableView = tableView;
            self.currentTableView = tableView;
            self.startIndex = self.currentTableView.tag;
            
            self.currentIndexPath = indexPath;
            self.oldIndexPath = indexPath;
            // 该indexPath的cell
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            // cell快照
            _snapedView = nil;
            _snapedView = [cell snapshotViewAfterScreenUpdates:NO];
            
            // 设置frame
            CGRect rect = [self.currentTableView convertRect:cell.frame toView:self];
            _snapedView.frame = rect;
            // 添加到self 不然无法显示
            [self addSubview:_snapedView];
            //截图后隐藏当前cell(数据源控制隐藏)
            cell.hidden = YES;
            TFProjectSectionModel *model = self.models[tableView.tag];
            TFProjectRowModel *row = model.tasks[indexPath.row];
            row.hidden = @"1";
            // 刷新隐藏的cell
            if (_oldIndexPath) {
                
                [self.currentTableView reloadRowsAtIndexPaths:@[_oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            // 动画放大和移动到触摸点下面
            [UIView animateWithDuration:0.25 animations:^{
                _snapedView.center = CGPointMake(_snapedView.center.x + 10, _snapedView.center.y + 10);
            }];
            if ([self.delegate respondsToSelector:@selector(boardViewWillMoing)]) {
                [self.delegate boardViewWillMoing];
            }
            //            HQLog(@"point:%@", NSStringFromCGPoint(point));
            //            HQLog(@"tablePoint:%@", NSStringFromCGPoint(tablePoint));
            [self _setEdgeTimer];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            if (self.edgeAct) {
                break;
            }
            self.gestureAct = YES;
            // 当前手指在tableView上的点
            _lastPoint = [self.currentTableView convertPoint:tablePoint toView:self];
            // 截图视图位置移动
            [UIView animateWithDuration:0.1 animations:^{
                _snapedView.center = _lastPoint;
            }];
            
            NSIndexPath *index = [self _getChangedIndexPath];
            
            // 没有取到或者距离隐藏的最近时就返回
            if (!index) {
                self.gestureAct = NO;
                break;
            }
            
            _currentIndexPath = index;
            
            self.oldPoint = [self.currentTableView cellForRowAtIndexPath:_currentIndexPath].center;
            
            // 更变数据源
            [self _updateSourceData];
            
            // 移动 会调用willMoveToIndexPath方法更新数据源
            [self.currentTableView moveRowAtIndexPath:_oldIndexPath toIndexPath:_currentIndexPath];
            // 设置移动后的起始indexPath
            _oldIndexPath = _currentIndexPath;
            if (_oldIndexPath) {
                
                [self.currentTableView reloadRowsAtIndexPaths:@[_oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            self.gestureAct = NO;
            
        }
            break;
        default: {
            
            if (!self.currentIndexPath) {
                return;
            }
            
            self.moving = NO;
            [self AllowAllTabViewScroll];// 允许滚动
            self.pageControl.hidden = NO;
            self.pageControl.currentPage = self.currentTableView.tag;
            
            UITableViewCell *cell = [self.currentTableView cellForRowAtIndexPath:_currentIndexPath];
            
            self.endIndex = self.currentTableView.tag;
            // 结束动画过程中停止交互，防止出问题
            self.userInteractionEnabled = NO;
            
            // 给截图视图一个动画移动到隐藏cell的新位置
            [UIView animateWithDuration:0.25 animations:^{
                if (!cell) {
                    _snapedView.center = _oldPoint;
                } else {
                    _snapedView.center = [self.currentTableView convertPoint:cell.center toView:self];
                }
                _snapedView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                _snapedView.alpha = 1.0;
            } completion:^(BOOL finished) {
                // 移除截图视图、显示隐藏的cell并开启交互
                [_snapedView removeFromSuperview];
                _snapedView = nil;
                cell.hidden = NO;
                [self refreshHidden];
                //                [self.currentTableView reloadData];
                self.userInteractionEnabled = YES;
                
                if ([self.delegate respondsToSelector:@selector(boardView:dataChanged:destinationIndex:originalIndex:moveTask:)]) {
                    TFProjectSectionModel *se = self.models[self.endIndex];
                    TFProjectRowModel *ro = se.tasks[self.currentIndexPath.row];
                    [self.delegate boardView:self dataChanged:self.models destinationIndex:self.startIndex originalIndex:self.endIndex moveTask:ro];
                }
                
            }];
            
            // 关闭定时器
            [self _stopEdgeTimer];
            
        }
            break;
    }
}

-(void)moveAllWithPoint:(CGPoint)point longGesture:(UILongPressGestureRecognizer *)longGesture{

//    HQLog(@"page:%ld===",page);
//
//    HQLog(@"point:%@===",NSStringFromCGPoint(point));
//
//    HQLog(@"rect:%@===",NSStringFromCGRect(allView.frame));
    
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.userInteractionEnabled = NO;
            self.moving = YES;
            [self forbidAllTabViewScroll];// 禁止滚动
            self.pageControl.hidden = YES;
            // 当前页
            NSInteger page = (NSInteger)self.scrollView.contentOffset.x / (self.width-3*Padding);
            // 当前View
            UIView *allView = [self.allViews objectAtIndex:page];
            // cell快照
            _snapedView = nil;
            _snapedView = [allView snapshotViewAfterScreenUpdates:NO];
            
            self.oldAllView = allView;
            self.currentAllView = allView;
            // 设置frame
            
            CGRect rect = [self convertRect:allView.frame fromView:self.scrollView];
            _snapedView.frame = rect;
            // 添加到self 不然无法显示
            [self addSubview:_snapedView];
            //截图后隐藏当前cell(数据源控制隐藏)
            allView.hidden = YES;
            
            // 动画放大和移动到触摸点下面
            [UIView animateWithDuration:0.25 animations:^{
                _snapedView.origin = CGPointMake(point.x - allView.width / 2, point.y);
            }];
            
            if ([self.delegate respondsToSelector:@selector(boardViewWillMoing)]) {
                [self.delegate boardViewWillMoing];
            }
            
            [self _setEdgeTimer];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            if (self.edgeAct) {
                break;
            }
            self.gestureAct = YES;
            // 当前手指在tableView上的点
            _lastPoint = point;
            // 截图视图位置移动
            [UIView animateWithDuration:0.1 animations:^{
                [UIView animateWithDuration:0.25 animations:^{
                    _snapedView.origin = CGPointMake(point.x - self.currentAllView.width / 2, point.y);
                }];
            }];
            
            self.gestureAct = NO;
            
        }
            break;
        default: {
            
            
            self.moving = NO;
            [self AllowAllTabViewScroll];// 允许滚动
            self.pageControl.hidden = NO;
            self.pageControl.currentPage = self.currentAllView.tag;
            // 结束动画过程中停止交互，防止出问题
//            self.userInteractionEnabled = NO;

            // 给截图视图一个动画移动到隐藏cell的新位置
            HQLog(@"拖拽结束时currentAllView位置%@===",NSStringFromCGRect(self.currentAllView.frame));
            
            [UIView animateWithDuration:0.25 animations:^{
                
                _snapedView.center = [self convertPoint:self.currentAllView.center fromView:self.scrollView];
                
                _snapedView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                _snapedView.alpha = 1.0;
            } completion:^(BOOL finished) {
                // 移除截图视图、显示隐藏的cell并开启交互
                [_snapedView removeFromSuperview];
                _snapedView = nil;
                
                if ([self.delegate respondsToSelector:@selector(boardView:dataChanged:destinationIndex:)]) {
                    [self.delegate boardView:self dataChanged:self.models destinationIndex:self.currentAllView.tag];
                }
                
                self.currentAllView = nil;
                self.oldAllView = nil;
                
                for (NSInteger i = 0; i < self.allViews.count; i ++) {
                    UIView *view = self.allViews[i];
                    view.hidden = NO;
                    view.tag = i;
                    
                    for (UIView *subView in view.subviews) {
                        subView.tag = i;
                    }
                }

                for (NSInteger i = 0; i < self.tableViews.count; i ++) {
                    UITableView *view = self.allViews[i];
                    view.tag = i;
                }
                [self loadTableViewRefresh];
                
                self.userInteractionEnabled = YES;

            }];

            // 关闭定时器
            [self _stopEdgeTimer];
            
        }
            break;
    }
}


- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    // 当前页
    NSInteger page = (NSInteger)self.scrollView.contentOffset.x / (self.width-3*Padding);
    // 加号页不执行
    if (self.models.count == page) return;
    
    // self上的一点
    CGPoint point = [longGesture locationInView:self];
    
    if (self.moving) {
        if (self.moveTask) {
            
            [self moveItemWithPoint:point longGesture:longGesture];
        }else{
            
            [self moveAllWithPoint:point longGesture:longGesture];
        }
        
    }else{
        
        if (point.y < 40) {// 移动整体
            if (self.isNotMoveTaskRow) {// 不能移动任务列
                return;
            }
            self.moveTask = NO;
            [self moveAllWithPoint:point longGesture:longGesture];
        }else if (point.y < self.height - 40){// 移动任务
            self.moveTask = YES;
            [self moveItemWithPoint:point longGesture:longGesture];
        }
    }
    
}

/** 将所有cell的隐藏属性改为0 */
-(void)refreshHidden{
    
    for (TFProjectSectionModel *se in self.models) {
        for (TFProjectRowModel *row in se.tasks) {
            
            row.hidden = @"0";
        }
    }
}

/** 跟新数据源 */
- (void)_updateSourceData{
    
    if (self.oldTableView == self.currentTableView) {// 没有切换tableView
        
        NSInteger page = self.currentTableView.tag;
        TFProjectSectionModel *model = self.models[page];
        [model.tasks exchangeObjectAtIndex:self.oldIndexPath.row withObjectAtIndex:self.currentIndexPath.row];
        [model.frames exchangeObjectAtIndex:self.oldIndexPath.row withObjectAtIndex:self.currentIndexPath.row];
        
    }else{
        
        NSInteger page = self.oldTableView.tag;
        TFProjectSectionModel *model = self.models[page];
        
        TFProjectRowModel *row = [model.tasks objectAtIndex:self.oldIndexPath.row];
        TFProjectRowFrameModel *frame = [model.frames objectAtIndex:self.oldIndexPath.row];
        
        // 删除tableView的数据
        [model.tasks removeObjectAtIndex:self.oldIndexPath.row];
        [model.frames removeObjectAtIndex:self.oldIndexPath.row];
        
        // 插入该条数据到currentTableView
        NSInteger page1 = self.currentTableView.tag;
        TFProjectSectionModel *model1 = self.models[page1];
        
        if (!model1.tasks) {
            model1.tasks = [NSMutableArray<TFProjectRowModel> array];
            [model1.tasks addObject:row];
        }else if (model1.tasks.count <= self.currentIndexPath.row){
            [model1.tasks addObject:row];
        }else{
            [model1.tasks insertObject:row atIndex:self.currentIndexPath.row];
        }
        if (!model1.frames) {
            model1.frames = [NSMutableArray array];
            [model1.frames addObject:frame];
        }else if (model1.frames.count <= self.currentIndexPath.row){
            [model1.frames addObject:frame];
        }else{
            [model1.frames insertObject:frame atIndex:self.currentIndexPath.row];
        }
        [self.currentTableView reloadData];
        [self.oldTableView reloadData];
    }
}
/** 找到需移动的cell */
- (nullable NSIndexPath *)_getChangedIndexPath {
    __block NSIndexPath *index = nil;
    CGPoint point1 = [self.longGesture locationInView:self];
    // tableView上对应的点
    CGPoint point = [self convertPoint:point1 toView:self.currentTableView];
    
    // 遍历拖拽的Cell的中心点在哪一个Cell里
    [[self.currentTableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            index = [self.currentTableView indexPathForCell:obj];
            *stop = YES;
        }
    }];
    // 找到而且不是当前的Cell就返回此 index
    if (index) {
        if ((index.section == self.oldIndexPath.section) && (index.row == self.oldIndexPath.row)) {
            return nil;
        }
        return index;
    }
    
    // 获取最应该交换的Cell
    __block CGFloat width = MAXFLOAT;
    __weak typeof(self) weakSelf = self;
    [[self.currentTableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            index = [self.currentTableView indexPathForCell:obj];
            *stop = YES;
        }
        __strong typeof(weakSelf) self = weakSelf;
        CGPoint p1 = self.snapedView.center;
        CGPoint p2 = obj.center;
        // 计算距离
        CGFloat distance = sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));
        if (distance < width) {
            width = distance;
            index = [self.currentTableView indexPathForCell:obj];
        }
    }];
    if (!index) {
        return nil;
    }
    if ((index.section == self.oldIndexPath.section) && (index.row == self.oldIndexPath.row)) {
        // 最近的就是隐藏的Cell时,return nil
        return nil;
    }
    return index;
}

- (void)_setEdgeTimer{
    if (!_edgeTimer) {
        HQLog(@"我开启了定时///////");
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(_edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)_stopEdgeTimer{
    if (_edgeTimer) {
        HQLog(@"我关闭了定时*********");
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}

-(void)_edgeScroll{
    
    if (self.gestureAct) {
        return;
    }
    
    if (self.moveTask) {// 移动任务
        [self moveDirectionItem];
    }else{// 移动所有
        [self moveDirectionAll];
    }
    
}



- (void)moveDirectionAll{
    
    TFMoveViewScrollDirection scrollDirection = [self _setScrollDirectionAll];
    switch (scrollDirection) {
        case TFMoveViewScrollDirectionLeft:
        {
            self.edgeAct = YES;
            
            self.currentAllView = self.allViews[self.currentAllView.tag - 1];
            
            // 换页切换页码
            if ([self.delegate respondsToSelector:@selector(boardView:changePage:)]) {
                [self.delegate boardView:self changePage:self.currentAllView.tag];
            }
            
            // scrollView滚动
            CGRect oldRect = self.oldAllView.frame;
            CGRect currentRect = self.currentAllView.frame;
            self.oldAllView.frame = currentRect;
            
            [UIView animateWithDuration:0.5 animations:^{
                //                HQLog(@"我向左来了------");
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - (self.width-3*Padding), 0);
                
                self.currentAllView.frame = oldRect;
                
            } completion:^(BOOL finished) {
                
                [self.models exchangeObjectAtIndex:self.oldAllView.tag withObjectAtIndex:self.currentAllView.tag];
                [self.allViews exchangeObjectAtIndex:self.oldAllView.tag withObjectAtIndex:self.currentAllView.tag];
                
                NSInteger tag = self.currentAllView.tag;
                
                self.currentAllView = self.allViews[tag];
                
                self.oldAllView = self.currentAllView;
                
                for (NSInteger i = 0; i < self.allViews.count; i ++) {
                    UIView *view = self.allViews[i];
                    view.tag = i;
                    
                    for (UIView *subView in view.subviews) {
                        subView.tag = i;
                    }
                }
                
                
                if (_snapedView) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self _setEdgeTimer];
                    });
                }
                self.userInteractionEnabled = YES;
                self.edgeAct = NO;
            }];
            
        }
            break;
        case TFMoveViewScrollDirectionRight:
        {
            self.edgeAct = YES;
            self.currentAllView = self.allViews[self.currentAllView.tag + 1];
            
            // 换页切换页码
            if ([self.delegate respondsToSelector:@selector(boardView:changePage:)]) {
                [self.delegate boardView:self changePage:self.currentAllView.tag];
            }
            
            
            // 结束动画过程中停止交互，防止出问题
            //            self.userInteractionEnabled = NO;
            // scrollView滚动
            CGRect oldRect = self.oldAllView.frame;
            CGRect currentRect = self.currentAllView.frame;
            self.oldAllView.frame = currentRect;
            [UIView animateWithDuration:0.5 animations:^{
                
                //                HQLog(@"我向右来了++++++++");
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + (self.width-3*Padding), 0);
                
                self.currentAllView.frame = oldRect;
                
            } completion:^(BOOL finished) {
                
                // 更新
                [self.models exchangeObjectAtIndex:self.oldAllView.tag withObjectAtIndex:self.currentAllView.tag];
                [self.allViews exchangeObjectAtIndex:self.oldAllView.tag withObjectAtIndex:self.currentAllView.tag];
                
                NSInteger tag = self.currentAllView.tag;
                
                self.currentAllView = self.allViews[tag];
                
                self.oldAllView = self.currentAllView;
                
                for (NSInteger i = 0; i < self.allViews.count; i ++) {
                    UIView *view = self.allViews[i];
                    view.tag = i;
                    
                    for (UIView *subView in view.subviews) {
                        subView.tag = i;
                    }
                }
                
                if (_snapedView) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self _setEdgeTimer];
                    });
                }
                self.userInteractionEnabled = YES;
                self.edgeAct = NO;
            }];
            
        }
            break;
        
        default:
            break;
    }
    
    if (scrollDirection == TFMoveViewScrollDirectionNone) {
        return;
    }
    
}


- (void)moveDirectionItem{
    
    TFMoveViewScrollDirection scrollDirection = [self _setScrollDirectionItem];
    switch (scrollDirection) {
        case TFMoveViewScrollDirectionLeft:
        {
            self.edgeAct = YES;
            
            self.currentTableView = self.tableViews[self.currentTableView.tag - 1];
            
            // 换页切换页码
            if ([self.delegate respondsToSelector:@selector(boardView:changePage:)]) {
                [self.delegate boardView:self changePage:self.currentTableView.tag];
            }
            
            // tableView上对应的点
            CGPoint tablePoint = [self convertPoint:CGPointMake(_snapedView.center.x - (self.width-3*Padding)/2, _snapedView.center.y) toView:self.currentTableView];
            // 该点在tableView上对应的indexPath
            NSIndexPath *indexPath = [self.currentTableView indexPathForRowAtPoint:tablePoint];
            if (indexPath == nil) {// self.currentTableView 无cell
                self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }else{
                self.currentIndexPath = indexPath;
            }
            
            // 更新
            [self _updateSourceData];
            
            // 结束动画过程中停止交互，防止出问题
            //            self.userInteractionEnabled = NO;
            // scrollView滚动
            [UIView animateWithDuration:0.5 animations:^{
                //                HQLog(@"我向左来了------");
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - (self.width-3*Padding), 0);
            } completion:^(BOOL finished) {
                self.oldIndexPath = self.currentIndexPath;
                self.oldTableView = self.currentTableView;
                //                HQLog(@"我向左来了snapedView.center:%@",NSStringFromCGPoint(_snapedView.center));
                if (_snapedView) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self _setEdgeTimer];
                    });
                }
                self.userInteractionEnabled = YES;
                self.edgeAct = NO;
            }];
            
        }
            break;
        case TFMoveViewScrollDirectionRight:
        {
            self.edgeAct = YES;
            self.currentTableView = self.tableViews[self.currentTableView.tag + 1];
            
            // 换页切换页码
            if ([self.delegate respondsToSelector:@selector(boardView:changePage:)]) {
                [self.delegate boardView:self changePage:self.currentTableView.tag];
            }
            
            // tableView上对应的点
            CGPoint tablePoint = [self convertPoint:CGPointMake(_snapedView.center.x + (self.width-3*Padding)/2, _snapedView.center.y) toView:self.currentTableView];
            // 该点在tableView上对应的indexPath
            NSIndexPath *indexPath = [self.currentTableView indexPathForRowAtPoint:tablePoint];
            
            if (indexPath == nil) {// self.currentTableView 无cell
                self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }else{
                self.currentIndexPath = indexPath;
            }
            // 更新
            [self _updateSourceData];
            
            // 结束动画过程中停止交互，防止出问题
            //            self.userInteractionEnabled = NO;
            // scrollView滚动
            [UIView animateWithDuration:0.5 animations:^{
                
                //                HQLog(@"我向右来了++++++++");
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + (self.width-3*Padding), 0);
            } completion:^(BOOL finished) {
                self.oldIndexPath = self.currentIndexPath;
                self.oldTableView = self.currentTableView;
                //                HQLog(@"我向右来了snapedView.center:%@",NSStringFromCGPoint(_snapedView.center));
                if (_snapedView) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self _setEdgeTimer];
                    });
                }
                self.userInteractionEnabled = YES;
                self.edgeAct = NO;
            }];
            
        }
            break;
        case TFMoveViewScrollDirectionUp:
        {
            // 结束动画过程中停止交互，防止出问题
            self.userInteractionEnabled = NO;
            self.edgeAct = YES;
            
            
            // tableView上对应的点
            CGPoint tablePoint = [self convertPoint:CGPointMake(_snapedView.center.x, _snapedView.center.y - _snapedView.height) toView:self.currentTableView];
            // 该点在tableView上对应的indexPath
            NSIndexPath *indexPath = [self.currentTableView indexPathForRowAtPoint:tablePoint];
            
            if (indexPath == nil) {
                
                self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }else{
                self.currentIndexPath = indexPath;
            }
            
            
            // 更新
            NSInteger page = self.currentTableView.tag;
            TFProjectSectionModel *model = self.models[page];
            [model.tasks exchangeObjectAtIndex:self.oldIndexPath.row withObjectAtIndex:self.currentIndexPath.row];
            [model.frames exchangeObjectAtIndex:self.oldIndexPath.row withObjectAtIndex:self.currentIndexPath.row];
            
            
            [UIView animateWithDuration:0.25 animations:^{
                
                HQLog(@"我向上移动了********%f",self.currentTableView.contentOffset.y > _snapedView.height ? self.currentTableView.contentOffset.y - _snapedView.height : 0);
                
                self.currentTableView.contentOffset = CGPointMake(self.currentTableView.contentOffset.x, self.currentTableView.contentOffset.y > _snapedView.height ? self.currentTableView.contentOffset.y - _snapedView.height : 0);
                
            }completion:^(BOOL finished) {
                
                // 移动 会调用willMoveToIndexPath方法更新数据源
                [self.currentTableView moveRowAtIndexPath:_oldIndexPath toIndexPath:_currentIndexPath];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    // 设置移动后的起始indexPath
                    if (_currentIndexPath && _oldIndexPath) {
                        
                        [self.currentTableView reloadRowsAtIndexPaths:@[_currentIndexPath,_oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                        _oldIndexPath = _currentIndexPath;
                    }
                    
                    self.userInteractionEnabled = YES;
                    self.edgeAct = NO;
                    [self _setEdgeTimer];
                });
                
            }];
            
        }
            break;
        case TFMoveViewScrollDirectionDown:
        {
            // 结束动画过程中停止交互，防止出问题
            self.userInteractionEnabled = NO;
            self.edgeAct = YES;
            
            
            // tableView上对应的点
            CGPoint tablePoint = [self convertPoint:CGPointMake(_snapedView.center.x, _snapedView.center.y + _snapedView.height) toView:self.currentTableView];
            // 该点在tableView上对应的indexPath
            NSIndexPath *indexPath = [self.currentTableView indexPathForRowAtPoint:tablePoint];
            
            // 更新
            NSInteger page = self.currentTableView.tag;
            TFProjectSectionModel *model = self.models[page];
            
            if (indexPath == nil) {
                
                self.currentIndexPath = [NSIndexPath indexPathForRow:model.tasks.count-1 inSection:0];
            }else{
                self.currentIndexPath = indexPath;
            }
            
            [model.tasks exchangeObjectAtIndex:self.oldIndexPath.row withObjectAtIndex:self.currentIndexPath.row];
            [model.frames exchangeObjectAtIndex:self.oldIndexPath.row withObjectAtIndex:self.currentIndexPath.row];
            
            
            [UIView animateWithDuration:0.25 animations:^{
                
                HQLog(@"我向下移动了********%f",self.currentTableView.contentOffset.y + _snapedView.height > self.currentTableView.contentSize.height ? self.currentTableView.contentSize.height : self.currentTableView.contentOffset.y + _snapedView.height);
                
                self.currentTableView.contentOffset = CGPointMake(self.currentTableView.contentOffset.x, self.currentTableView.contentOffset.y + _snapedView.height > self.currentTableView.contentSize.height ? self.currentTableView.contentSize.height : self.currentTableView.contentOffset.y + _snapedView.height);
                
            }completion:^(BOOL finished) {
                
                // 移动 会调用willMoveToIndexPath方法更新数据源
                [self.currentTableView moveRowAtIndexPath:_oldIndexPath toIndexPath:_currentIndexPath];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    // 设置移动后的起始indexPath
                    
                    if (_currentIndexPath && _oldIndexPath) {
                        
                        [self.currentTableView reloadRowsAtIndexPaths:@[_currentIndexPath,_oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                        _oldIndexPath = _currentIndexPath;
                    }
                    
                    self.userInteractionEnabled = YES;
                    self.edgeAct = NO;
                    [self _setEdgeTimer];
                });
                
            }];
            
        }
            break;
            
        default:
            break;
    }
    
    if (scrollDirection == TFMoveViewScrollDirectionNone) {
        return;
    }
    
}


// 处理临界点问题
- (TFMoveViewScrollDirection)_setScrollDirectionItem {
    
    CGPoint snapeViewCenter = _snapedView.center;// 中心点
    CGPoint snapeViewCenterUpCorner = CGPointMake(_snapedView.origin.x + _snapedView.width/2, _snapedView.origin.y);// 中上角
    CGPoint snapeviewCenterDownCorner = CGPointMake(_snapedView.origin.x + _snapedView.width/2, _snapedView.origin.y + _snapedView.height);// 中下角
    //    HQLog(@"==========%@=======",NSStringFromCGPoint(_snapedView.center));
    
    if (snapeviewCenterDownCorner.y > self.height+10) {
        // 需要判断是否为最后一个，最后一个不需在移动
        // 怎么判断为最后一个呢？
        TFProjectSectionModel *ssection = self.models[self.currentTableView.tag];
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:ssection.tasks.count-1 inSection:0];
        UITableViewCell *lastCell = [self.currentTableView cellForRowAtIndexPath:lastPath];// 最后一个cell
        UITableViewCell *currentCell = [self.currentTableView cellForRowAtIndexPath:self.currentIndexPath];// 当前移动的cell
        HQLog(@"下移动contentOffset.y = %f",self.currentTableView.contentOffset.y);
        // 存在
        if (lastCell == currentCell || self.currentTableView.contentOffset.y   + self.currentTableView.height >= self.currentTableView.contentSize.height) {
            HQLog(@"下移动TFMoveViewScrollDirectionNone");
            
            return TFMoveViewScrollDirectionNone;
        }else{
            
            HQLog(@"我准备向下移动了*******%@",NSStringFromCGPoint(snapeviewCenterDownCorner));
            [self _stopEdgeTimer];
            return TFMoveViewScrollDirectionDown;
            
        }
        
    } else if (snapeViewCenterUpCorner.y < -10) {
        // 怎么判断为第一个呢？
        UITableViewCell *lastCell = [self.currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];// 最后一个cell
        UITableViewCell *currentCell = [self.currentTableView cellForRowAtIndexPath:self.currentIndexPath];// 当前移动的cell
        HQLog(@"contentOffset.y = %f",self.currentTableView.contentOffset.y);
        // 存在
        if (lastCell == currentCell || self.currentTableView.contentOffset.y  <= 0) {
            
            return TFMoveViewScrollDirectionNone;
            
        }else{
            
            HQLog(@"我准备向上移动了--------%@",NSStringFromCGPoint(snapeViewCenterUpCorner));
            [self _stopEdgeTimer];
            return TFMoveViewScrollDirectionUp;
            
        }
        
        
    } else if (_snapedView && (snapeViewCenter.x > (self.width-3*Padding)-EdgeMargin)) {
        
        if (self.currentTableView.tag != self.models.count-1) {
            //            HQLog(@"我准备向右移动了+++++++%@",NSStringFromCGPoint(_snapedView.center));
            [self _stopEdgeTimer];
            return TFMoveViewScrollDirectionRight;
        }
        
    } else if (_snapedView && (snapeViewCenter.x < EdgeMargin)) {// 因动画有时限，动画完成时销毁_snapedView，定时又是开启的状态时_snapedView的中心为{0，0}，所有当_snapedView存在的时候才能判断是否左移。
        
        if (self.currentTableView.tag != 0) {
            
            //            HQLog(@"我准备向左移动了--------%@",NSStringFromCGPoint(_snapedView.center));
            [self _stopEdgeTimer];
            return TFMoveViewScrollDirectionLeft;
        }
        
    }
    return TFMoveViewScrollDirectionNone;
}


// 处理临界点问题
- (TFMoveViewScrollDirection)_setScrollDirectionAll {
    
    CGFloat ww = _snapedView.width;
    CGFloat rr = _snapedView.origin.x;
    CGPoint snapeViewRightUpCorner = CGPointMake(rr + ww / 2 , _snapedView.origin.y);
    CGPoint snapeviewLeftUpCorner = CGPointMake(rr + ww / 2, _snapedView.origin.y);
    HQLog(@"snapeViewRightUpCorner:%@===",NSStringFromCGPoint(snapeViewRightUpCorner));
    
//    HQLog(@"snapeviewLeftUpCorner:%@===",NSStringFromCGPoint(snapeviewLeftUpCorner));
    if (snapeviewLeftUpCorner.x < EdgeMargin) {
        
        if (self.currentAllView.tag != 0) {
            [self _stopEdgeTimer];
            return TFMoveViewScrollDirectionLeft;
        }
    }
    if (snapeViewRightUpCorner.x > (self.width-3*Padding)-EdgeMargin) {
        
        if (self.currentAllView.tag <= self.allViews.count-2) {
            [self _stopEdgeTimer];
            return TFMoveViewScrollDirectionRight;
        }
    }
    
    return TFMoveViewScrollDirectionNone;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TFProjectSectionModel *model = self.models[tableView.tag];
    return model.tasks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    TFProjectSectionModel *model = self.models[tableView.tag];
    TFProjectRowModel *row = model.tasks[indexPath.row];
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据) */
    if ([row.dataType isEqualToNumber:@2]) {// 任务
        
        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
        cell.frameModel = model.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        cell.delegate = self;
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@1]){// 备忘录
        
        TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
        cell.frameModel = model.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@3]){// 自定义
        
        if (row.rows) {
            
            TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
            cell.frameModel = model.frames[indexPath.row];
            
            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            return cell;
        }
        TFTProjectCustomCell *cell = [TFTProjectCustomCell projectCustomCellWithTableView:tableView];
        cell.frameModel = model.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else{// 审批
        TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
        cell.frameModel = model.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectSectionModel *model = self.models[tableView.tag];
    TFProjectRowModel *row = model.tasks[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(boardView:didClickedItem:)]) {
        [self.delegate boardView:self didClickedItem:row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    TFProjectSectionModel *model = self.models[tableView.tag];
    TFProjectRowFrameModel *frame = model.frames[indexPath.row];
    return frame.cellHeight;
        
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

- (void)loadTableViewRefresh{
    
    for (NSInteger index = 0; index < self.tableViews.count; index ++) {
        UITableView *tableView = self.tableViews[index];
        TFProjectSectionModel *section = self.models[index];
        
        MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
            
            [self.projectTaskBL requsetGetTaskWithSectionId:section.id pageNo:@1 pageSize:@100 rowIndex:index filterParam:nil];
            
        }];
        tableView.mj_header = header;
        
        
//        MJRefreshBackNormalFooter *footer = [TFRefresh footerBackRefreshWithBlock:^{
//
//
//        }];
//        tableView.mj_footer = footer;
        
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"20"]) {// 新增列
            self.type = 1;
        }
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"22"]) {// 移动列
            self.isNotMoveTaskRow = YES;
        }
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"21,23,24"]) {// 编辑，删除，取消关联
            for (UIButton *bbtt in self.menus) {
                bbtt.hidden = YES;
            }
        }
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"25"]) {// 任务新增
            
            for (UILabel *la in self.adds) {
                la.hidden = YES;
            }
            for (UITableView *table in self.tableViews) {
                table.height += 34;
            }
        }
        
        return;
    }
    
    HQCMD cmd = resp.cmdId;
    NSDictionary *dict = resp.body;
    NSArray *datas = [dict valueForKey:@"dataList"];
    NSInteger index = (NSInteger)(cmd - HQCMD_getSectionTask);
    
    UITableView *tableView = self.tableViews[index];
    NSInteger tag = tableView.tag;
    HQLog(@"tag==%ld",tag);
    if ([tableView.mj_header isRefreshing]) {
        [tableView.mj_header endRefreshing];
    }
    [MBProgressHUD hideHUDForView:tableView animated:YES];
    
    TFProjectSectionModel *model = self.models[index];
    
    NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
    NSMutableArray *frames = [NSMutableArray array];
    
    
    for (NSDictionary *taskDict in datas) {
        TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
        
//        TFCustomRowModel *rows = [[TFCustomRowModel alloc] init];
//        NSMutableArray *arr1 = [NSMutableArray array];
//        NSMutableArray *arr2 = [NSMutableArray array];
//        NSMutableArray *arr3 = [NSMutableArray array];
//        for (NSInteger i = 0 ; i < task.row.count; i++) {
//            if (i == 0) {
//                [arr1 addObject:task.row[i]];
//            }else if (i < 4){
//                [arr2 addObject:task.row[i]];
//            }else if (i < 7){
//                [arr3 addObject:task.row[i]];
//            }
//        }
//        rows.row1 = arr1;
//        rows.row2 = arr2;
//        rows.row3 = arr3;
//        task.rows = rows;
        
        [tasks addObject:task];
        
        TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] init];
        frame.projectRow = task;
        [frames addObject:frame];
    }
    
    model.frames = frames;
    model.tasks = tasks;
    
    [self refreshData];
    
}



-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {
        
        [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
        return;
    }

    HQCMD cmd = resp.cmdId;
    NSInteger index = (NSInteger)(cmd - 10000);
    
    UITableView *tableView = self.tableViews[index];
    [MBProgressHUD hideHUDForView:tableView animated:YES];
    if ([tableView.mj_header isRefreshing]) {
        [tableView.mj_header endRefreshing];
    }
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
