//
//  FileCell.m
//  ChatTest
//
//  Created by 肖胜 on 2017/5/20.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "MessageFileCell.h"

@implementation MessageFileCell{
    ChatFileType fileType;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kUIColorFromRGB(0xF2F2F2);
        
        [self boxImage];
        
        [self photo];
        
        [self sizeLabel];
        
        [self headImage];
        
        [self nameLabel];
        
        [self progressView];
    }
    
    return self;
}

// 气泡框
- (UIImageView *)boxImage {
    
    if (_boxImage == nil) {
        
        UIImage *image = [UIImage imageNamed:@"box_white"];
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:15 topCapHeight:image.size.height *0.5];
        _boxImage = [[UIImageView alloc]initWithImage:newImage];
        _boxImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviewAction)];
        [_boxImage addGestureRecognizer:tap];
        [self.contentView addSubview:_boxImage];
    }
    return _boxImage;
}

// 图片
- (UIImageView *)photo {
    
    if (_photo == nil) {
        
        
        _photo = [[UIImageView alloc]init];
        _photo.layer.cornerRadius = 2;
        _photo.clipsToBounds = YES;
        [_boxImage addSubview:_photo];

    }
    
    return _photo;
}

// 文件大小
- (UILabel *)sizeLabel {
    
    if (_sizeLabel == nil) {
        
        _sizeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _sizeLabel.font = [UIFont systemFontOfSize:13];
        _sizeLabel.textColor = [UIColor lightGrayColor];
        [_boxImage addSubview:_sizeLabel];

    }
    
    return _sizeLabel;
}

// 头像
- (UIImageView *)headImage {
    
    if (_headImage == nil) {
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 15, 30, 30)];
        _headImage.image = [UIImage imageNamed:@"se_se"];
        [self.contentView addSubview:_headImage];
    }
    return _headImage;
}

// 文件名
- (UILabel *)nameLabel {
    
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [_boxImage addSubview:_nameLabel];
    }
    
    return _nameLabel;
}

// 进度条
- (UIProgressView *)progressView {
    
    if (_progressView == nil) {
        
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectZero];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.progress = 0;
        _progressView.hidden = YES;
        [_boxImage addSubview:_progressView];
    }
    return _progressView;
}


/**
 查看详情
 */
- (void)reviewAction {
    
    if (_fileReviewBlock) {
        
        _fileReviewBlock(fileType, _photo.image);
    }
}


- (void)fillWithContent:(NSDictionary *)content Type:(ChatFileType)type {
    
    fileType = type;
    _boxImage.frame = CGRectMake(SCREEN_WIDTH-[_size[@"width"] floatValue]-60, 20, [_size[@"width"] floatValue]+20, self.contentView.height-20);
    _photo.frame = CGRectMake(15, 15, _boxImage.height-30, _boxImage.height-30);
    _nameLabel.frame = CGRectMake(_photo.right + 10, _photo.top, _boxImage.width - _photo.width - 40, 20);
    _sizeLabel.frame = CGRectMake(_nameLabel.left, _photo.bottom - 15, _nameLabel.width, 15);
    
    NSDictionary *info = content[@"content"];
    // 未传输完
    if (info[@"progress"]) {
        
        _sizeLabel.text = [NSString stringWithFormat:@"%@           正在发送",info[@"size"]];
        _progressView.hidden = NO;
        _progressView.frame = CGRectMake(_photo.left, _photo.bottom + 6, _boxImage.width - 40, 10);
        [NSTimer scheduledTimerWithTimeInterval:.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
           
            [_progressView setProgress:_progressView.progress + 0.1 animated:YES];
            
            // 传输完成：隐藏进度条，更改发送状态
            if (_progressView.progress == 1) {
                
                _progressView.hidden = YES;
                _sizeLabel.text = [NSString stringWithFormat:@"%@           已发送",info[@"size"]];
                [timer invalidate];
                timer = nil;
            }
        }];
    }
    else {
        _progressView.hidden = YES;
        _sizeLabel.text = [NSString stringWithFormat:@"%@           已发送",info[@"size"]];
    }
    _photo.image = [UIImage imageWithData:info[@"image"]];
    if (fileType == FileTypeVideo) {
        
        _photo.image = [UIImage imageWithData:info[@"thumbnail"]];
    }
    _nameLabel.text = info[@"name"];
    
    
    
}

@end
