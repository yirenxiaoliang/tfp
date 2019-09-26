//
//  TFBarcodeShareView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/9.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFBarcodeShareViewDelegate <NSObject>

@optional
-(void)barcodeShareViewShareWithBarcode:(NSString *)barcode;

@end

@interface TFBarcodeShareView : UIView

/** 二维码string */
@property (nonatomic, copy) NSString *barcode;

/** title */
@property (nonatomic, copy) NSString *title;


@property (nonatomic, weak) id <TFBarcodeShareViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
