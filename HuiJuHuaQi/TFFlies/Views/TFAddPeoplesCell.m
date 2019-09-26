//
//  TFAddPeoplesCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPeoplesCell.h"
#import "TFAddPeoplesView.h"

@interface TFAddPeoplesCell ()<TFAddPeoplesViewDelegate>

/** buttons */
@property (nonatomic, strong) NSMutableArray *peoples;


/** UILabel *lable */
@property (nonatomic, weak) UILabel *peopleNumLabel;

@property (nonatomic, assign) NSInteger row;

@end

@implementation TFAddPeoplesCell

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = ExtraLightBlackTextColor;
        lable.font = FONT(14);
        lable.backgroundColor = ClearColor;
        [self.contentView addSubview:lable];
        lable.textAlignment = NSTextAlignmentLeft;
        self.titleLabel = lable;
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.contentView).with.offset(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(85);
            
        }];
        lable.text = @"";
        
        
        UILabel *requi = [[UILabel alloc] init];
        requi.text = @"*";
        self.requireLabel = requi;
        requi.textColor = RedColor;
        requi.font = FONT(14);
        requi.backgroundColor = ClearColor;
        [self.contentView addSubview:requi];
        requi.textAlignment = NSTextAlignmentLeft;
        [requi mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).with.offset(6);
            make.centerY.equalTo(lable.mas_centerY);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(15);
            
        }];
        
        
        UILabel *lable1 = [[UILabel alloc] init];
        lable1.textColor = GreenColor;
        lable1.font = FONT(14);
        lable1.backgroundColor = ClearColor;
        [self.contentView addSubview:lable1];
        lable1.textAlignment = NSTextAlignmentRight;
        self.peopleNumLabel = lable1;
        
        [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).with.offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(60);
            
        }];
        lable1.text = @"";
        
        
        
        self.layer.masksToBounds = YES;
    }
    return self;
}

/** 刷新人员 */
-(void)refreshAddPeoplesCellWithPeoples:(NSArray *)peoples structure:(NSString *)structure chooseType:(NSString *)chooseType showAdd:(BOOL)showAdd row:(NSInteger)row{
    
    CGFloat top = 10.0;
    CGFloat left = 85.0;
    CGFloat num = 5.0;
    CGFloat margin = 10;
    NSInteger index = 0;
    
    self.row = row;
    
    if ([structure isEqualToString:@"0"]) {
        // 上下
        
        top = 36.0;
        left = 0.0;
        num = 7.0;
        
        if (peoples.count < 7){
            if (showAdd) {
                index = peoples.count + 1;
            }else{
                index = peoples.count ;
            }
        }else{
            index = 7;
        }
        
        [self.peopleNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(10);
            
        }];
    }else{
        
        if (peoples.count < 5){
            if (showAdd) {
                index = peoples.count + 1;
            }else{
                index = peoples.count ;
            }
        }else{
            
            index = 4;
        }
        [self.peopleNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
    }
    
    
    for (UIView *view in self.peoples) {
        
        [view removeFromSuperview];
    }
    [self.peoples removeAllObjects];
    
    
    CGFloat width = ((SCREEN_WIDTH - left - 2 * margin) / num) >= 50 ?50:40;
    CGFloat height = 60;
    
    
    if ([chooseType isEqualToString:@"0"]) {// 单选
        
        self.peopleNumLabel.hidden = YES;
        for (NSInteger i = 0; i < 1; i ++) {
            
            TFAddPeoplesView *view = [[TFAddPeoplesView alloc] initWithFrame:(CGRect){left}];
            view.frame = CGRectMake(left + margin + i * width, top, width, height);
            [self.contentView addSubview:view];
            
            
            if (showAdd) {
                
                if (peoples.count == 0) {
                    
                    [view refreshAddType];
                    view.hidden = NO;
                    
                }else{
                    view.hidden = NO;
                    [view refreshPeopleViewWithEmployee:peoples[i]];
                }
            }
            else{
                
                if (peoples.count == 0) {
                    
                    view.hidden = YES;
                    
                }else{
                    view.hidden = NO;
                    [view refreshPeopleViewWithEmployee:peoples[i]];
                }
            }
            
            [self.peoples addObject:view];
        }
        
        return;
        
    }
    
    
    for (NSInteger i = 0; i < index; i ++) {
        
        TFAddPeoplesView *view = [[TFAddPeoplesView alloc] initWithFrame:(CGRect){left}];
        view.frame = CGRectMake(left + margin + i * width, top, width, height);
        
        view.delegate = self;
        
        [self.contentView addSubview:view];
        
        if (showAdd) {
            
            if (peoples.count >= index) {
                view.hidden = NO;
                self.peopleNumLabel.hidden = NO;
                self.peopleNumLabel.text = [NSString stringWithFormat:@"等%ld人 >",peoples.count];
                [view refreshPeopleViewWithEmployee:peoples[i]];
            }else{
                
                if (i < index-1) {
                    
                    view.hidden = NO;
                    self.peopleNumLabel.hidden = YES;
                    [view refreshPeopleViewWithEmployee:peoples[i]];
                }else{
                    
                    view.hidden = NO;
                    self.peopleNumLabel.hidden = YES;
                    [view refreshAddType];
                }
                
            }
            
            
        }
        else{
            
            view.hidden = NO;
            self.peopleNumLabel.hidden = YES;
            [view refreshPeopleViewWithEmployee:peoples[i]];
        }
        
        
        [self.peoples addObject:view];
    }
    
}

