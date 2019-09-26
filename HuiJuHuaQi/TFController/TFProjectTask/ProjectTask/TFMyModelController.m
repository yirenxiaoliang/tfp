//
//  TFMyModelController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMyModelController.h"

#import "HQTFProjectModelCell.h"
#import "TFProjectClassModel.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"
#import "TFProjectModelPreviewController.h"
#import "TFThinkPreviewController.h"

@interface TFMyModelController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** templates */
@property (nonatomic, strong) NSMutableArray *templates;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFMyModelController

-(NSMutableArray *)templates{
    
    if (!_templates) {
        _templates = [NSMutableArray array];
    }
    return _templates;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestGetProjectModelWithTemplateRole:@1 templateType:nil];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectTemplateList) {
        
        NSArray *dataList = [resp.body valueForKey:@"dataList"];
        
        for (NSDictionary *dict in dataList) {
            
            TFProjectClassModel *sub = [[TFProjectClassModel alloc] init];
            sub.templateName = [dict valueForKey:@"name"];
            sub.templateId = [dict valueForKey:@"id"];
            sub.system_default_pic = [dict valueForKey:@"system_default_pic"];
            sub.pic_url = [dict valueForKey:@"pic_url"];
            [self.templates addObject:sub];
        }
        
        if (self.templates.count) {
            
            self.tableView.backgroundView = [UIView new];
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
        
        
        [self.tableView reloadData];
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
    
    return self.templates.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFProjectModelCell *cell = [HQTFProjectModelCell projectModelCellWithTableView:tableView];
    TFProjectClassModel *model = self.templates[indexPath.row];
    cell.contentLabel.text = model.templateName;
    
    if (model.pic_url && ![model.pic_url isEqualToString:@""]) {
        [cell.titleBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.pic_url] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                [cell.titleBtn setBackgroundImage:[UIImage imageNamed:@"projectBg"] forState:UIControlStateNormal];;
            }
        }];
        
    }else{
        
        if (model.system_default_pic && ![model.system_default_pic isEqualToString:@""]) {
            
            [cell.titleBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"modelBg%@",[model.system_default_pic description]]]?:[UIImage imageNamed:[NSString stringWithFormat:@"modelBg1"]] forState:UIControlStateNormal];
        }else{
            
            [cell.titleBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"modelBg1"]] forState:UIControlStateNormal];
        }
    }
    
    [cell.selectBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    [cell.selectBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateHighlighted];
    cell.bottomLine.hidden = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    TFProjectModelPreviewController *preview = [[TFProjectModelPreviewController alloc] init];
//
//    TFProjectClassModel *model1 = self.templates[indexPath.row];
//    preview.templateId = model1.templateId;
//    preview.sureAction = ^{
//
//        if (self.parameter) {
//            self.parameter(model1);
//        }
//    };
//
//    [self.navigationController pushViewController:preview animated:YES];
    
    TFThinkPreviewController *preview = [[TFThinkPreviewController alloc] init];
    
    TFProjectClassModel *model1 = self.templates[indexPath.row];
    preview.templateId = model1.templateId;
    preview.sureAction = ^{

        if (self.parameter) {
            self.parameter(model1);
        }
    };

    [self.navigationController pushViewController:preview animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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
