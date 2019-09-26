//
//  TFCustomAttributeTextOldCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomAttributeTextOldCell.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>


@interface TFCustomAttributeTextOldCell ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, assign) CGFloat webViewHeight;

@property (nonatomic, assign) NSInteger type;

/** UILabel *nameLabel */
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, assign) BOOL isFinish;

/** requireLabel */
@property (nonatomic, weak) UILabel *requireLabel;
/** content */
@property (nonatomic, copy) NSString *content;
/** 边框View */
@property (nonatomic, weak) UIView *borderView;

@end

@implementation TFCustomAttributeTextOldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.type = type;
        
        UILabel *lable = [[UILabel alloc] init];
        [self.contentView addSubview:lable];
        lable.textColor = BlackTextColor;
        lable.font = BFONT(12);
        self.titleLabel = lable;
        lable.numberOfLines = 0;
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.contentView).with.offset(8);
            make.right.equalTo(self.contentView).with.offset(-15);
            
        }];
        
        
        UILabel *requi = [[UILabel alloc] init];
        requi.text = @"*";
        self.requireLabel = requi;
        requi.textColor = RedColor;
        requi.font = BFONT(14);
        requi.backgroundColor = ClearColor;
        [self.contentView addSubview:requi];
        requi.textAlignment = NSTextAlignmentLeft;
        [requi mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(6);
            make.top.equalTo(self.contentView).with.offset(8);
        }];
        
        [self cleanCacheAndCookie];
        
        
        UIView *borderView = [[UIView alloc] init];
        [self.contentView addSubview:borderView];
        self.borderView = borderView;
        borderView.layer.cornerRadius = 4;
        borderView.layer.borderWidth = 1;
        borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(lable.mas_bottom).with.offset(8);
            make.bottom.equalTo(self.contentView).with.offset(-8);
            make.right.equalTo(self.contentView).with.offset(-15);
            
        }];
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //        config.preferences = [[WKPreferences alloc] init];
        //        config.preferences.minimumFontSize = 10;
        //        config.preferences.javaScriptEnabled = YES;
        //        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        WKUserContentController *userController = [WKUserContentController new];
        NSString *js = @" $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=no\">' );";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userController addUserScript:script];
        config.userContentController = userController;
        //        config.processPool = [[WKProcessPool alloc] init];
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)
                                          configuration:config];
        
        
        [borderView addSubview:self.webView];
        //记得实现对应协议,不然方法不会实现.
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate =self;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.layer.cornerRadius = 4;
        self.webView.layer.masksToBounds = YES;
        
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"iosPostMessage"];
        
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        
        
        if (type == 1) {
            self.webView.userInteractionEnabled = YES;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorDetailURL)]]];
            self.titleLabel.hidden = NO;
        }
        else {
            self.webView.userInteractionEnabled = NO;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5URL(editorDetailURL)]]];
            self.titleLabel.hidden = NO;
        }
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(borderView).with.offset(0);
            make.top.equalTo(borderView).with.offset(0);
            make.bottom.equalTo(borderView).with.offset(0);
            make.right.equalTo(borderView).with.offset(0);
            
        }];
        
    }
    return self;
}

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}


-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
        
    }
    
}


