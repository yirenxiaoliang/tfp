//
//  TFKnowledgeSearchView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFKnowledgeSearchViewDelegate <NSObject>

@optional
-(void)knowledgeSearchViewWithHeight:(CGFloat)height;

@end

@interface TFKnowledgeSearchView : UIView


@property (nonatomic, weak) id <TFKnowledgeSearchViewDelegate>delegate;

-(void)refreshKnowledgeSearchViewWithCategorys:(NSArray *)categorys;

@end

NS_ASSUME_NONNULL_END
