//
//  HQCommentItemModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/3/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//



#import "JSONModel.h"
#import "HQEmployModel.h"
#import "HQAudioModel.h"
#import "HQBaseVoModel.h"


@protocol HQCommentItemModel @end


/**
 * 评论信息
 */
@interface HQCommentItemModel : HQBaseVoModel


///** 文本 **/
//public static final int COMMENT_TYPE_TEXT = 0;
///** 语音 **/
//public static final int COMMENT_TYPE_RADIO = 1;


/**
 * 评论的内容
 */
@property (nonatomic, strong) NSString <Optional> *contentinfo;


/**
 *  评论发送者id
 */
@property (nonatomic, strong) NSNumber  <Optional>*senderId;
/**
 *  评论发送者name
 */
@property (nonatomic, copy) NSString  <Optional>*senderName;
/**
 *  评论发送者name
 */
@property (nonatomic, copy) NSString  <Optional>*senderPhotograph;


/**
 *  评论接受者id
 */
@property (nonatomic, copy) NSString <Optional> *receiverId;
/**
 *  评论接受者name
 */
@property (nonatomic, copy) NSString <Optional>*receiverName;
/**
 *  评论接受者name
 */
@property (nonatomic, copy) NSString <Optional>*receiverPhotograph;


// 尹明亮添加
/**
 * 评论的ID
 */
@property(nonatomic,strong)NSNumber < Optional>* commentId;





@end
