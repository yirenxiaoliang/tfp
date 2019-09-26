//
//  JCHATGroupSettingCtl.h
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
// TODO: 换成collectionview

#import <UIKit/UIKit.h>
#import "HQChatTableView.h"
#import "JCHATGroupPersonView.h"
#import "HQConversationController.h"

@class JMSGConversation;

@interface JCHATGroupSettingCtl : UIViewController<HQChatTableViewDelegate,UITableViewDataSource,UITableViewDelegate,GroupPersonDelegate,UITextFieldDelegate>
@property (nonatomic,strong) HQChatTableView *groupTab;
@property (nonatomic,strong) JMSGConversation *conversation;
@property (nonatomic,strong) HQConversationController *sendMessageCtl;
@property (nonatomic,strong) NSMutableArray *groupData;
@end
