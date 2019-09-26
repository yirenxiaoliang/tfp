//
//  TFManyLableCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/8/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFManyLableCell.h"
#import "TFCustomerRowsModel.h"


@implementation TFManyLableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,35}];
        [self.contentView addSubview:view];
        view.backgroundColor = ClearColor;
        self.titleBgView = view;
        
        UIView *borderView = [[UIView alloc] init];
        [self.contentView addSubview:borderView];
        borderView.layer.borderColor = CellClickColor.CGColor;
        borderView.layer.borderWidth = 0.5;
        self.borderView = borderView;
        borderView.hidden = YES;
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(95);
            make.top.equalTo(self.contentView).with.offset(15);
            make.bottom.equalTo(self.contentView).with.offset(-15);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        
        HQAdviceTextView *textView = [[HQAdviceTextView alloc] init];
        textView.backgroundColor = ClearColor;
        [self.contentView addSubview:textView];
        textView.font = FONT(17);
        self.textVeiw = textView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(105);
            make.top.equalTo(self.contentView).with.offset(5);
            make.bottom.equalTo(self.contentView).with.offset(-5);
            make.right.equalTo(self.contentView).with.offset(-10);
            
        }];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = ExtraLightBlackTextColor;
        lable.font = FONT(14);
        lable.backgroundColor = ClearColor;
        [self addSubview:lable];
        lable.textAlignment = NSTextAlignmentLeft;
        self.titleLab = lable;
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.contentView).with.offset(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(101);
            
        }];
        
        UILabel *requi = [[UILabel alloc] init];
        requi.text = @"*";
        self.requireLabel = requi;
        requi.textColor = RedColor;
        requi.font = FONT(14);
        requi.backgroundColor = ClearColor;
        [self.contentView addSubview:requi];
        requi.textAlignment = NSTextAlignmentLeft;
        [requi mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(6);
            make.centerY.equalTo(lable.mas_centerY);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(15);
            
        }];
        
        self.layer.masksToBounds = YES;
    }
    return self;
}


-(void)setStructure:(NSString *)structure{
    
    _structure = structure;
    
    if ([structure isEqualToString:@"0"]) {
        
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.width.mas_equalTo(SCREEN_WIDTH-30);
        }];
        
        [self.textVeiw mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(35);
            
        }];
        
    }else{
        
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(90);
        }];
        
        [self.textVeiw mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(105);
            make.top.equalTo(self.contentView).with.offset(5);
            
        }];
        
    }
    
}

-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
}


+ (instancetype)creatManyLableCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFManyLableCell";
    TFManyLableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFManyLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.layer.masksToBounds = YES;
    return cell;
}

+ (CGFloat)refreshManyLableCellHeightWithModel:(id)model type:(NSInteger)type{
    
    if ([model isKindOfClass:[TFCustomerRowsModel class]]) {
        TFCustomerRowsModel *row = model;
        
        if (type != 1) {
            
            
            if ([row.field.structure isEqualToString:@"0"]) {// 上下
                
                CGSize size = [HQHelper sizeWithFont:FONT(17) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:row.fieldValue];
                
                CGFloat height =  size.height + 30 < 144 ? 144 : size.height + 30;
                
                return height + 35;// 35为title高度
                
            }else{// 左右
                
                CGSize size = [HQHelper sizeWithFont:FONT(17) maxSize:(CGSize){SCREEN_WIDTH-101-20,MAXFLOAT} titleStr:row.fieldValue];
                
                return size.height + 30 < 144 ? 144 : size.height + 30;
            }
            
        }else{
            
            if ([row.field.structure isEqualToString:@"0"]) {// 上下
                
                CGSize size = [HQHelper sizeWithFont:FONT(17) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:row.fieldValue];
                
                CGFloat height =  size.height + 30 ;
                
                return height + 35 < 80 ? 80 : height + 35;// 35为title高度
                
            }else{// 左右
                
                CGSize size = [HQHelper sizeWithFont:FONT(17) maxSize:(CGSize){SCREEN_WIDTH-101-20,MAXFLOAT} titleStr:row.fieldValue];
                
                return size.height + 30 < 64 ? 64 : size.height + 30;
            }
        }
        
    }
    
    return 144;
}

@end
