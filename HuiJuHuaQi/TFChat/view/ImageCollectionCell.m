//
//  ImageCollectionCell.m
//  ChatTest
//
//  Created by Season on 2017/5/19.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "ImageCollectionCell.h"

@implementation ImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self photo];
        [self selectedBtn];
        
    }
    return self;
}

- (UIImageView *)photo {
    
    if (_photo == nil) {
        
        _photo = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_photo];
    }
    return _photo;
}

- (UIButton *)selectedBtn {
    

    if (_selectedBtn == nil) {
        
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBtn.frame = CGRectMake(5, 5, 25, 25);
        _selectedBtn.hidden = YES;
        [_selectedBtn setImage:[UIImage imageNamed:@"photo_check_selected"] forState:UIControlStateNormal];
        [self.contentView addSubview:_selectedBtn];
    }
    return _selectedBtn;
}


/**
 设置图片和选中状态
 
 @param asset 图片信息
 @param isSelected 是否选中
 */
- (void)setImage:(PHAsset *)asset IsSelected:(BOOL)isSelected{
    
    
    if (isSelected) {
        
        _selectedBtn.hidden = NO;
    }
    else {
        
        _selectedBtn.hidden = YES;
    }
    
    // 获取图片
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    // 获取类型为缩略图
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    __weak typeof(self) weakSelf = self;
    

    // 获取目标尺寸的缩略图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        weakSelf.photo.image = result;
    }];
    
    
}
@end
