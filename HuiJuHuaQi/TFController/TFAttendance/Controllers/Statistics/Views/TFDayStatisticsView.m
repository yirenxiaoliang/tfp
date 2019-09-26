//
//  TFDayStatisticsView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFDayStatisticsView.h"
#import "TFColorItemView.h"
#import "TFStatisticsItemView.h"
#define Radius (80)

@interface TFDayStatisticsView ()<TFStatisticsItemViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLalel;

@property (nonatomic, strong) TFAttendanceStatisticsModel *model;

@property (nonatomic, strong) NSMutableArray *rates;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableArray *nums;

@property (nonatomic, strong) NSMutableArray *numItems;

@end

@implementation TFDayStatisticsView
-(NSMutableArray *)numItems{
    if (!_numItems) {
        _numItems = [NSMutableArray array];
    }
    return _numItems;
}

-(NSMutableArray *)rates{
    if (!_rates) {
        _rates = [NSMutableArray array];
    }
    return _rates;
}
-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
-(NSMutableArray *)nums{
    if (!_nums) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.descLabel.font = FONT(16);
    self.descLabel.textColor = ExtraLightBlackTextColor;
    self.numLalel.textColor = BlackTextColor;
    self.numLalel.font = BFONT(30);
    
    self.backgroundColor = WhiteColor;
}

+(instancetype)dayStatisticsView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFDayStatisticsView" owner:self options:nil] lastObject];
}

-(void)refreshViewWithStatasticsModel:(TFAttendanceStatisticsModel *)model{
    
    self.model = model;
    self.numLalel.text = [NSString stringWithFormat:@"%@",model.attendance_person_number];
    [self.rates removeAllObjects];
    for (UIView *itemView in self.items) {
        [itemView removeFromSuperview];
    }
    [self.items removeAllObjects];
    
    for (UIView *itemView in self.nums) {
        [itemView removeFromSuperview];
    }
    [self.nums removeAllObjects];
    [self.numItems removeAllObjects];
    
    NSInteger total = 0;
    for (NSInteger i = 1; i < model.dataList.count; i++) {
        TFStatisticsTypeModel *tyModel = model.dataList[i];
        total += [tyModel.number integerValue];
    }
    NSArray *colors = @[@(0x3895FE),@(0x3895FE),@(0x4f78d4),@(0xf05049),@(0x4db27f),@(0xfe8239),@(0x398BA0),@(0x6A56DD),@(0xba4ba8),@(0xDD56C6),@(0xDD56C6),@(0xDD56C6),@(0xDD56C6),@(0xDD56C6),@(0xDD56C6)];
    for (NSInteger i = 0; i < model.dataList.count; i++) {
        TFStatisticsTypeModel *tyModel = model.dataList[i];
        if (total != 0 && i != 0) {
            CGFloat rate = ([tyModel.number integerValue] * 1.0) / (total * 1.0);// 比例
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(rate * 2 * M_PI) forKey:@"value"];// 转换成弧度
            [dict setObject:colors[i] forKey:@"color"];
            [self.rates addObject:dict];
        }
        
        if (i != 0) {
            NSInteger row = (i-1) / 3;
            NSInteger col = (i-1) % 3;
            TFColorItemView *item = [TFColorItemView colorItemView];
            [self addSubview:item];
            [self.items addObject:item];
            item.frame = CGRectMake(col * (SCREEN_WIDTH/3), 2 * Radius + 30 + 30 * row, (SCREEN_WIDTH/3), 30);
            item.colorImage.image = [HQHelper createImageWithColor:HexColor([colors[i] integerValue])];
            item.nameLabel.text = tyModel.name;
        }
        
        if ([tyModel.type integerValue] != 9) {
            [self.numItems addObject:tyModel];
        }
    }
    
    for (NSInteger i = 0 ; i < self.numItems.count; i ++) {
        TFStatisticsTypeModel *tyModel = self.numItems[i];
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        TFStatisticsItemView *item = [TFStatisticsItemView statisticsItemView];
        [self addSubview:item];
        item.frame = CGRectMake(col * ((SCREEN_WIDTH+1)/3 - 0.5), 180 + (self.items.count + 2) / 3 * 30 + 10 + 20 + row * (90 - 0.5), ((SCREEN_WIDTH+1)/3), 90);
        [self.nums addObject:item];
        item.nameLabel.text = tyModel.name;
        item.numLabel.text = [NSString stringWithFormat:@"%ld",[tyModel.number integerValue]];
        item.delegate = self;
        item.tag = i;
    }
    
    [self setNeedsDisplay];
}

#pragma mark - TFStatisticsItemViewDelegate
-(void)statisticsItemViewClicked:(TFStatisticsItemView *)view{
    if ([self.delegate respondsToSelector:@selector(dayStatisticsViewDidClickedWithIndex:)]) {
        [self.delegate dayStatisticsViewDidClickedWithIndex:view.tag];
    }
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();//当前画笔
    
    CGContextSetLineWidth(context, 18);//线的宽度
    
    CGContextSetRGBStrokeColor(context, 0xd8/255.0, 0xd8/255.0, 0xd8/255.0, 1.0);//画笔线的颜色
    
    CGContextAddArc(context, self.width/2, Radius + 10, Radius, - M_PI_2, 2 * M_PI - M_PI_2 , 0); //添加一个圆
    
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    CGFloat total = 0.0;// 用于累积画了多少
    for (NSInteger i = 0; i < self.rates.count; i++) {
        
        NSDictionary *dict = self.rates[i];
        NSNumber *rate = [dict valueForKey:@"value"];
        NSNumber *color = [dict valueForKey:@"color"];
        
        CGFloat red = 0.0;
        CGFloat green = 0.0;
        CGFloat blue = 0.0;
        CGFloat alpha = 0.0;
        [HexColor([color integerValue]) getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0);//画笔线的颜色
        CGContextAddArc(context, self.width/2, Radius + 10, Radius, - M_PI_2 + total, [rate floatValue] + total - M_PI_2 , 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
        
        total += [rate floatValue];// 画一次累积
    }
    
    
}



@end
