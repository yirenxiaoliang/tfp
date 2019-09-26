//
//  TFChangePeopleView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChangePeopleView.h"

@interface TFChangePeopleView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *authImage;
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation TFChangePeopleView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = ClearColor;
    self.bgView.backgroundColor = ClearColor;
//    self.bgView.layer.shadowColor = LightGrayTextColor.CGColor;
//    self.bgView.layer.shadowRadius = 8;
//    self.bgView.layer.shadowOffset = CGSizeZero;
//    self.bgView.layer.shadowOpacity = 0.5;
    self.topView.backgroundColor = ClearColor;
    self.bottomView.backgroundColor = ClearColor;
//    self.topView.layer.shadowRadius = 8;
//    self.bottomView.layer.shadowRadius = 8;
//    self.topView.layer.masksToBounds = YES;
//    self.bottomView.layer.masksToBounds = YES;
    
    self.line.backgroundColor = CellSeparatorColor;
    self.headImage.layer.cornerRadius = 14;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.titleLabel.font = FONT(10);
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImage sd_setImageWithURL:[HQHelper URLWithString:UM.userLoginInfo.employee.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
            self.headImage.backgroundColor = WhiteColor;
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:UM.userLoginInfo.employee.employee_name] forState:UIControlStateNormal];
            self.headImage.backgroundColor = GreenColor;
        }
        
    }];
    self.authImage.layer.cornerRadius = 12;
    self.authImage.layer.masksToBounds = YES;
    [self.authImage setImage:IMG(@"workAuth") forState:UIControlStateNormal];;
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(12);
    self.nameLabel.text = UM.userLoginInfo.employee.employee_name;
    self.numberLabel.textColor = BlackTextColor;
    self.numberLabel.font = FONT(18);
    self.numberLabel.text = @"0";
    self.descLabel.textColor = ExtraLightBlackTextColor;
    self.descLabel.font = FONT(12);
    self.descLabel.text = @"待完成任务";
    self.authImage.hidden = YES;
    
    [self.authImage addTarget:self action:@selector(headClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.headImage addTarget:self action:@selector(headClicked) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
    [self.nameLabel addGestureRecognizer:tap];
    self.nameLabel.userInteractionEnabled = YES;
    
}

-(void)headClicked{
    
    if (!self.authImage.hidden) {
        
        if ([self.delegate respondsToSelector:@selector(changePeopleViewDidClickedPeople)]) {
            [self.delegate changePeopleViewDidClickedPeople];
        }
    }
}

-(void)setAuth:(NSString *)auth{
    _auth = auth;
    if ([auth isEqualToString:@"1"]) {
        self.authImage.hidden = NO;
    }else{
        self.authImage.hidden = YES;
    }
}


-(void)refreshChangePeopleViewPeoples:(NSArray *)peoples{
    
    if (!peoples || peoples.count == 0) {
        
        [self.headImage sd_setImageWithURL:[HQHelper URLWithString:UM.userLoginInfo.employee.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.headImage setTitle:@"" forState:UIControlStateNormal];
                self.headImage.backgroundColor = WhiteColor;
            }else{
                [self.headImage setTitle:[HQHelper nameWithTotalName:UM.userLoginInfo.employee.employee_name] forState:UIControlStateNormal];
                self.headImage.backgroundColor = GreenColor;
            }
            
        }];
        self.nameLabel.text = UM.userLoginInfo.employee.employee_name;
        
    }else if (peoples.count == 1){
        HQEmployModel *model = peoples.firstObject;
        
        [self.headImage sd_setImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.headImage setTitle:@"" forState:UIControlStateNormal];
                self.headImage.backgroundColor = WhiteColor;
            }else{
                [self.headImage setTitle:[HQHelper nameWithTotalName:model.employee_name?:model.employeeName] forState:UIControlStateNormal];
                self.headImage.backgroundColor = GreenColor;
            }
            
        }];
        self.nameLabel.text = model.employee_name?:model.employeeName;
        
    }else{
        
        [self.headImage setImage:IMG(@"群组45") forState:UIControlStateNormal];
        self.nameLabel.text = [NSString stringWithFormat:@"等%ld人",peoples.count];
    }
    
}

-(void)setTaskCount:(NSInteger)taskCount{
    _taskCount = taskCount;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",taskCount];
}

+(instancetype)changePeopleView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFChangePeopleView" owner:self options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
