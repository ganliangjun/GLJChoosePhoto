//
//  GLJChoosePhotoManagerTool.h
//  GLJChoosePhoto
//
//  Created by JunLiang Gan on 2017/5/16.
//  Copyright © 2017年 JunLiang Gan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLJPhotoModel.h"

typedef NS_ENUM(NSInteger, GLJChoosePhotoShowType) {
    GLJChoosePhotoShowType_Push,
    GLJChoosePhotoShowType_present
};

typedef void(^GLJBackPhotoBlock)(void);

@interface GLJChoosePhotoManagerTool : NSObject
/**
 *  所有可选择照片模型数组
 */
@property (strong, nonatomic) NSMutableArray *photoImageArray;
@property (strong, nonatomic) NSMutableArray *selectedImageArray;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *groupArray;
@property (nonatomic, copy) GLJBackPhotoBlock backPhotoBlock;
@property (nonatomic, assign) GLJChoosePhotoShowType type;

+(instancetype)shareChoosePhotoManagerTool;
-(void)setDataNil;
-(void)showChoosePhotoVCWithVC:(UIViewController *) VC WithType:(GLJChoosePhotoShowType) type andBackPhotoBlock:(GLJBackPhotoBlock) backPhotoBlock;

@end
