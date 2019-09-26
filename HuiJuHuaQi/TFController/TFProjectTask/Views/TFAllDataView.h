//
//  TFAllDataView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/13.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TFAllDataView;
@protocol TFAllDataViewDelegate <NSObject>

-(void)allDataView:(TFAllDataView *)allDataView didChangeHeight:(CGFloat)height;

@end

@interface TFAllDataView : UIView

/** 刷新数据 */
-(void)refreshAllDataViewWithDatas:(NSArray *)datas;

/** delegate */
@property (nonatomic, weak) id <TFAllDataViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
