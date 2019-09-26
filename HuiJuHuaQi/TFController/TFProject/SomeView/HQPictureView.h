//
//  HQPictureView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/3/16.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol HQPictureViewDelegate <NSObject>

- (void)didPictureWithPhotos:(NSArray *)photoArr
                    indexNum:(NSInteger)indexNum;

@end




@interface HQPictureView : UIView



@property (nonatomic, weak) id <HQPictureViewDelegate> delegate;


/**
 *  pictureView设置数据
 *
 *  @param photos         图片数组
 *  @param distanceFloat  图片间距
 *  @param itemWidth      图片大小
 *  @param lineNum        一行几张图
 *
 */
- (void)refreshPictureViewWithPhotos:(NSArray *)photos
                            Distance:(float)distanceFloat
                             itemWidth:(float)itemWidth
                            lineNumber:(NSInteger)lineNum;




@end
