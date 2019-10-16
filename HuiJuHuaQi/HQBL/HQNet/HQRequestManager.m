//
//  HQRequestManager.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQRequestManager.h"
#import "LBKeyChainTool.h"
#import "HQConfig.h"
#import "HQConst.h"
#import "AFNetworking.h"
#import "TFFileModel.h"
#import "AlertView.h"
#import "NSString+AES.h"

#define NormalRequest 30
#define BigDataRequest 60

@interface HQRequestManager()

/** 第三方请求管理器 */
@property (nonatomic, strong) AFHTTPSessionManager *requestOperationManager;

/** 请求序列号 */
@property (nonatomic, assign) NSInteger requestIndex;

/** 请求任务队列 */
@property (nonatomic, strong) NSMutableArray *requestItems;

/** 是否在执行 */
@property (nonatomic, assign) BOOL executing;

/** 网络是否可达 */
@property (nonatomic, assign) BOOL isNetworkAvailable;
/** 网络状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus netWorkStatus;

/** 服务端是否可达 */
@property (nonatomic, assign) BOOL isServerAvailable;
/** 服务端状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus serverWorkStatus;


/** 网络管理器 */
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

/** 服务端管理器 */
@property (nonatomic, strong) AFNetworkReachabilityManager *serverReachabilityManager;


@end

static HQRequestManager *instance = nil;
static dispatch_once_t oncetoKen;

@implementation HQRequestManager

