//
//  TFNewNoteListView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNewNoteListView.h"

@interface TFNewNoteListView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *buttonOne;
@property (weak, nonatomic) IBOutlet UIImageView *buttonTwo;


@end

@implementation TFNewNoteListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgView.layer.cornerRadius = 4.0;
    self.imgView.layer.masksToBounds = YES;
    
    self.photoBtn.layer.cornerRadius = self.photoBtn.width/2.0;
    self.photoBtn.layer.masksToBounds = YES;
}

- (void)refreshNewNoteListCellWithModel:(TFNoteDataListModel *)model {
    
    self.titleLable.text = model.title;
    self.nameLable.text = model.createObj.employee_name;
    self.timeLable.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"MM-dd HH:mm"];
    
    if (![model.createObj.picture isEqualToString:@""]) {
        
        [self.photoBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.createObj.picture] forState:UIControlStateNormal];
        [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        
        [self.photoBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [self.photoBtn setTitle:[HQHelper nameWithTotalName:model.createObj.employee_name] forState:UIControlStateNormal];
        [self.photoBtn setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [self.photoBtn setBackgroundColor:GreenColor];
    }
    
    [self.imgView sd_setImageWithURL:[HQHelper URLWithString:model.pic_url]];
    
    //有共享人，或者创建人不为自己
    if ((![model.share_ids isEqualToString:@""] && model.share_ids != nil) || ![model.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) {
        
        self.buttonOne.image = IMG(@"备忘录共享蓝");
        
        if ([model.remind_time integerValue] > 0) {
            
            self.buttonTwo.image = IMG(@"新备忘录提醒");
        }
        else {
            
            self.buttonTwo.image = IMG(@"");
        }
    }
    else {
        
        if ([model.remind_time integerValue] > 0) {
            
            self.buttonOne.image = IMG(@"新备忘录提醒");
        }
        else {
            
            self.buttonOne.image = IMG(@"");
        }
        self.buttonTwo.image = IMG(@"");
    }
    
    
}

+(instancetype)newNoteListView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFNewNoteListView" owner:self options:nil] lastObject];
    
}

@end
