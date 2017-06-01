//
//  GLJChoosePhotoViewController.m
//  HaoMaMa
//
//  Created by John on 15/11/19.
//  Copyright (c) 2015年 taoqi. All rights reserved.
//

#import "GLJChoosePhotoViewController.h"
#import "GLJPhottoCell.h"
#import "GLJPhotoModel.h"
#import "GLJBigPhotoCollentionView.h"


@interface GLJChoosePhotoViewController ()<GLJPhottoCellProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photoImageArray;
@property (strong, nonatomic) NSMutableArray *selectedImageArray;
@property (assign, nonatomic) int count;
@property (strong, nonatomic) NSMutableArray *currentSelectedImageArray;

@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectongView;
@property (strong, nonatomic) GLJBigPhotoCollentionView *bigPhotoCollentionView;
@property (strong, nonatomic) UIView * maskView;

@end

@implementation GLJChoosePhotoViewController

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return _maskView;
    
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
//    NSLog( @"%@", [NSBundle mainBundle].bundlePath);
//    NSLog( @"%@", [NSBundle bundleForClass:[self class]].bundlePath);
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _maxSelectedPhotoCount = 6;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相机胶卷";
    self.photoImageArray = [GLJChoosePhotoManagerTool shareChoosePhotoManagerTool].photoImageArray;
    self.selectedImageArray = [GLJChoosePhotoManagerTool shareChoosePhotoManagerTool].selectedImageArray;
    self.currentSelectedImageArray = [_selectedImageArray mutableCopy];
    self.count = (int)_selectedImageArray.count;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(complete:)];
    self.navigationItem.hidesBackButton = YES;
    
     NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"back" ofType:@"png" inDirectory:@"GLJChoosePhoto.bundle"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:path] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    [_mainCollectongView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"camera"];
    [_mainCollectongView registerClass:[GLJPhottoCell class] forCellWithReuseIdentifier:@"photoes"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPhotoModelArray:) name:@"photo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"reloadData" object:nil];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)getPhotoModelArray:(NSNotification*) notificaton{
    
    _photoImageArray = notificaton.userInfo[@"photo"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mainCollectongView reloadData];
    });
    
}

-(void)reloadData:(NSNotification*) notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mainCollectongView reloadData];
    });
    
}


