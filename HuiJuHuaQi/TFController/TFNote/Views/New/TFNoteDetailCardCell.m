//
//  TFNoteDetailCardCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteDetailCardCell.h"
#import "TFNoteDetailAddressCell.h"
#import "TFLocationModel.h"
#import "TFNoteDetailRemindCell.h"
#import "TFNoteDetailShareCell.h"
#import "TFNoteDetailRelatedCell.h"
#import "TFProjectRowFrameModel.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFNewProjectCustomCell.h"
#import "TFTProjectCustomCell.h"
#import "TFProjectApprovalCell.h"
#import "TFNewProjectTaskItemCell.h"


@interface TFNoteDetailCardCell ()<UITableViewDelegate,UITableViewDataSource,TFNoteDetailAddressCellDelegate,TFNoteDetailRelatedCellDelegate,TFNoteDetailRemindCellDelegate,TFNoteDetailShareCellDelegate,TFProjectTaskItemCellDelegate,TFProjectNoteCellDelegate,TFNewProjectCustomCellDelegate,TFProjectApprovalCellDelegate,TFNewProjectTaskItemCellDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 图标 */
@property (nonatomic, strong) UIButton *imgBtn;
/** 背景视图 */
@property (nonatomic ,strong) UIView *borderView;

@property (nonatomic, strong) TFCreateNoteModel *model;

@end

@implementation TFNoteDetailCardCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupChildView];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView {
    
    UIView *borderView = [[UIView alloc] init];
    [self.contentView addSubview:borderView];
    self.borderView = borderView;
    borderView.layer.cornerRadius = 4;
    borderView.backgroundColor = WhiteColor;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-10);
        
    }];
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgBtn = imgBtn;
    [self.borderView addSubview:imgBtn];
    
    [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.borderView).with.offset(4);
        make.top.equalTo(self.borderView).with.offset(10);
        make.width.height.equalTo(@20);
    }];
    
    
    UILabel *lable = [[UILabel alloc] init];
    [self.borderView addSubview:lable];
    lable.textColor = ThreeColor;
    lable.font = BFONT(14);
    self.titleLabel = lable;
    lable.numberOfLines = 0;
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imgBtn.mas_right).offset(2);
        make.top.equalTo(self.borderView).with.offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-80));
        make.height.equalTo(@20);
        
    }];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH-20, 65) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    [borderView addSubview:tableView];
    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    
}

//刷新cell
- (void)refreshNoteDetailCardCellWithArray:(TFCreateNoteModel *)model {
    
    self.titleLabel.text = self.title;
    
    self.model = model;
    if (self.cellType == NoteDetailCellLocation) {
        
        [self.imgBtn setImage:IMG(@"新备忘录定位") forState:UIControlStateNormal];
        if (model.locations.count == 0) {
            
            self.tableView.height = 0;
        }
        else {
            
            self.tableView.height = model.locations.count*65;
        }
    }
    else if (self.cellType == NoteDetailCellRelated) {
        
        [self.imgBtn setImage:IMG(@"新备忘录定位") forState:UIControlStateNormal];
        
        if (model.relations.count == 0) {
            
            self.tableView.height = 0;
        }
        else {
            
            CGFloat relateH = 0;
            for (TFProjectRowFrameModel *frame in model.relations) {
                relateH += frame.cellHeight;
            }
            relateH += (model.relations.count-1)*5;
            
            self.tableView.height = relateH + 5;
        }
        
    }
    else if (self.cellType == NoteDetailCellRemind) {
        
        [self.imgBtn setImage:IMG(@"新备忘录提醒实心") forState:UIControlStateNormal];
        if (model.remindTime == nil || [model.remindTime isEqualToString:@""]) {
            
            self.tableView.height = 0;
        }
        else {
            
            self.tableView.height = 45;
        }
        
    }
    else if (self.cellType == NoteDetailCellShare) {
        
        [self.imgBtn setImage:IMG(@"共享实心") forState:UIControlStateNormal];
        self.tableView.height = [TFNoteDetailShareCell refreshNoteDetailShareHeightWithArray:model withColumn:6];
    }
    
    
    [self.tableView reloadData];
    
}

