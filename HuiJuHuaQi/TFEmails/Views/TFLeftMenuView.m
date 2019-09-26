//
//  TFLeftMenuView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLeftMenuView.h"
#import "HQTFTwoLineCell.h"
#import "TFEmailUnreadModel.h"

#define MarginWidth 55
#define Color RGBColor(0x3d, 0xb8, 0xc1)
#define OPEN 0

@interface TFLeftMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, strong) NSMutableArray *unreadCounts;


@property (nonatomic ,strong) NSNumber *boxId;

@end

@implementation TFLeftMenuView



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame unreads:(NSMutableArray *)unreads
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.unreadCounts = unreads;
        
        [self setupChild];
    }
    return self;
}



- (void)setupChild{
    
//    self.titles = @[@"收件箱",@"未读",@"已发送",@"草稿箱",@"已删除",@"垃圾箱",@"返回首页"];
//    self.imgs = @[@"邮件收件箱",@"邮件未读",@"邮件已发送",@"邮件草稿箱",@"邮件已删除",@"邮件垃圾箱",@"邮件返回首页"];
    self.titles = @[@"收件箱",@"未读",@"已发送",@"草稿箱",@"已删除",@"垃圾箱"];
    self.imgs = @[@"邮件收件箱",@"邮件未读",@"邮件已发送",@"邮件草稿箱",@"邮件已删除",@"邮件垃圾箱"];
    
    UIView *bgview = [[UIView alloc] initWithFrame:(CGRect){0,0,MarginWidth,SCREEN_HEIGHT}];
    [self addSubview:bgview];
    
    UIView *headView = [[UIView alloc] initWithFrame:(CGRect){MarginWidth,0,SCREEN_WIDTH-MarginWidth,NaviHeight}];
    headView.backgroundColor = WhiteColor;
    [self addSubview:headView];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.frame = CGRectMake(headView.width-20-30, 32+TopM, 20, 20);
    imgV.image = IMG(@"邮件导航");
    [headView addSubview:imgV];
    imgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
    [imgV addGestureRecognizer:tapImg];
    
    
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"邮件";
    titleView.textColor = BlackTextColor;
    titleView.font = BFONT(18);
    [titleView sizeToFit];
    [headView addSubview:titleView];
//    titleView.center = CGPointMake(headView.width/5, 42);
    titleView.frame = CGRectMake(30, 32+TopM, headView.width-50, 20);
    
//    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(imgV.mas_right).offset(16);
//        make.centerY.equalTo(imgV.mas_centerY);
//        make.height.equalTo(@22);
//    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
    [bgview addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [bgview addGestureRecognizer:pan];
    
    [self setupTableView];
    
    self.backgroundColor = RGBAColor(0, 0, 0, 0);
    self.layer.masksToBounds = NO;
}

- (void)refreshLeftmenuViewWithBoxId:(NSNumber *)boxId {

    self.boxId = boxId;
    
    [self.tableView reloadData];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(MarginWidth, NaviHeight, SCREEN_WIDTH-MarginWidth, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    [cell.titleImage setImage:IMG(_imgs[indexPath.row]) forState:UIControlStateNormal];
    cell.topLabel.text = _titles[indexPath.row];
    cell.type = TwoLineCellTypeOne;
    cell.titleImageWidth = 0;
    
    cell.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    
    if (indexPath.row == 0 && [self.boxId isEqualToNumber:@1]) {
        
        cell.backgroundColor = kUIColorFromRGB(0xEBEDF0);
    }
    else if (indexPath.row == 1 && [self.boxId isEqualToNumber:@6]) {
    
        cell.backgroundColor = kUIColorFromRGB(0xEBEDF0);
    }
    else if (indexPath.row == 2 && [self.boxId isEqualToNumber:@2]) {
        
        cell.backgroundColor = kUIColorFromRGB(0xEBEDF0);
    }
    else if (indexPath.row == 3 && [self.boxId isEqualToNumber:@3]) {
        
        cell.backgroundColor = kUIColorFromRGB(0xEBEDF0);
    }
    else if (indexPath.row == 4 && [self.boxId isEqualToNumber:@4]) {
        
        cell.backgroundColor = kUIColorFromRGB(0xEBEDF0);
    }
    else if (indexPath.row == 5 && [self.boxId isEqualToNumber:@5]) {
        
        cell.backgroundColor = kUIColorFromRGB(0xEBEDF0);
    }

    
    NSString *count = @"";
    
    if (self.unreadCounts.count > 0) {
        
        for (TFEmailUnreadModel *model in self.unreadCounts) {
            
            if (indexPath.row == 0) {
                
                if ([model.mail_box_id isEqualToNumber:@1]) {
                    
                    count = [model.count stringValue];
                }

            }
            else if (indexPath.row == 1) {
                
                if ([model.mail_box_id isEqualToNumber:@6]) {
                    
                    count = [model.count stringValue];
                }

            }

            else if (indexPath.row == 3) {
                
                if ([model.mail_box_id isEqualToNumber:@3]) {
                    
                    count = [model.count stringValue];
                }
            }

        }
    }
    else {
        
        if (indexPath.row == 0) {
            
                count = @"0";
        }
        if (indexPath.row == 1) {
            
            count = @"0";
        }
        if (indexPath.row == 3) {
            
            count = @"0";
        }
    }
    
    if (indexPath.row < 2) {
        [cell.enterImage setTitle:count forState:UIControlStateNormal];
        [cell.enterImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        [cell.enterImage setBackgroundColor:GreenColor];
        cell.enterImage.layer.cornerRadius = 15;
        cell.enterImage.layer.masksToBounds = YES;
        cell.enterW.constant = cell.enterH.constant = 30;
        
    }else{
        [cell.enterImage setTitle:count forState:UIControlStateNormal];
        [cell.enterImage setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
        [cell.enterImage setBackgroundColor:ClearColor];
        cell.enterImage.layer.cornerRadius = 0;
        cell.enterImage.layer.masksToBounds = YES;
    }
    if (self.imgs.count - 1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(fileterViewCellDid:title:)]) {
        
        [self.delegate fileterViewCellDid:indexPath.row title:self.titles[indexPath.row]];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.left = SCREEN_WIDTH;
        self.backgroundColor = RGBAColor(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 49;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tapBgView{
    
    if ([self.delegate respondsToSelector:@selector(filterViewDidClicked:)]) {
        [self.delegate filterViewDidClicked:NO];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:pan.view];
    
    //    HQLog(@"=%@=",NSStringFromCGPoint(point));
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.left = point.x;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.left += point.x-self.left;
            
            if (self.left <= 0) {
                self.left = 0.0;
            }else if (self.left >= SCREEN_WIDTH){
                self.left = SCREEN_WIDTH;
            }
            
            CGFloat alpha = self.left/(SCREEN_WIDTH-MarginWidth);
            HQLog(@"=======%f=====",0.5-0.5*alpha);
            
            self.backgroundColor = RGBAColor(0, 0, 0, 0.5-0.5*alpha);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.left > MarginWidth) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.backgroundColor = RGBAColor(0, 0, 0, 0);
                    self.left = SCREEN_WIDTH;
                }completion:^(BOOL finished) {
                    
                    [self tapBgView];
                }];
            }else{
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.backgroundColor = RGBAColor(0, 0, 0, 0.5);
                    self.left = 0;
                }];
            }
        }
            break;
            
        default:
            break;
    }
    
}


@end
