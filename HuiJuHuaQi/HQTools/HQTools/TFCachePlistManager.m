//
//  TFCachePlistManager.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCachePlistManager.h"
#import "FileManager.h"

#define ComponentPath [NSString stringWithFormat:@"/%@-%@-%@",[AppDelegate shareAppDelegate].urlEnvironment,[UM.userLoginInfo.company.id description],[UM.userLoginInfo.employee.id description]]
#define CacheDirectoryPath [[FileManager dirCache] stringByAppendingPathComponent:@"HomeDataCache"]

@interface TFCachePlistManager ()

/** fileManager */
@property (nonatomic, strong) FileManager *fileManager;


@end


@implementation TFCachePlistManager

static TFCachePlistManager *_sharedManager = nil;

/** 单例 */
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TFCachePlistManager alloc] init];
        _sharedManager.fileManager = [FileManager shared];
    });
    return _sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
    });
    return _sharedManager;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return _sharedManager;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone{
    return _sharedManager;
}

/** 存放工作台数据
 *
 *  @prama datas 某列的数据列表
 *  @prama type 某列的序号
 */
+(void)saveWorkBenchDataWithDatas:(NSArray *)datas type:(NSInteger)type{
    
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-workBench%ld.plist",ComponentPath,type]];
    // 写入文件
    // 发现datas为复杂的字典，写入失败
    NSMutableArray *strs = [NSMutableArray array];
    for (NSDictionary *dict in datas) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (str) {
            [strs addObject:str];
        }
    }
    
    BOOL success = [strs writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
}

/** 取出工作台数据
 *
 *  @prama datas 某列的数据列表
 *  @prama type 某列的序号
 */
+(NSArray *)getWorkBenchDataWithType:(NSInteger)type{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-workBench%ld.plist",ComponentPath,type]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:NSJSONReadingMutableContainers
                                                   error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}

/** 存放同事圈数据
 *
 *  @prama datas 数据列表
 */
+(void)saveCircleDataWithDatas:(NSArray *)datas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-circle.plist",ComponentPath]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
}

/** 获取同事圈的数据 */
+(NSArray *)getCircleDatas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-circle.plist",ComponentPath]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}

/** 存放邮件数据
 *
 *  @prama datas 某列的数据列表
 *  @prama type 某列的序号
 */
+(void)saveEmailDataWithDatas:(NSArray *)datas type:(NSInteger)type{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-email%ld.plist",ComponentPath,type]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
}

/** 获取邮件某列表的数据
 *
 *  @prama datas 某列的数据列表
 *  @prama type 某列的序号
 */
+(NSArray *)getEmailDataWithType:(NSInteger)type{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-email%ld.plist",ComponentPath,type]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    return result;
}


/** 保存文件库根目录
 *
 *  @prama datas 数据列表
 */
+(void)saveFileMenuDataWithDatas:(NSArray *)datas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-fileMenu.plist",ComponentPath]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
    
}

/** 获取文件库的数据 */
+(NSArray *)getFileMenuDatas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-fileMenu.plist",ComponentPath]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}


/** 文件库目录缓存 */
+(void)saveFileLevelWithStyle:(NSInteger)style levelId:(NSNumber *)levelId datas:(NSArray *)datas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-fileRoot%ld%lld.plist",ComponentPath,style,[levelId longLongValue]]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
    
    
}

/** 获取文件库目录数据 */
+(NSArray *)getFileLevelWithStyle:(NSInteger)style levelId:(NSNumber *)levelId{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-fileRoot%ld%lld.plist",ComponentPath,style,[levelId longLongValue]]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}


/** 缓存项目列表数据 */
+(void)saveProjectListDataWithType:(NSInteger)type datas:(NSArray *)datas{
   
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-project%ld.plist",ComponentPath,type]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
}

/** 获取项目列表的数据 */
+(NSArray *)getProjectListDataWithType:(NSInteger)type{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-project%ld.plist",ComponentPath,type]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}



/** 缓存任务列表数据 */
+(void)saveTaskListDataWithType:(NSInteger)type datas:(NSArray *)datas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-task%ld.plist",ComponentPath,type]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
}

/** 获取任务列表的数据 */
+(NSArray *)getTaskListDataWithType:(NSInteger)type{
    
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-task%ld.plist",ComponentPath,type]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}

/** 缓存常用模块列表 */
+(void)saveOftenModuleListWithDatas:(NSArray *)datas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-often.plist",ComponentPath]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
}

/** 获取常用模块列表数据 */
+(NSArray *)getOftenModuleList{
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-often.plist",ComponentPath]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}

/** 缓存应用模块列表 */
+(void)saveApplicationModuleListWithDatas:(NSArray *)datas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-application.plist",ComponentPath]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
}

/** 获取常用模块列表数据 */
+(NSArray *)getApplicationModuleList{
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-application.plist",ComponentPath]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}

/** 缓存系统模块列表 */
+(void)saveSystemModuleListWithDatas:(NSArray *)datas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-system.plist",ComponentPath]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
}

/** 获取系统模块列表数据 */
+(NSArray *)getSystemModuleList{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-system.plist",ComponentPath]];
    
    // 读取
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    NSMutableArray *dicts = [NSMutableArray array];
    
    for (NSString *str in result) {
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if (dict) {
            [dicts addObject:dict];
        }
    }
    
    return dicts;
}



/** 缓存工作台模块列表 */
+(void)saveBenchModuleListWithDatas:(NSArray *)datas{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-benchModule.plist",ComponentPath]];
    
    // 写入文件
    BOOL success = [datas writeToFile:cache atomically:YES];
    if (success) {
        HQLog(@"写入数据成功！%@",cache);
    }else{
        HQLog(@"写入数据失败！%@",cache);
    }
    
    
}

/** 获取工作台模块列表数据 */
+(NSArray *)getBenchModuleList{
    
    NSString *cache = [CacheDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-benchModule.plist",ComponentPath]];
    
    // 读取(此处存的就是数组放的字典)
    NSArray *result = [NSArray arrayWithContentsOfFile:cache];
    
    return result;
    
}























@end
