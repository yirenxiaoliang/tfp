//
//  TFApprovalTableView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TFApprovalTableView;
@protocol TFApprovalTableViewDelegate <NSObject>

-(void)approvalTableView:(TFApprovalTableView *)approvalTableView didChangeHeight:(CGFloat)height;
@end

@interface TFApprovalTableView : UIView

/** 刷新数据 */
-(void)refreshApprovalTableViewWithDatas:(NSArray *)datas;

/** delegate */
@property (nonatomic, weak) id <TFApprovalTableViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
