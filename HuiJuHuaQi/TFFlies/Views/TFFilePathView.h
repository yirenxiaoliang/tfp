//
//  TFFilePathView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFFilePathModel;

@protocol TFFilePathViewDelegate <NSObject>

@optional

- (void)selectFilePath:(NSInteger)index;

- (void)selectFilePathWithModel:(TFFilePathModel *)mdoel;

@end

@interface TFFilePathModel : NSObject

/** class */
@property (nonatomic, assign) Class className;

/** vcTag */
@property (nonatomic, assign) NSInteger vcTag;

/** name */
@property (nonatomic, copy) NSString *name;

@end


@interface TFFilePathView : UIView

- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<TFFilePathModel *> *)models;

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

@property (nonatomic, weak) id <TFFilePathViewDelegate>delegate;


@end
