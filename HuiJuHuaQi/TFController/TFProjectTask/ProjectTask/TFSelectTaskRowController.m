//
//  TFSelectTaskRowController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectTaskRowController.h"
#import "HQSelectTimeCell.h"
#import "TFProjectSectionModel.h"
#import "HQTFNoContentView.h"

@interface TFSelectTaskRowController ()<UITableViewDataSource,UITableViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFSelectTaskRowController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2-30,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据\n请先去PC端新建任务子列"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.selectModel) {
        for (TFProjectSectionModel *model in self.datas) {
            if ([model.id isEqualToNumber:self.selectModel.id]) {
                model.select = @1;
                break;
            }
        }
    }
    
    [self setupTableView];
   
    if (self.type == 0) {
        self.navigationItem.title = @"选择分组";
    }else if (self.type == 1){
        self.navigationItem.title = @"选择列";
    }else{
        self.navigationItem.title = @"选择子列";
        if (self.datas.count == 0) {
            self.tableView.backgroundView = self.noContentView;
        }
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.selectModel) {
        if (self.parameter) {
            self.parameter(self.selectModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [MBProgressHUD showError:@"请选择" toView:self.view];
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
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.timeTitle.textColor = BlackTextColor;
    cell.timeTitle.font = FONT(16);
    cell.titltW.constant = SCREEN_WIDTH-30;
    cell.requireLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TFProjectSectionModel *model = self.datas[indexPath.row];
    cell.timeTitle.text = model.name;
    cell.bottomLine.hidden = NO;
    if ([model.select isEqualToNumber:@1]) {
        cell.arrow.hidden = NO;
        cell.arrow.image = [UIImage imageNamed:@"完成"];
    }else{
        cell.arrow.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    for (TFProjectSectionModel *model in self.datas) {
        model.select = @0;
    }
    TFProjectSectionModel *model = self.datas[indexPath.row];
    model.select = @1;
    [self.tableView reloadData];
    self.selectModel = model;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
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
