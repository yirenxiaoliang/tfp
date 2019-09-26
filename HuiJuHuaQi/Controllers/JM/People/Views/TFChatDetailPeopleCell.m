//
//  TFChatDetailPeopleCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatDetailPeopleCell.h"
#import "HQRootButton.h"

#import "TFGroupEmployeeModel.h"

@interface TFChatDetailPeopleCell ()

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

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

@implementation TFChatDetailPeopleCell



-(NSMutableArray *)buttons{
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
    
}

+(instancetype)chatDetailPeopleCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFChatDetailPeopleCell";
    TFChatDetailPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFChatDetailPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
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
    
    self.column = column;
    
    NSInteger index = 0;
    self.marginWidth = 15;
    self.paddingWidth = 10;
    
    if (type == 1) {
        index += 1;
    }else if (type == 2){
        index += 2;
        self.marginWidth = 22;
        self.paddingWidth = 20;
    }
    NSArray *arr = nil;
    if (items.count > 2 * column - index) {
        arr = [items subarrayWithRange:NSMakeRange(0, 2 * column-index)];
    }else{
        arr = items;
    }
    self.items = arr;
    index += arr.count;
    
    self.buttonWidth = ((SCREEN_WIDTH - self.marginWidth * 2 - (self.column-1) * self.paddingWidth)/self.column);
    
    for (UIButton *button in self.buttons) {
        
        [button removeFromSuperview];
    }
    
    [self.buttons removeAllObjects];
    
    for (NSInteger i = 0; i < index; i ++) {
        
        UIButton *labelBtn = [HQHelper buttonWithFrame:(CGRect){0,0,self.buttonWidth,self.buttonWidth} target:nil action:nil];
        
        //        labelBtn.backgroundColor = RedColor;
        labelBtn.frame = CGRectMake(0, 0,self.buttonWidth , self.buttonWidth + 20);
 
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = (CGRect){0,0,Long(50),Long(50)};
        button.centerX = self.buttonWidth/2;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.cornerRadius = button.width/2;
        button.layer.masksToBounds = YES;
        [labelBtn addSubview:button];
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:(CGRect){0,Long(50),self.buttonWidth,20}];
        title.font = FONT(14);
        title.textColor = BlackTextColor;
        title.textAlignment = NSTextAlignmentCenter;
        [labelBtn addSubview:title];
        
        
        if (i == arr.count + 1) {
            button.tag = 0x789;

            [button setImage:IMG(@"踢人") forState:UIControlStateNormal];
        }else if (i == arr.count) {
            button.tag = 0x456;

            [button setImage:IMG(@"加人") forState:UIControlStateNormal];
        }else{
            
            TFGroupEmployeeModel *model = arr[i];
            if (![model.picture isEqualToString:@""]) {
                
//                [button.imageView sd_setImageWithURL:[HQHelper URLWithString:model.picture]];
//                NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:model.picture]];
//                
//                UIImage *image =  [UIImage imageWithData:data];
//                
//                [button setImage:image forState:UIControlStateNormal];
                [button sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
            }
            else {
            
                [button setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
                [button setTitleColor:WhiteColor forState:UIControlStateNormal];
                [button setBackgroundColor:GreenColor];
            }
            
            
            title.text = model.employee_name;
            button.tag = 0x123 + i;
        }
        
        [self.contentView addSubview:labelBtn];
        
        [self.buttons addObject:labelBtn];
    }
}

- (void)buttonClicked:(UIButton *)button{
    
    if (button.tag < 0x456) {
        if ([self.delegate respondsToSelector:@selector(chatDetailPeopleCellDidClickedPeopleWithModel:)]) {
            
//            JMSGUser *jmsUser = self.items[button.tag-0x123];
            NSInteger index = button.tag-0x123;
            [self.delegate chatDetailPeopleCellDidClickedPeopleWithModel:index];
        }
        
    }else if (button.tag < 0x789){
        
        if ([self.delegate respondsToSelector:@selector(chatDetailPeopleCellDidClickedAddButton)]) {
            [self.delegate chatDetailPeopleCellDidClickedAddButton];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(chatDetailPeopleCellDidClickedMinusBuuton)]) {
            [self.delegate chatDetailPeopleCellDidClickedMinusBuuton];
        }
    }
}


+(CGFloat)refreshCellHeightWithItems:(NSArray *)items withType:(NSInteger)type withColumn:(NSInteger)column{
    
    NSInteger index = 0;
    CGFloat marginWidth = 15, paddingWidth = 10;
    
    if (type == 1) {
        index += 1;
    }else if (type == 2){
        index += 2;
        marginWidth = 22;
        paddingWidth = 20;
    }
    
    NSArray *arr = nil;
    if (items.count > 2 * column - index) {
        arr = [items subarrayWithRange:NSMakeRange(0, 2 * column-index)];
    }else{
        arr = items;
    }
    
    CGFloat buttonWidth = ((SCREEN_WIDTH - marginWidth * 2 - (column-1) * paddingWidth)/column);
    
    CGFloat height = 0;
    
    
    NSInteger col = (arr.count + index +column-1) / column;
    
    if (col == 0) {
        return height;
    }else{
        
        height = marginWidth + col * (marginWidth + buttonWidth + 20);
        
    }
    
    if ((arr.count + index) % column == 1 || (arr.count + index) % column == 2) {
        height -= 20;
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
        
        CGFloat Y = self.marginWidth + row * (self.paddingWidth + self.buttonWidth + 20);
        
        HQLog(@"%lf",Y);
        
        labelBtn.frame = CGRectMake(self.marginWidth + col * (self.paddingWidth + self.buttonWidth), Y, self.buttonWidth, self.buttonWidth + 20);
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
