//
//  TFChartDetailController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChartDetailController.h"
#import "TFFilterView.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "TFCustomBL.h"
#import "TFStatisticsListModel.h"
#import "TFChartListController.h"
#import "HQTFNoContentView.h"
#import "TFStatisticsListController.h"

@interface TFChartDetailController ()<TFFilterViewDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler,HQBLDelegate>

@property(nonatomic,strong) WKWebView *webView;

@property (nonatomic, strong) JSContext *jsContext;
/** filterVeiw */
@property (nonatomic, strong) TFFilterView *filterVeiw ;

/** filterButton */
@property (nonatomic, weak) UIButton *filterButton;

/** htmlUrl */
@property (nonatomic, copy) NSString *htmlUrl;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** data */
@property (nonatomic, strong) NSString *data;

/** dict */
@property (nonatomic, strong) NSMutableDictionary *dict;

/** layout */
@property (nonatomic, strong) NSMutableDictionary *layoutDict;

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** titleLabel */
@property (nonatomic, weak) UILabel *titleLabel;
/** enterView */
@property (nonatomic, weak) UIView *enterView;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;


@end

@implementation TFChartDetailController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.view.height-Long(150))/2 - 40,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)lists{
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (void)applicationDidBecomeActive{
    
    if (self.type == 1) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestChartList];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    
    if (self.type == 1 && self.lists.count == 0) {
        if ([UM.userLoginInfo.isLogin isEqualToString:@"1"]) {
            [self.customBL requestChartList];
        }
    }
    if (self.type == 1) {
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
        self.navigationItem.title = @"";
        self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:@"仪表盘" color:BlackTextColor imageName:nil withTarget:nil action:nil];
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) image:@"数据分析-报表" highlightImage:@"数据分析-报表"];
    }
    
}

- (void)rightClicked{
    
//    self.webView.transform = CGAffineTransformMakeRotation(M_PI_2);
//    self.webView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-BottomHeight);
    TFStatisticsListController *controller1 = [[TFStatisticsListController alloc] init];
    
    [self.navigationController pushViewController:controller1 animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // app 活跃通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:ChangeCompanySocketConnect object:nil];
    
    self.view.backgroundColor = WhiteColor;
    
    self.enablePanGesture = NO;
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    
    if (self.type == 0) {// 表
        
        [self setupFilterBtn];
        [self setupFilterView];
        [self.customBL requestGetFilterFields];// 筛选
//        [self.customBL requestGetFilterFieldsWithReportId:self.model.id];
        
        if (self.model.id) {
            
            [self.dict setObject:self.model.id forKey:@"reportId"];
        }
        self.navigationItem.title = self.model.report_label?:self.model.name;
        [self.customBL requestGetReportLayoutDetailWithReportId:self.model.id];
        _htmlUrl = H5URL(customTable);
        
        // 详情
        [self.customBL requestGetReportDetailWithReportDict:self.dict];
    }else{// 图
        
        _htmlUrl = H5URL(customChart);

    }
    
    
    [self cleanCacheAndCookie];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    config.processPool = [[WKProcessPool alloc] init];
    if (self.type == 0) {
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44)
                                          configuration:config];
    }else{
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44-BottomHeight)
                                          configuration:config];
    }

    //记得实现对应协议,不然方法不会实现.
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate =self;
    self.webView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:self.webView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)setupEnterView{
    
    [self.enterView removeFromSuperview];
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    view.backgroundColor = WhiteColor;
    self.enterView = view;
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-60,44}];
    [view addSubview:label];
    label.font = BFONT(14);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){SCREEN_WIDTH-44,0,44,44}];
    [view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"下一级浅灰"];
    [self.view addSubview:view];
    imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel = label;
    
//    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,43,SCREEN_WIDTH,1}];
//    [view addSubview:line];
//    line.backgroundColor = BackGroudColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterViewClicked)];
    [view addGestureRecognizer:tap];
}


- (void)enterViewClicked{
    TFChartListController *list = [[TFChartListController alloc] init];
    list.lists = self.lists;
    list.model = self.model;
    list.refresh = ^(TFStatisticsItemModel *parameter) {
        self.model = parameter;
        self.titleLabel.text = self.model.report_label?:self.model.name;
        // 详情
        if (![self.model.id isEqualToNumber:@0]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestGetChartDetailWithChartId:self.model.id];
        }
    };
    [self.navigationController pushViewController:list animated:YES];
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    if (resp.cmdId == HQCMD_getChartList) {
        
        TFStatisticsListModel *model = resp.body;
        
        [self.lists removeAllObjects];
        
        [self.lists addObjectsFromArray:model.data];
#pragma mark - 删除项目统计分析
        for (TFStatisticsItemModel *item in self.lists) {
            if ([item.id isEqualToNumber:@0]) {
                [self.lists removeObject:item];// 删除项目统计分析
                break;
            }
        }
        
        
        if (self.lists.count) {
            
            [self.noContentView removeFromSuperview];
            [self.view insertSubview:self.webView atIndex:0];
            
            self.model = self.lists[0];
            [self setupEnterView];
            self.titleLabel.text = self.model.report_label?:self.model.name;
            // 详情
            
            if (![self.model.id isEqualToNumber:@0]) {
                [self.customBL requestGetChartDetailWithChartId:self.model.id];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }else{
            
            [self.enterView removeFromSuperview];
            [self.webView removeFromSuperview];
            [self cleanCacheAndCookie];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view addSubview:self.noContentView];
        }
    }
    
    if (resp.cmdId == HQCMD_getReportFilterFields) {
        
        self.filterVeiw.filters = resp.body;
        
    }
    
    if (resp.cmdId == HQCMD_getReportFilterFieldsWithReportId) {
        
        self.filterVeiw.filters = resp.body;
        
    }

    if (resp.cmdId == HQCMD_getReportDetail) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.data = resp.body;
        
        if (self.layoutDict) {
            
            [self loadHtmlWithHelpDetailCtrl];
        }
    }
    
    if (resp.cmdId == HQCMD_getChartDetail) {
        
        
        self.titleLabel.text = self.model.report_label?:self.model.name;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.data = resp.body;
        
        [self loadHtmlWithHelpDetailCtrl];
        
    }
    
    if (resp.cmdId == HQCMD_getReportLayoutDetail) {
        
        NSDictionary *dict = resp.body;
        
        NSMutableDictionary *layout = [NSMutableDictionary dictionary];
        NSDictionary *dashBoardData = [dict valueForKey:@"dashBoardData"];

        if (dashBoardData) {

            if ([dashBoardData valueForKey:@"chartList"]) {

                [layout setObject:[dashBoardData valueForKey:@"chartList"] forKey:@"chartList"];
            }else{
                [layout setObject:@[] forKey:@"chartList"];
            }
        }else{
            [layout setObject:@[] forKey:@"chartList"];
        }

        if ([dict valueForKey:@"reportType"]) {

            [layout setObject:[dict valueForKey:@"reportType"] forKey:@"reportType"];
        }

        self.layoutDict = layout;
        
        
//        self.layoutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        if (self.data) {
            
            [self loadHtmlWithHelpDetailCtrl];
        }
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


