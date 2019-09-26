//
//  TFTestH5Controller.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/10.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTestH5Controller.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface TFTestH5Controller ()<UIWebViewDelegate>


@property(nonatomic,strong) UIWebView *webView;

@property (nonatomic, strong) JSContext *jsContext;


@end

@implementation TFTestH5Controller

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    _webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    
    [self loadHtmlWithHelpDetailCtrl];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(click) text:@"点击"];
}

- (void)click{
    //     也可以通过下标的方式获取到方法
    if (self.type == 0) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"secondClick()"];
    }else{
        
        JSValue *jsValue = [self.jsContext evaluateScript:@"secondClick1"];
        
        [jsValue callWithArguments:@[self.obj]];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext = jsContext;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    
    
    //    [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
    
    //    JSValue *jsValue = [self.jsContext evaluateScript:@"dateArray"];
    
    
    //     也可以通过下标的方式获取到方法
    
    kWEAKSELF
    self.jsContext[@"passValue"] = ^(NSString *obj){
        
        NSArray *arg = [JSContext currentArguments];
        for (id obj in arg) {
            NSLog(@"%@", obj);
        }
        if (weakSelf.action) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            weakSelf.action(obj);
        }
    };
    
    self.jsContext[@"passValue1"] = ^(NSString *obj){
        
        NSArray *arg = [JSContext currentArguments];
        for (id obj in arg) {
            NSLog(@"%@", obj);
        }
    };
}

#pragma mark-加载html
- (void)loadHtmlWithHelpDetailCtrl
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[HQHelper URLWithString:_htmlUrl]]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
