//
//  TFKnowledgeFilterView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/24.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFKnowledgeFilterViewDelegate <NSObject>

@optional
-(void)filterViewDidClicked:(BOOL)show;
-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict;

@end

@interface TFKnowledgeFilterView : UIView

/** delegate */
@property (nonatomic, weak) id <TFKnowledgeFilterViewDelegate>delegate;

/** filters */
@property (nonatomic, strong) NSMutableArray *filters;

@end

NS_ASSUME_NONNULL_END
