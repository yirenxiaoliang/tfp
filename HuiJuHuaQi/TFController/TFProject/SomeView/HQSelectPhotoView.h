//
//  HQSelectPhotoView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HQSelectPhotoViewDelegate <NSObject>

- (void)addPhotoAction;

- (void)deletePhotoActionWithIndex:(NSInteger)index;

- (void)lookAtPhotoActionWithIndex:(NSInteger)index;

- (void)lookAtPhotoActionWithIndex:(NSInteger)index imageViews:(NSArray *)imageViews;


@end



@interface HQSelectPhotoView : UIView

@property (nonatomic, assign) NSInteger maxNum;

/* 一行图片数 */
@property (nonatomic, assign) NSInteger lineMaxNum;

@property (nonatomic, weak) id <HQSelectPhotoViewDelegate> delegate;



/**
 *  初始化
 *
 *  @param frame
 *  @param maxNum     最大图片数
 *  @param lineMaxNum 一行最大图片
 *  @param imgArr     本地图片数组
 *  @param urlArr     网络图片链接数组
 *  @param delegate
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
                       maxNum:(NSInteger)maxNum
                   lineMaxNum:(NSInteger)lineMaxNum
                       imgArr:(NSArray *)imgArr
                       urlArr:(NSArray *)urlArr
                     delegate:(id<HQSelectPhotoViewDelegate>)delegate;


/**
 *  初始化（一行四张图）
 */
- (instancetype)initWithFrame:(CGRect)frame
                       maxNum:(NSInteger)maxNum
                       imgArr:(NSArray *)imgArr
                       urlArr:(NSArray *)urlArr
                     delegate:(id<HQSelectPhotoViewDelegate>)delegate;


/**
 *  刷新选择视图
 *
 *  @param imgArr 图片数组
 *  @param urlArr 图片URL数组
 */
- (void)refreshSelectPhotoViewWithImgArr:(NSArray *)imgArr
                                  urlArr:(NSArray *)urlArr;


/**
 *  刷新选择视图
 *
 *  @param imgArr            图片数组
 *  @param urlArr            图片URL数组
 *  @param editeOrLookAtSate 编辑还是查看，NO为编辑
 */
- (void)refreshSelectPhotoViewWithImgArr:(NSArray *)imgArr
                                  urlArr:(NSArray *)urlArr
                       editeOrLookAtSate:(BOOL)editeOrLookAtSate;


@end