//刷新高度
+ (CGFloat)refreshNoteDetailCardCellHeightWithArray:(TFCreateNoteModel *)model cellType:(NoteDetailCellType)cellType {
    
    CGFloat height = 0.0;
    
    height += 35;
    height += 10;
    
    if (cellType == NoteDetailCellLocation) {
        
        height += model.locations.count*65;
    }
    if (cellType == NoteDetailCellRelated) {
        CGFloat relateH = 0;
        for (TFProjectRowFrameModel *frame in model.relations) {
            relateH += frame.cellHeight;
        }
        height += relateH + (model.relations.count-1)*5 + 5;
    }
    if (cellType == NoteDetailCellRemind) {
        
        height += 40;
    }
    if (cellType == NoteDetailCellShare) {
        
        height += [TFNoteDetailShareCell refreshNoteDetailShareHeightWithArray:model withColumn:6];
    }
    return height;
    
}

#pragma mark - 删除事件
-(void)noteDetailAddressCellDidDeleteBtnWithIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(deleteNoteLocationWithIndex:)]) {
        
        [self.delegate deleteNoteLocationWithIndex:index];
    }
}

-(void)noteDetailRelatedCellDidDeleteBtn:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(deleteNoteRelatedWithIndex:)]) {
        
        [self.delegate deleteNoteRelatedWithIndex:index];
    }
}

-(void)deleteNoteRemindWithIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(deleteNoteRemindWithIndex:)]) {
        
        [self.delegate deleteNoteRemindWithIndex:index];
    }
}

-(void)noteDetailShareCellDidDeleteBtn:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(deleteNoteSharesWithIndex:)]) {
        
        [self.delegate deleteNoteSharesWithIndex:index];
    }
}

-(void)noteDetailSingleSharerDidDeleteBtn:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(deleteNoteSingleSharerWithIndex:)]) {
        
        [self.delegate deleteNoteSingleSharerWithIndex:index];
    }
}


-(void)noteDetailDidClickedPeople:(HQEmployModel *)people{
    if ([self.delegate respondsToSelector:@selector(didClickedPeopleWithModel:)]) {
        [self.delegate didClickedPeopleWithModel:people];
    }
}

