//
//  TFAddFolderController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddFolderController.h"
#import "HQTFSelectColorController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFSelectChatPeopleController.h"

#import "TFProjLabelModel.h"
#import "HQEmployModel.h"
#import "TFManagePersonsModel.h"
#import "HQEmployModel.h"

#import "HQSelectTimeCell.h"
#import "HQTFInputCell.h"
#import "TFAddPeoplesCell.h"
#import "FDActionSheet.h"

#import "TFFileBL.h"

@interface TFAddFolderController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFInputCellDelegate,TFAddPeoplesCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) TFFileBL *fileBL;

/** 文件夹名称 */
@property (nonatomic, copy) NSString *fileName;

/** 0:公开 1:私有 */
@property (nonatomic, copy) NSString *visibleRange;

/** 默认管理员 */
@property (nonatomic, strong) NSMutableArray *managers;

@property (nonatomic, copy) NSString *managerStr;

/** 所有管理员 */
@property (nonatomic, strong) NSMutableArray *allManager;

/** 成员 */
@property (nonatomic, strong) NSMutableArray *peoples;

@property (nonatomic, copy) NSString *peopleStr;

@property (nonatomic, strong) TFManagePersonsModel *manageModel;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TFAddFolderController

- (TFManagePersonsModel *)manageModel {

    if (!_manageModel) {
        
        _manageModel = [[TFManagePersonsModel alloc] init];
    }
    return _manageModel;
}

- (NSMutableArray *)peoples {

    if (!_peoples) {
        
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (NSMutableArray *)managers {
    
    if (!_managers) {
        
        _managers = [NSMutableArray array];
    }
    return _managers;
}

- (NSMutableArray *)allManager {
    
    if (!_allManager) {
        
        _allManager = [NSMutableArray array];
    }
    return _allManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    self.labColor = @"#F9B239";
    
    _visibleRange = @"0";
    
    _managerStr = @"";
    _peopleStr = @"";
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    [self setupTableView];
    
    if (self.fileSeries == 0) {
        
        self.navigationItem.title = @"新建文件夹";
    }
    else {
        
        self.navigationItem.title = @"新建子文件夹";
        
        if (self.style == 1) {
            
            [self.fileBL requestQueryFolderInitDetailWithData:@(self.style) folderId:@([self.parentId integerValue])];
        }
        
    }
    
    
}

- (void)setNavi {
    
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
    
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = @"文件夹名称";
        cell.requireLabel.hidden = NO;
        cell.enterBtn.hidden = YES;
        cell.textField.placeholder = @"请输入";
        cell.delegate = self;
        
        [cell refreshInputCellWithType:0];
        
        return cell;
    }
    else if (indexPath.row == 1) {
    
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
    else if (indexPath.row == 2) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.timeTitle.text = @"文件夹类型";
        cell.requireLabel.hidden = NO;
        cell.arrow.hidden = NO;
        
        if ([_visibleRange isEqualToString:@"1"]) {
            
            cell.time.text = @"私有（只有加入成员可见此文件夹）";
        }
        else {
        
            cell.time.text = @"公开（企业所有成员可见此文件夹）";
        }
        
        cell.time.font = FONT(15);

        return cell;
    }
    else if (indexPath.row == 3) {
        
        TFAddPeoplesCell *cell = [TFAddPeoplesCell AddPeoplesCellWithTableView:tableView];
        
        cell.requireLabel.hidden = NO;
        cell.titleLabel.text = @"管理员";
        cell.delegate = self;
        
        [cell refreshAddPeoplesCellWithPeoples:self.allManager structure:0 chooseType:0 showAdd:YES row:indexPath.row];
        
        return cell;
    }
    else if (indexPath.row == 4) {
    
        TFAddPeoplesCell *cell = [TFAddPeoplesCell AddPeoplesCellWithTableView:tableView];
        
        cell.requireLabel.hidden = NO;
        cell.titleLabel.text = @"成员";
        cell.delegate = self;
        
        [cell refreshAddPeoplesCellWithPeoples:_peoples structure:0 chooseType:0 showAdd:YES row:indexPath.row];
        
        return cell;
    }
    
    return nil;
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
    else if (indexPath.row == 2) {
        
        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"文件夹类型" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"公开（企业所有成员可见此文件夹）",@"私有（只有加入成员可见此文件夹）", nil];
        [sheet setButtonTitleColor:GreenColor bgColor:WhiteColor fontSize:FONT(18) atIndex:[self.visibleRange integerValue]];
        
        [sheet show];
    }
    else if (indexPath.row == 3 || indexPath.row == 4) {
    
        [self selectFilePeoples:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.style == 1) { //公司文件
        
        if (self.fileSeries > 0) {
            
            if (indexPath.row == 2) {
                
                return 0;
            }
        }
        
        
        if (indexPath.row == 3 ) {
            
            return 80;
        }
        
        if (indexPath.row == 4) {
            
            if ([_visibleRange isEqualToString:@"0"]) {
                
                return 0;
                
            }
            else {
                
                return 80;
            }
        }

    }
    else if (self.style == 3) { //个人文件
    
        if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
            
            return 0;
        }
    }
    
    return 70;
}

