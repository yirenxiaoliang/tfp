//
//  TFDownloadRecordController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFDownloadRecordController.h"

#import "TFDownloadRecordCell.h"

#import "TFDownloadRecordModel.h"
#import "HQTFNoContentView.h"
#import "TFProjectTaskBL.h"
#import "TFFileBL.h"

@interface TFDownloadRecordController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFFileBL *fileBL;
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFDownloadRecordController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"下载记录";
    
    [self createView];
    
    [self setupTableView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.isProject) {
        self.projectTaskBL = [TFProjectTaskBL build];
        self.projectTaskBL.delegate = self;
        [self.projectTaskBL requestFileProjectDownloadRecordWithFileId:self.fileId];
        
    }else{
        self.fileBL = [TFFileBL build];
        self.fileBL.delegate = self;
        [self.fileBL requestQueryDownLoadListWithData:self.fileId];
    }
}

- (void)createView {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = ClearColor;
    [self.view addSubview:view];
    
    UILabel *lab1 = [UILabel initCustom:CGRectMake(15, 10, 50, 20) title:@"下载人" titleColor:kUIColorFromRGB(0x8C8C8E) titleFont:14 bgColor:ClearColor];
    lab1.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab1];
    
    UILabel *lab2 = [UILabel initCustom:CGRectMake(143, 10, 60, 20) title:@"下载次数" titleColor:kUIColorFromRGB(0x8C8C8E) titleFont:14 bgColor:ClearColor];
    lab2.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab2];
    
    UILabel *lab3 = [UILabel initCustom:CGRectMake((SCREEN_WIDTH-90-62), 10, 90, 20) title:@"最近下载时间" titleColor:kUIColorFromRGB(0x8C8C8E) titleFont:14 bgColor:ClearColor];
    lab3.textAlignment = NSTextAlignmentRight;
    [view addSubview:lab3];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-40) style:UITableViewStylePlain];
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
    return _datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFDownloadRecordModel *model = _datas[indexPath.row];
    TFDownloadRecordCell *cell = [TFDownloadRecordCell DownloadRecordCellWithTableView:tableView];
    
//    [cell.photoImg sd_setImageWithURL:[HQHelper URLWithString:model.picture] placeholderImage:PlaceholderHeadImage];
    if (![model.picture isEqualToString:@""]) {
        
        [cell.photoImg sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
        [cell.photoImg setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        
        [cell.photoImg sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [cell.photoImg setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [cell.photoImg setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [cell.photoImg setBackgroundColor:GreenColor];
    }

    
    cell.nameLab.text = model.employee_name;
    cell.numbersLab.text = [NSString stringWithFormat:@"%@次",model.number];
    cell.timeLab.text = [HQHelper nsdateToTime:[model.lately_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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
    
    if (resp.cmdId == HQCMD_queryDownLoadList || resp.cmdId == HQCMD_FileProjectDownloadRecord) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        _datas = resp.body;
        
        if (_datas.count == 0) {
            
            self.tableView.backgroundView = self.noContentView;
            
        }else{
            self.tableView.backgroundView = [UIView new];
        }

        
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
