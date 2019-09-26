//
//  HQTFLabelButton.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    LabelButtonTypeNormal,
    LabelButtonTypeSelect,
    LabelButtonTypeDelete,
    LabelButtonTypeColor
    
}LabelButtonType;


@protocol HQTFLabelButtonDelegate <NSObject>

@optional
-(void)labelButtonSelectIndex:(NSInteger)index withSelect:(BOOL)select block:(void(^)(BOOL selected))blcok;

@end

@interface HQTFLabelButton : UIView

/** delegate */
@property (nonatomic, weak) id<HQTFLabelButtonDelegate>delegate;

+ (instancetype)labelButton;

/** 应用场景 0:新增 1：删除 2:选择颜色*/
@property (nonatomic, assign) NSInteger scene;

@property (nonatomic, copy) NSString *text;

/** 是否选中 */
@property (nonatomic, assign) BOOL selected;


/** button类型 */
@property (nonatomic, assign) LabelButtonType type;

@end
