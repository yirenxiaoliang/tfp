//
//  TFEmailsDetailWebViewCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsDetailWebViewCell.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import "TFEmailWebViewModel.h"
#define WebMargin 0

@interface TFEmailsDetailWebViewCell ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>


@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, copy) NSString *heightStr;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL isReplay;

@property (nonatomic, copy) NSString *replayStr;

@property (nonatomic, strong) TFEmailReceiveListModel *model;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat webViewHeight;

@property (nonatomic, assign) NSInteger from;

@end

@implementation TFEmailsDetailWebViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier from:(NSInteger)from {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.isLoaded = NO;
        self.from=from;
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        config.preferences = [[WKPreferences alloc] init];
//        config.preferences.minimumFontSize = 10;
//        config.preferences.javaScriptEnabled = YES;
//        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.userContentController = [[WKUserContentController alloc] init];
//        config.processPool = [[WKProcessPool alloc] init];
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(WebMargin, WebMargin, SCREEN_WIDTH-2*WebMargin, 150)
                                          configuration:config];
        
        //记得实现对应协议,不然方法不会实现.
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate =self;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.userInteractionEnabled = NO;
        
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosPostMessage"];
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"linkPostMessage"];
        
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:self.webView];
//        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
//        [self addSubview:self.scrollView];
//        [self.scrollView addSubview:self.webView];
//        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.scrollView);
//        }];
//        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView);
//        }];
        
//        if (from == 1) {
        HQLog(@"邮件详情界面H5地址：%@",H5URL(editorDetailURL));
        
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorDetailURL)]]];
//        }
//        else {
//
//            HQLog(@"%@",H5URL(editorEditURL));
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorEditURL)]]];
//        }
        if (from == 1) {
            self.webView.userInteractionEnabled = YES;
        }else{
            self.webView.userInteractionEnabled = NO;
        }

    }
    return self;
}

-(void)setFrom:(NSInteger)from{
    _from = from;
//    if (from == 1) {
    
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorDetailURL)]]];
//    }
//    else {
//
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorEditURL)]]];
//    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGSize size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        HQLog(@"CGSize===%@",NSStringFromCGSize(size));
        
        if (self.webViewHeight != (size.height + 2*WebMargin)) {

            self.webViewHeight = size.height + 2*WebMargin;
            self.webView.frame = CGRectMake(WebMargin, WebMargin, SCREEN_WIDTH-2*WebMargin, size.height);
            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.webViewHeight);
            if ([self.delegate respondsToSelector:@selector(getWebViewHeight:)]) {

                [self.delegate getWebViewHeight:self.webViewHeight<150?150: self.webViewHeight];
            }
        }
        
    }
    
}

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    HQLog(@"======我来了=============%@",message.body);
    HQLog(@"我的名字====%@",message.name);
    //找到对应js端的方法名,获取messge.body
    if ([message.name isEqualToString:@"iosPostMessage"]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
        [KeyWindow addSubview:imageView];
        imageView.tag = 0x2222;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor blackColor];
        [imageView sd_setImageWithURL:[HQHelper URLWithString:message.body] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [KeyWindow addSubview:imageView];
            }else{
                [MBProgressHUD showError:@"未获取到图片" toView:self];
            }
            
        }];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
    }
    
    if ([message.name isEqualToString:@"linkPostMessage"]) {
        
        if ([self.delegate respondsToSelector:@selector(jumpUrl:)]) {
            [self.delegate jumpUrl:message.body];
        }
    }
}

- (void)imageViewClicked:(UITapGestureRecognizer *)tap{
    
    [tap.view removeFromSuperview];
}

/** 新增 */
- (void)addEmailWithWebViewCellWithData:(TFEmailReceiveListModel *)model {

    
}

