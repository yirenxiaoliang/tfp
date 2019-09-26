//
//  TFCustomDetailItemView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFCustomDetailItemView : UIButton

+(instancetype)customDetailItemView;


/** nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;
/** numLabel */
@property (nonatomic, weak) UILabel *numLabel;

/** type */
@property (nonatomic, assign) NSInteger type;



@end
