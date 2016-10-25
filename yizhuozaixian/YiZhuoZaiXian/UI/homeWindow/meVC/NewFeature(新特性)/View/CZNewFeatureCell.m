//
//  CZNewFeatureCell.m
//  传智微博
//
//  Created by apple on 15-3-7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZNewFeatureCell.h"
//#import "CZTabBarController.h"
#import "UIView+Frame.h"
#import "ICSDrawerController.h"
#import "leftViewController.h"
#import "rootViewController.h"


@interface CZNewFeatureCell ()

@property (nonatomic, weak) UIImageView *imageView;



@property (nonatomic, weak) UIButton *startButton;

@end

@implementation CZNewFeatureCell



- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setTitle:@"开始购物" forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_btn_exp_n"] forState:UIControlStateNormal];
        //[startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
//        startBtn.alpha = 0.4;
        [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        _startButton = startBtn;

    }
    return _startButton;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        _imageView = imageV;
        
        // 注意:一定要加载contentView
        [self.contentView addSubview:imageV];
        
    }
    return _imageView;
}

// 布局子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    
    // 开始按钮
     self.startButton.center = CGPointMake(self.width * 0.5, self.height * 0.8);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
        //self.shareButton.hidden = NO;
        self.startButton.hidden = NO;
        
        
    }else{ // 非最后一页，隐藏分享和开始按钮
        //self.shareButton.hidden = YES;
        self.startButton.hidden = YES;
    }
}

// 点击开始的时候调用
- (void)start
{
    // 根控制器
    rootViewController * rootVC = [[rootViewController alloc] init];
    rootVC.view.backgroundColor = [UIColor whiteColor];
    
    leftViewController * leftVC = [[leftViewController alloc] init];
    
    ICSDrawerController * drawer = [[ICSDrawerController alloc] initWithLeftViewController:leftVC centerViewController:rootVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
    
}

@end
