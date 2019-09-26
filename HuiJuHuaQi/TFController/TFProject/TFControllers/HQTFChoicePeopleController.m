//
//  HQTFChoicePeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFChoicePeopleController.h"
#import "HQTFTwoLineCell.h"
#import "TFProjectBL.h"
#import "HQEmployModel.h"
#import "TFCompanyGroupController.h"
#import "HQTFAddPeopleController.h"

@interface HQTFChoicePeopleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,HQTFTwoLineCellDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;

@end

@implementation HQTFChoicePeopleController

-(NSMutableArray *)peoples{
    
    if (!_peoples) {
        _peoples = [NSMutableArray arrayWithArray:self.employees];
    }
    return _peoples;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
    if (self.instantPush) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.type == ChoicePeopleTypeSelectPeople) {
                
                [self pushCompany];
            }else{
                
                [self pushAdd];
            }
        });
    }
}

#pragma mark - pushAdd
- (void)pushAdd{
    
    HQTFAddPeopleController *addPeople = [[HQTFAddPeopleController alloc] init];
    addPeople.type = self.type;
    addPeople.Id = self.Id;
    addPeople.projectItem = self.projectItem;
    addPeople.isMutual = self.isMutual;
    addPeople.employees = self.peoples;
    addPeople.actionParameter = ^(NSArray *peoples){
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObjectsFromArray:self.peoples];
        for (HQEmployModel *peo in peoples) {
            BOOL contain = NO;
            for (HQEmployModel *people in self.peoples) {
                
                if ([people.id?people.id:people.employeeId isEqualToNumber:peo.id?peo.id:peo.employeeId] ) {
                    contain = YES;
                    break;
                }
            }
            
            if (!contain) {
                [arr addObject:peo];
            }
        }
        
        self.peoples = arr;
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:addPeople animated:YES];
}

#pragma mark - pushCompany
- (void)pushCompany{
    
    TFCompanyGroupController *depart = [[TFCompanyGroupController alloc] init];
    depart.type = 2;
    depart.isSingle = !self.isMutual;
    depart.employees = self.peoples;
    depart.actionParameter = ^(NSArray *peoples){
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObjectsFromArray:self.peoples];
        for (HQEmployModel *peo in peoples) {
            BOOL contain = NO;
            for (HQEmployModel *people in self.peoples) {
                
                if ([people.id?people.id:people.employeeId isEqualToNumber:peo.id?peo.id:peo.employeeId] ) {
                    contain = YES;
                    break;
                }
            }
            
            if (!contain) {
                [arr addObject:peo];
            }
        }
        
        self.peoples = arr;
        [self.tableView reloadData];
        
    };
    [self.navigationController pushViewController:depart animated:YES];
}

#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GreenColor];
    
    self.navigationItem.title = @"添加成员";
}

- (void)sure{
    
    if (!self.isMutual) {// 一个
        
        if (self.peoples.count > 1) {
            [MBProgressHUD showError:@"只能选一个人员" toView:KeyWindow];
            return;
        }
        
    }
    
    if (self.actionParameter) {
        self.actionParameter(self.peoples);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.peoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        
        [cell.titleImage setImage:[UIImage imageNamed:@"添加协作"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"添加协作"] forState:UIControlStateHighlighted];
        cell.topLabel.text = self.rowTitle;
        
        cell.topLabel.textColor = GreenColor;
        cell.type = TwoLineCellTypeOne;
        cell.enterImage.hidden = YES;
        cell.bottomLine.hidden = NO;
        cell.headMargin = 0;
        cell.enterImage.userInteractionEnabled = NO;
        
    }else{
        
        HQEmployModel *employ = self.peoples[indexPath.row];
//        [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//        [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateHighlighted];
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:employ.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:employ.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
        cell.topLabel.text = employ.employeeName;
        cell.bottomLabel.text = employ.position;
        cell.topLabel.textColor = BlackTextColor;
        cell.enterImage.hidden = NO;
        cell.bottomLine.hidden = NO;
        cell.headMargin = 15;
        if (employ.position && ![employ.position isEqualToString:@""]) {
            
            cell.type = TwoLineCellTypeTwo;
        }else{
            cell.type = TwoLineCellTypeOne;
        }
        
        if ([employ.isCreator isEqualToNumber:@1] || [employ.isProjectCreator isEqualToNumber:@1]) {
            
            [cell.enterImage setImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){0,0}] forState:UIControlStateNormal];
            cell.enterImage.userInteractionEnabled = NO;
        }else{
            
            [cell.enterImage setImage:[UIImage imageNamed:@"关闭30"] forState:UIControlStateNormal];
            cell.enterImage.userInteractionEnabled = YES;
        }
        
        cell.delegate = self;
        cell.enterImage.tag = 0x123 + indexPath.row;
        
        if (self.peoples.count-1 == indexPath.row) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        
//        if (indexPath.row == 3) {
//            
//            [cell.titleImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            [cell.titleImage setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//            [cell.titleImage setTitle:@"易" forState:UIControlStateNormal];
//            [cell.titleImage setTitle:@"易" forState:UIControlStateHighlighted];
//            [cell.titleImage setBackgroundImage:[HQHelper createImageWithColor:HeadImageGroundColor] forState:UIControlStateNormal];
//            [cell.titleImage setBackgroundImage:[HQHelper createImageWithColor:HeadImageGroundColor] forState:UIControlStateHighlighted];
//            cell.type = TwoLineCellTypeOne;
//        }
    }
    
    return cell;
}

- (void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    [self.peoples removeObjectAtIndex:enterBtn.tag-0x123];
    
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        
        if (self.type == ChoicePeopleTypeSelectPeople) {
            
            [self pushCompany];
        }else{
            
            [self pushAdd];
        }
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 44;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:[NSString stringWithFormat:@"    %@",self.sectionTitle] textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        label.backgroundColor = HexColor(0xf2f2f2, 1);
        return label;
    }
    
    UIView *view = [UIView new];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
//    NSString *tip = @" 项目负责人最多设置1位";
//     UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:tip textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
//    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"    "];
//    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//    attach.image = [UIImage imageNamed:@"关于"];
//    attach.bounds = CGRectMake(0, -1, 6, 13);
//    
//    [str appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
//    [str appendAttributedString:[[NSAttributedString alloc] initWithString:tip]];
//    
//    [str addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(5, tip.length)];
//    
//    label.backgroundColor = WhiteColor;
//    label.attributedText = str;
//    return label;
    
    UIView *view = [UIView new];
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
