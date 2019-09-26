//
//  TFNoteCollectionViewCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteCollectionViewCell.h"

@implementation TFNoteCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 4.0;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderColor = CellSeparatorColor.CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowColor = LightGrayTextColor.CGColor;
    self.bgView.layer.shadowRadius = 5;
    self.bgView.layer.shadowOpacity = 0.7;
    
    self.picImgView.layer.cornerRadius = 4.0;
    self.picImgView.layer.masksToBounds = YES;
    self.picImgView.layer.borderColor = CellSeparatorColor.CGColor;
    self.picImgView.layer.borderWidth = 0.5;
    
    self.picImgView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
