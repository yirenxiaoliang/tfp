//
//  TFCustomDetailScrollView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomDetailScrollView.h"
#import "TFCustomDetailItemView.h"
#import "TFModuleModel.h"
#import "TFRelevanceTradeModel.h"

#define MaxL 130

@interface TFCustomDetailScrollView ()

/** itemViews */
@property (nonatomic, strong) NSMutableArray *itemViews;


/** items */
@property (nonatomic, strong) NSArray *items;


@end



@implementation TFCustomDetailScrollView

-(NSMutableArray *)itemViews{
    if (!_itemViews) {
        _itemViews = [NSMutableArray array];
    }
    return _itemViews;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.layer.masksToBounds = NO;
    }
    return self;
}

-(void)refreshScrollViewWithItems:(NSArray *)items type:(NSInteger)type{
    
    for (TFCustomDetailItemView *view in self.itemViews) {
        [view removeFromSuperview];
    }
    [self.line removeFromSuperview];
    [self.itemViews removeAllObjects];
    self.items = items;
    
//    CGFloat width = 75;
    CGFloat height = 40;
    
//    self.contentSize = CGSizeMake(items.count * width < SCREEN_WIDTH
//                                  ? SCREEN_WIDTH : items.count * width, height);
    CGFloat width = 0;
    for (NSInteger i = 0; i < items.count; i ++) {
        
        TFRelevanceTradeModel *model = items[i];
        CGFloat wordW = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:model.moduleLabel?:model.chinese_name].width + 20;
        
        width += (wordW > MaxL ? MaxL : wordW);
        CGFloat X = width - (wordW > MaxL ? MaxL : wordW);
        
        TFCustomDetailItemView *view = [TFCustomDetailItemView customDetailItemView];
        view.type = type;
        view.frame = CGRectMake(X+10, 0, wordW > MaxL ? MaxL : wordW, height);
        view.nameLabel.text = [NSString stringWithFormat:@"%@",model.moduleLabel?:model.chinese_name];
        view.numLabel.text = [NSString stringWithFormat:@"%ld",[model.totalRows integerValue]];
        [self addSubview:view];
        view.tag = i;
        [view addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemViews addObject:view];
        
    }
    
        self.contentSize = CGSizeMake( width+10 < SCREEN_WIDTH
                                      ? SCREEN_WIDTH : width+10, height);
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,39.5,SCREEN_WIDTH,.5}];
    [self addSubview:line];
    line.backgroundColor = BackGroudColor;
//    line.layer.shadowOffset = CGSizeMake(0, 4);
//    line.layer.shadowColor = BackGroudColor.CGColor;
//    line.layer.shadowRadius = 2;
//    line.layer.shadowOpacity = 0.5;
    line.hidden = YES;
    self.line = line;
}

-(void)btnClicked:(TFCustomDetailItemView *)view{
    
    if ([self.delegate1 respondsToSelector:@selector(customDetailScrollViewDidClickedWithModel:)]) {
        [self.delegate1 customDetailScrollViewDidClickedWithModel:self.items[view.tag]];
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
