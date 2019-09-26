//
//  TFProjectClassModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFProjectClassModel : NSObject

/** 分类名 */
@property (nonatomic, copy) NSString *templateName;

/** 分类id */
@property (nonatomic, strong) NSNumber *templateId;

/** 选择 */
@property (nonatomic, assign) NSInteger select;

/**  */
@property (nonatomic, copy) NSString *system_default_pic;
/**  */
@property (nonatomic, copy) NSString *pic_url;

/** 模板s */
@property (nonatomic, strong) NSMutableArray *templates;



@end
