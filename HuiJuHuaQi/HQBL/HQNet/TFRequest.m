//
//  TFRequest.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRequest.h"
#import "AFNetworking.h"
#import "LBKeyChainTool.h"
#import "NSString+AES.h"


@interface TFRequest ()


/** 第三方请求管理器 */
@property (nonatomic, strong) AFHTTPSessionManager *requestOperationManager;

/** 互联网状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus netWorkStatus;
/** 服务端状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus serverWorkStatus;

/** 网络管理器 */
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

/** 服务端管理器 */
@property (nonatomic, strong) AFNetworkReachabilityManager *serverReachabilityManager;

@end

static TFRequest *instance = nil;
static dispatch_once_t oncetoKen;

@implementation TFRequest
/** GET请求 */
-(void)requestGET:(NSString *)URLString
       parameters:(id)parameters
         progress:(void (^)(NSProgress *))progress
          success:(void (^)(id))success
          failure:(void (^)(NSError *))failure{
    
   
    // 头部信息
//    [self setRequestHeaderWithRequest:self.requestOperationManager.requestSerializer];
    
    [self.requestOperationManager GET:URLString
                           parameters:parameters
                              headers:[self setRequestHeader]
                             progress:^(NSProgress * downloadProgress) {
        
                                 
        HQMainQueue(^{
            
            if (progress) {
                progress(downloadProgress);
            }
            
        });
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        HQLog(@"currentThread:%@",[NSThread currentThread]);
        HQLog(@"response jsonStr (%@)---From Bag(%@)", [HQHelper dictionaryToJson:parameters], [NSString stringWithFormat:@"URL:%@, Param:%@", URLString,[HQHelper dictionaryToJson:responseObject]]);
        HQMainQueue(^{
            
            if (success) {
                success(responseObject);
            }
            
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        HQLog(@"currentThread:%@",[NSThread currentThread]);
        
        HQLog(@"Response Failed Bag(%@)---From Bag(%@)", error, [NSString stringWithFormat:@"URL:%@, Param:%@", URLString,[HQHelper dictionaryToJson:parameters]]);
        HQMainQueue(^{
            
            if (failure) {
                failure(error);
            }
            
        });
    
    }];
    
}


/** POST请求 走参数 */
-(void)requestPOST:(NSString *)URLString
        parameters:(id)parameters
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure{
    
    // 头部信息
//    [self setRequestHeaderWithRequest:self.requestOperationManager.requestSerializer];
    
    [self.requestOperationManager POST:URLString
                            parameters:parameters
                               headers:[self setRequestHeader]
                              progress:^(NSProgress * uploadProgress) {
        
        HQMainQueue(^{
            
            if (progress) {
                progress(uploadProgress);
            }
            
        });
        
    } success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        HQLog(@"currentThread:%@",[NSThread currentThread]);
        HQLog(@"response jsonStr (%@)---From Bag(%@)", [HQHelper dictionaryToJson:parameters], [NSString stringWithFormat:@"URL:%@, Param:%@", URLString,[HQHelper dictionaryToJson:responseObject]]);
        
        HQMainQueue(^{
            
            if (success) {
                success(responseObject);
            }
            
        });
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        HQLog(@"currentThread:%@",[NSThread currentThread]);
        
        HQLog(@"Response Failed Bag(%@)---From Bag(%@)", error, [NSString stringWithFormat:@"URL:%@, Param:%@", URLString,[HQHelper dictionaryToJson:parameters]]);
        
        HQMainQueue(^{
            
            if (failure) {
                failure(error);
            }
            
        });
        
    }];
    
}


/** POST请求 走body */
-(void)requestPOST:(NSString *)URLString
              body:(id)body
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure{
    
    // 处理
    body = [self handleStringEmptyParameter:body];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:body?:@{} options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.timeoutInterval = 30;
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:data];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置请求头部
    [self setRequestHeaderWithRequest:request];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // 非主线程
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        // 成功
        if (error == nil && httpResponse.statusCode == HQRESCode_Success00) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
            
            HQLog(@"currentThread:%@",[NSThread currentThread]);
            HQLog(@"response jsonStr (%@)---From Bag(%@)", [HQHelper dictionaryToJson:dic], [NSString stringWithFormat:@"URL:%@, Param:%@", URLString,[HQHelper dictionaryToJson:body]]);
            
            NSDictionary *res = [dic valueForKey:@"response"];
            NSString *code = [[res valueForKey:@"code"] description];
            if ([code isEqualToString:@"common.sucess"] || [code isEqualToString:@"1001"]) {
                
                HQMainQueue(^{
                    
                    if (success) {
                        success(dic);
                    }
                    
                });
            }else{
                HQMainQueue((^{
                    NSError *error1 = [NSError errorWithDomain:NSCocoaErrorDomain code:1000 userInfo:@{NSLocalizedDescriptionKey:[res valueForKey:@"describe"],NSStringEncodingErrorKey:[res valueForKey:@"code"]}];
                    
                    if (failure) {
                        failure(error1);
                    }
                }));
            }
            
        }else{// 失败
            
            HQLog(@"currentThread:%@",[NSThread currentThread]);
            
            HQLog(@"Response Failed Bag(%@)---From Bag(%@)", error, [NSString stringWithFormat:@"URL:%@, Param:%@", URLString,[HQHelper dictionaryToJson:body]]);
            
            
            HQMainQueue(^{

                if (failure) {
                    failure(error);
                }

            });
            
        }
        
    }];
    
    [task resume];
}


