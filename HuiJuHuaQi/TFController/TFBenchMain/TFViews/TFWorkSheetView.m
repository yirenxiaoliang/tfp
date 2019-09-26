//
//  TFWorkSheetView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/31.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkSheetView.h"
#import "TFProjectTaskBL.h"
#import "TFCachePlistManager.h"
#import "TFProjectRowFrameModel.h"
#import "TFRefresh.h"
#import "HQTFNoContentView.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFProjectApprovalCell.h"
#import "TFTProjectCustomCell.h"
#import "TFNewProjectCustomCell.h"
#import "TFNewProjectTaskItemCell.h"

@interface TFWorkSheetView()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFProjectTaskItemCellDelegate,TFNewProjectTaskItemCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UILabel *numberLabel;


@property (nonatomic, assign) NSInteger type;
/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, strong) TFProjectSectionModel *section;


@property (nonatomic, copy) NSString *memberIds;

@end

@implementation TFWorkSheetView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.section = [[TFProjectSectionModel alloc] init];
        self.projectTaskBL = [TFProjectTaskBL build];
        self.projectTaskBL.delegate = self;
        [self setupHeaderView];
        [self setupTableView];
        self.type = type;
        self.section.id = @(type+1);
        [self loadDataWithSectionModel:self.section];
        
        self.backgroundColor = ClearColor;
        self.layer.shadowColor = LightGrayTextColor.CGColor;
        self.layer.shadowRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0, -4);
        self.layer.shadowOpacity = 0.5;
        
    }
    return self;
}

/** 刷新 */
- (void)refreshData{
    [self.tableView reloadData];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.section.tasks.count];
    if ([self.delegate respondsToSelector:@selector(workSheet:taskCount:)]) {
        [self.delegate workSheet:self taskCount:self.section.tasks.count];
    }
}

/** 加载数据 */
- (void)loadDataMemberIds:(NSString *)memberIds{
    
    self.memberIds = memberIds;
    self.section.pageNum = @1;
    [self.projectTaskBL requestGetWorkBenchDataWithWorkBenchType:self.section.id index:self.type pageNum:self.section.pageNum pageSize:self.section.pageSize memeberIds:self.memberIds];
}

/** 加载某列数据 */
- (void)loadDataWithSectionModel:(TFProjectSectionModel *)section{
    
    if (IsStrEmpty(UM.userLoginInfo.token) || ![UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
        return;
    }
    
    NSArray *arr = [TFCachePlistManager getWorkBenchDataWithType:self.type];
    [self handleDataWithDatas:arr index:self.type pageInfo:nil];
        
    [self.projectTaskBL requestGetWorkBenchDataWithWorkBenchType:section.id index:self.type pageNum:section.pageNum pageSize:section.pageSize memeberIds:nil];
   
}
/** 处理某列的数据 */
- (void)handleDataWithDatas:(NSArray *)datas index:(NSInteger)index pageInfo:(NSDictionary *)pageInfo{
    
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    
    // 下面为数据
    NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
    NSMutableArray *frames = [NSMutableArray array];
    
//    CGFloat allHeight = 0;
    for (NSDictionary *taskDict in datas) {
        TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
        
        [tasks addObject:task];
        if ([task.dataType isEqualToNumber:@2]) {
            task.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:task haveClear:NO]);
        }
        
        TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] initBorder];
        frame.projectRow = task;
        [frames addObject:frame];
        
//        allHeight += frame.cellHeight;
    }
    
    if ([self.tableView.mj_footer isRefreshing]){
        [self.tableView.mj_footer endRefreshing];
        if (self.section.frames && self.section.tasks) {
            [self.section.frames addObjectsFromArray:frames];
            [self.section.tasks addObjectsFromArray:tasks];
        }else{
            self.section.frames = frames;
            self.section.tasks = tasks;
        }
    }else{
        [self.tableView.mj_header endRefreshing];
        self.section.frames = frames;
        self.section.tasks = tasks;
    }
    
    // 存储工作台某列数据
    [TFCachePlistManager saveWorkBenchDataWithDatas:datas type:index];
    
    if ([[pageInfo valueForKey:@"totalPages"] integerValue] <= [self.section.pageNum integerValue]) {// 总页数 <= 请求的页码，说明已经加载完数据
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];// 没有更多数据
    }else {
        [self.tableView.mj_footer resetNoMoreData];// 重置上拉
    }
    
