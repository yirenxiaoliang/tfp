//
//  HQTFProjectCollectionViewCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectSeeModel.h"

typedef NS_ENUM(NSUInteger, XWDragCellCollectionViewScrollDirection) {
    XWDragCellCollectionViewScrollDirectionNone = 0,
    XWDragCellCollectionViewScrollDirectionLeft,
    XWDragCellCollectionViewScrollDirectionRight,
    XWDragCellCollectionViewScrollDirectionUp,
    XWDragCellCollectionViewScrollDirectionDown
};

@class HQTFProjectCollectionViewCell;

@protocol HQTFProjectCollectionViewCellDelegate <NSObject>

@optional
- (void)projectCollectionViewCellDidClickedJumpWithIndex:(NSInteger)index;
- (void)projectCollectionViewCellDidClickedTaskWithModel:(TFProjTaskModel *)model;
- (void)projectCollectionViewCellDidclickedCreateTask;
- (void)projectCollectionViewCellDidclickedFinishBtn:(UIButton *)finishBtn withModel:(TFProjTaskModel *)model;


/** **********************************以下代理方法为实验************************************ */
/**
 *  向左右拖动tableViewCell时,通知代理移动
 *
 */
- (void)dragLeftOrRightWithProjectCollectionViewCell:(HQTFProjectCollectionViewCell *)projectCollectionViewCell withMoveCell:(UIView *)moveCell withDirection:(XWDragCellCollectionViewScrollDirection)direction moveCellCenter:(CGPoint)point withModel:(id)model;
/**
 *  当数据源更新的到时候调用，必须实现，需将新的数据源设置为当前tableView的数据源(例如 :_data = newDataArray)
 *  @param newDataArray   更新后的数据源
 */
- (void)dragProjectCollectionViewCell:(HQTFProjectCollectionViewCell *)projectCollectionViewCell newDataArrayAfterMove:(NSArray *)newDataArray;
/**
 *  返回整个CollectionView的数据，必须实现，需根据数据进行移动后的数据重排
 */
- (NSArray *)dataSourceArrayOfProjectCollectionViewCell:(HQTFProjectCollectionViewCell *)projectCollectionViewCell;

@end




@interface HQTFProjectCollectionViewCell : UICollectionViewCell

/** 假数据列表 */
@property (nonatomic, strong) NSArray *taskList;
/** 任务列表 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 是否响应手势 */
@property (nonatomic, assign) BOOL gestureEnable;


/** ProjectSeeBoardType */
@property (nonatomic, assign) ProjectSeeBoardType type;
/** delegate */
@property (nonatomic, weak) id<HQTFProjectCollectionViewCellDelegate>delegate;

- (void)refreshProjectCollectionViewCellWithModel:(TFProjectSeeModel *)model;

@end
