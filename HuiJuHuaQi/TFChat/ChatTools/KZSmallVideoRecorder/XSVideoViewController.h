//
//  XSVideoViewController.h
//  ChatTest
//
//  Created by 肖胜 on 2017/5/21.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSVideoConfig.h"
@protocol XSVideoViewControllerDelegate;

// 主类  更多自定义..修改XSVideoConfig.h里面的define
@interface XSVideoViewController : NSObject

@property (nonatomic, strong, readonly) UIView *view;

@property (nonatomic, strong, readonly) UIView *actionView;

//保存到相册
@property (nonatomic, assign) BOOL savePhotoAlbum;

@property (nonatomic, assign) id<XSVideoViewControllerDelegate> delegate;

- (void)startAnimationWithType:(XSVideoViewShowType)showType;

//- (void)endAniamtion;

@end

@protocol XSVideoViewControllerDelegate <NSObject>

@required
- (void)videoViewController:(XSVideoViewController *)videoController didRecordVideo:(XSVideoModel *)videoModel;

@optional
- (void)videoViewControllerDidCancel:(XSVideoViewController *)videoController;

@end
