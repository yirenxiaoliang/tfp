//
//  TFAutoMatchRuleModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFAutoMatchRuleModel : JSONModel

/**
 "id" : 1,
 "title" : "我是匹配",
 "chinese_name" : "联动数据",
 "employee_name" : "尹明亮",
 "modify_time" : 1536750775383,
 "english_name" : "bean1536029252416"
 }
 */
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** title */
@property (nonatomic, copy) NSString <Optional>*title;
/** chinese_name */
@property (nonatomic, copy) NSString <Optional>*chinese_name;
/** employee_name */
@property (nonatomic, copy) NSString <Optional>*employee_name;
/** modify_time */
@property (nonatomic, strong) NSNumber <Optional>*modify_time;
/** english_name */
@property (nonatomic, copy) NSString <Optional>*english_name;





@end
