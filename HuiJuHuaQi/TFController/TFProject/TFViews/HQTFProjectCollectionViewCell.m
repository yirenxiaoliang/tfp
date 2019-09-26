//
//  HQTFProjectCollectionViewCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectCollectionViewCell.h"
#import "UITableView+Extension.h"
#import "HQTFCrmTableViewCell.h"
#import "HQTFTaskTableViewCell.h"



@interface HQTFProjectCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,HQTFTaskTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLable;
@property (weak, nonatomic) IBOutlet UIButton *createTaskBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressW;


@property (nonatomic, strong) NSIndexPath *originalIndexPath;
@property (nonatomic, strong) NSIndexPath *moveIndexPath;
@property (nonatomic, weak) UIView *tempMoveCell;
@property (nonatomic, strong) CADisplayLink *edgeTimer;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) XWDragCellCollectionViewScrollDirection scrollDirection;
/** longPress */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation HQTFProjectCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 4;
    self.titleBgView.backgroundColor = HexColor(0xe7e7e7);
    
    self.progressBgView.backgroundColor = HexColor(0xc8cfd8);
    self.progressView.backgroundColor = GreenColor;
    self.progressBgView.layer.cornerRadius = 4;
    self.progressBgView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius = 4;
    self.progressView.layer.masksToBounds = YES;
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.jumpBtn.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView setExtraCellLineHidden:self.tableView];
    
    UIView *view = [[UIView alloc] init];
    [self.bgView insertSubview:view atIndex:0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleBgView.bottom - 4);
        make.left.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.bgView);
    }];
    view.backgroundColor = HexColor(0xe7e7e7);
    
    self.bgView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.jumpBtn addTarget:self action:@selector(jumpClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpClick)];
    [self.titleLabel addGestureRecognizer:tap];
    
    [self.createTaskBtn setTitle:@"+新建任务" forState:UIControlStateNormal];
    [self.createTaskBtn setTitle:@"+新建任务" forState:UIControlStateHighlighted];
    [self.createTaskBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    [self.createTaskBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [self.createTaskBtn addTarget:self action:@selector(createTaskBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.progressLable.attributedText = [self attributeStringWithFinishTask:21 withTotalTask:26];
    
    self.progressView.hidden = YES;
}

- (void)refreshProjectCollectionViewCellWithModel:(TFProjectSeeModel *)model{
    
    self.titleLabel.text = model.listName;
    
    self.progressLable.attributedText = [self attributeStringWithFinishTask:[model.listTaskFinishCount integerValue] withTotalTask:[model.listTaskCount integerValue]];
    
    if ([model.listTaskCount integerValue]) {
        
        self.progressW.constant = (SCREEN_WIDTH-85-40) * ([model.listTaskFinishCount integerValue] * 1.0/[model.listTaskCount integerValue]);
        
        self.progressView.hidden = NO;
    }else{
        self.progressW.constant = 0;
        self.progressView.hidden = YES;
    }
    
}

-(NSAttributedString *)attributeStringWithFinishTask:(NSInteger)finish withTotalTask:(NSInteger)total{
    
    NSString *totalString = [NSString stringWithFormat:@"%ld/%ld",finish,total];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:totalString];
    [string addAttribute:NSForegroundColorAttributeName value:GreenColor range:[totalString rangeOfString:[NSString stringWithFormat:@"%ld",finish]]];
    [string addAttribute:NSForegroundColorAttributeName value:LightGrayTextColor range:[totalString rangeOfString:[NSString stringWithFormat:@"/%ld",total]]];
    [string addAttribute:NSFontAttributeName value:FONT(12) range:(NSRange){0,totalString.length}];
    
    return string;
}


- (void)createTaskBtnClicked{
    
    if ([self.delegate respondsToSelector:@selector(projectCollectionViewCellDidclickedCreateTask)]) {
        [self.delegate projectCollectionViewCellDidclickedCreateTask];
    }
}


-(void)setGestureEnable:(BOOL)gestureEnable{
    _gestureEnable = gestureEnable;
    
    if (gestureEnable) {
        
        self.tableView.layer.masksToBounds = NO;
        self.contentView.layer.masksToBounds = NO;
        self.layer.masksToBounds = NO;
        
        // 初始化加入手势
        [self addGreture];
    }
}


#pragma mark - greture 
- (void)addGreture{
    // 添加手势
    if (self.longPress == nil) {
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        self.longPress = longPress;
        [self.tableView addGestureRecognizer:longPress];
    }else{
        
        self.longPress.enabled = YES;
    }
}

- (void)removeGreture{
    
    if (self.longPress) {
        self.longPress.enabled = NO;
    }
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
//            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x - 4, self.tableView.contentOffset.y) animated:NO];
//            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x - 4, _tempMoveCell.center.y);
//            _lastPoint.x -= 4;
            
            if ([self.delegate respondsToSelector:@selector(dragLeftOrRightWithProjectCollectionViewCell:withMoveCell:withDirection:moveCellCenter:withModel:)]) {
                
                // 停止定时器
                [self xwp_stopEdgeTimer];
                // 停止手势
//                [self removeGreture];
                // 一秒钟后再打开
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self xwp_setEdgeTimer];
                    [self addGreture];
                });
                
                
                [self.delegate dragLeftOrRightWithProjectCollectionViewCell:self withMoveCell:_tempMoveCell withDirection:_scrollDirection moveCellCenter:_tempMoveCell.center withModel:self.taskList[_originalIndexPath.row]];
            }
            
        }
            break;
        case XWDragCellCollectionViewScrollDirectionRight:{
//            [self setContentOffset:CGPointMake(self.contentOffset.x + 4, self.contentOffset.y) animated:NO];
//            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x + 4, _tempMoveCell.center.y);
//            _lastPoint.x += 4;
            
            // 停止定时器
            [self xwp_stopEdgeTimer];
            // 停止手势
//            [self removeGreture];
            // 一秒钟后再打开
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self xwp_setEdgeTimer];
                [self addGreture];
            });

            
            if ([self.delegate respondsToSelector:@selector(dragLeftOrRightWithProjectCollectionViewCell:withMoveCell:withDirection:moveCellCenter:withModel:)]) {
                
                
                [self.delegate dragLeftOrRightWithProjectCollectionViewCell:self withMoveCell:_tempMoveCell withDirection:_scrollDirection moveCellCenter:_tempMoveCell.center withModel:self.taskList[_originalIndexPath.row]];
            }
            
        }
            break;
        case XWDragCellCollectionViewScrollDirectionUp:{
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y - 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y - 4);
            _lastPoint.y -= 4;
        }
            break;
        case XWDragCellCollectionViewScrollDirectionDown:{
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + 4) animated:NO];
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
    if (self.tableView.bounds.size.height + self.tableView.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.bounds.size.height / 2 && self.tableView.bounds.size.height + self.tableView.contentOffset.y < self.tableView.contentSize.height) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionDown;
    }
    if (_tempMoveCell.center.y - self.tableView.contentOffset.y < _tempMoveCell.bounds.size.height / 2 && self.tableView.contentOffset.y > 0) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionUp;
    }
    if (self.tableView.bounds.size.width - _tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 4 ) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionRight;
    }
    
    if (_tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 4) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionLeft;
    }
}

