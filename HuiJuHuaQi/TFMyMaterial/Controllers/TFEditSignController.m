//
//  TFEditSignController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEditSignController.h"
#import "HQSelectTimeCell.h"
#import "TFEmotionCell.h"
#import "TFManyLableCell.h"
#import "TFEditEmotionController.h"

#import "TFPeopleBL.h"

@interface TFEditSignController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQBLDelegate,TFEmotionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFPeopleBL *peopleBL;

@property (nonatomic, strong) UIImageView *headImg;

@end

@implementation TFEditSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    self.headImg = [[UIImageView alloc] init];
    
    [self setupTableView];
}

- (void)setNavi {

    self.navigationItem.title = @"个人签名";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(save) text:@"保存" textColor:GreenColor];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
//        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        TFEmotionCell *cell = [TFEmotionCell EmotionCellWithTableView:tableView];
        
//        cell.arrow.hidden = YES;
//        cell.timeTitle.text = @"心情符号";
        
//        cell.time.text = self.emoStr;
        [cell refreshEmotionCellWithData:self.emoStr];
        cell.delegate = self;
//        self.headImg.layer.cornerRadius = 20;
//        self.headImg.layer.masksToBounds = YES;
//        self.headImg.frame = CGRectMake(101, 10, 40, 40);
//        self.headImg.contentMode = UIViewContentModeScaleToFill;
//        self.headImg.image = IMG([self.emoNum description]);
//        [cell.contentView addSubview:self.headImg];
//        self.headImg.tag = 0x123;
        
        return cell;
    }
    else {
    
        TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
        
        cell.requireLabel.hidden = NO;
        
        cell.titleLab.text = @"签名内容";
        cell.textVeiw.placeholder = @"说说你的工作状态";
        cell.textVeiw.text = self.sign;
        cell.textVeiw.delegate = self;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFEditEmotionController *emo = [[TFEditEmotionController alloc] init];
    
    emo.refresh = ^(id parameter) {
        
        self.emoNum = [parameter valueForKey:@"image"];
        self.emoStr = [parameter valueForKey:@"emotion"];
        
        [self.tableView reloadData];
    };

    
    [self.navigationController pushViewController:emo animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 64;
    }
    return 170;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
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
#pragma mark - TFEmotionCellDelegate
-(void)emotionCellDidClearBtn{
    self.emoStr = nil;
    [self.tableView reloadData];
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    return YES;
    
}


- (void)textViewDidChange:(UITextView *)textView {

    self.sign = textView.text;
}


#pragma mark 保存
- (void)save {

    if ([self.sign isEqualToString:@""] || self.sign == nil) {
        
        [MBProgressHUD showError:@"签名内容不能为空" toView:self.view];
        return;
    }
    if (self.sign.length > 12) {
        
        [MBProgressHUD showError:@"不能超过12个字！" toView:self.view];
        return;
    }
    
    self.peopleBL  = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    TFEmployModel *model = [[TFEmployModel alloc] init];
    
    model.sign = self.sign;
    model.mood = self.emoStr;
    
    [self.peopleBL requestUpdateEmployeeWithEmployee:model];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_updateEmployee) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:self.sign forKey:@"sign"];
        if (self.emoStr) {
            [dic setObject:self.emoStr forKey:@"emotion"];
        }
        
        if (self.refreshAction) {
            
            self.refreshAction(dic);
        }
        
        [MBProgressHUD showError:@"保存成功！" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
