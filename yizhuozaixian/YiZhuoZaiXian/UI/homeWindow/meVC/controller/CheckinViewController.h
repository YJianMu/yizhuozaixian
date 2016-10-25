//
//  CheckinViewController.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/17.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnTayeBlock)(BOOL);

@interface CheckinViewController : UIViewController

@property(nonatomic,copy)ReturnTayeBlock returnTayeBlock;
@property(nonatomic,assign)BOOL tayeInfrom;

@end