#pragma mark - 长按手势
- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self longPressBegan:longPress];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            [self longPressChanged:longPress];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
            [self longPressEnded:longPress];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            
            [self longPressEnded:longPress];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)longPressBegan:(UILongPressGestureRecognizer *)longPress{
    //获取手指所在的cell
    _originalIndexPath = [self.tableView indexPathForRowAtPoint:[longPress locationOfTouch:0 inView:longPress.view]];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_originalIndexPath];
    UIView *tempMoveCell = [cell snapshotViewAfterScreenUpdates:YES];
    cell.hidden = YES;
    _tempMoveCell = tempMoveCell;
//    CGRect rect = [cell convertRect:cell.frame toView:self];
//    CGPoint center = [cell convertPoint:cell.center toView:self];
    
    _tempMoveCell.frame = cell.frame;
    self.originalCenter = cell.center;
    
//    _tempMoveCell.frame = rect;
//    self.originalCenter = center;
    
    tempMoveCell.transform = CGAffineTransformRotate(cell.transform, M_PI/18);
    [self.tableView addSubview:_tempMoveCell];
    _lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
    
    
//    //开启边缘滚动定时器
    [self xwp_setEdgeTimer];
    //通知代理
//    if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:cellWillBeginMoveAtIndexPath:)]) {
//        [self.delegate dragCellCollectionView:self cellWillBeginMoveAtIndexPath:_originalIndexPath];
//    }

}

- (void)longPressChanged:(UILongPressGestureRecognizer *)longPress{
    
    CGFloat tranX = [longPress locationOfTouch:0 inView:longPress.view].x - _lastPoint.x;
    CGFloat tranY = [longPress locationOfTouch:0 inView:longPress.view].y - _lastPoint.y;
    _tempMoveCell.center = CGPointApplyAffineTransform(_tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
    _lastPoint = [longPress locationOfTouch:0 inView:longPress.view];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_originalIndexPath];
    cell.hidden = YES;
    [self xwp_moveCell];
    
}

