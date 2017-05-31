//
//  GLJChoosePhotoManagerTool.m
//  GLJChoosePhoto
//
//  Created by JunLiang Gan on 2017/5/16.
//  Copyright © 2017年 JunLiang Gan. All rights reserved.
//

#import "GLJChoosePhotoManagerTool.h"
#import "GLJChoosePhotoViewController.h"

static GLJChoosePhotoManagerTool *sharedObj = nil;

@implementation GLJChoosePhotoManagerTool

+(instancetype)shareChoosePhotoManagerTool
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObj = [[self alloc] init];
    });
    return sharedObj;
    
}


+(id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObj = [super allocWithZone:zone];
    });
    return sharedObj;
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
    
}

-(NSMutableArray*)selectedImageArray{
    
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
    
}

-(void)setDataNil{
    
    _photoImageArray = nil;
    _selectedImageArray = nil;
    
}



-(void)searchAllPhotoWithAssets{
    
    if (!_photoImageArray) {
        _photoImageArray = [NSMutableArray array];
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        _groupArray = [NSMutableArray arrayWithCapacity:0];
        _photoImageArray = [NSMutableArray arrayWithCapacity:0];
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [_groupArray addObject:group];
                //NSLog(@"%@",group);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        
                        NSLog(@"%@", [[[result defaultRepresentation] url] description]);
                        GLJPhotoModel *photoModel = [[GLJPhotoModel alloc] init];
                        photoModel.selected = NO;
                        photoModel.alasset = result;
                        
                        [_photoImageArray addObject: photoModel];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"photo" object:nil userInfo:@{@"photo": _photoImageArray}];
                    }
                }];
            });
        } failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
        }];

    }
    
}

-(void)showChoosePhotoVCWithVC:(UIViewController *) VC WithType:(GLJChoosePhotoShowType) type andBackPhotoBlock:(GLJBackPhotoBlock) backPhotoBlock{
    
    self.backPhotoBlock = backPhotoBlock;
    self.type = type;
    [self searchAllPhotoWithAssets];
    GLJChoosePhotoViewController * photo = [[GLJChoosePhotoViewController alloc] initWithNibName:@"GLJChoosePhotoViewController" bundle:nil];
    photo.maxSelectedPhotoCount = 9;
    
    switch (self.type) {
        case GLJChoosePhotoShowType_Push:
            [VC.navigationController pushViewController:photo animated:YES];
            break;
        case GLJChoosePhotoShowType_present:
            [VC presentViewController:[[UINavigationController alloc] initWithRootViewController:photo] animated:YES completion:nil];
            break;
        default:
            break;
    }
    
}





@end
