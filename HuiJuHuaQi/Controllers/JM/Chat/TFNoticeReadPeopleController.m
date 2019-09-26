
//
//  TFNoticeReadPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoticeReadPeopleController.h"
#import "HQTFTwoLineCell.h"
#import "HQEmployModel.h"
#import "MJRefresh.h"
#import "HQTFNoContentView.h"
#import "TFContactorInfoController.h"
#import "TFChatBL.h"
#import "TFGroupInfoModel.h"

@interface TFNoticeReadPeopleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

//
@property (nonatomic, strong) NSMutableArray *peopleArr;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFGroupInfoModel *groupModel;

/** 已读人员数组 */
@property (nonatomic, strong) NSMutableArray *peoples;

@end

@implementation TFNoticeReadPeopleController

- (NSMutableArray *)peoples {

    if (!_peoples) {
        
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestData];
    
    [self setupTableView];
    [self setupNoContentView];

    
}

- (void)requestData {

    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    [self.chatBL requestGetGroupInfoWithData:self.groupId];
}

#pragma mark - 无内容View
- (void)setupNoContentView{
    HQTFNoContentView *noContent = [HQTFNoContentView noContentView];
    noContent.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
    
    CGRect rect = (CGRect){(SCREEN_WIDTH-Long(150))/2,(self.tableView.height - Long(150))/2 - 60,Long(150),Long(150)};
    
    if (self.type == 1) {
        [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"没有未读成员"];
    }else{
        [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"没有已读成员"];
    }
    self.noContentView = noContent;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
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
    return self.peoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    cell.titleImage.imageView.layer.cornerRadius = cell.titleImage.imageView.width/2.0;
    cell.titleImage.imageView.layer.masksToBounds = YES;
    
    [cell refreshCellWithGroupInfoModel:self.peoples[indexPath.row]];
    if (self.peoples.count -1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    cell.topLine.hidden = YES;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFContactorInfoController *info = [[TFContactorInfoController alloc] init];
    TFGroupEmployeeModel *employee = self.peoples[indexPath.row];
    info.signId = employee.sign_id;
    [self.navigationController pushViewController:info animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    
    NSString *str = @"";
    
    if (self.type == 0) { //未读人数
        
        str = [NSString stringWithFormat:@"未读成员%ld人",self.peoples.count];
    }
    else { //已读人数
    
        str = [NSString stringWithFormat:@"已读成员%ld人",self.peoples.count];
    }
    
    UILabel *lab = [UILabel initCustom:CGRectMake((SCREEN_WIDTH-120)/2, 0, 120, 40) title:str titleColor:kUIColorFromRGB(0xBBBBC3) titleFont:14 bgColor:ClearColor];
    
    [view addSubview:lab];
    view.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    return view;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getGroupInfo) {
        
        self.groupModel = resp.body;
        
        //群所有人员
        NSArray *arr = self.groupModel.employeeInfo;
        
        //群成员字符串分割成数组
        NSArray  *array = [self.readPeoples componentsSeparatedByString:@","];
        
        self.peopleArr = [NSMutableArray arrayWithArray:array];
        
        [self.peopleArr removeLastObject];
        
        
        if (self.type == 1) {
            
            for (int i=0; i<self.peopleArr.count; i++) { //已读
                
                for (TFGroupEmployeeModel *model in arr) {
                    
                    if ([model.sign_id isEqualToNumber:@([self.peopleArr[i] integerValue])]) {
                        
                        [_peoples addObject:model];
                    }
                }
            }
            
        }
        else {
        
            NSInteger exit = 0;
            for (TFGroupEmployeeModel *model in arr) { //未读
                
                if (![model.sign_id isEqualToNumber:UM.userLoginInfo.employee.sign_id]) { //未读不显示自己
                    
                    for (NSString *str in self.peopleArr) {
                        
                        if (![model.sign_id isEqualToNumber:@([str integerValue])]) {
                            
                            exit = 0;
                        }
                        else {
                            
                            exit = 1;
                            break;
                        }
                        
                    }
                    if (exit == 0) {
                        
                        [_peoples addObject:model];
                    }

                }
                
                
            }
        }
        
        if (self.actionParameter) {
            self.actionParameter(self.peoples);
        }
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
