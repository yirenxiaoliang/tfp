//
//  HQTFSeeCollectionView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFSeeCollectionView.h"
#import "HQTFProjectCollectionViewCell.h"

@interface HQTFSeeCollectionView ()
/** HQTFProjectCollectionViewCell *cell */
@property (nonatomic, strong) HQTFProjectCollectionViewCell *currentCollectionCell;

@property (nonatomic, strong) NSIndexPath *originalIndexPath;
@property (nonatomic, strong) NSIndexPath *moveIndexPath;
@property (nonatomic, weak) UIView *tempMoveCell;
@property (nonatomic, strong) CADisplayLink *edgeTimer;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) XWDragCellCollectionViewScrollDirection scrollDirection;
/** UILongPressGestureRecognizer *longPress */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation HQTFSeeCollectionView

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self addGesture];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    
    self = [super initWithCoder:coder];
    if (self) {
        [self addGesture];
    }
    return self;
}


#pragma mark - timer methods

- (void)xwp_setEdgeTimer{
    if (!_edgeTimer) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(xwp_edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)xwp_stopEdgeTimer{
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}
- (void)xwp_edgeScroll{
    [self xwp_setScrollDirection];
    switch (_scrollDirection) {
        case XWDragCellCollectionViewScrollDirectionLeft:{
            //这里的动画必须设为NO
//            [self setContentOffset:CGPointMake(self.contentOffset.x - 4, self.contentOffset.y) animated:NO];
//            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x - 4, _tempMoveCell.center.y);
//            _lastPoint.x -= 4;

        }
            break;
        case XWDragCellCollectionViewScrollDirectionRight:{
//            [self setContentOffset:CGPointMake(self.contentOffset.x + 4, self.contentOffset.y) animated:NO];
//            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x + 4, _tempMoveCell.center.y);
//            _lastPoint.x += 4;
            
        }
            break;
        case XWDragCellCollectionViewScrollDirectionUp:{
            
            [self.currentCollectionCell.tableView setContentOffset:CGPointMake(self.currentCollectionCell.tableView.contentOffset.x, self.currentCollectionCell.tableView.contentOffset.y - 4) animated:NO];
//            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y - 4);
//            _lastPoint.y -= 4;
        }
            break;
        case XWDragCellCollectionViewScrollDirectionDown:{
            
            
//            if (self.currentCollectionCell.tableView.contentOffset.y + self.currentCollectionCell.tableView.height > self.currentCollectionCell.tableView.contentSize.height) {
//                
//                [self.currentCollectionCell.tableView setContentOffset:CGPointMake(self.currentCollectionCell.tableView.contentOffset.x,self.currentCollectionCell.tableView.height) animated:NO];
//            }else{
//                
//                [self.currentCollectionCell.tableView setContentOffset:CGPointMake(self.currentCollectionCell.tableView.contentOffset.x, self.currentCollectionCell.tableView.contentOffset.y + self.currentCollectionCell.tableView.height) animated:NO];
//            }
            
            
            
            
            [self.currentCollectionCell.tableView setContentOffset:CGPointMake(self.currentCollectionCell.tableView.contentOffset.x, self.currentCollectionCell.tableView.contentOffset.y + 4) animated:NO];
            
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y + 4);
            _lastPoint.y += 4;
            
        }
            break;
        default:
            break;
    }
    
}

- (void)xwp_setScrollDirection{
    _scrollDirection = XWDragCellCollectionViewScrollDirectionNone;
    
    
//    if (self.currentCollectionCell.tableView.bounds.size.height + self.currentCollectionCell.tableView.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.bounds.size.height / 2 && self.currentCollectionCell.tableView.bounds.size.height + self.currentCollectionCell.tableView.contentOffset.y < self.currentCollectionCell.tableView.contentSize.height) {
//        _scrollDirection = XWDragCellCollectionViewScrollDirectionDown;
//        
//        HQLog(@"我来了");
//    }
    
    
    HQLog(@"%f===%f===%f===%f===%f===",self.bounds.size.height,self.contentOffset.y,_tempMoveCell.center.y,_tempMoveCell.bounds.size.height / 2,self.contentSize.height);
    
    if (_tempMoveCell.bottom >= self.height) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionDown;
        
//        [self xwp_stopEdgeTimer];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self xwp_setEdgeTimer];
//        });
    }
    
    
