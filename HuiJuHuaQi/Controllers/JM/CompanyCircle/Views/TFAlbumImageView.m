//
//  TFAlbumImageView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAlbumImageView.h"


@interface TFAlbumImageView ()

/** images */
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation TFAlbumImageView

-(NSMutableArray *)images{
    
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}


-(void)refreshAlbumImageViewWithImages:(NSArray *)images{
    
    for (UIImageView *imageView in self.images) {
        [imageView removeFromSuperview];
    }
    [self.images removeAllObjects];
    
    NSInteger index = images.count;
    
    if (images.count > 4) {
        index = 4;
    }
    
    for (NSInteger i = 0; i < index; i ++) {
        TFFileModel *file = images[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[HQHelper URLWithString:file.file_url] placeholderImage:PlaceholderBackgroundImage];;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        [self.images addObject:imageView];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    for (NSInteger i = 0; i < self.images.count; i ++) {
        
        UIImageView *imageView  = self.images[i];
        
        if (self.images.count == 1) {
            
            imageView.frame = self.bounds;
        }else if (self.images.count == 2){
            
            imageView.frame = CGRectMake((self.width/2 - 1 + 2)*i, 0, self.width/2 - 1, self.height);
        }else if (self.images.count == 3){
            
            if (i == 0) {
                
                imageView.frame = CGRectMake(0, 0, self.width/2 - 1, self.height);
            }else if (i == 1){
                imageView.frame = CGRectMake((self.width/2 - 1 + 2), 0, self.width/2 - 1, self.height/2-1);
            }else{
                imageView.frame = CGRectMake((self.width/2 - 1 + 2), self.height/2+1, self.width/2 - 1, self.width/2 - 1);
            }
        }else{
            
            NSInteger row = i / 2;
            NSInteger col = i % 2;
            
            imageView.frame = CGRectMake((self.width/2 - 1 + 2)*col, (self.height/2+1)* row, self.width/2 - 1, self.width/2 - 1);
            
        }
    
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
