//
//  TFKnowledgeSearchView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeSearchView.h"
#import "TFKnowledgeSearchItem.h"


@interface TFKnowledgeSearchView ()

@property (nonatomic, strong) NSMutableArray *items;


@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *moreLabel;

@property (nonatomic, assign) BOOL more;

@end

@implementation TFKnowledgeSearchView

-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        titleLabel.textColor = GrayTextColor;
        titleLabel.font = FONT(14);
        titleLabel.text = @"猜你想搜的";
        
        UILabel *moreLabel = [[UILabel alloc] init];
        [self addSubview:moreLabel];
        self.moreLabel = moreLabel;
        moreLabel.textColor = GrayTextColor;
        moreLabel.font = FONT(14);
        moreLabel.text = @"查看更多";
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreClicked)];
        [moreLabel addGestureRecognizer:tap];
        moreLabel.userInteractionEnabled = YES;
        
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(void)moreClicked{
    
    self.more = YES;
    [self layoutSubviews];
}

-(void)refreshKnowledgeSearchViewWithCategorys:(NSArray *)categorys{
    
    for (TFKnowledgeSearchItem *item in self.items) {
        [item removeFromSuperview];
    }
    [self.items removeAllObjects];
    
    for (NSInteger i = 0; i < categorys.count; i++) {
        
        TFKnowledgeSearchItem *item = [TFKnowledgeSearchItem knowledgeSearchItem];
        [self addSubview:item];
        [self.items addObject:item];
        
    }
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(15 + 8, 10, SCREEN_WIDTH-30, 44);
    
    CGFloat XS = 15;
    CGFloat YS = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat W = (SCREEN_WIDTH-30)/2;
    CGFloat H = 38;
    
    
    for (NSInteger i = 0; i < self.items.count; i++) {
        
        NSInteger row = i / 2;
        NSInteger col = i % 2;
        TFKnowledgeSearchItem *item = self.items[i];
        
        if (i < 10) {
            item.frame = CGRectMake(XS + col * W - col * 0.5, YS + row * H - row * 0.5, W, H);
            item.hidden = NO;
        }else{
            
            if (self.more) {
                
                item.frame = CGRectMake(XS + col * W - col * 0.5, YS + row * H - row * 0.5, W, H);
                item.hidden = NO;
            }else{
                TFKnowledgeSearchItem *item9 = self.items[9];
                
                item.frame = CGRectMake(XS + col * W - col * 0.5, CGRectGetMaxY(item9.frame), W, 0);
                item.hidden = YES;
            }
        }
        
        if (col == 0) {
            item.leftLine.hidden = YES;
            item.nameHeadM.constant = 8;
        }else{
            item.rightLine.hidden = YES;
            item.nameHeadM.constant = 18;
        }
    }
    
    TFKnowledgeSearchItem *item = self.items.lastObject;
    
    if (self.more) {
        
        self.moreLabel.frame = CGRectMake(15 + 8, CGRectGetMaxY(item.frame), SCREEN_WIDTH-30, 0);
        self.moreLabel.hidden = YES;
        
        self.height = CGRectGetMaxY(self.moreLabel.frame) + 20;
        
    }else{
        
        if (self.items.count > 10) {
            self.moreLabel.frame = CGRectMake(15 + 8, CGRectGetMaxY(item.frame), SCREEN_WIDTH-30, 44);
            self.moreLabel.hidden = NO;
            self.height = CGRectGetMaxY(self.moreLabel.frame);
        }else{
            
            self.moreLabel.frame = CGRectMake(15 + 8, CGRectGetMaxY(item.frame), SCREEN_WIDTH-30, 0);
            self.moreLabel.hidden = YES;
            self.height = CGRectGetMaxY(self.moreLabel.frame) + 20;
        }
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(knowledgeSearchViewWithHeight:)]) {
        [self.delegate knowledgeSearchViewWithHeight:CGRectGetMaxY(self.moreLabel.frame) + 20];
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
