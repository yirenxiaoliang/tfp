//
//  TFEmailsAddHeadView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsAddHeadView.h"
#import "TFEmailPersonModel.h"
@interface TFEmailsAddHeadView ()<TFEmailNameViewDelegate>

@property (nonatomic, assign) float rHeight;

@property (nonatomic, assign) float cHeight;

@property (nonatomic, assign) float sHeight;

@end

@implementation TFEmailsAddHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self=[super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {


#pragma mark ---------发件
    self.sendView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.sendView.backgroundColor = LightGrayTextColor;
    
    [self addSubview:self.sendView];
    
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction)];
    
    [self.sendView addGestureRecognizer:sendTap];
    
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@50);
        
    }];
    
    
    self.requireLab = [UILabel initCustom:CGRectZero title:@"*" titleColor:kUIColorFromRGB(0xF42F2F) titleFont:14 bgColor:ClearColor];

    [self.sendView addSubview:self.requireLab];
    
    [self.requireLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@7);
        make.top.equalTo(@15);
        make.width.equalTo(@8);
        make.height.equalTo(@20);
        
    }];
    
    
    self.titleLab = [UILabel initCustom:CGRectZero title:@"发件人" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
    
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    
    [self.sendView addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.requireLab.mas_right).offset(0);
        make.top.equalTo(@15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        
    }];
    
    self.nextImgV = [[UIImageView alloc] init];
    
    
    self.nextImgV.contentMode = UIViewContentModeScaleAspectFit;
    
    self.nextImgV.image = IMG(@"下一级浅灰");
    
    [self.sendView addSubview:self.nextImgV];
    
    [self.nextImgV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(@(-10));
        make.top.equalTo(@16);
        make.width.height.equalTo(@18);
        
    }];
    
    self.sendLab = [UILabel initCustom:CGRectZero title:@"" titleColor:BlackTextColor titleFont:15 bgColor:ClearColor];
    self.sendLab.textAlignment = NSTextAlignmentLeft;
    [self.sendView addSubview:self.sendLab];
    
    [self.sendLab mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.titleLab.mas_right).offset(10);
        make.top.equalTo(@15);
        make.right.equalTo(self.nextImgV.mas_left).offset(-10);
        make.height.equalTo(@22);
        
    }];
    
    self.line1 = [UILabel initCustom:CGRectZero title:@"" titleColor:nil titleFont:10 bgColor:CellSeparatorColor];
    
    [self.sendView addSubview:self.line1];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.left.equalTo(@15);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH-15));
        make.height.equalTo(@(0.5));
        
    }];
    

#pragma mark ---------收件
    self.receiveView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.receiveView.backgroundColor = LightTextColor;
    
    [self addSubview:self.receiveView];
    
    [self.receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@0);
        make.top.equalTo(self.sendView.mas_bottom).offset(0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@50);
        
    }];
    
    self.receiveLab = [UILabel initCustom:CGRectZero title:@"*" titleColor:kUIColorFromRGB(0xF42F2F) titleFont:14 bgColor:ClearColor];
    
    
    
    [self.receiveView addSubview:self.receiveLab];
    
    [self.receiveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@7);
        make.top.equalTo(@15);
        make.width.equalTo(@8);
        make.height.equalTo(@20);
        
    }];
    
    
    self.titleLab2 = [UILabel initCustom:CGRectZero title:@"收件人" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
    
    self.titleLab2.textAlignment = NSTextAlignmentLeft;
    
    [self.receiveView addSubview:self.titleLab2];
    
    [self.titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.requireLab.mas_right).offset(0);
        make.top.equalTo(@15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        
    }];
    
    
    
    
    self.addReceiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addReceiveBtn.frame = CGRectZero;
    
    [self.addReceiveBtn addTarget:self action:@selector(addContactsAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addReceiveBtn.tag = 101;
    
    [self.addReceiveBtn setImage:IMG(@"添加收件人") forState:UIControlStateNormal];
    
    [self.receiveView addSubview:self.addReceiveBtn];
    
    [self.addReceiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-14));
        make.bottom.equalTo(@(-14));
        make.width.height.equalTo(@22);
        
    }];

    
    
    self.oneEditView = [[TFEmailNameView alloc] initWithFrame:CGRectZero];
    
    self.oneEditView.delegate = self;
    self.oneEditView.type = 1;
    
    [self.receiveView addSubview:self.oneEditView];
    
    [self.oneEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLab2.mas_right).offset(10);
        make.right.equalTo(self.addReceiveBtn.mas_left).offset(-10);
        make.top.equalTo(@0);
        make.height.greaterThanOrEqualTo(@22);
        
    }];

    self.line2 = [UILabel initCustom:CGRectZero title:@"" titleColor:nil titleFont:10 bgColor:CellSeparatorColor];
    
    [self.receiveView addSubview:self.line2];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH-15));
        make.height.equalTo(@(0.5));
        
    }];

    
    
