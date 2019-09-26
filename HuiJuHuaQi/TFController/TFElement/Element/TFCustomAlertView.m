//
//  TFCustomAlertView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomAlertView.h"
#import "TFCustomSelectCell.h"
#import "TFCustomerOptionModel.h"
#import "HQTFSearchHeader.h"
#import "IQKeyboardManager.h"

typedef enum {
    CustomAlertDefault,
    CustomAlertBottom
    
}CustomAlertType;

@interface TFCustomAlertView ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,UITextFieldDelegate>

@property (nonatomic, weak) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) CustomAlertType type;

/** headerSearch */
@property (nonatomic, weak) HQTFSearchHeader *headerSearch;

/** totalDatas */
@property (nonatomic, strong) NSArray *totalDatas;

/** footerView */
@property (nonatomic, weak) UIView *footerView;

/** keyboardHeight */
@property (nonatomic, assign) CGFloat keyboardHeight;

/** word */
@property (nonatomic, copy) NSString *word;

@end

@implementation TFCustomAlertView

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
        
        UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-46,40}];
        headerView.backgroundColor = WhiteColor;
        headerView.layer.borderColor = BackGroudColor.CGColor;
        headerView.layer.borderWidth = 1;
        
        UILabel *lable = [UILabel initCustom:CGRectZero title:@"请选择" titleColor:kUIColorFromRGB(0x505A6A) titleFont:14 bgColor:ClearColor];
        lable.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:lable];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@15);
            make.top.equalTo(@10);
            make.height.equalTo(@20);
            make.width.equalTo(@(100));
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:IMG(@"关闭") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@(-6));
            make.top.equalTo(@9);
            make.width.height.equalTo(@(22));
        }];
        
        [self addSubview:headerView];
        
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(-1));
            make.right.equalTo(@1);
            make.top.equalTo(@(-1));
            make.height.equalTo(@40);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked)];
        [headerView addGestureRecognizer:tap];
        
        UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,40}];
        footerView.backgroundColor = WhiteColor;
        self.footerView = footerView;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:SixColor forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@40);
            make.width.equalTo(@((SCREEN_WIDTH-46)/2));
        }];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cancelBtn.mas_right).offset(0);
            make.top.equalTo(@0);
            make.height.equalTo(@40);
            make.width.equalTo(@((SCREEN_WIDTH-46)/2));
        }];
        
        UIView *topLine = [[UIView alloc] init];
        [footerView addSubview:topLine];
        topLine.backgroundColor = CellSeparatorColor;
        
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        
        
        UIView *vLine = [[UIView alloc] init];
        [footerView addSubview:vLine];
        vLine.backgroundColor = CellSeparatorColor;
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.width.equalTo(@0.5);
            make.left.equalTo(@((SCREEN_WIDTH-46)/2));
            make.bottom.equalTo(@0);
        }];
        
        [self addSubview:footerView];
        
        
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@40);
        }];
        
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.backgroundColor = WhiteColor;
        tableView.bounces = NO;
        tableView.showsVerticalScrollIndicator = YES;
        
        [self insertSubview:tableView atIndex:0];
        self.tableView = tableView;
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(headerView.mas_bottom).offset(-20);
            make.bottom.equalTo(footerView.mas_top).offset(0);
        }];
        
        HQTFSearchHeader *headerSearch = [[HQTFSearchHeader alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH-46,64}];
//        headerSearch.textField.returnKeyType = UIReturnKeySearch;
        headerSearch.textField.delegate = self;
        headerSearch.delegate = self;
        self.headerSearch = headerSearch;
        self.headerSearch.type = SearchHeaderTypeSearch;
        self.headerSearch.textField.backgroundColor = BackGroudColor;
        self.headerSearch.image.backgroundColor = BackGroudColor;
        tableView.tableHeaderView = headerSearch;
        
//        [headerSearch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@0);
//            make.right.equalTo(@0);
//            make.top.equalTo(headerView.mas_bottom).offset(-30);
//            make.height.equalTo(@64);
//        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)keyboardShow:(NSNotification *)note{
    
    NSDictionary *dict = note.userInfo;
    NSValue *endValue = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = endValue.CGRectValue;
    self.keyboardHeight = endFrame.size.height;
    [self setNeedsLayout];
}

- (void)keyboardHide:(NSNotification *)note{
    
    [self setNeedsLayout];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)searchHeaderTextChange:(UITextField *)textField{
    
    UITextRange *range = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
    
    if (!position) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFCustomerOptionModel *model in self.totalDatas) {
            if ([model.label containsString:textField.text]) {
                [arr addObject:model];
            }
        }
        self.dataSource = arr;
        [self setNeedsLayout];
        [self.tableView reloadData];
        self.word = textField.text;
    }
    if (textField.text.length == 0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:self.totalDatas];
        [self setNeedsLayout];
        [self.tableView reloadData];
        self.word = textField.text;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = self.word;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = self.word;
}


