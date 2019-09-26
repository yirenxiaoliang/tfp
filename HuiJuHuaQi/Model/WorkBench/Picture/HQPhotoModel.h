//
//  HQPhotoModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/19.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQPictureModel.h"


@protocol HQPhotoModel @end


@interface HQPhotoModel : HQPictureModel


/**
 * 图片名称，默认为空
 */
@property (nonatomic, strong) NSString <Optional>*name;


/**
 * 图片描述
 */
@property (nonatomic, strong) NSString <Optional>*info;


/**
 * 上传日期
 */
@property (nonatomic, assign) long long date;


///**
// * 是否可以删除
// */
//@property (nonatomic, assign) BOOL canDelete;


@end
