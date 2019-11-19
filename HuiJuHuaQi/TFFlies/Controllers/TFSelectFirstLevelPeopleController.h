//
//  TFSelectFirstLevelPeopleController.h
//  HuiJuHuaQi
//
//  Created by daidan on 2019/11/15.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFSelectFirstLevelPeopleController : HQBaseViewController

/** 选择的人 */
@property (nonatomic, copy) ActionParameter actionParameter;
/** 根目录 1：公司文件 2：应用文件 3：个人文件 4：我共享的 5：与我共享的 6：项目文件 */
@property (nonatomic, assign) NSInteger style;
// 上级文件夹id
@property (nonatomic, strong) NSNumber *lastfolderId;
@end

NS_ASSUME_NONNULL_END
