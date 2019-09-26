//
//  TFLauguageController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLauguageController.h"
#import "HQBaseCell.h"
#import "NSBundle+Language.h"
#import "HQBaseTabBarViewController.h"

#define UserLanguage @"UserLanguage"

@interface TFLauguageModel : NSObject

/** language */
@property (nonatomic, copy) NSString *language;

/** code */
@property (nonatomic, copy) NSString *code;

/** select */
@property (nonatomic, strong) NSNumber *select;

@end

@implementation TFLauguageModel



@end

@interface TFLauguageController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** languages */
@property (nonatomic, strong) NSMutableArray *languages;


/** selectLanguage */
@property (nonatomic, strong) TFLauguageModel *selectLanguage;



@end

@implementation TFLauguageController


- (NSString *)handleRegionWithString:(NSString *)string{
    
    NSArray *strs = [string componentsSeparatedByString:@"-"];
    
    if (strs.count < 1) {
        return nil;
    }else if (strs.count == 1) {
        return strs[0];
    }else if (strs.count == 2) {
        return [NSString stringWithFormat:@"%@-%@",strs[0],strs[1]];
    }else{
        
        NSString *str = @"";
        for (NSInteger i = 0; i < strs.count-1; i ++) {
            
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@-",strs[i]]];
            
        }
        
        if (str.length) {
            str = [str substringToIndex:str.length-1];
        }
        return str;
    }
}


- (NSMutableArray *)languages{
    if (!_languages) {
        _languages = [NSMutableArray array];
        
        NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:UserLanguage];
        NSString *currentLanguage = languages.firstObject;
        
        NSString *str = [self handleRegionWithString:currentLanguage];
        
        NSArray *las = @[@"跟随系统语言",@"简体中文",@"繁體中文",@"English"];
        NSArray *codes = @[str,@"zh-Hans",@"zh-Hant",@"en"];
        
        NSAssert(las.count == codes.count, @"数组长度不相等");
        
        
        NSArray *sys = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
        NSString *sysStr = sys.firstObject;
        NSString *str1 = [self handleRegionWithString:sysStr];
        
        for (NSInteger i = 0; i < las.count; i ++) {
            
            TFLauguageModel *model = [[TFLauguageModel alloc] init];
            model.language = las[i];
            model.code = codes[i];
            model.select = @0;
            [_languages addObject:model];
            
            if ([str1 isEqualToString:model.code]) {
                
                self.selectLanguage = model;
                model.select = @1;
            }
            
        }
        
    }
    return _languages;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:UserLanguage]) {
        
        NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@[languages.firstObject] forKey:UserLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self setupTableView];
    [self setupNavi];
}

- (void)setupNavi{
    
    self.navigationItem.title = NSLocalizedString(@"Language", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:NSLocalizedString(@"Done", nil)];
}

- (void)sure{
    
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
    return self.languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    HQBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HQBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    TFLauguageModel *model = self.languages[indexPath.row];
    cell.textLabel.text = model.language;
    if ([model.select isEqualToNumber:@1]) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中了"]];
    }else{
        cell.accessoryView = nil;
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    TFLauguageModel *selectLanguage = self.languages[indexPath.row];
    
    if ([selectLanguage.select isEqualToNumber:@1]) {
        return;
    }else{
        [MBProgressHUD showError:@"敬请期待" toView:self.view];
        return;
    }
    
    self.selectLanguage.select = @0;
    
    self.selectLanguage = self.languages[indexPath.row];
    
    self.selectLanguage.select = @1;
    
    [self.tableView reloadData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSArray *lans = @[self.selectLanguage.code];
    [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NSBundle setLanguage:self.selectLanguage.code];
    
    HQBaseTabBarViewController *tabbarVc = [[HQBaseTabBarViewController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbarVc;
    // 跳转到设置页
    tabbarVc.selectedIndex = 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
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
