//
//  HQTFSearchHeader.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SearchHeaderTypeNormal,
    SearchHeaderTypeMove,
    SearchHeaderTypeTwoBtn,
    SearchHeaderTypeSearch
}SearchHeaderType;

@protocol HQTFSearchHeaderDelegate <NSObject>

@optional
- (void)searchHeaderClicked;
- (void)searchHeaderCancelClicked;
- (void)searchHeaderTextChange:(UITextField *)textField;

- (void)searchHeaderleftBtnClicked;
- (void)searchHeaderRightBtnClicked;

@end

@interface HQTFSearchHeader : UIView
+ (instancetype)searchHeader;
/** type */
@property (nonatomic, assign) SearchHeaderType type;

/** UIImageView *image */
@property (nonatomic, weak) UIImageView *image;
/** textField */
@property (nonatomic, weak) UITextField *textField;
/** rightBtn */
@property (nonatomic, weak) UIButton *rightBtn;
/** rightBtn */
@property (nonatomic, weak) UIButton *leftBtn;

/** UIButton *button */
@property (nonatomic, weak) UIButton *button;
/** delegate */
@property (nonatomic, weak) id<HQTFSearchHeaderDelegate> delegate;
@end
