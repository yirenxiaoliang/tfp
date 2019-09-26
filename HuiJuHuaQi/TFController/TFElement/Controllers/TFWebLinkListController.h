//
//  TFWebLinkListController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFWebLinkListController : HQBaseViewController

/** 模块bean */
@property (nonatomic, copy) NSString *moduleBean;

/** 1:后台获取发布链接，2:非公海池，3:公海池，4:关联模块 */
@property (nonatomic, copy) NSNumber *source;

/** 公海池IDsource=3必传 */
@property (nonatomic, strong) NSNumber *seasPoolId;

/** 关联模块source=4必传 */
@property (nonatomic, copy) NSString *relevanceModule;
/** 关联字段source=4必传 */
@property (nonatomic, copy) NSString *relevanceField;
/** 关联值source=4必传 */
@property (nonatomic, copy) NSString *relevanceValue;

@end

NS_ASSUME_NONNULL_END