/** 单例 */
+ (HQRequestManager *)sharedManager
{
    dispatch_once(&oncetoKen, ^{
        if(instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

/** 单例销毁 */
+ (void)dellocManager{
    instance = nil;
    oncetoKen = 0;
}

-(void)dealloc{
    HQLog(@"sharedManager ==== 单例被销毁了");
}

- (id)init
{
    
    if (self = [super init])
    {
        _isNetworkAvailable = YES;
        _requestIndex = 0;
        _requestItems = [NSMutableArray array];
        
        AFSecurityPolicy *securityPolicy;
//#ifdef DisFlag
        if ([[AppDelegate shareAppDelegate].baseUrl isEqualToString:baseUrl]) {
            
        
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        [securityPolicy setAllowInvalidCertificates:NO];
        [securityPolicy setValidatesDomainName:YES];
        
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        NSSet *set = [NSSet setWithObject:certData];
        [securityPolicy setPinnedCertificates:set];
        
        //请求管理器
        _requestOperationManager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:[AppDelegate shareAppDelegate].baseUrl]];
            
        }else{
//#else
        
        securityPolicy = [AFSecurityPolicy defaultPolicy];
        [securityPolicy setAllowInvalidCertificates:YES];
        //请求管理器
        _requestOperationManager = [AFHTTPSessionManager manager];
        }
//#endif
        
        
        
        [_requestOperationManager setSecurityPolicy:securityPolicy];
        
        //申明请求为HTTP类型
        _requestOperationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        
        //申明返回的结果是json类型
        _requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        

        
        //网络是否可达 管理器
        _reachabilityManager = [AFNetworkReachabilityManager managerForDomain:kNetMonitorAddress];
        [_reachabilityManager startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
        
        //服务器是否可达 管理器
        _serverReachabilityManager = [AFNetworkReachabilityManager managerForDomain:[AppDelegate shareAppDelegate].baseUrl];
        [_serverReachabilityManager startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}



- (HQRequestItem *)requestItemFromIndex:(NSInteger)index
{
    NSArray *arr = [NSArray arrayWithArray:_requestItems];
    for (HQRequestItem *item in arr)
    {
        if (item.sid == index) {
            
            return item;
        }
    }
    return nil;
}



/** 
 * 加载请求
 *
 */
- (void)loopRequestWithRequestItem:(HQRequestItem *)requestItem{
    
    
//    HQRequestItem *requestItem = _requestItems.lastObject;
    HQLog(@"我将请求：==+==%@==+==",requestItem.url);
    
    NSInteger sid = requestItem.sid;
    
    //将要请求
    if (requestItem.willRequestBlk) {
        
        requestItem.willRequestBlk(requestItem.cmdId, sid);
    }
    
    if (!requestItem.isExecuting) {
        
        if ([requestItem.method isEqualToString:@"GET"]) {
            // GET 请求
            [self getWithRequestItem:requestItem];
        }
        
        if ([requestItem.method isEqualToString:@"POST"]){
            
            if (requestItem.imgDatas.count == 0  &&  requestItem.audioDatas.count == 0 && requestItem.videoDatas.count == 0) {
                //POST 普通请求
                [self postWithRequestItem:requestItem];
            }else{
                
                // 判断文件的大小是否满足上传条件
                NSNumber *remain = [[NSUserDefaults standardUserDefaults] objectForKey:DataFlowRemain];
                
                if (!remain || [remain isEqualToNumber:@1]) {// 需提醒
                    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
                    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                        
                        if(status != AFNetworkReachabilityStatusReachableViaWiFi)// 非wifi
                        {
                            
                            NSArray *imgDatas   = requestItem.imgDatas;
                            NSArray *audioDatas = requestItem.audioDatas;
                            NSArray *videoDatas = requestItem.videoDatas;
                            
                            NSInteger length = 0;
                            
                            // 图片
                            for(NSInteger i=0; i<imgDatas.count; i++) {
                                
                                id object = [imgDatas objectAtIndex:i];
                                if ([object isKindOfClass:[UIImage class]]) {
                                    
                                    UIImage *image = [imgDatas objectAtIndex:i];
                                    NSData *eachImgData = UIImageJPEGRepresentation(image, 0.1);
                                    length += eachImgData.length;
                                }
                                
                                if ([object isKindOfClass:[NSArray class]]) {
                                    
                                    NSArray *arr = [imgDatas objectAtIndex:i];
                                    for(NSInteger i=0; i<arr.count; i++) {
                                        
                                        if ([object isKindOfClass:[UIImage class]]) {
                                            
                                            UIImage *image = [arr objectAtIndex:i];
                                            NSData *eachImgData = UIImageJPEGRepresentation(image, 0.1);
                                            
                                            length += eachImgData.length;
                                        }
                                    }
                                }
                            }
                            
                            // 音频
                            for (NSString *str in audioDatas) {
                                
                                NSData *data = [NSData dataWithContentsOfFile:str];
                                length += data.length;
                            }
                            // 视频
                            for (NSString *str in videoDatas) {
                                
                                NSData *data = [NSData dataWithContentsOfFile:str];
                                length += data.length;
                            }
                            
                            if (length/1000.0/1000.0 > MaxFileSize) {// 大于10M提示
                                
                                [AlertView showAlertView:@"流量提醒" msg:@"您正在使用2G/3G/4G网络上传大于10M的内容，继续使用可能产生流量费用（运营商收取），是否继续？" leftTitle:@"取消" rightTitle:@"继续上传" onLeftTouched:^{
                                    
                                    // 非主线程
                                    HQLog(@"currentThread:%@",[NSThread currentThread]);
                                    //失败
                                    HQRequestItem *responseItem = [self requestItemFromIndex:sid];
                                    
                                    HQLog(@"Upload Photo Response Fail! (URL:%@, CMD:%ld, Sid:%ld)",responseItem.url, (long)responseItem.cmdId, (long)responseItem.sid);
                                    
                                    if (responseItem!=nil) {
                                        if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didErrorWithData:cmdId:)) {
                                            
                                            HQMainQueue(^{
                                                NSError *error = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:1000 userInfo:@{@"description" : @"取消请求"}];
                                                
                                                [responseItem.delegate requestManager:self sequenceID:responseItem.sid didErrorWithData:error cmdId:(HQCMD)responseItem.cmdId];
                                            });
                                        }
                                    }
                                    [self.requestItems removeObject:responseItem];
                                    self.executing = NO;
                                    
                                    //执行下一个任务
//                                    [self loopRequest];
                                    
                                } onRightTouched:^{
                                    
                                    //POST 上传图片与录音
                                    if ((NSInteger)requestItem.cmdId < MutilFileStart) {// 普通
                                        
                                        [self postUploadWithRequestItem:requestItem];
                                    }else{// 多文件
                                        [self postUploadMutilFileWithRequestItem:requestItem];
                                    }
                                    
                                }];
                                
                            }else{
                                
                                //POST 上传图片与录音
                                if ((NSInteger)requestItem.cmdId < MutilFileStart) {// 普通
                                    
                                    [self postUploadWithRequestItem:requestItem];
                                }else{// 多文件
                                    [self postUploadMutilFileWithRequestItem:requestItem];
                                }
                                
                            }
                            
                        }
                        
                        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                           
                            //POST 上传图片与录音
                            if ((NSInteger)requestItem.cmdId < MutilFileStart) {// 普通
                                
                                [self postUploadWithRequestItem:requestItem];
                            }else{// 多文件
                                [self postUploadMutilFileWithRequestItem:requestItem];
                            }
                            
                        }
                        
                    }];
                    
                }else{
                    
                    //POST 上传图片与录音
                    if ((NSInteger)requestItem.cmdId < MutilFileStart) {// 普通
                        
                        [self postUploadWithRequestItem:requestItem];
                    }else{// 多文件
                        [self postUploadMutilFileWithRequestItem:requestItem];
                    }
                }
                
            }
        }
        
        
        if ([requestItem.method isEqualToString:@"SELFPOST"] || [requestItem.method isEqualToString:@"SELFDEL"]){
            // 自定义请求
            [self selfWithRequestItem:requestItem];
        }
        
        if ([requestItem.method isEqualToString:@"DELETE"]) {
            // 删除请求
            [self deleteWithRequestItem:requestItem];
        }
        
        requestItem.isExecuting = YES;
    }
    
}

