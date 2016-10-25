//
//  rootViewController.h
//  YiZhuoZaiXian
//
//  Created by Mac on 16/3/10.
//  Copyright (c) 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"

@interface rootViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;


@end
