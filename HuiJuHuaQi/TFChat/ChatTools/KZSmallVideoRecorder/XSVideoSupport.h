//
//  XSVideoConfig.h
//  ChatTest
//
//  Created by 肖胜 on 2017/5/21.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSVideoConfig.h"
@class XSVideoModel;

//************* 录视频 顶部 状态 条 ****************
@interface XSStatusBar : UIView

- (instancetype)initWithFrame:(CGRect)frame style:(XSVideoViewShowType)style;

- (void)addCancelTarget:(id)target selector:(SEL)selector;

@property (nonatomic, assign) BOOL isRecoding;

@end


//************* 关闭的下箭头按钮 ****************
@interface XSCloseBtn : UIButton

@property (nonatomic,strong) NSArray *gradientColors; //CGColorRef


@end

//************* 点击录制的按钮 ****************
@interface XSRecordBtn : UIView

- (instancetype)initWithFrame:(CGRect)frame style:(XSVideoViewShowType)style;

@end


//************* 聚焦的方框 ****************
@interface XSFocusView : UIView

- (void)focusing;

@end

//************* 眼睛 ****************
@interface XSEyeView : UIView

@end

//************* 录视频下部的控制条 ****************
typedef NS_ENUM(NSUInteger, XSRecordCancelReason) {
    XSRecordCancelReasonDefault,
    XSRecordCancelReasonTimeShort,
    XSRecordCancelReasonUnknown,
};

@class XSControllerBar;
@protocol XSControllerBarDelegate <NSObject>

@optional

- (void)ctrollVideoDidStart:(XSControllerBar *)controllerBar;

- (void)ctrollVideoDidEnd:(XSControllerBar *)controllerBar;

- (void)ctrollVideoDidCancel:(XSControllerBar *)controllerBar reason:(XSRecordCancelReason)reason;

- (void)ctrollVideoWillCancel:(XSControllerBar *)controllerBar;

- (void)ctrollVideoDidRecordSEC:(XSControllerBar *)controllerBar;

- (void)ctrollVideoDidClose:(XSControllerBar *)controllerBar;

- (void)ctrollVideoOpenVideoList:(XSControllerBar *)controllerBar;

@end
//************* 录视频下部的控制条 ****************
@interface XSControllerBar : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<XSControllerBarDelegate> delegate;

- (void)setupSubViewsWithStyle:(XSVideoViewShowType)style;

@end

//************************* Video List 控件 **************************

//************* 删除视频的圆形叉叉 ****************
@interface XSCircleCloseBtn : UIButton

@end

//************* 视频列表 ****************
@interface XSVideoListCell:UICollectionViewCell

@property (nonatomic, strong) XSVideoModel *videoModel;

@property (nonatomic, strong) void(^deleteVideoBlock)(XSVideoModel *);

- (void)setEdit:(BOOL)canEdit;

@end

//************* 视频列表的添加 ****************
@interface XSAddNewVideoCell : UICollectionViewCell

@end