/** 展示详情 */
-(void)setShowEdit:(BOOL)showEdit{
    
    _showEdit = showEdit;
    
    if (showEdit) {// 框
        
        self.borderView.layer.cornerRadius = 4;
        self.borderView.layer.borderWidth = 1;
        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowColor = ClearColor.CGColor;
        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
        self.borderView.layer.shadowRadius = 0;
        self.borderView.layer.shadowOpacity = 0.5;
        self.borderView.backgroundColor = ClearColor;
        
    }else{// 阴影
        
        self.borderView.layer.cornerRadius = 4;
        self.borderView.layer.borderWidth = 0;
        self.borderView.layer.borderColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowColor = HexColor(0xd5d5d5).CGColor;
        self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
        self.borderView.layer.shadowRadius = 4;
        self.borderView.layer.shadowOpacity = 0.5;
        self.borderView.backgroundColor = WhiteColor;
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
        
        //        [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //
        //            CGFloat height = [result doubleValue] + 18;// webView的内容高度 + 上下间距 == borderView的高度
        //
        //            if (self.type == 0) {
        //                height += 16;// 加上borderView的上下间距
        //            }else{
        //
        //                height += 16;// 加上borderView的上下间距
        //                height += 8;// title的上间距
        //                height += [HQHelper sizeWithFont:BFONT(12) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:self.model.label].height;// title的高度
        //            }
        //            if ([self.model.height floatValue] + 18 == height) {
        //                return ;
        //            }
        //
        //            self.webViewHeight = height<150?150:height;
        //
        //            if (self.webViewHeight != [self.model.height floatValue] && [self.model.height floatValue]+18 != height) {
        //
        //                self.model.height = @(self.webViewHeight);
        //
        //                if ([self.delegate respondsToSelector:@selector(customAttributeTextCell:getWebViewHeight:)]) {
        //
        //                    [self.delegate customAttributeTextCell:self getWebViewHeight:self.webViewHeight];
        //                }
        //            }
        //        }];
        
        CGSize size = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        HQLog(@"CGSize===%@",NSStringFromCGSize(size));
        
        if (self.webViewHeight != size.height) {
            
            self.webViewHeight = size.height;
            CGSize titleSize = [HQHelper sizeWithFont:BFONT(12) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:self.model.label];// title的高度
            
            self.model.height = @((self.webViewHeight + titleSize.height) < 150 ? 150 : (self.webViewHeight + titleSize.height));
            
            if ([self.delegate respondsToSelector:@selector(customAttributeTextCell:getWebViewHeight:)]) {
                
                [self.delegate customAttributeTextCell:self getWebViewHeight:[self.model.height floatValue]];
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
        
        //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
        //        [KeyWindow addSubview:imageView];
        //        imageView.tag = 0x2222;
        //        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        imageView.backgroundColor = [UIColor blackColor];
        //        [imageView sd_setImageWithURL:[HQHelper URLWithString:message.body] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
        //            if (image) {
        //                [KeyWindow addSubview:imageView];
        //            }else{
        //                [MBProgressHUD showError:@"未获取到图片" toView:self];
        //            }
        //
        //        }];
        //        imageView.userInteractionEnabled = YES;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        //        [imageView addGestureRecognizer:tap];
        HQMainQueue(^{
            
            if ([self.delegate respondsToSelector:@selector(customAttributeTextCell:didClickedImage:)]) {
                [self.delegate customAttributeTextCell:self didClickedImage:[HQHelper URLWithString:message.body]];
            }
        });
    }
}

- (void)imageViewClicked:(UITapGestureRecognizer *)tap{
    
    [tap.view removeFromSuperview];
}


/** 重新加载详情内容 */
-(void)reloadDetailContentWithContent:(NSString *)content{
    
    
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
    
    
    //可编辑
    if (self.type == 0) {
        
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
            self.isFinish = YES;
        }];
        
        
    }
    else { //不可编辑（详情）
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
    
    
}


/** 获取编辑的内容 */
- (void)getEmailContentFromWebview {
    
    NSString * jsStr  =[NSString stringWithFormat:@"sendValMobile()"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        //此处可以打印error.
        //        HQLog(@"result:%@  error:%@",result,error);
        
        if ([self.delegate respondsToSelector:@selector(customAttributeTextCell:getWebViewContent:)]) {
            
            [self.delegate customAttributeTextCell:self getWebViewContent:result];
        }
        
    }];
    
}


+ (instancetype)customAttributeTextCellWithTableView:(UITableView *)tableView type:(NSInteger)type index:(NSInteger)index{
    
    NSString *indentifier = [NSString stringWithFormat:@"TFCustomAttributeTextOldCell%ld",index];
    TFCustomAttributeTextOldCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomAttributeTextOldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier type:type];
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
