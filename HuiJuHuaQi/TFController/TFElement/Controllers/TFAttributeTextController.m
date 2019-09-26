
//
//  TFAttributeTextController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttributeTextController.h"
#import "TFAttributeTextCell.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface TFAttributeTextController ()<UITableViewDelegate,UITableViewDataSource,TFAttributeTextCellDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** attributeHeight */
@property (nonatomic, assign) CGFloat attributeHeight;
@property (nonatomic, strong) WKWebView *webView;


@end

@implementation TFAttributeTextController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupTableView];
    
    self.navigationItem.title = self.fieldLabel;
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight)
                                      configuration:config];
    
    [self.view addSubview:self.webView];
    
    //        self.webView.backgroundColor = RedColor;
    
    //记得实现对应协议,不然方法不会实现.
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate =self;
    self.webView.scrollView.scrollEnabled = YES;
    
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"focus"];
    
    
    self.webView.userInteractionEnabled = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorEditURL)]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://page.teamface.cn/#/emailEdit"]]];
    
    
    [self cleanCacheAndCookie];
    
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


#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    //找到对应js端的方法名,获取messge.body
    if ([message.name isEqualToString:@"focus"]) {
        
        HQLog(@"getFocus:%@", message.body);
    }
}


#pragma mark - 监听    =====WKWebView代理相关
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    
    NSString * jsStri = @"";
    CGFloat width = 0;
    width = SCREEN_WIDTH-50;
    
    NSDictionary *dict = @{
                           @"type":@0,
                           @"html":self.content?self.content:@"",
                           @"device":@1,
                           @"width":@((SCREEN_WIDTH > 375 || SCREEN_HEIGHT > 667) ? width*3 : width*2),
                           @"head":@{}
                           };
    
    jsStri  =[NSString stringWithFormat:@"getValHtml(%@)",[HQHelper dictionaryToJson:dict]];
    
    [self.webView evaluateJavaScript:jsStri completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //此处可以打印error.
        
        NSLog(@"result:%@  error:%@",result,error);
    }];
    
}

- (void)sure{
    
    [self getEmailContentFromWebview];
    
}


/** 获取编辑的内容 */
- (void)getEmailContentFromWebview {
    
    NSString * jsStr  =[NSString stringWithFormat:@"sendValMobile()"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        //此处可以打印error.
        HQLog(@"result:%@  error:%@",result,error);
        self.content = result;
        if (self.contentAction) {
            self.contentAction(self.content);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}



#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFAttributeTextCell *cell = [TFAttributeTextCell attributeTextCellWithTableView:tableView type:0 index:indexPath.section * 0x11 + indexPath.row];
    cell.delegate = self;
    [cell reloadDetailContentWithContent:self.content];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.attributeHeight>150?self.attributeHeight:150;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - TFAttributeTextCellDelegate
-(void)attributeTextCell:(TFAttributeTextCell *)attributeTextCell getWebViewContent:(NSString *)content{
    
    self.content = content;
    if (self.contentAction) {
        self.contentAction(self.content);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)attributeTextCell:(TFAttributeTextCell *)attributeTextCell getWebViewHeight:(CGFloat)height{
    
    self.attributeHeight = height;
//    [self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
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
