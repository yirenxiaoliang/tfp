//
//  HQTFProjectDescController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectDescController.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQTFMorePeopleCell.h"
#import "TFCompanyGroupController.h"
#import "IQKeyboardManager.h"

@interface HQTFProjectDescController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

/**  UITableView *tableView */
@property (nonatomic, weak)  UITableView *tableView;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;


@end

@implementation HQTFProjectDescController

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    if (!self.descString) {
        self.descString = @"";
    }
}
#pragma mark - Navigation
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    if (self.type == 0) {
        self.navigationItem.title = @"项目名称";
    }
    if (self.type == 1) {
        self.navigationItem.title = @"项目描述";
    }
    if (self.type == 2) {
        self.navigationItem.title = @"新建分类";
    }
    if (self.type == 3) {
        self.navigationItem.title = @"任务名称";
    }
    if (self.type == 4) {
        self.navigationItem.title = @"任务描述";
    }
    if (self.type == 5) {
        self.navigationItem.title = @"群组描述";
    }
    if (self.type == 6) {
        self.navigationItem.title = @"笔记本重命名";
    }
    if (self.type == 7) {
        self.navigationItem.title = @"添加描述";
    }
    
    if (self.naviTitle) {
        self.navigationItem.title = self.naviTitle;
    }
}

- (void)sure{
    
    if (!self.isApproval) {
        
        if (!self.isNoNecessary){
            
            if (!self.descString || [self.descString isEqualToString:@""]) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"请输入%@",self.sectionTitle] toView:self.view];
                return;
            }
        }
        
        if (self.descAction) {
            self.descAction(self.descString);
        }
    }else{
        
        if (!self.descString || [self.descString isEqualToString:@""]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"请输入%@",self.sectionTitle] toView:self.view];
            return;
        }
        
        if (!self.peoples.count) {
            [MBProgressHUD showError:@"请选择转审人" toView:self.view];
            return;
        }
        
        if (self.parameterAction) {
            self.parameterAction(@[self.descString,self.peoples[0]]);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        
        HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
        if (self.isApproval) {
            
            cell.titleLabel.text = @"转审给";
        }else{
            
            cell.titleLabel.text = @"抄送人";
        }
        cell.contentLabel.textColor = PlacehoderColor;
        cell.titleLabel.textAlignment = NSTextAlignmentLeft;
        cell.bottomLine.hidden = YES;
        
        if (self.peoples.count) {
            
            [cell refreshMorePeopleCellWithPeoples:self.peoples];
            cell.contentLabel.text = @"";
        }else{
            
            [cell refreshMorePeopleCellWithPeoples:@[]];
            cell.contentLabel.text = @"请添加";
        }
        
        return cell;
        
    }else{
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        
        
        if (self.type == 0) {
            cell.textVeiw.placeholder = @"20字以内";
        }
        if (self.type == 1) {
            cell.textVeiw.placeholder = @"500字以内";
        }
        if (self.type == 2) {
            cell.textVeiw.placeholder = @"12字以内";
        }
        if (self.type == 3) {
            cell.textVeiw.placeholder = @"20字以内";
        }
        if (self.type == 4) {
            cell.textVeiw.placeholder = @"500字以内";
        }
        
        if (self.placehoder) {
            cell.textVeiw.placeholder = self.placehoder;
        }
        
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(18);
        cell.textVeiw.text = self.descString;
        cell.textVeiw.tag = 0x12345;
        cell.bottomLine.hidden = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.isApproval) {
                [cell.textVeiw becomeFirstResponder];
            }
        });
        return cell;
    }
    
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (self.wordNum != 0) {
        
        if (textView.text.length > self.wordNum) {
            
            self.descString = [textView.text substringToIndex:self.wordNum];
            textView.text = self.descString;
            [MBProgressHUD showError:[NSString stringWithFormat:@"%ld个字以内",self.wordNum] toView:self.view];
            
        }else{
            self.descString =  textView.text;
        }
        
    }else{
        
        self.descString = textView.text;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.isApproval) {
            return 55;
        }else{
            return 0;
        }
            
    }else{
        return SCREEN_HEIGHT - 108;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if ([self.sectionTitle isEqualToString:@""]) {
            return 0;
        }
        return 44;
    }
    
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else{
        
        if (self.sectionTitle) {
            
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:[NSString stringWithFormat:@"    %@",self.sectionTitle] textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        
        if (self.type == 0) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:@"    项目名称" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        if (self.type == 1) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:@"    项目描述" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        if (self.type == 2) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:@"    分类名称" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        if (self.type == 3) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:@"    任务名称" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        if (self.type == 4) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:@"    任务描述" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        
        if (self.type == 5) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:@"    群组描述" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        if (self.type == 6) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:@"    笔记本名称" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        if (self.type == 7) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:@"    添加描述" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
        
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        
        TFCompanyGroupController *depart = [[TFCompanyGroupController alloc] init];
        depart.type = 2;
        depart.isSingle = YES;
        depart.actionParameter = ^(NSArray *peoples){
            
            [self.peoples removeAllObjects];
            [self.peoples addObjectsFromArray:peoples];
            
            [tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:depart animated:YES];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