#pragma mark - 初始化tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.cellType == NoteDetailCellLocation) {
        
        return self.model.locations.count;
    }
    else if (self.cellType == NoteDetailCellRelated) {
        
        return self.model.relations.count;
    }
    else {
        
        return 1;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.cellType == NoteDetailCellLocation) { //位置
        
        TFLocationModel *model = self.model.locations[indexPath.section];
        TFNoteDetailAddressCell *cell = [TFNoteDetailAddressCell noteDetailAddressCellWithTableView:tableView];
        if (self.type == 1) {
            
            cell.deleteBtn.hidden = YES;
        }
        cell.delegate = self;
        cell.index = indexPath.section;
        [cell refreshNoteDetailAddressCellWithData:model];
        return cell;
    }
    else if (self.cellType == NoteDetailCellRelated){ //关联
        
//        TFNoteDetailRelatedCell *cell = [TFNoteDetailRelatedCell noteDetailRelatedCellWithTableView:tableView];
//        if (self.type == 1) {
//            cell.deleteBtn.hidden = YES;
//        }
//        cell.type = self.type;
//        cell.delegate = self;
//        cell.index = indexPath.section;
//        NSDictionary *dic = self.model.relations[indexPath.section];
//        [cell refreshNoteDetailRelatedCellWithData:dic];
//        return cell;
        
        TFProjectRowFrameModel *model = self.model.relations[indexPath.section];
        TFProjectRowModel *row = model.projectRow;
        
        /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 ) */
        if ([row.dataType isEqualToNumber:@2]) {// 任务
            
//            TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
//            cell.frameModel = model;
//
//            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
//                cell.hidden = NO;
//            }else{
//                cell.hidden = YES;
//            }
//            cell.tag = indexPath.section;
//            cell.delegate = self;
//            cell.edit = self.type == 1 ? NO : YES;
//            cell.knowledge = 2;
//            return cell;
            
            
            
            TFNewProjectTaskItemCell *cell = [TFNewProjectTaskItemCell newProjectTaskItemCellWithTableView:tableView];
            [cell refreshNewProjectTaskItemCellWithModel:row haveClear:self.type == 1 ? NO : YES];
            cell.tag = indexPath.row;
            cell.hidden = NO;
            cell.delegate = self;
            cell.contentView.backgroundColor = WhiteColor;
            cell.backgroundColor = WhiteColor;
            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            return cell;
            
        }else if ([row.dataType isEqualToNumber:@1]){// 备忘录
            
            TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
            cell.frameModel = model;
            
            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.edit = self.type == 1 ? NO : YES;
            return cell;
            
        }else if ([row.dataType isEqualToNumber:@3]){// 自定义
            
            if (row.rows) {
                
                TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
                cell.frameModel = model;
                
                if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                    cell.hidden = NO;
                }else{
                    cell.hidden = YES;
                }
                cell.tag = indexPath.section;
                cell.delegate = self;
                cell.edit = self.type == 1 ? NO : YES;
                return cell;
            }
            TFTProjectCustomCell *cell = [TFTProjectCustomCell projectCustomCellWithTableView:tableView];
            cell.frameModel = model;
            
            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            return cell;
            
        }else{// 审批
            TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
            cell.frameModel = model;
            
            if (!row.hidden || [row.hidden isEqualToString:@"0"]) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
            cell.tag = indexPath.section;
            cell.delegate = self;
            cell.edit = self.type == 1 ? NO : YES;
            return cell;
            
        }
    }
    else if (self.cellType == NoteDetailCellRemind){ //提醒
        
//        NSString *string = self.array[indexPath.row];
        TFNoteDetailRemindCell *cell = [TFNoteDetailRemindCell noteDetailRemindCellWithTableView:tableView];
        if (self.type == 1) {
            
            cell.deleteBtn.hidden = YES;
        }
        cell.delegate = self;
        cell.index = indexPath.section;
        [cell refreshNoteDetailRemindCellWithData:self.model.remindTime];
        
        return cell;
    }
    else { //分享
        
        TFNoteDetailShareCell *cell = [TFNoteDetailShareCell NoteDetailShareCellWithTableView:tableView];
        
        cell.type = self.type;
        [cell refreshNoteDetailShareCellWithArray:self.model.sharers withColumn:6];
        
        if (self.type == 1) {
            
            cell.clearBtn.hidden = YES;
        }
        cell.delegate = self;
        cell.index = indexPath.section;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 1) {// 详情时点击
        
        if (self.cellType == NoteDetailCellLocation) {// 位置
            
            if ([self.delegate respondsToSelector:@selector(didClickedLocation:)]) {
                [self.delegate didClickedLocation:self.model.locations[indexPath.section]];
            }
        }
        
        if (self.cellType == NoteDetailCellRelated) {// 关联
            
            TFProjectRowFrameModel *model = self.model.relations[indexPath.section];
            TFProjectRowModel *row = model.projectRow;
            if ([self.delegate respondsToSelector:@selector(didClickedReferanceWithDataId:bean:moduleId:model:)]) {
                [self.delegate didClickedReferanceWithDataId:row.bean_id bean:row.bean_name moduleId:row.module_id model:row];
            }
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.cellType == NoteDetailCellRemind) {
        
        return 40;
    }
    if (self.cellType == NoteDetailCellShare) {
        
        return [TFNoteDetailShareCell refreshNoteDetailShareHeightWithArray:self.model withColumn:6];;
    }
    if (self.cellType == NoteDetailCellRelated) {
        
        TFProjectRowFrameModel *model = self.model.relations[indexPath.section];
        
        return model.cellHeight;
    }
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
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

+ (TFNoteDetailCardCell *)NoteDetailCardCellWithTableView:(UITableView *)tableView {
    
    static NSString *indentifier = @"TFNoteDetailCardCell";
    TFNoteDetailCardCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFNoteDetailCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark = TFProjectTaskItemCellDelegate
-(void)projectTaskItemCellDidClickedClearBtn:(TFProjectTaskItemCell *)cell{
    
    [self.model.relations removeObjectAtIndex:cell.tag];
    if ([self.delegate respondsToSelector:@selector(changeHeight)]) {
        [self.delegate changeHeight];
    }
}
#pragma mark - TFProjectNoteCellDelegate
-(void)projectNoteCellDidClickedClearBtn:(TFProjectNoteCell *)cell{
    
    [self.model.relations removeObjectAtIndex:cell.tag];
    if ([self.delegate respondsToSelector:@selector(changeHeight)]) {
        [self.delegate changeHeight];
    }
}

#pragma mark - TFNewProjectCustomCellDelegate
-(void)newProjectCustomCellDidClickedClearBtn:(TFNewProjectCustomCell *)cell{
    
    [self.model.relations removeObjectAtIndex:cell.tag];
    if ([self.delegate respondsToSelector:@selector(changeHeight)]) {
        [self.delegate changeHeight];
    }
}
#pragma mark - TFProjectApprovalCellDelegate
-(void)projectApprovalCellDidClickedClearBtn:(TFProjectApprovalCell *)cell{
    
    [self.model.relations removeObjectAtIndex:cell.tag];
    if ([self.delegate respondsToSelector:@selector(changeHeight)]) {
        [self.delegate changeHeight];
    }
}


@end
