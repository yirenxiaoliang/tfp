//
//  FDActionSheet.m
//  FDActionSheetDemp
//
//  Created by fergusding on 15/5/28.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDActionSheet.h"

#define MARGIN_LEFT 10
#define MARGIN_RIGHT 10
#define SPACE_SMALL 10
#define TITLE_FONT_SIZE FONT(14)
#define BUTTON_FONT_SIZE FONT(16)
#define CANCEL_FONT_SIZE FONT(18)
#define BUTTON_HEIGHT 46

@interface FDActionSheet ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) NSMutableArray *buttonTitleArray;

@end

CGFloat contentViewWidth;
CGFloat contentViewHeight;

@implementation FDActionSheet

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            [_buttonTitleArray addObject:otherButtonTitles];
            while (1) {
                NSString *otherButtonTitle = va_arg(args, NSString *);
                if (otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.alpha = 0;
        _backgroundView.backgroundColor = RGBColor(0x00, 0x00, 0x00);
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_backgroundView];
        
        [self initContentView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle titles:(NSArray *)titles{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
//        va_list args;
//        va_start(args, otherButtonTitles);
//        if (otherButtonTitles) {
//            [_buttonTitleArray addObject:otherButtonTitles];
//            while (1) {
//                NSString *otherButtonTitle = va_arg(args, NSString *);
//                if (otherButtonTitle == nil) {
//                    break;
//                } else {
//                    [_buttonTitleArray addObject:otherButtonTitle];
//                }
//            }
//        }
//        va_end(args);
        
        [_buttonTitleArray addObjectsFromArray:titles];
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.alpha = 0;
        _backgroundView.backgroundColor = RGBColor(0x00, 0x00, 0x00);
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_backgroundView];
        
        [self initContentView];
    }
    return self;
}



- (void)initContentView {
//    contentViewWidth = 290 * self.frame.size.width / 320;
    contentViewWidth = SCREEN_WIDTH ;
    contentViewHeight = 0;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    
    _buttonView = [[UIView alloc] init];
    _buttonView.backgroundColor = [UIColor whiteColor];
    
    [self initTitle];
    [self initButtons];
    [self initCancelButton];
    
    _contentView.frame = CGRectMake((self.frame.size.width - contentViewWidth ) / 2, self.frame.size.height, contentViewWidth, contentViewHeight);
    [self addSubview:_contentView];
    
    
    _cancelButton.titleLabel.font = CANCEL_FONT_SIZE;
    [_cancelButton setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    
    for (NSInteger i = 0; i < _buttonArray.count; i ++) {
        
        UIButton *button = _buttonArray[i];
        
        [button setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        button.titleLabel.font = BUTTON_FONT_SIZE;
    }
    _contentView.backgroundColor = BackGroudColor;
}

- (void)initTitle {
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentViewWidth, BUTTON_HEIGHT)];
        _titleLabel.text = _title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = ExtraLightBlackTextColor;
        _titleLabel.font = TITLE_FONT_SIZE;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonView addSubview:_titleLabel];
        contentViewHeight += _titleLabel.frame.size.height;
    }
}

- (void)initButtons {
    if (_buttonTitleArray.count > 0) {
        NSInteger count = _buttonTitleArray.count;
        for (int i = 0; i < count; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewHeight, contentViewWidth, .5)];
            lineView.backgroundColor = HexAColor(0xe7e7e7, 1) ;
            [_buttonView addSubview:lineView];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, contentViewHeight + 1, contentViewWidth, 50)];
            button.frame = CGRectMake(0, contentViewHeight + 1, contentViewWidth, BUTTON_HEIGHT);
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = BUTTON_FONT_SIZE;
            [button setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            [_buttonView addSubview:button];
            contentViewHeight += lineView.frame.size.height + button.frame.size.height;
        }
        _buttonView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight);
//        _buttonView.layer.cornerRadius = 5.0;
//        _buttonView.layer.masksToBounds = YES;
        [_contentView addSubview:_buttonView];
    }
}

- (void)initCancelButton {
    if (_cancelButtonTitle != nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, contentViewHeight + SPACE_SMALL, contentViewWidth, BUTTON_HEIGHT);
//        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, contentViewHeight + SPACE_SMALL, contentViewWidth, 50)];
        _cancelButton.backgroundColor = RGBColor(0xff, 0xff, 0xff);
        _cancelButton.titleLabel.font = CANCEL_FONT_SIZE;
//        _cancelButton.layer.cornerRadius = 5.0;
        [_cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelButton];
        contentViewHeight += SPACE_SMALL + _cancelButton.frame.size.height;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self initContentView];
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    _cancelButtonTitle = cancelButtonTitle;
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:self];
    [self addAnimation];
}

- (void)hide {
    [self removeAnimation];
}

- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size {
    if (color != nil) {
        _titleLabel.textColor = color;
    }
    
    if (size > 0) {
        _titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

- (void)setButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(UIFont *)size atIndex:(NSInteger)index {
    UIButton *button = _buttonArray[index];
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (bgcolor != nil) {
        [button setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        button.titleLabel.font = size ;
    }
}

- (void)setCancelButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(UIFont *)size {
    if (color != nil) {
        [_cancelButton setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (bgcolor != nil) {
        [_cancelButton setBackgroundColor:bgcolor];
    }
    
    if (size > 0) {
        _cancelButton.titleLabel.font = size ;
    }
}

- (void)addAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height - _contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
        _backgroundView.alpha = 0.6;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAnimation {
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, self.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonPressed:(UIButton *)button {
    [self hide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonIndex:)]) {
        for (int i = 0; i < _buttonArray.count; i++) {
            if (button == _buttonArray[i]) {
                [_delegate actionSheet:self clickedButtonIndex:i];
                break;
            }
        }
    }
}

- (void)cancelButtonPressed:(UIButton *)button {
    [self hide];
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_delegate actionSheetCancel:self];
    }
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
}


@end
