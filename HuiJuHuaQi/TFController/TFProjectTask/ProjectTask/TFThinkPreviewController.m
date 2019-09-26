//
//  TFThinkPreviewController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/20.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFThinkPreviewController.h"
#import "TFProjectTaskBL.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface TFThinkPreviewController ()<HQBLDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** 项目节点json数据 */
@property (nonatomic, strong) NSDictionary *projectNodeDict;

@end

@implementation TFThinkPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.projectTaskBL requestTemplateWithTempId:self.templateId];// 项目所有节点
    [self setupWebview];
    self.navigationItem.title = @"模板";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.sureAction) {
        [self.navigationController popViewControllerAnimated:NO];
        self.sureAction();
    }
    
}
-(void)setupWebview{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //        config.preferences = [[WKPreferences alloc] init];
    //        config.preferences.minimumFontSize = 10;
    //        config.preferences.javaScriptEnabled = YES;
    //        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    //        config.processPool = [[WKProcessPool alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomM)
                                      configuration:config];
    
    
    [self.view insertSubview:self.webView atIndex:0];
    //记得实现对应协议,不然方法不会实现.
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate =self;
    //    self.webView.scrollView.scrollEnabled = NO;
    //    self.webView.layer.cornerRadius = 4;
    //    self.webView.layer.masksToBounds = YES;
    //    self.webView.scalesPageToFit = YES;
    self.webView.multipleTouchEnabled = YES;
    self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.bounces = YES;
    self.webView.scrollView.bouncesZoom = YES;
    self.webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosPostMessage"];
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(thinkUrl)]]];
}

#pragma mark - 监听    =====WKWebView代理相关
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSString *jsMeta = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=0.2',); document.getElementsByTagName('head')[0].appendChild(meta);"];
    
    [self.webView evaluateJavaScript:jsMeta completionHandler:^(id _Nullable x, NSError * _Nullable error) {
        
    }];
    
    CGFloat width = 0;
    
    width = SCREEN_WIDTH-50;
    
    NSMutableDictionary *domain = [NSMutableDictionary dictionary];
    NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
    if (pic) {
        [domain setObject:pic forKey:@"domain"];
    }
    if (UM.userLoginInfo.token) {
        [domain setObject:UM.userLoginInfo.token forKey:@"token"];
    }
    
    //    NSString *jsToken  =[NSString stringWithFormat:@"getToken(%@)",[HQHelper dictionaryToJson:domain]];
    //    [self.webView evaluateJavaScript:jsToken completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //        //此处可以打印error.
    //
    //        NSLog(@"result:%@  error:%@",result,error);
    //    }];
    //
    if ([self.projectNodeDict valueForKey:@"rootNode"]) {
        [domain setObject:[self.projectNodeDict valueForKey:@"rootNode"] forKey:@"html"];
    }
    NSString * jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:domain]];
    
    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.
        
        NSLog(@"result:%@  error:%@",result,error);
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGSize size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        HQLog(@"CGSize===%@",NSStringFromCGSize(size));
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
        
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectTempAllNode) {// 所有节点
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.projectNodeDict = resp.body;
        NSDictionary *dict = [resp.body valueForKey:@"rootNode"];
        
        NSMutableDictionary *domain = [NSMutableDictionary dictionary];
        NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:UserPictureDomain];
        if (pic) {
            [domain setObject:pic forKey:@"domain"];
        }
        if (UM.userLoginInfo.token) {
            [domain setObject:UM.userLoginInfo.token forKey:@"token"];
        }
        if (dict) {
            [domain setObject:dict forKey:@"html"];
        }
        //        NSString *str = [HQHelper dictionaryToJson:domain];
        NSString *jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:domain]];
        
        [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //此处可以打印error.
            
            NSLog(@"result:%@  error:%@",result,error);
        }];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
