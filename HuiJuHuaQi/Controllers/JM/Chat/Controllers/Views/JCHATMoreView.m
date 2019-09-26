//
//  JPIMMore.m
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATMoreView.h"
//#import "JChatConstants.h"
#import "HQRootButton.h"

@interface JCHATMoreView ()

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;


@end

@implementation JCHATMoreView
-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setChildView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setChildView];
}


- (void)setChildView{
    
    self.backgroundColor = HexAColor(0xf2f2f2, 1);
    
    for (HQRootButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    
    for (NSInteger i = 0; i < 4; i ++) {
        
        HQRootButton *button = [HQRootButton rootButton];
        
        button.backgroundColor = HexAColor(0xf2f2f2, 1);
        button.tipLable.hidden = YES;
        [self addSubview:button];
        button.tag = 0x123 + i;
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            
            [button setImage:[UIImage imageNamed:@"相册"] forState:UIControlStateNormal];
            [button setTitle:@"相册" forState:UIControlStateNormal];
        }else if ( i == 1){
            
            [button setImage:[UIImage imageNamed:@"拍照"] forState:UIControlStateNormal];
            [button setTitle:@"拍照" forState:UIControlStateNormal];
        }else if ( i == 2){
            
            [button setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
            [button setTitle:@"定位" forState:UIControlStateNormal];
        }else{
            
            [button setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
            [button setTitle:@"电话" forState:UIControlStateNormal];
        }
        [self.buttons addObject:button];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSInteger i = 0; i < self.buttons.count; i ++) {
        
        HQRootButton *button = self.buttons[i];
        
        button.frame = CGRectMake(SCREEN_WIDTH/4 * i, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        button.centerY = self.height/2;
        
        if (self.type == MoreViewTypeGroupChat) {
            
            if (i == 3) {
                button.hidden = YES;
            }
        }
        
        if (self.type == MoreViewTypeCommentChat) {
            if (i == 2 || i == 3) {
                button.hidden = YES;
            }
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
- (void)drawRect:(CGRect)rect {
  
}

- (void)btnClicked:(UIButton *)button{
    
    switch (button.tag - 0x123) {
        case 0:
            if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
                [self.delegate photoClick];
            }
            break;
        case 1:
            if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraClick)]) {
                [self.delegate cameraClick];
            }
            break;
        case 2:
            if (self.delegate &&[self.delegate respondsToSelector:@selector(locationClick)]) {
                [self.delegate locationClick];
            }
            break;
        case 3:
            if (self.delegate &&[self.delegate respondsToSelector:@selector(telephoneClick)]) {
                [self.delegate telephoneClick];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)photoBtnClick:(id)sender {
  
  if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
    [self.delegate photoClick];
  }
}
- (IBAction)cameraBtnClick:(id)sender {
  if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraClick)]) {
    [self.delegate cameraClick];
  }
}


@end


@implementation JCHATMoreViewContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _moreView = NIB(JCHATMoreView);
        
        _moreView.frame =CGRectMake(0, 0, 320, 227);
        
        
        //  [_toolbar drawRect:_toolbar.frame];
        
        //  _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_moreView];
    }
    return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  _moreView = NIB(JCHATMoreView);
  
  _moreView.frame =CGRectMake(0, 0, SCREEN_WIDTH, 227);
  
  
  //  [_toolbar drawRect:_toolbar.frame];
  
  //  _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:_moreView];
}


@end

