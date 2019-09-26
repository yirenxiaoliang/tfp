//
//  TFEmailsDetailWebViewCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFEmailReceiveListModel.h"
#import <WebKit/WebKit.h>

@protocol TFEmailsDetailWebViewCellDelegate <NSObject>

@optional
- (void)getWebViewHeight:(CGFloat)height;

- (void)turnSendEmailWithWebView:(TFEmailReceiveListModel *)model;

- (void)giveWebViewContentForAddEmail:(NSString *)content;

- (void)showWebViewAlert:(UIAlertController*)alert;

- (void)webViewIsFucus;

- (void)jumpUrl:(NSString *)url;

@end

@interface TFEmailsDetailWebViewCell : HQBaseCell

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *mailContent;

/** 0:可编辑 1:不可编辑 */
@property (nonatomic, strong) NSNumber *type;

/** 0:可编辑 1:不可编辑 */
+ (instancetype)emailsDetailWebViewCellWithTableView:(UITableView *)tableView from:(NSInteger)from;

//- (void)refreshEmailsDetailWebViewCellWithData:(TFEmailReceiveListModel *)model;

/** 获取编辑的内容 */
- (NSString *)getEmailContentFromWebview;

/** 回复 */
- (void)replayEmailWithWebViewCellWithData:(TFEmailReceiveListModel *)listModel;

@property (nonatomic, weak) id <TFEmailsDetailWebViewCellDelegate>delegate;


@end
