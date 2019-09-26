//
//  HQTFAddLabelCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFAddLabelCell.h"

#import "TFProjLabelModel.h"

#define MaxVisibleWidth (SCREEN_WIDTH - 150)


@interface HQTFAddLabelCell ()
@property (weak, nonatomic) IBOutlet UIImageView *enterImage;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn31;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn1H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn2H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn3H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn31H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn4H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn5H;

@end

@implementation HQTFAddLabelCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.textColor = ExtraLightBlackTextColor;
    self.titleLabel.font = FONT(14);
    
    self.btn1.backgroundColor = [UIColor clearColor];
    self.btn2.backgroundColor = [UIColor clearColor];
    self.btn3.backgroundColor = [UIColor clearColor];
    self.btn31.backgroundColor = [UIColor clearColor];
    self.btn4.backgroundColor = [UIColor clearColor];
    self.btn5.backgroundColor = [UIColor clearColor];
    
    self.btn1.userInteractionEnabled = NO;
    self.btn2.userInteractionEnabled = NO;
    self.btn3.userInteractionEnabled = NO;
    self.btn31.userInteractionEnabled = NO;
    self.btn4.userInteractionEnabled = NO;
    self.btn5.userInteractionEnabled = NO;
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)refreshAddLabelCellWithLabels:(NSArray *)labels{
    
    
    self.btn1H.constant = 28;
    self.btn2H.constant = 28;
    self.btn3H.constant = 28;
    self.btn4H.constant = 28;
    self.btn5H.constant = 28;
    self.btn31H.constant = 28;
    
    
    self.btn1.layer.cornerRadius = 14;
    self.btn1.layer.masksToBounds = YES;
    self.btn2.layer.cornerRadius = 14;
    self.btn2.layer.masksToBounds = YES;
    self.btn3.layer.cornerRadius = 14;
    self.btn3.layer.masksToBounds = YES;
    self.btn31.layer.cornerRadius = 14;
    self.btn31.layer.masksToBounds = YES;
    self.btn4.layer.cornerRadius = 14;
    self.btn4.layer.masksToBounds = YES;
    self.btn5.layer.cornerRadius = 14;
    self.btn5.layer.masksToBounds = YES;
    
    /*UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 10, 10);
    // 指定为拉伸模式
    UIImage *image = [[UIImage imageNamed:@"标签透明"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    [self.btn1 setBackgroundImage:image forState:UIControlStateNormal];
    [self.btn1 setBackgroundImage:image forState:UIControlStateHighlighted];
    [self.btn2 setBackgroundImage:image forState:UIControlStateNormal];
    [self.btn2 setBackgroundImage:image forState:UIControlStateHighlighted];
    [self.btn3 setBackgroundImage:image forState:UIControlStateNormal];
    [self.btn3 setBackgroundImage:image forState:UIControlStateHighlighted];
    [self.btn4 setBackgroundImage:image forState:UIControlStateNormal];
    [self.btn4 setBackgroundImage:image forState:UIControlStateHighlighted];
    */
    
    if (labels.count == 1){
        
        self.btn1.hidden = NO;
        self.btn2.hidden = YES;
        self.btn3.hidden = YES;
        self.btn4.hidden = YES;
        self.btn31.hidden = YES;
        self.btn5.hidden = YES;
        
        
        TFProjLabelModel *model1 = labels[0];
        [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateNormal];
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model1.labelColor]] forState:UIControlStateNormal];
        
        
    }else if (labels.count == 2){
        
        
        self.btn1.hidden = NO;
        self.btn2.hidden = NO;
        self.btn3.hidden = YES;
        self.btn4.hidden = YES;
        self.btn31.hidden = YES;
        self.btn5.hidden = YES;
        
        TFProjLabelModel *model1 = labels[0];
        TFProjLabelModel *model2 = labels[1];
        [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateNormal];
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model1.labelColor]] forState:UIControlStateNormal];
        [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model2.labelColor]] forState:UIControlStateNormal];
        
    }else if (labels.count == 3){
        
//        NSInteger i = 0;
//        NSString *string = @"";
        
        CGFloat sur = MaxVisibleWidth;
        
        
        CGFloat puls = 0;
        NSString *str = @"";
        NSInteger index = 0;
        
//        for (TFProjLabelModel *model in labels) {
//
//            string = [string stringByAppendingString:[NSString stringWithFormat:@"    %@    我",model.labelName]];
//           
//            
//            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:string];
//            
//            if (size.width >= MaxVisibleWidth) {
//                break;
//            }
//            
//            i ++;
//
//        }
        
        for (NSInteger i = 0; i < labels.count; i ++) {
            
            TFProjLabelModel *label = labels[i];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"    %@    ",label.labelName]];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:str];
            puls = (size.width + 8);
            
            if (sur <= puls) {
                break;
            }
            index ++;
        }
        
        if (index == 3) {
            
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = NO;
            self.btn31.hidden = YES;
            self.btn4.hidden = YES;
            self.btn5.hidden = YES;
            TFProjLabelModel *model1 = labels[0];
            TFProjLabelModel *model2 = labels[1];
            TFProjLabelModel *model3 = labels[2];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateNormal];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateHighlighted];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateNormal];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateHighlighted];
            [self.btn3 setTitle:[NSString stringWithFormat:@"    %@    ",model3.labelName] forState:UIControlStateNormal];
            [self.btn3 setTitle:[NSString stringWithFormat:@"    %@    ",model3.labelName] forState:UIControlStateHighlighted];
            [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model1.labelColor]] forState:UIControlStateNormal];
            [self.btn2 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model2.labelColor]] forState:UIControlStateNormal];
            [self.btn3 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model3.labelColor]] forState:UIControlStateNormal];
            
        }else{
            
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = YES;
            self.btn31.hidden = YES;
            self.btn4.hidden = NO;
            self.btn5.hidden = YES;
            TFProjLabelModel *model1 = labels[0];
            TFProjLabelModel *model2 = labels[1];
            TFProjLabelModel *model4 = labels[2];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateNormal];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateHighlighted];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateNormal];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateHighlighted];
            [self.btn4 setTitle:[NSString stringWithFormat:@"    %@    ",model4.labelName] forState:UIControlStateNormal];
            [self.btn4 setTitle:[NSString stringWithFormat:@"    %@    ",model4.labelName] forState:UIControlStateHighlighted];
            
            [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model1.labelColor]] forState:UIControlStateNormal];
            [self.btn2 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model2.labelColor]] forState:UIControlStateNormal];
            [self.btn4 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model4.labelColor]] forState:UIControlStateNormal];
        }

        
        
    }else{
        
        
        
        CGFloat sur = MaxVisibleWidth;
        
        
        CGFloat puls = 0;
        NSString *str = @"";
        NSInteger index = 0;
        for (NSInteger i = 0; i < labels.count; i ++) {
            
            TFProjLabelModel *label = labels[i];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"    %@    ",label.labelName]];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:str];
            puls = (size.width + 8);
            
            if (sur <= puls) {
                break;
            }
            index ++;
        }
        if (index == 4) {
            
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = NO;
            self.btn31.hidden = NO;
            self.btn4.hidden = YES;
            self.btn5.hidden = YES;
            TFProjLabelModel *model1 = labels[0];
            TFProjLabelModel *model2 = labels[1];
            TFProjLabelModel *model3 = labels[2];
            TFProjLabelModel *model31 = labels[3];
            
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateNormal];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateHighlighted];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateNormal];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateHighlighted];
            [self.btn3 setTitle:[NSString stringWithFormat:@"    %@    ",model3.labelName] forState:UIControlStateNormal];
            [self.btn3 setTitle:[NSString stringWithFormat:@"    %@    ",model3.labelName] forState:UIControlStateHighlighted];
            [self.btn31 setTitle:[NSString stringWithFormat:@"    %@    ",model31.labelName] forState:UIControlStateNormal];
            [self.btn31 setTitle:[NSString stringWithFormat:@"    %@    ",model31.labelName] forState:UIControlStateHighlighted];
            [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model1.labelColor]] forState:UIControlStateNormal];
            [self.btn2 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model2.labelColor]] forState:UIControlStateNormal];
            [self.btn3 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model3.labelColor]] forState:UIControlStateNormal];
            [self.btn31 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model31.labelColor]] forState:UIControlStateNormal];
            
        }else if (index == 3) {
            
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = NO;
            self.btn31.hidden = YES;
            self.btn4.hidden = NO;
            self.btn5.hidden = YES;
            TFProjLabelModel *model1 = labels[0];
            TFProjLabelModel *model2 = labels[1];
            TFProjLabelModel *model3 = labels[2];
            TFProjLabelModel *model4 = labels[3];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateNormal];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateHighlighted];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateNormal];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateHighlighted];
            [self.btn3 setTitle:[NSString stringWithFormat:@"    %@    ",model3.labelName] forState:UIControlStateNormal];
            [self.btn3 setTitle:[NSString stringWithFormat:@"    %@    ",model3.labelName] forState:UIControlStateHighlighted];
            [self.btn4 setTitle:[NSString stringWithFormat:@"    %@    ",model4.labelName] forState:UIControlStateNormal];
            [self.btn4 setTitle:[NSString stringWithFormat:@"    %@    ",model4.labelName] forState:UIControlStateHighlighted];
            
            [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model1.labelColor]] forState:UIControlStateNormal];
            [self.btn2 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model2.labelColor]] forState:UIControlStateNormal];
            [self.btn3 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model3.labelColor]] forState:UIControlStateNormal];
            [self.btn4 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model4.labelColor]] forState:UIControlStateNormal];
            
        }else{
            
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = YES;
            self.btn31.hidden = YES;
            self.btn4.hidden = NO;
            self.btn5.hidden = NO;
            TFProjLabelModel *model1 = labels[0];
            TFProjLabelModel *model2 = labels[1];
            TFProjLabelModel *model4 = labels[2];
            TFProjLabelModel *model5 = labels[3];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateNormal];
            [self.btn1 setTitle:[NSString stringWithFormat:@"    %@    ",model1.labelName] forState:UIControlStateHighlighted];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateNormal];
            [self.btn2 setTitle:[NSString stringWithFormat:@"    %@    ",model2.labelName] forState:UIControlStateHighlighted];
            [self.btn4 setTitle:[NSString stringWithFormat:@"    %@    ",model4.labelName] forState:UIControlStateNormal];
            [self.btn4 setTitle:[NSString stringWithFormat:@"    %@    ",model4.labelName] forState:UIControlStateHighlighted];
            [self.btn5 setTitle:[NSString stringWithFormat:@"    %@    ",model5.labelName] forState:UIControlStateNormal];
            [self.btn5 setTitle:[NSString stringWithFormat:@"    %@    ",model5.labelName] forState:UIControlStateHighlighted];
            
            [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model1.labelColor]] forState:UIControlStateNormal];
            [self.btn2 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model2.labelColor]] forState:UIControlStateNormal];
            [self.btn4 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model4.labelColor]] forState:UIControlStateNormal];
            [self.btn5 setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:model5.labelColor]] forState:UIControlStateNormal];
        }
        

        
    }
    
    
}

