//
//  TFStatisticsCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsCell.h"
#import "TFStatisticsModel.h"

#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface TFStatisticsCell ()<UIWebViewDelegate>

@property (nonatomic, strong) JSContext *jsContext;

/** webView */
@property (nonatomic, weak) UIWebView *webView;

/** type */
@property (nonatomic, assign) NSInteger type;

/** models */
@property (nonatomic, strong) NSMutableArray *models;


@end

@implementation TFStatisticsCell

-(NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupWebView];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWebView];
    }
    return self;
}

#pragma mark - 初始化tableView
- (void)setupWebView
{
    self.type = 0;
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    
    [self.contentView addSubview:webView];
    self.webView = webView;
    webView.backgroundColor = ClearColor;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.contentInset = UIEdgeInsetsZero;
    webView.scrollView.backgroundColor = ClearColor;
    self.layer.masksToBounds = YES;
    webView.userInteractionEnabled = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
        HQLog(@"异常信息：%@", exceptionValue);
    };
    
    
    //[webView stringByEvaluatingJavaScriptFromString:_noteContent];
    
    //JSValue *jsValue = [self.jsContext evaluateScript:@"dateArray"];
    
    
    switch (self.type) {
        case 0:// 饼状图
        {
            
            TFStatisticsModel *model = [[TFStatisticsModel alloc] init];
            model.title = @"人民币来源图";
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0; i < 5; i ++) {
                
                TFValueModel *value = [[TFValueModel alloc] init];
                value.name = [NSString stringWithFormat:@"人民币来源%ld",i];
                value.value = @((i + 1) * 10);
                [arr addObject:[value toDictionary]];
            }
            model.series = arr;
            
            JSValue *jsValue = [self.jsContext evaluateScript:@"pieFunction"];
            
            [jsValue callWithArguments:@[[model toDictionary]]];
        }

            break;
        case 1:{// 条形图
            
            TFStatisticsModel *model = [[TFStatisticsModel alloc] init];
            model.title = @"货币量";
            model.yAxis = @[@"美国",@"英国",@"巴西",@"中国",@"全世界"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0; i < 3; i ++) {
                
                TFValueModel *value = [[TFValueModel alloc] init];
                value.name = [NSString stringWithFormat:@"%ld年",i+2013];
                
                NSMutableArray *data = [NSMutableArray array];
                for (NSInteger k = 0; k < model.yAxis.count; k ++) {
                    
                    [data addObject:@((k + 1) * 2340)];
                }
                
                value.data = data;
                [arr addObject:[value toDictionary]];
            }
            model.series = arr;
            
            JSValue *jsValue = [self.jsContext evaluateScript:@"horBarFunction"];
            
            [jsValue callWithArguments:@[[model toDictionary]]];
        }
            break;
        case 2:{// 柱状图
            TFStatisticsModel *model = [[TFStatisticsModel alloc] init];
            model.title = @"货币量";
            model.xAxis = @[@"美国",@"英国",@"巴西",@"中国",@"全世界"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0; i < 3; i ++) {
                
                TFValueModel *value = [[TFValueModel alloc] init];
                value.name = [NSString stringWithFormat:@"%ld年",i+2013];
                
                NSMutableArray *data = [NSMutableArray array];
                for (NSInteger k = 0; k < model.xAxis.count; k ++) {
                    
                    [data addObject:@((k + 1) * 2340)];
                }
                
                value.data = data;
                [arr addObject:[value toDictionary]];
            }
            model.series = arr;
            
            JSValue *jsValue = [self.jsContext evaluateScript:@"verBarFunction"];
            
            [jsValue callWithArguments:@[[model toDictionary]]];
        }
            break;
        case 3:{// 曲线图
            TFStatisticsModel *model = [[TFStatisticsModel alloc] init];
            model.title = @"货币量";
            model.xAxis = @[@"美国",@"英国",@"巴西",@"中国",@"全世界"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0; i < 3; i ++) {
                
                TFValueModel *value = [[TFValueModel alloc] init];
                value.name = [NSString stringWithFormat:@"%ld年",i+2013];
                
                NSMutableArray *data = [NSMutableArray array];
                for (NSInteger k = 0; k < model.xAxis.count; k ++) {
                    
                    [data addObject:@((k + 1) * arc4random_uniform(423))];
                }
                value.smooth = true;
                value.data = data;
                [arr addObject:[value toDictionary]];
            }
            model.series = arr;
            
            JSValue *jsValue = [self.jsContext evaluateScript:@"lineFunction"];
            
            [jsValue callWithArguments:@[[model toDictionary]]];
        }
            break;
        case 4:{// 折线图
            TFStatisticsModel *model = [[TFStatisticsModel alloc] init];
            model.title = @"货币量";
            model.xAxis = @[@"美国",@"英国",@"巴西",@"中国",@"全世界"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0; i < 3; i ++) {
                
                TFValueModel *value = [[TFValueModel alloc] init];
                value.name = [NSString stringWithFormat:@"%ld年",i+2013];
                
                NSMutableArray *data = [NSMutableArray array];
                for (NSInteger k = 0; k < model.xAxis.count; k ++) {
                    
                    [data addObject:@((k + 1) * arc4random_uniform(423))];
                }
                value.smooth = false;
                value.data = data;
                [arr addObject:[value toDictionary]];
            }
            model.series = arr;
            
            JSValue *jsValue = [self.jsContext evaluateScript:@"lineFunction"];
            
            [jsValue callWithArguments:@[[model toDictionary]]];

        }
            break;
        case 5:{// 漏斗图
            
            TFStatisticsModel *model = [[TFStatisticsModel alloc] init];
            model.title = @"销售漏斗";
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0; i < 5; i ++) {
                
                TFValueModel *value = [[TFValueModel alloc] init];
                value.name = [NSString stringWithFormat:@"%ld年",i+2013];
                value.value = @((i+1) * 20);
                [arr addObject:[value toDictionary]];
            }
            model.series = arr;
            
            JSValue *jsValue = [self.jsContext evaluateScript:@"funnelFunction"];
            
            [jsValue callWithArguments:@[[model toDictionary]]];

        }
            break;
            
        case 6:{// 仪表图
        
            TFStatisticsModel *model = [[TFStatisticsModel alloc] init];
            model.title = @"任务困难度";
            NSMutableArray *arr = [NSMutableArray array];
            TFValueModel *value = [[TFValueModel alloc] init];
            value.name = @"困难度";
            value.value = @(70);
            [arr addObject:[value toDictionary]];
            
            model.series = arr;
            
            JSValue *jsValue = [self.jsContext evaluateScript:@"gaugeFunction"];
            
            [jsValue callWithArguments:@[[model toDictionary]]];
        }
            break;
            
        default:
            break;
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


-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.webView.frame = CGRectMake(0, 0, self.width, self.height);
}




+ (TFStatisticsCell *)statisticsCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFStatisticsCell";
    TFStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.topLine.hidden = YES;
    //    cell.bottomLine.hidden = YES;
    return cell;
}

- (void)refreshStatisticsCellWithType:(NSInteger)type{
    
    self.type = type;
    
    [self cleanCacheAndCookie];
    
    NSString *htmlUrl = [[NSBundle mainBundle] pathForResource:@"pieStatistics" ofType:@"html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[HQHelper URLWithString:htmlUrl]]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
