//
//  HQTFProjectProcessCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectProcessCell.h"
#import "HQTFProcessView.h"

@interface HQTFProjectProcessCell ()


@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UIImageView *eyeImage;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet HQTFProcessView *processView;
@property (weak, nonatomic) IBOutlet UIImageView *outDateImage;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end

@implementation HQTFProjectProcessCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.groundImage.backgroundColor = [UIColor clearColor];
    self.processView.backgroundColor = [UIColor clearColor];
    self.starImage.hidden = YES;
    self.eyeImage.hidden = YES;
    self.contentView.backgroundColor = ClearColor;
    self.backgroundColor = ClearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)projectProcessCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFProjectProcessCell" owner:self options:nil] lastObject];
}


+ (HQTFProjectProcessCell *)projectProcessCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFProjectProcessCell";
    HQTFProjectProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    if (!cell) {
        cell = [self projectProcessCell];
    }
    return cell;
}

-(void)setRate:(CGFloat)rate{
    _rate = rate;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f%@",rate*100.0,@"%"]];
    [str addAttribute:NSFontAttributeName value:FONT(32) range:(NSRange){0,str.length - 1}];
    [str addAttribute:NSFontAttributeName value:FONT(18) range:(NSRange){str.length - 1,1}];
    [str addAttribute:NSForegroundColorAttributeName value:WhiteColor range:(NSRange){0,str.length}];
    if (rate == 1.0) {
       [str addAttribute:NSForegroundColorAttributeName value:HexAColor(0xffec00, 1) range:(NSRange){0,str.length}];
    }
    
    self.rateLabel.attributedText = str;
    self.processView.rate = rate;
}


- (void)refreshProjectProcessCellWithModel:(TFProjectItem *)model type:(NSInteger)type{
    
    self.projectName.text = model.projectName;
    
    self.bookImage.hidden = ![model.projectCollectId boolValue];
    
    if ([model.projectStatus isEqualToNumber:@0]) {
        
        if ([model.isOverdue isEqualToNumber:@1]) {
            [self.outDateImage setImage:[UIImage imageNamed:@"超期project"]];
            self.outDateImage.hidden = NO;
        }else{
            self.outDateImage.hidden = YES;
        }
    }else{
        if (type == 1) {
            [self.outDateImage setImage:[UIImage imageNamed:@"超期project"]];
            self.outDateImage.hidden = NO;
        }else{
            self.outDateImage.hidden = YES;
        }
        
        if (type == 3) {
            self.outDateImage.hidden = NO;
            [self.outDateImage setImage:[UIImage imageNamed:@"暂停project"]];
        }
    }
    
    if ([model.taskCount integerValue]) {
        
        self.rate = [model.finishedTaskCount integerValue]*1.0/[model.taskCount integerValue]*1.0;
    }else{
        self.rate = 0;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
