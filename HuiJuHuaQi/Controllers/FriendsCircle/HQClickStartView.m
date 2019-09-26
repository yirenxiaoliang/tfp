//
//  HQClickStartView.m
//  HuiJuHuaQi
//
//  Created by hq001 on 16/4/26.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQClickStartView.h"
#import "HQEmployModel.h"
#import "HQPeopleButton.h"


#define ButtonHeight 18
#define margin 4

@interface HQClickStartView ()
{
    CGFloat _firstWidth;// 抄送人：宽
    CGFloat _addWidth;// 每次累计的宽
    CGFloat _ButtonY;
    CGFloat _ButtonX;
    CGFloat _SelfHeight;
    CGFloat _changeW;// 用于记录转折点需要记录的增加量
}
/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

@end


@implementation HQClickStartView


-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.titleFont = FONT(14.0);
        self.titleColor = HexAColor(0x4d628f, 1);
    }
    return self;
}


- (void)setEmployees:(NSArray *)employees{
    
    _employees = employees;
    HQLog(@"%ld",employees.count);
    
    
    for (HQPeopleButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    
    [self.buttons removeAllObjects];
    
    if (_employees.count) {
        NSMutableArray *title =[NSMutableArray array];
        [title addObject:self.titleName ? self.titleName : @""];
        [title addObjectsFromArray:_employees];
        
        for (int i = 0; i < title.count; i ++) {
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            HQPeopleButton *button = [HQPeopleButton button];
            button.tag = i + 100;
            [self addSubview:button];
            [self.buttons addObject:button];
            
            if (i == 0) {
                
                [button setImage:[UIImage imageNamed:@"点赞people"] forState:UIControlStateNormal];
                
                button.comma.hidden = YES;
            }else{
                
                HQEmployModel *employee = title[i];
                button.titleLabel.font = BFONT(14);
                
                [button setTitleColor:GreenColor forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@ ",employee.employeeName] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickFriendName:) forControlEvents:UIControlEventTouchUpInside];
                
//                [button setBackgroundImage:[HQHelper createImageWithColor:CellSeparatorColor] forState:UIControlStateNormal];
//                button.layer.cornerRadius = ButtonHeight / 2.0;
//                button.layer.masksToBounds = YES;
                
                if (_employees.count == i) {
                    button.comma.hidden = YES;
                }

            }
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_employees.count) {
        int j = 0;
        for (int i = 0; i < _employees.count + 1; i ++) {
//            UIButton *button = [self viewWithTag:i+100];
            HQPeopleButton *button = [self viewWithTag:i+100];
            //            HQLog(@"%@", button.titleLabel.text);
            if (i == 0) {
                _firstWidth = 20;
                _addWidth = _firstWidth;
                _changeW = 0;
                button.frame = CGRectMake(-2, 0, _firstWidth, ButtonHeight);
            }else{
                CGFloat temWidth = [self sizeWithString:button.titleLabel.text font:BFONT(14) textWidth:MAXFLOAT].width;// 此处增加font，让宽度增加，灰色背景更圆满
                CGFloat add = margin + temWidth;//每次x增加量
                _addWidth += add;
                if (_addWidth + _changeW < (SCREEN_WIDTH - CompanyCircleGoodWidth)) {
                    _ButtonX = _addWidth - temWidth + _changeW;
                    if (j > 0) {// 换行后从头开始，而不是从❤️（赞）开始时
                        _ButtonX =_addWidth - temWidth + _changeW - _firstWidth - margin;
                    }
                    _ButtonY = (ButtonHeight + 2) * j;
                    button.frame = CGRectMake(_ButtonX, _ButtonY, temWidth, ButtonHeight);
                    //                    HQLog(@"=========%.1f,X: %.1f,add: %.1f,X + add: %.1f,Y : %.1f,",self.width, _ButtonX,add, _ButtonX + add, _ButtonY);
                }else{
                    ++ j;
                    _addWidth = _firstWidth;
                    
                    _ButtonX = _addWidth + margin;
                    if (j > 0) {// 换行后从头开始，而不是从❤️（赞）开始时
                        _ButtonX =_addWidth + margin - _firstWidth - margin;
                    }
                    _ButtonY = (ButtonHeight + 2) * j;
                    button.frame = CGRectMake(_ButtonX, _ButtonY, temWidth, ButtonHeight);
                    //                    HQLog(@"*********%.1f,X: %.1f,add: %.1f,X + add: %.1f,Y : %.1f,",self.width, _ButtonX,add, _ButtonX + add, _ButtonY);
                    _changeW = add;
                }
            }
        }
        _SelfHeight = _ButtonY + margin + ButtonHeight;
    }else{
        _SelfHeight = 0;// 没有抄送人
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@(_SelfHeight) forKey:@"selfHeight"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CopyerViewFinishedCalculateHeight" object:self userInfo:dic];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (CGSize)sizeWithString:(NSString *)textStr font:(UIFont *)textFont textWidth:(CGFloat)textWidth{
    
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil] context:nil].size;
    return size;
}


+ (CGFloat)getCopyerViewHeightWithTitleFont:(UIFont *)titleFont
                                   titleStr:(NSString *)titleStr
                                  employees:(NSArray *)employees
                                  selfWidth:(CGFloat)selfWidth
{
    
    if (employees.count == 0 || !employees) {
        
        return 0;
    }
    
    
    CGFloat firstWidth = 0.0;
    CGFloat addWidth = 0.0;
    CGFloat changeW = 0.0;
    CGFloat ButtonY = 0.0;
    CGFloat ButtonX = 0.0;
    int j = 0;
    for (int i = 0; i < employees.count + 1; i ++) {
        
        
        if (i == 0) {
            
            firstWidth = [HQHelper sizeWithFont:titleFont maxSize:CGSizeMake(MAXFLOAT, 20) titleStr:titleStr].width;
            addWidth = firstWidth;
            changeW = 0;
            
        }else{
            
            TFEmployeeCModel *employee = employees[i-1];
            
            
            CGFloat temWidth = [HQHelper sizeWithFont:BFONT(14.0) maxSize:CGSizeMake(MAXFLOAT, 20) titleStr:[NSString stringWithFormat:@"%@ ",employee.employee_name]].width;
            CGFloat add = margin + temWidth;//每次x增加量
            addWidth += add;
            if (addWidth + changeW < selfWidth) {
                ButtonX = addWidth - temWidth + changeW;
                ButtonY = (ButtonHeight + margin) * j;
                
            }else{
                ++ j;
                addWidth = firstWidth;
                ButtonX = addWidth + margin;
                ButtonY = (ButtonHeight + margin) * j;
                changeW = add;
            }
        }
    }
    
    
    return (CGFloat)(ButtonY + margin + ButtonHeight);
}

-(void)clickFriendName:(UIButton*)sender{
    
   HQEmployModel * employModel =  _employees[sender.tag-101];
    
    HQLog(@"buttontag++%@",employModel.id);
    

    if ([self.delegate respondsToSelector:@selector(senderEmployIdToCell:)]) {
        [self.delegate senderEmployIdToCell:employModel];
    }
    
    
}




@end
