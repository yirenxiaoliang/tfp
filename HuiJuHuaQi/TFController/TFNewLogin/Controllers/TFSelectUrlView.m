//
//  TFSelectUrlView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/22.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectUrlView.h"

@interface TFEnvironmentModel : NSObject

/** 接口IP地址 */
@property (nonatomic, copy) NSString *baseUrl;
/** 服务器地址 */
@property (nonatomic, copy) NSString *serverAddress;
/** IM地址 */
@property (nonatomic, copy) NSString *iMAddress;
/** 环境 */
@property (nonatomic, copy) NSString *urlEnvironment;

@end


@implementation TFEnvironmentModel

@end


@interface TFSelectUrlView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)  UITableView *tableView;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, copy) ActionParameter action;
@property (nonatomic, copy) ActionHandler cancel;

@end

@implementation TFSelectUrlView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupTableView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
        NSArray *urls = @[baseUrl,baseUrl181,baseUrl183,baseUrl186,baseUrl57,baseUrl60,baseUrl172,baseUrl202];
        NSArray *environments = @[environment,environment181,environment183,environment186,environment57,environment60,environment172,environment202];
        
        for (NSInteger i = 0; i < urls.count; i++) {
            TFEnvironmentModel *model = [[TFEnvironmentModel alloc] init];
            [_datas addObject:model];
            model.baseUrl = urls[i];
            model.serverAddress = serverAddress;
            if (i == 5) {
                model.serverAddress = serverAddressNew;
            }
            model.iMAddress = imServerAddress9006;
            if (i == 0) {
                model.iMAddress = imServerAddress;
            }
            model.urlEnvironment = environments[i];
        }
    }
    return _datas;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.datas.count * 44) style:UITableViewStylePlain];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"indexPathCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    TFEnvironmentModel *model = self.datas[indexPath.row];
    cell.textLabel.text = model.baseUrl;
    if ([self.url isEqualToString:model.baseUrl]) {
        cell.textLabel.textColor = GreenColor;
    }else{
        cell.textLabel.textColor = BlackTextColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    
    TFEnvironmentModel *model = self.datas[indexPath.row];
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.baseUrl = model.baseUrl;
    app.serverAddress = model.serverAddress;
    app.iMAddress = model.iMAddress;
    app.urlEnvironment = model.urlEnvironment;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:model.baseUrl forKey:SaveInputUrlRecordKey];
    [userDefault synchronize];
    
    self.url = model.baseUrl;
    
    if (self.action) {
        self.action(self.url);
    }
    if (self.cancel) {
        self.cancel();
    }
    [self.tableView reloadData];
}

+(void)selectUrlViewWithUrl:(NSString *)url sure:(ActionParameter)sure{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x98765;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    TFSelectUrlView *view = [[TFSelectUrlView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44 * 8)];
    view.url = url;
    __weak UIView *weakView = view;
    view.action = sure;
    view.cancel = ^{
        [UIView animateWithDuration:0.35 animations:^{
            weakView.y = SCREEN_HEIGHT;
            bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
        
    };
    [view.tableView reloadData];
    view.tag = 0x11111;
    [bgView addSubview:view];
    [window addSubview:bgView];
    // 动画显示
    [UIView animateWithDuration:0.35 animations:^{
        view.y = SCREEN_HEIGHT -(44 * 8);
        bgView.alpha = 1;
        
    }];
    // 显示窗体
    [window makeKeyAndVisible];
    
}

+ (void)tapBgView:(UIButton *)tap{
    
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.35 animations:^{
        [window viewWithTag: 0x11111].y = SCREEN_HEIGHT;
        [window viewWithTag:0x98765].alpha = 0;
        
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x98765] removeFromSuperview];
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
