//
//  PendingPaymentOrderDetailsViewController.h
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#pragma mark - ******** 待付款订单信息 ********

#import <UIKit/UIKit.h>


@interface PendingPaymentOrderDetailsViewController : UIViewController
@property (nonatomic,strong) NSString *order_sn;
@property (nonatomic,strong) NSString *add_time;
@property (nonatomic,strong) NSString *order_id;

@end
