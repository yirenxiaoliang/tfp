//
//  TFPicturePositionModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFPicturePositionModel : JSONModel

/** 类型 0:文字 1:图片*/
@property (nonatomic, assign) NSInteger type;
/** 文字 */
@property (nonatomic, copy) NSString *word;
/** 图片 */
@property (nonatomic, strong) UIImage *image;
/** 图片位置 */
@property (nonatomic, assign) NSInteger position;
/** 图片范围 */
@property (nonatomic, assign) NSRange range;
/** 存放图片的rect的数组 */
@property (nonatomic, strong) NSArray *specialRects;
/** 存放绘图图片path的数组 */
@property (nonatomic, strong) NSMutableArray *paths;
/** 网络图片 */
@property (nonatomic, assign) NSInteger network;
/** 网络地址 */
@property (nonatomic, copy) NSString *networkUrl;

@end
