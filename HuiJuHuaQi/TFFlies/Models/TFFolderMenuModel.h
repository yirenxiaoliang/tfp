//
//  TFFolderMenuModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFFolderMenuModel : JSONModel
/** 1：公司文件 2：应用文件 3：个人文件 4：我共享的 5：与我共享的 6：项目文件 */
@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*status;

@end
