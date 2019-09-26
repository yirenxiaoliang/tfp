//
//  HQTFUploadFileView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFUploadFileView.h"
#import "HQRootButton.h"
#import "AlertView.h"

#define CancelBtnHeight 60
#define PlusHeight 10


@interface HQTFUploadFileView ()

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

/** type */
@property (nonatomic, assign) NSInteger type;

/** label */
@property (nonatomic, weak)  UILabel  *titleLable;
/** label */
@property (nonatomic, weak)  UIButton  *cancelBtn;

/** 值 */
@property (nonatomic, copy) ActionParameter parameter;

/**
 * 关闭函数
 */
@property (nonatomic, strong) ActionHandler onDismiss;

/** 一行排列数 */
@property (nonatomic, assign) NSInteger count;


@end


@implementation HQTFUploadFileView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
    //    [self removeFromSuperview];
}

-(instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type{
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *title = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,CancelBtnHeight} text:@"" textColor:ExtraLightBlackTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
        self.titleLable = title;
        [self addSubview:title];
        
        
        UIButton *cancelBtn = [HQHelper buttonWithFrame:(CGRect){0,self.height-CancelBtnHeight,SCREEN_WIDTH,CancelBtnHeight} target:self action:@selector(cancelBtnClicked:)];
        [cancelBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
        [cancelBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FONT(20);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
        [self addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        self.backgroundColor = HexAColor(0xf2f2f2, 1);
        cancelBtn.backgroundColor = WhiteColor;
        
        [self setupBtnsWithType:type];
        
    }
    return self;
}



- (void)cancelBtnClicked:(UIButton *)cancelBtn{
    
    [self dismiss];
}

- (void)setupBtnsWithType:(NSInteger)type{
    self.count = 4;
    switch (type) {
        case 0:
        {
            [self setupMoreHandle];// 任务详情
            self.count = 4;
        }
            break;
        case 1:
        {
            [self setupFile];// 上传文件
            self.count = 4;
        }
            break;
        case 2:
        {
            [self setupFile2];// 3个按钮
            self.count = 4;
        }
            break;
        case 3:
        {
            [self setupFile3];// 文件库
            self.count = 4;
        }
            break;
        case 4:
        {
            [self setupCompanyGroup];// 组织架构
            self.count = 4;
        }
            break;
        case 5:
        {
            [self setupShare];// 分享
            self.count = 4;
        }
            break;
        case 6:
        {
            [self setupNote];// 随手记
            self.count = 4;
        }
            break;
        case 7:
        {
            [self setupAddNote];// 随手记添加笔记
            self.count = 4;
        }
            break;
        case 8:
        {
            [self setupApprovalMore];// 审批详情
            self.count = 4;
        }
            break;
        case 9:
        {
            [self setupFileDetailMore];// 文件详情更多
            self.count = 4;
        }
            break;
        case 10:
        {
            [self setupScheduleDetailMore];// 日程详情更多
            self.count = 4;
        }
            break;
            
        case 11:
        {
            [self setupCustomer];// 客户
            self.count = 4;
        }
            break;
        case 12:
        {
            [self setupCommunication];// 沟通关联
            self.count = 3;
        }
            break;
        case 13:
        {
            [self setupCustom];// 自定义
            self.count = 3;
        }
            break;
            
        default:
            break;
    }
    
    self.type = type;
    
    NSInteger i = (self.buttons.count + (self.count -1))/self.count;
    self.height = CancelBtnHeight * 2 + (SCREEN_WIDTH/self.count + PlusHeight)* i - 10;
}

- (void)setupMoreHandle{
    
    NSArray *title = @[@"发送到聊天",@"共享到微信",@"共享到QQ",@"共享到邮箱",@"编辑任务名称",@"删除任务",@"二维码"];
    NSArray *image = @[@"聊天",@"微信more",@"qq",@"邮箱",@"编辑任务",@"删除",@"二维码"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-30,0.5}];
    sepeView.tag = 0x2233;
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
    
}

- (void)setupFileDetailMore{
    
    NSArray *title = @[@"发送到聊天",@"共享到微信",@"共享到QQ",@"共享到邮箱",@"重命名",@"删除文件",@"二维码"];
    NSArray *image = @[@"聊天",@"微信more",@"qq",@"邮箱",@"编辑任务",@"删除",@"二维码"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-30,0.5}];
    sepeView.tag = 0x2233;
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
    
}

- (void)setupScheduleDetailMore{
    
    NSArray *title = @[@"发送到聊天",@"共享到微信",@"共享到QQ",@"共享到邮箱",@"编辑日程名称",@"删除日程",@"二维码"];
    NSArray *image = @[@"聊天",@"微信more",@"qq",@"邮箱",@"编辑任务",@"删除",@"二维码"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-30,0.5}];
    sepeView.tag = 0x2233;
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
    
}

