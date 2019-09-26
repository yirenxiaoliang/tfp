//
//  TFCustomCardView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomCardView.h"
#import "TFTwoBtnsView.h"
#import "TFFieldView.h"
#import "TFStyleModel.h"

@interface TFCustomCardView ()<TFTwoBtnsViewDelegate,TFFieldViewDelegate>

/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** styles */
@property (nonatomic, strong) NSMutableArray *styles;

/** styleModels */
@property (nonatomic, strong) NSMutableArray *styleModels;


/** fields */
@property (nonatomic, strong) NSMutableArray *fields;
@end


@implementation TFCustomCardView

-(NSMutableArray *)fields{
    if (!_fields) {
        _fields = [NSMutableArray array];
    }
    return _fields;
}

-(NSMutableArray *)styleModels{
    if (!_styleModels) {
        _styleModels = [NSMutableArray array];
    }
    return _styleModels;
}

-(NSMutableArray *)styles{
    if (!_styles) {
        _styles = [NSMutableArray array];
    }
    return _styles;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupChildView];
    }
    return self;
}

-(void)refreshCustomViewWithStyles:(NSArray *)arr choice:(NSInteger)choice hides:(NSArray *)hides{
    
    
    [self.styleModels removeAllObjects];
    if (arr.count == 0) {
        TFStyleModel *model = [[TFStyleModel alloc] init];
        model.id = @0;
        model.styleId = @0;
        TFStyleModel *model1 = [[TFStyleModel alloc] init];
        model1.id = @1;
        model1.styleId = @1;
        
        [self.styleModels addObject:model];
        [self.styleModels addObject:model1];
        [self.styleModels addObjectsFromArray:arr];
        
//        TFStyleModel *model2 = [[TFStyleModel alloc] init];
//        model2.id = @(-1);
//        model2.styleId = @(-1);
//        [self.styleModels addObject:model2];
    }else{
        [self.styleModels addObjectsFromArray:arr];
//        TFStyleModel *model2 = [[TFStyleModel alloc] init];
//        model2.id = @(-1);
//        model2.styleId = @(-1);
//        [self.styleModels addObject:model2];
    }
    if (choice < self.styleModels.count) {
        TFStyleModel *se = self.styleModels[choice];
        se.select = @1;
    }
    
    for (UIView *view in self.styles) {
        
        [view removeFromSuperview];
    }
    [self.styles removeAllObjects];
    
    CGFloat W = 100;
    CGFloat H = 60;
    CGFloat M = 15;
    CGFloat P = 10;
    
    for (NSInteger i = 0; i < self.styleModels.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollView addSubview:button];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = GrayTextColor.CGColor;
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.frame = CGRectMake(M + i * (W + P), 0, W, H);
        button.tag = i;
        [button addTarget:self action:@selector(styleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.styles addObject:button];
        
//        if (i == self.styleModels.count-1) {
//            [button setTitle:@"+" forState:UIControlStateNormal];
//            [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
//        }else{
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
//        }
        
        TFStyleModel *se = self.styleModels[i];
        if ([se.select isEqualToNumber:@1]) {
            button.selected = YES;
        }
        
        if ([se.id isEqualToNumber:@0]) {
            [button setBackgroundImage:IMG(@"style0") forState:UIControlStateNormal];
        }else if ([se.id isEqualToNumber:@1]){
            [button setBackgroundImage:IMG(@"style1") forState:UIControlStateNormal];
        }else if ([se.id isEqualToNumber:@(-1)]){
            // +
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }else{
            
        }
        
        if (button.selected) {
            button.layer.borderColor = GreenColor.CGColor;
        }else{
            button.layer.borderColor = GrayTextColor.CGColor;
        }
    }
    CGFloat scrollCon = 2 * M + (self.styleModels.count-1) * P + self.styleModels.count * W;
    self.scrollView.contentSize = CGSizeMake(scrollCon<self.width?self.width:scrollCon, H);
    
    for (TFFieldView *field in self.fields) {
        for (NSString *str in hides) {
            if ([str isEqualToString:[NSString stringWithFormat:@"%ld",field.tag]]) {
                field.selected = YES;
                break;
            }
        }
    }
}

