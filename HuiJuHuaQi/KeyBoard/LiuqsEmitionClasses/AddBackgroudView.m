//
//  AddBackgroudView.m
//  LiuqsEmoticonkeyboard
//
//  Created by HQ-20 on 2017/12/14.
//  Copyright © 2017年 刘全水. All rights reserved.
//

#import "AddBackgroudView.h"
#import "AddItemButton.h"

@interface AddBackgroudView ()

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation AddBackgroudView


-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithType:(NSInteger)type{
    if (self = [super init]) {
        
        self.backgroundColor = ColorRGB(0xf2, 0xf2, 0xf2);
        
        if (type == 0) {
            
            [self setupFile0];
            
        }else if (type == 1){
            
            [self setupFile1];
        }else if (type == 2){
            
            [self setupFile2];
        }else if (type == 3){
            
            [self setupFile3];
        }
        
    }
    return self;
}

- (void)setupFile3{
    
    NSArray *title = @[@"拍照上传",@"手机相册",@"视频",@"文件库选",@"@成员"];
    NSArray *image = @[@"拍照",@"相册",@"视频",@"文件库more",@"@人"];
    
    
    CGFloat buttonW = screenW/4;
    CGFloat buttonH = buttonW + 10;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        AddItemButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.75;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.frame = CGRectMake(0, 0 ,buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


- (void)setupFile0{
    
    NSArray *title = @[@"拍照上传",@"手机相册",@"视频",@"文件库选"];
    NSArray *image = @[@"拍照",@"相册",@"视频",@"文件库more"];
    
    
    CGFloat buttonW = screenW/4;
    CGFloat buttonH = buttonW + 10;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        AddItemButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.75;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.frame = CGRectMake(0, 0 ,buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)setupFile1{
    
    NSArray *title = @[@"拍照上传",@"手机相册",@"文件库选",@"@成员"];
    NSArray *image = @[@"拍照",@"相册",@"文件库more",@"@人"];
    
    
    CGFloat buttonW = screenW/4;
    CGFloat buttonH = buttonW + 10;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        AddItemButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.75;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.frame = CGRectMake(0, 0 ,buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)setupFile2{
    
    NSArray *title = @[@"拍照上传",@"手机相册",@"视频"];
    NSArray *image = @[@"拍照",@"相册",@"视频"];
    
    
    CGFloat buttonW = screenW/3;
    CGFloat buttonH = buttonW + 10;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        AddItemButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.75;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.frame = CGRectMake(0, 0 ,buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (void)moreButtonClick:(UIButton *)button{
    
    if ([self.delegate1 respondsToSelector:@selector(addBackgroudView:didSelectIndex:)]) {
        [self.delegate1 addBackgroudView:self didSelectIndex:button.tag - 0x135];
    }
}

/** 私有化-创建按钮 */
- (AddItemButton *)rootButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    AddItemButton *button = [AddItemButton rootButton];
    button.userInteractionEnabled = YES;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    return button;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat buttonW = screenW/4;
    CGFloat buttonH = buttonW + 10;
    
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        
        NSInteger row = i / 4;
        NSInteger col = i % 4;
        
        UIButton *button = self.buttons[i];
        button.frame = CGRectMake(col * buttonW , row * buttonH + 10, buttonW, buttonH);
        
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