#pragma mark --------抄送
    /**   +++++++++++++++++++++++++++ 抄送人  +++++++++++++++++++++++++++++++  */
    
    self.copyerView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.copyerView.backgroundColor = LightGrayTextColor;
    
    [self addSubview:self.copyerView];
    
    [self.copyerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.receiveView.mas_bottom).offset(0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@50);
        
    }];
    
    
    self.titleLab3 = [UILabel initCustom:CGRectZero title:@"抄送人" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
    
    self.titleLab3.textAlignment = NSTextAlignmentLeft;
    
    [self.copyerView addSubview:self.titleLab3];
    
    [self.titleLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        
    }];
    
    
    
    
    self.addCopyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addCopyerBtn.frame = CGRectZero;
    [self.addCopyerBtn addTarget:self action:@selector(addContactsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addCopyerBtn setImage:IMG(@"添加收件人") forState:UIControlStateNormal];
    self.addCopyerBtn.tag = 102;
    
    [self.copyerView addSubview:self.addCopyerBtn];
    
    [self.addCopyerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-14));
        make.bottom.equalTo(@(-14));
        make.width.height.equalTo(@22);
        
    }];
    
    
    
    self.twoEditView = [[TFEmailNameView alloc] initWithFrame:CGRectZero];
    
    self.twoEditView.delegate = self;
    self.twoEditView.type = 2;
    
    [self.copyerView addSubview:self.twoEditView];
    
    [self.twoEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLab3.mas_right).offset(10);
        make.right.equalTo(self.addCopyerBtn.mas_left).offset(-10);
        make.top.equalTo(@0);
        make.height.greaterThanOrEqualTo(@22);
        
    }];

    self.line3 = [UILabel initCustom:CGRectZero title:@"" titleColor:nil titleFont:10 bgColor:CellSeparatorColor];
    
    [self.copyerView addSubview:self.line3];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH-15));
        make.height.equalTo(@(0.5));
        
    }];
    
    
#pragma mark --------密送
    
    self.secreterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.secreterView.backgroundColor = LightGrayTextColor;
    
    [self addSubview:self.secreterView];
    
    [self.secreterView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.copyerView.mas_bottom).offset(0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@50);
        
    }];
    
    
    self.titleLab4 = [UILabel initCustom:CGRectZero title:@"密送人" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
    
    self.titleLab4.textAlignment = NSTextAlignmentLeft;
    
    [self.secreterView addSubview:self.titleLab4];
    
    [self.titleLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        
    }];
    
    
    
    
    self.addSecreterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addSecreterBtn.frame = CGRectZero;
    [self.addSecreterBtn addTarget:self action:@selector(addContactsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addSecreterBtn setImage:IMG(@"添加收件人") forState:UIControlStateNormal];
    self.addSecreterBtn.tag = 103;
    
    [self.secreterView addSubview:self.addSecreterBtn];
    
    [self.addSecreterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-14));
        make.bottom.equalTo(@(-14));
        make.width.height.equalTo(@22);
        
    }];
    
    
    
    self.threeEditView = [[TFEmailNameView alloc] initWithFrame:CGRectZero];
    
    self.threeEditView.delegate = self;
    self.threeEditView.type = 3;
    
    [self.secreterView addSubview:self.threeEditView];
    
    [self.threeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLab4.mas_right).offset(10);
        make.right.equalTo(self.addSecreterBtn.mas_left).offset(-10);
        make.top.equalTo(@0);
        make.height.greaterThanOrEqualTo(@22);
        
    }];
    
    self.line4 = [UILabel initCustom:CGRectZero title:@"" titleColor:nil titleFont:10 bgColor:CellSeparatorColor];
    
    [self.secreterView addSubview:self.line4];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH-15));
        make.height.equalTo(@(0.5));
        
    }];

}


