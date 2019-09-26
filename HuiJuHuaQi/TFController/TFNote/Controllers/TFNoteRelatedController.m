//
//  TFNoteRelatedController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteRelatedController.h"
#import "HQTFTwoLineCell.h"
#import "HQTFNoContentView.h"
#import "TFApplicationModel.h"
#import "TFNoteModuleController.h"

#import "TFCustomBL.h"

@interface TFNoteRelatedController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFCustomBL *customBL;

@property (nonatomic, strong) NSMutableArray *applications;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFNoteRelatedController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据~"];
    }
    return _noContentView;
}

-(NSMutableArray *)applications{
    if (!_applications) {
        _applications = [NSMutableArray array];
    }
    return _applications;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"备忘录";
    
    [self setupTableView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    [self.customBL requestCustomApplicationListWithApprovalFlag:nil];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
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
    return self.applications.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFApplicationModel *model = self.applications[indexPath.row];
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    cell.type = TwoLineCellTypeOne;
    
    cell.topLabel.text = model.name;
    
    if ([model.icon_type isEqualToString:@"0"]) {
        
        [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [cell.titleImage setImage:IMG(model.icon_url) forState:UIControlStateNormal];
        [cell.titleImage setBackgroundColor:[HQHelper colorWithHexString:model.icon_color]];
    }
    else if ([model.icon_type isEqualToString:@"1"]) {
        
        [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.icon_url] forState:UIControlStateNormal];
        [cell.titleImage setImage:nil forState:UIControlStateNormal];
        [cell.titleImage setBackgroundColor:ClearColor];
        
    }
    
    
    cell.titleImage.layer.cornerRadius = 6.0;
    cell.titleImage.layer.masksToBounds = YES;
    cell.enterImgTrailW.constant = -15;
    cell.bottomLine.hidden = NO;
    
    [cell.enterImage setImage:IMG(@"备忘录下一级") forState:UIControlStateNormal];
    cell.titleImage.contentMode = UIViewContentModeScaleToFill;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFApplicationModel *model = self.applications[indexPath.row];
    
    TFNoteModuleController *moduleVC = [[TFNoteModuleController alloc] init];
    
    moduleVC.datas = model.modules;
    
    moduleVC.name = model.name;
    
    moduleVC.refresh = ^(NSDictionary *dict) {
        
        if (self.refresh) {
            
            [self.navigationController popViewControllerAnimated:NO];
            
            self.refresh(dict);
            
            
        }
    };
    
    [self.navigationController pushViewController:moduleVC animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customApplicationList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        for (TFApplicationModel *model in resp.body) {
            
            if (model.id) {// 过滤掉常用应用
                [self.applications addObject:model];
            }
        }
        
        
        if (self.applications.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
