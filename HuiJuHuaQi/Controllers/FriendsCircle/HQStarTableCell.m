//
//  HQStarTableCell.m
//  HuiJuHuaQi
//
//  Created by hq001 on 16/4/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQStarTableCell.h"
#import "HQEmployModel.h"
#import "HQHelper.h"
#import "HQClickStartView.h"

@interface HQStarTableCell()<HQClickStartViewDeleagte>
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;
@property (weak, nonatomic) IBOutlet UIView *backimageView;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (strong, nonatomic) HQClickStartView * clickStart;

@end
@implementation HQStarTableCell


/** 刷新cell */
- (void)refreshCellWithPeoples:(NSMutableArray *)peoples{
    
    [self cellForStart:peoples];
}
/** 刷新高度 */
+ (CGFloat)refreshCellHeightWithPeoples:(NSMutableArray *)peoples{
    return [self theCellForHeight:peoples];
}


-(void)cellForStart:(NSMutableArray *)peopleName{
    
    _clickStart.employees = peopleName;
    _clickStart.titleFont = FONT(12.0);
    _clickStart.titleColor = [UIColor blackColor];
    
    [self addSubview:_clickStart];
    
}


+ (CGFloat)theCellForHeight:(NSMutableArray *)peopleName{
    
   CGFloat cellHeight = [HQClickStartView getCopyerViewHeightWithTitleFont:FONT(12.0) titleStr:@"" employees:peopleName selfWidth:SCREEN_WIDTH - CompanyCircleGoodWidth];
    
    return cellHeight;
    
}




-(void)senderEmployIdToCell:(HQEmployModel *)employ{
    
    
    if ([self.delegate respondsToSelector:@selector(senderEmployIdToCtr:)]) {
        
        [self.delegate senderEmployIdToCtr:employ];
        
    }
    
    
}

-(void)awakeFromNib{
    
     [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topLine.hidden = YES;
    
    _clickStart = [[HQClickStartView alloc] initWithFrame:CGRectMake(8, 0, self.width, self.height)];
    _clickStart.delegate = self;
}

+ (instancetype)starTableCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQStarTableCell" owner:self options:nil] lastObject];
}



+ (HQStarTableCell *)starTableCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQStarTableCell";
    HQStarTableCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self starTableCell];
    }
    return cell;
}


@end
