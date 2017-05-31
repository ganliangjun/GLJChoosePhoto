//
//  GLJPhottoCell.h
//  HaoMaMa
//
//  Created by John on 15/11/19.
//  Copyright (c) 2015年 taoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLJPhotoModel.h"
@class GLJPhottoCell;

/**
 *  GLJPhottoCell协议
 */
@protocol GLJPhottoCellProtocol <NSObject>

/**
 *  选中图片方法
 *
 *  @param photoCell GLJPhottoCell
 *  @param sender    选中图片按钮
 */
-(void)photoCell:(GLJPhottoCell*)photoCell cancelPic:(UIButton*)sender;

/**
 *  取消选中图片方法
 *
 *  @param photoCell GLJPhottoCell
 *  @param sender    取消选中图片按钮
 */
-(void)photoCell:(GLJPhottoCell*)photoCell selectPic:(UIButton*)sender;


@end
/**
 *  照片cell
 */
@interface GLJPhottoCell : UICollectionViewCell

/**
 *  GLJPhottoCell代理
 */
@property (weak, nonatomic) id<GLJPhottoCellProtocol> delegate;

/**
 *  图片数据模型对象
 */
@property (strong, nonatomic) GLJPhotoModel *photoModel;


@end
