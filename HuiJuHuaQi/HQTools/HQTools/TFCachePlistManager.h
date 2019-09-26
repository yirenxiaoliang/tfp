//
//  TFCachePlistManager.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFCachePlistManager : NSObject

/** 单例 */
+(TFCachePlistManager *)sharedManager;

/** 存放工作台数据
 *
 *  @prama datas 某列的数据列表
 *  @prama type 某列的序号
 */
+(void)saveWorkBenchDataWithDatas:(NSArray *)datas type:(NSInteger)type;

/** 取出工作台数据
 *
 *  @prama datas 某列的数据列表
 *  @prama type 某列的序号
 */
+(NSArray *)getWorkBenchDataWithType:(NSInteger)type;

/** 存放同事圈数据
 *
 *  @prama datas 数据列表
 */
+(void)saveCircleDataWithDatas:(NSArray *)datas;

/** 获取同事圈的数据 */
+(NSArray *)getCircleDatas;


/** 存放邮件数据
 *
 *  @prama datas 某列的数据列表
 *  @prama type 某列的序号
 */
+(void)saveEmailDataWithDatas:(NSArray *)datas type:(NSInteger)type;

/** 获取邮件某列表的数据
 *
 *  @prama datas 某列的数据列表
 *  @prama type 某列的序号
 */
+(NSArray *)getEmailDataWithType:(NSInteger)type;

/** 保存文件库菜单目录
 *
 *  @prama datas 数据列表
 */
+(void)saveFileMenuDataWithDatas:(NSArray *)datas;

/** 获取文件库菜单目录数据 */
+(NSArray *)getFileMenuDatas;

/** 文件库目录缓存 */
+(void)saveFileLevelWithStyle:(NSInteger)style levelId:(NSNumber *)leveId datas:(NSArray *)datas;

/** 获取文件库目录数据 */
+(NSArray *)getFileLevelWithStyle:(NSInteger)style levelId:(NSNumber *)leveId;

/** 缓存项目列表数据 */
+(void)saveProjectListDataWithType:(NSInteger)type datas:(NSArray *)datas;

/** 获取项目列表的数据 */
+(NSArray *)getProjectListDataWithType:(NSInteger)type;

/** 缓存任务列表数据 */
+(void)saveTaskListDataWithType:(NSInteger)type datas:(NSArray *)datas;

/** 获取任务列表的数据 */
+(NSArray *)getTaskListDataWithType:(NSInteger)type;

/** 缓存常用模块列表 */
+(void)saveOftenModuleListWithDatas:(NSArray *)datas;

/** 获取常用模块列表数据 */
+(NSArray *)getOftenModuleList;

/** 缓存应用模块列表 */
+(void)saveApplicationModuleListWithDatas:(NSArray *)datas;

/** 获取常用模块列表数据 */
+(NSArray *)getApplicationModuleList;

/** 缓存系统模块列表 */
+(void)saveSystemModuleListWithDatas:(NSArray *)datas;

/** 获取系统模块列表数据 */
+(NSArray *)getSystemModuleList;


/** 缓存工作台模块列表 */
+(void)saveBenchModuleListWithDatas:(NSArray *)datas;

/** 获取工作台模块列表数据 */
+(NSArray *)getBenchModuleList;

@end
