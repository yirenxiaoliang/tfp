//
//  HQClickStartView.h
//  HuiJuHuaQi
//
//  Created by hq001 on 16/4/26.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HQEmployModel.h"

@protocol HQClickStartViewDeleagte <NSObject>
@optional
-(void)senderEmployIdToCell:(HQEmployModel *)employ;

@end


@interface HQClickStartView : UIView

@property (nonatomic , strong)NSArray *employees;

@property (nonatomic , copy) NSString *titleName;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic,weak) id <HQClickStartViewDeleagte> delegate;


+ (CGFloat)getCopyerViewHeightWithTitleFont:(UIFont *)titleFont
                                   titleStr:(NSString *)titleStr
                                  employees:(NSArray *)employees
                                  selfWidth:(CGFloat)selfWidth;

@end