//    if (allHeight < self.height-Long(70) && self.tableView.contentSize.height < self.height-Long(70)) {
//        self.tableView.tableFooterView.height = self.height-Long(70)-allHeight-8;
//    }else{
//        self.tableView.tableFooterView.height = 0;
//    }
//
    self.tableView.tableFooterView.height = 0;
    if (tasks.count) {
        self.tableView.backgroundView.hidden = YES;
    }else{
        self.tableView.backgroundView.hidden = NO;
    }
    // 后台会给出所有任务，以及第一页自定义数据，totalRows为自定义的总数，不含任务数
    NSInteger count = 0;
    for (TFProjectRowModel *row in self.section.tasks) {
        
        if ([row.dataType isEqualToNumber:@3]) {
            continue;
        }
        count ++;
    }
    
    self.taskCount = count + [[pageInfo valueForKey:@"totalRows"] integerValue];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.taskCount];
    
    if ([self.delegate respondsToSelector:@selector(workSheet:taskCount:)]) {
        [self.delegate workSheet:self taskCount:self.taskCount];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    NSDictionary *dict = resp.body;
    NSArray *datas = [dict valueForKey:@"dataList"];
    NSDictionary *pageInfo = [dict valueForKey:@"pageInfo"];
    
    // 处理数据
    [self handleDataWithDatas:datas index:self.type pageInfo:pageInfo];
}


-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if ([self.tableView.mj_footer isRefreshing]){
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_header endRefreshing];
    }
    
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


-(void)setType:(NSInteger)type{
    _type = type;
    
    switch (type) {
        case 0:
        {
            self.imageView.image = IMG(@"work超期");
            self.nameLabel.text = @"超期任务 ·";
            self.descLabel.text = @"Overdue";
        }
            break;
        case 1:
        {
            self.imageView.image = IMG(@"work今日");
            self.nameLabel.text = @"今日要做 ·";
            self.descLabel.text = @"Today";
        }
            break;
        case 2:
        {
            self.imageView.image = IMG(@"work明日");
            self.nameLabel.text = @"明日要做 ·";
            self.descLabel.text = @"Tomorrow";
        }
            break;
        case 3:
        {
            self.imageView.image = IMG(@"work以后");
            self.nameLabel.text = @"以后要做 ·";
            self.descLabel.text = @"Later";
        }
            break;
            
        default:
            break;
    }
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    
    if (selected) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tableView.frame = CGRectMake(0, Long(70), self.width, self.height-Long(70));
        }];
        
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tableView.frame = CGRectMake(0, Long(120), self.width, self.height-Long(120));
        }];
    }
}

#pragma mark - 初始化头部
-(void)setupHeaderView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,Long(120)}];
    [self addSubview:bgView];
    self.bgView = bgView;
    bgView.layer.cornerRadius = 8;
    bgView.backgroundColor = WhiteColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked)];
    [bgView addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe)];
    swipe1.direction = UISwipeGestureRecognizerDirectionUp;
    [bgView addGestureRecognizer:swipe1];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe)];
    swipe2.direction = UISwipeGestureRecognizerDirectionDown;
    [bgView addGestureRecognizer:swipe2];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClicked:)];
    [bgView addGestureRecognizer:pan];
    [pan requireGestureRecognizerToFail:swipe2];
    [pan requireGestureRecognizerToFail:swipe1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, bgView.height)];
    [bgView addSubview:imageView];
    imageView.image = IMG(@"work以后");
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    imageView.hidden = YES;
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:(CGRect){15,Long(25),80,22}];
    [bgView addSubview:nameLabel];
    nameLabel.textColor = LightBlackTextColor;
    nameLabel.font = BFONT(16);
    nameLabel.text = @"以后";
    self.nameLabel = nameLabel;
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:(CGRect){30,CGRectGetMaxY(nameLabel.frame),200,22}];
    [bgView addSubview:descLabel];
    descLabel.textColor = LightBlackTextColor;
    descLabel.alpha = 0.5;
    descLabel.font = BFONT(14);
    descLabel.text = @"Later";
    self.descLabel = descLabel;
    descLabel.hidden = YES;
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(nameLabel.frame),Long(25),100,22}];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:numberLabel];
    numberLabel.textColor = LightBlackTextColor;
    numberLabel.font = BFONT(16);
    numberLabel.text = @"";
    self.numberLabel = numberLabel;
    
    UIImageView *close = [[UIImageView alloc] initWithImage:IMG(@"关闭")];
    close.frame = CGRectMake(SCREEN_WIDTH-50, 15, 40, 40);
    [bgView addSubview:close];
    close.contentMode = UIViewContentModeCenter;
    
}