//        if (self.currentCollectionCell.tableView.height + self.currentCollectionCell.tableView.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.height / 2 && self.currentCollectionCell.tableView.height + self.currentCollectionCell.tableView.contentOffset.y < self.currentCollectionCell.tableView.contentSize.height) {
//            _scrollDirection = XWDragCellCollectionViewScrollDirectionDown;
//        }
    
    
//    if (_tempMoveCell.center.y-self.currentCollectionCell.tableView.y - self.currentCollectionCell.tableView.contentOffset.y < _tempMoveCell.bounds.size.height / 2 && self.currentCollectionCell.tableView.contentOffset.y > 0) {
//        _scrollDirection = XWDragCellCollectionViewScrollDirectionUp;
//    }
//    
//    if (self.bounds.size.width + self.contentOffset.x - _tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 2 && self.bounds.size.width + self.contentOffset.x < self.contentSize.width) {
//        _scrollDirection = XWDragCellCollectionViewScrollDirectionRight;
//    }
//    
//    if (_tempMoveCell.center.x - self.contentOffset.x < _tempMoveCell.bounds.size.width / 2 && self.contentOffset.x > 0) {
//        _scrollDirection = XWDragCellCollectionViewScrollDirectionLeft;
//    }
}


//- (void)xwp_setScrollDirection{
//    _scrollDirection = XWDragCellCollectionViewScrollDirectionNone;
//    if (self.bounds.size.height + self.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.bounds.size.height / 2 && self.bounds.size.height + self.contentOffset.y < self.contentSize.height) {
//        _scrollDirection = XWDragCellCollectionViewScrollDirectionDown;
//    }
//    if (_tempMoveCell.center.y - self.contentOffset.y < _tempMoveCell.bounds.size.height / 2 && self.contentOffset.y > 0) {
//        _scrollDirection = XWDragCellCollectionViewScrollDirectionUp;
//    }
//    if (self.bounds.size.width + self.contentOffset.x - _tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 2 && self.bounds.size.width + self.contentOffset.x < self.contentSize.width) {
//        _scrollDirection = XWDragCellCollectionViewScrollDirectionRight;
//    }
//    
//    if (_tempMoveCell.center.x - self.contentOffset.x < _tempMoveCell.bounds.size.width / 2 && self.contentOffset.x > 0) {
//        _scrollDirection = XWDragCellCollectionViewScrollDirectionLeft;
//    }
//}


/**
 *  添加一个自定义的滑动手势
 */
- (void)addGesture{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.longPress = longPress;
    [self addGestureRecognizer:longPress];
}



/**
 *  监听手势的改变
 */
- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self gestureBegan:longPress];
    }
    if (longPress.state == UIGestureRecognizerStateChanged) {
        [self gestureChange:longPress];
    }
    if (longPress.state == UIGestureRecognizerStateCancelled ||
        longPress.state == UIGestureRecognizerStateEnded){
        [self gestureEndOrCancle:longPress];
    }
}


/**
 *  手势开始
 */