/** 设置请求头部 */
- (void)setRequestHeaderWithRequest:(id)request{
    
    TFUserLoginCModel *userInfo = [HQUserManager defaultUserInfoManager].userLoginInfo;
    if (userInfo) {
        
        [request setValue:userInfo.token forHTTPHeaderField:@"TOKEN"];
    }
    
    // 1：Android客户端
    // 2：IOS客户端
    [request setValue:@"2" forHTTPHeaderField:@"CLIENT_FLAG"];
    // SIGN=时间戳,ip,CLIENT_FLAG,随机数(0-100)
    NSString *sign = [NSString stringWithFormat:@"%lld,%@,2,%u",[HQHelper getNowTimeSp],[LBKeyChainTool getUUIDStr],arc4random_uniform(1000)];
    NSString *signSecret = [sign aes128Encrypt:Privatekey];
    signSecret = [signSecret stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    signSecret = [signSecret stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [request setValue:signSecret forHTTPHeaderField:@"SIGN"];
    
    HQLog(@"****************请求头中固定部分参数*******************");
    HQLog(@"TOKEN = %@",          userInfo.token);
    HQLog(@"CLIENT_FLAG = 2");
    HQLog(@"SIGN = %@", sign);
    HQLog(@"SIGN = %@", signSecret);
    HQLog(@"*****************请求头中固定部分参数******************");
    
}

-(NSDictionary <NSString *,NSString *> *)requestHeader{
    
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    
    TFUserLoginCModel *userInfo = [HQUserManager defaultUserInfoManager].userLoginInfo;
    if (userInfo.token) {
        
        [request setObject:userInfo.token forKey:@"TOKEN"];
    }
    
    // 1：Android客户端
    // 2：IOS客户端
    [request setObject:@"2" forKey:@"CLIENT_FLAG"];
    // SIGN=时间戳,ip,CLIENT_FLAG,随机数(0-100)
    NSString *sign = [NSString stringWithFormat:@"%lld,%@,2,%u",[HQHelper getNowTimeSp],[LBKeyChainTool getUUIDStr],arc4random_uniform(1000)];
    NSString *signSecret = [sign aes128Encrypt:Privatekey];
    signSecret = [signSecret stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    signSecret = [signSecret stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [request setObject:signSecret forKey:@"SIGN"];
    
    HQLog(@"****************请求头中固定部分参数*******************");
    HQLog(@"TOKEN = %@", userInfo.token);
    HQLog(@"CLIENT_FLAG = 2");
    HQLog(@"SIGN = %@", sign);
    HQLog(@"SIGN = %@", signSecret);
    HQLog(@"*****************请求头中固定部分参数******************");
    
    return request;
}
/** 处理参数中的字符串首尾空白字符 */
- (id)handleStringEmptyParameter:(id)parameter{
    
    if ([parameter isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameter];
        for (NSString *key in dict.allKeys) {
            id obj = [dict valueForKey:key];
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *str = obj;
                [dict setObject:str.trimEmptySpace forKey:key];
            }else{
                [dict setObject:[self handleStringEmptyParameter:obj] forKey:key];
            }
        }
        return dict;
        
    }else if ([parameter isKindOfClass:[NSArray class]]){
        
        NSArray *arr = parameter;
        NSMutableArray *arrs = [NSMutableArray array];
        for (id obj in arr) {
            [arrs addObject:[self handleStringEmptyParameter:obj]];
        }
        return arrs;
    }else if ([parameter isKindOfClass:[NSString class]]){
        
        NSString *str = parameter;
        
        return str.trimEmptySpace;
    }
    return parameter;
    
}

/** 自定义请求 */
- (void)selfWithRequestItem:(HQRequestItem*)requestItem{
    
    _executing = YES;
    NSInteger sid = requestItem.sid;
    __weak typeof(self) wSelf = self;
    
    // 处理
//    requestItem.requestParam = [self handleStringEmptyParameter:requestItem.requestParam];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:requestItem.requestParam?:@{} options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestItem.url]];
    request.timeoutInterval = NormalRequest;
    
    if ([requestItem.method isEqualToString:@"SELFPOST"]) {
        
        [request setHTTPMethod:@"POST"];
    }
    
    if ([requestItem.method isEqualToString:@"SELFDEL"]) {
        
        [request setHTTPMethod:@"DELETE"];
    }
    
    [request setHTTPBody:data];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置请求头部
    [self setRequestHeaderWithRequest:request];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // 非主线程
        HQLog(@"currentThread: %@",[NSThread currentThread]);
        HQLog(@"response---------%@",response);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        // 成功
        if (error == nil && httpResponse.statusCode == HQRESCode_Success00) {
            
            __strong __typeof(wSelf) strongSelf = wSelf;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
            
            //成功
            HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
            
            HQLog(@"response jsonStr (%@)---From Bag(%@)", [HQHelper dictionaryToJson:dic] , responseItem);
            
            if (responseItem!=nil) {
                if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithData:cmdId:)) {
                    
                    HQMainQueue(^{
                        [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didCompleteWithData:dic cmdId:(HQCMD)responseItem.cmdId];
                    });
                }
            }
            [strongSelf.requestItems removeObject:responseItem];
            strongSelf.executing = NO;
            
            //执行下一个任务
//            [strongSelf loopRequest];
            
            
            
        }else{// 失败
            
            HQLog(@"currentThread:%@",[NSThread currentThread]);
            __strong __typeof(wSelf) strongSelf = wSelf;
            HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
            
            HQLog(@"Response Failed Bag(%@)---From Bag(%@)", error?:response, responseItem);
            
            if (responseItem!=nil) {
                
                if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didErrorWithData:cmdId:)) {
                    NSString *str = [NSString stringWithFormat:@"请求异常：%ld",httpResponse.statusCode];
                    HQMainQueue(^{
                
                        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
                        if (!error) {
                            [dd setObject:str forKey:kDescribe];
                            [dd setObject:@(httpResponse.statusCode) forKey:kCode];
                        }
                        [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didErrorWithData:error?:dd cmdId:(HQCMD)responseItem.cmdId];
                    
                    });
                
                }
            }
            [strongSelf.requestItems removeObject:responseItem];
            strongSelf.executing = NO;
            
            //执行下一个任务
//            [strongSelf loopRequest];
            
        }
        
    }];
    
    [task resume];

    
}


