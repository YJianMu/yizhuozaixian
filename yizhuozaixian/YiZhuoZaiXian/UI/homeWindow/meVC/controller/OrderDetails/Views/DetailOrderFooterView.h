//
//  DetailOrderFooterView.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/8.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTest.h"

@interface DetailOrderFooterView : UIView
@property (nonatomic,strong) BFTest *model;
+ (instancetype)footerView;
@end
