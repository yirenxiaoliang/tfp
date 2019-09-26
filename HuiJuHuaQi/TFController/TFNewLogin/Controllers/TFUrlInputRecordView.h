//
//  TFUrlInputRecordView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFUrlInputRecordViewDelegate <NSObject>

@optional
-(void)urlInputRecordViewSelectUrl:(NSString *)url;

@end

@interface TFUrlInputRecordView : UIView


@property (nonatomic, weak) id <TFUrlInputRecordViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
