//
//  TFManageFolderController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFManageFolderController.h"
#import "HQTFSelectColorController.h"

#import "HQSelectTimeCell.h"
#import "HQTFInputCell.h"

#import "TFProjLabelModel.h"

#import "TFFileBL.h"

@interface TFManageFolderController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFFileBL *fileBL;

@end

@implementation TFManageFolderController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavi];
    
//    self.labColor = @"#FABC01";
    
    [self setupTableView];
}

- (void)setNavi {
    
    if (self.fileSeries == 0) {
        
        self.navigationItem.title = @"管理文件夹";
    }
    else {
    
        self.navigationItem.title = @"管理子文件夹";
    }
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(returnAction) image:@"返回" highlightImage:@"返回"];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(saveAction) text:@"保存" textColor:GreenColor];
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
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = @"文件夹名称";
        cell.requireLabel.hidden = NO;
        cell.enterBtn.hidden = YES;
        cell.textField.placeholder = @"请输入";
        cell.delegate = self;
        
        cell.textField.text = self.folderName;
        
        [cell refreshInputCellWithType:0];
        
        return cell;
    }
    else {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.timeTitle.text = @"选择颜色";
        cell.requireLabel.hidden = NO;
        cell.arrow.hidden = NO;
        
        UIButton *colorImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.contentView addSubview:colorImage];
        [colorImage setImage:IMG(@"文件夹") forState:UIControlStateNormal];
        colorImage.tag = 0x1234;
        colorImage.frame = CGRectMake(108, 0, 30, 30);
        colorImage.centerY = 70/2;
        colorImage.userInteractionEnabled = NO;
        colorImage.layer.cornerRadius = 3;
        colorImage.layer.masksToBounds = YES;
        
        colorImage.backgroundColor = [HQHelper colorWithHexString:self.labColor];
        
        return cell;
    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 1) {
        
        HQTFSelectColorController *selectColor = [[HQTFSelectColorController alloc] init];
        
        selectColor.color = self.labColor;
        
        selectColor.colorAction = ^(TFProjLabelModel *model) {
            
            self.labColor = model.labelColor;
            
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:selectColor animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

#pragma mark 保存
- (void)returnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction {
    
    self.fileBL = [TFFileBL build];
    
    self.fileBL.delegate = self;
    
    [self.fileBL requestEditFolderWithData:self.folderId name:self.folderName color:self.labColor];
}

#pragma mark HQTFInputCellDelegate
- (void)inputCellWithTextField:(UITextField *)textField {

    self.folderName = textField.text;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_editFolder) {
        
        if (self.refreshAction) {
            self.refreshAction();
        }
        
        [MBProgressHUD showError:@"修改成功！" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
