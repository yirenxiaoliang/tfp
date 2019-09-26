//
//  TFChatInfoListCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatInfoListModel.h"

@implementation TFChatInfoListModel

- (TFFMDBModel *)chatListModel {

    TFFMDBModel *model = [[TFFMDBModel alloc] init];
    
//    model.senderName = self.name?self.name:self.employee_name;
    model.chatType = self.chat_type;
    model.chatId = self.id;
    model.receiverID = self.receiver_id;
    model.avatarUrl = self.picture?self.picture:self.application_icon;
    model.receiverName = self.name?self.name:self.employee_name;
    model.isHide = @([self.is_hide integerValue]);
    model.application_id = self.application_id;
    model.groupPeoples = self.peoples;
    model.unreadMsgCount = self.unread_nums;
    model.noBother = @([self.no_bother integerValue]);
    model.assistantName = self.name;
    model.isTop = @([self.top_status integerValue]);
    model.showType = self.show_type;
    model.create_time = self.create_time;
    model.latest_push_content = self.latest_push_content;
    model.clientTimes = self.update_time;
    
    model.icon_url = self.icon_url;
    model.icon_color = self.icon_color;
    model.icon_type = self.icon_type;
    
    if ([self.latest_push_time  isEqualToString:@""]) {
        
        model.latest_push_time = self.update_time;
    }
    else {
    
        model.latest_push_time = @([self.latest_push_time integerValue]);
    }
    
    model.type = self.type;
    
    return model;
}

@end
