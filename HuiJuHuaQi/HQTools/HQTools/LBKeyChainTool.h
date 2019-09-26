//
//  LBKeyChainTool.h
//  KeyChainDemo
//
//  Created by XieLB on 16/5/31.
//  Copyright © 2016年 XLB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBKeyChainTool : NSObject


+ (NSString *)getUUIDStr;

+ (void)saveAction:(NSString *)service data:(id)data;

+ (id)loadAction:(NSString *)service;

+ (void)deleteAction:(NSString *)service;



@end