/** 上传文件 */
-(void)requestPOST:(NSString *)URLString
        parameters:(id)parameters
            images:(NSArray *)images
            audios:(NSArray *)audios
            videos:(NSArray *)videos
             files:(NSArray *)files
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure{
    
    
    [self.requestOperationManager POST:URLString parameters:parameters headers:[self setRequestHeader] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        if (images.count > 0) {
            // 图片
            for(NSInteger i=0; i<images.count; i++) {
                
                id object = [images objectAtIndex:i];
                if ([object isKindOfClass:[UIImage class]]) {
                    
                    UIImage *image = [images objectAtIndex:i];
                    NSData *eachImgData = UIImageJPEGRepresentation(image, 0.1);
                    
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
                        NSData *eachImgData = UIImageJPEGRepresentation(image, 0.1);
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
        if (audios.count > 0) {
            
            for(NSInteger i = 0; i<audios.count; i++) {
                
                NSData *eachVedioData = [NSData dataWithContentsOfFile:audios[i]];
                
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
        
        if (videos.count > 0) {
            
            for(NSInteger i = 0; i < videos.count; i++) {
                
                NSData *eachVedioData = [NSData dataWithContentsOfFile:videos[i]];
                
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
        
        if (files.count > 0) {
            
            for(NSInteger i = 0; i < files.count; i++) {
                
                NSString *path = files[i];
                NSData *eachVedioData = [NSData dataWithContentsOfFile:path];
                
                // 取路径的最后component为文件名
                NSString *fileName = path.lastPathComponent;
                
                [formData appendPartWithFileData:eachVedioData
                                            name:[NSString stringWithFormat:@"file%d", (int)i+1]
                                        fileName:fileName
                                        mimeType:@"application/octet-stream"];
            }
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        HQMainQueue(^{
            
            if (progress) {
                progress(uploadProgress);
            }
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HQLog(@"currentThread:%@",[NSThread currentThread]);
        HQLog(@"response jsonStr (%@)---From Bag(%@)", [HQHelper dictionaryToJson:parameters], [NSString stringWithFormat:@"URL:%@, Param:%@", URLString,[HQHelper dictionaryToJson:responseObject]]);
        
        HQMainQueue(^{
            
            if (success) {
                success(responseObject);
            }
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HQLog(@"currentThread:%@",[NSThread currentThread]);
        
        HQLog(@"Response Failed Bag(%@)---From Bag(%@)", error, [NSString stringWithFormat:@"URL:%@, Param:%@", URLString,[HQHelper dictionaryToJson:parameters]]);
        
        HQMainQueue(^{
            
            if (failure) {
                failure(error);
            }
            
        });
    }];
    
}



/*********************************************初始化*********************************************/

/** 单例 */
+ (TFRequest *)sharedManager
{
    dispatch_once(&oncetoKen, ^{
        if(instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+(void)dellocManager{
    instance = nil;
    oncetoKen = 0;
}


- (id)init
{
    
    if (self = [super init])
    {
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
        _requestOperationManager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:[AppDelegate shareAppDelegate].baseUrl]];
//#endif
        }
        
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
        _serverReachabilityManager = [AFNetworkReachabilityManager managerForDomain:kServerAddress];
        [_serverReachabilityManager startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
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
    NSString *sign = [NSString stringWithFormat:@"%lld,%@,2,%u",[HQHelper getNowTimeSp],[LBKeyChainTool getUUIDStr],arc4random_uniform(100)];
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
/** 请求头部 */
- (NSDictionary <NSString *, NSString *> *)setRequestHeader{
    
    NSMutableDictionary<NSString *, NSString *> *dict = [NSMutableDictionary<NSString *, NSString *> dictionary];
    TFUserLoginCModel *userInfo = [HQUserManager defaultUserInfoManager].userLoginInfo;
    if (userInfo) {
        
        [dict setObject:TEXT(userInfo.token) forKey:@"TOKEN"];
    }
    
    // 1：Android客户端
    // 2：IOS客户端
    [dict setObject:@"2" forKey:@"CLIENT_FLAG"];
    // SIGN=时间戳,ip,CLIENT_FLAG,随机数(0-100)
    NSString *sign = [NSString stringWithFormat:@"%lld,%@,2,%u",[HQHelper getNowTimeSp],[LBKeyChainTool getUUIDStr],arc4random_uniform(100)];
    NSString *signSecret = [sign aes128Encrypt:Privatekey];
    signSecret = [signSecret stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    signSecret = [signSecret stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [dict setObject:signSecret forKey:@"SIGN"];
    
    HQLog(@"****************请求头中固定部分参数*******************");
    HQLog(@"TOKEN = %@",          userInfo.token);
    HQLog(@"CLIENT_FLAG = 2");
    HQLog(@"SIGN = %@", sign);
    HQLog(@"SIGN = %@", signSecret);
    HQLog(@"*****************请求头中固定部分参数******************");
    
    return dict;
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


#pragma mark - AFNetworkingReachabilityDidChangeNotification
//网络连接 监听方法
- (void)reachabilityDidChange:(NSNotification*)notification
{
    NSDictionary *netDic = notification.userInfo;
    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)[netDic[AFNetworkingReachabilityNotificationStatusItem] intValue];
    _netWorkStatus = status;
}

//服务端连接 监听方法
- (void)serverReachabilityDidChange:(NSNotification*)notification
{
    NSDictionary *netDic = notification.userInfo;
    AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)[netDic[AFNetworkingReachabilityNotificationStatusItem] intValue];
    _serverWorkStatus = status;
    
}

@end
