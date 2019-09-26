//
//  HQPhotoView.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/10.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQPhotoViewDelegate <NSObject>

@optional
/** 删除图片返回剩余图片 */
- (void)photoViewDeletePictureReturePicture:(NSMutableArray *)picture;
/** 删除图片返回剩余图片并告诉删除的图片index */
- (void)photoViewDeletePictureReturePicture:(NSMutableArray *)picture pictureIndex:(NSInteger)index;

@end

typedef enum photoViewType{
    photoViewTypeNormal,  // 显示用
    photoViewTypeMinus    // 可删除图片
}photoViewType;

@interface HQPhotoView : UIView

@property (nonatomic, weak) id<HQPhotoViewDelegate> delegate;
@property (nonatomic, assign) BOOL isLine;
// 标示photoView类型
@property (nonatomic, assign) photoViewType type;
/**
 *  存放图片数组
 */
@property (nonatomic, strong) NSMutableArray *photos;


/** 创建photoView */
+ (instancetype)photoView;


/**
 *  刷新视图
 *  @param photos         图片数组
 *  @param distanceFloat  图片间距
 *  @param lineNum        一行图片个数
 *
 */
- (void)refreshPhotoViewWithPhotos:(NSArray *)photos
                     distanceFloat:(float)distanceFloat
                           lineNum:(NSInteger)lineNum;

@end
