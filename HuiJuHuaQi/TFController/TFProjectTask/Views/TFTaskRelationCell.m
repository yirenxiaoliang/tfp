//
//  TFTaskRelationCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskRelationCell.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectSectionModel.h"
#import "TFProjectNoteCell.h"
#import "TFTProjectCustomCell.h"
#import "TFProjectApprovalCell.h"
#import "TFNewProjectCustomCell.h"

@interface TFTaskRelationCell ()<UITableViewDataSource,UITableViewDelegate,TFProjectTaskItemCellDelegate,TFProjectNoteCellDelegate,TFNewProjectCustomCellDelegate,TFProjectApprovalCellDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/**  models */
@property (nonatomic, strong) NSMutableArray* models;

/** moduleLabel */
@property (nonatomic, weak) UILabel *moduleLabel;
/** handleBtn */
@property (nonatomic, weak) UIButton *handleBtn;

/** model */
@property (nonatomic, strong) TFProjectSectionModel *model;

/** longPress */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, assign) BOOL auth;
@end


@implementation TFTaskRelationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupTableView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (TFTaskRelationCell *)taskRelationCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskRelationCell";
    TFTaskRelationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFTaskRelationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


-(void)refreshTaskRelationCellWithModel:(TFProjectSectionModel *)model auth:(BOOL)auth{
    
    self.moduleLabel.text = model.name;
    self.model = model;
    self.models = model.tasks;
    self.auth = auth;
    self.longPress.enabled = auth;
    
    if (![model.select isEqualToNumber:@1]) {
        
        CGFloat height = 0;
        for (TFProjectRowFrameModel *frame in model.frames) {
            
            height += frame.cellHeight;
        }
        if (model.frames.count) {
            self.tableView.height = height+10;
        }else{
            self.tableView.height = height;
        }
    }else{
        self.tableView.height = 0;
    }
    if (model.tasks.count) {
        self.moduleLabel.height = 44;
        self.handleBtn.hidden = NO;
    }else{
        self.moduleLabel.height = 0;
        self.handleBtn.hidden = YES;
    }
    [self.tableView reloadData];
}

+(CGFloat)refreshTaskRelationCellHeightWithModel:(TFProjectSectionModel *)model{
    
    CGFloat height = 0;
    
    if (![model.select isEqualToNumber:@1]) {
        
        for (TFProjectRowFrameModel *frame in model.frames) {
            
            height += frame.cellHeight;
        }
        height += 10;// n+1 个间距
    }
    if (model.frames.count != 0) {
        height += 44;
    }
    return height;
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UILabel *moduleLabel = [[UILabel alloc] initWithFrame:(CGRect){25,0,SCREEN_WIDTH-30-15-44,44}];
    [self.contentView addSubview:moduleLabel];
    moduleLabel.font = FONT(14);
    moduleLabel.textColor = BlackTextColor;
    self.moduleLabel = moduleLabel;
    
    UIButton *handleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:handleBtn];
    handleBtn.frame = CGRectMake(SCREEN_WIDTH-30-20, 0, 44, 44);
    [handleBtn setImage:IMG(@"更多信息") forState:UIControlStateNormal];
    [handleBtn addTarget:self action:@selector(handleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.handleBtn = handleBtn;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(25, 44, SCREEN_WIDTH-25-15, 100) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundColor = BackGroudColor;
    tableView.layer.cornerRadius = 4;
    tableView.layer.masksToBounds = YES;
    tableView.scrollEnabled = NO;
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    longPress.minimumPressDuration = .5;
//    [tableView addGestureRecognizer:longPress];
//    self.longPress = longPress;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    // tableView上的一点
    CGPoint point = [longPress locationInView:self.tableView];
    // 该点在tableView上对应的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath) {
        if (longPress.state == UIGestureRecognizerStateBegan) {
            
            if ([self.delegate respondsToSelector:@selector(taskRelationCellLongPressItem:taskIndex:)]) {
                [self.delegate taskRelationCellLongPressItem:self.model taskIndex:indexPath.row];
            }
        }
    }
}


- (void)handleBtnClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    if (button.selected) {
        self.tableView.height = 0;
        self.model.select = @1;
    }else{
        
        self.model.select = @0;
        CGFloat height = 0;
        for (TFProjectRowFrameModel *frame in self.model.frames) {
            
            height += frame.cellHeight;
        }
        if (self.model.frames.count) {
            self.tableView.height = height+10;
        }else{
            self.tableView.height = height;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(taskRelationCellDidShow:)]) {
        [self.delegate taskRelationCellDidShow:self.model];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TFProjectRowModel *row = self.model.tasks[indexPath.row];
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据) */
    if ([row.dataType isEqualToNumber:@2]) {// 任务
        
        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
        
        cell.frameModel = self.model.frames[indexPath.row];
        cell.edit = self.auth;
        cell.delegate = self;
        cell.tag = indexPath.row;
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@1]){// 备忘录
        
        TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
        cell.frameModel = self.model.frames[indexPath.row];
        
        cell.edit = self.auth;
        cell.delegate = self;
        cell.tag = indexPath.row;
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@3]){// 自定义
        
        if (row.rows) {
            
            TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
            cell.frameModel = self.model.frames[indexPath.row];
            cell.edit = self.auth;
            cell.delegate = self;
            cell.tag = indexPath.row;
            return cell;
        }
        TFTProjectCustomCell *cell = [TFTProjectCustomCell projectCustomCellWithTableView:tableView];
        cell.frameModel = self.model.frames[indexPath.row];
//        cell.edit = self.auth;
        return cell;
        
    }else{// 审批
        TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
        cell.frameModel = self.model.frames[indexPath.row];
        cell.edit = self.auth;
        cell.delegate = self;
        cell.tag = indexPath.row;
        
        return cell;
        
    }
}

#pragma mark - TFProjectTaskItemCellDelegate
-(void)projectTaskItemCellDidClickedClearBtn:(TFProjectTaskItemCell *)cell{
    
    if ([self.delegate respondsToSelector:@selector(taskRelationCellLongPressItem:taskIndex:)]) {
        [self.delegate taskRelationCellLongPressItem:self.model taskIndex:cell.tag];
    }
}
#pragma mark - TFProjectNoteCellDelegate
-(void)projectNoteCellDidClickedClearBtn:(TFProjectNoteCell *)cell{
    
    if ([self.delegate respondsToSelector:@selector(taskRelationCellLongPressItem:taskIndex:)]) {
        [self.delegate taskRelationCellLongPressItem:self.model taskIndex:cell.tag];
    }
}
#pragma mark - TFNewProjectCustomCellDelegate
-(void)newProjectCustomCellDidClickedClearBtn:(TFNewProjectCustomCell *)cell{
    
    if ([self.delegate respondsToSelector:@selector(taskRelationCellLongPressItem:taskIndex:)]) {
        [self.delegate taskRelationCellLongPressItem:self.model taskIndex:cell.tag];
    }
}
#pragma mark - TFProjectApprovalCellDelegate
-(void)projectApprovalCellDidClickedClearBtn:(TFProjectApprovalCell *)cell{
    
    if ([self.delegate respondsToSelector:@selector(taskRelationCellLongPressItem:taskIndex:)]) {
        [self.delegate taskRelationCellLongPressItem:self.model taskIndex:cell.tag];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectRowModel *row = self.model.tasks[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(taskRelationCellDidClickedItem:)]) {
        [self.delegate taskRelationCellDidClickedItem:row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectRowFrameModel *frame = self.model.frames[indexPath.row];
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