- (void)gestureBegan:(UILongPressGestureRecognizer *)longPress{
    // 触摸的点
    CGPoint point = [longPress locationOfTouch:0 inView:longPress.view];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    HQTFProjectCollectionViewCell *cell = (HQTFProjectCollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
    self.currentCollectionCell = cell;
    
    point = CGPointMake(point.x - self.width *(cell.tag -0x999), point.y);
    
    CGPoint tablePoint = [cell convertPoint:point toView:cell.tableView];
    
    HQLog(@"%@",NSStringFromCGPoint(tablePoint));
    
    _originalIndexPath = [cell.tableView indexPathForRowAtPoint:tablePoint];
    UITableViewCell *tableCell = [cell.tableView cellForRowAtIndexPath:_originalIndexPath];
    
    UIView *tempMoveCell = [tableCell snapshotViewAfterScreenUpdates:YES];
    tableCell.hidden = YES;
    _tempMoveCell = tempMoveCell;
    
    CGRect rect = [tableCell convertRect:tableCell.frame toView:self];
    CGPoint center = [tableCell convertPoint:tableCell.center toView:self];
    
//    _tempMoveCell.frame = cell.frame;
//    self.originalCenter = cell.center;
    
    _tempMoveCell.frame = rect;
    self.originalCenter = center;
    
    tempMoveCell.transform = CGAffineTransformRotate(cell.transform, M_PI/18);
    [self addSubview:_tempMoveCell];
    _lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
//
//    
    //开启边缘滚动定时器
    [self xwp_setEdgeTimer];
    //通知代理
    //    if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:cellWillBeginMoveAtIndexPath:)]) {
    //        [self.delegate dragCellCollectionView:self cellWillBeginMoveAtIndexPath:_originalIndexPath];
    //    }

}
/**
 *  手势拖动
 */
- (void)gestureChange:(UILongPressGestureRecognizer *)longPress{
    
    CGFloat tranX = [longPress locationOfTouch:0 inView:longPress.view].x - _lastPoint.x;
    CGFloat tranY = [longPress locationOfTouch:0 inView:longPress.view].y - _lastPoint.y;
    _tempMoveCell.center = CGPointApplyAffineTransform(_tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
    HQLog(@"_tempMoveCell.center:%@",NSStringFromCGPoint(_tempMoveCell.center));
    _lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
    HQLog(@"_lastPoint:%@",NSStringFromCGPoint(_lastPoint));
    
    [self xwp_moveCell];
}

/**
 *  手势取消或者结束
 */
- (void)gestureEndOrCancle:(UILongPressGestureRecognizer *)longPress{
    UITableViewCell *cell = [self.currentCollectionCell.tableView cellForRowAtIndexPath:_originalIndexPath];
    self.userInteractionEnabled = NO;
    cell.transform = CGAffineTransformIdentity;
    
    
    // 停止tableView边界定时器
    [self xwp_stopEdgeTimer];
    //通知代理
    //    if ([self.delegate respondsToSelector:@selector(dragCellCollectionViewCellEndMoving:)]) {
    //        [self.delegate dragCellCollectionViewCellEndMoving:self];
    //    }
    
    //通知代理
    //    if ([self.delegate respondsToSelector:@selector(dragCellCollectionViewCellEndMoving:cellMoveAtIndexPath:)]) {
    //        [self.delegate dragCellCollectionViewCellEndMoving:self cellMoveAtIndexPath:_originalIndexPath];
    //    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _tempMoveCell.center = cell.center;
    } completion:^(BOOL finished) {
        
        [_tempMoveCell removeFromSuperview];
        
        self.userInteractionEnabled = YES;
        cell.hidden = NO;
        
        //        HQLog(@"%@--------%@*************", NSStringFromCGPoint(self.originalCenter), NSStringFromCGPoint(_tempMoveCell.center));
        //        if ([NSStringFromCGPoint(self.originalCenter) isEqualToString:NSStringFromCGPoint(_tempMoveCell.center)]) {
        //
        //            if (self.type < 2) {
        //                cell.minusButton.hidden = NO;
        //                cell.backgroundColor = HexColor(0x000000, 0.05);
        //            }else if (self.type == 2){
        //                cell.minusButton.hidden = YES;
        //            }else if (self.type == 3){
        //                cell.minusButton.hidden = NO;
        //            }
        //
        //            cell.rootModel.backColor = YES;
        //        }else{
        //
        //            cell.minusButton.hidden = NO;
        //            cell.backgroundColor = [UIColor clearColor];
        //            cell.rootModel.backColor = NO;
        //        }
    }];
}