/** DELETE 请求 */
- (void)deleteWithRequestItem:(HQRequestItem*)requestItem{
    _executing = YES;
    NSInteger sid = requestItem.sid;
    __weak typeof(self) wSelf = self;
    _requestOperationManager.requestSerializer.timeoutInterval = NormalRequest;
    
    // 设置请求头
//    [self setRequestHeaderWithRequest:_requestOperationManager.requestSerializer];
    
    // 发送请求
    [_requestOperationManager DELETE:requestItem.url
                          parameters:requestItem.requestParam
                             headers:[self requestHeader]
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 __strong __typeof(wSelf) strongSelf = wSelf;
                                 
                                 HQLog(@"currentThread:%@",[NSThread currentThread]);
                                 //成功
                                 HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
                                 
                                 HQLog(@"response jsonStr (%@)---From Bag(%@)", [HQHelper dictionaryToJson:responseObject], responseItem);
                                 
                                 if (responseItem!=nil) {
                                     if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithData:cmdId:)) {
                                         
                                         HQMainQueue(^{
                                             [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didCompleteWithData:responseObject cmdId:(HQCMD)responseItem.cmdId];
                                         });
                                     }
                                 }
                                 [strongSelf.requestItems removeObject:responseItem];
                                 strongSelf.executing = NO;
                                 
                                 //执行下一个任务
//                                 [strongSelf loopRequest];
                                 

                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 HQLog(@"currentThread:%@",[NSThread currentThread]);
                                 //失败
                                 __strong __typeof(wSelf) strongSelf = wSelf;
                                 HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
                                 
                                 HQLog(@"Response Failed Bag(%@)---From Bag(%@)", error, responseItem);
                                 
                                 if (responseItem!=nil) {
                                     if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didErrorWithData:cmdId:)) {
                                         
                                         HQMainQueue(^{
                                             [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didErrorWithData:error cmdId:(HQCMD)responseItem.cmdId];
                                         });
                                     }
                                 }
                                 [strongSelf.requestItems removeObject:responseItem];
                                 strongSelf.executing = NO;
                                 
                                 //执行下一个任务
//                                 [strongSelf loopRequest];
                             }];
    
}


/** GET 请求 */
- (void)getWithRequestItem:(HQRequestItem*)requestItem{
    _executing = YES;
    NSInteger sid = requestItem.sid;
    __weak typeof(self) wSelf = self;
    _requestOperationManager.requestSerializer.timeoutInterval = NormalRequest;
    
    // 设置请求头
//    [self setRequestHeaderWithRequest:_requestOperationManager.requestSerializer];
    
    //发送请求
    [_requestOperationManager GET:requestItem.url
                       parameters:requestItem.requestParam
                          headers:[self requestHeader]
                         progress:^(NSProgress * _Nonnull downloadProgress) {
                             
                             HQLog(@"currentThread:%@",[NSThread currentThread]);
                             __strong __typeof(wSelf) strongSelf = wSelf;
                             
                             HQLog(@"data progress-------%@",downloadProgress);
                             
                             HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
                             
                             HQLog(@"---From Bag(%@)", responseItem);
                             
                             if (responseItem!=nil) {
                                 if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithProgress:cmdId:)) {
                                     
                                     HQMainQueue(^{
                                         [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didCompleteWithProgress:downloadProgress cmdId:(HQCMD)responseItem.cmdId];
                                     });
                                 }
                             }
                             
                         }
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              HQLog(@"currentThread:%@",[NSThread currentThread]);
                              
                              __strong __typeof(wSelf) strongSelf = wSelf;
                              
                              //成功
                              HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
                              
                              HQLog(@"response jsonStr (%@)---From Bag(%@)", [HQHelper dictionaryToJson:responseObject], responseItem);
                              
                              if (responseItem!=nil) {
                                  if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithData:cmdId:)) {
                                      
                                      HQMainQueue(^{
                                          
                                          [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didCompleteWithData:responseObject cmdId:(HQCMD)responseItem.cmdId];
                                      
                                      });
                                      
                                  }
                              }
                              [strongSelf.requestItems removeObject:responseItem];
                              strongSelf.executing = NO;
                              
                              //执行下一个任务
