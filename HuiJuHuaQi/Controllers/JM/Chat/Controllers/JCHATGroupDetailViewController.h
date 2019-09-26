//
//  JCHATGroupDetailViewController.h
//  JChat
//
//  Created by HuminiOS on 15/11/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQConversationController.h"
#import "HQBaseViewController.h"

typedef NS_ENUM(NSInteger, AlertViewTag) {
//清除聊天记录
  kAlertViewTagClearChatRecord = 100,
//修改群名
  kAlertViewTagRenameGroup = 200,
//添加成员
  kAlertViewTagAddMember = 300,
//退出群组
  kAlertViewTagQuitGroup = 400
};

@interface JCHATGroupDetailViewController : HQBaseViewController
@property (nonatomic,weak) JMSGConversation *conversation;
//@property (nonatomic,weak) JCHATConversationViewController *sendMessageCtl;
@property (nonatomic,weak) HQConversationController *sendMessageCtl;
@property (nonatomic,strong) NSMutableArray <__kindof JMSGUser *>*memberArr;

- (void)quitGroup;
- (void)switchDisturb;
@end
