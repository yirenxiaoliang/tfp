//
//  TFEnterPeopleView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/21.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterPeopleView.h"

@interface TFEnterPeopleView ()
@property (weak, nonatomic) IBOutlet UIView *bgHeadView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *authImage;


@end

@implementation TFEnterPeopleView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgHeadView.layer.cornerRadius = 27.5 ;
    self.bgHeadView.layer.masksToBounds = YES;
    self.bgHeadView.backgroundColor = HexAColor(0xffffff, 0.2);
    self.headBtn.layer.cornerRadius = 25.5;
    self.headBtn.layer.masksToBounds = YES;

    self.nameLabel.textColor = WhiteColor;
    self.nameLabel.font = FONT(14);
    
    self.tipLabel.textColor = WhiteColor;
    self.tipLabel.font = FONT(12);
    
    self.numberLabel.textColor = WhiteColor;
    self.numberLabel.font = FONT(20);
    
    self.backgroundColor = ClearColor;
    
    self.nameLabel.text = @"";
    self.tipLabel.text = @"待完成任务";
    self.numberLabel.text = @"0";
    self.authImage.layer.cornerRadius = 10;
    self.authImage.layer.masksToBounds = YES;
    [self.authImage setImage:IMG(@"workAuth") forState:UIControlStateNormal];
    
    [self.authImage addTarget:self action:@selector(headClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.headBtn addTarget:self action:@selector(headClicked) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
    [self.nameLabel addGestureRecognizer:tap];
    self.nameLabel.userInteractionEnabled = YES;
    self.authImage.hidden = YES;
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
        
        [self.headBtn sd_setImageWithURL:[HQHelper URLWithString:UM.userLoginInfo.employee.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
                self.headBtn.backgroundColor = WhiteColor;
            }else{
                [self.headBtn setTitle:[HQHelper nameWithTotalName:UM.userLoginInfo.employee.employee_name] forState:UIControlStateNormal];
                self.headBtn.backgroundColor = GreenColor;
            }
            
        }];
        self.nameLabel.text = UM.userLoginInfo.employee.employee_name;
        
    }else if (peoples.count == 1){
        HQEmployModel *model = peoples.firstObject;
        
        [self.headBtn sd_setImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.headBtn setTitle:@"" forState:UIControlStateNormal];
                self.headBtn.backgroundColor = WhiteColor;
            }else{
                [self.headBtn setTitle:[HQHelper nameWithTotalName:model.employee_name?:model.employeeName] forState:UIControlStateNormal];
                self.headBtn.backgroundColor = GreenColor;
            }
            
        }];
        self.nameLabel.text = model.employee_name?:model.employeeName;
        
    }else{
        
        [self.headBtn setImage:IMG(@"群组45") forState:UIControlStateNormal];
        self.nameLabel.text = [NSString stringWithFormat:@"等%ld人",peoples.count];
    }
    
}

-(void)setTaskCount:(NSInteger)taskCount{
    _taskCount = taskCount;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",taskCount];
}

+(instancetype)enterPeopleView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFEnterPeopleView" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
