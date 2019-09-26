//
//  TFCustomListCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomListCell.h"

@interface TFCustomListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UILabel *bg1Label1;
@property (weak, nonatomic) IBOutlet UILabel *bg1Label2;
@property (weak, nonatomic) IBOutlet UILabel *bg2Label1;
@property (weak, nonatomic) IBOutlet UILabel *bg2Label2;
@property (weak, nonatomic) IBOutlet UILabel *bg3Label1;
@property (weak, nonatomic) IBOutlet UILabel *bg3Label2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgView1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgView2W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgView3W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label2W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label3W;

/**  marginView */
@property (nonatomic, weak) UIView *marginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeadW;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation TFCustomListCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.textColor = BlackTextColor;
    self.bg1Label1.textColor = GrayTextColor;
    self.bg1Label2.textColor = LightBlackTextColor;
    self.bg2Label1.textColor = GrayTextColor;
    self.bg2Label2.textColor = LightBlackTextColor;
    self.bg3Label1.textColor = GrayTextColor;
    self.bg3Label2.textColor = LightBlackTextColor;
    self.label1.textColor = LightBlackTextColor;
    self.label2.textColor = LightBlackTextColor;
    self.label3.textColor = LightBlackTextColor;
    
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label1.textColor = WhiteColor;
    self.label2.textColor = WhiteColor;
    self.label3.textColor = WhiteColor;
    self.label1.font = FONT(11);
    self.label2.font = FONT(11);
    self.label3.font = FONT(11);
    
    UIView *marginView = [[UIView alloc] init];
    marginView.hidden = YES;
    [self.contentView addSubview:marginView];
    self.marginView = marginView;
    [marginView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(@4);
    }];
    self.selectBtn.hidden = YES;
    self.titleHeadW.constant = 0;
    self.selectBtn.userInteractionEnabled = NO;
}

+(instancetype)customListCell{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFCustomListCell" owner:self options:nil] lastObject];
}

+ (instancetype)customListCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFCustomListCell";
    TFCustomListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self customListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setSelect:(BOOL)select{
    _select = select;
    
    if (select) {
        self.titleHeadW.constant = 34;
        self.selectBtn.hidden = NO;
    }else{
        self.titleHeadW.constant = 0;
        self.selectBtn.hidden = YES;
    }
}


