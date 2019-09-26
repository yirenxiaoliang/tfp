//
//  TFOptionListView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"

@interface TFOptionListView : UIView

/** 刷新选项 */
-(void)refreshWithOptions:(NSArray *)options;
-(void)refreshWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit;
/** 高度 */
+(CGFloat)refreshOptionListViewHeightWithOptions:(NSArray *)options;

/** 高度 */
+(CGFloat)refreshOptionListViewHeightWithOptions:(NSArray *)options maxWidth:(CGFloat)maxWidth;

/** 高度 */
+(CGFloat)refreshOptionListViewHeightWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit;
@end
