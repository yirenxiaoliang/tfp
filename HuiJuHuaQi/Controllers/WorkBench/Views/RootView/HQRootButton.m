//
//  HQRootButton.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/17.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQRootButton.h"

#define INDEX 0.6
@interface HQRootButton ()




@end

@implementation HQRootButton

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
    self.titleLabel.font = FONT(12);
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    
    self.tipLable.textAlignment = NSTextAlignmentCenter;
    self.tipLable.font = FONT(16);
    self.tipLable.textColor = WhiteColor;
    self.tipLable.backgroundColor = ClearColor;
    self.scale = 0.6;
    self.wordScale = 0.6;
    
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
//    [self addGestureRecognizer:longPress];
}

//- (void)longPress{
//    
////    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
//    self.backgroundColor = GrayTextColor;
//}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    
//}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint lastPoint = [touch previousLocationInView:self];// 上个点
//    CGPoint currentPoint = [touch locationInView:self];// 当前点
//    
//    self.origin = CGPointMake(self.x - lastPoint.x + currentPoint.x, self.y - lastPoint.y + currentPoint.y);
//}

- (void)setRootModel:(HQRootModel *)rootModel{
    
    _rootModel = rootModel;
    
    [self setImage:[UIImage imageNamed:rootModel.image] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:rootModel.image] forState:UIControlStateHighlighted];
    [self setTitle:rootModel.name forState:UIControlStateNormal];
    [self setTitle:rootModel.name forState:UIControlStateHighlighted];
    [self setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [self setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    
    
    switch (rootModel.functionModelType) {
            
        case FunctionModelTypeTask:
        {
            /** 任务数量优先，然后逾期数量，两者全没有就隐藏 */
            // 任务中心
            if (rootModel.markNum) {
                self.tipLable.hidden = NO;
                
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+", 99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld", rootModel.markNum];
                }
                
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字宽度
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
            }else{
                if (rootModel.OutDate) {// 逾期数量
                    self.tipLable.text = @"逾";
                    self.tipLable.hidden = NO;
                    
                    self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                    self.tipLable.layer.masksToBounds = YES;
                    // 计算提醒数字宽度
                    self.tipWidth.constant = 20;
                    
                }else{
                    self.tipLable.hidden = YES;
                }
            }
            
        }
            break;
            
        case FunctionModelTypeApproval:
        {
            // 审批中心
            if (rootModel.markNum) {
                
                self.tipLable.hidden = NO;
                
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+", 99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld", rootModel.markNum];
                }
                
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
                
            }else{
                self.tipLable.hidden = YES;
            }
            

        }
            break;
            
        case FunctionModelTypeSchedule:
        {
            // 日程中心
            if (rootModel.markNum) {
                self.tipLable.hidden = NO;
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+", 99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld",rootModel.markNum];
                }
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
                
            }else{
                self.tipLable.hidden = YES;
            }

            
        }
            break;
        case FunctionModelTypeReport:
        {
            // 工作报告
            if (rootModel.markNum) {
                self.tipLable.hidden = NO;
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+",99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld", rootModel.markNum];
                }
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
            }else{
                self.tipLable.hidden = YES;
            }

        }
            break;
            
        case FunctionModelTypeAdvice:
        {
            // 投诉建议
            if (rootModel.markNum) {
                self.tipLable.hidden = NO;
                if (rootModel.markNum >99) {
                    self.tipLable.text = [NSString stringWithFormat:@"%d+",99];
                }else{
                    self.tipLable.text = [NSString stringWithFormat:@"%ld", rootModel.markNum];
                }
                self.tipLable.layer.cornerRadius = self.tipLable.height * 0.5;
                self.tipLable.layer.masksToBounds = YES;
                
                // 计算提醒数字
                if (self.tipLable.text.length == 3) {
                    self.tipWidth.constant = 30;
                }else if (self.tipLable.text.length == 2 ) {
                    self.tipWidth.constant = 25;
                }else{
                    self.tipWidth.constant = 20;
                }
                
            }else{
                self.tipLable.hidden = YES;
            }
            
        }
            break;
            
        case FunctionModelTypeSubscribe:
        {
            // 考勤中心
            self.tipLable.hidden = YES;
        }
            break;
            
        case FunctionModelTypeDocument:
        {
            // 收藏夹
            self.tipLable.hidden = YES;
        }
            break;
            
        case FunctionModelTypePrejectPartner:
        {
            // 项目协同
            self.tipLable.hidden = YES;
        }
            break;
            
        case FunctionModelTypePersonnel:
        {
            // 人事
            self.tipLable.hidden = YES;
        }
            break;
            
        case FunctionModelTypeNote:
        {
            // 随手记
            self.tipLable.hidden = YES;
        }
            break;
            
        case FunctionModelTypeFile:
        {
            // 文件库
            self.tipLable.hidden = YES;
        }
            break;
            
        case FunctionModelTypeCrm:
        {
            // 销售
            self.tipLable.hidden = YES;
        }
            break;
            
        case FunctionModelTypeVote:
        {
            // 投票
            self.tipLable.hidden = YES;
        }
            break;
        case FunctionModelTypeContact:
        {
            // 通讯录
            self.tipLable.hidden = YES;
        }
            break;
        case FunctionModelTypeCircle:
        {
            // 企业圈
            self.tipLable.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    
    [self setNeedsLayout];
}

- (void)setWordScale:(CGFloat)wordScale{
    _wordScale = wordScale;
    
    [self setNeedsLayout];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(0, self.height * self.wordScale, self.width, self.height * (1-self.wordScale));
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(ABS(self.width - self.height* self.scale)/2.0, 0, self.height* self.scale , self.height* self.scale);
    return rect;
}

+ (instancetype)rootButton{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQRootButton" owner:self options:nil]  lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
