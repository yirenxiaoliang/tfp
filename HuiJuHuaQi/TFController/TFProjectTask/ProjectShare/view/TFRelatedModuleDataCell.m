//
//  TFRelatedModuleDataCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRelatedModuleDataCell.h"

#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFTProjectCustomCell.h"
#import "TFProjectApprovalCell.h"
#import "TFProjectRowFrameModel.h"
#import "TFNewProjectCustomCell.h"

@interface TFRelatedModuleDataCell()<UITableViewDelegate,UITableViewDataSource,TFProjectTaskItemCellDelegate>

@property (nonatomic, strong) NSArray *tasks;

@property (nonatomic, strong) NSArray *frames;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong, nullable) UILongPressGestureRecognizer *longGesture; ///< 长按手势


@property (nonatomic, assign) BOOL auth;

@end

@implementation TFRelatedModuleDataCell

- (void)refreshCellWithTasks:(NSArray *)tasks frames:(NSArray *)frames auth:(BOOL)auth{
    self.auth = auth;
    self.tasks = tasks;
    self.frames = frames;
    CGFloat height = 0;
    self.longGesture.enabled = auth;
    
    for ( TFProjectRowFrameModel *row in frames) {
        height += row.cellHeight;
    }
    
    self.tableView.height = height;
    if (self.tasks.count>0) {
        if (auth) {
            self.tableView.height = height + 35;
        }
    }
    
    [self.tableView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupTableView];
    }
    
    return self;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    self.tableView  = tableView;
    [self addSubview:tableView];
    tableView.scrollEnabled = NO;
    [tableView addGestureRecognizer:self.longGesture];
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        _longGesture.minimumPressDuration = .5;
    }
    return _longGesture;
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    // self上的一点
    CGPoint point = [longGesture locationInView:self.tableView];
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:point];
    
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        
        if ([self.delegate respondsToSelector:@selector(deleteRelatedDataWithIndex:)]) {
            
            [self.delegate deleteRelatedDataWithIndex:index];
        }
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.frames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectRowModel *row = self.tasks[indexPath.row];
    
    /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据) */
    if ([row.dataType isEqualToNumber:@2]) {// 任务
        
        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
        cell.frameModel = self.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        cell.delegate = self;
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@1]){// 备忘录
        
        TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
        cell.frameModel = self.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else if ([row.dataType isEqualToNumber:@3]){// 自定义
        
        if (row.rows) {
            
            TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
            cell.frameModel = self.frames[indexPath.row];
            
            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            return cell;
        }
        TFTProjectCustomCell *cell = [TFTProjectCustomCell projectCustomCellWithTableView:tableView];
        cell.frameModel = self.frames[indexPath.row];
        
        if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
        
    }else{// 审批
        TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
        cell.frameModel = self.frames[indexPath.row];
        
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
    
    if ([self.delegate respondsToSelector:@selector(didSelectRelatedWithIndex:)]) {
        
        [self.delegate didSelectRelatedWithIndex:indexPath];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectRowFrameModel *frame = self.frames[indexPath.row];
    return frame.cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.auth) {
        return 35;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    view.backgroundColor = WhiteColor;
    UILabel *lab = [UILabel initCustom:CGRectMake(20, 0, SCREEN_WIDTH-40, 35) title:@"长按卡片可取消关联     " titleColor:kUIColorFromRGB(0x666666) titleFont:12 bgColor:WhiteColor];
    lab.textAlignment = NSTextAlignmentRight;
    
    [view addSubview:lab];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

+ (CGFloat)refreshRelatedModuleHeightWithFrames:(NSArray*)frames auth:(BOOL)auth{
    
    CGFloat height = 0;
    for (TFProjectRowFrameModel *frame in frames) {
        
        height = frame.cellHeight+height;
    }
    
    if (frames.count >0) {
        if (auth) {
            return height+35;
        }
    }
    return height;
}

+ (TFRelatedModuleDataCell *)relatedModuleDataCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFRelatedModuleDataCell";
    TFRelatedModuleDataCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFRelatedModuleDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
