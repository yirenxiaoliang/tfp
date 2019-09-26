//
//  TFTaskDetailDescCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDetailDescCell.h"
#import "HQAdviceTextView.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface TFTaskDetailDescCell ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, assign) CGFloat webViewHeight;
/** content */
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isFinish;

@end

@implementation TFTaskDetailDescCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *headImage = [[UIImageView alloc] initWithImage:IMG(@"descPro")];
        self.headImage = headImage;
        headImage.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.headImage];
        [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(16);
            make.top.equalTo(self.contentView).with.offset(8);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        
        UILabel *lable = [[UILabel alloc] init];
        [self.contentView addSubview:lable];
        lable.textColor = ExtraLightBlackTextColor;
        lable.font = FONT(14);
        self.titleLabel = lable;
        lable.text = @"描述";
        lable.numberOfLines = 0;
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImage.mas_right).with.offset(18);
            make.centerY.equalTo(self.headImage.mas_centerY);
            make.width.equalTo(@100);
        }];
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userController = [WKUserContentController new];
        NSString *js = @" $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=no\">' );";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userController addUserScript:script];
        config.userContentController = userController;
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)
                                          configuration:config];
        
        
        [self.contentView addSubview:self.webView];
        //记得实现对应协议,不然方法不会实现.
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate =self;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.layer.cornerRadius = 4;
        self.webView.layer.masksToBounds = YES;
//        self.webView.layer.borderColor = RedColor.CGColor;
//        self.webView.layer.borderWidth = 0.5;
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosPostMessage"];
        
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        self.webView.userInteractionEnabled = NO;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorDetailURL)]]];
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(115);
            make.top.equalTo(self.contentView).with.offset(0);
            make.bottom.equalTo(self.contentView).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(-30);
            
        }];
        self.bottomLine.hidden = YES;
        
        UILabel *placehoder = [[UILabel alloc] init];
        placehoder.text = @"添加描述";
        self.placehoder = placehoder;
        placehoder.textColor = LightGrayTextColor;
        placehoder.font = FONT(14);
        placehoder.backgroundColor = ClearColor;
        [self.contentView addSubview:placehoder];
        placehoder.textAlignment = NSTextAlignmentLeft;
        placehoder.hidden = YES;
        [self.placehoder mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(127);
            make.top.equalTo(self.contentView).with.offset(10);
            make.height.equalTo(@20);
            make.right.equalTo(self.contentView).with.offset(-40);
            
        }];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:IMG(@"下一级浅灰")];
        arrow.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(self.contentView).with.offset(8);
            make.width.height.equalTo(@20);
        }];
        
        [self cleanCacheAndCookie];
    }
    return self;
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

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGSize size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        HQLog(@"CGSize===%@",NSStringFromCGSize(size));
     
            if (self.webViewHeight != size.height) {
                self.webViewHeight = size.height;
                
                if ([self.delegate respondsToSelector:@selector(taskDetailDescCellHeightChange:)]) {
                    CGFloat height = self.webViewHeight < 44 ? 44 :  self.webViewHeight;
                    [self.delegate taskDetailDescCellHeightChange:height];
                }
            }
        
    }
    
}

#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    HQLog(@"======我来了=============%@",message.body);
    HQLog(@"我的名字====%@",message.name);
    //找到对应js端的方法名,获取messge.body
    if ([message.name isEqualToString:@"iosPostMessage"]) {
        
        HQMainQueue(^{
            
            if ([self.delegate respondsToSelector:@selector(taskDetailDescCel:didClickedImage:)]) {
                [self.delegate taskDetailDescCel:self didClickedImage:[HQHelper URLWithString:message.body]];
            }
        });
    }
}

/** 重新加载详情内容 */
-(void)reloadDetailContentWithContent:(NSString *)content{
    
    if (IsStrEmpty(content)) {
        self.webView.hidden = YES;
        self.placehoder.hidden = NO;
        return;
    }else{
        self.webView.hidden = NO;
        self.placehoder.hidden = YES;
    }
    
    if (![self.content isEqualToString:content]) {
        self.isFinish = NO;
        self.content = content;
    }
    
    if (!self.isFinish) {
        
        CGFloat width = 0;
        
        width = SCREEN_WIDTH-50;
        
        if (self.content != nil && ![self.content isEqualToString:@""]) {
            
            NSDictionary *dict = @{
                                   @"type":@1,
                                   @"html":self.content?self.content:@"",
                                   @"device":@1,
                                   @"width":@((SCREEN_WIDTH > 375 || SCREEN_HEIGHT > 667) ? width*3 : width*2),
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
    width = SCREEN_WIDTH-50;
    
    if (self.content != nil && ![self.content isEqualToString:@""]) {
        NSDictionary *dict = @{
                               @"type":@1,
                               @"html":self.content?self.content:@"",
                               @"device":@1,
                               @"width":@((SCREEN_WIDTH > 375 || SCREEN_HEIGHT > 667) ? width*3 : width*2),
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



//+(instancetype)taskDetailDescCell{
//    return [[[NSBundle mainBundle] loadNibNamed:@"TFTaskDetailDescCell" owner:self options:nil] lastObject];
//}

+(instancetype)taskDetailDescCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFTaskDetailDescCell";
    TFTaskDetailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFTaskDetailDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
