//
//  GLJBigPhotoCollentionView.m
//  GLJChoosePhoto
//
//  Created by JunLiang Gan on 2017/5/16.
//  Copyright © 2017年 JunLiang Gan. All rights reserved.
//

#import "GLJBigPhotoCollentionView.h"
#import "GLJPhotoModel.h"
#import "GLJChoosePhotoManagerTool.h"

@interface GLJBigPhotoCollentionView ()

@property (strong, nonatomic) NSMutableArray *photoImageArray;
@property (strong, nonatomic) NSMutableArray *selectedImageArray;
@property (assign, nonatomic) int count;
@property (strong, nonatomic) NSMutableArray *currentSelectedImageArray;

@end

@implementation GLJBigPhotoCollentionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.photoImageArray = [GLJChoosePhotoManagerTool shareChoosePhotoManagerTool].photoImageArray;
        self.selectedImageArray = [GLJChoosePhotoManagerTool shareChoosePhotoManagerTool].selectedImageArray;
        self.currentSelectedImageArray = [_selectedImageArray mutableCopy];
        self.count = (int)_selectedImageArray.count;
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BIG_CONLLECTION"];
    }
    return self;
    
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoImageArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BIG_CONLLECTION" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    
    UIImage *image = [UIImage imageWithCGImage:[(GLJPhotoModel*)_photoImageArray[indexPath.row] alasset].aspectRatioThumbnail];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat height = ScreenWidth/image.size.width * image.size.height;
    CGRect endImageViewRect;
    if (height > ScreenHeight) {
        CGFloat width = ScreenHeight/image.size.height * image.size.width;
        endImageViewRect = CGRectMake((ScreenWidth - width)/2, 0, width, ScreenHeight);
    }else{
        endImageViewRect = CGRectMake(0, (ScreenHeight - height)/2, ScreenWidth, height);
    }
    
    imageView.frame = endImageViewRect;
    
    [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [cell addSubview:imageView];

    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth, ScreenHeight);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView * imageView;
    for (UIView *view in [collectionView cellForItemAtIndexPath:indexPath].subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            imageView = (UIImageView *)view;
        }
    }
    self.clickBigBlock(imageView.frame, indexPath);
    
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
