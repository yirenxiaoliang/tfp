//
//  TFKnowledgeDetailHeader.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFKnowledgeItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFKnowledgeDetailHeaderDelegate<NSObject>

-(void)knowledgeDetailHeaderDidStar:(UIButton *)button;
-(void)knowledgeDetailHeaderDidGood:(UIButton *)button;
-(void)knowledgeDetailHeaderDidLearn:(UIButton *)button;
-(void)knowledgeDetailHeaderDidAnswer;
-(void)knowledgeDetailHeaderDidInvite;

@end


@interface TFKnowledgeDetailHeader : UIView

+(instancetype)knowledgeDatailHeader;

/** delegate */
@property (nonatomic, weak) id <TFKnowledgeDetailHeaderDelegate>delegate;

/** 刷新 */
-(void)refreshKnowledgeDetailHeaderWithModel:(TFKnowledgeItemModel *)model type:(NSInteger)type auth:(NSInteger)auth;
-(CGFloat)knowledgeDetailHeaderWithModel:(TFKnowledgeItemModel *)model type:(NSInteger)type;

/** 折叠 */
-(void)foldDetailHeader;
/** 展开 */
-(void)unfoldDetailHeader;

@property (nonatomic, assign) CGFloat selfHeight;

/** star */
@property (nonatomic, assign) BOOL star;
/** good */
@property (nonatomic, assign) BOOL good;
/** learn */
@property (nonatomic, assign) BOOL learn;


@end

NS_ASSUME_NONNULL_END
