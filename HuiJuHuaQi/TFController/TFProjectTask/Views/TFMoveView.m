//
//  TFMoveView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMoveView.h"
#import "TFProjectSectionModel.h"
#import "TFTaskListCell.h"
#import "HQBaseCell.h"
#import "TFProjectTaskBL.h"
#import "TFRefresh.h"
#import "TFRequest.h"
#import "TFTaskRowNameCell.h"
#import "TFProjectTaskItemCell.h"

#define EdgeMargin 50

@interface TFMoveView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HQBLDelegate,TFTaskRowNameCellDelegate>

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

/** type 0:任务的移动 1:任务分类及任务列的移动 2:工作台的移动 */
@property (nonatomic, assign) NSInteger type;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** TFRequest */
@property (nonatomic, strong) TFRequest *request;

/** frameModels */
@property (nonatomic, strong) NSMutableArray *frameModels;


@end

@implementation TFMoveView

-(NSMutableArray *)frameModels{
    if (!_frameModels) {
        _frameModels = [NSMutableArray array];
    }
    return _frameModels;
}

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
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        scrollView.tag = 0x7788;
        scrollView.backgroundColor = WhiteColor;
        self.scrollView = scrollView;
        
        [self addGestureRecognizer:self.longGesture];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 0x7788) {
        // 当前页
        NSInteger page = self.scrollView.contentOffset.x / self.width;
        
        if ([self.delegate respondsToSelector:@selector(moveView:changePage:)]) {
            [self.delegate moveView:self changePage:page];
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
    
    for (UITableView *tableView in self.tableViews) {
        
        [tableView reloadData];
    }
    
}


/** 初始化 0:任务的移动 1:任务分类及任务列的移动 2:工作台的移动 */
-(void)refreshMoveViewWithModels:(NSMutableArray *)models withType:(NSInteger)type{
    
    self.models = models;
    self.type = type;
    
    
    self.scrollView.contentSize = CGSizeMake(self.width * models.count, self.height);
    
    for (UITableView *tableView in self.tableViews) {
        [tableView removeFromSuperview];
    }
    [self.tableViews removeAllObjects];
    
    for (NSInteger i = 0; i < models.count; i ++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.width * i, 0, self.width, self.height) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        if (self.type != 1) {
            tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
        }else{
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
//        tableView.backgroundColor = HexColor(0xfafafa);
        tableView.backgroundColor = HexColor(0xebeef0);
//        tableView.backgroundColor = RedColor;
        [self.scrollView addSubview:tableView];
        [self.tableViews addObject:tableView];
        tableView.tag = i;
        [tableView reloadData];
        
//        if (self.type == 0) {
//
//            tableView.mj_header = [TFRefresh headerGifRefreshWithBlock:^{
//
//
//                [self.request requestGET:@""
//                              parameters:@{}
//                                progress:^(NSProgress *progress) {
//
//                                } success:^(id response) {
//
//                                } failure:^(NSError *error) {
//
//                                }];
//
//                HQLog(@"I'm header refresh!");
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [tableView.mj_header endRefreshing];
//                });
//            }];
//            tableView.mj_footer = [TFRefresh footerBackRefreshWithBlock:^{
//
//                HQLog(@"I'm footer refresh!");
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [tableView.mj_footer endRefreshing];
//                });
//
//            }];
//        }
        
        
    }
    
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.currentTableView.mj_footer endRefreshing];
    [self.currentTableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}



-(void)setSelectPage:(NSInteger)selectPage{
    
    _selectPage = selectPage;
    
    self.scrollView.contentOffset = CGPointMake(selectPage * self.width, 0);
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
        tableView.scrollEnabled = YES;
    }
}


#pragma mark - 事件响应

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    // scrollView上的一点
    CGPoint point = [longGesture locationInView:self];
    // 当前页
    NSInteger page = self.scrollView.contentOffset.x / self.width;
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
        
    }else{
        
        NSInteger page = self.oldTableView.tag;
        TFProjectSectionModel *model = self.models[page];
        
        TFProjectRowModel *row = [model.tasks objectAtIndex:self.oldIndexPath.row];
        
        // 删除tableView的数据
        [model.tasks removeObjectAtIndex:self.oldIndexPath.row];
        
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
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - self.width, 0);
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
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.width, 0);
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
    
    if (self.type == 0) {
        
        TFProjectSectionModel *model = self.models[tableView.tag];
        TFProjectRowModel *row = model.tasks[indexPath.row];
        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
        cell.frameModel = model.frames[indexPath.row];
        
        if ([row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        
        return cell;
        
//        TFTaskListCell *cell = [TFTaskListCell taskListCellWithTableView:tableView];
//
//        cell.tag = indexPath.row;
//        TFProjectSectionModel *model = self.models[tableView.tag];
//        TFProjectRowModel *row = model.tasks[indexPath.row];
//
//        if ([row.hidden isEqualToString:@"0"]) {
//            cell.hidden = NO;
//        }else{
//            cell.hidden = YES;
//        }
//
//        return cell;
        
    }else if (self.type == 1){
        TFTaskRowNameCell *cell = [TFTaskRowNameCell taskRowNameCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.bottomLine.hidden = NO;
        cell.tag = indexPath.row;
        TFProjectSectionModel *model = self.models[tableView.tag];
        TFProjectRowModel *row = model.tasks[indexPath.row];
        if ([row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        cell.delegate = self;
        cell.moveImage.hidden = NO;
        cell.textField.text = row.name;
        cell.textHeadW.constant = 30;
        cell.textField.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.minusBtn.tag = indexPath.row;
        return cell;
    }else{
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.tag = indexPath.row;
        TFProjectSectionModel *model = self.models[tableView.tag];
        TFProjectRowModel *row = model.tasks[indexPath.row];
        if ([row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        
        cell.textLabel.text = @"ewcfds";
        return cell;
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
    
    if (self.type == 0) {
        
        TFProjectSectionModel *model = self.models[tableView.tag];
        TFProjectRowFrameModel *frame = model.frames[indexPath.row];
        return frame.cellHeight;
        
    }else if (self.type == 1){
        
        return 60;
    }else{
        
        return 140;
    }
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
