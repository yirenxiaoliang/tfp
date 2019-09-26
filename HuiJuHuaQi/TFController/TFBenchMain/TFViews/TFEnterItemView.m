//
//  TFEnterItemView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterItemView.h"
#define Height 64

@interface TFEnterItemView ()<TFWorkNumButtonDelegate>


@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation TFEnterItemView

- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)setItems:(NSArray *)items{
    _items = items;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    
    [self setupChildWithItems:items];
    
}

-(void)setupChildWithItems:(NSArray *)items{
    
    NSInteger column = 0;
    if (items.count < 4) {
        column = items.count;
    }else{
        column = 4;
    }
    CGFloat height = Height;
    CGFloat width = self.width / column;
    NSInteger lineIndex = 0;
    for (NSInteger i = 0; i < items.count; i ++) {
        NSInteger row = i / column;
        NSInteger col = i % column;
        TFWorkNumButton *button = [TFWorkNumButton workNumButton];
        button.tag = i;
        button.delegate = self;
        [self addSubview:button];
        button.frame = CGRectMake(col * width, row * height + 5, width, height);
        button.info = items[i];
        [self.buttons addObject:button];
        if (row > lineIndex) {
            UIView *line = [[UIView alloc] initWithFrame:(CGRect){15,row*height,self.width-30,0.5}];
            line.backgroundColor = HexColor(0xdae0e7);
            [self addSubview:line];
            lineIndex = row;
//            [self.buttons addObject:line];
        }
    }
}

#pragma mark - TFWorkNumButtonDelegate
-(void)workNumButtonDidClicked:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(enterItemViewDidClickedIndex:)]) {
        [self.delegate enterItemViewDidClickedIndex:index];
    }
    
}

-(void)refreshNums:(NSArray *)nums{
    
    for (TFWorkNumButton *button in self.buttons) {
        button.number = 0;
    }
    
    for (NSInteger i = 0; i < nums.count; i ++) {
        if (i < self.buttons.count) {
            TFWorkNumButton *button = self.buttons[i];
            HQLog(@"I'm number of %@",nums[i]);
            NSInteger nnnn = [nums[i] integerValue];
            button.number = nnnn;
        }
    }
    
}

/** 高度 */
+(CGFloat)enterItemViewHeightWithItems:(NSArray *)items{
    
    CGFloat height = 0 ;
    
    NSInteger column = 0;
    if (items.count < 4) {
        column = items.count;
    }else{
        column = 4;
    }
    NSInteger row = (items.count+(column-1)) / column;
    
    height += row * Height;
    
    return height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