#pragma mark TFEmailsEditViewDelegate
- (void)editViewTextWithArray:(NSMutableArray *)textArr type:(NSInteger)type{

    if ([self.delegate respondsToSelector:@selector(headViewContents:type:)]) {
        
        [self.delegate headViewContents:textArr type:type];
    }
}

- (void)editViewHeight:(float)height type:(NSInteger)type {

    if (height <= 50) {
        height = 50;
    }
    
    switch (type) {
        case 1:
        {
        
            self.rHeight = height;
            [self.oneEditView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.titleLab2.mas_right).offset(10);
                make.right.equalTo(self.addReceiveBtn.mas_left).offset(-10);
                make.top.equalTo(@14);
                make.height.greaterThanOrEqualTo(@(height));
                
            }];
            
            [self.receiveView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@0);
                make.top.equalTo(self.sendView.mas_bottom).offset(0);
                make.width.equalTo(@(SCREEN_WIDTH));
                make.height.equalTo(@(height));
                
            }];
        }
            break;
        case 2:
        {
            self.cHeight = height;
            [self.twoEditView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.titleLab3.mas_right).offset(10);
                make.right.equalTo(self.addCopyerBtn.mas_left).offset(-10);
                make.top.equalTo(@14);
                make.height.greaterThanOrEqualTo(@(height));
                
            }];
            
            [self.copyerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@0);
                make.top.equalTo(self.receiveView.mas_bottom).offset(0);
                make.width.equalTo(@(SCREEN_WIDTH));
                make.height.equalTo(@(height));
                
            }];
            
        }
            break;
        case 3:
        {
            self.sHeight = height;
            [self.threeEditView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.titleLab4.mas_right).offset(10);
                make.right.equalTo(self.addSecreterBtn.mas_left).offset(-10);
                make.top.equalTo(@14);
                make.height.greaterThanOrEqualTo(@(height));
                
            }];
            
            [self.secreterView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@0);
                make.top.equalTo(self.copyerView.mas_bottom).offset(0);
                make.width.equalTo(@(SCREEN_WIDTH));
                make.height.equalTo(@(height));
                
            }];
            
        }
            break;
        default:
            break;
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(headViewHeight:)]) {
        
        [self.delegate headViewHeight:self.rHeight+self.cHeight+self.sHeight];
    }
}

#pragma mark 事件
- (void)selectAction {

    if ([self.delegate respondsToSelector:@selector(selectSenderClicked)]) {
        
        [self.delegate selectSenderClicked];
    }
}

- (void)addContactsAction:(UIButton*)button {

    NSInteger type = button.tag-100;
    if ([self.delegate respondsToSelector:@selector(addEmailContactsClicked:)]) {
        
        [self.delegate addEmailContactsClicked:type];
    }
}

- (void)fromSelectContacts:(NSString *)text type:(NSInteger)type name:(NSString *)name{

    TFEmailPersonModel *model = [[TFEmailPersonModel alloc] init];
    model.mail_account = text;
    model.employee_name = name;
//    NSString *str = @"";
//    if (name && text && ![name isEqualToString:@""] && ![text isEqualToString:@""]) {
//        str = [NSString stringWithFormat:@"%@%@",name,text];
//    }else if (name && ![name isEqualToString:@""]){
//        str = name;
//    }else if (text && ![text isEqualToString:@""]){
//        str = text;
//    }
    
    if (type == 1) {
        
//        self.oneEditView.isSelect = YES;
//        //    [self.oneEditView textFieldShouldReturn:textField];
//        self.oneEditView.name = name;
//
//        [self.oneEditView createTextField:text];
        [self.oneEditView addPeoples:@[model]];
        
    }
    else if (type == 2) {
    
//        self.twoEditView.isSelect = YES;
//        //    [self.oneEditView textFieldShouldReturn:textField];
//        [self.twoEditView createTextField:text];
        
        [self.twoEditView addPeoples:@[model]];
        
    }
    else if (type == 3) {
    
//        self.threeEditView.isSelect = YES;
//        //    [self.oneEditView textFieldShouldReturn:textField];
//        [self.threeEditView createTextField:text];
        
        [self.threeEditView addPeoples:@[model]];
        
    }
    
}

@end
