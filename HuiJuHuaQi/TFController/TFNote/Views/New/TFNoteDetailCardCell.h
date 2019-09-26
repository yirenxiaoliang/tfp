//
//  TFNoteDetailCardCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCreateNoteModel.h"
#import "TFLocationModel.h"

typedef enum {
    NoteDetailCellLocation,// 位置
    NoteDetailCellRemind, // 提醒
    NoteDetailCellRelated, //关联
    NoteDetailCellShare //分享
}NoteDetailCellType;

@protocol TFNoteDetailCardCellDelegate <NSObject>

@optional
-(void)deleteNoteLocationWithIndex:(NSInteger)index;
-(void)deleteNoteRelatedWithIndex:(NSInteger)index;
-(void)deleteNoteRemindWithIndex:(NSInteger)index;
-(void)deleteNoteSharesWithIndex:(NSInteger)index;
-(void)deleteNoteSingleSharerWithIndex:(NSInteger)index;
-(void)didClickedLocation:(TFLocationModel *)location;
-(void)didClickedReferanceWithDataId:(NSNumber *)dataId bean:(NSString *)bean moduleId:(NSNumber *)moduleId model:(id)model;
-(void)didClickedPeopleWithModel:(HQEmployModel *)people;
-(void)changeHeight;

@end

@interface TFNoteDetailCardCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
/** 0:新增 1:详情 2:编辑 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, weak) id <TFNoteDetailCardCellDelegate>delegate;

@property (nonatomic, assign) NoteDetailCellType cellType;

- (void)refreshNoteDetailCardCellWithArray:(TFCreateNoteModel *)model;

+ (TFNoteDetailCardCell *)NoteDetailCardCellWithTableView:(UITableView *)tableView;

+ (CGFloat)refreshNoteDetailCardCellHeightWithArray:(TFCreateNoteModel *)model cellType:(NoteDetailCellType)cellType;

@end
