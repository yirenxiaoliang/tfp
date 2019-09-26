//
//  HQHelpDetailCtrl.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/5/20.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQHelpDetailCtrl.h"
#import <WebKit/WebKit.h>

@interface HQHelpDetailCtrl ()<WKNavigationDelegate>


@property(nonatomic,strong) WKWebView *webView;


@property (nonatomic, weak) UIView *progress;

@end

@implementation HQHelpDetailCtrl

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    if (_titleName) {
        self.navigationItem.title = _titleName;
    }
    
    _webView =[[WKWebView alloc] initWithFrame:self.view.bounds];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:_webView];
        
    [self loadHtmlWithHelpDetailCtrl];
    
    UIView *progress = [[UIView alloc] initWithFrame:(CGRect){0,0,0,4}];
    [self.view addSubview:progress];
    progress.backgroundColor = GreenColor;
    self.progress = progress;
    
}

#pragma mark-加载html
- (void)loadHtmlWithHelpDetailCtrl
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[HQHelper URLWithString:_htmlUrl]]];
    _webView.navigationDelegate = self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress >= 0.88) {
            [UIView animateWithDuration:0.25 animations:^{
                self.progress.width = SCREEN_WIDTH;
            }completion:^(BOOL finished) {
                self.progress.hidden = YES;
            }];
        }else {
            self.progress.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.progress.width = newprogress * SCREEN_WIDTH;
            }];
        }
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
