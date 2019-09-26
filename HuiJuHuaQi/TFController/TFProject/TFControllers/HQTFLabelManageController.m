//
//  HQTFLabelManageController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFLabelManageController.h"
#import "HQTFCreatLabelController.h"
#import "HQTFLabelCell.h"
#import "HQTFSearchHeader.h"
#import "HQTFThreeLabelCell.h"
#import "AlertView.h"
#import "TFProjectBL.h"
#import "TFProjectLableListModel.h"
#import "HQTFNoContentView.h"

#define MaxSelectCount 4

@interface HQTFLabelManageController ()<UITableViewDataSource,UITableViewDelegate,HQTFSearchHeaderDelegate,HQTFLabelCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** labels */
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *allLabels;
/** selectLabels */
@property (nonatomic, strong) NSMutableArray *selectLabels;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/**  headerView */
@property (nonatomic, strong) UIView *headerView;

/** 请求 */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** isSearch */
@property (nonatomic, assign) BOOL isSearch;


@end

@implementation HQTFLabelManageController

-(NSMutableArray *)labels{
    if (!_labels) {
        _labels = [NSMutableArray array];
        
    }
    return _labels;
}

-(NSMutableArray *)allLabels{
    if (!_allLabels) {
        _allLabels = [NSMutableArray array];
        
    }
    return _allLabels;
}

-(NSMutableArray *)selectLabels{
    if (!_selectLabels) {
        _selectLabels = [NSMutableArray arrayWithArray:self.didSelectLabels];
    }
    return _selectLabels;
}

//-(void)setDidSelectLabels:(NSMutableArray *)didSelectLabels{
//    _didSelectLabels = didSelectLabels;
//    
//    [self.selectLabels addObjectsFromArray:didSelectLabels];
//}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无标签"];
    }
    return _noContentView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
    
    [self.projectBL requestGetProjLabelAndMarkLabelWithProjectId:self.projectId withLabelName:@""];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
    [self searchHeaderCancelClicked];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTableView];
    [self setupHeaderSearch];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
}

#pragma mark - navi
- (void)setupNavigation{
    
    [self naviTypeManage];
    
}

- (void)naviTypeManage{
    
    
    if (self.type == LabelManageControllerSelect) {
        
        UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(createLabel) image:@"加号" highlightImage:@"加号"];
        UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(editLabel) image:@"编辑24" highlightImage:@"编辑24"];
        UIBarButtonItem *item3 = [self itemWithTarget:self action:@selector(editLabel) text:@"" textColor:WhiteColor];
        
        self.navigationItem.rightBarButtonItems = @[item2,item3,item1];
        self.navigationItem.title = @"选择标签";
        
    }else{
        
        UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(createLabel) image:@"加号" highlightImage:@"加号"];
        
        self.navigationItem.rightBarButtonItems = @[item1];
        
        self.navigationItem.title = @"标签管理";
    }
    
}


- (void)naviTypeSelect{
    
    UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(selectLabel) text:@"确定" textColor:GreenColor];
    
    self.navigationItem.rightBarButtonItems = @[item1];
    
    if (self.type == LabelManageControllerSelect) {
        
        self.navigationItem.title = @"选择标签";
    }
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createLabel{
    
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    HQTFCreatLabelController *create = [[HQTFCreatLabelController alloc] init];
    create.projectId = self.projectId;
    [self.navigationController pushViewController:create animated:YES];
}