- (void)styleClicked:(UIButton *)button{
    
//    if (button.tag == self.styles.count-1) {
//        if ([self.delegate respondsToSelector:@selector(customCardViewDidClickedAdd)]) {
//            [self.delegate customCardViewDidClickedAdd];
//        }
//        return;
//    }
    
    for (UIButton *btn in self.styles) {
        
        btn.layer.borderColor = GrayTextColor.CGColor;
        btn.selected = NO;
    }
    
    button.selected = !button.selected;
    
    if (button.selected) {
        button.layer.borderColor = GreenColor.CGColor;
    }else{
        button.layer.borderColor = GrayTextColor.CGColor;
    }
    
    if ([self.delegate respondsToSelector:@selector(customCardViewDidClickedStyleIndex:)]) {
        [self.delegate customCardViewDidClickedStyleIndex:button.tag];
    }
}

- (void)setupChildView{
    
    UILabel *styleLabel = [[UILabel alloc] initWithFrame:(CGRect){15,0,self.width-30,40}];
    styleLabel.font = FONT(14);
    styleLabel.textColor = BlackTextColor;
    styleLabel.text = @"模板样式";
    [self addSubview:styleLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(styleLabel.frame),self.width,60}];
    [self addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    
//    UIPageControl *page = [[UIPageControl alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(scrollView.frame),self.width,20}];
//    page.currentPageIndicatorTintColor = GreenColor;
//    page.pageIndicatorTintColor = GrayTextColor;
//    [self addSubview:page];
    
//    UIView *line = [[UIView alloc] initWithFrame:(CGRect){15,CGRectGetMaxY(scrollView.frame),self.width,.5}];
//    line.backgroundColor = CellSeparatorColor;
//    [self addSubview:line];
    
    
    UILabel *fieldLabel = [[UILabel alloc] initWithFrame:(CGRect){15,CGRectGetMaxY(scrollView.frame),self.width-30,40}];
    fieldLabel.font = FONT(14);
    fieldLabel.textColor = BlackTextColor;
    fieldLabel.text = @"隐藏字段";
    [self addSubview:fieldLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(fieldLabel.frame),self.width,0}];
    [self addSubview:view];
    
    NSInteger row = 4;
    CGFloat margin = 15;
    CGFloat fieldW = (SCREEN_WIDTH - (row+1) * margin) / row ;
    CGFloat fieldH = 30 ;
    NSInteger X = 0;
    NSInteger Y = 0;
    NSArray *fields = @[@"Logo",@"座机",@"手机",@"邮箱",@"地址"];
    [self.fields removeAllObjects];
    for (NSInteger i = 0; i < fields.count; i ++) {
        X = i % row;
        Y = i / row;
        
        TFFieldView *field = [TFFieldView fieldView];
        [view addSubview:field];
        field.frame = CGRectMake(margin + (fieldW + margin) * X, Y * (fieldH + margin), fieldW, fieldH);
        field.nameLabel.text = fields[i];
        field.tag = i;
        field.delegate = self;
        [self.fields addObject:field];
    }
    
    view.height = (fields.count + (row - 1))/row * (fieldH + margin);
    
    NSMutableArray<TFTwoBtnsModel> *arr = [NSMutableArray<TFTwoBtnsModel> array];
    for (NSInteger i = 0; i < 2; i ++) {
        
        TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
        model.font = FONT(18);
        
        if (0 == i){
            model.title = @"取消";
            model.color = GrayTextColor;
        }else if (1 == i){
            model.title = @"确定";
            model.color = GreenColor;
        }
        
        [arr addObject:model];
    }
    
    TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(view.frame),self.width,49} withTitles:arr];
    bottomView.delegate = self;
    [self addSubview:bottomView];
    
    self.backgroundColor = WhiteColor;
    self.layer.borderColor = LightGrayTextColor.CGColor;
    self.layer.borderWidth = 0.5;
}

#pragma mark - TFTwoBtnsViewDelegate
-(void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectIndex:(NSInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(customCardViewDidClickedBottomIndex:models:)]) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFStyleModel *mo in self.styleModels) {
            if ([mo.id isEqualToNumber:@(-1)]) {
                continue;
            }
            [arr addObject:mo];
        }
        
        [self.delegate customCardViewDidClickedBottomIndex:index models:arr];
    }
    
}
#pragma mark - TFFieldViewDelegate
-(void)fieldViewClicked:(TFFieldView *)fieldView{
    
    fieldView.selected = !fieldView.selected;
    
    NSString *str = @"";
    for (TFFieldView *f in self.fields) {
        if (f.selected) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",f.tag]];
        }
    }
    if (str.length) {
        str = [str substringToIndex:str.length-1];
    }
    
    if ([self.delegate respondsToSelector:@selector(customCardViewDidClickedHiddenIndex: hide:)]) {
        [self.delegate customCardViewDidClickedHiddenIndex:fieldView.tag hide:str];
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
