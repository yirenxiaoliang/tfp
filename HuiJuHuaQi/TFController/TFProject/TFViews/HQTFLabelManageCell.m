//
//  HQTFLabelManageCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFLabelManageCell.h"
#import "HQTFLabelButton.h"

#define ItemMargin Long(20)
#define ItemTopMargin Long(25)
#define ItemWidth ((SCREEN_WIDTH-2*ItemMargin-2*ItemTopMargin)/3)
#define ItemHeight Long(36)
#define ItemColumn 3

@interface HQTFLabelManageCell ()<HQTFLabelButtonDelegate>

/** 数组 */
@property (nonatomic, strong) NSMutableArray *buttons;


/** 应用场景 0:新增 1：删除 2:选择颜色*/
@property (nonatomic, assign) NSInteger type;

@property (nonatomic,strong) NSArray *items;


@property (nonatomic,strong) NSMutableArray *selectedItems;

@end

@implementation HQTFLabelManageCell

-(NSMutableArray *)buttons{
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
    
}
-(NSMutableArray *)selectedItems{
    
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    return _selectedItems;
    
}

+(instancetype)labelManageCellWithTableView:(UITableView *)tableView withType:(NSInteger)type{
    
    static NSString *indentifier = @"HQTFLabelManageCell";
    HQTFLabelManageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFLabelManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.type = type;
    return cell;
    
}

-(void)refreshCellWithItems:(NSArray *)items{
    
    self.items = items;
    
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < items.count; i ++) {
        
        HQTFLabelButton *labelBtn = [HQTFLabelButton labelButton];
        labelBtn.delegate = self;
        labelBtn.tag = 0x123 + i;
        labelBtn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:arc4random_uniform(255)/255.0];
        labelBtn.text = items[i];
        labelBtn.scene = self.type;
        
        
        [self.contentView addSubview:labelBtn];
        
        [self.buttons addObject:labelBtn];
    }
}


-(void)refreshCellItemColorWithItems:(NSArray *)items{
    
    self.items = items;
    
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < items.count; i ++) {
        
        HQTFLabelButton *labelBtn = [HQTFLabelButton labelButton];
        labelBtn.delegate = self;
        labelBtn.tag = 0x123 + i;
        labelBtn.scene = self.type;
        TFProjLabelModel *model = items[i];
        labelBtn.backgroundColor = [HQHelper colorWithHexString:model.labelColor];
        labelBtn.text = @"";
        [self.contentView addSubview:labelBtn];
        
        if ([self.selcteColor isEqualToString:model.labelColor]) {
            labelBtn.type = LabelButtonTypeColor;
        }else{
            labelBtn.type = LabelButtonTypeNormal;
        }
        
        [self.buttons addObject:labelBtn];
    }
    
}

-(void)labelButtonSelectIndex:(NSInteger)index withSelect:(BOOL)select block:(void (^)(BOOL selected))blcok{
    
   
    if (self.type == 0) {// 新增
        
        if (select) {
            
            if (self.selectedItems.count >= 3) {//最多选3个
                
                [MBProgressHUD showError:@"最多选用3个标签" toView:KeyWindow];
                blcok(NO);
                
            }else{
                
                [self.selectedItems addObject:self.items[index]];
                blcok(select);
            }
            
        }else{
            
            [self.selectedItems removeObject:self.items[index]];
            
            blcok(select);
        }
        
        
    }else if (self.type == 1){// 删除
        
        if (select) {
            
            [self.selectedItems addObject:self.items[index]];
            
        }else{
            
            [self.selectedItems removeObject:self.items[index]];
        }

        blcok(select);
        
    }else{// 选颜色
        
        
        for (HQTFLabelButton *labelBtn in self.buttons) {
            labelBtn.type = LabelButtonTypeNormal;
        }
        [self.selectedItems removeAllObjects];
        
        HQTFLabelButton *labelBtn = self.buttons[index];
        labelBtn.type = LabelButtonTypeColor;
        
        [self.selectedItems addObject:self.items[index]];
        
        if ([self.delegate respondsToSelector:@selector(labelManageCellSelectColorWithColorModel:)]) {
            [self.delegate labelManageCellSelectColorWithColorModel:self.items[index]];
        }
    }
    
}


+(CGFloat)refreshCellHeightWithItems:(NSArray *)items{
    
    CGFloat height = 0;
    
    
    NSInteger col = (items.count+ItemColumn-1) / ItemColumn;
    
    if (col == 0) {
        return height;
    }else{
        
        height = ItemMargin + col * (ItemMargin + ItemHeight);
        
    }
    
    return height;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    HQLog(@"%ld",self.contentView.subviews.count);
    
    for (NSInteger i = 0; i < self.buttons.count; i ++) {
        
        HQTFLabelButton *labelBtn = self.buttons[i];
        
        NSInteger row = i / ItemColumn;
        NSInteger col = i % ItemColumn;
        
        CGFloat Y = ItemMargin + row * (ItemMargin + ItemHeight);
        
        HQLog(@"%lf",Y);
        
        labelBtn.frame = CGRectMake(ItemTopMargin + col * (ItemMargin + ItemWidth), ItemMargin + row * (ItemMargin + ItemHeight), ItemWidth, ItemHeight);
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
