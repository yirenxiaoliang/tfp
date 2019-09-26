//
//  HQPictureModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/19.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol HQPictureModel  @end

@interface HQPictureModel : JSONModel


/**
 * 图片id
 */
@property (nonatomic, strong) NSString <Optional>*imageID;


/**
 * 绝对路径
 */
@property (nonatomic, strong) NSString <Optional>* absolutePath;


/**
 * 是否被选中
 */
@property (nonatomic, assign) NSInteger choose;


/**
 * 图片url路径
 */
@property (nonatomic, strong) NSString <Optional>*url;


/**
 * 默认的图片（可以设置为drawable中的资源ID）
 */
@property (nonatomic, assign) NSInteger defaultImage;

@end
