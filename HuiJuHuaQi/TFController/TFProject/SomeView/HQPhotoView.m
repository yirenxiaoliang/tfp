//
//  HQPhotoView.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/10.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQPhotoView.h"
#import "HQPhotoCell.h"

@interface HQPhotoView ()<UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , HQPhotoCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) float distanceFloat;

@property (nonatomic, assign) NSInteger lineNum;

@end

@implementation HQPhotoView

+ (instancetype)photoView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQPhotoView" owner:self options:nil] firstObject];
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HQPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    
    _distanceFloat = 15;
    
    _lineNum = 3;
    
    [self.collectionView reloadData];
    
}


/**
 *  刷新视图
 *  @param photos         图片数组
 *  @param distanceFloat  图片间距
 *  @param lineNum        一行图片个数
 *
 */
- (void)refreshPhotoViewWithPhotos:(NSMutableArray *)photos
                     distanceFloat:(float)distanceFloat
                           lineNum:(NSInteger)lineNum
{
    _photos = photos;
    
    _distanceFloat = distanceFloat;
    
    _lineNum = lineNum;
    
    [self.collectionView reloadData];
}



// item数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HQPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.imageView.tag = indexPath.row + 1000;
    cell.minus.hidden = !self.type;
    cell.delegate = self;
//    if (self.isLine) {
//        [cell.imageView setImage:self.photos[indexPath.row]];
//    }else{
//        NSString *photo = self.photos[indexPath.row];
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@", BASE_FILE_URL, photo];
//        [cell.imageView sd_setImageWithURL:[HQHelper URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"picture_loading"]];
//    }
    
    id obj = self.photos[indexPath.row];
    if (obj && [obj isKindOfClass:[UIImage class]]) {
        [cell.imageView setImage:self.photos[indexPath.row]];
    }else{
        NSString *photo = self.photos[indexPath.row];
        NSString *urlStr = [NSString stringWithFormat:@"%@", photo];
        [cell.imageView sd_setImageWithURL:[HQHelper URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"picture_loading"]];
    }
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

- (void)photoCellMinusButtonClickedIndex:(NSInteger)index{
    [self.photos removeObjectAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(photoViewDeletePictureReturePicture:pictureIndex:)]) {
        [self.delegate photoViewDeletePictureReturePicture:self.photos pictureIndex:index];
    }
    
    if ([self.delegate respondsToSelector:@selector(photoViewDeletePictureReturePicture:)]) {
        [self.delegate photoViewDeletePictureReturePicture:self.photos];
    }
}
// item 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    HQLog(@"width = %f, height = %f", self.width,  self.height);
    

    return CGSizeMake((self.width - _distanceFloat*(_lineNum+1))/ _lineNum,
                      (self.width - _distanceFloat*(_lineNum+1))/ _lineNum);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, _distanceFloat, 0, _distanceFloat);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"indexPath"] = indexPath;
    dict[@"photoArray"] = self.photos;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionViewdidSelectItemAtIndexPath" object:self.collectionView userInfo:dict];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
