//
//  TFSliderCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSliderCell.h"

@interface TFSliderItem ()

/** 宽度 ：无需赋值，根据name动态计算 */
@property (nonatomic, assign, readwrite) CGFloat width;

@end

@implementation TFSliderItem

@end

@interface TFSliderCell()<UIScrollViewDelegate>


/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

/** buttons */
@property (nonatomic, strong) NSArray<TFSliderItem *> *items;
/** confirm */
@property (nonatomic, assign) BOOL confirm;
/** direction NO：左 YES：右 */
@property (nonatomic, assign) BOOL direction;
@property (nonatomic,assign,readwrite) BOOL isSlider;

@end


@implementation TFSliderCell

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.bounces = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        scrollView.backgroundColor = WhiteColor;
        self.scrollView = scrollView;
        scrollView.backgroundColor = GreenColor;
        scrollView.delegate = self;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:bgView];
        self.bgView = bgView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
        [scrollView addGestureRecognizer:tap];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.bounces = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        scrollView.backgroundColor = WhiteColor;
        self.scrollView = scrollView;
        scrollView.backgroundColor = GreenColor;
        scrollView.delegate = self;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:bgView];
        self.bgView = bgView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
        [scrollView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapClicked{
    
    if (self.scrollView.contentOffset.x > 0 ) {
        self.isSlider = NO;
        [self hiddenItem];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(sliderCellSelectedIndexPath:)]) {
        [self.delegate sliderCellSelectedIndexPath:self.indexPath];
    }
}

/** 刷新左滑Items */
- (void)refreshSliderCellItemsWithItems:(NSArray <TFSliderItem *>*)items{
    
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    
    self.items = items;
    for (NSInteger i = 0; i < items.count; i ++) {
        TFSliderItem *item = items[i];
        UIButton *btn = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(btnClicked:)];
        btn.tag = 0x123 + i;
        [self.scrollView addSubview:btn];
        [self.buttons addObject:btn];
        
        CGSize size = [HQHelper sizeWithFont:FONT(17) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:item.name];
        item.width = size.width + 30;
        if (item.confirm == 1 && items.count == 1) {
            item.width += 40;
        }
        [btn setTitle:item.name forState:UIControlStateNormal];
        [btn setTitle:item.name forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[HQHelper createImageWithColor:item.bgColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[HQHelper createImageWithColor:item.bgColor] forState:UIControlStateHighlighted];
    }
    
}