#pragma mark-加载html
- (void)loadHtmlWithHelpDetailCtrl
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_htmlUrl]]];
}

//- (void)click{
//    // 执行js方法
//    [self.webView stringByEvaluatingJavaScriptFromString:@"secondClick()"];
//    
//    // 执行js方法并传参
//    JSValue *jsValue = [self.jsContext evaluateScript:@"getTablesVal()"];
//    [jsValue callWithArguments:@[@""]];
//    
//}


#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    //找到对应js端的方法名,获取messge.body
    if ([message.name isEqualToString:@"alert"]) {
        
        NSLog(@"alert:%@", message.body);
    }
}
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);


//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//       
//    }]];
//    [self presentViewController:alert animated:YES completion:NULL];
    completionHandler();
    
    NSLog(@"message:%@", message);
}

#pragma mark - 监听    =====WKWebView代理相关关

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    if (self.type == 0) {
        
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getTablesVal(%@,%@)",self.data,[HQHelper dictionaryToJson:self.layoutDict]] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //此处可以打印error.
            
            HQLog(@"getTablesVal == result:%@  error:%@",result,error);
        }];
    }else{
        
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getChartsVal(%@)",self.data] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            //此处可以打印error.
            
            HQLog(@"getChartsVal == result:%@  error:%@",result,error);
        }];
    }
}


//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
//    return YES;
//}
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//    
//    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    self.jsContext = jsContext;
//    
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        NSLog(@"异常信息：%@", exceptionValue);
//    };
//    
//    // 执行js方法并传参
//    self.model.report_type = @2;
//    
////    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getTablesVal(%@,%@)",self.data,self.model.report_label]];
//    
//    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getTablesVal(%@,%@)",self.data,self.model.report_label] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        //此处可以打印error.
//        
//        NSLog(@"result:%@  error:%@",result,error);
//    }];
//    
////    JSValue *jsValue = [self.jsContext evaluateScript:[NSString stringWithFormat:@"getTablesVal(%@,%@)",self.data,self.model.report_label]];
//    
////    if (self.data && self.model.report_type) {
////        [jsValue callWithArguments:@[self.data,self.model.report_type]];
////    }
//}

#pragma mark - 初始化filterView
- (void)setupFilterView{
    
    TFFilterView *filterVeiw = [[TFFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    filterVeiw.tag = 0x1234554321;
    self.filterVeiw = filterVeiw;
    filterVeiw.delegate = self;
}

#pragma mark - TFFilterViewDelegate
-(void)filterViewDidClicked:(BOOL)show{
   
    [self filterClicked:self.filterButton];
}

-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict{
    
    [self filterClicked:self.filterButton];
    
    // 此处传递参数
    NSMutableDictionary *di = [NSMutableDictionary dictionaryWithDictionary:dict];
    [di setObject:self.model.id forKey:@"reportId"];
    self.dict = di;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL requestGetReportDetailWithReportDict:self.dict];
    
}

#pragma mark - 初始化筛选按钮
- (void)setupFilterBtn{
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH-100, 0, 100, 44);
    [button setTitle:@"筛选" forState:UIControlStateNormal];
    [button setTitle:@"筛选" forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"状态"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"状态"] forState:UIControlStateHighlighted];
    [button setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [button setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    button.titleLabel.font = FONT(14);
    [button addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.filterButton = button;
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.size.width, 0, button.imageView.size.width)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
    
}

- (void)filterClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    
    [self crmSearchViewDidFilterBtn:button.selected];
}


-(void)crmSearchViewDidFilterBtn:(BOOL)show{
    
    if (show) {
        
        [KeyWindow addSubview:self.filterVeiw];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, .5);
            self.filterVeiw.left = 0;
        }];
        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            
            self.filterVeiw.left = SCREEN_WIDTH;
            self.filterVeiw.backgroundColor = RGBAColor(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            
            [self.filterVeiw removeFromSuperview];
        }];
        
    }
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