-(void)refreshCustomListCellWithModel:(TFCustomListItemModel *)model{
    
    
    self.titleLabel.hidden = YES;
    self.bgView1.hidden = YES;
    self.bgView1.backgroundColor = ClearColor;
    self.bgView2.hidden = YES;
    self.bgView2.backgroundColor = ClearColor;
    self.bgView3.hidden = YES;
    self.bgView3.backgroundColor = ClearColor;
    self.label1.hidden = YES;
    self.label2.hidden = YES;
    self.label3.hidden = YES;
    
    self.label1.layer.cornerRadius = 9;
    self.label1.layer.masksToBounds = YES;
    self.label2.layer.cornerRadius = 9;
    self.label2.layer.masksToBounds = YES;
    self.label3.layer.cornerRadius = 9;
    self.label3.layer.masksToBounds = YES;
    
    self.label1.backgroundColor = GreenColor;
    self.label2.backgroundColor = GreenColor;
    self.label3.backgroundColor = GreenColor;
    
    if ([model.select isEqualToNumber:@1]) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
    CGFloat selectBtnWidth = 0;
    if (self.selected) {
        selectBtnWidth = 42;
    }
    
    UIColor *color = [HQHelper colorWithHexString:model.color];
    
    if (color) {
        
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.marginView.hidden = NO;
        self.marginView.backgroundColor = color;
        
    }else{
        
        self.layer.borderColor = ClearColor.CGColor;
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
        self.marginView.hidden = YES;
        self.marginView.backgroundColor = ClearColor;
        
    }
    
    
    
    // row1
    TFCustomRowModel *row = model.row;
    
    if (row.row1 && row.row1.count) {
        
        TFFieldNameModel *field = row.row1[0];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = [HQHelper stringWithFieldNameModel:field];
        
        
    }
    
    // row2
    if (row.row2 && row.row2.count) {
        
        self.bgView1W.constant = self.bgView2W.constant = self.bgView3W.constant = (self.width-(self.select?self.titleHeadW.constant:0)-(row.row2.count + 1)*15.0-selectBtnWidth)/row.row2.count;
        for (NSInteger i= 0; i < row.row2.count; i ++) {
            
            TFFieldNameModel *field = row.row2[i];
            if (i == 0 ) {
                self.bgView1.hidden = NO;
                self.bg1Label1.text = field.label;
                self.bg1Label2.text = [HQHelper stringWithFieldNameModel:field];
            
                
            }else if (i == 1){
                
                self.bgView2.hidden = NO;
                self.bg2Label1.text = field.label;
                self.bg2Label2.text = [HQHelper stringWithFieldNameModel:field];
                
            }else{
                
                self.bgView3.hidden = NO;
                self.bg3Label1.text = field.label;
                self.bg3Label2.text = [HQHelper stringWithFieldNameModel:field];
                
            }
        }
    }
    
    // row3
    if (row.row3 && row.row3.count) {
        
        CGFloat maxW = (self.width-(self.select?self.titleHeadW.constant:0)-(row.row3.count + 1)*15.0-selectBtnWidth)/row.row3.count;
        
        for (NSInteger i= 0; i < row.row3.count; i ++) {
            
            TFFieldNameModel *field = row.row3[i];
            
            if ([field.name containsString:@"picklist"] || [field.name containsString:@"multi"] || [field.name containsString:@"mutlipicklist"]){
                
                NSArray *arr = [HQHelper dictionaryWithJsonString:field.value];
                
                if (arr.count == 1) {
                    
                    NSDictionary *ddd = arr[0];
                    field.color = [ddd valueForKey:@"color"];
                }else{
                    field.color = nil;
                }
            }
            
            if (i == 0 ) {
                self.label1.hidden = NO;
                
                if ([HQHelper colorWithHexString:field.color] && ![field.color isEqualToString:@"#FFFFFF"]) {
                    
                    self.label1.backgroundColor = [HQHelper colorWithHexString:field.color];
                    self.label1.textColor = WhiteColor;
                    
                    
                    CGSize size = [HQHelper sizeWithFont:FONT(11) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[NSString stringWithFormat:@"  %@  ",[HQHelper stringWithFieldNameModel:field]]];
                    self.label1.text = [NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]];
                    self.label1W.constant = size.width > maxW ? maxW : size.width;
                    self.label1.textAlignment = NSTextAlignmentCenter;
                }else{
                    
                    self.label1.backgroundColor = ClearColor;
                    self.label1.textColor = ExtraLightBlackTextColor;
                    CGSize size = [HQHelper sizeWithFont:FONT(11) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]]];
                    self.label1.text = [NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]];
                    self.label1W.constant = size.width > maxW ? maxW : size.width + 10;
                    self.label1.textAlignment = NSTextAlignmentLeft;
                }
                
            }else if (i == 1){
                self.label2.hidden = NO;
                
                if ([HQHelper colorWithHexString:field.color] && ![field.color isEqualToString:@"#FFFFFF"]) {
                    
                    self.label2.backgroundColor = [HQHelper colorWithHexString:field.color];
                    self.label2.textColor = WhiteColor;
                    
                    CGSize size = [HQHelper sizeWithFont:FONT(11) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[NSString stringWithFormat:@"  %@  ",[HQHelper stringWithFieldNameModel:field]]];
                    self.label2.text = [NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]];
                    self.label2W.constant = size.width > maxW ? maxW : size.width;
                    self.label2.textAlignment = NSTextAlignmentCenter;
                }else{
                    self.label2.backgroundColor = ClearColor;
                    self.label2.textColor = ExtraLightBlackTextColor;
                    CGSize size = [HQHelper sizeWithFont:FONT(11) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]]];
                    self.label2.text = [NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]];
                    self.label2W.constant = size.width > maxW ? maxW : size.width + 10;
                    self.label2.textAlignment = NSTextAlignmentLeft;
                }
            }else{
                self.label3.hidden = NO;
                
                if ([HQHelper colorWithHexString:field.color] && ![field.color isEqualToString:@"#FFFFFF"]) {
                    
                        
                    self.label3.backgroundColor = [HQHelper colorWithHexString:field.color];
                    self.label3.textColor = WhiteColor;
                    
                    CGSize size = [HQHelper sizeWithFont:FONT(11) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[NSString stringWithFormat:@"  %@  ",[HQHelper stringWithFieldNameModel:field]]];
                    self.label3.text = [NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]];
                    self.label3W.constant = size.width > maxW ? maxW : size.width;
                    self.label3.textAlignment = NSTextAlignmentCenter;
                }else{
                    self.label3.backgroundColor = ClearColor;
                    self.label3.textColor = ExtraLightBlackTextColor;
                    CGSize size = [HQHelper sizeWithFont:FONT(11) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]]];
                    self.label3.text = [NSString stringWithFormat:@"%@",[HQHelper stringWithFieldNameModel:field]];
                    self.label3W.constant = size.width > maxW ? maxW : size.width + 10;
                    self.label3.textAlignment = NSTextAlignmentLeft;
                }
            }
        }
    }
}


+(CGFloat)refreshCustomListCellHeightWithModel:(TFCustomListItemModel *)model{
    
    CGFloat height = 0;
    
    // row1
    TFCustomRowModel *row = model.row;
    
    if (row.row1) {
        
        height += 10 + 20 + 10;
    }
    
    // row2
    if (row.row2) {
        
        height += 30 + 10;
        
    }
    
    // row3
    if (row.row3) {
        
        height += 15 + 10;
    }
   
    return height;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
