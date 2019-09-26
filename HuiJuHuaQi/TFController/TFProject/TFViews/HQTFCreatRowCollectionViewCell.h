//
//  HQTFCreatRowCollectionViewCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQAdviceTextView.h"

@class HQTFCreatRowCollectionViewCell;
@protocol HQTFCreatRowCollectionViewCellDelegate <NSObject>

@optional
-(void)creatRowCollectionViewCell:(HQTFCreatRowCollectionViewCell *)cell didSureBtnWithText:(NSString *)text;

-(void)creatRowCollectionViewCell:(HQTFCreatRowCollectionViewCell *)cell didCreateBtn:(UIButton *)createBtn withBlock:(void (^)(BOOL open))block;

@end

@interface HQTFCreatRowCollectionViewCell : UICollectionViewCell

- (void)cancelBtnClick:(UIButton *)button;

@property (weak, nonatomic) IBOutlet HQAdviceTextView *textView;

/** ProjectSeeBoardType */
@property (nonatomic, assign) ProjectSeeBoardType type;

/** delegate */
@property (nonatomic, weak) id<HQTFCreatRowCollectionViewCellDelegate>delegate;

@end
