//
//  GLJPhotoModel.h
//  HaoMaMa
//
//  Created by John on 15/11/19.
//  Copyright (c) 2015年 taoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Photos/Photos.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface GLJPhotoModel : NSObject

@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) ALAsset *alasset;

@end
