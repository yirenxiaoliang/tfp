//
//  TFBenchView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/28.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBenchView.h"
#import "TFProjectSectionModel.h"
#import "TFTaskListCell.h"
#import "HQBaseCell.h"
#import "TFProjectTaskBL.h"
#import "TFRefresh.h"
#import "TFRequest.h"
#import "TFTaskRowNameCell.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFProjectApprovalCell.h"
#import "TFTProjectCustomCell.h"
#import "HQTFNoContentView.h"
#import "TFCachePlistManager.h"
#import "TFNewProjectCustomCell.h"

#define EdgeMargin 50
#define Padding 10

@interface TFBenchView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HQBLDelegate,TFTaskRowNameCellDelegate,TFProjectTaskItemCellDelegate>

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

@property (nonatomic, strong, nullable) NSIndexPath *oldIndexPath;                 ///< 旧的IndexPath
@property (nonatomic, strong, nullable) NSIndexPath *currentIndexPath;             ///< 当前路径

@property (nonatomic, assign) CGPoint oldPoint;                                    ///< 旧的位置
@property (nonatomic, assign) CGPoint lastPoint;

/** 用于控制在执行边缘切换页时不执行手势改变操作 */
@property (nonatomic, assign) BOOL edgeAct;
/** 用于控制在执行手势改变不执行边缘改变操作 */
@property (nonatomic, assign) BOOL gestureAct;


/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** TFRequest */
@property (nonatomic, strong) TFRequest *request;

/** page */
@property (nonatomic, assign) NSInteger page;


@end

@implementation TFBenchView


-(NSMutableArray *)tableViews{
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.projectTaskBL = [TFProjectTaskBL build];
        self.projectTaskBL.delegate = self;
        
        self.request = [TFRequest sharedManager];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(3*Padding/2, Padding, self.width-3*Padding, frame.size.height-10)];
        [self addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.scrollEnabled = NO;
        scrollView.delegate = self;
        scrollView.tag = 0x7788;
        scrollView.backgroundColor = WhiteColor;
        self.scrollView = scrollView;
        scrollView.layer.masksToBounds = NO;
        
        [self addGestureRecognizer:self.longGesture];
        
        UISwipeGestureRecognizer *pan = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
        [pan setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:pan];
        
        
        UISwipeGestureRecognizer *pan1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
        [pan1 setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:pan1];
    }
    return self;
}

- (void)panHandle:(UISwipeGestureRecognizer *)pan{
    
    if (pan.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        if (self.page >= 3) {
            return;
        }
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + (self.width-3*Padding), 0);
        }completion:^(BOOL finished) {
            
            // 当前页
            self.page = self.scrollView.contentOffset.x / (self.width-3*Padding);
            // 换页切换页码
            if ([self.delegate respondsToSelector:@selector(moveView:changePage:)]) {
                [self.delegate moveView:self changePage:self.page];
            }
            
        }];
        
    }
    if (pan.direction == UISwipeGestureRecognizerDirectionRight) {
        
        if (self.page <= 0) {
            return;
        }
        [UIView animateWithDuration:0.25 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - (self.width-3*Padding), 0);
        }completion:^(BOOL finished) {
        
            // 当前页
            self.page = self.scrollView.contentOffset.x / (self.width-3*Padding);
            // 换页切换页码
            if ([self.delegate respondsToSelector:@selector(moveView:changePage:)]) {
                [self.delegate moveView:self changePage:self.page];
            }
        }];
    }
}

/** 加载某列数据 */
- (void)loadDataWithSectionModel:(TFProjectSectionModel *)section index:(NSInteger)index{
    
    if (self.type == 0) {// 时间工作流
        
        NSArray *arr = [TFCachePlistManager getWorkBenchDataWithType:index];
        [self handleDataWithDatas:arr index:index pageInfo:nil];
        
        [self.projectTaskBL requestGetWorkBenchDataWithWorkBenchType:section.id index:index pageNum:section.pageNum pageSize:section.pageSize];
    }else{// 企业工作流
        [self.projectTaskBL requestGetEnterpriseWorkBenchDataWithFlowId:section.key index:index];
    }
}

/** 加载全部数据 */
- (void)loadAllData{
    
    if (self.type == 0) {// 时间工作流
        
        for (NSInteger index = 0; index < self.models.count; index ++) {
            
            NSArray *arr = [TFCachePlistManager getWorkBenchDataWithType:index];
            [self handleDataWithDatas:arr index:index pageInfo:nil];
            
            TFProjectSectionModel *section = self.models[index];
//            [MBProgressHUD showHUDAddedTo:self.tableViews[index] animated:YES];
            [self.projectTaskBL requestGetWorkBenchDataWithWorkBenchType:section.id index:index pageNum:section.pageNum pageSize:section.pageSize];
            
        }
        
    }else{// 企业工作流
        
        for (NSInteger index = 0; index < self.models.count; index ++) {
            TFProjectSectionModel *section = self.models[index];
            
//            [MBProgressHUD showHUDAddedTo:self.tableViews[index] animated:YES];
            [self.projectTaskBL requestGetEnterpriseWorkBenchDataWithFlowId:section.key index:index];
            
        }
        
    }
}


