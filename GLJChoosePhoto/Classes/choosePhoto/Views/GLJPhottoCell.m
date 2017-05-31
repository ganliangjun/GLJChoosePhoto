//
//  GLJPhottoCell.m
//  HaoMaMa
//
//  Created by John on 15/11/19.
//  Copyright (c) 2015年 taoqi. All rights reserved.
//

#import "GLJPhottoCell.h"
#import "GLJPhotoModel.h"
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


@interface GLJPhottoCell ()

@property (strong, nonatomic)  UIImageView *photoImageView;
@property (strong, nonatomic)  UIButton *selectButton;


@end

@implementation GLJPhottoCell

-(instancetype)init{
    if (self = [super init]) {
        [self initValue];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initValue];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initValue];
    }
    return self;
}

-(void)initValue{
    
    _photoImageView = [[UIImageView alloc] init];
    [self addSubview:_photoImageView];
    _selectButton = [[UIButton alloc] init];
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"icon_daixuan" ofType:@"png" inDirectory:@"GLJChoosePhoto.bundle"];
    [_selectButton setImage:[[UIImage alloc] initWithContentsOfFile:path] forState:UIControlStateNormal];
    NSString *path1 = [[NSBundle bundleForClass:[self class]] pathForResource:@"icon_xuanzhong" ofType:@"png" inDirectory:@"GLJChoosePhoto.bundle"];
    [_selectButton setImage:[[UIImage alloc] initWithContentsOfFile:path1] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(xuanZe:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectButton];
    
}

-(void)setPhotoModel:(GLJPhotoModel *)photoModel{
    
    
    _photoImageView.frame = self.bounds;
    _selectButton.frame = CGRectMake(self.bounds.size.width - GLJCalculateWithHeight(50), 0, GLJCalculateWithHeight(50), GLJCalculateWithHeight(50));
    
    _photoModel = photoModel;
    _selectButton.selected = photoModel.selected;
    if (_photoModel.image) {
        _photoImageView.image = _photoModel.image;
    }else{
        
        _photoImageView.image = [UIImage imageWithCGImage:photoModel.alasset.aspectRatioThumbnail];
        
    }
    _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _photoImageView.clipsToBounds = YES;

}


- (void)xuanZe:(UIButton *)sender {

    _photoModel.selected = _selectButton.selected = !_selectButton.selected;
    if (_selectButton.selected) {
        [self.delegate photoCell:self selectPic:sender];
    }else{
        [self.delegate photoCell:self cancelPic:sender];
    }

}





@end
