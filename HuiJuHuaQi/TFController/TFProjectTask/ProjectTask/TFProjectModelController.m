//
//  TFProjectModelController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectModelController.h"
#import "HQTFProjectModelCell.h"
#import "TFProjectClassModel.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"
#import "TFProjectModelPreviewController.h"
#import "TFThinkPreviewController.h"

@interface TFProjectModelController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** templates */
@property (nonatomic, strong) NSMutableArray *templates;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
@end

@implementation TFProjectModelController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)templates{
    
    if (!_templates) {
        _templates = [NSMutableArray array];
        
    }
    return _templates;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    [self.projectTaskBL requestGetProjectModelWithTemplateRole:@0 templateType:nil];
    
    
    [self setupTableView];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectTemplateList) {
        
        NSArray *dataList = [resp.body valueForKey:@"dataList"];
        NSArray *groupList = [resp.body valueForKey:@"groupList"];
        
        for (NSDictionary *dict in groupList) {
            TFProjectClassModel *model = [[TFProjectClassModel alloc] init];
            model.templateName = [dict valueForKey:@"tempTypeName"];
            model.templateId = [dict valueForKey:@"tempTypeId"];
            
            [self.templates addObject:model];
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict1 in dataList) {
                
                if ([[dict1 valueForKey:@"temp_type"] isEqualToNumber:[dict valueForKey:@"tempTypeId"]]) {
                    
                    TFProjectClassModel *sub = [[TFProjectClassModel alloc] init];
                    sub.templateName = [dict1 valueForKey:@"name"];
                    sub.templateId = [dict1 valueForKey:@"id"];
                    [arr addObject:sub];
                }
            }
            model.templates = arr;
            
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
    return self.templates.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TFProjectClassModel *model = self.templates[section];
    
    return model.templates.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFProjectModelCell *cell = [HQTFProjectModelCell projectModelCellWithTableView:tableView];
    TFProjectClassModel *model = self.templates[indexPath.section];
    TFProjectClassModel *model1 = model.templates[indexPath.row];
    cell.contentLabel.text = model1.templateName;
    [cell.titleBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"modelBgs%@",[model1.templateId description]]] forState:UIControlStateNormal];
    [cell.selectBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    [cell.selectBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateHighlighted];
    cell.bottomLine.hidden = NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    TFProjectModelPreviewController *preview = [[TFProjectModelPreviewController alloc] init];
//
//    TFProjectClassModel *model = self.templates[indexPath.section];
//    TFProjectClassModel *model1 = model.templates[indexPath.row];
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
    
    TFProjectClassModel *model = self.templates[indexPath.section];
    TFProjectClassModel *model1 = model.templates[indexPath.row];
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
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TFProjectClassModel *model = self.templates[section];
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    view.backgroundColor = BackGroudColor;
    UILabel *label = [HQHelper labelWithFrame:(CGRect){15,0,SCREEN_WIDTH-15,40} text:model.templateName textColor:HexColor(0x909090) textAlignment:NSTextAlignmentLeft font:FONT(14)];
    [view addSubview:label];
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
