//
//  GLJChoosePhotoViewController.h
//  HaoMaMa
//
//  Created by John on 15/11/19.
//  Copyright (c) 2015年 taoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLJChoosePhotoManagerTool.h"

@class GLJChoosePhotoViewController;
/**
 *  选择图片控制器
 */
@interface GLJChoosePhotoViewController : UIViewController
//最多选择相片数  不传值 默认6张
@property (assign, nonatomic) int maxSelectedPhotoCount;

@end
