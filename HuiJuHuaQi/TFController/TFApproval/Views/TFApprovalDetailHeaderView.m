//
//  TFApprovalDetailHeaderView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalDetailHeaderView.h"


@interface TFApprovalDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redImage;
@property (weak, nonatomic) IBOutlet UILabel *approvalStatuesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *processImage;


@end

@implementation TFApprovalDetailHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 20;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.userInteractionEnabled = NO;
    
    self.redImage.image = [HQHelper createImageWithColor:RedColor];
    self.redImage.layer.masksToBounds = YES;
    self.redImage.layer.cornerRadius = 4;
    
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(16);
    
    self.approvalStatuesLabel.textColor = FinishedTextColor;
    self.approvalStatuesLabel.font = FONT(12);
    self.redImage.hidden = YES;
//    self.headImage.image = PlaceholderHeadImage;
//    self.nameLabel.text = @"亮亮同学";
//    self.approvalStatuesLabel.text = @"审批通过";
    self.processImage.contentMode = UIViewContentModeScaleAspectFill;
    
    
}
+ (instancetype)approvalDetailHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFApprovalDetailHeaderView" owner:self options:nil] lastObject];
}

-(void)refreshViewWithDict:(NSDictionary *)dict{

    NSDictionary *people = [dict valueForKey:@"beginUser"];
    
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:[people valueForKey:@"picture"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.headImage setTitle:[HQHelper nameWithTotalName:[people valueForKey:@"employee_name"]] forState:UIControlStateNormal];
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.headImage.titleLabel.font = FONT(16);
            [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            
        }
        
    }];
    
    self.nameLabel.text = [people valueForKey:@"employee_name"];
    
    NSNumber *processStatus = [dict valueForKey:@"process_status"];
    self.processImage.hidden = YES;
    // -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交 6待提交（驳回到发起人）
    if ([processStatus isEqualToNumber:@0]) {
        
        self.redImage.image = [HQHelper createImageWithColor:HexColor(0xF5A623)];
        self.approvalStatuesLabel.text = @"待审批...";
        self.approvalStatuesLabel.textColor = HexColor(0xF5A623);
    }else if ([processStatus isEqualToNumber:@1]){
        
        self.redImage.image = [HQHelper createImageWithColor:HexColor(0x1890FF)];
        self.approvalStatuesLabel.text = @"审批中...";
        self.approvalStatuesLabel.textColor = HexColor(0x1890FF);
    }else if ([processStatus isEqualToNumber:@2]){
        
        self.redImage.image = [HQHelper createImageWithColor:HexColor(0x3CBB81)];
        self.approvalStatuesLabel.textColor = HexColor(0x3CBB81);
        self.approvalStatuesLabel.text = @"审批通过";
        self.processImage.hidden = NO;
        self.processImage.image = [UIImage imageNamed:@"approvalPass"];
    }else if ([processStatus isEqualToNumber:@3]){
        
        self.redImage.image = [HQHelper createImageWithColor:RedColor];
        self.approvalStatuesLabel.textColor = RedColor;
        self.approvalStatuesLabel.text = @"审批驳回";
        self.processImage.hidden = NO;
        self.processImage.image = [UIImage imageNamed:@"approvalReject"];
    }else if ([processStatus isEqualToNumber:@4]){
        
        self.redImage.image = [HQHelper createImageWithColor:HexColor(0x999999)];
        self.approvalStatuesLabel.textColor = HexColor(0x999999);
        self.approvalStatuesLabel.text = @"已撤销";
    }else if ([processStatus isEqualToNumber:@5]){
        
        self.redImage.image = [HQHelper createImageWithColor:HexColor(0xF5A623)];
        self.approvalStatuesLabel.textColor = HexColor(0xF5A623);
        self.approvalStatuesLabel.text = @"已转交";
    }else if ([processStatus isEqualToNumber:@6]){
        
        self.redImage.image = [HQHelper createImageWithColor:HexColor(0x999999)];
        self.approvalStatuesLabel.textColor = HexColor(0x999999);
        self.approvalStatuesLabel.text = @"待提交";
    }
    self.redImage.hidden = NO;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