- (void)longPressEnded:(UILongPressGestureRecognizer *)longPress{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_originalIndexPath];
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
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        if ([self.tableView indexPathForCell:cell] == _originalIndexPath) {
            continue;
        }
        //计算中心距
        CGFloat spacingX = fabs(_tempMoveCell.center.x - cell.center.x);
        CGFloat spacingY = fabs(_tempMoveCell.center.y - cell.center.y);
        if (spacingX <= _tempMoveCell.bounds.size.width / 2.0f && spacingY <= _tempMoveCell.bounds.size.height / 2.0f) {
            _moveIndexPath = [self.tableView indexPathForCell:cell];
            
//            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_moveIndexPath];
            
            
            //更新数据源
            [self xwp_updateDataSource];
            //移动
            [self.tableView moveRowAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
            
            //通知代理
//            if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:moveCellFromIndexPath:toIndexPath:)]) {
//                [self.delegate dragCellCollectionView:self moveCellFromIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
//            }
            //设置移动后的起始indexPath
            _originalIndexPath = _moveIndexPath;
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
    if ([self.delegate respondsToSelector:@selector(dataSourceArrayOfProjectCollectionViewCell:)]) {
        [temp addObjectsFromArray:[self.delegate dataSourceArrayOfProjectCollectionViewCell:self]];
    }
    //判断数据源是单个数组还是数组套数组的多section形式，YES表示数组套数组
    BOOL dataTypeCheck = ([self.tableView numberOfSections] != 1 || ([self.tableView numberOfSections] == 1 && [temp[0] isKindOfClass:[NSArray class]]));
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
    self.taskList = temp.copy;
}




- (void)jumpClick{
    
    if ([self.delegate respondsToSelector:@selector(projectCollectionViewCellDidClickedJumpWithIndex:)]) {
        [self.delegate projectCollectionViewCellDidClickedJumpWithIndex:self.tag - 0x3434];
    }
    
}

-(void)setTaskList:(NSArray *)taskList{
    _taskList = taskList;
    
    [self.tableView reloadData];
    
    // 给点时间让cell先布局，然后刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == ProjectSeeBoardTypeCrm) {
        
        HQTFCrmTableViewCell *cell = [HQTFCrmTableViewCell crmTableViewCellWithTableView:tableView];
        return cell;
    }else{
        HQTFTaskTableViewCell *cell = [HQTFTaskTableViewCell taskTableViewCellWithTableView:tableView];
        cell.delegate = self;
        [cell refreshTaskTableViewCellWithModel:self.taskList[indexPath.row] type:0];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(projectCollectionViewCellDidClickedTaskWithModel:)]) {
        [self.delegate projectCollectionViewCellDidClickedTaskWithModel:self.taskList[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.type == ProjectSeeBoardTypeCrm) {
        
        return 220;
    }else{
        return [HQTFTaskTableViewCell refreshTaskTableViewCellHeightWithModel:self.taskList[indexPath.row] type:0];
    }
}

#pragma mark - HQTFTaskTableViewCellDelegate
-(void)taskTableViewCell:(HQTFTaskTableViewCell *)taskCell didFinishBtn:(UIButton *)button withModel:(TFProjTaskModel *)model{
    
    if ([self.delegate respondsToSelector:@selector(projectCollectionViewCellDidclickedFinishBtn:withModel:)]) {
        [self.delegate projectCollectionViewCellDidclickedFinishBtn:button withModel:model];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //self.titleBgView.layer.masksToBounds = NO;
    //self.titleBgView.layer.shadowColor = GrayTextColor.CGColor;
    //self.titleBgView.layer.shadowOffset = CGSizeMake(0, 2);
    //self.titleBgView.layer.shadowOpacity = 0.5;
    //self.titleBgView.layer.shadowRadius = 1;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //[UIView animateWithDuration:0.25 animations:^{
        
    //    self.titleBgView.layer.shadowOpacity = 0;
    //}completion:^(BOOL finished) {
        
     //   self.titleBgView.layer.masksToBounds = YES;
    //}];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //[UIView animateWithDuration:0.25 animations:^{
        
   //     self.titleBgView.layer.shadowOpacity = 0;
    //}completion:^(BOOL finished) {
        
     //   self.titleBgView.layer.masksToBounds = YES;
   // }];
}
@end
