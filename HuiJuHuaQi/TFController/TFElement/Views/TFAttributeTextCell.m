//
//  TFAttributeTextCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttributeTextCell.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface TFAttributeTextCell ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, assign) CGFloat webViewHeight;

@property (nonatomic, assign) NSInteger type;

/** UILabel *nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, assign) BOOL isFinish;

/** requireLabel */
@property (nonatomic, weak) UILabel *requireLabel;
/** content */
@property (nonatomic, copy) NSString *content;

@end


@implementation TFAttributeTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.type = type;
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.userContentController = [[WKUserContentController alloc] init];
        config.processPool = [[WKProcessPool alloc] init];
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)
                                          configuration:config];
        
        [self.contentView addSubview:self.webView];
        
//        self.webView.backgroundColor = RedColor;
        
        //记得实现对应协议,不然方法不会实现.
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate =self;
        self.webView.scrollView.scrollEnabled = NO;
        
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"focus"];
        
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,44}];
        nameLabel.textColor = ExtraLightBlackTextColor;
        nameLabel.font = FONT(14);
        nameLabel.backgroundColor = ClearColor;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        if (type == 1) {
            self.webView.userInteractionEnabled = NO;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorDetailURL)]]];
            self.nameLabel.hidden = NO;
        }
        else {
            self.webView.userInteractionEnabled = YES;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorEditURL)]]];
            self.nameLabel.hidden = YES;
        }
        
        UILabel *requi = [[UILabel alloc] initWithFrame:(CGRect){6,0,15,44}];
        requi.text = @"*";
        self.requireLabel = requi;
        requi.textColor = RedColor;
        requi.font = FONT(14);
        requi.backgroundColor = ClearColor;
        [self.contentView addSubview:requi];
        requi.textAlignment = NSTextAlignmentLeft;
        requi.hidden = YES;
        [self cleanCacheAndCookie];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.nameLabel.text = title;
}

-(void)setStructure:(NSString *)structure{
    
    _structure = structure;
    
    if ([structure isEqualToString:@"0"]) {// 上下
        
        self.webView.frame = CGRectMake(8, 30, SCREEN_WIDTH-8, self.webViewHeight);
        
    }else{// 左右
        
        self.webView.frame = CGRectMake(100, 1, SCREEN_WIDTH-8-100, self.webViewHeight);
    }
    
}

-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
        
    }
    
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            CGFloat height = [result doubleValue] + 20;
            
            if (self.webViewHeight + 20 == height) {
                return ;
            }
            
            if (self.webViewHeight != height) {
                
                self.isLoaded = NO;
            }
            
            if (self.type == 0) {
                self.webViewHeight = height;
                self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.webViewHeight);
            }else{
                
                if ([_structure isEqualToString:@"0"]) {// 上下
                    
                    self.webViewHeight = height+44;
                    self.webView.frame = CGRectMake(8, 30, SCREEN_WIDTH-8, self.webViewHeight-44);
                    
                }else{// 左右
                    
                    self.webViewHeight = height;
                    self.webView.frame = CGRectMake(100, 1, SCREEN_WIDTH-8-100, self.webViewHeight);
                }
                
            }
            
            if (!self.isLoaded) {
                
                self.isLoaded = YES;
                
                if ([self.delegate respondsToSelector:@selector(attributeTextCell:getWebViewHeight:)]) {
                    
                    [self.delegate attributeTextCell:self getWebViewHeight:self.webViewHeight];
                }
            }
        }];
        
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
    //找到对应js端的方法名,获取messge.body
    if ([message.name isEqualToString:@"focus"]) {
        
        HQLog(@"getFocus:%@", message.body);
    }
}

/** 重新加载详情内容 */
//-(void)reloadDetailContentWithFinish:(BOOL)finish{
-(void)reloadDetailContentWithContent:(NSString *)content{
    
//    if (finish) {
//        if (self.isFinish) {
//            self.isFinish = NO;
//            self.isLoaded = NO;
//        }
//    }
    
    if (![self.content isEqualToString:content]) {
        self.isFinish = NO;
        self.content = content;
    }
    
    if (!self.isFinish) {
        
        CGFloat width = 0;
        
        if ([_structure isEqualToString:@"0"]) {// 上下
            
            width = SCREEN_WIDTH;
            
        }else{// 左右
            
            width = SCREEN_WIDTH-100;
        }
        
        if (self.content != nil && ![self.content isEqualToString:@""]) {
            
            NSDictionary *dict = @{
                                   @"type":@1,
                                   @"html":self.content?self.content:@"",
                                   @"device":@1,
                                   @"width":@(width),
                                   @"head":@{}
                                   };
            
            NSString *jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:dict]];
            [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //此处可以打印error.
                
                NSLog(@"result:%@  error:%@",result,error);
                self.isFinish = YES;
                
            }];
        }
        
    }
}

#pragma mark - 监听    =====WKWebView代理相关
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    
    NSString * jsStri = @"";
    
    CGFloat width = 0;
    
    if ([_structure isEqualToString:@"0"]) {// 上下
        
        width = SCREEN_WIDTH;
        
    }else{// 左右
        
        width = SCREEN_WIDTH-100;
    }
    
    //可编辑
    if (self.type == 0) {
        
        NSDictionary *dict = @{
                               @"type":@0,
                               @"html":self.content?self.content:@"",
                               @"device":@1,
                               @"width":@(width),
                               @"head":@{}
                               };
        
        jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:dict]];
        
        [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //此处可以打印error.
            
            NSLog(@"result:%@  error:%@",result,error);
            self.isFinish = YES;
        }];
            
        
    }
    else { //不可编辑（详情）
        if (self.content != nil && ![self.content isEqualToString:@""]) {
            NSDictionary *dict = @{
                                   @"type":@1,
                                   @"html":self.content?self.content:@"",
                                   @"device":@1,
                                   @"width":@(width),
                                   @"head":@{}
                                   };
            
            jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:dict]];
            [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                //此处可以打印error.
                
                NSLog(@"result:%@  error:%@",result,error);
                self.isFinish = YES;
            }];
        }
        
    }
    
    
}


/** 获取编辑的内容 */
- (void)getEmailContentFromWebview {
    
    NSString * jsStr  =[NSString stringWithFormat:@"sendValMobile()"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        //此处可以打印error.
        HQLog(@"result:%@  error:%@",result,error);
        
        if ([self.delegate respondsToSelector:@selector(attributeTextCell:getWebViewContent:)]) {

            [self.delegate attributeTextCell:self getWebViewContent:result];
        }
        
    }];
    
}


+ (instancetype)attributeTextCellWithTableView:(UITableView *)tableView type:(NSInteger)type index:(NSInteger)index{
    
    NSString *indentifier = [NSString stringWithFormat:@"TFAttributeTextCell%ld",index];
    TFAttributeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFAttributeTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier type:type];
    }
    [cell cleanCacheAndCookie];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