#pragma mark  - 事件方法
#pragma mark back: 返回上一界面
-(void)back:(UIBarButtonItem*)sender{
   
    NSLog(@"%d, %d", (int)self.currentSelectedImageArray.count, (int)self.selectedImageArray.count);
    for (GLJPhotoModel *model in self.currentSelectedImageArray) {
        model.selected = NO;
    }
    for (GLJPhotoModel *model in self.selectedImageArray) {
        model.selected = YES;
    }
    
    switch ([GLJChoosePhotoManagerTool shareChoosePhotoManagerTool].type) {
        case GLJChoosePhotoShowType_Push:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case GLJChoosePhotoShowType_present:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
    
}

#pragma mark 完成修改信息
-(void)complete:(UIBarButtonItem*)sender{

    for (GLJPhotoModel *model in self.currentSelectedImageArray) {
        if (model.selected) {
            if (model.alasset) {
                //获取资源图片的详细资源信息
                ALAssetRepresentation* representation = [model.alasset defaultRepresentation];//获取资源图片的高清图
                model.image = [UIImage imageWithCGImage:[representation fullScreenImage]];
            }
        }
    }
    [GLJChoosePhotoManagerTool shareChoosePhotoManagerTool].selectedImageArray = self.currentSelectedImageArray;
    switch ([GLJChoosePhotoManagerTool shareChoosePhotoManagerTool].type) {
        case GLJChoosePhotoShowType_Push:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case GLJChoosePhotoShowType_present:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
    [GLJChoosePhotoManagerTool shareChoosePhotoManagerTool].backPhotoBlock();
    
}

#pragma mark 拍照
-(void)canmera:(UIGestureRecognizer*) GR{
    
    if (_count >= _maxSelectedPhotoCount) {
//#warning ................
        return;
    }
    UIImagePickerController *addImagePickerController = [[UIImagePickerController alloc] init];
    addImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    addImagePickerController.delegate = self;
    [self presentViewController:addImagePickerController animated:YES completion:nil];

}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoImageArray.count + 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        GLJPhottoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"camera" forIndexPath:indexPath];
        if ([cell viewWithTag:1000]) {
            [[cell viewWithTag:1000] removeFromSuperview];
        }
        cell.contentView.backgroundColor = GLJCOLORFROMRGD(0xd5d5d5);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = cell.contentView.bounds;
        
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"icon_paizhao" ofType:@"png" inDirectory:@"GLJChoosePhoto.bundle"];
        [button setImage:[[UIImage alloc] initWithContentsOfFile:path] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(canmera:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000;
        [cell.contentView addSubview:button];
        return cell;
    }else{
        GLJPhottoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoes" forIndexPath:indexPath];
        cell.photoModel = _photoImageArray[indexPath.row - 1];
        cell.delegate = self;
        return cell;
    }
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (ScreenWidth - photos_Inset*(row_photo_count+1) - 1)/row_photo_count;
    return CGSizeMake(width, width);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(photos_Inset, photos_Inset, photos_Inset, photos_Inset);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    CGRect rect = [self.view convertRect:[collectionView cellForItemAtIndexPath:indexPath].frame fromView:collectionView];
    UIImage *image = [UIImage imageWithCGImage:[(GLJPhotoModel*)_photoImageArray[indexPath.row - 1] alasset].aspectRatioThumbnail];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = rect;
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    
    CGFloat height = ScreenWidth/image.size.width * image.size.height;
    CGRect endImageViewRect;
    if (height > ScreenHeight) {
        CGFloat width = ScreenHeight/image.size.height * image.size.width;
        endImageViewRect = CGRectMake((ScreenWidth - width)/2, 0, width, ScreenHeight);
    }else{
        endImageViewRect = CGRectMake(0, (ScreenHeight - height)/2, ScreenWidth, height);
    }
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = endImageViewRect;
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [imageView removeFromSuperview];
        //1.初始化layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        GLJBigPhotoCollentionView *bigPhotoCollentionView = [[GLJBigPhotoCollentionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
        [[UIApplication sharedApplication].keyWindow addSubview:bigPhotoCollentionView];
        [bigPhotoCollentionView setContentOffset:CGPointMake(ScreenWidth*(indexPath.row - 1), 0) animated:NO];
        _bigPhotoCollentionView = bigPhotoCollentionView;
        __weak typeof(self) weakself = self;
        
        bigPhotoCollentionView.clickBigBlock = ^(CGRect rect, NSIndexPath *indexPath) {
            
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            CGRect endImageViewRect = [weakself.view convertRect:[collectionView cellForItemAtIndexPath:indexPath1].frame fromView:collectionView];
            UIImage *image = [UIImage imageWithCGImage:[(GLJPhotoModel*)_photoImageArray[indexPath.row] alasset].aspectRatioThumbnail];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = rect;
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.maskView];
            [[UIApplication sharedApplication].keyWindow addSubview:imageView];
            [weakself.bigPhotoCollentionView removeFromSuperview];
            
            [UIView animateWithDuration:.5 animations:^{
                
                NSLog(@"%@, %@", NSStringFromCGRect(weakself.mainCollectongView.frame), NSStringFromCGRect(endImageViewRect));
                
                if (!CGRectContainsRect(weakself.mainCollectongView.frame, endImageViewRect)||(endImageViewRect.size.width == 0 &&endImageViewRect.size.height == 0)) {
                    imageView.alpha = 0;
                    self.maskView.alpha = 0;
                }else{
                    imageView.frame = endImageViewRect;
                    self.maskView.alpha = 0;
                }
                
            } completion:^(BOOL finished) {
                [self.maskView removeFromSuperview];
                [imageView removeFromSuperview];
            }];
            
        };
        
        
        
    }];
    
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return photos_Inset;
}

// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return photos_Inset;
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _count ++;
    GLJPhotoModel *model = [[GLJPhotoModel alloc] init];
    model.image = info[UIImagePickerControllerOriginalImage];
    model.selected = YES;
    [_photoImageArray insertObject:model atIndex:0];
    [self.currentSelectedImageArray addObject:model];
    [_mainCollectongView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - GLJPhottoCellProtocol
-(void)photoCell:(GLJPhottoCell*)photoCell cancelPic:(UIButton*)sender{
    _count --;
    photoCell.photoModel.selected = NO;
    [self.currentSelectedImageArray removeObject:photoCell.photoModel];
}

-(void)photoCell:(GLJPhottoCell*)photoCell selectPic:(UIButton*)sender{
    _count++;
    if (_count > _maxSelectedPhotoCount) {
        _count --;
        sender.selected = NO;
        photoCell.photoModel.selected = NO;
//#warning ................
    }else{
        [self.currentSelectedImageArray addObject:photoCell.photoModel];
    }
}


@end
