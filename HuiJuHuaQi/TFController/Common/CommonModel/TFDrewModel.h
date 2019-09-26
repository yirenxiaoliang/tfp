//
//  TFDrewModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    
    DrewTypeNormal, // 正常
    DrewTypeLeft, // 左边
    DrewTypeMiddle, // 中间
    DrewTypeRight // 右边
    
}DrewType;

@interface TFDrewModel : NSObject

/** 矩形数组 */
@property (nonatomic, assign) CGRect rect;

/** 类型 */
@property (nonatomic, assign) DrewType type;



@end