#pragma mark - UIScrollViewDelegate
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//    if (scrollView.tag != 0x7788) {
//        if (decelerate) {
//
//            if ([self.delegate respondsToSelector:@selector(moveView:didEndScrolloWithScrollView:)]) {
//                [self.delegate moveView:self didEndScrolloWithScrollView:scrollView];
//            }
//
//        }
//    }
//}
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    if (scrollView.tag != 0x7788) {
//
//        if ([self.delegate respondsToSelector:@selector(moveView:didEndScrolloWithScrollView:)]) {
//            [self.delegate moveView:self didEndScrolloWithScrollView:scrollView];
//        }
//
//    }
//}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 0x7788) {
        // 当前页
        self.page = self.scrollView.contentOffset.x / (self.width-3*Padding);
        
        if ([self.delegate respondsToSelector:@selector(moveView:changePage:)]) {
            [self.delegate moveView:self changePage:self.page];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(moveView:didEndScrolloWithScrollView:)]) {
            [self.delegate moveView:self didEndScrolloWithScrollView:scrollView];
        }
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag != 0x7788) {
        
        if ([self.delegate respondsToSelector:@selector(moveView:scrollView:)]) {
            [self.delegate moveView:self scrollView:scrollView];
        }
    }
    
}



/** 刷新 */
- (void)refreshData{
    
//    for (TFProjectSectionModel *model in self.models) {
//        for (NSInteger i = 0; i < model.tasks.count; i ++) {
//            TFProjectRowModel *row = model.tasks[i];
//            if ([row.finishType isEqualToNumber:@1]) {
//                [model.tasks removeObjectAtIndex:i];
//                [model.frames removeObjectAtIndex:i];
//                break;
//            }
//        }
//    }
    
    for (NSInteger i = 0; i < self.tableViews.count; i ++) {
        UITableView *tableView = self.tableViews[i];
        TFProjectSectionModel *model = self.models[i];
        if (model.tasks.count) {
            tableView.backgroundView.hidden = YES;
        }else{
            tableView.backgroundView.hidden = NO;
        }
        [tableView reloadData];
        
    }
    
}


/** 初始化 0:任务的移动 1:任务分类及任务列的移动 2:工作台的移动 */
-(void)refreshMoveViewWithModels:(NSMutableArray *)models withType:(NSInteger)type{
    
    self.models = models;
    self.type = type;
    
    self.scrollView.contentSize = CGSizeMake((self.width-3*Padding)*(models.count), self.height-10);
    
    for (UITableView *tableView in self.tableViews) {
        [tableView removeFromSuperview];
    }
    [self.tableViews removeAllObjects];
    
    for (NSInteger i = 0; i < models.count; i ++) {
        
        CGFloat X = (self.width - 3 * Padding) * i + Padding/2;
        CGFloat W = (self.width - 4 * Padding);

        UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRect){X,0,W,self.height-10} style:UITableViewStylePlain];
        tableView.layer.cornerRadius = 4;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.contentInset = UIEdgeInsetsMake(5, 0, -30, 0);
        tableView.backgroundColor = HexColor(0xebeef0);
        [self.scrollView addSubview:tableView];
        [self.tableViews addObject:tableView];
        tableView.tag = i;
        [tableView reloadData];
        
        HQTFNoContentView *noContentView = [HQTFNoContentView noContentView];
        [noContentView setupImageViewRect:(CGRect){15,(tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
        tableView.backgroundView = noContentView;
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight-44-BottomHeight+166}];
        tableView.tableFooterView = view;
        view.hidden = YES;
        
        
        MJRefreshGifHeader *header = [TFRefresh headerGifRefreshWithBlock:^{
            
            TFProjectSectionModel *section = self.models[self.page];
            section.pageNum = @1;
            [self.projectTaskBL requestGetWorkBenchDataWithWorkBenchType:section.id index:self.page pageNum:section.pageNum pageSize:section.pageSize];
            
        }];
        tableView.mj_header = header;
        
        
        MJRefreshAutoNormalFooter *footer = [TFRefresh footerAutoRefreshWithBlock:^{

            TFProjectSectionModel *section = self.models[self.page];
            section.pageNum = @([section.pageNum integerValue] + 1);
            [self.projectTaskBL requestGetWorkBenchDataWithWorkBenchType:section.id index:self.page pageNum:section.pageNum pageSize:section.pageSize];
        }];
        tableView.mj_footer = footer;
    }
    
}



