//
//  EmotionView.m
//  ChatTest
//
//  Created by Season on 2017/5/15.
//  Copyright © 2017年 Season. All rights reserved.
//

#import "EmotionView.h"
#import "EmotionCollectionLayout.h"
@implementation EmotionView
{
    NSArray *dataArray;
    UIButton *currentBtn;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
     
        self.frame = CGRectMake(0, 0,SCREEN_WIDTH, 170);
        self.backgroundColor = BGCOLOR;
        // 获取表情
        dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoNames" ofType:@"plist"]];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    //水平布局
//    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //设置每个表情按钮的大小为30*30
    layout.itemSize=CGSizeMake(SCREEN_WIDTH/7.0, 30);
//    //计算每个分区的左右边距
//    float xOffset = (KSCREENWIDTH-7*30-10*6)/2;
//    //设置分区的内容偏移
//    layout.sectionInset=UIEdgeInsetsMake(10, xOffset, 10, xOffset);
//    layout.rowCount = 3.0;
//    layout.itemCountPerRow = 7.0;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 160) collectionViewLayout:layout];
    //打开分页效果
    collectionView.pagingEnabled = YES;
    
    //设置行列间距
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing=0;

    collectionView.delegate=self;
    collectionView.dataSource=self;

    collectionView.backgroundColor = self.backgroundColor;
    [self addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"emotion"];
    
    UIView *toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-40, self.width, 40)];
    toolBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:toolBar];
    
    UIButton *emotion1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, toolBar.height+10, toolBar.height)];
    [emotion1 setImage:[UIImage imageNamed:@"se_se"] forState:UIControlStateNormal];
    [emotion1 addTarget:self action:@selector(chooseEmotionType:) forControlEvents:UIControlEventTouchUpInside];
    emotion1.backgroundColor = BGCOLOR;
    [toolBar addSubview:emotion1];
    currentBtn = emotion1;
    
    // 发送按钮
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 100, 0, 100, 40)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    [toolBar addSubview:sendBtn];
    
}


/**
 表情选中类型 可能会有多组表情攻供选择
 
 @param sender 
 */
- (void)chooseEmotionType:(UIButton *)sender {
    
    sender.backgroundColor = BGCOLOR;
    currentBtn.backgroundColor = [UIColor whiteColor];
    currentBtn = sender;
}

/**
 发送
 */
- (void)sendAction {
    
    if (_emotionBlock) {
        
        _emotionBlock(nil);
        
    }
}

// 多页处理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (((dataArray.count/28)+(dataArray.count%28==0?0:1))!=section+1) {
        return 28;
    }else{
        return dataArray.count-28*((dataArray.count/28)+(dataArray.count%28==0?0:1)-1);
    }
    
}
//返回页数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (dataArray.count/28)+(dataArray.count%28==0?0:1);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emotion" forIndexPath:indexPath];
    for (NSUInteger i=cell.contentView.subviews.count; i>0; i--) {
        [cell.contentView.subviews[i-1] removeFromSuperview];
    }
    UIImageView * emotion = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/7.0-30)/2.0, 0, 30, 30)];
    emotion.image = [UIImage imageNamed:dataArray[indexPath.item]];
    [cell.contentView addSubview:emotion];
    
    // 删除按钮
    if (indexPath.item % 20 == 0 && indexPath.item != 0) {
        
        emotion.height = 20;
        emotion.y = 5;
    }
    return cell;
}

// 选中表情，回调
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_emotionBlock) {
        
        _emotionBlock(dataArray[indexPath.item]);
        
    }
}

@end