//                              [strongSelf loopRequest];

                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              HQLog(@"currentThread:%@",[NSThread currentThread]);
                              //失败
                              __strong __typeof(wSelf) strongSelf = wSelf;
                              HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
                              
                              HQLog(@"Response Failed Bag(%@)---From Bag(%@)", error, responseItem);
                              
                              if (responseItem!=nil) {
                                  if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didErrorWithData:cmdId:)) {
                                      
                                      HQMainQueue(^{
                                          
                                          [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didErrorWithData:error cmdId:(HQCMD)responseItem.cmdId];
                                          
                                      });
                                      
                                  }
                              }
                              [strongSelf.requestItems removeObject:responseItem];
                              strongSelf.executing = NO;
                              
                              //执行下一个任务
//                              [strongSelf loopRequest];
                          }];
    
}

/** POST 普通请求 */
- (void)postWithRequestItem:(HQRequestItem*)requestItem
{
    
    _executing = YES;
    NSInteger sid = requestItem.sid;
    __weak typeof(self) wSelf = self;
    _requestOperationManager.requestSerializer.timeoutInterval = NormalRequest;
    
    // 设置请求头
//    [self setRequestHeaderWithRequest:_requestOperationManager.requestSerializer];
    
    //发送请求
    [_requestOperationManager POST:requestItem.url
                        parameters:requestItem.requestParam
                           headers:[self requestHeader]
                          progress:^(NSProgress * _Nonnull downloadProgress) {
                              
                              HQLog(@"currentThread:%@",[NSThread currentThread]);
                              __strong __typeof(wSelf) strongSelf = wSelf;
                              
                              HQLog(@"data progress-------%@",downloadProgress);
                              
                              HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
                              
                              HQLog(@"---From Bag(%@)", responseItem);
                              
                              if (responseItem!=nil) {
                                  if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithProgress:cmdId:)) {
                                      
                                      HQMainQueue(^{
                                          [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didCompleteWithProgress:downloadProgress cmdId:(HQCMD)responseItem.cmdId];
                                      });
                                  }
                              }
                              
                          }
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
                               
                               HQLog(@"currentThread:%@",[NSThread currentThread]);
                                __strong __typeof(wSelf) strongSelf = wSelf;
                                
                                //成功
                                HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
                                                       
                                HQLog(@"response jsonStr (%@)---From Bag(%@)", [HQHelper dictionaryToJson:responseObject], responseItem);
                               
                                
                                if (responseItem!=nil) {
                                    if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithData:cmdId:)) {
                                        
                                        HQMainQueue(^{
                                            [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didCompleteWithData:responseObject cmdId:(HQCMD)responseItem.cmdId];
                                        });
                                    }
                                }
                                [strongSelf.requestItems removeObject:responseItem];
                                strongSelf.executing = NO;
                                
                                //执行下一个任务
//                                [strongSelf loopRequest];
                            }
                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               HQLog(@"currentThread:%@",[NSThread currentThread]);
                                //失败
                                __strong __typeof(wSelf) strongSelf = wSelf;
                                HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
                                
                                HQLog(@"Response Failed Bag(%@)---From Bag(%@)", error, responseItem);
                                
                                if (responseItem!=nil) {
                                    if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didErrorWithData:cmdId:)) {
                                        
                                        HQMainQueue(^{
                                            [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didErrorWithData:error cmdId:(HQCMD)responseItem.cmdId];
                                        });
                                    }
                                }
                                [strongSelf.requestItems removeObject:responseItem];
                                strongSelf.executing = NO;
                                
                                //执行下一个任务
//                                [strongSelf loopRequest];
                            }];
}

/** POST 上传图片与录音视频请求 */

