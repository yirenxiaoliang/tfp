//
//  XWCountryCodeController.h
//  XWCountryCodeDemo
//
//  Created by daidan on 2020/10/22.
//  Copyright © 2020 com.huijuhuaqi.com. All rights reserved.
//
//  国家代码选择界面

#import <UIKit/UIKit.h>
#import "HQBaseViewController.h"

typedef void(^returnCountryCodeBlock) (NSString *countryName, NSString *code);

@protocol XWCountryCodeControllerDelegate <NSObject>

@optional

/**
 Delegate 回调所选国家代码

 @param countryName 所选国家
 @param code 所选国家代码
 */
-(void)returnCountryName:(NSString *)countryName code:(NSString *)code;

@end


@interface XWCountryCodeController : HQBaseViewController

@property (nonatomic, weak) id<XWCountryCodeControllerDelegate> deleagete;

@property (nonatomic, copy) returnCountryCodeBlock returnCountryCodeBlock;

@end
