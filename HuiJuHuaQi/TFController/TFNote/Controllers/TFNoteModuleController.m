//
//  TFNoteModuleController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteModuleController.h"
#import "HQTFTwoLineCell.h"
#import "HQTFNoContentView.h"
#import "TFModuleModel.h"
#import "TFNoteSearchController.h"

@interface TFNoteModuleController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFNoteModuleController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据~"];
    }
    return _noContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"备忘录";
    
    [self setupTableView];
    
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
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFModuleModel *model = self.datas[indexPath.row];
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    cell.type = TwoLineCellTypeOne;
    cell.topLabel.text = model.chinese_name;
    
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
    
    cell.bottomLine.hidden = NO;
    cell.enterImgTrailW.constant = -15;
    [cell.enterImage setImage:IMG(@"备忘录下一级") forState:UIControlStateNormal];
    cell.titleImage.contentMode = UIViewContentModeScaleToFill;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFModuleModel *model = self.datas[indexPath.row];
    
    TFNoteSearchController *search = [[TFNoteSearchController alloc] init];
    
    search.bean = model.english_name;
    
//    search.name  = [NSString stringWithFormat:@"%@-%@",self.name,model.chinese_name];
    search.name = model.chinese_name;
    search.icon_url = model.icon_url;
    search.icon_color = model.icon_color;
    search.icon_type = model.icon_type;
    search.refresh = ^(NSDictionary *dict) {
        
        if (self.refresh) {
            
            [self.navigationController popViewControllerAnimated:NO];
            
            self.refresh(dict);
        }
    };
    
    [self.navigationController pushViewController:search animated:YES];
    
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
