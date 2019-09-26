//
//  HQConversationController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/25.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface HQConversationController : HQBaseViewController<JMessageDelegate>

@property(strong, nonatomic) JMSGConversation *conversation;

/** gruopType 0：普通群和个人 1:小秘书 2：公司群 */
@property(assign, nonatomic) NSInteger gruopType;

/** isConversationChange */
@property(assign, nonatomic) BOOL isConversationChange;

@property(weak,nonatomic)id superViewController;

@property(strong, nonatomic) NSString *targetName;

- (void)setupView;
@end
