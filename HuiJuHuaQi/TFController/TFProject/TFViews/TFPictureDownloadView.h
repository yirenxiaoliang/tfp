//
//  TFPictureDownloadView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFPictureDownloadView;

@protocol TFPictureDownloadViewDelegate <NSObject>

@optional
-(void)pictureDownloadView:(TFPictureDownloadView *)pictureDownloadView withIndex:(NSInteger)index;

@end

@interface TFDownloadModel : NSObject

/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 图片 */
@property (nonatomic, copy) NSString *image;

@end

@interface TFPictureDownloadView : UIView

-(void)pictureDownloadViewWithModels:(NSArray *)models;

/** Delegate */
@property (nonatomic, weak) id <TFPictureDownloadViewDelegate>delegate;


@end
