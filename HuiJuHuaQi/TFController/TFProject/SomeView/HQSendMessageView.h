//
//  HQSendMessageView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/7.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQAdviceTextView.h"

typedef enum HQSendMessageView {
    SendMessageViewDefault,// 默认类型，发送一条消息自动移除
    SendMessageViewShow// 一直存在
}SendMessageViewType;

@protocol HQSendMessageViewDelegate <NSObject>


@optional

- (void)sendMessageWithText:(NSString *)messageText
               messageVoice:(id)messageVoice
            taskOperationID:(NSNumber *)taskOperationID;


/**弹出无声音的输入框**/
-(void)sendNoVoidWithText:(NSString *)messageText
                 taskType:(NSInteger )taskType
                 employID:(NSNumber *)employId;

@end


@interface HQSendMessageView : UIView


@property (nonatomic, strong) UIView *toolBarView;


//操作的ID,如果评论类型 为操作的评论，这个必须有
@property (nonatomic, strong) NSNumber *taskOperationID;

@property(nonatomic,strong)NSNumber * recivicePeopleName;

@property (nonatomic, weak) id <HQSendMessageViewDelegate> delegate;

@property (nonatomic , assign) SendMessageViewType type;

@property (nonatomic, strong) HQAdviceTextView *contentTextView;   //文本

@property (nonatomic,assign) NSInteger senderType;

-(void)initSendMessageView:(BOOL)operationTextType;

@end
