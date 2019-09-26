//
//  HQSelectPhotoView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSelectPhotoView.h"
#import "UIButton+WebCache.h"


@interface HQSelectPhotoView ()

@property (nonatomic, assign) float intervalFloat;

@property (nonatomic, assign) float highFloat;

@property (nonatomic, assign) NSInteger nowNum;

/** imageViews */
@property (nonatomic, strong) NSMutableArray *imageViews;



//@property (nonatomic, strong) NSMutableArray *imgArr;

@end


@implementation HQSelectPhotoView

-(NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

/**
 *  初始化
 *
 *  @param frame
 *  @param maxNum     最大图片数
 *  @param lineMaxNum 一行最大图片
 *  @param imgArr     本地图片数组
 *  @param urlArr     网络图片链接数组
 *  @param delegate
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
                       maxNum:(NSInteger)maxNum
                   lineMaxNum:(NSInteger)lineMaxNum
                       imgArr:(NSArray *)imgArr
                       urlArr:(NSArray *)urlArr
                     delegate:(id<HQSelectPhotoViewDelegate>)delegate
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _maxNum = maxNum;
        
        _lineMaxNum = lineMaxNum;
        
        _delegate = delegate;
        
        [self refreshSelectPhotoViewWithImgArr:imgArr
                                        urlArr:urlArr];
    }
    
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame
                       maxNum:(NSInteger)maxNum
                       imgArr:(NSArray *)imgArr
                       urlArr:(NSArray *)urlArr
                     delegate:(id<HQSelectPhotoViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
       
        _maxNum = maxNum;
        
        _delegate = delegate;
        
        [self refreshSelectPhotoViewWithImgArr:imgArr
                                        urlArr:urlArr];
    }
    
    return self;
}



/**
 *  刷新选择视图
 *
 *  @param imgArr            图片数组
 *  @param urlArr            图片URL数组
 *  @param editeOrLookAtSate 编辑还是查看，NO为编辑
 */
- (void)refreshSelectPhotoViewWithImgArr:(NSArray *)imgArr
                                  urlArr:(NSArray *)urlArr
                       editeOrLookAtSate:(BOOL)editeOrLookAtSate
{

    if (editeOrLookAtSate == YES) {
        
        _maxNum = imgArr.count;
    }
    
    
    if (_lineMaxNum <= 0) {
        _lineMaxNum = 4;
    }
    
    
//    self.backgroundColor = [UIColor orangeColor];
    
    for (id view in [self subviews]) {
        [view removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    NSInteger totalNum = imgArr.count + urlArr.count;
    
    CGFloat margin = 15;
    CGFloat imageX = margin;
    CGFloat imageY = margin;
    CGFloat imageW = (SCREEN_WIDTH - (_lineMaxNum + 1) * margin)/ _lineMaxNum;
    CGFloat imageH = imageW;
    
    if (totalNum == 0  &&  editeOrLookAtSate == NO) {
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.contentMode = UIViewContentModeScaleAspectFit;
        addBtn.frame = CGRectMake(imageX , imageY, imageW, imageH);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
//        [addBtn setImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
    }
    
    
    else {
        
        
        for (int i=0; i<totalNum; i++) {
            
//            UIButton *lookAtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImageView *lookAtBtn = [[UIImageView alloc] init];
            lookAtBtn.contentMode = UIViewContentModeScaleToFill;
//            lookAtBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageViews addObject:lookAtBtn];
            CGFloat imageX = margin + (i % _lineMaxNum) *(imageW+margin);
            CGFloat imageY = margin + (i / _lineMaxNum) *(imageW+margin);
            
            lookAtBtn.frame = CGRectMake(imageX, imageY, imageW, imageH);
            lookAtBtn.tag = 200 + i;
            
            if (i < urlArr.count) {
                NSString *urlStr = [NSString stringWithFormat:@"/%@", urlArr[i]];
//                [lookAtBtn sd_setImageWithURL:[HQHelper URLWithString:urlStr]
//                                     forState:UIControlStateNormal
//                             placeholderImage:[UIImage imageNamed:@"picture_loading"]];
                [lookAtBtn sd_setImageWithURL:[HQHelper URLWithString:urlStr]
                             placeholderImage:[UIImage imageNamed:@"picture_loading"]];
                
            }else {
//                [lookAtBtn setImage:imgArr[i-urlArr.count] forState:UIControlStateNormal];
                [lookAtBtn setImage:imgArr[i-urlArr.count]];
                
                
            }
            
            
            
            
//            [lookAtBtn addTarget:self action:@selector(lookAtPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
            
            lookAtBtn.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookAtPhotoAction:)];
            [lookAtBtn addGestureRecognizer:tap];
            
            [self addSubview:lookAtBtn];
            
            
            if (editeOrLookAtSate == NO) {
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(imageX+imageW - 25, imageY , 25, 25);
                deleteBtn.tag = 100 + i;
                [deleteBtn setImage:[UIImage imageNamed:@"减circle"] forState:UIControlStateNormal];
                [deleteBtn addTarget:self action:@selector(deletePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:deleteBtn];
            }

        }
        
        if (_maxNum > totalNum) {
            
            CGFloat imageX = margin + (totalNum % _lineMaxNum) *(imageW+margin);
            CGFloat imageY = margin + (totalNum / _lineMaxNum) *(imageW+margin);
            HQLog(@"%f,%f", imageX, imageY);
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.contentMode = UIViewContentModeScaleAspectFit;
            addBtn.frame = CGRectMake(imageX, imageY, imageW, imageH);
//            [addBtn setImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:addBtn];
            
        }
    }
    self.size = CGSizeMake(SCREEN_WIDTH,margin + (imageW + margin) * (imgArr.count+1+(_lineMaxNum - 1))/_lineMaxNum );
}



/**
 *  刷新选择视图
 *
 *  @param imgArr 图片数组
 *  @param urlArr 图片URL数组
 */
- (void)refreshSelectPhotoViewWithImgArr:(NSArray *)imgArr
                                  urlArr:(NSArray *)urlArr
{
    
    [self refreshSelectPhotoViewWithImgArr:imgArr
                                    urlArr:urlArr
                         editeOrLookAtSate:NO];
}


- (void)addPhotoAction
{
    if ([self.delegate respondsToSelector:@selector(addPhotoAction)]) {
        
        [self.delegate addPhotoAction];
    }
}


- (void)deletePhotoAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(deletePhotoActionWithIndex:)]) {
        
        [self.delegate deletePhotoActionWithIndex:button.tag - 100];
    }
}


- (void)lookAtPhotoAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(lookAtPhotoActionWithIndex:)]) {
        
        [self.delegate lookAtPhotoActionWithIndex:tap.view.tag - 200];
    }
    
    if ([self.delegate respondsToSelector:@selector(lookAtPhotoActionWithIndex:imageViews:)]) {
        
        [self.delegate lookAtPhotoActionWithIndex:tap.view.tag - 200 imageViews:self.imageViews];
    }
    
    
}



@end
