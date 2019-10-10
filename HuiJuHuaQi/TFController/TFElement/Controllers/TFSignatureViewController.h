//
//  TFSignatureViewController.h
//  HuiJuHuaQi
//
//  Created by daidan on 2019/10/10.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFSignatureViewController : HQBaseViewController

/** 模块标识 */
@property (nonatomic, copy) NSString *bean;
/** 图片url回调 */
@property (nonatomic, copy) ActionParameter imagePath;

@end

NS_ASSUME_NONNULL_END
