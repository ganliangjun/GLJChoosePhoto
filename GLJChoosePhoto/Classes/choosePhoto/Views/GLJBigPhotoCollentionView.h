//
//  GLJBigPhotoCollentionView.h
//  GLJChoosePhoto
//
//  Created by JunLiang Gan on 2017/5/16.
//  Copyright © 2017年 JunLiang Gan. All rights reserved.
//

#import <UIKit/UIKit.h>

//屏幕高度
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
//屏幕宽度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
//根据八进制 获取字体颜色
#define GLJCOLORFROMRGD(valueRGD) [UIColor colorWithRed:(float)((valueRGD & 0Xff0000) >> 16)/255 green:(float)((valueRGD & 0Xff00) >> 8)/255 blue:(float)(valueRGD & 0Xff)/255 alpha:1.0]
//根据屏幕计算高度
#define GLJCalculateWithHeight(height) ((ScreenHeight) > 568 ? ScreenWidth*(height)/720.0 : (height)/2.0)
//计算字体大小
#define GLJFontWithSize(size) [UIFont systemFontOfSize:GLJCalculateWithHeight(size)]
#define photos_Inset  GLJCalculateWithHeight(8)
#define row_photo_count 4

typedef void(^GLJClickBigBlock)(CGRect rect, NSIndexPath *indexPath);

@interface GLJBigPhotoCollentionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>;

@property (nonatomic, copy) GLJClickBigBlock clickBigBlock;

@end
