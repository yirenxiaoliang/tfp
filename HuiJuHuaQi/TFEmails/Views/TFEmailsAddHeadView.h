//
//  TFEmailsAddHeadView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFEmailNameView.h"

@protocol TFEmailsAddHeadViewDelegate <NSObject>

@optional
- (void)headViewHeight:(float)height;

- (void)headViewContents:(NSMutableArray *)contents type:(NSInteger)type;

- (void)selectSenderClicked;

- (void)addEmailContactsClicked:(NSInteger)type;

@end

@interface TFEmailsAddHeadView : UIView

- (void)fromSelectContacts:(NSString *)text type:(NSInteger)type name:(NSString *)name;

/** 1:接收  2:抄送  3:密送 */
//@property (nonatomic, assign) NSInteger type;

/** 发送人 */
@property (nonatomic, strong) UIView *sendView;

@property (nonatomic, strong) UILabel *sendLab;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *requireLab;

@property (nonatomic, strong) UIImageView *nextImgV;

/** 接收人 */
@property (nonatomic, strong) UIView *receiveView;

@property (nonatomic, strong) UILabel *receiveLab;

@property (nonatomic, strong) UILabel *titleLab2;

@property (nonatomic, strong) UIButton *addReceiveBtn;

@property (nonatomic, strong) TFEmailNameView *oneEditView;



/** 抄送人 */
@property (nonatomic, strong) UIView *copyerView;

@property (nonatomic, strong) UILabel *titleLab3;

@property (nonatomic, strong) UIButton *addCopyerBtn;

@property (nonatomic, strong) TFEmailNameView *twoEditView;



/** 密送人 */
@property (nonatomic, strong) UIView *secreterView;

@property (nonatomic, strong) UILabel *titleLab4;

@property (nonatomic, strong) UIButton *addSecreterBtn;

@property (nonatomic, strong) TFEmailNameView *threeEditView;


@property (nonatomic, strong) UILabel *line1;

@property (nonatomic, strong) UILabel *line2;

@property (nonatomic, strong) UILabel *line3;

@property (nonatomic, strong) UILabel *line4;

@property (nonatomic, weak) id <TFEmailsAddHeadViewDelegate>delegate;

@end
