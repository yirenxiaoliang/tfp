//
//  TFChatFileController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatFileController.h"

#import "TFHistoryVersionCell.h"
#import "TFFolderListModel.h"
#import "HQTFNoContentView.h"

#import "TFFileDetailController.h"

@interface TFChatFileController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFChatFileController

- (NSMutableArray *)datas {

    if (!_datas) {
        
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"聊天文件";
    
    [self initLocalData];
    
    [self setupTableView];
}

- (void)initLocalData {

    NSMutableArray *arr = [DataBaseHandle queryRecodeWithChatId:self.chatId];
    
    for (TFFMDBModel *model in arr) {
        
        if ([model.chatFileType isEqualToNumber:@4] || [model.chatFileType isEqualToNumber:@2] || [model.chatFileType isEqualToNumber:@5]) { //图片、文件、小视屏
            
            [self.datas addObject:model];
        }
    }
    
   
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
    
    if (self.datas.count == 0) {
        
        self.tableView.backgroundView = self.noContentView;
        
    }else{
        self.tableView.backgroundView = [UIView new];
        return _datas.count;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFolderListModel *model = [[TFFolderListModel alloc] init];
    
    TFFMDBModel *dbModel = _datas[indexPath.row];
    
    model.name = dbModel.fileName;
    model.employee_name = dbModel.senderName;
    model.create_time = dbModel.clientTimes;
    model.size = dbModel.fileSize;
    model.siffix = dbModel.fileSuffix;
    model.url = dbModel.fileUrl;
    model.file_id = dbModel.fileId;
    
    TFHistoryVersionCell *cell = [TFHistoryVersionCell HistoryVersionCellWithTableView:tableView];
    
    cell.versionLab.hidden = YES;

    [cell refreshChatFileDataWithModel:model];

    cell.moreImgV.hidden = YES;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFFMDBModel *model = self.datas[indexPath.row];
    
    TFFileDetailController *detailVC = [[TFFileDetailController alloc] init];
    detailVC.fileId = model.fileId;
    detailVC.naviTitle = model.fileName;
    detailVC.whereFrom = 1;
    
    TFFolderListModel *basicModel = [[TFFolderListModel alloc] init];
    
    basicModel.size = model.fileSize;
    basicModel.siffix = model.fileSuffix;
    basicModel.name = model.fileName;
    
    basicModel.employee_name = model.senderName;
    basicModel.create_time = model.clientTimes;
    
    detailVC.fileUrl = model.fileUrl;
    detailVC.fileId = model.fileId;
    detailVC.basics = basicModel;
    
    model.fileSuffix = [model.fileSuffix stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ( [model.fileSuffix isEqualToString:@"jpg"] ||[model.fileSuffix isEqualToString:@"jpeg"] ||[model.fileSuffix isEqualToString:@"png"] ||[model.fileSuffix isEqualToString:@"gif"] ) {
        
        detailVC.isImg = 1;
    }
    else if ([model.fileSuffix isEqualToString:@"mp3"]) {
    
        detailVC.isImg = 2;
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
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

@end