#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    HQCMD cmd = resp.cmdId;
    NSDictionary *dict = resp.body;
    NSArray *datas = [dict valueForKey:@"dataList"];
    NSDictionary *pageInfo = [dict valueForKey:@"pageInfo"];
    NSInteger index = 0;
    if (self.type == 0) {
        index = (NSInteger)(cmd - HQCMD_getWorkBenchTimeData);
    }else{
        index = (NSInteger)(cmd - HQCMD_enterpriseWorkBenchFlowData);
    }
    if (index>=self.tableViews.count) {
        return;
    }
    
    // 处理数据
    [self handleDataWithDatas:datas index:index pageInfo:pageInfo];
    
}

/** 处理某列的数据 */
- (void)handleDataWithDatas:(NSArray *)datas index:(NSInteger)index pageInfo:(NSDictionary *)pageInfo{
    
    UITableView *tableView = self.tableViews[index];
    NSInteger tag = tableView.tag;
    HQLog(@"tag==%ld",tag);
    
    [MBProgressHUD hideHUDForView:tableView animated:YES];
    
    // 下面为数据
    NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
    NSMutableArray *frames = [NSMutableArray array];
    
    CGFloat allHeight = 0;
    for (NSDictionary *taskDict in datas) {
        TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
        
        [tasks addObject:task];
        
        TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] init];
        frame.projectRow = task;
        [frames addObject:frame];
        
        allHeight += frame.cellHeight;
    }
    
    TFProjectSectionModel *model = self.models[index];
    
    if ([tableView.mj_footer isRefreshing]){
        [tableView.mj_footer endRefreshing];
        if (model.frames && model.tasks) {
            [model.frames addObjectsFromArray:frames];
            [model.tasks addObjectsFromArray:tasks];
        }else{
            model.frames = frames;
            model.tasks = tasks;
        }
    }else{
        [tableView.mj_header endRefreshing];
        model.frames = frames;
        model.tasks = tasks;
    }
    
    // 存储工作台某列数据
    [TFCachePlistManager saveWorkBenchDataWithDatas:datas type:index];
    
    if ([[pageInfo valueForKey:@"totalPages"] integerValue] <= [model.pageNum integerValue]) {// 总页数 <= 请求的页码，说明已经加载完数据
       
        [tableView.mj_footer endRefreshingWithNoMoreData];// 没有更多数据
    }else {
        [tableView.mj_footer resetNoMoreData];// 重置上拉
    }
    
    if (allHeight < SCREEN_HEIGHT-NaviHeight-44-BottomHeight+166) {
        tableView.tableFooterView.height = SCREEN_HEIGHT-NaviHeight-44-BottomHeight-allHeight+166;
    }else{
        tableView.tableFooterView.height = 0;
    }
    
    if (tasks.count) {
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    
    [self refreshData];
}


-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    HQCMD cmd = resp.cmdId;
    NSInteger index = 0;
    if (self.type == 0) {
        index = (NSInteger)(cmd - HQCMD_getWorkBenchTimeData);
    }else{
        index = (NSInteger)(cmd - HQCMD_enterpriseWorkBenchFlowData);
    }

    UITableView *tableView = self.tableViews[index];
    if ([tableView.mj_footer isRefreshing]){
        [tableView.mj_footer endRefreshing];
    }else{
        [tableView.mj_header endRefreshing];
    }
    
    [MBProgressHUD hideHUDForView:tableView animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}




