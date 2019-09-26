//
//  TFChatCustomView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/7/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatCustomView.h"

@interface TFChatCustomView ()
/** UIImageView *imageView */
@property (nonatomic, weak) UIImageView *imageView;
/** UILabel *nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;

/** UILabel *createLabel */
@property (nonatomic, weak) UILabel *createLabel;
/** UILabel *timeLabel */
@property (nonatomic, weak) UILabel *timeLabel;
@end

@implementation TFChatCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChildView];
    }
    return self;
}
- (void)setupChildView{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
//    imageView.image = [UIImage imageNamed:@"微信"];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(@10);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = LightBlackTextColor;
    nameLabel.font = FONT(14);
    [self addSubview:nameLabel];
    nameLabel.numberOfLines = 0;
//    nameLabel.text = @"我是一个假的名字";
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(imageView.mas_top).with.offset(-10);
//        make.left.equalTo(imageView.mas_right).with.offset(10);
//        make.right.equalTo(self.mas_right).with.offset(-12);
//        make.height.equalTo(@40);
        
        
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(-12);
        make.height.equalTo(@50);
    }];
    
    UILabel *createLabel = [[UILabel alloc] init];
    createLabel.backgroundColor = CellSeparatorColor;
    [self addSubview:createLabel];
    self.createLabel = createLabel;
    [createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@0.5);
    }];
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = LightTextColor;
    timeLabel.font = FONT(12);
    [self addSubview:timeLabel];
    timeLabel.numberOfLines = 1;
    //    nameLabel.text = @"我是一个假的名字";
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(createLabel.mas_bottom).with.offset(9);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(-12);
        make.height.equalTo(@20);
    }];
}

-(void)refreshCustomViewWithModel:(TFChatCustomModel *)model isReceive:(BOOL)isReceive{
    /** 类型 1110：任务，1111：文件库；1112：随手记，1113：审批，1114：日程，1115：公告，1116：投诉建议，1117：工作汇报，1118：订单，1119：考勤，1120：投票 */
    if ([model.type isEqualToNumber:@1110]) {
        self.imageView.image = [UIImage imageNamed:@"项目"];
    }else if ([model.type isEqualToNumber:@1112]){
        self.imageView.image = [UIImage imageNamed:@"随手记"];
    }else if ([model.type isEqualToNumber:@1113]){
        self.imageView.image = [UIImage imageNamed:@"审批"];
    }else if ([model.type isEqualToNumber:@1114]){
        self.imageView.image = [UIImage imageNamed:@"日程"];
    }else if ([model.type isEqualToNumber:@1115]){
        self.imageView.image = [UIImage imageNamed:@"公告"];
    }else if ([model.type isEqualToNumber:@1116]){
        self.imageView.image = [UIImage imageNamed:@"建议"];
    }else if ([model.type isEqualToNumber:@1117]){
        self.imageView.image = [UIImage imageNamed:@"工作汇报"];
    }else if ([model.type isEqualToNumber:@1118]){
        self.imageView.image = [UIImage imageNamed:@"订单"];
    }else if ([model.type isEqualToNumber:@1119]){
        self.imageView.image = [UIImage imageNamed:@"考勤"];
    }else if ([model.type isEqualToNumber:@1119]){
        self.imageView.image = [UIImage imageNamed:@"投票"];
    }
    
    self.nameLabel.text = model.title;
//    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"创建人:%@",model.creator.employeeName],[HQHelper nsdateToTime:[model.createTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"创建人:%@",model.employeeName],[HQHelper nsdateToTime:[model.createTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"]];
    
    if (isReceive) {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@20);
        }];
    }else{
        
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
        }];
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