- (void)editLabel{
    
    
    if ([self.projectItem.projectStatus isEqualToNumber:@2]) {
        [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    
    if ([self.projectItem.projectStatus isEqualToNumber:@3]) {
        [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
        return;
    }
    HQTFLabelManageController *create = [[HQTFLabelManageController alloc] init];
    create.projectId = self.projectId;
    create.type = LabelManageControllerManage;
    [self.navigationController pushViewController:create animated:YES];
}

- (void)selectLabel{
    
    if (self.selectLabels.count) {
        
        if (self.labelAction) {
            self.labelAction(self.selectLabels);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    headerView.backgroundColor = HexColor(0xe7e7e7, 1);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    header.delegate = self;
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

-(void)searchHeaderClicked{
    self.isSearch = YES;
    self.headerSearch.type = SearchHeaderTypeMove;
    [self.headerSearch.textField becomeFirstResponder];
    self.headerSearch.frame = CGRectMake(0, 24, SCREEN_WIDTH, 64);
    [self.navigationController.navigationBar addSubview:self.headerSearch];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.headerSearch.y = -20;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        
        self.tableView.tableHeaderView = nil;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -44);
    }];
    
}


-(void)searchHeaderCancelClicked{
    self.isSearch = NO;
    self.header.type = SearchHeaderTypeNormal;
    self.headerSearch.type = SearchHeaderTypeNormal;
    [self.headerSearch.textField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.headerSearch.y = 24;
        self.tableView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -88);
    }completion:^(BOOL finished) {
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        [self.headerSearch removeFromSuperview];
    }];
    
    [self.projectBL requestGetProjLabelAndMarkLabelWithProjectId:self.projectId withLabelName:nil];
}

- (void)keyboardHide{
    
    
}

-(void)searchHeaderTextChange:(UITextField *)textField{
    
    [self textFieldChange:textField];
}

- (void)textFieldChange:(UITextField *)textField
{
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        [self.projectBL requestGetProjLabelAndMarkLabelWithProjectId:self.projectId withLabelName:textField.text];
        
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.labels.count) {
            return 1;
        }
        return 0;
    }else if (section == 2){
        if (self.allLabels.count) {
            return 1;
        }
        return 0;
    }else if (section == 1){
        return self.labels.count;
    }else{
        
        return self.allLabels.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
            HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
            cell.headMargin = 0;
            cell.leftLabel.textColor = LightGrayTextColor;
            cell.leftLabel.text = @"常用标签";
            return cell;
        
    }else if (indexPath.section == 1){
    
        if (self.type == LabelManageControllerManage) {
            
            HQTFLabelCell *cell = [HQTFLabelCell labelCellWithTableView:tableView withType:LabelCellTypeThreeAll];
            cell.tag = 0x123*indexPath.section + indexPath.row;
            
            cell.delegate = self;
            [cell refreshLabelCellWithModel:self.labels[indexPath.row]];
            
            if (indexPath.row == self.labels.count - 1) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            
            return cell;
            
        }else{
            
            
            TFProjLabelModel *model = self.labels[indexPath.row];
            HQTFLabelCell *cell = [HQTFLabelCell labelCellWithTableView:tableView withType:[model.select integerValue] == 0 ? LabelCellTypeNothing : LabelCellTypeSelect];
            cell.tag = 0x123*indexPath.section + indexPath.row;
            
            [cell refreshLabelCellWithModel:self.labels[indexPath.row]];
            cell.delegate = self;
            if (indexPath.row == self.labels.count - 1) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            
            return cell;
            
        }

    
    }else if (indexPath.section == 2){
        
            
        HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
        
        cell.headMargin = 0;
        cell.leftLabel.textColor = LightGrayTextColor;
        cell.leftLabel.text = @"所有标签";
        return cell;
        
    }else{
        if (self.type == LabelManageControllerManage) {
            
            HQTFLabelCell *cell = [HQTFLabelCell labelCellWithTableView:tableView withType:LabelCellTypeThreeAll];
            cell.tag = 0x123*indexPath.section + indexPath.row;
            cell.delegate = self;
            [cell refreshLabelCellWithModel:self.allLabels[indexPath.row]];
            
            if (indexPath.row == self.allLabels.count - 1) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            
            return cell;
            
        }else{
            
            
            
            TFProjLabelModel *model = self.allLabels[indexPath.row];
            
            HQTFLabelCell *cell = [HQTFLabelCell labelCellWithTableView:tableView withType:[model.select integerValue] == 0 ? LabelCellTypeNothing : LabelCellTypeSelect];
            cell.tag = 0x123*indexPath.section + indexPath.row;
            
            [cell refreshLabelCellWithModel:self.allLabels[indexPath.row]];
            cell.delegate = self;
            if (indexPath.row == self.allLabels.count - 1) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            
            return cell;
            
        }

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == LabelManageControllerSelect) {
        
        if (indexPath.section == 1) {
            
            TFProjLabelModel *model = self.labels[indexPath.row];
        
            if ([model.select integerValue] == 1) {// 已选中
                
                model.select = 0; // 变为未选中
                
                for (TFProjLabelModel *model1 in self.selectLabels) {// 从选中剔除
                    
                    if ([model1.id longLongValue] == [model.id longLongValue]) {
                        
                        [self.selectLabels removeObject:model1];
                        break;
                    }
                }
                
                
                for (TFProjLabelModel *model2  in self.allLabels) {// 从所有中剔除

                    
                    if ([model2.id longLongValue] == [model.id longLongValue]) {
                        
                        model2.select = 0;
                        break;
                    }
                    
                }
                
                
            }else{// 选中
                
                if (self.selectLabels.count >= MaxSelectCount) {// 未选中且多于=MaxSelectCount
                    
                    // 最多MaxSelectCount个
                    [MBProgressHUD showError:[NSString stringWithFormat:@"最多选择%d个标签",MaxSelectCount] toView:KeyWindow];
                    return;
                    
                }else{// 少于MaxSelectCount个
                    
                    model.select = @1;
                    
                    [self.selectLabels addObject:model];
                    
                    
                    for (TFProjLabelModel *model2  in self.allLabels) {// 选中所有中的
                        
                        if ([model2.id longLongValue] == [model.id longLongValue]) {
                            
                            model2.select = @1;
                            break;
                        }
                        
                    }

                    
                }
                
                
            }
            
            
        }
        

        
        
        
        if (indexPath.section == 3) {
            
            
            TFProjLabelModel *model = self.allLabels[indexPath.row];
            
            if ([model.select integerValue] == 1) {// 已选中
                
                model.select = @0;
                
                for (TFProjLabelModel *model1 in self.selectLabels) {
                    
                    if ([model1.id longLongValue] == [model.id longLongValue]) {
                        
                        [self.selectLabels removeObject:model1];
                        break;
                    }
                }
                
                
                for (TFProjLabelModel *model2  in self.labels) {
                    
                    if ([model2.id longLongValue] == [model.id longLongValue]) {
                        
                        model2.select = @0;
                        break;
                    }
                    
                }
                
                
            }else{// 未选中
                
                if (self.selectLabels.count >= MaxSelectCount) {//
                    
                    // 最多MaxSelectCount个
                    [MBProgressHUD showError:[NSString stringWithFormat:@"最多选择%d个标签",MaxSelectCount] toView:KeyWindow];
                    return;
                    
                }else{
                    
                    model.select = @1;
                    
                    [self.selectLabels addObject:model];
                    
                    
                    for (TFProjLabelModel *model2  in self.labels) {
                        
                        if ([model2.id longLongValue] == [model.id longLongValue]) {
                            
                            model2.select = @1;
                            break;
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
        }
    }
    
    [tableView reloadData];
    
    if (self.selectLabels.count) {
        [self naviTypeSelect];
    }else{
        [self naviTypeManage];
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 40;
    }
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    

    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0 || section == 2) {
        return 0;
    }else{
        if (section == 1) {
            if (self.labels.count) {
                return 8;
            }
        }else{
            if (self.allLabels.count) {
                return 8;
            }
        }
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    /*
    if (section == 0) {
        
        NSString *tip = @" 每个任务最多选用3个标签";
        UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:tip textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"    "];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"关于"];
        attach.bounds = CGRectMake(0, -1, 6, 13);
        
        [str appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:tip]];
        
        [str addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(5, tip.length)];
        
        label.backgroundColor = WhiteColor;
        label.attributedText = str;
        return label;
        
    }*/
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - HQTFLabelCellDelegate
-(void)labelCellDidClickedEditBtnWithModel:(TFProjLabelModel *)model{
    
    HQTFCreatLabelController *create = [[HQTFCreatLabelController alloc] init];
    create.projectId = self.projectId;
    create.labelModel = model;
    create.type = 1;
    [self.navigationController pushViewController:create animated:YES];
    
}

-(void)labelCell:(HQTFLabelCell *)labelCell didClickedDeleteBtnWithModel:(TFProjLabelModel *)model{
    
    [AlertView showAlertView:@"删除标签" msg:@"你确定要删除此标签吗？" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
        
    } onRightTouched:^{
        
        
        if (labelCell.tag < 0x123*3) {
            
            [self.labels removeObjectAtIndex:labelCell.tag-0x123];
        }else{
            
            [self.allLabels removeObjectAtIndex:labelCell.tag-0x123*3];
        }
        
        [self.projectBL requestDelProjLabelIdsWithLabelId:model.id];
        
    }];
}

-(void)labelCell:(HQTFLabelCell *)labelCell didClickedStarBtnWithModel:(TFProjLabelModel *)model{
    
    
    if (labelCell.tag < 0x123*3) {
        
        TFProjLabelModel *model = self.labels[labelCell.tag-0x123];
        model.labelStatus = [model.labelStatus integerValue]==0?@2:@0;
        
        if ([model.labelStatus isEqualToNumber:@0]) {// 取消常用
            
            for (TFProjLabelModel *label in self.allLabels) {
                
                if ([label.id isEqualToNumber:model.id]) {
                    
                    label.labelStatus = model.labelStatus;
                    break;
                }
            }
            
            [self.labels removeObjectAtIndex:labelCell.tag-0x123];
        }
        
        [self.projectBL requestDelProjLabelCollectWithLabelId:model.id];
        
    }else{
        
        TFProjLabelModel *model = self.allLabels[labelCell.tag-0x123*3];
        model.labelStatus = [model.labelStatus integerValue]==0?@2:@0;
        
        
        if ([model.labelStatus isEqualToNumber:@0]) {// 取消常用
            
            for (TFProjLabelModel *label in self.labels) {
                
                if ([label.id isEqualToNumber:model.id]) {
                    
                    [self.labels removeObject:label];
                    break;
                }
            }
        }else{
            
            [self.labels addObject:model];
        }
        if ([model.labelStatus isEqualToNumber:@0]) {
            
            [self.projectBL requestDelProjLabelCollectWithLabelId:model.id];
        }else{
            
            [self.projectBL requestAddProjLabelCollectWithLabelId:model.id];
        }
    }
    
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjLabelAndMarkLabel) {
        
        self.allLabels = resp.body;
        [self.labels removeAllObjects];
        
        for (TFProjLabelModel *model in self.allLabels) {
            
            model.labelId = model.id;
            if ([model.labelStatus isEqualToNumber:@2]) {
                [self.labels addObject:model];
            }
            
        }
        
        for (TFProjLabelModel *model in self.allLabels) {
            model.select = @0;
        }
        
        for (TFProjLabelModel *label1 in self.selectLabels) {
            
            for (TFProjLabelModel *label2 in self.labels) {
                
                if ([label1.labelId longLongValue] == [label2.labelId longLongValue]) {
                    label2.select = @1;
                    break;
                }
            }
        }
        
        for (TFProjLabelModel *label1 in self.selectLabels) {
            
            for (TFProjLabelModel *label2 in self.allLabels) {
                
                if ([label1.labelId longLongValue] == [label2.labelId longLongValue]) {
                    label2.select = @1;
                    break;
                }
            }
        }
        
//        [self.tableView reloadData];
    }
    
    if (!self.isSearch) {
        
        if (self.selectLabels.count) {
            [self naviTypeSelect];
        }else{
            [self naviTypeManage];
        }
    }
    
    if (self.allLabels.count) {
        self.tableView.backgroundView = [UIView new];
    }else{
        self.tableView.backgroundView = self.noContentView;
    }
    
//    if (resp.cmdId == HQCMD_addProjLabel) {
//        
//        [self.tableView reloadData];
//    }
//    
//    if (resp.cmdId == HQCMD_delProjLabel) {
//        
//        [self.tableView reloadData];
//    }
//    if (resp.cmdId == HQCMD_projectLabelCollectDelete) {
//        
//    }
//    
//    if (resp.cmdId == HQCMD_projectLabelCollectAdd) {
//        
//    }
    
    [self.tableView reloadData];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    
    if (resp.cmdId == HQCMD_getProjLabelAndMarkLabel) {
        
    }
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
