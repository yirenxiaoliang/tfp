//
//  HQTFTaskProgressCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskProgressCell.h"
#import "HQTFProgressView.h"

@interface HQTFTaskProgressCell()
/** processView */
@property (nonatomic, weak) HQTFProgressView *progressView;

@end

@implementation HQTFTaskProgressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChild];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupChild];
    
}

- (void)setupChild{
    HQTFProgressView *progressView = [HQTFProgressView progressView];
    self.progressView = progressView;
    [self.contentView addSubview:progressView];
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
    
}

/** 刷新 */
-(void)refreshTaskProgressCellWithTotalTask:(NSInteger)total finish:(NSInteger)finish{
    
    [self.progressView refreshProgressWithTotalTask:total finish:finish];
}

+(instancetype)taskProgressCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"HQTFTaskProgressCell";
    HQTFTaskProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFTaskProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    return cell;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
