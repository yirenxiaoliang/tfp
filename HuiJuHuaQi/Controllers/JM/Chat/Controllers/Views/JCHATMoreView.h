//
//  JPIMMore.h
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddBtnDelegate <NSObject>
@optional
- (void)photoClick;
- (void)cameraClick;
- (void)locationClick;
- (void)telephoneClick;
@end

typedef enum {
    MoreViewTypeSingleChat, // 单聊
    MoreViewTypeGroupChat,  // 群聊
    MoreViewTypeCommentChat // 评论
}MoreViewType;

@interface JCHATMoreView : UIView
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (assign, nonatomic)  id<AddBtnDelegate>delegate;
/** type */
@property (nonatomic, assign) MoreViewType type;


@end

@interface JCHATMoreViewContainer : UIView
@property (strong, nonatomic) JCHATMoreView *moreView;

@end