- (void)setupApprovalMore{
    
    NSArray *title = @[@"发送到聊天",@"共享到微信",@"共享到QQ",@"共享到邮箱"];
    NSArray *image = @[@"聊天",@"微信more",@"qq",@"邮箱"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


- (void)setupFile{
    
    NSArray *title = @[@"发语音",@"拍照上传",@"手机相册",@"文件库选"];
    NSArray *image = @[@"语音more",@"拍照",@"相册",@"文件库more"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)setupFile2{
    
    NSArray *title = @[@"发语音",@"拍照上传",@"手机相册"];
    NSArray *image = @[@"语音more",@"拍照",@"相册"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/3;
    HQLog(@"buttonW===%f",buttonW);
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)setupCustom{
    
    NSArray *title = @[@"拍照上传",@"手机相册"];
    NSArray *image = @[@"拍照",@"相册"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)setupFile3{
    
    NSArray *title = @[@"新建文件夹",@"发语音",@"拍照上传",@"手机相册"];
    NSArray *image = @[@"文件库more",@"语音more",@"拍照",@"相册"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)setupCompanyGroup{
    
    NSArray *title = @[@"添加成员",@"二维码邀请",@"部门管理",@"成员管理"];
    NSArray *image = @[@"添加成员",@"二维码",@"部门contact",@"员工管理"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (void)setupShare{
    
    NSArray *title = @[@"微信朋友圈",@"微信好友",@"手机QQ",@"QQ空间"];
    NSArray *image = @[@"朋友圈",@"微信more",@"qq",@"QQ空间"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (void)setupNote{
    
    NSArray *title = @[@"新建笔记本",@"新建笔记",@"发语音",@"拍照上传",@"相册上传"];
    NSArray *image = @[@"文件库more",@"新建笔记",@"语音more",@"拍照",@"相册"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-30,0.5}];
    sepeView.tag = 0x2233;
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
}

- (void)setupAddNote{
    
    NSArray *title = @[@"新建笔记",@"发语音",@"拍照上传",@"相册上传"];
    NSArray *image = @[@"新建笔记",@"语音more",@"拍照",@"相册"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}


- (void)setupCustomer{
    
    NSArray *title = @[@"跟进沟通",@"拨打电话",@"查看位置",@"发表评论",@"新增订单",@"新增报价",@"添加任务",@"添加日程",@"发起审批",@"添加投诉",@"发起投票",@"分享"];
    NSArray *image = @[@"跟进沟通0",@"拨打电话0",@"查看位置",@"发表评论",@"新增订单",@"新增报价",@"添加任务",@"添加日程",@"发起审批",@"发起投诉",@"发起投票",@"分享"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.wordScale = 0.4;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)setupCommunication{
    
    NSArray *title = @[@"发起审批",@"添加任务",@"添加日程"];
    NSArray *image = @[@"审批",@"任务",@"日程"];
    
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < title.count; i++) {
        
        HQRootButton *button = [self rootButtonWithTitle:title[i] imageName:image[i]];
        button.scale = 0.7;
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)moreButtonClick:(UIButton *)button{
    
    NSInteger tag = button.tag - 0x135;
    
    if (self.parameter) {
        self.parameter(@(tag));
    }
    [self dismiss];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLable.frame = CGRectMake(0, 0, SCREEN_WIDTH, CancelBtnHeight);
    self.cancelBtn.frame = CGRectMake(0, self.height - CancelBtnHeight, SCREEN_WIDTH, CancelBtnHeight);
    
    CGFloat buttonW = SCREEN_WIDTH/self.count;
    CGFloat buttonH = buttonW + PlusHeight;
    
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        
        NSInteger row = i / self.count;
        NSInteger col = i % self.count;
        
        UIButton *button = self.buttons[i];
        button.frame = CGRectMake(col * buttonW , row * buttonH + CancelBtnHeight - 10, buttonW, buttonH);
    
    }
    
    UIView *sepeView = [self viewWithTag:0x2233];
    
    if (sepeView) {
        
        sepeView.frame = (CGRect){15,CancelBtnHeight + buttonW+PlusHeight -10,SCREEN_WIDTH-30,0.5};
    }
    
}


/** 私有化-创建按钮 */
- (HQRootButton *)rootButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    HQRootButton *button = [HQRootButton rootButton];
    button.titleLabel.font = FONT(12);
    button.tipLable.hidden = YES;
    button.userInteractionEnabled = YES;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [button setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    return button;
}

/**
 * 提示框
 * @param title 标题
 * @param msg 内容
 * @param leftTitle 左按钮标题
 * @param rightTitle 右按钮标题
 * @param onLeftTouched 左按钮被点击
 * @param onRightTouched 右按钮被点击
 */
+ (void) showAlertView:(NSString *)title
              withType:(NSInteger)type
       parameterAction:(ActionParameter)parameter{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x1234554321] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x1234554321;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    // 告警窗体
    HQTFUploadFileView *view = [[HQTFUploadFileView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT,SCREEN_WIDTH,100} withType:type];
    view.top = SCREEN_HEIGHT - view.height;
    view.titleLable.text = title;
    view.parameter = parameter;
    view.onDismiss = ^(void) {
        
        [UIView animateWithDuration:0.25 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    };
    
    [bgView addSubview:view];
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    // 添加手势
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    //    [bgView addGestureRecognizer:tap];
    
    //    UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRect){(SCREEN_WIDTH - 74) * 0.5,SCREEN_HEIGHT * 0.5 - 85 - 37, 74,74 }];
    //    [image setImage:[UIImage imageNamed:@"灯泡"]];
    //    image.backgroundColor = RGBColor(0x00, 0xbb, 0x9d);
    //    image.contentMode = UIViewContentModeCenter;
    //    image.layer.cornerRadius = image.width * 0.5;
    //    image.layer.masksToBounds = YES;
    //    [bgView addSubview:image];
    
    [window addSubview:bgView];
    
    // 显示窗体
    [window makeKeyAndVisible];
}

+ (void)tapBgView:(UIButton *)tap{
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.25 animations:^{
        [window viewWithTag:0x1234554321].alpha = 0;
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x1234554321] removeFromSuperview];
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