#pragma mark FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

    _visibleRange = [NSString stringWithFormat:@"%ld",buttonIndex];
    
    [self.tableView reloadData];
}

#pragma mark 保存
- (void)returnAction {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction {
    
    
    if ([_fileName isEqualToString:@""] || _fileName == nil) {
        
        [MBProgressHUD showError:@"文件夹名称不能为空！" toView:self.view];
        return;
    }
    if (_fileName.length > 12) {
        
        [MBProgressHUD showError:@"文件夹名称最多12个字！" toView:self.view];
        return;
    }
    if (self.style == 1) {
        
        if ([_managerStr isEqualToString:@""] || _managerStr == nil) {
            
            [MBProgressHUD showError:@"管理员不能为空！" toView:self.view];
            return;
        }
        
        if (self.fileSeries == 0) {
            
            if ([_visibleRange isEqualToString:@"1"]) { //私有
                
                if ([_peopleStr isEqualToString:@""] || _peopleStr == nil) {
                    
                    [MBProgressHUD showError:@"成员不能为空！" toView:self.view];
                    return;
                }
            }
            
        }
        
    }
    
    
    TFAddFileModel *model = [[TFAddFileModel alloc] init];
    model.name = _fileName;
    model.color = self.labColor;
    if (self.style == 1) {
        
        model.type = _visibleRange;
    }
    else {
    
        model.type = @"";
    }
    model.style = @(self.style);
    model.manage_by = _managerStr;
    model.member_by = _peopleStr;
    
    if (self.fileSeries == 0) {
        
        model.parent_id = @"";
    }
    else {
    
        model.parent_id = self.parentId;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.fileBL requestSavaFileLibraryWithData:model];
}

#pragma mark HQTFInputCellDelegate
- (void)inputCellWithTextField:(UITextField *)textField {

    if (textField.text.length > 12) {
        
        textField.text = [textField.text substringToIndex:12];
        
        [MBProgressHUD showError:[NSString stringWithFormat:@"%d个字以内",12] toView:self.view];
        _fileName = textField.text;
    }
    else {
    
        _fileName = textField.text;
    }
    
    
}

- (void)selectFilePeoples:(NSInteger)index {

    if (self.fileSeries == 0) { //创建一级文件夹
        
        TFMutilStyleSelectPeopleController *selectPeople = [[TFMutilStyleSelectPeopleController alloc] init];
        
        selectPeople.selectType = 1;
        selectPeople.isSingleSelect = NO;
        
        if (index == 3) {
            
            selectPeople.defaultPoeples = self.allManager;
        }
        else {
            
            selectPeople.noSelectPoeples = self.allManager;
            selectPeople.defaultPoeples = _peoples;
        }
        
        NSMutableArray *persons = [NSMutableArray array];
        if ([_manageModel.basics.type isEqualToString:@"1"]) { //公司文件 -> 私有文件夹
            
            for (TFSettingItemModel *itemModel in _manageModel.setting) {
                
                HQEmployModel *empModel = [[HQEmployModel alloc] init];
                
                empModel.employeeName = itemModel.employee_name;
                empModel.id = itemModel.employee_id;
                empModel.photograph = itemModel.picture;
                
                [persons addObject:empModel];
            }
        }
        
        
        selectPeople.actionParameter = ^(id parameter) {
            
            if (index == 3) {
                
                NSMutableArray *manageArr = [NSMutableArray array];
                
                for (HQEmployModel *emp in parameter) {
                    
                    [manageArr addObject:emp];
                }
                
                [self.allManager removeAllObjects];
                [self.allManager addObjectsFromArray:self.managers];
                
                [self.allManager addObjectsFromArray:manageArr];
                
                if (manageArr.count > 0) {
                    
                    _managerStr = @"";
                    for (HQEmployModel *model in manageArr) {
                        
                        _managerStr = [_managerStr stringByAppendingFormat:@",%@", model.id];
                    }
                    
                    NSString *st = [_managerStr substringToIndex:1];
                    if ([st isEqualToString:@","]) { //如果第一个是,就截取掉
                        
                        _managerStr = [_managerStr substringFromIndex:1];
                    }
                    
                }
                
            }
            
            else {
                
                _peoples = parameter;
                
                _peopleStr = @"";
                for (HQEmployModel *model in _peoples) {
                    
                    _peopleStr = [_peopleStr stringByAppendingFormat:@",%@", model.id];
                }
                
                _peopleStr = [_peopleStr substringFromIndex:1];
            }
            
            
            [self.tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:selectPeople animated:YES];
    }
    else {
        
        TFSelectChatPeopleController *selectPeople = [[TFSelectChatPeopleController alloc] init];
        
        selectPeople.type = 1;
        selectPeople.isSingle = NO;
        
        if (self.dataSource.count) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (TFSettingItemModel *itemModel in self.dataSource) {
                HQEmployModel *empModel = [[HQEmployModel alloc] init];
                
                empModel.employeeName = itemModel.employee_name;
                empModel.id = itemModel.employee_id;
                empModel.photograph = itemModel.picture;
                
                [arr addObject:empModel];
            }
            selectPeople.dataPeoples = arr;
        }
        
        NSMutableArray *persons = [NSMutableArray array];
        if ([_manageModel.basics.type isEqualToString:@"1"]) { //公司文件 -> 私有文件夹
            
            for (TFSettingItemModel *itemModel in _manageModel.setting) {
                
                HQEmployModel *empModel = [[HQEmployModel alloc] init];
                
                empModel.employeeName = itemModel.employee_name;
                empModel.id = itemModel.employee_id;
                empModel.photograph = itemModel.picture;
                
                [persons addObject:empModel];
            }
        }
        
        
        selectPeople.actionParameter = ^(id parameter) {
            
            if (index == 3) {
                
                NSMutableArray *manageArr = [NSMutableArray array];
                
                for (HQEmployModel *emp in parameter) {
                    
                    [manageArr addObject:emp];
                }
                
                [self.allManager removeAllObjects];
                [self.allManager addObjectsFromArray:self.managers];
                
                [self.allManager addObjectsFromArray:manageArr];
                
                if (manageArr.count > 0) {
                    
                    for (HQEmployModel *model in manageArr) {
                        
                        _managerStr = [_managerStr stringByAppendingFormat:@",%@", model.id];
                    }
                    
                    NSString *st = [_managerStr substringToIndex:1];
                    if ([st isEqualToString:@","]) { //如果第一个是,就截取掉
                        
                        _managerStr = [_managerStr substringFromIndex:1];
                    }
                    
                }
                
            }
            
            else {
                
                _peoples = parameter;
                
                for (HQEmployModel *model in _peoples) {
                    
                    _peopleStr = [_peopleStr stringByAppendingFormat:@",%@", model.id];
                }
                
                _peopleStr = [_peopleStr substringFromIndex:1];
            }
            
            
            [self.tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:selectPeople animated:YES];
    }
}

#pragma mark TFAddPeoplesCellDelegate
- (void)addPersonel:(NSInteger)index {

    
    [self selectFilePeoples:index];

    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
 
    if (resp.cmdId == HQCMD_savaFileLibrary) {
        
        if (self.refreshAction) {
            
            self.refreshAction();
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"新建成功！" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_queryFolderInitDetail) {
        
        _manageModel = resp.body;
        
//        for (TFSettingItemModel *settingModel in _manageModel.setting) {
//            
//            HQEmployModel *em = [[HQEmployModel alloc] init];
//            
//            em.employeeName = settingModel.employee_name;
//        }
        
        [self.dataSource addObjectsFromArray:_manageModel.setting];
        
        for (TFManageItemModel *itemModel in _manageModel.manage) {
            
            HQEmployModel *model = [[HQEmployModel alloc] init];
            
            model.id = itemModel.employee_id;
            model.employee_name = itemModel.employee_name;
            model.picture = itemModel.picture;
            
            [self.managers addObject:model];
            
            
            
        }
        
        [self.allManager addObjectsFromArray:self.managers];
        
        for (HQEmployModel *model in self.managers) {
            
            _managerStr = [_managerStr stringByAppendingFormat:@",%@", model.id];
        }
        
        _managerStr = [_managerStr substringFromIndex:1];
        
        [self.tableView reloadData];

        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
