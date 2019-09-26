//
//  TFFilePathView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFilePathView.h"



@implementation TFFilePathModel

@end

@interface TFFilePathView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) NSArray *models;

@end

@implementation TFFilePathView


- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<TFFilePathModel *> *)models{
    
    if (self = [super initWithFrame:frame]) {
        
        _models = models;
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (TFFilePathModel *model in models) {
            
            [arr addObject:model.name];
        }
        
        _arr = arr;
        
        [self setupTableView];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {

    if (self = [super initWithFrame:frame]) {
        
        _arr = titleArr;
        
        [self setupTableView];
    }
    return self;
}

- (void)setupView {

    for (int i=0; i< _arr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectZero;
        [btn setTitle:_arr[i] forState:UIControlStateNormal];
        
        [self addSubview:btn];
    }
    
    //CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) titleStr:@""];
    
    
}



#pragma mark - 初始化tableView

- (void)setupTableView {

    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.transform  = CGAffineTransformMakeRotation(-M_PI/2);
    _tableView.frame = CGRectMake(15, 0, self.width-30, self.height);
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self addSubview:_tableView];
    _tableView.tag = 0x22222;
    
    self.backgroundColor = WhiteColor;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *ID = @"filePathCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    [[cell.contentView viewWithTag:0x123] removeFromSuperview];
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *title;
    NSMutableAttributedString *titleAttr;
    UIColor *color;
    
    if (indexPath.row<_arr.count-1) {
        
        title = [NSString stringWithFormat:@"%@  >",_arr[indexPath.row]];
        color = GreenColor;
        titleAttr = [[NSMutableAttributedString alloc] initWithString:title];
        [titleAttr addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(0, title.length)];
        [titleAttr addAttribute:NSForegroundColorAttributeName value:GreenColor range:NSMakeRange(0, title.length)];
        [titleAttr addAttribute:NSForegroundColorAttributeName value:GrayTextColor range:[title rangeOfString:@"  >"]];
        
    }
    else {
    
        title = _arr[indexPath.row];
        color = GrayTextColor;
        titleAttr = [[NSMutableAttributedString alloc] initWithString:title];
        [titleAttr addAttribute:NSForegroundColorAttributeName value:GrayTextColor range:NSMakeRange(0, title.length)];
        [titleAttr addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(0, title.length)];
    }
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) titleStr:title];
    
    
    UILabel *lab = [UILabel initCustom:CGRectMake(0, 0, size.width, self.height) title:title titleColor:color titleFont:14 bgColor:ClearColor];
    lab.tag = 0x123;
    lab.attributedText = titleAttr;
    [cell.contentView addSubview:lab];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(selectFilePath:)]) {
        
        [self.delegate selectFilePath:indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectFilePathWithModel:)]) {
        [self.delegate selectFilePathWithModel:self.models[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title;
    
    if (indexPath.row<_arr.count-1) {
        
        title = [NSString stringWithFormat:@"%@  > ",_arr[indexPath.row]];
    }
    else {
        
        title = _arr[indexPath.row];
    }
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) titleStr:title];
    
    return size.width;
}

@end