- (void)xwp_moveCell{
    
    
    
    for (UITableViewCell *cell in [self.currentCollectionCell.tableView visibleCells]) {
        if ([self.currentCollectionCell.tableView indexPathForCell:cell] == _originalIndexPath) {
            UITableViewCell *cell = [self.currentCollectionCell.tableView cellForRowAtIndexPath:_originalIndexPath];
            cell.hidden = YES;
            continue;
        }
        //计算中心距
        CGFloat spacingX = fabs(_tempMoveCell.center.x - cell.center.x);
        CGFloat spacingY = fabs(_tempMoveCell.center.y - cell.center.y);
        if (spacingX <= _tempMoveCell.bounds.size.width / 2.0f && spacingY <= _tempMoveCell.bounds.size.height / 2.0f) {
            _moveIndexPath = [self.currentCollectionCell.tableView indexPathForCell:cell];
            
            //            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_moveIndexPath];
            
            
            //更新数据源
            [self xwp_updateDataSource];
            //移动
            [self.currentCollectionCell.tableView moveRowAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
            
            //通知代理
            //            if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:moveCellFromIndexPath:toIndexPath:)]) {
            //                [self.delegate dragCellCollectionView:self moveCellFromIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
            //            }
            //设置移动后的起始indexPath
            _originalIndexPath = _moveIndexPath;
            
            UITableViewCell *cell = [self.currentCollectionCell.tableView cellForRowAtIndexPath:_originalIndexPath];
            cell.hidden = YES;
            break;
        }
    }
}

/**
 *  更新数据源
 */
- (void)xwp_updateDataSource{
    NSMutableArray *temp = @[].mutableCopy;
    //获取数据源
//    if ([self.delegate respondsToSelector:@selector(dataSourceArrayOfProjectCollectionViewCell:)]) {
//        [temp addObjectsFromArray:[self.delegate dataSourceArrayOfProjectCollectionViewCell:self]];
//    }
    [temp addObjectsFromArray:self.currentCollectionCell.taskList];
    
    //判断数据源是单个数组还是数组套数组的多section形式，YES表示数组套数组
    BOOL dataTypeCheck = ([self.currentCollectionCell.tableView numberOfSections] != 1 || ([self.currentCollectionCell.tableView numberOfSections] == 1 && [temp[0] isKindOfClass:[NSArray class]]));
    if (dataTypeCheck) {
        for (int i = 0; i < temp.count; i ++) {
            [temp replaceObjectAtIndex:i withObject:[temp[i] mutableCopy]];
        }
    }
    if (_moveIndexPath.section == _originalIndexPath.section) {
        NSMutableArray *orignalSection = dataTypeCheck ? temp[_originalIndexPath.section] : temp;
        if (_moveIndexPath.item > _originalIndexPath.item) {
            for (NSUInteger i = _originalIndexPath.item; i < _moveIndexPath.item ; i ++) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        }else{
            for (NSUInteger i = _originalIndexPath.item; i > _moveIndexPath.item ; i --) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
    }else{
        
        NSMutableArray *orignalSection = temp[_originalIndexPath.section];
        NSMutableArray *currentSection = temp[_moveIndexPath.section];
        [currentSection insertObject:orignalSection[_originalIndexPath.item] atIndex:_moveIndexPath.item];
        [orignalSection removeObject:orignalSection[_originalIndexPath.item]];
        
    }
    //将重排好的数据传递给外部
    //    if ([self.delegate respondsToSelector:@selector(dragProjectCollectionViewCell:newDataArrayAfterMove:)]) {
    //        [self.delegate dragProjectCollectionViewCell:self newDataArrayAfterMove:temp.copy];
    //    }
    self.currentCollectionCell.taskList = temp.copy;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
