//
//  HQTFMyWorkBenchCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/1.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFMyWorkBenchCell.h"
#import "HQTFTaskTableViewCell.h"
#import "HQTFNoContentCell.h"
#import "TFApprovalItemModel.h"


@interface HQTFMyWorkBenchCell ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HQTFTaskTableViewCellDelegate,UIGestureRecognizerDelegate>

/** tableViews */
@property (nonatomic, strong) NSMutableArray *tableViews;

@property (nonatomic,assign) BOOL isScroll;

/** UIScrollView *scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** TFWorkBenchModel */
@property (nonatomic, strong) TFWorkBenchModel *benchModel;


@end

@implementation HQTFMyWorkBenchCell


-(void)refreshMyWorkBenchCellWithModel:(TFWorkBenchModel *)model;
{
    self.benchModel = model;
    for (UITableView *tableView in self.tableViews) {
        [tableView reloadData];
    }
}

-(void)setTaskList:(NSMutableArray *)taskList{
    
    _taskList = taskList;
    
    for (UITableView *tableView in self.tableViews) {
        
//        NSArray *arr = self.taskList[tableView.tag - 0x1234];
//        if (!arr || arr.count == 0) {
//            
//            [HQHelper setupBackgroudViewForTableView:tableView withPoint:CGPointMake(tableView.centerX, tableView.centerY-83) withImageName:@"图123" titleText:@"暂无任务，喝杯咖啡思考人生"];
//            tableView.tableFooterView = nil;
//            
//        }else{
//            
//            tableView.backgroundView = nil;
//            UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"没有更多啦..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
//            tableView.tableFooterView = label;
//        }
        [tableView reloadData];
    }
}

-(NSMutableArray *)tableViews{
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupChild];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupChild];
}

+ (HQTFMyWorkBenchCell *)myWorkBenchCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFMyWorkBenchCell";
    HQTFMyWorkBenchCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFMyWorkBenchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    return cell;
}

- (void)setupChild{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-83-49);
    scrollView.layer.masksToBounds = NO;
    scrollView.backgroundColor = GreenColor;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.bounces = NO;
    scrollView.tag = 0x1111;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, scrollView.height);
    
    for (NSInteger i = 0; i < 4; i ++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, scrollView.height) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.backgroundColor = HexAColor(0xEBEDF0, 1);
        tableView.layer.masksToBounds = NO;
        tableView.bounces = YES;
        tableView.scrollEnabled = NO;
        tableView.tag = 0x1234 + i;
        
//        UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"没有更多啦..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
//        tableView.tableFooterView = label;
        
        [scrollView addSubview:tableView];
        
        [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.tableViews addObject:tableView];
        tableView.layer.masksToBounds = NO;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainTableViewScroll:) name:WorkBenchMainTableViewScrollNotifition object:nil];
}

- (void)mainTableViewScroll:(NSNotification *)note{
    
    BOOL isScroll = [note.object boolValue];
    
    for (UITableView *tableView in self.tableViews) {
        
        tableView.scrollEnabled = !isScroll;
    }
    
//    self.isScroll = isScroll;
    
    NSInteger index = self.scrollView.contentOffset.x/SCREEN_WIDTH;
    
    UITableView *table = self.tableViews[index];
    
    if (table.scrollEnabled == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            
            table.contentOffset = CGPointMake(0, 1);
        }];
    }
    
}


-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    
//    [UIView animateWithDuration:0.25 animations:^{
        self.open = YES;
        [self.scrollView setContentOffset:(CGPoint){SCREEN_WIDTH*selectIndex,0} animated:YES];
//    }];
    
}