/** 刷新角色 */
-(void)refreshAddRolesCellWithPeoples:(NSArray *)peoples structure:(NSString *)structure chooseType:(NSString *)chooseType showAdd:(BOOL)showAdd row:(NSInteger)row{
    
    CGFloat top = 10.0;
    CGFloat left = 85.0;
    CGFloat num = 5.0;
    CGFloat margin = 10;
    NSInteger index = 0;
    
    self.row = row;
    
    if ([structure isEqualToString:@"0"]) {
        // 上下
        
        top = 36.0;
        left = 0.0;
        num = 7.0;
        
        if (peoples.count < 7){
            if (showAdd) {
                index = peoples.count + 1;
            }else{
                index = peoples.count ;
            }
        }else{
            index = 7;
        }
        
        [self.peopleNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(10);
            
        }];
    }else{
        
        if (peoples.count < 5){
            if (showAdd) {
                index = peoples.count + 1;
            }else{
                index = peoples.count ;
            }
        }else{
            
            index = 4;
        }
        [self.peopleNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
    }
    
    
    for (UIView *view in self.peoples) {
        
        [view removeFromSuperview];
    }
    [self.peoples removeAllObjects];
    
    
    CGFloat width = ((SCREEN_WIDTH - left - 2 * margin) / num) >= 50 ?50:40;
    CGFloat height = 60;
    
    
    if ([chooseType isEqualToString:@"0"]) {// 单选
        
        self.peopleNumLabel.hidden = YES;
        for (NSInteger i = 0; i < 1; i ++) {
            
            TFAddPeoplesView *view = [[TFAddPeoplesView alloc] initWithFrame:(CGRect){left}];
            view.frame = CGRectMake(left + margin + i * width, top, width, height);
            [self.contentView addSubview:view];
            
            
            if (showAdd) {
                
                if (peoples.count == 0) {
                    
                    [view refreshAddType];
                    view.hidden = NO;
                    
                }else{
                    view.hidden = NO;
                    [view refreshRoleViewWithEmployee:peoples[i]];
                }
            }
            else{
                
                if (peoples.count == 0) {
                    
                    view.hidden = YES;
                    
                }else{
                    view.hidden = NO;
                    [view refreshRoleViewWithEmployee:peoples[i]];
                }
            }
            
            [self.peoples addObject:view];
        }
        
        return;
        
    }
    
    
    for (NSInteger i = 0; i < index; i ++) {
        
        TFAddPeoplesView *view = [[TFAddPeoplesView alloc] initWithFrame:(CGRect){left}];
        view.frame = CGRectMake(left + margin + i * width, top, width, height);
        
        view.delegate = self;
        
        [self.contentView addSubview:view];
        
        if (showAdd) {
            
            if (peoples.count >= index) {
                view.hidden = NO;
                self.peopleNumLabel.hidden = NO;
                self.peopleNumLabel.text = [NSString stringWithFormat:@"等%ld人 >",peoples.count];
                [view refreshRoleViewWithEmployee:peoples[i]];
            }else{
                
                if (i < index-1) {
                    
                    view.hidden = NO;
                    self.peopleNumLabel.hidden = YES;
                    [view refreshRoleViewWithEmployee:peoples[i]];
                }else{
                    
                    view.hidden = NO;
                    self.peopleNumLabel.hidden = YES;
                    [view refreshAddType];
                }
                
            }
            
            
        }
        else{
            
            view.hidden = NO;
            self.peopleNumLabel.hidden = YES;
            [view refreshRoleViewWithEmployee:peoples[i]];
        }
        
        
        [self.peoples addObject:view];
    }
    
}

/** 高度 */
+(CGFloat)refreshAddPeoplesCellHeightWithStructure:(NSString *)structure{
    
    if ([structure isEqualToString:@"0"]) {
        return 110;
    }else{
        return 80;
    }
}

-(void)setFieldControl:(NSString *)fieldControl{
    _fieldControl = fieldControl;
    
    if ([fieldControl isEqualToString:@"2"]) {
        self.requireLabel.hidden = NO;
    }else{
        self.requireLabel.hidden = YES;
    }
}


+ (instancetype)AddPeoplesCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFAddPeoplesCell";
    TFAddPeoplesCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFAddPeoplesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
    
}

#pragma mark TFAddPeoplesViewDelegate
- (void)addFolderPeoples {

    if ([self.delegate respondsToSelector:@selector(addPersonel:)]) {
        
        [self.delegate addPersonel:self.row];
    }
}

@end