/** 出现动画 */
-(void)showAnimation{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    [KeyWindow addSubview:view];
    view.tag = 0x987;
    view.backgroundColor = [UIColor blackColor];
    self.alpha = 0;
    view.alpha = 0;
    [KeyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 1;
        view.alpha = 0.3;
    }];
    IQKeyboardManager *ma = [IQKeyboardManager sharedManager];
    ma.enable = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked)];
    [view addGestureRecognizer:tap];
}

- (void)clicked{
    
    [self.headerSearch.textField resignFirstResponder];
    
}

/** 隐藏动画 */
-(void)hideAnimation{
    
    UIView *view = [KeyWindow viewWithTag:0x987];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        view.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [view removeFromSuperview];
    }];
    [self.headerSearch.textField resignFirstResponder];
    
    IQKeyboardManager *ma = [IQKeyboardManager sharedManager];
    ma.enable = YES;
}

-(void)setIsSingle:(BOOL)isSingle{
    _isSingle = isSingle;
    if (self.isSingle) {
        self.type = CustomAlertDefault;
    }else{
        self.type = CustomAlertBottom;
    }
    [self setNeedsLayout];
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerOptionModel *model = self.dataSource[indexPath.row];
    TFCustomSelectCell *cell = [TFCustomSelectCell CustomSelectCellWithTableView:tableView];
    [cell refreshCustomSelectViewWithModel:model];
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.isSingle) { //单选
        for (TFCustomerOptionModel *model in self.dataSource) {
            model.open = @0;
        }
        TFCustomerOptionModel *model = self.dataSource[indexPath.row];
        model.open = @1;
        
        [self.tableView reloadData];
        
        [self sureAction];
        
    }else { //多选
        
        TFCustomerOptionModel *model = self.dataSource[indexPath.row];
        if ([model.open isEqualToNumber:@1]) {
            model.open = @0;
        }else {
            model.open = @1;
        }
        
        [self.tableView reloadData];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerOptionModel *model = self.dataSource[indexPath.row];
    return [TFCustomSelectCell refreshCustomSelectCellHeightWithModel:model];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    return 40;
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    

    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.headerSearch.textField resignFirstResponder];
}

//取消
- (void)cancelAction {
    
    [self closeAction];
}

//确定
- (void)sureAction {
    
    if ([self.delegate respondsToSelector:@selector(sureClickedWithOptions:)]) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFCustomerOptionModel *model in self.dataSource) {
            
            if ([model.open isEqualToNumber:@1]) {
                [arr addObject:model];
            }
        }
        [self.delegate sureClickedWithOptions:arr];
    }
    
    [self hideAnimation];
}

//关闭
- (void)closeAction {
    
    [self hideAnimation];
    self.headerSearch.textField.text = @"";
    self.word = @"";
}

//刷新view
- (void)refreshCustomAlertViewWithData:(NSArray *)array {
    
    self.totalDatas = array;
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    
    [self setNeedsLayout];
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    
    CGFloat height = 0.0;
    for (int i=0; i<self.dataSource.count; i++) {
        
        TFCustomerOptionModel *model = self.dataSource[i];
        height += [TFCustomSelectCell refreshCustomSelectCellHeightWithModel:model];
    }
    
    if (self.type == CustomAlertDefault) {
        
        height += 84;
        
        [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@0);
        }];
        self.footerView.hidden = YES;
    }
    else if (self.type == CustomAlertBottom) {
        
        height += 124;
        [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@40);
        }];
        self.footerView.hidden = NO;
    }
    
    if (self.headerSearch.textField.isFirstResponder) {
        
        if (self.keyboardHeight + 90 + height > SCREEN_HEIGHT) {
            
            if (SCREEN_HEIGHT -self.keyboardHeight - 90 < 124) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.frame = CGRectMake(23, 20-10, SCREEN_WIDTH-46, SCREEN_HEIGHT -self.keyboardHeight - 20);
                }];
                
            }else{
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.frame = CGRectMake(23, 90-10, SCREEN_WIDTH-46, SCREEN_HEIGHT -self.keyboardHeight - 90);
                }];
            }
            
        }else{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                if (height < 180) {
                    
                    self.frame = CGRectMake(23, SCREEN_HEIGHT - self.keyboardHeight - 180- 10, SCREEN_WIDTH-46, 180 );
                }else{
                    self.frame = CGRectMake(23, SCREEN_HEIGHT - self.keyboardHeight - height-10, SCREEN_WIDTH-46, height);
                }
            }];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.tableView setContentOffset:(CGPoint){0,0} animated:YES];
        });
        
    }else{
        
        if (height > SCREEN_HEIGHT-160) { //大于最大高度
            
            height = SCREEN_HEIGHT-160;
        }
        if (self.width != SCREEN_WIDTH-46) {// 第一次
            
            self.frame = CGRectMake(23, (SCREEN_HEIGHT-height)/2, SCREEN_WIDTH-46, height);
        }else{
            
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = CGRectMake(23, (SCREEN_HEIGHT-height)/2, SCREEN_WIDTH-46, height);
            }];
        }
    }
   
}

@end