- (void)refreshAddLabelCellWithPriority:(NSNumber *)priority{
    
    
    self.btn1H.constant = 28;
    self.btn2H.constant = 28;
    self.btn3H.constant = 28;
    self.btn4H.constant = 28;
    self.btn5H.constant = 28;
    self.btn31H.constant = 28;
    
    self.btn1.hidden = NO;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn31.hidden = YES;
    self.btn5.hidden = YES;
    
    
    self.btn1.layer.cornerRadius = 2;
    self.btn1.layer.masksToBounds = YES;
    self.btn2.layer.cornerRadius = 2;
    self.btn2.layer.masksToBounds = YES;
    self.btn3.layer.cornerRadius = 2;
    self.btn3.layer.masksToBounds = YES;
    self.btn31.layer.cornerRadius = 2;
    self.btn31.layer.masksToBounds = YES;
    self.btn4.layer.cornerRadius = 2;
    self.btn4.layer.masksToBounds = YES;
    self.btn5.layer.cornerRadius = 2;
    self.btn5.layer.masksToBounds = YES;
    
    if ([priority isEqualToNumber:@0]) {
        
        [self.btn1 setTitle:@"   普通   " forState:UIControlStateNormal];
        [self.btn1 setTitle:@"   普通   " forState:UIControlStateHighlighted];
        
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:LightGrayTextColor] forState:UIControlStateNormal];
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:LightGrayTextColor] forState:UIControlStateHighlighted];
        
    }else if ([priority isEqualToNumber:@1]){
        
        [self.btn1 setTitle:@"   紧急   " forState:UIControlStateNormal];
        [self.btn1 setTitle:@"   紧急   " forState:UIControlStateHighlighted];
        
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xf5a623, 1)] forState:UIControlStateNormal];
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xf5a623, 1)] forState:UIControlStateHighlighted];
        
    }else{
        
        [self.btn1 setTitle:@"   非常紧急   " forState:UIControlStateNormal];
        [self.btn1 setTitle:@"   非常紧急   " forState:UIControlStateHighlighted];
        
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xf41c0d, 1)] forState:UIControlStateNormal];
        [self.btn1 setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xf41c0d, 1)] forState:UIControlStateHighlighted];
    }
}

+ (CGFloat)refreshAddLabelCellHeightWithLabels:(NSArray *)labels{
    
    CGFloat sur = MaxVisibleWidth;
    CGFloat puls = 0;
    NSString *str = @"";
    NSInteger index = 0;
    for (NSInteger i = 0; i < labels.count; i ++) {
        
        TFProjLabelModel *label = labels[i];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"    %@    ",label.labelName]];
        CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:str];
        puls = (size.width + 8);
        
        if (sur <= puls) {
            break;
        }
        index ++;
    }


    if (labels.count <= 2) {
        return  55;
    }else{
        
        if (labels.count == 3) {
            
            if (index <= 2) {
                return 90;
            }else{
                return 55;
            }
            
        }else{
            
            if (index <= 3) {
                return 90;
            }else{
                return 55;
            }
        }
        
    }
}


+ (instancetype)addLabelCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFAddLabelCell" owner:self options:nil] lastObject];
}

+ (HQTFAddLabelCell *)addLabelCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFAddLabelCell";
    HQTFAddLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self addLabelCell];
    }
    cell.topLine.hidden = YES;
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
