//
//  TFNoteDetailShareCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCreateNoteModel.h"
#import "HQEmployModel.h"

@protocol TFNoteDetailShareCellDelegate <NSObject>

@optional
-(void)noteDetailShareCellDidDeleteBtn:(NSInteger)index;

-(void)noteDetailSingleSharerDidDeleteBtn:(NSInteger)index;

-(void)noteDetailDidClickedPeople:(HQEmployModel *)people;

@end

@interface TFNoteDetailShareCell : UITableViewCell

@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, weak) id <TFNoteDetailShareCellDelegate>delegate;

+ (TFNoteDetailShareCell *)NoteDetailShareCellWithTableView:(UITableView *)tableView;

/** 刷新cell
 *  @param model 模型
 *  @param column  一行几个
 */
- (void)refreshNoteDetailShareCellWithArray:(NSArray *)array withColumn:(NSInteger)column;

/** 高度 */
+(CGFloat)refreshNoteDetailShareHeightWithArray:(TFCreateNoteModel *)model withColumn:(NSInteger)column;

@end
