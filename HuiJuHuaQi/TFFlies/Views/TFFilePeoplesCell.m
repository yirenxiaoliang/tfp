//
//  TFFilePeoplesCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFilePeoplesCell.h"
#import "HQEmployModel.h"

//#define MarginWidth 15
//#define PaddingWidth 10
//#define ButtonCount 7
//#define ButtonWidth ((SCREEN_WIDTH - MarginWidth * 2 - (ButtonCount-1) * PaddingWidth)/ButtonCount)

@interface TFFilePeoplesCell ()

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

/** buttons */
@property (nonatomic, strong) NSMutableArray *lables;

/** buttons */
@property (nonatomic, strong) NSArray *items;

/** 一行有几个 */
@property (nonatomic, assign) NSInteger column;

/** 按钮宽 */
@property (nonatomic, assign) CGFloat buttonWidth;
/** top间距 */
@property (nonatomic, assign) CGFloat marginWidth;
/** 按钮之间间距 */
@property (nonatomic, assign) CGFloat paddingWidth;

@end

@implementation TFFilePeoplesCell


-(NSMutableArray *)buttons{
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
    
}

-(NSMutableArray *)lables{
    
    if (!_lables) {
        _lables = [NSMutableArray array];
        
        
    }
    return _lables;
    
}

+(instancetype)filePeopleCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFFilePeoplesCell";
    TFFilePeoplesCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFFilePeoplesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
/** 刷新cell
 *  @param items 人员数组
 *  @param type  类型 0：无加减号  1：有加号  2：有加减号
 *  @param column  一行几个
 */
-(void)refreshCellWithItems:(NSArray *)items withType:(NSInteger)type withColumn:(NSInteger)column{
    
    self.requireLab = [UILabel initCustom:CGRectZero title:@"*" titleColor:RedColor titleFont:14 bgColor:ClearColor];
    
    [self addSubview:self.requireLab];
    
    [self.requireLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@6);
        make.top.equalTo(@22);
        make.width.equalTo(@7);
        make.height.equalTo(@17);
    }];
    
    self.titleLab = [UILabel initCustom:CGRectZero title:@"管理员" titleColor:kUIColorFromRGB(0x2D2D00) titleFont:14 bgColor:ClearColor];
    
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.requireLab.mas_right).offset(2);
        make.top.equalTo(@22);
        make.height.equalTo(@17);
        
    }];
    
    self.column = column;
    
    NSInteger index = items.count+1;
    self.marginWidth = 15;
    self.paddingWidth = 10;

    
    self.buttonWidth = ((SCREEN_WIDTH - 108 - self.marginWidth * 2 - (self.column-1) * self.paddingWidth)/self.column);
    
    for (UIButton *button in self.buttons) {
        
        [button removeFromSuperview];
    }
    
    [self.buttons removeAllObjects];
    
    
    for (UILabel *lable in self.lables) {
        
        [lable removeFromSuperview];
    }
    
    [self.lables removeAllObjects];
    
    for (NSInteger i = 0; i < index; i ++) {
        
        UIButton *labelBtn = [HQHelper buttonWithFrame:(CGRect){0,0,self.buttonWidth,self.buttonWidth} target:self action:@selector(buttonClicked:)];
        //        labelBtn.backgroundColor = RedColor;
        labelBtn.layer.cornerRadius = self.buttonWidth/2;
        labelBtn.layer.masksToBounds = YES;
        labelBtn.contentMode = UIViewContentModeScaleAspectFill;
        labelBtn.userInteractionEnabled = YES;

        if (i == items.count) {
            [labelBtn setBackgroundImage:[UIImage imageNamed:@"加人"] forState:UIControlStateNormal];
            [_lables addObject:@""];
        }else{
            HQEmployModel *employ = items[i];
            
            // 设置头像
            if (![employ.photograph isEqualToString:@""] && employ.photograph != nil) {
                
                [labelBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
                [labelBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:employ.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
                [labelBtn setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                
                [labelBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
                [labelBtn setTitle:[HQHelper nameWithTotalName:employ.employee_name] forState:UIControlStateNormal];
                [labelBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
                [labelBtn setBackgroundColor:GreenColor];
                
            }
            
            UILabel *nameLab = [HQHelper labelWithFrame:(CGRect){0,self.marginWidth+self.buttonWidth+4,self.buttonWidth,18} text:employ.employee_name textColor:kUIColorFromRGB(0x17171A) textAlignment:NSTextAlignmentCenter font:FONT(11)];
            
            [self.contentView addSubview:nameLab];
            
            [self.lables addObject:nameLab];
        }
        
        
        
        [self.contentView addSubview:labelBtn];
        
        [self.buttons addObject:labelBtn];
    }
}

- (void)buttonClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(addFilePeoples)]) {
        
        [self.delegate addFilePeoples];
    }
}


+(CGFloat)refreshFileCellHeightWithItems:(NSArray *)items withType:(NSInteger)type withColumn:(NSInteger)column{
    
    NSInteger index = 0;
    CGFloat marginWidth = 15, paddingWidth = 10;
    
//    if (type == 1) {
        index += 1;
//    }else if (type == 2){
//        index += 2;
//        marginWidth = 22;
//        paddingWidth = 20;
//    }
    
    CGFloat buttonWidth = ((SCREEN_WIDTH - 108 -marginWidth * 2 - (column-1) * paddingWidth)/column);
    
    CGFloat height = 0;
    
    
    NSInteger col = (items.count + index +column-1) / column;
    
    if (col == 0) {
        return height;
    }else{
        
        height = marginWidth + col * (marginWidth + buttonWidth);
        
    }
    
    return height;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    HQLog(@"%ld",self.contentView.subviews.count);
    
    for (NSInteger i = 0; i < self.buttons.count; i ++) {
        
        UIButton *labelBtn = self.buttons[i];
       
        
        
        NSInteger row = i / self.column;
        NSInteger col = i % self.column;
        
        CGFloat Y = self.marginWidth + row * (self.paddingWidth + self.buttonWidth);
        
        HQLog(@"%lf",Y);
        
        labelBtn.frame = CGRectMake(self.marginWidth + col * (self.paddingWidth + self.buttonWidth)+108, self.marginWidth + row * (self.marginWidth + self.buttonWidth), self.buttonWidth, self.buttonWidth);
        
        if (self.lables.count>0) {
            
            UILabel *nameLab = self.lables[i];
            
            nameLab.frame = CGRectMake(self.marginWidth + col * (self.paddingWidth + self.buttonWidth)+108, self.marginWidth + row * (self.marginWidth + self.buttonWidth)+self.buttonWidth+4, self.buttonWidth, 18);
        }
        
    }
    
}

@end
