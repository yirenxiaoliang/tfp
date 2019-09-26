//
//  KSPhotoBrowser.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPhotoItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KSPhotoBrowserInteractiveDismissalStyle) {
    KSPhotoBrowserInteractiveDismissalStyleRotation,
    KSPhotoBrowserInteractiveDismissalStyleScale,
    KSPhotoBrowserInteractiveDismissalStyleSlide,
    KSPhotoBrowserInteractiveDismissalStyleNone
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserBackgroundStyle) {
    KSPhotoBrowserBackgroundStyleBlurPhoto,
    KSPhotoBrowserBackgroundStyleBlur,
    KSPhotoBrowserBackgroundStyleBlack
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserPageIndicatorStyle) {
    KSPhotoBrowserPageIndicatorStyleDot,
    KSPhotoBrowserPageIndicatorStyleText
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserImageLoadingStyle) {
    KSPhotoBrowserImageLoadingStyleIndeterminate,
    KSPhotoBrowserImageLoadingStyleDeterminate
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserType) {
    KSPhotoBrowserTypeNone,   // 无
    KSPhotoBrowserTypeShareDownload, // 共享跟下载
    KSPhotoBrowserTypeShareHistory
};

@protocol KSPhotoBrowserDelegate;
@interface KSPhotoBrowser : UIViewController

@property (nonatomic, assign) KSPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (nonatomic, assign) KSPhotoBrowserBackgroundStyle backgroundStyle;
@property (nonatomic, assign) KSPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (nonatomic, assign) KSPhotoBrowserImageLoadingStyle loadingStyle;
@property (nonatomic, assign) KSPhotoBrowserType showType;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, strong) UIButton *historyBtn;
@property (nonatomic, weak) id<KSPhotoBrowserDelegate> delegate;
/** 标题 */
@property (nonatomic, assign) NSString *fileTitle;


+ (instancetype)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;
- (instancetype)initWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;
- (void)showFromViewController:(UIViewController *)vc;

@end

@protocol KSPhotoBrowserDelegate <NSObject>

@optional
- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index;
@optional
- (void)historyVersionBtn:(UIButton *)button;

@end



NS_ASSUME_NONNULL_END
