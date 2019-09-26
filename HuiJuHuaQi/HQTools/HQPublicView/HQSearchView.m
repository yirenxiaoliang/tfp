//
//  HQSearchView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/8/31.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSearchView.h"

@implementation HQSearchView


- (instancetype)initViewWithFrame:(CGRect)frame
                textFiledDelegate:(id)delegate
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UITextField *searchTextFiled = [[UITextField alloc] init];
        searchTextFiled.frame =CGRectMake(10, 7, self.width - 20, self.height-15);
        searchTextFiled.backgroundColor = HexAColor(0xeeeff3, 1);
        searchTextFiled.layer.cornerRadius = 5.0;
        searchTextFiled.delegate = delegate;
        searchTextFiled.returnKeyType = UIReturnKeySearch;
        self.searchTextFiled = searchTextFiled;
        
        UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 25)];
        leftImageView.image = [UIImage imageNamed:@"灰色搜索"];
        
        searchTextFiled.leftViewMode = UITextFieldViewModeAlways;
        searchTextFiled.leftView = leftImageView;
        searchTextFiled.font = [UIFont systemFontOfSize:15.0];
        searchTextFiled.clearButtonMode =UITextFieldViewModeWhileEditing;
        searchTextFiled.leftViewMode = UITextFieldViewModeAlways;
        searchTextFiled.placeholder = @"搜索";
        [self addSubview:searchTextFiled];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = CellSeparatorColor;
        [self addSubview:line];
        self.line = line;
    }
    
    return self;
}

@end
