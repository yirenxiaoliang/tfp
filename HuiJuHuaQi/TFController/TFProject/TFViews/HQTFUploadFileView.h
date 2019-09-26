//
//  HQTFUploadFileView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQTFUploadFileView : UIView

/**
 * 提示框
 * @param title 标题
 * @param type 类型 0：任务详情  1：上传文件 2：三个按钮 3：文件库 4：组织架构 5：分享 6：随手记 7：随手记添加笔记 8：审批详情 9：文件详情更多 10：日程详情更多 11：客户更多 12：沟通关联
 */
+ (void) showAlertView:(NSString *)title
              withType:(NSInteger)type
       parameterAction:(ActionParameter)parameter;


@end
