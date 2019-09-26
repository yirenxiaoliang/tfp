//
//  TFNumButton.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ButtonInfo : NSObject

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger number;

@end

@protocol TFWorkNumButtonDelegate <NSObject>

@optional
-(void)workNumButtonDidClicked:(NSInteger)index;

@end

@interface TFWorkNumButton : UIView

+(instancetype)workNumButton;

@property (nonatomic, strong) ButtonInfo *info;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, weak) id <TFWorkNumButtonDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
