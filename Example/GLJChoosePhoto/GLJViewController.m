//
//  GLJViewController.m
//  GLJChoosePhoto
//
//  Created by 970721775@qq.com on 05/31/2017.
//  Copyright (c) 2017 970721775@qq.com. All rights reserved.
//

#import "GLJViewController.h"
#import "GLJChoosePhotoManagerTool.h"


@interface GLJViewController ()

@end

@implementation GLJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)jump:(UIButton *)sender {
    
    GLJChoosePhotoManagerTool *tool = [GLJChoosePhotoManagerTool shareChoosePhotoManagerTool];
    [tool showChoosePhotoVCWithVC:self WithType:GLJChoosePhotoShowType_present andBackPhotoBlock:^{
        
        
        
    }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