- (void)postUploadWithRequestItem:(HQRequestItem*)requestItem{
    _executing = YES;
    NSInteger sid       = requestItem.sid;
//    NSArray *imgDatas   = requestItem.imgDatas;
    
    NSMutableArray *images = [NSMutableArray array];
    for (UIImage *image in requestItem.imgDatas) {// 修正图片
        UIImage *img = [HQHelper fixedImageOrientationWithImage:image];
        [images addObject:img];
    }
    
    NSArray *imgDatas   = images;
    NSArray *audioDatas = requestItem.audioDatas;
    NSArray *videoDatas = requestItem.videoDatas;
    
    _requestOperationManager.requestSerializer.timeoutInterval = BigDataRequest;
    
    // 设置请求头
//    [self setRequestHeaderWithRequest:_requestOperationManager.requestSerializer];
    
    
    __weak typeof(self) wSelf = self;
    [_requestOperationManager POST:requestItem.url
                        parameters:requestItem.requestParam
                           headers:[self requestHeader]
         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
             //             __strong __typeof(wSelf) strongSelf = wSelf;
             if (imgDatas.count > 0) {
                 // 图片
                 for(NSInteger i=0; i<imgDatas.count; i++) {
                     
                     id object = [imgDatas objectAtIndex:i];
                     if ([object isKindOfClass:[UIImage class]]) {
                         
                         UIImage *image = [imgDatas objectAtIndex:i];
                         NSData *eachImgData =
//                         UIImagePNGRepresentation(image);
                         UIImageJPEGRepresentation(image, 0.1);
                         
                         // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                         // 要解决此问题，
                         // 可以在上传时使用当前的系统事件作为文件名
                         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                         // 设置时间格式
                         formatter.dateFormat = @"yyyyMMddHHmmss";
                         NSString *str = [formatter stringFromDate:[NSDate date]];
                         NSString *fileName = [NSString stringWithFormat:@"%@%ld.jpg", str,i];
                         
                         [formData appendPartWithFileData:eachImgData
                                                     name:[NSString stringWithFormat:@"img%d", (int)i+1]
                                                 fileName:fileName
                                                 mimeType:@"image/jpg"];
                         
                         
                     }
                     
                     else if ([object isKindOfClass:[NSArray class]]) {
                     
                         NSArray *objectArr = (NSArray *)object;
                         for (NSInteger j=0; j<objectArr.count; j++) {
                             
                             UIImage *image = [objectArr objectAtIndex:j];
                             NSData *eachImgData =
//                             UIImagePNGRepresentation(image);
                             UIImageJPEGRepresentation(image, 0.1);
                             // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                             // 要解决此问题，
                             // 可以在上传时使用当前的系统事件作为文件名
                             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                             // 设置时间格式
                             formatter.dateFormat = @"yyyyMMddHHmmss";
                             NSString *str = [formatter stringFromDate:[NSDate date]];
                             NSString *fileName = [NSString stringWithFormat:@"%@%ld.jpg", str,i];
                             
                             [formData appendPartWithFileData:eachImgData
                                                         name:[NSString stringWithFormat:@"%d_%d", (int)i, (int)j]
                                                     fileName:fileName
                                                     mimeType:@"image/jpg"];
                         }
                     }
                     

                 }
             }
             
             //录音
             if (audioDatas.count > 0) {
                 
                 for(NSInteger i=0; i<audioDatas.count; i++) {
                     
                     NSData *eachVedioData = [NSData dataWithContentsOfFile:audioDatas[i]];
                     
                     // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                     // 要解决此问题，
                     // 可以在上传时使用当前的系统事件作为文件名
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     // 设置时间格式
                     formatter.dateFormat = @"yyyyMMddHHmmss";
                     NSString *str = [formatter stringFromDate:[NSDate date]];
                     NSString *fileName = [NSString stringWithFormat:@"%@%ld.mp3", str,i];
                     
                     [formData appendPartWithFileData:eachVedioData
                                                 name:[NSString stringWithFormat:@"audio%d", (int)i+1]
                                             fileName:fileName
                                             mimeType:@"audio/mp3"];
                 }
             }
             
             if (videoDatas.count > 0) {
                 
                 for(NSInteger i=0; i<videoDatas.count; i++) {
                     
                     NSData *eachVedioData = [NSData dataWithContentsOfFile:videoDatas[i]];
                     
                     // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                     // 要解决此问题，
                     // 可以在上传时使用当前的系统事件作为文件名
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     // 设置时间格式
                     formatter.dateFormat = @"yyyyMMddHHmmss";
                     NSString *str = [formatter stringFromDate:[NSDate date]];
                     NSString *fileName = [NSString stringWithFormat:@"%@%ld.mp4", str,i];
                     
                     [formData appendPartWithFileData:eachVedioData
                                                 name:[NSString stringWithFormat:@"video%d", (int)i+1]
                                             fileName:fileName
                                             mimeType:@"video/mp4"];
                 }

             }
             
             
         }
                          progress:^(NSProgress * _Nonnull uploadProgress) {
             __strong __typeof(wSelf) strongSelf = wSelf;
             
             
             // 非主线程
             HQLog(@"currentThread:%@",[NSThread currentThread]);
             
             HQLog(@"data progress-------%@",uploadProgress);
             
             HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
             
             HQLog(@"---From Bag(%@)", responseItem);
             
             if (responseItem!=nil) {
                 if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithProgress:cmdId:)) {
                     
                     HQMainQueue(^{
                         [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didCompleteWithProgress:uploadProgress cmdId:(HQCMD)responseItem.cmdId];
                     });
                     
                 }
             }
             
         }
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //成功
             __strong __typeof(wSelf) strongSelf = wSelf;
             HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
             
             // 成功和失败都回到了主线程；
             HQLog(@"currentThread:%@",[NSThread currentThread]);
             
             HQLog(@"Upload Photo Response Bag(URL:%@, CMD:%ld, Sid:%ld): %@",responseItem.url, (long)responseItem.cmdId, (long)responseItem.sid, responseObject);
             
             if (responseItem!=nil) {
                 if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithData:cmdId:)) {
                     
                     HQMainQueue(^{
                         [responseItem.delegate requestManager:wSelf sequenceID:responseItem.sid didCompleteWithData:responseObject cmdId:(HQCMD)responseItem.cmdId];
                     });
                 }
             }
             [strongSelf.requestItems removeObject:responseItem];
             strongSelf.executing = NO;
             
             //执行下一个任务