-(void)setSelectPage:(NSInteger)selectPage{
    
    _selectPage = selectPage;
    
//    self.scrollView.contentOffset = CGPointMake(selectPage * self.width, 0);
    
    self.scrollView.contentOffset = CGPointMake(selectPage * (self.width-3*Padding), 0);
    self.page = selectPage;
    
    for (UITableView *ta in self.tableViews) {
        ta.scrollEnabled = NO;
    }
    if (selectPage < self.tableViews.count) {
        UITableView *t = [self.tableViews objectAtIndex:selectPage];
        t.scrollEnabled = YES;
        
        TFProjectSectionModel *model = self.models[selectPage];
        if (model.tasks.count < 4) {
            [t setContentOffset:(CGPoint){0,-5}];
        }
        if (model.tasks.count == 0) {
            t.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        }
    }
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

#warning 猜想：在移动cell时，tableView会出现不停指令般的乱闪动，可能的原因是tableView可以滚动所致，当移动时禁止所有的tableView滚动
- (void)forbidAllTabViewScroll{
    
    for (UITableView *tableView in self.tableViews) {
        tableView.scrollEnabled = NO;
    }
}
- (void)ArrowAllTabViewScroll{
    
    for (UITableView *tableView in self.tableViews) {
        tableView.scrollEnabled = NO;
    }
    
    if (self.selectPage < self.tableViews.count) {
        UITableView *t = [self.tableViews objectAtIndex:self.selectPage];
        t.scrollEnabled = YES;
    }
}


#pragma mark - 事件响应

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    // scrollView上的一点
    CGPoint point = [longGesture locationInView:self];
    // 当前页
//    NSInteger page = self.scrollView.contentOffset.x / self.width;
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
            
            self.userInteractionEnabled = NO;
            
            [self forbidAllTabViewScroll];// 禁止滚动
            
            // 记录当前的tableView,开始时老的和新的一样
            self.oldTableView = tableView;
            self.currentTableView = tableView;
            
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
            if ([self.delegate respondsToSelector:@selector(moveViewWillMoing)]) {
                [self.delegate moveViewWillMoing];
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
            
            [self ArrowAllTabViewScroll];// 允许滚动
            
            UITableViewCell *cell = [self.currentTableView cellForRowAtIndexPath:_currentIndexPath];
            
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
                
                if ([self.delegate respondsToSelector:@selector(moveView:dataChanged:destinationIndex:)]) {
                    [self.delegate moveView:self dataChanged:self.models destinationIndex:self.currentTableView.tag];
                }
                
                TFProjectSectionModel *sec = self.models[self.currentTableView.tag];
                TFProjectRowModel *row = sec.tasks[self.currentIndexPath.row];
                
                if ([self.delegate respondsToSelector:@selector(moveView:dataChanged:destinationIndex:moveModel:)]) {
                    
                    [self.delegate moveView:self dataChanged:self.models destinationIndex:self.currentTableView.tag moveModel:row];
                }
                
                // 背景的展示
                for (NSInteger i = 0; i < self.models.count; i ++) {
                    TFProjectSectionModel *mm = self.models[i];
                    UITableView *tab = self.tableViews[i];
                    
                    if (mm.tasks.count) {
                        tab.backgroundView.hidden = YES;
                    }else{
                        tab.backgroundView.hidden = NO;
                    }
                }
                self.page = self.scrollView.contentOffset.x / (self.width-3*Padding);
                self.selectPage = self.page;
            }];
            
            // 关闭定时器
            [self _stopEdgeTimer];
            
        }
            break;
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
    
    TFMoveViewScrollDirection scrollDirection = [self _setScrollDirection];
    switch (scrollDirection) {
        case TFMoveViewScrollDirectionLeft:
        {
            self.edgeAct = YES;
            
            self.currentTableView = self.tableViews[self.currentTableView.tag - 1];
            
            // 换页切换页码
            if ([self.delegate respondsToSelector:@selector(moveView:changePage:)]) {
                [self.delegate moveView:self changePage:self.currentTableView.tag];
            }
            
            // tableView上对应的点
            CGPoint tablePoint = [self convertPoint:CGPointMake(_snapedView.center.x - self.width/2, _snapedView.center.y) toView:self.currentTableView];
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
            if ([self.delegate respondsToSelector:@selector(moveView:changePage:)]) {
                [self.delegate moveView:self changePage:self.currentTableView.tag];
            }
            
            // tableView上对应的点
            CGPoint tablePoint = [self convertPoint:CGPointMake(_snapedView.center.x + self.width/2, _snapedView.center.y) toView:self.currentTableView];
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
            
            if (indexPath == nil) {// self.currentTableView 无cell
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
            
            if (indexPath == nil) {// self.currentTableView 无cell
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
- (TFMoveViewScrollDirection)_setScrollDirection {
    
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
        
        
    } else if (_snapedView && (snapeViewCenter.x > self.width-EdgeMargin)) {
        
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

#pragma mark - TFProjectTaskItemCellDelegate
-(void)projectTaskItemCell:(TFProjectTaskItemCell *)cell didClickedFinishBtnWithModel:(id)model{
    
    if ([self.delegate respondsToSelector:@selector(moveView:didClickedFinishItem:)]) {
        [self.delegate moveView:self didClickedFinishItem:model];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectSectionModel *model = self.models[tableView.tag];
    TFProjectRowModel *row = model.tasks[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(moveView:didClickedItem:)]) {
        [self.delegate moveView:self didClickedItem:row];
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

#pragma mark - TFTaskRowNameCellDelegate
-(void)taskRowNameCellDidMinusBtn:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(moveView:didMinusBtn:models:)]) {
        [self.delegate moveView:self didMinusBtn:button models:self.models];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
