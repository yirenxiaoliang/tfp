//
//  TFCompanyCircleHeader.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCircleEmployModel.h"

typedef enum {
    CompanyCircleHeaderTypeNormal,
    CompanyCircleHeaderTypeNoDescription
}CompanyCircleHeaderType;


@protocol TFCompanyCircleHeaderDelegate <NSObject>

@optional
- (void)companyCircleHeaderDidClickedBackground;
- (void)companyCircleHeaderDidClickedHeadWithEmployee:(TFCircleEmployModel *)employee;

@end

@interface TFCompanyCircleHeader : UIView

/** 创建header */
+ (instancetype)companyCircleHeader;

/** headerType */
@property (nonatomic, assign) CompanyCircleHeaderType headerType;

/** delegate */
@property (nonatomic, weak) id<TFCompanyCircleHeaderDelegate> delegate;

/** employee */
@property (nonatomic, strong) TFCircleEmployModel *employee;

/** employee */
@property (nonatomic, strong) UIImage *image;


@end
