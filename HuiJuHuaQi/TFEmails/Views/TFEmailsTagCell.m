//
//  TFEmailsTagCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsTagCell.h"
#import "SZTextView.h"

@interface TFEmailsTagCell ()

@property (nonatomic, strong) SZTextView *textView;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation TFEmailsTagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLab = [UILabel initCustom:CGRectZero title:@"收件人:" titleColor:kUIColorFromRGB(0x2D2D00) titleFont:14 bgColor:ClearColor];
        
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLab];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.height.equalTo(@20);
        }];
        
        
        TFEmailsAccountTagView *accountTagView = [[TFEmailsAccountTagView alloc] init];
        accountTagView.backgroundColor = ClearColor;
        [self.contentView addSubview:accountTagView];
        self.accountTagView = accountTagView;
        self.accountTagView.frame = CGRectZero;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [accountTagView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.titleLab.mas_right);
//            make.top.equalTo(self.contentView).with.offset(5);
//            make.bottom.equalTo(self.contentView).with.offset(-5);
//            make.right.equalTo(self.contentView).with.offset(-15);
//            
//        }];
        
        self.textView = [[SZTextView alloc] init];
        
        self.textView.placeholder = @"请输入";
        
        [self.contentView addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(@76);
            make.top.equalTo(@15);
            make.width.equalTo(@(SCREEN_WIDTH-115));
        }];
    }
    return self;
}


+ (instancetype)emailsTagCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFEmailsTagCell";
    TFEmailsTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[TFEmailsTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
