//
//  TFTagListView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerOptionModel.h"

@protocol TFTagListViewDelegate <NSObject>

@optional
- (void)tagListViewHeight:(CGFloat)height;

@end

@interface TFTagListView : UIView

/** 刷新选项 */
-(void)refreshWithOptions:(NSArray *)options;
/** delegate */
@property (nonatomic, weak) id <TFTagListViewDelegate>delegate;

/** 刷新知识库选项 */
-(void)refreshKnowledgeWithOptions:(NSArray *)options;

@end
