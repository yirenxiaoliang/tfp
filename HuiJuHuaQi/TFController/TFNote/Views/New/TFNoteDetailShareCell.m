//
//  TFNoteDetailShareCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteDetailShareCell.h"

@interface TFNoteDetailShareCell ()

/** 按钮之间间距 */
@property (nonatomic, assign) CGFloat paddingWidth;
/** 一行有几个 */
@property (nonatomic, assign) NSInteger column;
/** 图片 */
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSMutableArray *imageArr;
/** 按钮宽 */
@property (nonatomic, assign) CGFloat buttonWidth;

@end

@implementation TFNoteDetailShareCell

- (NSMutableArray *)imageArr {
    
    if (!_imageArr) {
        
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSArray *)images {
    
    if (!_images) {
        
        _images = [NSArray array];
    }
    return _images;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.paddingWidth = 8.0;
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setImage:IMG(@"新备忘录删除") forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearShares) forControlEvents:UIControlEventAllEvents];
        self.clearBtn = clearBtn;
        [self.contentView addSubview:clearBtn];
        
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.width.height.equalTo(@18);
        }];
        
    }
    return self;
}

/** 刷新cell
 *  @param model 模型
 *  @param column  一行几个
 */
- (void)refreshNoteDetailShareCellWithArray:(NSArray *)array withColumn:(NSInteger)column {
    
//    self.model = model;
    self.column = column;
    self.images = array;
    
    NSInteger num = self.images.count;
    
    self.buttonWidth = ((SCREEN_WIDTH - 20 - 63 - (self.column+1) * self.paddingWidth)/self.column);
    
    for (UIImageView *imgView in self.imageArr) {
        
        [imgView removeFromSuperview];
    }
    
    [self.imageArr removeAllObjects];
    
    for (NSInteger i = 0; i < num; i ++) {
        
        HQEmployModel *model = self.images[i];
        UIView *view = [[UIView alloc] init];
        
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.bottom.equalTo(@10);
            make.width.height.equalTo(@(self.buttonWidth));
        }];
        
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.layer.cornerRadius = self.buttonWidth/2.0;
        photoBtn.layer.masksToBounds = YES;
        photoBtn.userInteractionEnabled = YES;
        photoBtn.titleLabel.font = FONT(12);
        
        if (![model.picture isEqualToString:@""] && model.picture != nil) {
            
            [photoBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
            [photoBtn setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            
            [photoBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
            [photoBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [photoBtn setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
            [photoBtn setBackgroundColor:GreenColor];
        }
        photoBtn.tag = i;
        [photoBtn addTarget:self action:@selector(photoClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:photoBtn];
        
        [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.width.height.equalTo(@(self.buttonWidth));
            
        }];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [view insertSubview:deleteBtn aboveSubview:photoBtn];
//        [view insertSubview:deleteBtn belowSubview:photoBtn];
        deleteBtn.tag = i;
        [deleteBtn setImage:IMG(@"删除共享人") forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteSharer:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn = deleteBtn;
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.width.height.equalTo(@12);
        }];
        
        if (self.type == 1) { //详情
            
            deleteBtn.hidden = YES;
        }
        
        [self.imageArr addObject:view];
    }
}

// 点击头像
-(void)photoClicked:(UIButton *)button{
    
    HQEmployModel *model = self.images[button.tag];
    
    if ([self.delegate respondsToSelector:@selector(noteDetailDidClickedPeople:)]) {
        [self.delegate noteDetailDidClickedPeople:model];
    }
    
}

//清除
- (void)clearShares {
    
    if ([self.delegate respondsToSelector:@selector(noteDetailShareCellDidDeleteBtn:)]) {
        
        [self.delegate noteDetailShareCellDidDeleteBtn:self.index];
    }
}

//删除单个
- (void)deleteSharer:(UIButton *)button {
    
    NSInteger index = button.tag;
    if ([self.delegate respondsToSelector:@selector(noteDetailSingleSharerDidDeleteBtn:)]) {
        
        [self.delegate noteDetailSingleSharerDidDeleteBtn:index];
    }
}

/** 高度 */
+(CGFloat)refreshNoteDetailShareHeightWithArray:(TFCreateNoteModel *)model withColumn:(NSInteger)column{

    CGFloat paddingWidth = 10;// 图片之间的间距
    
    // 图片的宽度
    CGFloat buttonWidth = ((SCREEN_WIDTH - 20 - 63 - (column+1) * paddingWidth)/column);
    
    // 多少行
    NSInteger col = (model.sharers.count +column-1) / column;
//    NSInteger col = 1;
    
    CGFloat height = (buttonWidth + paddingWidth) * col + paddingWidth;
    return height;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    HQLog(@"%ld",self.contentView.subviews.count);
    
    for (NSInteger i = 0; i < self.imageArr.count; i ++) {
        
        UIView *view = self.imageArr[i];
        
        NSInteger row = i / self.column;
        NSInteger col = i % self.column;
        
        CGFloat Y = self.paddingWidth + row * (self.paddingWidth + self.buttonWidth);
        
        HQLog(@"%lf",Y);
        
        view.frame = CGRectMake(self.paddingWidth + col * (self.paddingWidth + self.buttonWidth), self.paddingWidth + row * (self.paddingWidth + self.buttonWidth), self.buttonWidth, self.buttonWidth);
    }
    
}

+ (TFNoteDetailShareCell *)NoteDetailShareCellWithTableView:(UITableView *)tableView {
    
    static NSString *indentifier = @"TFNoteDetailShareCell";
    TFNoteDetailShareCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFNoteDetailShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kUIColorFromRGB(0xF8F8F8);
    cell.layer.cornerRadius = 4.0;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