//             [strongSelf loopRequest];
         }
                           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // 非主线程
             HQLog(@"currentThread:%@",[NSThread currentThread]);
             //失败
             __strong __typeof(wSelf) strongSelf = wSelf;
             HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
             
             HQLog(@"Upload Photo Response Fail! (URL:%@, CMD:%ld, Sid:%ld)",responseItem.url, (long)responseItem.cmdId, (long)responseItem.sid);
             
             HQLog(@"error:%@",error);
             
             if (responseItem!=nil) {
                 if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didErrorWithData:cmdId:)) {
                     
                     HQMainQueue(^{
                         
                         [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didErrorWithData:error cmdId:(HQCMD)responseItem.cmdId];
                     });
                 }
             }
             [strongSelf.requestItems removeObject:responseItem];
             strongSelf.executing = NO;
             
             //执行下一个任务
//             [strongSelf loopRequest];
         }];
}

/** POST 上传图片与录音请求 */
- (void)postUploadMutilFileWithRequestItem:(HQRequestItem*)requestItem{
    _executing = YES;
    NSInteger sid       = requestItem.sid;
    
    for (TFFileModel *file in requestItem.imgDatas) {// 修正图片
        file.image = [HQHelper fixedImageOrientationWithImage:file.image];
    }
    
    NSArray *imgDatas   = requestItem.imgDatas;
    _requestOperationManager.requestSerializer.timeoutInterval = BigDataRequest;
    
    // 设置请求头
//    [self setRequestHeaderWithRequest:_requestOperationManager.requestSerializer];
    
    __weak typeof(self) wSelf = self;
    [_requestOperationManager POST:requestItem.url
                        parameters:requestItem.requestParam
                           headers:[self requestHeader]
         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
             //             __strong __typeof(wSelf) strongSelf = wSelf;
             if (imgDatas.count > 0) {
                 // 图片
                 for(NSInteger i=0; i<imgDatas.count; i++) {
                     
                         
                     TFFileModel *file = [imgDatas objectAtIndex:i];
                     NSData *eachImgData =
                     //                         UIImagePNGRepresentation(image);
                     UIImageJPEGRepresentation(file.image, 0.1);
                     
                     NSString *fileName = file.file_name;
                     
                     [formData appendPartWithFileData:eachImgData
                                                 name:[NSString stringWithFormat:@"img%d", (int)i+1]
                                             fileName:fileName
                                             mimeType:@"image/jpg"];
                         
                     
                 }
             }
             
            
             
         } progress:^(NSProgress * _Nonnull uploadProgress) {
             __strong __typeof(wSelf) strongSelf = wSelf;
             
             
             // 非主线程
             HQLog(@"currentThread:%@",[NSThread currentThread]);
             
             HQLog(@"data progress-------%@",uploadProgress);
             
             HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
             
             HQLog(@"---From Bag(%@)", responseItem);
             
             if (responseItem!=nil) {
                 if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithProgress:cmdId:)) {
                     
                     HQMainQueue(^{
                         [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didCompleteWithProgress:uploadProgress cmdId:(HQCMD)responseItem.cmdId];
                     });
                     
                 }
             }
             
         }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //成功
             __strong __typeof(wSelf) strongSelf = wSelf;
             HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
             
             // 成功和失败都回到了主线程；
             HQLog(@"currentThread:%@",[NSThread currentThread]);
             
             HQLog(@"Upload Photo Response Bag(URL:%@, CMD:%ld, Sid:%ld): %@",responseItem.url, (long)responseItem.cmdId, (long)responseItem.sid, responseObject);
             
             if (responseItem!=nil) {
                 if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didCompleteWithData:cmdId:)) {
                     
                     HQMainQueue(^{
                         [responseItem.delegate requestManager:wSelf sequenceID:responseItem.sid didCompleteWithData:responseObject cmdId:(HQCMD)responseItem.cmdId];
                     });
                 }
             }
             [strongSelf.requestItems removeObject:responseItem];
             strongSelf.executing = NO;
             
             //执行下一个任务
