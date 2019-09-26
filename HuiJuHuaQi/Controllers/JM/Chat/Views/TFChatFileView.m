//
//  TFChatFileView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatFileView.h"

@interface TFChatFileView ()
/** UIImageView *imageView */
@property (nonatomic, weak) UIImageView *imageView;
/** UILabel *nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;
/** UILabel *sescLabel */
@property (nonatomic, weak) UILabel *sizeLabel;
@end

@implementation TFChatFileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChildView];
    }
    return self;
}
- (void)setupChildView{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
//    imageView.image = [UIImage imageNamed:@"微信"];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@15);
        make.left.equalTo(@22);
        make.height.equalTo(@80);
        make.width.equalTo(@80);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = BlackTextColor;
    nameLabel.font = FONT(16);
    [self addSubview:nameLabel];
    nameLabel.numberOfLines = 0;
//    nameLabel.text = @"我是一个假的文件名字.pdf";
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@12);
        make.left.equalTo(imageView.mas_right).with.offset(12);
        make.right.equalTo(self.mas_right).with.offset(-12);
        make.height.equalTo(@40);
    }];
    
    UILabel *sescLabel = [[UILabel alloc] init];
    sescLabel.textColor = ExtraLightBlackTextColor;
    sescLabel.font = FONT(14);
    [self addSubview:sescLabel];
//    sescLabel.text = @"18.30MB";
    self.sizeLabel = sescLabel;
    [sescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(imageView.mas_bottom);
        make.left.equalTo(imageView.mas_right).with.offset(12);
        make.right.equalTo(self.mas_right).with.offset(-12);
        make.height.equalTo(@20);
    }];
}
/** 刷新FileView */
-(void)refreshFileViewWithFileName:(NSString *)fileName fileSize:(NSInteger)fileSize isReceive:(BOOL)isReceive{
    
    NSArray *arr = [fileName componentsSeparatedByString:@"."];
    NSString *fileType = arr.lastObject;
    TFFileModel *model = [[TFFileModel alloc] init];
    model.file_type = fileType;
//    [self.imageView setImage:[HQHelper fileTypeWithFileModel:model]];
    [self.imageView setImage:[HQHelper createImageWithColor:RedColor]];
    self.nameLabel.text = fileName;
    self.sizeLabel.text = [HQHelper fileSizeWithInterge:fileSize];
    
    if (isReceive) {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@22);
        }];
        
    }else{
        
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
        }];
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
