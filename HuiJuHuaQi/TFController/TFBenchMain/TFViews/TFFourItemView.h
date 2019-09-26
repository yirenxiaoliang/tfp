//
//  TFFourItemView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class TFFourItemView;
@protocol TFFourItemViewDelegate <NSObject>

@optional
-(void)fourItemViewDidClicked:(TFFourItemView *)itemView;

@end

@interface TFFourItemView : UIView

+(instancetype)fourItemView;

@property (nonatomic, assign) NSInteger taskCount;

@property (nonatomic, assign) NSInteger type;


@property (nonatomic, weak) id <TFFourItemViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