//             [strongSelf loopRequest];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // 非主线程
             HQLog(@"currentThread:%@",[NSThread currentThread]);
             //失败
             __strong __typeof(wSelf) strongSelf = wSelf;
             HQRequestItem *responseItem = [strongSelf requestItemFromIndex:sid];
             
             HQLog(@"Upload Photo Response Fail! (URL:%@, CMD:%ld, Sid:%ld)",responseItem.url, (long)responseItem.cmdId, (long)responseItem.sid);
             
             HQLog(@"error:%@",error);
             
             if (responseItem!=nil) {
                 if (IsDelegate(responseItem.delegate, requestManager:sequenceID:didErrorWithData:cmdId:)) {
                     
                     HQMainQueue(^{
                         
                         [responseItem.delegate requestManager:strongSelf sequenceID:responseItem.sid didErrorWithData:error cmdId:(HQCMD)responseItem.cmdId];
                     });
                 }
             }
             [strongSelf.requestItems removeObject:responseItem];
             strongSelf.executing = NO;
             
             //执行下一个任务
//             [strongSelf loopRequest];
         }];
}


/** API 网络请求入口 */
- (HQRequestItem*)requestToURL:(NSString*)url
                        method:(NSString*)method
                  requestParam:(id)params
                         cmdId:(HQCMD)cmdId
                      delegate:(id<HQRequestManagerDelegate>)delegate
                    startBlock:(WillRequestBlk)blk
{
    
    HQRequestItem *requestItem = [[HQRequestItem alloc] initWithUrl:url method:method cmdId:cmdId sid:_requestIndex requestParam:params imgData:nil audioData:nil videoData:nil delegate:delegate willRequestBlk:blk];
    
    [_requestItems addObject:requestItem];
    ++_requestIndex;
    [self loopRequestWithRequestItem:requestItem];
    
    
    return requestItem;
}

/** API 网络请求入口 */
- (HQRequestItem*)uploadPicToURL:(NSString*)url requestParam:(id)params mediaDatas:(NSArray*)mediaDatas cmdId:(HQCMD)cmdId delegate:(id<HQRequestManagerDelegate>)delegate startBlock:(WillRequestBlk)blk
{
    
    HQRequestItem *requestItem = [[HQRequestItem alloc] initWithUrl:url method:@"POST" cmdId:cmdId sid:_requestIndex requestParam:params imgData:mediaDatas audioData:nil videoData:nil delegate:delegate willRequestBlk:blk];
    
    
    [_requestItems addObject:requestItem];
    ++_requestIndex;
    [self loopRequestWithRequestItem:requestItem];
    
    
    return requestItem;
}




/** 上传图片与录间请求 (imgDatas数组中全是UIImage对象)(vedioDatas数组中全是录音地址URL) */
- (HQRequestItem *)uploadPicToURL:(NSString*)url requestParam:(id)params imgDatas:(NSArray*)imgDatas audioDatas:(NSArray *)audioDatas videoDatas:(NSArray *)videoDatas cmdId:(HQCMD)cmdId delegate:(id<HQRequestManagerDelegate>)delegate startBlock:(WillRequestBlk)blk
{
    HQRequestItem *requestItem = [[HQRequestItem alloc] initWithUrl:url method:@"POST" cmdId:cmdId sid:_requestIndex requestParam:params imgData:imgDatas audioData:audioDatas videoData:videoDatas delegate:delegate willRequestBlk:blk];
    
    [_requestItems addObject:requestItem];
    ++_requestIndex;
    [self loopRequestWithRequestItem:requestItem];
    
    return requestItem;
}




#pragma mark - AFNetworkingReachabilityDidChangeNotification
//网络连接 监听方法
- (void)reachabilityDidChange:(NSNotification*)notification
{
    NSDictionary *netDic = notification.userInfo;
    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)[netDic[AFNetworkingReachabilityNotificationStatusItem] intValue];
    _netWorkStatus = status;
    if (status == AFNetworkReachabilityStatusNotReachable) {
        
        //网络不可达
        if (_isNetworkAvailable) {
            _isNetworkAvailable = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkStatusNotReachable" object:nil];
        }
        
        
    }else{
        if (!_isNetworkAvailable) {
            _isNetworkAvailable = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkStatusReachable" object:nil];
        }
    }
}

//服务端连接 监听方法
- (void)serverReachabilityDidChange:(NSNotification*)notification
{
    NSDictionary *netDic = notification.userInfo;
    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)[netDic[AFNetworkingReachabilityNotificationStatusItem] intValue];
    _serverWorkStatus = status;
    if (status == AFNetworkReachabilityStatusNotReachable) {
        //网络不可达
        _isServerAvailable = NO;
    }else{
        _isServerAvailable = YES;
    }
}


@end