#pragma mark - tableView 数据源及代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *models = nil;
    if (tableView.tag - 0x1234 == 0) {
        
        models = self.benchModel.overdueTask.tasks;
    }else if (tableView.tag - 0x1234 == 1){
        models = self.benchModel.todayTask.tasks;
    }else if (tableView.tag - 0x1234 == 2){
        models = self.benchModel.tomorrowTask.tasks;
    }else{
        
        models = self.benchModel.futureTask.tasks;
    }
    if (models.count) {
        return models.count;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *models = nil;
    if (tableView.tag - 0x1234 == 0) {
        
        models = self.benchModel.overdueTask.tasks;
    }else if (tableView.tag - 0x1234 == 1){
        models = self.benchModel.todayTask.tasks;
    }else if (tableView.tag - 0x1234 == 2){
        models = self.benchModel.tomorrowTask.tasks;
    }else{
        
        models = self.benchModel.futureTask.tasks;
    }
//    NSArray *models = self.taskList[tableView.tag - 0x1234];
    
    if (models.count) {
        id model = models[indexPath.row];
        
        if ([model isKindOfClass:[TFProjTaskModel class]]) {
            
            HQTFTaskTableViewCell *cell = [HQTFTaskTableViewCell taskTableViewCellWithTableView:tableView];
            [cell refreshTaskTableViewCellWithModel:model type:1];
            cell.delegate = self;
            return cell;
            
        }else{
//            TFApprovalItemCell *cell = [TFApprovalItemCell approvalItemCellWithTableView:tableView];
//            [cell refreshApprovalItemCellWithModel:model];
//            cell.showDown = YES;
//            cell.delegate = self;
//            return cell;
            
            static NSString *ID = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            cell.textLabel.text = @"ewcfds";
            return cell;
        }
        
        
    }else{
        
        HQTFNoContentCell *cell = [HQTFNoContentCell noContentCellWithTableView:tableView withImage:@"图123" withText:@"今天任务完成，喝杯咖啡思考人生"];
        cell.bottomLine.hidden = YES;
        cell.backgroundColor = ClearColor;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    NSArray *models = nil;
    if (tableView.tag - 0x1234 == 0) {
        
        models = self.benchModel.overdueTask.tasks;
    }else if (tableView.tag - 0x1234 == 1){
        models = self.benchModel.todayTask.tasks;
    }else if (tableView.tag - 0x1234 == 2){
        models = self.benchModel.tomorrowTask.tasks;
    }else{
        
        models = self.benchModel.futureTask.tasks;
    }
    if (models.count) {
        
        id model = models[indexPath.row];
        
        if ([model isKindOfClass:[TFProjTaskModel class]]) {
            
            if ([self.delegate respondsToSelector:@selector(myWorkBenchCellDidClickedTask:)]) {
                [self.delegate myWorkBenchCellDidClickedTask:model];
            }
        }else{
            
            if ([self.delegate respondsToSelector:@selector(myWorkBenchCellDidClickedApproval:)]) {
                [self.delegate myWorkBenchCellDidClickedApproval:model];
            }
            
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *models = nil;
    if (tableView.tag - 0x1234 == 0) {
        
        models = self.benchModel.overdueTask.tasks;
    }else if (tableView.tag - 0x1234 == 1){
        models = self.benchModel.todayTask.tasks;
    }else if (tableView.tag - 0x1234 == 2){
        models = self.benchModel.tomorrowTask.tasks;
    }else{
        
        models = self.benchModel.futureTask.tasks;
    }
    
    if (models.count) {
        
        
        id model = models[indexPath.row];
        
        if ([model isKindOfClass:[TFProjTaskModel class]]) {
        
            return [HQTFTaskTableViewCell refreshTaskTableViewCellHeightWithModel:model type:1];
        }else{
//            return [TFApprovalItemCell refreshApprovalItemCellHeightWithModel:model];
            return 100;
        }
    }else{
        return SCREEN_HEIGHT-64-83-49;
    }
    
}

#define mark - TFApprovalItemCellDelegate
//-(void)approvalItemCell:(TFApprovalItemCell *)approvalItemCell didDownBtnWithModel:(TFApprovalItemModel *)model{
//    
//    if ([self.delegate respondsToSelector:@selector(myWorkBenchCellDidDownBtnWithSelectIndex:withModel:)]) {
//        [self.delegate myWorkBenchCellDidDownBtnWithSelectIndex:self.selectIndex withModel:model];
//    }
//}


#pragma mark - HQTFTaskTableViewCellDelegate
-(void)taskTableViewCell:(HQTFTaskTableViewCell *)taskCell didDownBtnWithModel:(TFProjTaskModel *)model{
    
    if ([self.delegate respondsToSelector:@selector(myWorkBenchCellDidDownBtnWithSelectIndex:withModel:)]) {
        [self.delegate myWorkBenchCellDidDownBtnWithSelectIndex:self.selectIndex withModel:model];
    }
}

-(void)taskTableViewCell:(HQTFTaskTableViewCell *)taskCell didFinishBtn:(UIButton *)button withModel:(TFProjTaskModel *)model{
    
    if ([self.delegate respondsToSelector:@selector(myWorkBenchCellDidFinishBtn:withModel:)]) {
        [self.delegate myWorkBenchCellDidFinishBtn:button withModel:model];
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.open = NO;
    
    if (scrollView.tag != 0x1111) {
        
        if ((scrollView.contentOffset.y <= 0.5)) {
            self.isScroll = NO;
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    if (scrollView.contentOffset.y <= 0 && !self.isScroll) {
//        scrollView.scrollEnabled = NO;
//        self.isScroll = YES;
//        [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchChildTableViewScrollNotifition object:@0];
//    }
//    if(scrollView.contentOffset.y > 0 && self.isScroll){
//        
//        scrollView.scrollEnabled = YES;
//        
//        self.isScroll = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchChildTableViewScrollNotifition object:@1];
//    }
//
    
    if (scrollView.tag == 0x1111 && !self.open) {
        
        if ([self.delegate respondsToSelector:@selector(myWorkBenchCellWithScrollView:)]) {
            [self.delegate myWorkBenchCellWithScrollView:scrollView];
        }
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    
    if (scrollView.tag == 0x1111) {
        
        NSInteger selectIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
        
        if ([self.delegate respondsToSelector:@selector(myWorkBenchCellWithSelectIndex:)]) {
            [self.delegate myWorkBenchCellWithSelectIndex:selectIndex];
        }
    
    }
    
//    HQLog(@"##########%f",scrollView.contentOffset.y);
    
    if (scrollView.tag != 0x1111) {
        
        if ((scrollView.contentOffset.y <= 0.5)) {
            self.isScroll = NO;
        }else{
            self.isScroll = YES;
        }
    }
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    UITableView *tableView = object;
    
//    HQLog(@"========%f",tableView.contentOffset.y);
//    HQLog(@"********%d",self.isScroll);
    
    if ((tableView.contentOffset.y <= 0.5)) {
//        HQLog(@"====******====");
        tableView.scrollEnabled = NO;
        
        if (!self.isScroll) {
            
            self.isScroll = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchChildTableViewScrollNotifition object:@0];
        }
    }
    if(tableView.contentOffset.y > 0.5){
        
//        HQLog(@"====******====");
        tableView.scrollEnabled = YES;
        if (self.isScroll) {
            
            self.isScroll = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:WorkBenchChildTableViewScrollNotifition object:@1];
        }

    }
    
}

-(void)dealloc{
    
    for (UITableView *tableView in self.tableViews) {
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