- (void)btnClicked:(UIButton *)button{
    
    NSInteger tag = button.tag - 0x123;
    
    TFSliderItem *item = self.items[tag];
    
    if (item.confirm == 1) {
        self.confirm = YES;
        item.confirm = 2;
        item.width = self.scrollView.contentSize.width - SCREEN_WIDTH;
        item.name = [NSString stringWithFormat:@"确认%@",item.name];
        [button setTitle:item.name forState:UIControlStateNormal];
        [button setTitle:item.name forState:UIControlStateHighlighted];
        [UIView animateWithDuration:0.25 animations:^{
            button.x = SCREEN_WIDTH;
            button.width = item.width;
            
        }];
        
    }else{
        
        if ([self.delegate respondsToSelector:@selector(sliderCellDidClickedIndex:)]) {
            [self.delegate sliderCellDidClickedIndex:tag];
        }
        
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        
        for (NSInteger i = 0;i < self.items.count;i ++) {
            TFSliderItem *item = self.items[i];
            
            if (item.confirm == 2) {
                item.confirm = 1;
                if (item.name.length > 2) {
                    item.name = [item.name substringFromIndex:2];
                }
            }
            
            
            CGSize size = [HQHelper sizeWithFont:FONT(17) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:item.name];
            item.width = size.width + 30;
            if (item.confirm == 1 && self.items.count == 1) {
                item.width += 40;
            }
            UIButton *button = self.buttons[i];
            [button setTitle:item.name forState:UIControlStateNormal];
            [button setTitle:item.name forState:UIControlStateHighlighted];
            button.width = item.width;
            
            self.isSlider = NO;
            self.confirm = NO;
        }
        
    }else{
        
        
        if (self.confirm){
            
            if (scrollView.contentOffset.x > scrollView.contentSize.width - SCREEN_WIDTH) {
                
                CGFloat mar = (scrollView.contentOffset.x - (scrollView.contentSize.width - SCREEN_WIDTH));
                for (NSInteger i = 0;i < self.items.count;i ++) {
                    TFSliderItem *item = self.items[i];
                    UIButton *button = self.buttons[i];
                    button.width = item.width + mar;
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, mar);
                }
                
            }
            
            return;
        }
        
        self.isSlider = YES;
        CGFloat width = 0.0;
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:[NSNumber numberWithFloat:width]];
        for (NSInteger i = 0;i < self.items.count-1;i ++) {
            TFSliderItem *item = self.items[i];
            width += item.width;
            [arr addObject:[NSNumber numberWithFloat:width]];
        }
        
        for (NSInteger i = 0;i < arr.count;i ++) {
            NSNumber *num = arr[i];
            UIButton *button = self.buttons[i];
            
            CGFloat position = ([num floatValue]/(scrollView.contentSize.width-scrollView.width)) * scrollView.contentOffset.x;
            button.x = SCREEN_WIDTH + position;
        }
        
        if (scrollView.contentOffset.x > scrollView.contentSize.width - SCREEN_WIDTH) {
            
            CGFloat mar = (scrollView.contentOffset.x - (scrollView.contentSize.width - SCREEN_WIDTH));
            for (NSInteger i = 0;i < self.items.count;i ++) {
                TFSliderItem *item = self.items[i];
                UIButton *button = self.buttons[i];
                button.width = item.width + mar;
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, mar);
            }
            
        }else{
            
            for (NSInteger i = 0;i < self.items.count;i ++) {
                TFSliderItem *item = self.items[i];
                UIButton *button = self.buttons[i];
                button.width = item.width;
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([self.delegate respondsToSelector:@selector(sliderCellWillScrollIndexPath:)]) {
        
        [self.delegate sliderCellWillScrollIndexPath:self.indexPath];
    }
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (velocity.x == 0) {
        
        if (scrollView.contentOffset.x > (scrollView.contentSize.width-SCREEN_WIDTH)/2) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width-SCREEN_WIDTH, 0) animated:YES];
        }else{
    
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    
    if (targetContentOffset->x > (scrollView.contentSize.width-SCREEN_WIDTH)/2) {
        targetContentOffset->x = (scrollView.contentSize.width-SCREEN_WIDTH);
    }else{
        targetContentOffset->x = 0;
    }
    
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//    HQLog(@"%s",__func__);
//    if (scrollView.contentOffset.x > (scrollView.contentSize.width-SCREEN_WIDTH)/2) {
//        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width-SCREEN_WIDTH, 0) animated:YES];
//    }else{
//
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
//}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
//    HQLog(@"%s",__func__);
//    if (scrollView.contentOffset.x > (scrollView.contentSize.width-SCREEN_WIDTH)/2) {
//        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width-SCREEN_WIDTH, 0) animated:YES];
//    }else{
//
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }
//}

- (void)hiddenItem{
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

+ (instancetype)sliderCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFSliderCell";
    TFSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    self.bgView.frame = CGRectMake(0, 0, self.width, self.height);
    
    HQLog(@"%@======",NSStringFromCGRect(self.bgView.frame));
    
    CGFloat width = 0;
    for (NSInteger i = 0; i < self.items.count; i++) {
        TFSliderItem *it = self.items[i];
        width += it.width;
        UIButton *button = self.buttons[i];
        button.frame = CGRectMake(SCREEN_WIDTH, 0, it.width, self.scrollView.height);
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH + width, self.scrollView.height);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
