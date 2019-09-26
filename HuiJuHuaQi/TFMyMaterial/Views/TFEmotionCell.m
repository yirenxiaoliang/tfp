//
//  TFEmotionCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmotionCell.h"

@interface TFEmotionCell ()

@property (nonatomic, strong)YYLabel *emoLab;
/** UIButton *clearBtn */
@property (nonatomic, weak) UIButton *clearBtn;
@end

@implementation TFEmotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titleLab = [UILabel initCustom:CGRectZero title:@"心情符号" titleColor:kUIColorFromRGB(0x69696C) titleFont:14 bgColor:ClearColor];
        
        [self addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(@15);
            make.top.equalTo(@22);
            make.height.equalTo(@20);
            
        }];
        
        self.emoLab = [[YYLabel alloc] init];
        
        self.emoLab.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.emoLab];
        
        [self.emoLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(titleLab.mas_right).offset(37);
            make.top.equalTo(@20);
            make.width.height.equalTo(@25);
        }];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:clearBtn];
        self.clearBtn = clearBtn;
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).offset(-10);
            make.width.height.equalTo(@44);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [clearBtn setImage:IMG(@"清除") forState:UIControlStateHighlighted];
        [clearBtn setImage:IMG(@"清除") forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
- (void)clear{
    
    if ([self.delegate respondsToSelector:@selector(emotionCellDidClearBtn)]) {
        [self.delegate emotionCellDidClearBtn];
    }
}

- (void)refreshEmotionCellWithData:(NSString *)emotion {

    self.emoLab.attributedText = [self attributedStringWithText:emotion font:14];
    self.clearBtn.hidden = IsStrEmpty(emotion);
}

/** 普通文本转成带表情的属性文本 */
- (NSAttributedString *)attributedStringWithText:(NSString *)text font:(CGFloat)font{
    
    return [LiuqsDecoder decodeWithPlainStr:text font:[UIFont systemFontOfSize:font]];
}

+ (instancetype)EmotionCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFEmotionCell";
    TFEmotionCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFEmotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
    
}

@end