/** 回复 */
- (void)replayEmailWithWebViewCellWithData:(TFEmailReceiveListModel *)listModel {
    
    self.model = listModel;
    
    self.isReplay = YES;
    TFEmailWebViewModel *webModel = [[TFEmailWebViewModel alloc] init];
    
    webModel.html = self.model.mail_content;
    
    webModel.type = @0;
    webModel.device = @1;
    if (SCREEN_WIDTH > 375 || SCREEN_HEIGHT > 667) {
        webModel.width = @(SCREEN_WIDTH*3);
    }else{
        webModel.width = @(SCREEN_WIDTH*2);
    }
    
    //头
    TFEmailWebViewHeadModel *headModel = [[TFEmailWebViewHeadModel alloc] init];
    
    headModel.ip_address = self.model.ip_address;
    headModel.subject = self.model.subject;
//    headModel.time = [HQHelper nsdateToTime:[self.model.create_time longLongValue] formatStr:@"yyyy-MM"];
    headModel.from_recipient = self.model.from_recipient;
    headModel.from_recipient_name = self.model.from_recipient_name;
    headModel.to_recipients = self.model.to_recipients;
    
    headModel.cc_recipients = self.model.cc_recipients;
    headModel.bcc_recipients = self.model.bcc_recipients;
    
    
    NSString *timeStr = [HQHelper nsdateToTime:[self.model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    
    // NSString * -> NSDate *
    
    NSDate *data = [format dateFromString:timeStr];
    
    headModel.time = [NSString stringWithFormat:@"时   间:%@(%@)",[HQHelper nsdateToTime:[self.model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"],[HQHelper getWeekday2WithDate:data]];
    
    webModel.head = headModel;
    
    
    NSString *sss = [webModel toJSONString];
    
    //传值
    NSString * jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",sss];
    
    self.replayStr = jsStri;
    
    
}


/** 转发 */
- (void)turnSendEmailWithWebView:(TFEmailReceiveListModel *)model {
    
    
}

#pragma mark - 监听    =====WKWebView代理相关

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    TFEmailWebViewModel *webModel = [[TFEmailWebViewModel alloc] init];
    
    NSString * jsStri = @"";
    
    //可编辑
    if ([self.type isEqualToNumber:@0]) {
        
        if ([self.model.type isEqualToNumber:@1]) { //回复、转发
            
            webModel.type = @0;
            
            jsStri = self.replayStr;
            
            [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //此处可以打印error.
                
                NSLog(@"result:%@  error:%@",result,error);
                [self getEmailContentFromWebview];
                
            }];
        }
        else {
        
            webModel.type = @0;
            
            webModel.html = self.mailContent?self.mailContent:@"";
            webModel.device = @1;
            if (SCREEN_WIDTH > 375 || SCREEN_HEIGHT > 667) {
                webModel.width = @(SCREEN_WIDTH*3);
            }else{
                webModel.width = @(SCREEN_WIDTH*2);
            }
            webModel.head = [[TFEmailWebViewHeadModel alloc] init];
            
            NSString *sss = [webModel toJSONString];
            
            jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",sss];
            [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //此处可以打印error.
                NSLog(@"result:%@  error:%@",result,error);
            }];
        }
        
    }
    else { //不可编辑（详情）
        
        webModel.type = @1;
        
        webModel.html = self.mailContent;
        webModel.device = @1;
        if (SCREEN_WIDTH > 375 || SCREEN_HEIGHT > 667) {
            webModel.width = @(SCREEN_WIDTH*3);
        }else{
            webModel.width = @(SCREEN_WIDTH*2);
        }
        webModel.head = [[TFEmailWebViewHeadModel alloc] init];
        
        NSString *sss = [webModel toJSONString];
        
        jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",sss];
        [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //此处可以打印error.
            HQLog(@"result:%@  error:%@",result,error);
            
        }];
    }
    

}

/** 获取编辑的内容 */
- (NSString *)getEmailContentFromWebview {

    __block NSString *string = @"";
    NSString * jsStr  =[NSString stringWithFormat:@"sendValMobile()"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.

        HQLog(@"result:%@  error:%@",result,error);
        
        string = result;
        
        if ([self.delegate respondsToSelector:@selector(giveWebViewContentForAddEmail:)]) {
            
            [self.delegate giveWebViewContentForAddEmail:string];
        }
        
    }];
    
    return string;
}


+ (instancetype)emailsDetailWebViewCellWithTableView:(UITableView *)tableView from:(NSInteger)from{
    
    static NSString *indentifier = @"TFEmailsDetailWebViewCell";
    TFEmailsDetailWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFEmailsDetailWebViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier from:from];
    }
    cell.from = from;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
    
}

@end
