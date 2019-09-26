//
//  TFGroupDetailModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFGroupDetailModel : JSONModel

/**
 "gid" : "23107653",
 "ctime" : "2017-06-17 10:45:07",
 "appkey" : null,
 "mtime" : "2017-06-17 10:45:07",
 "groupType" : "0",
 "backGround" : "0",
 "maxMemberCount" : "500",
 "owner_username" : null,
 "name" : "在线内已",
 "desc" : "这些吧、" */

/** gid */
@property (nonatomic, copy) NSString <Optional>*gid;
/** gid */
@property (nonatomic, copy) NSString <Optional>*name;
/** gid */
@property (nonatomic, copy) NSString <Optional>*desc;
/** gruopType 0：普通群 1:小秘书 2：公司群 */
@property (nonatomic, copy) NSString <Optional>*groupType;




@end