-(void)bgClicked{
    self.selected = !self.selected;
    if ([self.delegate respondsToSelector:@selector(workSheetViewDidClickedHeader:)]) {
        [self.delegate workSheetViewDidClickedHeader:self];
    }
}

-(void)upSwipe{
    
    if (!self.selected) {
        [self bgClicked];
    }
}
-(void)downSwipe{
   
    if (self.selected) {
        [self bgClicked];
    }
}

-(void)panClicked:(UIPanGestureRecognizer *)pan{
    
    if (self.selected) {
        CGPoint point = [pan locationInView:pan.view];
//        CGPoint changePoint = [self convertPoint:point toView:self.superview];
//        HQLog(@"point:%@",NSStringFromCGPoint(point));
//        HQLog(@"changePoint:%@",NSStringFromCGPoint(changePoint));

        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
            {
                if ([self.delegate respondsToSelector:@selector(workSheetView:panBeginWithPoint:)]) {
                    [self.delegate workSheetView:self panBeginWithPoint:point];
                }
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
                if ([self.delegate respondsToSelector:@selector(workSheetView:panChangeWithPoint:)]) {
                    [self.delegate workSheetView:self panChangeWithPoint:point];
                }
            }
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                if ([self.delegate respondsToSelector:@selector(workSheetView:panEndWithPoint:)]) {
                    [self.delegate workSheetView:self panEndWithPoint:point];
                }
            }
                break;
                
            default:
                break;
        }
        
    }
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bgView.frame), self.width, self.height-Long(120)) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    tableView.backgroundColor = WhiteColor;
    
    [self addSubview:tableView];
    self.tableView = tableView;
    
    HQTFNoContentView *noContentView = [HQTFNoContentView noContentView];
    [noContentView setupImageViewRect:(CGRect){30,(tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    tableView.backgroundView = noContentView;
    
//    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,self.height-Long(70)}];
//    tableView.tableFooterView = view;
//    view.hidden = YES;
    
    
    MJRefreshNormalHeader *header = [TFRefresh headerNormalRefreshWithBlock:^{
        
        self.section.pageNum = @1;
        [self.projectTaskBL requestGetWorkBenchDataWithWorkBenchType:self.section.id index:self.type pageNum:self.section.pageNum pageSize:self.section.pageSize memeberIds:self.memberIds];
        
    }];
    tableView.mj_header = header;
    
    
    MJRefreshAutoNormalFooter *footer = [TFRefresh footerAutoRefreshWithBlock:^{
        
        self.section.pageNum = @([self.section.pageNum integerValue] + 1);
        [self.projectTaskBL requestGetWorkBenchDataWithWorkBenchType:self.section.id index:self.type pageNum:self.section.pageNum pageSize:self.section.pageSize memeberIds:self.memberIds];
    }];
    tableView.mj_footer = footer;
}

#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.section.tasks.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TFProjectRowModel *row = self.section.tasks[indexPath.row];
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据) */
    if ([row.dataType isEqualToNumber:@2]) {// 任务
        
        TFNewProjectTaskItemCell *cell = [TFNewProjectTaskItemCell newProjectTaskItemCellWithTableView:tableView];
        [cell refreshNewProjectTaskItemCellWithModel:self.section.tasks[indexPath.row] haveClear:NO];
//        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
//        cell.frameModel = self.section.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        cell.delegate = self;
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@1]){// 备忘录
        
        TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
        cell.frameModel = self.section.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@3]){// 自定义
        
        if (row.rows) {
         
            TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
            cell.frameModel = self.section.frames[indexPath.row];
            
            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            return cell;
        }
        
        TFTProjectCustomCell *cell = [TFTProjectCustomCell projectCustomCellWithTableView:tableView];
        cell.frameModel = self.section.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else{// 审批
        TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
        cell.frameModel = self.section.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFProjectRowModel *row = self.section.tasks[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(workSheet:didClickedItem:)]) {
        [self.delegate workSheet:self didClickedItem:row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectRowModel *row = self.section.tasks[indexPath.row];
    if ([row.dataType isEqualToNumber:@2]) {
        return [row.cellHeight floatValue];
    }else{
        TFProjectRowFrameModel *frame = self.section.frames[indexPath.row];
        return frame.cellHeight;
    }
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
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}


#pragma mark - TFProjectTaskItemCellDelegate
-(void)projectTaskItemCell:(TFNewProjectTaskItemCell *)cell didClickedFinishBtnWithModel:(id)model{
    
    if ([self.delegate respondsToSelector:@selector(workSheet:didClickedFinishItem:)]) {
        [self.delegate workSheet:self didClickedFinishItem:model];
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
